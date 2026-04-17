# Tech Spec - Reestruturacao do Dominio de Curriculo para Modelo LinkedIn

## Resumo tecnico

Esta entrega substitui o dominio atual de curriculo, hoje baseado em colecoes planas, por um agregado `Resume` alinhado ao modelo LinkedIn definido no PRD. A API passara a expor `headline`, contato estruturado, `top_skills`, `certifications`, experiencias agrupadas por empresa com cargos e bullets, e educacao no formato novo. Nao havera compatibilidade retroativa com o contrato atual.

A implementacao deve evitar acoplamento do controller com regras de agregacao. Para isso, o `GET /resumes/:id` e o `GET /resumes/:id/export` devem usar um servico dedicado para montar um hash ordenado e consistente para JSON e PDF. A migracao de dados sera feita em fases para permitir backfill do que for reaproveitavel antes da remocao do legado.

## Arquitetura alvo

### Camadas afetadas

- `config/routes.rb`
- `app/controllers/resumes_controller.rb`
- `app/controllers/educations_controller.rb`
- `app/controllers/experience_groups_controller.rb`
- `app/controllers/experience_positions_controller.rb`
- `app/controllers/experience_position_bullets_controller.rb`
- `app/controllers/top_skills_controller.rb`
- `app/controllers/certifications_controller.rb`
- `app/models/resume.rb`
- `app/models/education.rb`
- `app/models/experience_group.rb`
- `app/models/experience_position.rb`
- `app/models/experience_position_bullet.rb`
- `app/models/top_skill.rb`
- `app/models/certification.rb`
- `app/services/resume_payload_builder.rb`
- `app/services/pdf_generator_service.rb`
- `app/views/resumes/show.html.erb`
- `db/migrate/[timestamp]_add_linkedin_profile_fields_to_resumes.rb`
- `db/migrate/[timestamp]_create_experience_groups.rb`
- `db/migrate/[timestamp]_create_experience_positions.rb`
- `db/migrate/[timestamp]_create_experience_position_bullets.rb`
- `db/migrate/[timestamp]_create_top_skills.rb`
- `db/migrate/[timestamp]_create_certifications.rb`
- `db/migrate/[timestamp]_reshape_educations_for_linkedin_profile.rb`
- `db/migrate/[timestamp]_backfill_linkedin_profile_domain.rb`
- `db/migrate/[timestamp]_drop_legacy_resume_domain_structures.rb`
- `db/seeds.rb`
- `test/controllers/**`
- `test/models/**`
- `test/fixtures/**`

### Responsabilidades

- `ResumesController`: manter `index`, `show`, `create`, `update`, `destroy`, `export` e `avatar`, mas passar a renderizar o agregado novo em `show` e `export`.
- `ResumePayloadBuilder`: concentrar ordenacao, agrupamento e composicao do payload publico do resume, evitando duplicacao entre JSON e PDF.
- `Resume`: manter o agregado raiz, relacoes com as novas entidades e helpers pequenos como `avatar_url`.
- `ExperienceGroup`: representar empresa dentro do resume e ordenar grupos por `display_order`.
- `ExperiencePosition`: representar cargo dentro de uma empresa, com datas, flag `current` e `summary`.
- `ExperiencePositionBullet`: representar bullets independentes de cada cargo.
- `TopSkill` e `Certification`: representar listas simples e ordenadas do dominio principal.
- `Education`: refletir a estrutura nova com `degree_name`, `field_of_study` e `display_order`.
- Controllers dos recursos filhos: expor CRUD REST, validar ownership pelo parent e devolver JSON simples do recurso persistido.
- `db/seeds.rb`: recriar o curriculo de referencia do Victor no novo formato e remover carga de entidades legadas.

## Decisoes tecnicas principais

- O contrato agregado do resume sera montado por `ResumePayloadBuilder`, nao por `render json: @resume, include: ...`.
- O builder sera usado tanto no `show` quanto no `export`, para reduzir divergencia entre API e PDF.
- A API adotara rotas aninhadas com `shallow: true` para os novos recursos filhos, preservando ownership explicito sem URLs excessivamente profundas para `show`, `update` e `destroy`.
- A migracao sera feita em tres etapas logicas: criacao estrutural, backfill best-effort dos dados reaproveitaveis, e remocao do legado.
- O backfill sera conservador: campos sem correspondencia semantica clara nao serao inferidos automaticamente.

## Contratos de API

### Rotas

```ruby
resources :resumes do
  get :export, on: :member
  post :avatar, on: :member

  resources :educations, shallow: true
  resources :top_skills, shallow: true
  resources :certifications, shallow: true
  resources :experience_groups, shallow: true do
    resources :experience_positions, shallow: true do
      resources :experience_position_bullets, shallow: true
    end
  end
end

resources :users
```

Rotas removidas:

- `resources :experiences`
- `resources :skills`
- `resources :softwares`
- `resources :languages`

### Tabela de contratos

| Metodo | Rota | Descricao | Sucesso | Erros esperados |
|--------|------|-----------|---------|-----------------|
| GET | `/resumes` | Lista resumes. Mantem filtro por `email` quando presente. | `200` com colecao de resumes sem payload profundamente agregado. | `500` em erro interno. |
| GET | `/resumes/:id` | Retorna o agregado LinkedIn completo. | `200` com payload contendo `headline`, `contact`, `avatar_url`, `top_skills`, `certifications`, `experience_groups` e `educations`. | `404` se resume nao existir. |
| POST | `/resumes` | Cria resume com os campos novos de cabecalho/contato. | `201` com recurso criado. | `422` em validacao. |
| PATCH/PUT | `/resumes/:id` | Atualiza campos do cabecalho/contato do resume. | `200` com recurso atualizado. | `404`, `422`. |
| GET | `/resumes/:id/export` | Gera PDF usando o mesmo agregado do show. | `200` com `application/pdf`. | `404`, `500` em falha de renderizacao/Grover. |
| POST | `/resumes/:id/avatar` | Mantem upload de avatar via Active Storage. | `200` com `avatar_url`. | `400` sem arquivo, `404` se resume nao existir. |
| GET/POST | `/resumes/:resume_id/experience_groups` | Lista/cria grupos de experiencia ligados ao resume. | `200`/`201` com grupo. | `404` para parent inexistente, `422` em validacao. |
| GET/PATCH/DELETE | `/experience_groups/:id` | Consulta, atualiza ou remove grupo de experiencia. | `200`/`204`. | `404`, `422`. |
| GET/POST | `/experience_groups/:experience_group_id/experience_positions` | Lista/cria cargos de um grupo. | `200`/`201` com posicao. | `404`, `422`. |
| GET/PATCH/DELETE | `/experience_positions/:id` | Consulta, atualiza ou remove cargo. | `200`/`204`. | `404`, `422`. |
| GET/POST | `/experience_positions/:experience_position_id/experience_position_bullets` | Lista/cria bullets de um cargo. | `200`/`201` com bullet. | `404`, `422`. |
| GET/PATCH/DELETE | `/experience_position_bullets/:id` | Consulta, atualiza ou remove bullet. | `200`/`204`. | `404`, `422`. |
| GET/POST | `/resumes/:resume_id/top_skills` | Lista/cria top skills do resume. | `200`/`201` com top skill. | `404`, `422`. |
| GET/PATCH/DELETE | `/top_skills/:id` | Consulta, atualiza ou remove top skill. | `200`/`204`. | `404`, `422`. |
| GET/POST | `/resumes/:resume_id/certifications` | Lista/cria certifications do resume. | `200`/`201` com certification. | `404`, `422`. |
| GET/PATCH/DELETE | `/certifications/:id` | Consulta, atualiza ou remove certification. | `200`/`204`. | `404`, `422`. |
| GET/POST | `/resumes/:resume_id/educations` | Lista/cria educacoes no formato novo. | `200`/`201` com education. | `404`, `422`. |
| GET/PATCH/DELETE | `/educations/:id` | Consulta, atualiza ou remove education. | `200`/`204`. | `404`, `422`. |

### Payload alvo de `GET /resumes/:id`

O payload final deve seguir o formato do PRD. Campos derivados:

- `contact`: agrupamento logico de campos persistidos em `resumes`.
- `avatar_url`: derivado de Active Storage.
- `experience_groups[].positions`: ordenados por `display_order`.
- `positions[].bullets`: ordenados por `display_order`.
- ordenacao padrao de `top_skills`, `certifications` e `educations`: `display_order ASC`.

Exemplo resumido:

```json
{
  "id": 1,
  "full_name": "Victor Mendes Martins",
  "headline": "...",
  "summary": "...",
  "contact": {
    "street_address": "...",
    "city": "Paranagua",
    "region": "Parana",
    "country": "Brazil",
    "phone": "...",
    "email": "...",
    "linkedin_url": "...",
    "github_url": "...",
    "portfolio_label": "Portfolio"
  },
  "avatar_url": "...",
  "top_skills": [],
  "certifications": [],
  "experience_groups": [],
  "educations": []
}
```

## Dados e persistencia

### Entidades impactadas

- alteradas: `Resume`, `Education`
- novas: `ExperienceGroup`, `ExperiencePosition`, `ExperiencePositionBullet`, `TopSkill`, `Certification`
- removidas do dominio principal: `Experience`, `Skill`, `Software`, `Language`, `TechnicalSkill`, `Project`, `Hobby`

### Alteracoes em `resumes`

Adicionar colunas:

- `headline :string`
- `street_address :string`
- `city :string`
- `region :string`
- `country :string`
- `portfolio_label :string`

Remover colunas:

- `title`
- `job_title`
- `address`
- `website_url`
- `old_experiences_summary`

Campos mantidos:

- `user_id`
- `full_name`
- `summary`
- `email`
- `phone`
- `linkedin_url`
- `github_url`
- `avatar` via Active Storage

### Alteracoes em `educations`

Adicionar/ajustar colunas:

- `degree_name :string`
- `field_of_study :string`
- `display_order :integer, null: false`

Remover colunas:

- `degree`
- `location`

Campos mantidos:

- `institution`
- `start_date`
- `end_date`
- `current`
- `resume_id`

### Novas tabelas

`experience_groups`

- `resume_id :references, null: false, foreign_key: true`
- `company_name :string, null: false`
- `location :string`
- `display_order :integer, null: false`
- timestamps

`experience_positions`

- `experience_group_id :references, null: false, foreign_key: true`
- `title :string, null: false`
- `start_date :date, null: false`
- `end_date :date`
- `current :boolean, null: false, default: false`
- `summary :text`
- `display_order :integer, null: false`
- timestamps

`experience_position_bullets`

- `experience_position_id :references, null: false, foreign_key: true`
- `content :text, null: false`
- `display_order :integer, null: false`
- timestamps

`top_skills`

- `resume_id :references, null: false, foreign_key: true`
- `name :string, null: false`
- `display_order :integer, null: false`
- timestamps

`certifications`

- `resume_id :references, null: false, foreign_key: true`
- `name :string, null: false`
- `display_order :integer, null: false`
- timestamps

### Indices e constraints

- indice unico em `experience_groups(resume_id, display_order)`
- indice unico em `experience_positions(experience_group_id, display_order)`
- indice unico em `experience_position_bullets(experience_position_id, display_order)`
- indice unico em `top_skills(resume_id, display_order)`
- indice unico em `certifications(resume_id, display_order)`
- indice unico em `educations(resume_id, display_order)`

### Validacoes novas/alteradas

- `Resume`: `belongs_to :user`; `full_name` obrigatorio; validacao de URL para `linkedin_url` e `github_url` quando presentes.
- `ExperienceGroup`: `company_name` e `display_order` obrigatorios.
- `ExperiencePosition`: `title`, `start_date` e `display_order` obrigatorios; `end_date` deve ser maior ou igual a `start_date` quando presente; `current` e `end_date` nao devem coexistir de forma inconsistente.
- `ExperiencePositionBullet`: `content` e `display_order` obrigatorios.
- `TopSkill` e `Certification`: `name` e `display_order` obrigatorios.
- `Education`: `institution` e `display_order` obrigatorios; `end_date` deve ser maior ou igual a `start_date` quando presente.

### Estrategia de migracao

1. Criar estrutura nova sem remover o legado.
2. Executar backfill best-effort:
   - `resumes.job_title -> resumes.headline`
   - `resumes.address -> resumes.street_address`
   - `skills -> top_skills`, preservando `name` e gerando `display_order` deterministico por ordem atual
   - `experiences -> experience_groups + experience_positions + bullets`, criando um grupo por empresa antiga e uma posicao por registro antigo; `description` sera dividida por quebra de linha para bullets, mantendo `summary` igual ao texto completo apenas quando necessario
   - `educations.degree -> educations.degree_name`
   - `educations.field_of_study` permanecera nulo nos dados legados sem correspondencia semantica confiavel
3. Atualizar seeds para o formato final e validar o novo payload.
4. Remover tabelas e colunas legadas somente apos o backfill e a atualizacao das fixtures/testes.

## Regras de negocio e responsabilidades por camada

### Controller

- Controllers devem continuar usando `params.expect(...)` no padrao do projeto.
- Controllers filhos devem carregar o parent no `create` e `index`, e o proprio recurso em `show`, `update` e `destroy`.
- `ResumesController#show` deve fazer eager loading das associacoes novas para evitar N+1:
  - `experience_groups: { experience_positions: :experience_position_bullets }`
  - `top_skills`
  - `certifications`
  - `educations`
- `ResumesController#index` pode seguir retornando o recurso base sem o payload agregado profundo para manter custo previsivel de listagem.

### Service

- `ResumePayloadBuilder` recebe um `resume` preloaded e devolve um hash imutavel pronto para `render json:`.
- O builder e responsavel por:
  - montar `contact`
  - ordenar colecoes por `display_order`
  - serializar experiencias aninhadas
  - omitir chaves legadas
  - incluir `avatar_url`
- `ResumesController#export` deve passar o payload agregado para a view, evitando recomposicao manual no template.

### Model

- `Resume` passa a declarar apenas associacoes aderentes ao novo dominio.
- `ExperienceGroup`, `ExperiencePosition` e `ExperiencePositionBullet` devem usar `dependent: :destroy` em cascata.
- `Education`, `TopSkill` e `Certification` devem pertencer a `Resume`.
- Escopos de ordenacao simples podem ser adicionados por modelo (`ordered`) para reduzir duplicacao no builder.

### View/PDF

- `app/views/resumes/show.html.erb` deve deixar de acessar `job_title`, `address`, `skills`, `softwares`, `languages`, `technical_skills`, `projects`, `hobbies` e `old_experiences_summary`.
- A view deve refletir:
  - cabecalho com `full_name` e `headline`
  - bloco de contato estruturado
  - summary
  - top skills
  - certifications
  - experiencias agrupadas por empresa e cargos
  - educacao no formato novo
- O template PDF deve permanecer resiliente a listas vazias.

## Integracoes externas

- `Active Storage`: permanece para `avatar`, sem mudanca de contrato.
- `Grover`: permanece na exportacao PDF; o risco principal e quebra do template ao trocar a estrutura consumida.
- Nao ha autenticacao ou integracao externa nova nesta feature.

## Seguranca e consistencia

- Strong params devem refletir apenas campos do novo dominio, sem aceitar atributos legados.
- Foreign keys e `dependent: :destroy` devem impedir orfaos entre grupos, cargos e bullets.
- Validacoes de URL devem evitar persistencia de links invalidos em `linkedin_url` e `github_url`.
- O builder nao deve vazar campos internos ou estruturas legadas no JSON publico.

## Estrategia de testes

- testes de controller:
  - `ResumesControllerTest`: validar `show` com payload agregado novo, `create/update` com campos de `headline` e contato estruturado, `index` com filtro por email, `export` respondendo PDF e `avatar` mantendo upload
  - `ExperienceGroupsControllerTest`: CRUD basico e ordenacao por `display_order`
  - `ExperiencePositionsControllerTest`: CRUD basico, parent ownership e validacao de datas
  - `ExperiencePositionBulletsControllerTest`: CRUD basico e ordenacao
  - `TopSkillsControllerTest` e `CertificationsControllerTest`: CRUD basico e `display_order`
  - `EducationsControllerTest`: payload novo sem `degree/location` legados
- testes de model:
  - validacoes de presenca e ordem
  - destruicao em cascata de grupos -> posicoes -> bullets
  - validacoes de coerencia de datas
- testes de service:
  - `ResumePayloadBuilderTest` cobrindo formato final, omissao de campos legados, agrupamento e ordenacao
- dados de fixture necessarios:
  - novos fixtures para `experience_groups`, `experience_positions`, `experience_position_bullets`, `top_skills`, `certifications`
  - atualizacao de `resumes.yml` e `educations.yml`
  - remocao de fixtures de `experiences`, `skills`, `softwares`, `languages`, `technical_skills`, `projects`, `hobbies`
- seeds:
  - teste de carga de seeds garantindo que o curriculo do Victor e criado com top skills, certifications, educations ordenadas e pelo menos um grupo com multiplas posicoes quando aplicavel
- export PDF:
  - teste de request do endpoint `export` e validacao minima de resposta binaria

## Validacao tecnica

- `bin/rubocop`
- `bin/brakeman --quiet --no-pager --exit-on-warn --exit-on-error`
- `bin/rails test`

## Riscos e trade-offs

- Remover o legado no mesmo ciclo simplifica o dominio, mas quebra consumidores existentes. Isso e aceito pelo PRD.
- Introduzir `ResumePayloadBuilder` adiciona uma camada nova, mas evita espalhar serializacao manual em controller, model e view.
- Backfill parcial preserva parte dos dados atuais, mas nao tenta inferir semanticamente `field_of_study` ou decompor localizacao antiga, o que reduz risco de dados incorretos.
- Rotas aninhadas com `shallow: true` aumentam quantidade de declaracoes em `routes.rb`, mas deixam ownership explicito e melhoram a semantica do contrato.
- Manter `index` sem payload profundo evita custo de listagem, mas cria uma diferenca intencional entre listagem e detalhe.

## Arquivos previstos

- `config/routes.rb`
- `app/controllers/resumes_controller.rb`
- `app/controllers/educations_controller.rb`
- `app/controllers/experience_groups_controller.rb`
- `app/controllers/experience_positions_controller.rb`
- `app/controllers/experience_position_bullets_controller.rb`
- `app/controllers/top_skills_controller.rb`
- `app/controllers/certifications_controller.rb`
- `app/models/resume.rb`
- `app/models/education.rb`
- `app/models/experience_group.rb`
- `app/models/experience_position.rb`
- `app/models/experience_position_bullet.rb`
- `app/models/top_skill.rb`
- `app/models/certification.rb`
- `app/services/resume_payload_builder.rb`
- `app/views/resumes/show.html.erb`
- `db/migrate/[timestamp]_add_linkedin_profile_fields_to_resumes.rb`
- `db/migrate/[timestamp]_create_experience_groups.rb`
- `db/migrate/[timestamp]_create_experience_positions.rb`
- `db/migrate/[timestamp]_create_experience_position_bullets.rb`
- `db/migrate/[timestamp]_create_top_skills.rb`
- `db/migrate/[timestamp]_create_certifications.rb`
- `db/migrate/[timestamp]_reshape_educations_for_linkedin_profile.rb`
- `db/migrate/[timestamp]_backfill_linkedin_profile_domain.rb`
- `db/migrate/[timestamp]_drop_legacy_resume_domain_structures.rb`
- `db/seeds.rb`
- `test/controllers/resumes_controller_test.rb`
- `test/controllers/educations_controller_test.rb`
- `test/controllers/experience_groups_controller_test.rb`
- `test/controllers/experience_positions_controller_test.rb`
- `test/controllers/experience_position_bullets_controller_test.rb`
- `test/controllers/top_skills_controller_test.rb`
- `test/controllers/certifications_controller_test.rb`
- `test/models/resume_test.rb`
- `test/models/education_test.rb`
- `test/models/experience_group_test.rb`
- `test/models/experience_position_test.rb`
- `test/models/experience_position_bullet_test.rb`
- `test/models/top_skill_test.rb`
- `test/models/certification_test.rb`
- `test/services/resume_payload_builder_test.rb`
- `test/fixtures/resumes.yml`
- `test/fixtures/educations.yml`
- `test/fixtures/experience_groups.yml`
- `test/fixtures/experience_positions.yml`
- `test/fixtures/experience_position_bullets.yml`
- `test/fixtures/top_skills.yml`
- `test/fixtures/certifications.yml`
