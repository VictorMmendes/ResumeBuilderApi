# Task 4 - Concluir Migracao de Dados, Seeds, Fixtures e Limpeza do Legado

## Objetivo

Finalizar a troca de dominio no banco e na base de teste, migrando os dados reaproveitaveis, recriando o curriculo de referencia no formato novo e removendo estruturas legadas restantes.

## Escopo

- implementar migration de backfill do dominio LinkedIn com reaproveitamento conservador dos dados antigos
- atualizar `db/seeds.rb` para gerar apenas o curriculo no formato novo
- revisar fixtures para refletir exclusivamente o novo dominio
- remover models, fixtures e artefatos de teste do dominio legado que nao devem mais existir
- criar migration final para remover tabelas e colunas antigas apos o backfill
- validar que schema, seeds e payload final estao consistentes

## Arquivos provaveis

- `db/migrate/[timestamp]_backfill_linkedin_profile_domain.rb`
- `db/migrate/[timestamp]_drop_legacy_resume_domain_structures.rb`
- `db/seeds.rb`
- `db/schema.rb`
- `app/models/experience.rb`
- `app/models/skill.rb`
- `app/models/software.rb`
- `app/models/language.rb`
- `app/models/technical_skill.rb`
- `app/models/project.rb`
- `app/models/hobby.rb`
- `test/fixtures/resumes.yml`
- `test/fixtures/educations.yml`
- `test/fixtures/experience_groups.yml`
- `test/fixtures/experience_positions.yml`
- `test/fixtures/experience_position_bullets.yml`
- `test/fixtures/top_skills.yml`
- `test/fixtures/certifications.yml`
- `test/fixtures/experiences.yml`
- `test/fixtures/skills.yml`
- `test/fixtures/softwares.yml`
- `test/fixtures/languages.yml`
- `test/fixtures/technical_skills.yml`
- `test/fixtures/projects.yml`
- `test/fixtures/hobbies.yml`

## Criterios de aceite

- o backfill cria `headline`, `street_address`, `top_skills` e estrutura agrupada de experiencias a partir do legado quando houver dados
- `field_of_study` nao e inferido artificialmente quando nao houver origem confiavel
- `db/seeds.rb` cria o curriculo principal do Victor inteiramente no formato novo
- tabelas e colunas legadas deixam de existir no schema final
- fixtures antigas sao removidas ou substituidas por fixtures do novo dominio
- a suite de testes nao depende mais de `Experience`, `Skill`, `Software`, `Language`, `TechnicalSkill`, `Project` ou `Hobby`

## Testes esperados

- teste de seeds garantindo top skills, certifications, educations e grupos de experiencia no curriculo principal
- teste do payload agregado com dados oriundos das fixtures novas
- regressao completa de controllers, models e service sem referencias ao legado
- validacao de que o schema final nao contem tabelas e colunas removidas pelo PRD

## Validacao minima

- `bin/rubocop`
- `bin/brakeman --quiet --no-pager --exit-on-warn --exit-on-error`
- `bin/rails test`
