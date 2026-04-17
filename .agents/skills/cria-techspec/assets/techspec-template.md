# Tech Spec - [Nome da Feature]

## Resumo tecnico

[Resumo da abordagem proposta.]

## Arquitetura alvo

### Camadas afetadas

- `config/routes.rb`
- `app/controllers/[..._controller].rb`
- `app/models/[...].rb`
- `app/services/[...].rb` (se aplicavel)
- `db/migrate/[timestamp]_...rb` (se aplicavel)

### Responsabilidades

- [Controller: responsabilidade]
- [Model/Service: responsabilidade]

## Contratos de API

| Metodo | Rota | Descricao | Sucesso | Erros esperados |
|--------|------|-----------|---------|-----------------|
| GET/POST/etc | `/...` | [descricao] | [status + payload] | [status + payload] |

## Dados e persistencia

- entidades impactadas: [lista]
- validacoes novas/alteradas: [lista]
- migration necessaria: [sim/nao + descricao]

## Integracoes externas

- [Servico/API externa]
- [Autenticacao]
- [Fallback/timeout/retry]

## Estrategia de testes

- testes de controller: [casos]
- testes de model/service: [casos]
- dados de fixture necessarios: [lista]

## Validacao tecnica

- `bin/rubocop`
- `bin/brakeman --quiet --no-pager --exit-on-warn --exit-on-error`
- `bin/rails test`

## Riscos e trade-offs

- [Risco + mitigacao]
- [Decisao + alternativa descartada]

## Arquivos previstos

- [arquivo novo/alterado]
- [arquivo novo/alterado]
