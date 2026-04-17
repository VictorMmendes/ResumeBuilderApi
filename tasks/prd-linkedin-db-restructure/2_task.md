# Task 2 - Implementar o Payload Agregado de Resume e Adaptar o PDF

## Objetivo

Substituir o `render json` direto do ActiveRecord por um payload agregado coerente com o modelo LinkedIn e garantir que a exportacao PDF consuma a mesma estrutura.

## Escopo

- criar `ResumePayloadBuilder` para montar `contact`, `avatar_url`, `top_skills`, `certifications`, `experience_groups` e `educations`
- atualizar `ResumesController#show` para usar eager loading e renderizar o builder
- atualizar `ResumesController#create` e `#update` para aceitar apenas campos do novo cabecalho/contato
- preservar `index`, `avatar` e `export`, mas alinhando `export` ao payload agregado
- adaptar `app/views/resumes/show.html.erb` para o novo dominio e remover referencias a secoes legadas
- garantir que o PDF funcione com listas vazias e com experiencias agrupadas por empresa/cargo

## Arquivos provaveis

- `app/controllers/resumes_controller.rb`
- `app/models/resume.rb`
- `app/services/resume_payload_builder.rb`
- `app/services/pdf_generator_service.rb`
- `app/views/resumes/show.html.erb`
- `test/controllers/resumes_controller_test.rb`
- `test/services/resume_payload_builder_test.rb`
- `test/fixtures/resumes.yml`
- `test/fixtures/educations.yml`
- `test/fixtures/experience_groups.yml`
- `test/fixtures/experience_positions.yml`
- `test/fixtures/experience_position_bullets.yml`
- `test/fixtures/top_skills.yml`
- `test/fixtures/certifications.yml`

## Criterios de aceite

- `GET /resumes/:id` retorna o payload agregado definido no PRD
- `contact` e `avatar_url` sao entregues no formato correto
- `experience_groups`, `positions` e `bullets` saem ordenados por `display_order`
- `ResumesController` nao aceita mais `title`, `job_title`, `address`, `website_url` e `old_experiences_summary`
- `GET /resumes/:id/export` continua funcional usando a mesma fonte de dados do `show`
- a view do PDF nao acessa mais `skills`, `softwares`, `languages`, `technical_skills`, `projects`, `hobbies` ou `old_experiences_summary`

## Testes esperados

- teste de request para `GET /resumes/:id` validando `headline`, `contact`, `top_skills`, `certifications`, `experience_groups` e `educations`
- teste de ordenacao por `display_order` no payload agregado
- teste de `create/update` aceitando apenas campos novos de resume
- teste do builder cobrindo agrupamento, serializacao e omissao de campos legados
- teste do endpoint `export` validando resposta PDF minima

## Validacao minima

- `bin/rubocop`
- `bin/brakeman --quiet --no-pager --exit-on-warn --exit-on-error`
- `bin/rails test`
