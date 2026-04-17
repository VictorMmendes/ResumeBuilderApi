# Code Quality Checklist (Rails API)

| Aspect | Verification |
|--------|-------------|
| MVC boundaries | Controller sem regra de negocio pesada; dominio em model/service |
| Routing | Rotas claras e consistentes com contratos da API |
| Params safety | Strong params aplicados corretamente |
| Validations | Model validations cobrem regras essenciais |
| Error handling | Status HTTP e mensagens de erro consistentes |
| Security | Sem riscos obvios de injection, auth bypass ou dados sensiveis expostos |
| Tests | Cobertura relevante em `test/controllers` e `test/models` |
| Migrations | Migration segura, reversivel e sem quebrar ambiente |
