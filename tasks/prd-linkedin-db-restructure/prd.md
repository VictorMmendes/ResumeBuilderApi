# PRD - Reestruturacao do Dominio de Curriculo para Modelo LinkedIn

## Contexto

Hoje o produto usa `resume` como agregado principal com secoes planas para experiencias, educacoes, skills, idiomas, softwares, projetos e hobbies. Esse modelo nao representa corretamente o curriculo de referencia baseado no LinkedIn usado pelo produto, especialmente em pontos como cabecalho estruturado, experiencia agrupada por empresa com multiplos cargos, top skills e certifications. Como resultado, o contrato da API exige transformacoes extras no consumidor e mantem entidades que nao fazem parte do curriculo alvo.

Essa inconsistencia afeta principalmente a evolucao do backend, a confiabilidade do payload retornado para o frontend e a manutencao dos dados seed usados como referencia do perfil principal.

## Objetivo

Alinhar o dominio de curriculo ao formato de perfil inspirado no LinkedIn, substituindo o contrato atual por um payload agregado que represente cabecalho, contato estruturado, experiencia agrupada por empresa, top skills, certifications e educacao no formato esperado pelo consumidor.

## Metricas de sucesso

- `GET /resumes/:id` retornar o novo payload agregado sem exigir transformacao adicional no consumidor.
- O curriculo seed principal refletir integralmente o perfil de referencia com experiencia agrupada, certifications e top skills.
- As entidades que deixaram de fazer parte do modelo principal nao aparecerem mais no contrato publico da API.

## Escopo funcional

1. O produto deve redefinir o cabecalho de `resume` para refletir nome, headline, summary, avatar e contato estruturado com endereco detalhado, localizacao e links principais.
2. O produto deve representar experiencia profissional agrupada por empresa, permitindo multiplos cargos ordenados dentro da mesma empresa e bullets independentes por cargo.
3. O produto deve expor `top_skills` como lista ordenada sem nivel de proficiencia e `certifications` como lista ordenada separada.
4. O produto deve ajustar educacao para separar nome do grau e area de estudo, mantendo ordenacao e periodo academico.
5. O produto deve remover do modelo principal e do contrato publico as secoes que nao fazem parte do curriculo alvo, incluindo idiomas, softwares, technical skills, projetos, hobbies e resumos antigos de experiencia.
6. O produto deve disponibilizar operacoes da API coerentes com as novas entidades mantidas no dominio e deixar de expor recursos descontinuados.
7. O produto deve publicar dados iniciais coerentes com o perfil de referencia para permitir validacao e uso imediato do novo contrato.

## Fluxos principais

- Consumidor consulta `GET /resumes/:id` e recebe um payload completo com cabecalho, contato, avatar, top skills, certifications, experiencia agrupada por empresa e educacao ordenada.
- Usuario ou sistema atualiza informacoes de um resume usando os novos recursos do dominio, incluindo empresas, cargos, bullets, top skills, certifications e educacao.
- Ambiente local ou pipeline carrega seeds e passa a contar com um curriculo de referencia consistente com o modelo LinkedIn.

## Regras de negocio (alto nivel)

- O dominio continua centrado em `resumes`, permitindo multiplos curriculos por usuario.
- A nova estrutura pode quebrar o contrato anterior; nao ha requisito de compatibilidade retroativa.
- O bloco de contato deve ser estruturado o suficiente para renderizacao direta do frontend, sem concatenacoes ou mapeamentos externos.
- Experiencias devem ser organizadas por empresa, com ordenacao explicita de empresas, cargos e bullets.
- A duracao total por empresa e um dado derivado para apresentacao, nao um dado autoritativo de entrada.
- Quando a origem informar apenas mes e ano, a data oficial armazenada continua sendo o primeiro dia do mes correspondente.
- Avatar continua suportado como parte do resume, mesmo nao sendo o elemento central do modelo semantico.

## Dependencias e restricoes

- O novo contrato deve permanecer adequado para uma API-only Rails consumida por frontend externo.
- O curriculo de referencia em `.artefacts/Profile.pdf` e o plano em `.artefacts/linkedin-db-restructure-plan.md` orientam a aderencia do escopo funcional.
- A mudanca depende de revisao completa do payload publico para evitar sobras de campos e recursos legados.
- O produto deve preservar suporte a multiplos resumes por usuario durante a migracao do dominio.

## Fora de escopo

- Qualquer camada de compatibilidade entre payload antigo e payload novo.
- Definicao de endpoints, migrations, serializers internos ou detalhes de implementacao Rails.
- Mudancas de frontend, layout de interface ou experiencia visual fora do contrato JSON.
- Inclusao de novas secoes que nao estao presentes no curriculo de referencia do modelo LinkedIn.

## Riscos

- Quebra imediata para consumidores que ainda dependam do contrato antigo.
- Inconsistencias entre seeds, payload agregado e dados reais se a migracao nao eliminar completamente entidades legadas.
- Perda de clareza de exibicao se ordenacao e agrupamento nao forem tratados como parte obrigatoria do contrato.
- Escopo crescer indevidamente ao tentar acomodar secoes historicas que o novo modelo explicitamente remove.
