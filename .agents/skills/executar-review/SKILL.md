---
name: executar-review
description: Faz code review de mudancas deste projeto Rails API com foco em bugs, regressao, arquitetura MVC, seguranca e cobertura de testes. Use para revisar branch, diff ou entrega antes de merge.
---

# Execucao de Review

## Objetivo

Revisar mudancas com foco principal em risco funcional e tecnico: bugs, regressoes, falhas de seguranca e quebra de padrao Rails.

## Quando usar

Use para revisar:

- branch ou diff antes de merge
- implementacao de task
- bugfix que altera regras de dominio ou contratos de API

Nao use para implementar codigo nem para QA manual de fluxo completo.

## Procedimento

1. Ler contexto da entrega (`prd.md`, `techspec.md`, `tasks.md`), quando existir.
2. Inspecionar `git status` e `git diff` com foco no que realmente muda.
3. Revisar por risco:
   - comportamento de endpoint (status, payload, tratamento de erro)
   - regra de negocio em model/service
   - alteracoes de migration/schema
   - seguranca (mass assignment, validacoes, authn/authz, SQL injection)
   - cobertura e qualidade de testes em `test/**`
4. Rodar validacoes quando necessario:
   - `bin/rubocop`
   - `bin/brakeman --quiet --no-pager --exit-on-warn --exit-on-error`
   - `bin/rails test`

## Criterios de review

### Arquitetura

- controller permanece enxuto e sem regra de negocio densa
- dominio fica em model/service
- rota, controller e testes mantem contrato consistente

### Dados e integridade

- migrations sao reversiveis e seguras
- alteracoes em dados sensiveis possuem validacao adequada
- nao ha manipulacao perigosa de parametros sem whitelist

### Testes

- mudanca relevante possui teste cobrindo sucesso e erro
- bugfix inclui teste de regressao quando possivel
- suite nao ignora falhas introduzidas pelo diff

## Formato de saida

- findings primeiro, ordenados por severidade
- cada finding com arquivo, impacto e recomendacao
- depois perguntas abertas (se houver)
- resumo final curto
