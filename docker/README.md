# Ollama + Open WebUI mit Docker Compose

Dieses Setup startet [Ollama](https://ollama.com) und [Open WebUI](https://github.com/open-webui/open-webui) als Docker-Container.

## Voraussetzungen

- [Docker](https://docs.docker.com/get-docker/) und [Docker Compose](https://docs.docker.com/compose/install/) installiert

## Starten

```bash
docker compose up -d
```

## Modell pullen

Nach dem Start kannst du ein Modell in den laufenden Ollama-Container laden:

```bash
docker compose exec ollama ollama pull qwen2.5-coder:7b
```

## WebUI öffnen

Öffne deinen Browser und navigiere zu:

```
http://localhost:3000
```

Beim ersten Start musst du einen Admin-Account anlegen.

## Stoppen

```bash
docker compose down
```

## Komplett löschen (inkl. Volumes)

> **Achtung:** Dieser Befehl löscht alle gespeicherten Modelle und Chat-Daten unwiderruflich.

```bash
docker compose down -v
```

## GPU-Support (NVIDIA)

Um NVIDIA-GPU-Beschleunigung zu aktivieren, öffne die `docker-compose.yml` im Repo-Root und kommentiere den `deploy`-Block unter dem `ollama`-Service ein.

Voraussetzung: Das [NVIDIA Container Toolkit](https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/install-guide.html) muss auf dem Host installiert sein.
