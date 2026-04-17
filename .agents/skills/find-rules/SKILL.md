---
name: find-rules
description: Descobre e consolida as regras reais deste projeto Rails API antes de implementar, revisar ou corrigir codigo. Prioriza Ruby 3.4, Rails 8.1, Minitest e os padroes de app/controllers, app/models, db/migrate e config/routes.rb.
---

# Find Rules

Use esta skill para mapear as regras vigentes do repositorio antes de codar.

## Quando usar

Use antes de:

- implementar feature
- corrigir bug
- revisar diff ou PR
- desenhar endpoint, modelo ou servico
- decidir estrategia de testes e validacao

## Fontes prioritarias

Leia nesta ordem:

1. `Gemfile`
2. `.ruby-version`
3. `config/application.rb`
4. `config/routes.rb`
5. `app/controllers/**`, `app/models/**`, `app/services/**`
6. `db/schema.rb` e migrations em `db/migrate/**`
7. testes existentes em `test/**`
8. scripts de qualidade em `bin/ci`, `bin/rubocop`, `bin/brakeman`, `bin/rails`

## Heuristicas obrigatorias

### Stack

- assumir Ruby `3.4.7` e Rails `8.1.x`
- tratar o projeto como API (`config.api_only = true`)
- nao sugerir stack de frontend como React, Vue, Next.js ou Tailwind para codigo deste repo

### Arquitetura

- endpoints ficam em `app/controllers`
- regras de dominio e validacoes ficam em `app/models` e, quando necessario, `app/services`
- manter controllers enxutos: orquestracao HTTP, sem regra de negocio pesada
- reutilizar padroes ja existentes antes de criar novo fluxo paralelo

### Dados e migrations

- evoluir banco com migration em `db/migrate`
- nunca editar `db/schema.rb` manualmente
- manter compatibilidade com `db:prepare` e ambiente de teste

### Testes

- priorizar Minitest em `test/controllers` e `test/models`
- para bugfix, reproduzir o bug em teste antes da correcao sempre que possivel
- cobrir cenarios de sucesso, validacao e erro HTTP relevante

### Validacao minima

- `bin/rubocop`
- `bin/brakeman --quiet --no-pager --exit-on-warn --exit-on-error`
- `bin/rails test`
- usar `bin/ci` quando quiser validar o pacote completo de checks

## O que registrar na resposta

Sempre devolver:

- regra encontrada
- fonte consultada
- se a regra e critica, obrigatoria ou recomendada
- impacto da regra na tarefa atual

## Guardrails

- nao usar exemplos de outros frameworks como referencia principal
- em conflito, o padrao local do repositorio vence
- nao transformar desvio legado em regra oficial
