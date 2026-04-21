#!/usr/bin/env bash
# Updates all locally installed Ollama models via `ollama pull`.
# Designed for use as a cron job.

set -euo pipefail

DRY_RUN=false
PRUNE=false
FAILED=0
UPDATED=0

usage() {
    cat <<EOF
Usage: $(basename "$0") [OPTIONS]

Updates all locally installed Ollama models.

Options:
  -h, --help      Show this help message and exit
  --dry-run       Print what would be done without executing any updates
  --prune         (Stub) Reserved for future cleanup of unused model versions

Exit codes:
  0   All models updated successfully (or dry-run completed)
  1   One or more model updates failed
  2   Prerequisite check failed (Ollama not installed or daemon not running)
EOF
}

log() {
    echo "[$(date '+%Y-%m-%dT%H:%M:%S')] $*"
}

# Parse arguments
for arg in "$@"; do
    case "$arg" in
        -h|--help)
            usage
            exit 0
            ;;
        --dry-run)
            DRY_RUN=true
            ;;
        --prune)
            PRUNE=true
            ;;
        *)
            echo "Unknown option: $arg" >&2
            usage >&2
            exit 2
            ;;
    esac
done

# Check that ollama binary is available
if ! command -v ollama &>/dev/null; then
    log "ERROR: 'ollama' not found in PATH. Please install Ollama first."
    exit 2
fi

# Check that the Ollama daemon is running by listing models
if ! ollama list &>/dev/null; then
    log "ERROR: Ollama daemon is not running or not reachable. Start it with 'ollama serve'."
    exit 2
fi

if "$PRUNE"; then
    log "INFO: --prune is a stub and not yet implemented. Skipping."
fi

# Collect model names (skip the header line, grab the first column)
mapfile -t MODELS < <(ollama list 2>/dev/null | tail -n +2 | awk '{print $1}' | grep -v '^$')

if [[ ${#MODELS[@]} -eq 0 ]]; then
    log "INFO: No models installed. Nothing to update."
    exit 0
fi

log "INFO: Found ${#MODELS[@]} model(s) to update: ${MODELS[*]}"

for model in "${MODELS[@]}"; do
    if "$DRY_RUN"; then
        log "DRY-RUN: Would pull '$model'"
        continue
    fi

    log "INFO: Pulling '$model' ..."
    if ollama pull "$model"; then
        log "OK: '$model' updated successfully."
        (( UPDATED++ )) || true
    else
        log "ERROR: Failed to update '$model'. Continuing with remaining models."
        (( FAILED++ )) || true
    fi
done

if "$DRY_RUN"; then
    log "INFO: Dry-run complete. No changes were made."
    exit 0
fi

log "INFO: Done. Updated: $UPDATED, Failed: $FAILED."

if [[ $FAILED -gt 0 ]]; then
    exit 1
fi

exit 0
