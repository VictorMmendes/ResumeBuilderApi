---
name: find-skills
description: Ajuda a identificar a skill certa para tarefas neste projeto Rails API, priorizando as skills locais em `.agents/skills` antes de qualquer opcao externa.
---

# Find Skills

## Objetivo

Selecionar a skill mais adequada para a tarefa atual sem assumir stack errada.

## Mapeamento rapido

- `find-rules`: descobrir regras reais do repositorio antes de implementar/revisar.
- `cria-prd`: criar PRD de feature.
- `cria-techspec`: transformar PRD em especificacao tecnica.
- `criar-tasks`: quebrar PRD + tech spec em tasks executaveis.
- `executar-task`: implementar task documentada.
- `executar-bugfix`: corrigir bug com foco em causa raiz.
- `executar-review`: revisar diff/branch com foco em riscos.
- `executar-qa`: validar entrega de API por contrato e regressao.
- `skill-writer`: criar/ajustar skills locais.
- `skill-best-practices`: validar qualidade estrutural de skill.

## Regra principal

- priorizar sempre skill local
- se houver sobreposicao, escolher a skill de escopo mais especifico
- so sugerir opcao externa quando nao houver skill local adequada

## Fora da stack

- nao sugerir Vue, React, Next.js, Hono, Cloudflare ou Vercel como padrao deste repo
