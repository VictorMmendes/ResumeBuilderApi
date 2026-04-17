# Task 3 - Expor os CRUDs dos Novos Recursos e Remover Rotas Legadas

## Objetivo

Disponibilizar os endpoints REST do novo dominio LinkedIn com ownership via parent resource e retirar da API publica os recursos que nao pertencem mais ao modelo principal.

## Escopo

- atualizar `config/routes.rb` para usar rotas aninhadas com `shallow: true`
- criar controllers para `experience_groups`, `experience_positions`, `experience_position_bullets`, `top_skills` e `certifications`
- atualizar `EducationsController` para o contrato novo
- ajustar `params.expect(...)` e callbacks de parent/resource nos novos controllers
- remover rotas e controllers CRUD de `experiences`, `skills`, `softwares` e `languages`

## Arquivos provaveis

- `config/routes.rb`
- `app/controllers/educations_controller.rb`
- `app/controllers/experience_groups_controller.rb`
- `app/controllers/experience_positions_controller.rb`
- `app/controllers/experience_position_bullets_controller.rb`
- `app/controllers/top_skills_controller.rb`
- `app/controllers/certifications_controller.rb`
- `app/controllers/experiences_controller.rb`
- `app/controllers/skills_controller.rb`
- `app/controllers/softwares_controller.rb`
- `app/controllers/languages_controller.rb`
- `test/controllers/educations_controller_test.rb`
- `test/controllers/experience_groups_controller_test.rb`
- `test/controllers/experience_positions_controller_test.rb`
- `test/controllers/experience_position_bullets_controller_test.rb`
- `test/controllers/top_skills_controller_test.rb`
- `test/controllers/certifications_controller_test.rb`
- `test/controllers/experiences_controller_test.rb`
- `test/controllers/skills_controller_test.rb`
- `test/controllers/softwares_controller_test.rb`
- `test/controllers/languages_controller_test.rb`

## Criterios de aceite

- as rotas novas existem com nesting coerente para `create/index` e `shallow` para `show/update/destroy`
- os novos controllers retornam `200`, `201`, `204`, `404` e `422` conforme esperado
- `EducationsController` usa apenas `institution`, `degree_name`, `field_of_study`, `start_date`, `end_date`, `current` e `display_order`
- as rotas legadas de `experiences`, `skills`, `softwares` e `languages` deixam de existir
- controllers legados removidos ou desativados deixam de fazer parte da superficie publica da API

## Testes esperados

- testes de CRUD para cada novo recurso
- testes de `404` para parent inexistente
- testes de `422` para dados invalidos
- testes cobrindo ordenacao por `display_order` nos recursos listaveis
- ajuste ou remocao dos testes dos controllers legados para refletir o novo contrato

## Validacao minima

- `bin/rubocop`
- `bin/brakeman --quiet --no-pager --exit-on-warn --exit-on-error`
- `bin/rails test`
