# 💻 Section 2 — Installation & Environment Setup

Notes and a working environment for getting Apache NiFi running locally, tested against
NiFi `1.27.0` via Docker on macOS.

---

## 1. Two ways to install NiFi

| Method | When to use |
|---|---|
| 🐳 **Docker (this folder)** | Fastest, disposable, reproducible — recommended for learning |
| 💻 **Standalone (binary)** | Useful to understand what Docker is doing under the hood, or when you need OS-level integration |

### Standalone install (reference)
```bash
# Requires Java 11 or 17
curl -LO https://dlcdn.apache.org/nifi/1.27.0/nifi-1.27.0-bin.zip
unzip nifi-1.27.0-bin.zip && cd nifi-1.27.0
bin/nifi.sh start          # start in background
tail -f logs/nifi-app.log  # watch it come up
bin/nifi.sh status         # check status
bin/nifi.sh stop           # stop
```
NiFi generates a random `admin` username/password on first boot — check `logs/nifi-app.log`
for `Generated Username` / `Generated Password`, or set your own with:
```bash
bin/nifi.sh set-single-user-credentials <username> <password>
```

### Docker (what's actually in this folder)
See [`docker-compose.yml`](docker-compose.yml) — brings up NiFi with:
- Named volumes for every repository (`conf`, `content`, `database`, `flowfile`, `provenance`, `state`, `logs`) so state survives container recreation
- A healthcheck hitting the UI
- An **optional** `nifi-registry` service behind a Compose profile (full use in Section 9)

```bash
cd 02-setup
cp .env.example .env        # then edit .env with your own credentials
docker compose up -d
docker compose logs -f nifi # watch startup
```

---

## 2. ⚠️ Gotchas we hit in practice (real issues, not hypothetical)

### ❌ `http://localhost:8443/` doesn't work
NiFi's web server on that port speaks **HTTPS only** — there is no plain-HTTP listener.
Requesting it over `http://` just gets connection-reset/refused by the browser.

✅ **Correct URL:** `https://localhost:8443/nifi` (note the `/nifi` path — the bare root
serves NiFi's generic error page, not the app). Accept the self-signed cert warning; NiFi
generates its own cert on first boot (see `Generated Self-Signed Certificate` in the logs).

### ❌ Password shorter than 12 characters is silently ignored
`SINGLE_USER_CREDENTIALS_PASSWORD` **must be ≥ 12 characters**. If it's shorter, the image's
setup script skips applying it — no error, no warning — and NiFi falls back to generating a
random username/password (visible only by `docker logs nifi | grep Generated`). We hit this
exact issue: a 10-character password in `.env` silently produced random creds instead.

✅ Fix: use a password ≥ 12 characters in `.env`, then recreate the container so the
credential-setup script re-runs against a clean `conf` volume:
```bash
docker compose down -v   # -v wipes volumes — fine for a learning sandbox, not for real data
docker compose up -d
```

### Verify login without a browser (useful for scripting/CI)
```bash
curl -sk -X POST "https://localhost:8443/nifi-api/access/token" \
  --data-urlencode "username=admin" \
  --data-urlencode "password=<your-password>" \
  -w "\n%{http_code}\n"
# 201 + a JWT body = success
```

---

## 3. 🖥️ NiFi UI tour

| Area | What it's for |
|---|---|
| 🎨 Canvas | Drag processors/process groups here, wire them with connections |
| 🧰 Components toolbar (top-left) | Processor, Input/Output Port, Process Group, Remote Process Group, Funnel, Label |
| ▶️ Operate palette (top-left, below components) | Start/stop/enable/disable selected components |
| 📊 Status bar (top) | Active threads, queued FlowFiles, cluster/node state |
| ☰ Global menu (top-right) | Controller Settings, Users, Flow Configuration History, Templates |
| 🕵️ Data Provenance | Under the global menu — full lineage search (deep dive in Section 8) |

---

## 4. ⚙️ `nifi.properties` — the properties that matter early on

Lives at `conf/nifi.properties` (inside the `nifi_conf` volume). Key ones to know:

| Property | Purpose |
|---|---|
| `nifi.web.https.port` | Port the UI/API listens on (what we changed below) |
| `nifi.web.https.host` | Bind address for the web server |
| `nifi.sensitive.props.key` | Encryption key for sensitive processor properties (passwords, tokens) |
| `nifi.flow.configuration.file` | Where the flow definition (`flow.json.gz`) is persisted |
| `nifi.content.repository.directory.default` | Where FlowFile content is stored on disk |
| `nifi.flowfile.repository.directory` | Where FlowFile attributes/state (write-ahead log) live |
| `nifi.provenance.repository.directory.default` | Where provenance events are stored |

In the Docker image, many of these are set **via environment variables** at container
startup rather than hand-edited — that's the supported way to control `nifi.properties`
when running in a container (the entrypoint script writes them into the file for you).

---

## 5. 📋 NiFi Registry (intro only — full setup in Section 9)

NiFi Registry stores **versioned flow definitions**, so a Process Group's history can be
tracked and promoted between environments (dev → staging → prod). It's included in this
compose file as an optional service so it's available when needed:
```bash
docker compose --profile registry up -d nifi-registry
# UI at http://localhost:18080/nifi-registry
```

---

## ✅ Practical exercise (completed & verified)

**Goal:** run NiFi via Docker Compose and prove you can control the runtime by changing a
`nifi.properties` value (the HTTPS port) and observing the effect.

1. `cp .env.example .env`, set a real ≥12-character password, `docker compose up -d`
2. Confirmed login via `curl` against `/nifi-api/access/token` → `201`
3. Changed `NIFI_WEB_HTTPS_PORT` in `.env` from `8443` → `8444`, ran `docker compose up -d`
   to recreate the container
4. Confirmed the API now responds on **8444** and **refuses connections on 8443**
5. Reverted `.env` back to `8443` (the repo's documented default) and re-confirmed login

This proves the property change took effect both ways — not just that the container restarted.
