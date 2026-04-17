#!/bin/bash
set -euo pipefail

# =============================================================================
# run-tasks.sh — Executa todas as tasks de uma pasta PRD via Codex CLI
# Uso: ./run-tasks.sh tasks/prd-fazer-tal-coisa [opções]
# =============================================================================

# Cores
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Defaults
SKIP_COMPLETED=true
STOP_ON_ERROR=true
MAX_TURNS=50
DANGEROUS_MODE=true
CODEX_MODEL=""
PRD_DIR=""
SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$SCRIPT_DIR"
FOOTER_SUPPORTED=false
FOOTER_ENABLED=false
SPINNER_INDEX=0
CURRENT_TASK_LABEL="Preparando"
RESOLVED_MODEL=""
SPINNER_FRAMES=('|' '/' '-' '\')

# Contadores
TOTAL=0
EXECUTED=0
SKIPPED=0
FAILED=0

usage() {
  cat <<EOF
Uso: ./run-tasks.sh <pasta-prd> [opções]

Executa todas as tasks de uma pasta PRD sequencialmente via Codex CLI.

Argumentos:
  <pasta-prd>                    Caminho da pasta PRD (ex: tasks/prd-fazer-tal-coisa)

Opções:
  --no-skip-completed            Executa mesmo tasks já marcadas como [x]
  --no-stop-on-error             Continua execução mesmo se uma task falhar
  --max-turns <N>                Hint de budget para o agente Codex (default: 50)
  --model <MODEL>                Força o modelo usado no Codex CLI
  --dangerously-bypass-approvals-and-sandbox
                                 Executa o Codex sem sandbox/aprovações (default)
  --sandboxed                    Força execução com sandbox/aprovações do modo full-auto
  -h, --help                     Mostra esta mensagem

Exemplos:
  ./run-tasks.sh tasks/prd-fazer-tal-coisa
  ./run-tasks.sh tasks/prd-fazer-tal-coisa --no-skip-completed --max-turns 80
  ./run-tasks.sh tasks/prd-fazer-tal-coisa --model gpt-5.4
  ./run-tasks.sh tasks/prd-fazer-tal-coisa --dangerously-bypass-approvals-and-sandbox
  ./run-tasks.sh tasks/prd-fazer-tal-coisa --sandboxed
EOF
  exit 0
}

print_line() {
  local format="$1"
  local message="${2-}"

  if [[ "$FOOTER_SUPPORTED" == true && "$FOOTER_ENABLED" == true ]]; then
    printf '\r\033[2K'
  fi

  if [[ "$format" == "__BLANK__" ]]; then
    printf '\n'
  else
    printf "${format}\n" "$message"
  fi

  if [[ "$FOOTER_SUPPORTED" == true && "$FOOTER_ENABLED" == true ]]; then
    render_footer
  fi
}

print_blank_line() { print_line "__BLANK__"; }
log_info()    { print_line '%b' "${BLUE}[INFO]${NC} $1"; }
log_success() { print_line '%b' "${GREEN}[OK]${NC} $1"; }
log_warn()    { print_line '%b' "${YELLOW}[SKIP]${NC} $1"; }
log_error()   { print_line '%b' "${RED}[ERRO]${NC} $1"; }

detect_codex_model() {
  local config_file="${CODEX_CONFIG_FILE:-$HOME/.codex/config.toml}"

  if [[ -n "$CODEX_MODEL" ]]; then
    printf '%s' "$CODEX_MODEL"
    return 0
  fi

  if [[ ! -f "$config_file" ]]; then
    return 1
  fi

  awk -F'=' '
    /^[[:space:]]*model[[:space:]]*=/ {
      value=$2
      gsub(/^[[:space:]]+|[[:space:]]+$/, "", value)
      gsub(/^"|"$/, "", value)
      print value
      exit
    }
  ' "$config_file"
}

footer_text() {
  local spinner="${SPINNER_FRAMES[$SPINNER_INDEX]}"
  printf '%b' "${BLUE}[RUN]${NC} ${spinner} Processo em execucao | Modelo: ${RESOLVED_MODEL} | Tarefa: ${CURRENT_TASK_LABEL}"
}

render_footer() {
  if [[ "$FOOTER_SUPPORTED" != true || "$FOOTER_ENABLED" != true ]]; then
    return
  fi

  printf '\r\033[2K%b' "$(footer_text)"
}

start_footer() {
  if [[ "$FOOTER_SUPPORTED" != true ]]; then
    return
  fi

  FOOTER_ENABLED=true
  render_footer
}

stop_footer() {
  if [[ "$FOOTER_SUPPORTED" != true || "$FOOTER_ENABLED" != true ]]; then
    return
  fi

  FOOTER_ENABLED=false
  printf '\r\033[2K'
}

advance_footer() {
  if [[ "$FOOTER_SUPPORTED" != true || "$FOOTER_ENABLED" != true ]]; then
    return
  fi

  SPINNER_INDEX=$(((SPINNER_INDEX + 1) % ${#SPINNER_FRAMES[@]}))
  render_footer
}

cleanup_footer() {
  stop_footer
}

run_codex_command() {
  # Executa o Codex conectado diretamente ao terminal para preservar
  # o comportamento normal da CLI e o exit code real do processo.
  printf '%s\n' "$PROMPT" | "${CODEX_CMD[@]}"
}

trap cleanup_footer EXIT

# --- Parse de argumentos ---
while [[ $# -gt 0 ]]; do
  case "$1" in
    --no-skip-completed)
      SKIP_COMPLETED=false
      shift
      ;;
    --no-stop-on-error)
      STOP_ON_ERROR=false
      shift
      ;;
    --max-turns)
      MAX_TURNS="$2"
      shift 2
      ;;
    --model)
      CODEX_MODEL="$2"
      shift 2
      ;;
    --dangerously-bypass-approvals-and-sandbox|--dangerously-skip-permissions)
      DANGEROUS_MODE=true
      shift
      ;;
    --sandboxed)
      DANGEROUS_MODE=false
      shift
      ;;
    -h|--help)
      usage
      ;;
    -*)
      log_error "Flag desconhecida: $1"
      usage
      ;;
    *)
      if [[ -z "$PRD_DIR" ]]; then
        PRD_DIR="$1"
      else
        log_error "Argumento extra inesperado: $1"
        usage
      fi
      shift
      ;;
  esac
done

# --- Validação ---
if [[ -z "$PRD_DIR" ]]; then
  log_error "Pasta PRD não informada."
  usage
fi

PRD_DIR="${PRD_DIR%/}"

if [[ "$PRD_DIR" != /* ]]; then
  PRD_DIR="$REPO_ROOT/$PRD_DIR"
fi

PRD_DIR="${PRD_DIR%/}"

if [[ ! -d "$PRD_DIR" ]]; then
  log_error "Pasta não encontrada: $PRD_DIR"
  exit 1
fi

for required_file in tasks.md prd.md techspec.md; do
  if [[ ! -f "$PRD_DIR/$required_file" ]]; then
    log_error "Arquivo obrigatório não encontrado: $PRD_DIR/$required_file"
    exit 1
  fi
done

# --- Verificar que codex CLI está disponível ---
if ! command -v codex &> /dev/null; then
  log_error "Codex CLI não encontrado. Instale com: npm install -g @openai/codex"
  exit 1
fi

if [[ -t 1 ]]; then
  FOOTER_SUPPORTED=true
fi

RESOLVED_MODEL="$(detect_codex_model || true)"
if [[ -z "$RESOLVED_MODEL" ]]; then
  RESOLVED_MODEL="default-do-codex"
fi

# --- Descobrir tasks ---
TASK_FILES=()
for f in "$PRD_DIR"/*_task.md; do
  [[ -f "$f" ]] || continue
  basename_f=$(basename "$f")
  # Excluir arquivos de review (*_task_review.md)
  if [[ "$basename_f" =~ ^[0-9]+_task\.md$ ]]; then
    TASK_FILES+=("$f")
  fi
done

if [[ ${#TASK_FILES[@]} -eq 0 ]]; then
  log_error "Nenhuma task encontrada em $PRD_DIR (padrão: N_task.md)"
  exit 1
fi

# Ordenar numericamente
IFS=$'\n' TASK_FILES=($(for f in "${TASK_FILES[@]}"; do echo "$f"; done | sort -t/ -k2 -V))
unset IFS

TOTAL=${#TASK_FILES[@]}
log_info "Encontradas $TOTAL task(s) em $PRD_DIR"
if [[ "$DANGEROUS_MODE" == true ]]; then
  log_warn "Modo padrao ativo: Codex sem sandbox e sem prompts de aprovacao"
else
  log_info "Modo sandboxed ativo: Codex em full-auto"
fi
log_info "Modelo efetivo do Codex: $RESOLVED_MODEL"
print_blank_line

# --- Função para verificar se task está completa ---
is_task_completed() {
  local task_num="$1"
  grep -qE "^[[:space:]]*-[[:space:]]*\[x\][[:space:]]*${task_num}\.0" "$PRD_DIR/tasks.md" 2>/dev/null
}

# --- Loop principal ---
for task_file in "${TASK_FILES[@]}"; do
  basename_f=$(basename "$task_file")
  task_num="${basename_f%%_task.md}"
  CURRENT_TASK_LABEL="Task ${task_num} (${basename_f})"
  SPINNER_INDEX=0

  print_line '%s' "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  log_info "Task $task_num — $task_file"

  # Check se já completa
  if [[ "$SKIP_COMPLETED" == true ]] && is_task_completed "$task_num"; then
    log_warn "Task $task_num já completa — pulando"
    ((SKIPPED++))
    print_blank_line
    continue
  fi

  # Montar prompt
  PROMPT=$(cat <<PROMPT_EOF
Voce e um assistente IA responsavel por implementar a task documentada abaixo no repositorio atual.

Ative e siga a skill \`executar-task\`.
Leia e siga as regras locais em \`AGENTS.md\` e \`CLAUDE.md\`.
Leia obrigatoriamente o arquivo da task, o \`prd.md\` e o \`techspec.md\` antes de implementar.
Use as skills locais adicionais quando fizer sentido para UI, migracao, docs, QA, review ou bugfix.
Use o MCP \`context7\` ja configurado no Codex quando precisar de documentacao tecnica externa.
Ao final, execute uma revisao final com a skill \`task-review\`. Se decidir delegar essa revisao, use o agente \`task-reviewer\`, que deve permanecer fino e apontar para essa skill.

Arquivos da tarefa:
- PRD: ${PRD_DIR}/prd.md
- Tech Spec: ${PRD_DIR}/techspec.md
- Tasks: ${PRD_DIR}/tasks.md
- Task file: ${PRD_DIR}/${task_num}_task.md

Regras operacionais:
- Inicie a implementacao logo apos o planejamento.
- Marque a task como completa em tasks.md apenas quando a implementacao e a revisao final estiverem prontas.
- Se \`npm run lint\` ou \`npm run build\` falharem por problemas preexistentes fora do escopo, registre isso claramente na resposta final.
- Use o budget de iteracoes apenas como hint de objetividade. Budget sugerido: ${MAX_TURNS}.
PROMPT_EOF
)

  # Montar comando codex
  CODEX_CMD=(
    codex
    exec
    -C "$REPO_ROOT"
  )

  if [[ "$DANGEROUS_MODE" == true ]]; then
    CODEX_CMD+=(--dangerously-bypass-approvals-and-sandbox)
  else
    CODEX_CMD+=(--full-auto)
  fi

  if [[ -n "$CODEX_MODEL" ]]; then
    CODEX_CMD+=(--model "$CODEX_MODEL")
  fi

  CODEX_CMD+=(-)

  log_info "Executando codex para task $task_num com modelo $RESOLVED_MODEL..."
  print_blank_line

  # Executar
  set +e
  run_codex_command
  exit_code=$?
  set -e

  if [[ $exit_code -eq 0 ]]; then
    log_success "Task $task_num concluída com sucesso"
    ((EXECUTED++))
  else
    log_error "Task $task_num falhou (exit code: $exit_code)"
    ((FAILED++))

    if [[ "$STOP_ON_ERROR" == true ]]; then
      log_error "Interrompendo execucao (use --no-stop-on-error para continuar)"
      break
    fi
  fi

  print_blank_line
done

# --- Resumo ---
print_blank_line
print_line '%s' "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
print_line '%b' "${BLUE}RESUMO${NC}"
print_line '%s' "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
print_line '%b' "  Total:      $TOTAL"
print_line '%b' "  Executadas: ${GREEN}$EXECUTED${NC}"
print_line '%b' "  Puladas:    ${YELLOW}$SKIPPED${NC}"
print_line '%b' "  Falhas:     ${RED}$FAILED${NC}"
print_line '%s' "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

if [[ $FAILED -gt 0 ]]; then
  exit 1
fi
