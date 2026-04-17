---
name: cria-prd
description: Cria PRDs para features deste projeto Rails API e salva em `tasks/prd-[slug]/prd.md`. Mantem linguagem de produto e registra escopo, objetivos, requisitos, riscos e criterios de sucesso sem entrar em implementacao tecnica.
---

# Criacao de PRD

## Objetivo

Gerar um PRD claro e objetivo para evolucoes do produto, mantendo foco em problema, valor e resultado esperado.

## Quando usar

Use quando o pedido for criar ou revisar PRD de feature, melhoria ou iniciativa.
Nao use para tech spec, tasks, implementacao, QA ou code review.

## Procedimento

1. Confirmar nome da feature e gerar slug em `kebab-case`.
2. Levantar contexto minimo:
   - problema a resolver
   - publico afetado
   - resultado esperado
   - restricoes e riscos
3. Ler `assets/prd-template.md`.
4. Escrever PRD com foco em WHAT/WHY:
   - contexto
   - objetivos e metricas
   - requisitos funcionais numerados
   - fora de escopo
   - dependencias
   - criterios de sucesso
5. Salvar em `tasks/prd-[slug]/prd.md`.

## Regras

- PRD nao detalha como implementar no Rails
- endpoint, migration e estrutura de codigo ficam para tech spec
- se houver ambiguidade bloqueante, perguntar de forma direta

## Saida

- caminho do arquivo criado
- resumo curto do escopo
- lista dos requisitos funcionais principais
