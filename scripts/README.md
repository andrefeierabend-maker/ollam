# scripts

Helper scripts for managing Ollama.

## ollama-update.sh

Updates all locally installed Ollama models by running `ollama pull` for each one.

**Features:**
- Checks that `ollama` is installed and the daemon is reachable before doing anything
- Fault-tolerant: a failed pull for one model does not abort the remaining updates
- Structured, timestamped log output suitable for cron jobs
- Exit code `0` on full success, `1` if any model failed, `2` on prerequisite failure

**Usage:**

```bash
# Update all models
./scripts/ollama-update.sh

# Preview what would happen without making changes
./scripts/ollama-update.sh --dry-run

# Show help
./scripts/ollama-update.sh --help
```

**Cron example** (update every day at 03:00):

```cron
0 3 * * * /path/to/scripts/ollama-update.sh >> /var/log/ollama-update.log 2>&1
```

**Flags:**

| Flag | Description |
|------|-------------|
| `-h`, `--help` | Show usage information |
| `--dry-run` | Print what would be done without pulling any models |
| `--prune` | *(Stub)* Reserved for future cleanup of unused model versions |
