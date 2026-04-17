---
name: criar-tasks
description: Converte `prd.md` e `techspec.md` em tarefas incrementais para este projeto Rails API. Salva em `tasks/prd-[slug]/tasks.md` e `[n]_task.md`, com foco em entrega testavel e validacao tecnica.
---

# Criacao de Tasks

## Objetivo

Quebrar PRD + tech spec em tasks pequenas, sequenciais e executaveis.

## Procedimento

1. Ler `tasks/prd-[slug]/prd.md`.
2. Ler `tasks/prd-[slug]/techspec.md`.
3. Separar a entrega por blocos:
   - rotas e controllers
   - modelos/regras de negocio
   - migrations e dados
   - testes
   - validacao final
4. Criar `tasks/prd-[slug]/tasks.md` com checklist macro.
5. Criar arquivos `tasks/prd-[slug]/[n]_task.md` com escopo objetivo.

## Regras

- cada task precisa ser concluivel de forma independente
- cada task precisa explicitar arquivos provaveis e criterio de aceite
- toda task tecnica deve incluir teste esperado
- toda task de implementacao deve incluir validacao minima:
  - `bin/rubocop`
  - `bin/brakeman --quiet --no-pager --exit-on-warn --exit-on-error`
  - `bin/rails test`

## Evitar

- tasks grandes e vagas ("fazer API completa")
- task sem criterio de aceite
- task sem estrategia de validacao
