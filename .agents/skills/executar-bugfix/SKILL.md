---
name: executar-bugfix
description: Corrige bugs documentados em `tasks/prd-[slug]/bugs.md` com foco em causa raiz no Rails API. Prioriza correcao com testes Minitest e validacao com rubocop, brakeman e rails test.
---

# Execucao de Bugfix

## Objetivo

Corrigir a causa raiz do defeito sem criar regressao e sem desorganizar a arquitetura Rails.

## Procedimento

1. Ler `bugs.md` e, quando existir, `prd.md` e `techspec.md`.
2. Reproduzir o bug localmente (request/model test ou chamada HTTP).
3. Localizar a origem real:
   - regra de negocio (`app/models` ou `app/services`)
   - fluxo HTTP (`app/controllers` ou `config/routes.rb`)
   - dado inconsistente (`db/migrate`, validacoes, callbacks)
4. Criar ou ajustar teste que falha antes da correcao.
5. Implementar a correcao no ponto certo, com patch minimo e claro.
6. Confirmar que o teste novo passa e que nao houve regressao.
7. Executar validacao:
   - `bin/rubocop`
   - `bin/brakeman --quiet --no-pager --exit-on-warn --exit-on-error`
   - `bin/rails test`

## Criterios de decisao

- se o bug e de regra de negocio, corrigir no dominio e nao no controller
- se o bug e de contrato da API, alinhar status code, payload e testes de controller
- se a correcao exigir evolucao de banco, usar migration
- se nao der para reproduzir de forma automatizada, registrar claramente a lacuna

## Relatorio esperado

- bug corrigido
- causa raiz
- arquivos alterados
- testes criados/atualizados
- validacoes executadas
