# Setup Guide

Step-by-step instructions to get Ollama running as a local LLM backend.

## 1. Install Ollama

**macOS (Homebrew)**
```bash
brew install ollama
```

**Linux (curl installer)**
```bash
curl -fsSL https://ollama.com/install.sh | sh
```

**Windows**

Download and run the installer from [ollama.com/download](https://ollama.com/download).

## 2. Pull a Model

For coding tasks, `qwen2.5-coder:7b` is recommended:

```bash
ollama pull qwen2.5-coder:7b
```

Other useful models:
| Model | Size | Use case |
|---|---|---|
| `qwen2.5-coder:7b` | ~4 GB | Code generation (recommended) |
| `qwen2.5-coder:14b` | ~8 GB | Code generation (higher quality) |
| `llama3.2:3b` | ~2 GB | General chat (lightweight) |
| `llama3.1:8b` | ~5 GB | General chat |

## 3. Start Ollama as a Daemon

**macOS / Linux**
```bash
ollama serve
```

To run it as a background service on macOS:
```bash
brew services start ollama
```

On Linux with systemd:
```bash
sudo systemctl enable ollama
sudo systemctl start ollama
```

**Windows**

Ollama runs automatically as a background service after installation. You can manage it from the system tray icon.

## 4. Verify with a Test Query

Once Ollama is running, confirm it responds on port 11434:

```bash
curl http://localhost:11434/api/generate \
  -d '{
    "model": "qwen2.5-coder:7b",
    "prompt": "Write a hello world function in Python.",
    "stream": false
  }'
```

You should receive a JSON response with a `response` field containing the generated text.

Check available models:
```bash
curl http://localhost:11434/api/tags
```

## 5. Connect Claude Code or OpenCode

### Claude Code

Add Ollama as an API provider by setting the base URL to `http://localhost:11434/v1`:

```bash
claude config set apiBaseUrl http://localhost:11434/v1
```

### OpenCode

In your OpenCode configuration, set the provider endpoint to `http://localhost:11434/v1` and select the model you pulled (e.g., `qwen2.5-coder:7b`).

## Troubleshooting

### Port 11434 is already in use

Check what is occupying the port:
```bash
# macOS / Linux
lsof -i :11434

# Windows (PowerShell)
netstat -ano | findstr :11434
```

If a stale Ollama process is running, kill it and restart:
```bash
pkill ollama
ollama serve
```

### No GPU detected

Ollama falls back to CPU automatically, but performance will be slower. To check whether your GPU is being used:

```bash
ollama ps
```

**NVIDIA:** Ensure the [CUDA toolkit](https://developer.nvidia.com/cuda-downloads) is installed and `nvidia-smi` reports your GPU correctly.

**AMD (ROCm):** Install [ROCm](https://rocm.docs.amd.com/) and verify with `rocm-smi`.

**Apple Silicon:** GPU acceleration is built in — no extra steps required. Confirm by checking that `ollama ps` shows `metal` as the compute type.

### Model download is slow or fails

Try pulling again (downloads resume automatically):
```bash
ollama pull qwen2.5-coder:7b
```

To use a mirror or proxy, set the `HTTPS_PROXY` environment variable before running the pull:
```bash
HTTPS_PROXY=http://your-proxy:port ollama pull qwen2.5-coder:7b
```

### "model not found" error

List locally available models and confirm the name matches exactly:
```bash
ollama list
```
