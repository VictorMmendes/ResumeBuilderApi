---
name: executar-task
description: Implementa tasks documentadas neste projeto Rails API com foco em controllers, models, services, migrations e testes Minitest. Usa rubocop, brakeman e rails test como validacao base.
---

# Execucao de Task

## Objetivo

Executar uma task documentada em `tasks/prd-[slug]/[n]_task.md` sem desalinhar a arquitetura Rails do repositorio.

## Procedimento

1. Ler `tasks/prd-[slug]/[n]_task.md`, `prd.md` e `techspec.md`.
2. Levantar regras locais com `find-rules` antes de implementar.
3. Mapear area afetada:
   - `app/controllers`
   - `app/models`
   - `app/services` (quando houver regra de negocio complexa)
   - `config/routes.rb`
   - `db/migrate` e `db/schema.rb`
   - `test/**`
4. Implementar com separacao clara de responsabilidades:
   - controller para HTTP/orquestracao
   - model/service para regra de negocio
   - serializer/render JSON consistente com o padrao existente
5. Se houver alteracao de dados, criar migration em `db/migrate` e validar impacto no schema.
6. Criar/atualizar testes Minitest relacionados em `test/controllers` e `test/models`.
7. Executar validacoes minimas:
   - `bin/rubocop`
   - `bin/brakeman --quiet --no-pager --exit-on-warn --exit-on-error`
   - `bin/rails test`
8. Atualizar `tasks.md` somente depois de codigo + testes + validacoes concluirem.

## Guardrails

- nao assumir stack de frontend para implementar task de API
- nao mover regra de negocio critica para controller
- nao editar `db/schema.rb` manualmente
- nao pular testes ao alterar comportamento de endpoint ou modelo
- nao considerar task concluida sem validacao local minima
