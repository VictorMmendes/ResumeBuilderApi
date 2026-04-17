# Tasks - Reestruturacao do Dominio de Curriculo para Modelo LinkedIn

## Checklist macro

- [x] Task 1: criar a nova estrutura de persistencia e os modelos do dominio LinkedIn
- [x] Task 2: implementar o payload agregado de `Resume` e adaptar o PDF ao novo contrato
- [x] Task 3: expor os CRUDs dos novos recursos e remover as rotas legadas da API publica
- [x] Task 4: concluir migracao de dados, seeds, fixtures e limpeza do legado

## Ordem recomendada

1. Executar Task 1 para estabelecer schema, associacoes e regras de negocio.
2. Executar Task 2 para fechar o contrato principal de `GET /resumes/:id` e `GET /resumes/:id/export`.
3. Executar Task 3 para disponibilizar os novos endpoints operacionais do dominio.
4. Executar Task 4 para consolidar backfill, seeds, fixtures, remocao do legado e regressao final.

## Dependencias entre tasks

- Task 2 depende da estrutura criada na Task 1.
- Task 3 depende das entidades e validacoes criadas na Task 1.
- Task 4 depende das Tasks 1, 2 e 3 para fechar schema, dados e suite de testes.

## Validacao minima por task

- `bin/rubocop`
- `bin/brakeman --quiet --no-pager --exit-on-warn --exit-on-error`
- `bin/rails test`
