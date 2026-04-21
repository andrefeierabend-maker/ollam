# ollam

![License](https://img.shields.io/github/license/andrefeierabend-maker/ollam)
![Status](https://img.shields.io/badge/status-active-brightgreen)

Use [Ollama](https://ollama.com) as a local LLM backend, accessible through [Claude Code](https://claude.ai/code) or [OpenCode](https://opencode.ai).

## Architecture

```
┌─────────────────────┐        ┌──────────────────────┐
│   Claude Code /     │  HTTP  │   Ollama Daemon       │
│   OpenCode          │◄──────►│   localhost:11434     │
│   (AI frontend)     │        │   (local LLM server)  │
└─────────────────────┘        └──────────┬───────────┘
                                           │
                                ┌──────────▼───────────┐
                                │   Local Models        │
                                │  (qwen2.5-coder, etc) │
                                └──────────────────────┘
```

**Components:**

- **Ollama** — runs LLM models locally, exposes an OpenAI-compatible REST API on `localhost:11434`
- **Claude Code / OpenCode** — AI coding assistants that can be pointed at the local Ollama endpoint instead of a cloud API
- **Local models** — quantized LLMs stored on disk, loaded on demand by the Ollama daemon

## Getting Started

See [SETUP.md](SETUP.md) for full installation and configuration instructions.

## License

MIT
