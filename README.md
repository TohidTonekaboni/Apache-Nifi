# 🔀 Apache NiFi — Learning Journey

A hands-on, section-by-section journey through Apache NiFi for data engineering.
This repo doubles as **learning notes** and a **progress log** — every section of the
[roadmap](roadmap.md) is completed and pushed as its own commit, so the git history itself
tells the story of the learning path.

📄 **Companion docs:**
- [`roadmap.md`](roadmap.md) — the full 10-section learning plan with exercises
- [`Compare.md`](Compare.md) — how NiFi stacks up against Kafka, Spark, Flink, Airflow, etc.

---

## 📌 Progress Tracker

Each row = one section of the roadmap = one commit (or a small series of commits) once completed.
Check items off and fill in the commit hash as you go.

| # | Section | Status | Commit |
|---|---|---|---|
| 1 | 🧩 Core Concepts & Architecture | ⬜ Not started | — |
| 2 | 💻 Installation & Environment Setup | ✅ Done | _(pending commit)_ |
| 3 | 🖥️ Building Your First Flows | ⬜ Not started | — |
| 4 | 📥 Data Ingestion | ⬜ Not started | — |
| 5 | 🔄 Data Transformation & Routing | ⬜ Not started | — |
| 6 | 📤 Data Egress (Sinks) | ⬜ Not started | — |
| 7 | ⚖️ Flow Control, Reliability & Performance | ⬜ Not started | — |
| 8 | 🕵️ Monitoring, Provenance & Troubleshooting | ⬜ Not started | — |
| 9 | 🔐 Clustering, Security & Governance | ⬜ Not started | — |
| 10 | 🏆 Advanced Topics & Capstone Project | ⬜ Not started | — |

> Status legend: ⬜ Not started · 🔶 In progress · ✅ Done

---

## 📁 Repo Structure

As each section is completed, its notes, exported flow templates, and configs live in a
matching numbered folder:

```
Apache-Nifi/
├── README.md              ← you are here
├── roadmap.md             ← the 10-section learning plan
├── Compare.md             ← NiFi vs. other big data tools
├── 01-core-concepts/
├── 02-setup/
├── 03-first-flows/
├── 04-data-ingestion/
├── 05-transform-routing/
├── 06-data-egress/
├── 07-reliability-performance/
├── 08-monitoring-provenance/
├── 09-clustering-security/
└── 10-advanced-capstone/
```

Each section folder typically contains:
- `notes.md` — key concepts, gotchas, and links learned in that section
- `flow-templates/` — exported NiFi flow `.json`/`.xml` templates built during the exercises
- `docker-compose.yml` (where relevant) — the environment used for that section's exercise

---

## 🧰 Prerequisites

- Java 11 or 17
- Docker & Docker Compose (recommended for fast, disposable NiFi instances)
- Basic familiarity with data engineering concepts (files, databases, messaging)

## 🚀 Quick Start

```bash
# Spin up a local NiFi instance using the compose setup in 02-setup/
cd 02-setup
cp .env.example .env   # then edit .env — set a real password (>= 12 characters)
docker compose up -d

# Access the UI (HTTPS only, note the /nifi path)
open https://localhost:8443/nifi
```

> See [`02-setup/notes.md`](02-setup/notes.md) for the gotchas we actually hit (HTTP vs
> HTTPS, the 12-character password minimum) and how they were fixed.

---

## 🎯 Goal

By the end of this repo, have a working, versioned, secured, clustered NiFi pipeline
(the [capstone project](roadmap.md#-advanced-topics--capstone-project)) and a personal
library of reusable flow patterns — plus a commit history that documents the whole path
from first principles to production-readiness.
