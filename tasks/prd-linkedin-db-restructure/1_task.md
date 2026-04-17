# Task 1 - Criar a Estrutura de Persistencia e Modelos do Dominio LinkedIn

## Objetivo

Introduzir o schema novo do curriculo LinkedIn e atualizar os modelos centrais para suportar `headline`, contato estruturado, experiencia agrupada, `top_skills`, `certifications` e educacao com ordenacao.

## Escopo

- adicionar colunas novas em `resumes`
- remodelar `educations` para `degree_name`, `field_of_study` e `display_order`
- criar tabelas `experience_groups`, `experience_positions`, `experience_position_bullets`, `top_skills` e `certifications`
- atualizar `Resume` para remover associacoes do dominio legado e declarar apenas as associacoes novas
- criar os novos models com `dependent: :destroy`, escopos de ordenacao e validacoes essenciais
- adicionar validacoes de coerencia de datas e validacoes basicas de URL

## Arquivos provaveis

- `app/models/resume.rb`
- `app/models/education.rb`
- `app/models/experience_group.rb`
- `app/models/experience_position.rb`
- `app/models/experience_position_bullet.rb`
- `app/models/top_skill.rb`
- `app/models/certification.rb`
- `db/migrate/[timestamp]_add_linkedin_profile_fields_to_resumes.rb`
- `db/migrate/[timestamp]_create_experience_groups.rb`
- `db/migrate/[timestamp]_create_experience_positions.rb`
- `db/migrate/[timestamp]_create_experience_position_bullets.rb`
- `db/migrate/[timestamp]_create_top_skills.rb`
- `db/migrate/[timestamp]_create_certifications.rb`
- `db/migrate/[timestamp]_reshape_educations_for_linkedin_profile.rb`
- `db/schema.rb`
- `test/models/resume_test.rb`
- `test/models/education_test.rb`
- `test/models/experience_group_test.rb`
- `test/models/experience_position_test.rb`
- `test/models/experience_position_bullet_test.rb`
- `test/models/top_skill_test.rb`
- `test/models/certification_test.rb`

## Criterios de aceite

- o banco passa a ter todas as colunas e tabelas previstas na tech spec com foreign keys e indices de ordenacao
- `Resume` nao declara mais associacoes para `skills`, `softwares`, `languages`, `technical_skills`, `projects` e `hobbies`
- os novos models existem e possuem validacoes minimas de presenca, ordem e datas
- `Education` usa apenas a estrutura nova e deixa de depender de `degree` e `location`
- a suite de model tests cobre associacoes, ordenacao e validacoes principais

## Testes esperados

- testes de model para presenca de `company_name`, `title`, `content`, `name` e `display_order`
- testes de coerencia de datas para `Education` e `ExperiencePosition`
- teste de destruicao em cascata de grupo -> posicoes -> bullets
- teste de validacao de URL em `Resume` para `linkedin_url` e `github_url`

## Validacao minima

- `bin/rubocop`
- `bin/brakeman --quiet --no-pager --exit-on-warn --exit-on-error`
- `bin/rails test`
