# Relatorio de QA - [Feature]

## Resumo

- Data: [yyyy-mm-dd]
- Status: APROVADO / REPROVADO
- Endpoints validados: [X]
- Bugs encontrados: [Y]

## Contratos validados

| Endpoint | Cenario | Resultado | Evidencia |
|----------|---------|-----------|-----------|
| `GET /...` | sucesso | PASSOU/FALHOU | [teste/chamada] |
| `POST /...` | erro 422 | PASSOU/FALHOU | [teste/chamada] |

## Regressao

- [Fluxo regressivo validado]
- [Fluxo regressivo validado]

## Bugs encontrados

| ID | Descricao | Severidade | Reproducao |
|----|-----------|------------|------------|
| BUG-01 | [descricao] | Alta/Media/Baixa | [passos] |

## Validacao automatizada

- `bin/rails test`: [ok/falhou]
- `bin/rubocop`: [ok/falhou]
- `bin/brakeman --quiet --no-pager --exit-on-warn --exit-on-error`: [ok/falhou]

## Conclusao

[Parecer final do QA.]
