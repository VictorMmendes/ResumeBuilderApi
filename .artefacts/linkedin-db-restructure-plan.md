# Reestruturar o Domínio de Currículo para o Modelo LinkedIn

## Summary
O projeto atual é uma API Rails com `resume` como agregado principal e coleções planas (`experiences`, `educations`, `skills`, `languages`, `softwares`, `technical_skills`, `projects`, `hobbies`). O PDF `.artefacts/Profile.pdf` expõe outra estrutura: contato, headline, localização, summary, top skills, certifications, experiência agrupada por empresa com múltiplos cargos, e educação.

A implementação deve quebrar o contrato atual e alinhar o backend ao currículo do LinkedIn. O app continuará suportando múltiplos `resumes` por usuário, com avatar preservado, mas o modelo principal deixará de carregar seções que não existem no PDF.

## Key Changes
### 1. Redesenhar o agregado `Resume`
Manter `resumes` como raiz, mas ajustar seus campos para o cabeçalho do perfil:
- Manter: `user_id`, `full_name`, `summary`, `email`, `phone`, `linkedin_url`, `github_url`, `avatar`
- Remover do core: `title`, `job_title`, `address`, `website_url`, `old_experiences_summary`
- Adicionar:
  - `headline` para o texto principal do perfil
  - `street_address` para o endereço detalhado do bloco de contato
  - `city`
  - `region`
  - `country`
  - `portfolio_label` opcional para exibir algo como `Portfolio` no link do GitHub
- O payload principal do frontend deve sair de `job_title/address` genéricos e passar a ler `headline` + localização estruturada

### 2. Substituir experiências planas por experiência agrupada
A estrutura atual de `experiences` não representa o caso do PDF em que uma empresa possui mais de um cargo. Implementar:
- `experience_groups`
  - `resume_id`
  - `company_name`
  - `location`
  - `display_order`
- `experience_positions`
  - `experience_group_id`
  - `title`
  - `start_date`
  - `end_date`
  - `current`
  - `summary`
  - `display_order`
- `experience_position_bullets`
  - `experience_position_id`
  - `content`
  - `display_order`

Com isso:
- `PUZL Place` vira um grupo
- cada cargo dentro da empresa vira uma posição
- cada bullet do cargo vira um registro próprio
- duração total por empresa deve ser derivada no serializer, não persistida

### 3. Reestruturar skills e certifications
O PDF não usa `skills` por nível, nem `technical_skills`, `softwares` ou `languages` como parte do layout principal. Implementar:
- Renomear semanticamente `skills` para `top_skills`
  - tabela nova ou reaproveitamento com migração completa
  - campos: `resume_id`, `name`, `display_order`
  - sem `level`
- Criar `certifications`
  - `resume_id`
  - `name`
  - `display_order`

Remover do modelo principal:
- `softwares`
- `technical_skills`
- `projects`
- `hobbies`
- `languages`
- `old_experiences_summary`

### 4. Ajustar educação ao formato do PDF
A tabela `educations` está próxima do necessário, mas `degree` hoje concentra informação demais. Ajustar para:
- `institution`
- `degree_name`
- `field_of_study`
- `start_date`
- `end_date`
- `current`
- `display_order`

Remover:
- `location`

O frontend deve renderizar algo no formato:
`Associate Degree in Systems Analysis and Development, Computer Technology/Computer Systems Technology`

### 5. Atualizar seeds, models e API
Atualizar todo o backend para a nova estrutura:
- models/associações do `Resume`
- strong params dos controllers
- `ResumesController#show` deve retornar o agregado novo
- remover controllers CRUD das entidades descontinuadas
- adicionar CRUDs para `experience_groups`, `experience_positions`, `experience_position_bullets`, `top_skills`, `certifications`
- atualizar `db/seeds.rb` com os dados do PDF:
  - contato do Victor
  - headline
  - summary
  - top skills
  - certifications
  - experiência agrupada por empresa e cargos
  - educação
- o repo é API-only; não há frontend neste código. O contrato JSON precisa sair pronto para um frontend moderno consumir sem transformação adicional

## Public API / Payload Shape
O `GET /resumes/:id` deve passar a expor um payload agregado com esta forma:

```json
{
  "id": 1,
  "full_name": "Victor Mendes Martins",
  "headline": "Fullstack Engineer (Backend-Focused) | Kotlin (Ktor) & Spring Boot | Vue.js, TypeScript, Laravel | AI-Assisted Development",
  "summary": "...",
  "contact": {
    "street_address": "...",
    "city": "Paranaguá",
    "region": "Paraná",
    "country": "Brazil",
    "phone": "41991959007",
    "email": "Victormmendes.vm@icloud.com",
    "linkedin_url": "...",
    "github_url": "...",
    "portfolio_label": "Portfolio"
  },
  "avatar_url": "...",
  "top_skills": [
    { "name": "Artificial Intelligence (AI)", "display_order": 1 }
  ],
  "certifications": [
    { "name": "Aplicações completas e escaláveis com Node.js", "display_order": 1 }
  ],
  "experience_groups": [
    {
      "company_name": "PUZL Place",
      "location": "Belo Horizonte, MG",
      "display_order": 1,
      "positions": [
        {
          "title": "Fullstack Software Engineer (Backend-Focused) | Vue.js, TypeScript & Laravel",
          "start_date": "2025-09-01",
          "end_date": null,
          "current": true,
          "summary": "Working as...",
          "display_order": 1,
          "bullets": [
            { "content": "Development of scalable web applications...", "display_order": 1 }
          ]
        }
      ]
    }
  ],
  "educations": [
    {
      "institution": "Pontifícia Universidade Católica do Paraná",
      "degree_name": "postgraduate",
      "field_of_study": "Software Engineering, DevOps & Digital Transformation",
      "start_date": "2025-04-01",
      "end_date": "2026-11-01",
      "current": false,
      "display_order": 1
    }
  ]
}
```

## Test Plan
- Atualizar fixtures para o novo domínio e remover fixtures das entidades descontinuadas
- Ajustar testes de controllers para os novos recursos e payloads
- Adicionar teste de `GET /resumes/:id` validando:
  - `headline`
  - `contact`
  - agrupamento de experiências por empresa
  - ordenação por `display_order`
  - bullets por cargo
  - top skills e certifications
- Adicionar teste de seed/load garantindo que o currículo do Victor é criado com:
  - 1 ou mais grupos de experiência
  - múltiplas posições sob a mesma empresa quando aplicável
  - certificação separada
  - top skills sem `level`
- Validar que o export PDF continua funcional após trocar o template para consumir o novo payload

## Assumptions
- A migração pode quebrar a API atual; não haverá camada de compatibilidade
- O domínio continuará centrado em `resumes`, não em `users.profile`
- Contato principal ficará em colunas fixas do `resume`
- `avatar` continua existindo, mas fora do núcleo semântico do LinkedIn
- Datas continuarão como `date`, usando o primeiro dia do mês quando o LinkedIn só informar mês/ano
- Idiomas, hobbies, softwares, technical skills, projects e resumo de experiências antigas deixam de fazer parte do modelo principal
