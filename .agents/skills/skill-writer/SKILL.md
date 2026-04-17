---
name: skill-writer
description: Cria, revisa e padroniza skills locais em `.agents/skills` para este repositorio Rails API, com foco em escopo, frontmatter e gatilhos reais de uso.
---

# Skill Writer

Esta skill orienta a criacao e manutencao de skills locais do projeto.

## Quando usar

- criar uma nova skill em `.agents/skills/<skill-name>/`
- atualizar `SKILL.md` existente
- corrigir frontmatter, descricao e gatilhos
- auditar skills inconsistentes com a stack atual

## Escopo obrigatorio

- uma skill cobre uma capacidade principal
- evitar skill generica de "ajuda com tudo"
- se a skill for tecnica deste repo, refletir Ruby on Rails API:
  - `app/controllers`
  - `app/models`
  - `app/services`
  - `config/routes.rb`
  - `db/migrate`
  - `test`

## Frontmatter obrigatorio

```yaml
---
name: skill-name
description: O que a skill faz e quando usar
---
```

Regras:

- `name` em minusculo com hifens
- `name` deve bater com a pasta
- `description` objetiva e orientada a uso
- nao usar `.claude/skills` neste repositorio

## Fluxo de escrita

1. definir capacidade principal
2. confirmar se ja existe skill equivalente
3. escrever `description` com gatilho positivo e negativo
4. estruturar corpo com passos acionaveis
5. validar se os caminhos citados existem no repo
6. revisar para remover stack incorreta

## Guardrails

- nao citar ferramentas inexistentes
- nao assumir Vue/React/Next.js/Hono para este projeto
- nao mencionar paths legados que nao existem
- nao usar linguagem vaga

