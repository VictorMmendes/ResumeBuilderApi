---
name: executar-qa
description: Executa QA de features deste projeto Rails API com foco em contrato HTTP, validacoes de negocio, persistencia de dados e regressao. Usa rails test, rubocop e brakeman como base de validacao.
---

# Execucao de QA

Use esta skill para validar entrega de feature ou bugfix pelo ponto de vista funcional e tecnico da API.

## Quando usar

Use quando houver:

- endpoint novo ou alterado
- mudanca de regra de dominio em model/service
- alteracao de migration/dados
- risco de regressao em contratos de resposta

Nao use para implementar codigo ou fazer code review completo.

## Procedimento

1. Ler contexto da entrega (`prd.md`, `techspec.md`, `tasks.md`) quando existir.
2. Listar endpoints e regras impactadas.
3. Validar cenarios chave:
   - sucesso (status 2xx esperado)
   - entrada invalida (status 4xx e mensagens)
   - erro interno controlado (quando aplicavel)
4. Verificar persistencia e integridade de dados apos a chamada.
5. Confirmar cobertura de testes em `test/controllers` e `test/models`.
6. Rodar:
   - `bin/rails test`
   - `bin/rubocop`
   - `bin/brakeman --quiet --no-pager --exit-on-warn --exit-on-error`

## Checklist de QA

- contrato HTTP consistente com a especificacao
- payload de resposta estavel e sem campos quebrados
- validacoes de negocio aplicadas corretamente
- sem regressao evidente em fluxos ja existentes
- testes automatizados cobrindo casos criticos

## Classificacao de achados

- `critica`: quebra funcional ou de contrato de API
- `major`: comportamento incorreto sem bloqueio total
- `minor`: inconsistencias de acabamento, mensagem ou cobertura

## Saida esperada

- achados ordenados por severidade
- evidencia objetiva (endpoint/teste/arquivo)
- recomendacao direta de correcao
- riscos residuais, se houver
