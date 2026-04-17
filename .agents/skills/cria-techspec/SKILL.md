---
name: cria-techspec
description: Cria especificacao tecnica para features deste projeto Rails API a partir de um PRD existente. Traduz requisitos de produto para arquitetura executavel com controllers, models, services, migrations e testes.
---

# Criacao de Tech Spec

## Objetivo

Transformar o PRD em um plano tecnico acionavel, sem implementar codigo.

## Fluxo

1. Identificar slug e localizar `tasks/prd-[slug]/prd.md`.
2. Ler o PRD por completo.
3. Mapear contexto tecnico do repositorio:
   - `config/routes.rb`
   - `app/controllers/**`
   - `app/models/**`
   - `app/services/**` (quando houver)
   - `db/migrate/**` e `db/schema.rb`
   - `test/**`
4. Ler `assets/techspec-template.md`.
5. Escrever `tasks/prd-[slug]/techspec.md`.

## Conteudo obrigatorio

- escopo tecnico da solucao
- endpoints e contratos HTTP
- alteracoes de dados (models/migrations)
- regras de negocio e responsabilidades por camada
- riscos e trade-offs
- estrategia de testes
- plano de validacao (`bin/rubocop`, `bin/brakeman`, `bin/rails test`)

## Regras

- nao escrever PRD nem tasks dentro da tech spec
- nao detalhar codigo linha a linha
- explicitar decisoes tecnicas e impacto no sistema atual
- registrar dependencias externas e requisitos de seguranca quando existirem
