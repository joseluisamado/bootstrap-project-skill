# Step 4 — Final design

Synthesizes steps 1–3 into a concrete design for the `bootstrap-project` skill.

This document is the spec; the actual templates land in `skill/` next to it.

---

## What the skill does, in one sentence

Reads a same-session design conversation, extracts a project spec, asks for confirmation on at most three things, and writes a complete project scaffold (docs, ops, build, conventions) into the current directory.

---

## When the skill is invoked

The skill is a **finalizer**, not a wizard. It assumes the user has just had a design conversation with Claude in this session — vision, principles, milestones, stack — and now wants to crystallize that into files.

Trigger: user says "bootstrap this project" or invokes the skill explicitly.

Result: a populated project tree, ready for `git init && git add . && git commit`.

---

## What the skill writes

### Always-present files (the universal core)

```
<project-root>/
├── README.md
├── CLAUDE.md
├── CONTRIBUTING.md
├── SECURITY.md                          # disclosure policy
├── CHANGELOG.md                         # Keep a Changelog format, [Unreleased] only
├── LICENSE                              # canonical text for chosen license
├── VERSION                              # 0.0.1
├── BOOTSTRAP-MANIFEST.md                # what this scaffold contains
├── .bootstrap-meta.yaml                 # skill version + invocation timestamp
├── .editorconfig
├── .gitignore                           # universal sections + project-specific placeholder
├── Makefile                             # generic targets, project-specific section at bottom
├── .pre-commit-config.yaml              # universal hooks + secret detection
├── docs/
│   ├── PROJECT.md                       # vision, principles, F-NN, NFRs, success criteria
│   ├── ARCHITECTURE.md                  # TOC, overview, components, decisions, open questions
│   ├── ROADMAP.md                       # milestones, exit criteria, "what we will not do"
│   ├── PROGRESS.md                      # status block, log, decisions pointer
│   ├── DEPLOY.md                        # numbered linear deployment guide (or stub if no deploy)
│   ├── BACKUP.md                        # state inventory, scenarios, RTO/RPO, verification
│   ├── SECURITY-REVIEW.md               # threat model + findings stub (populated at v1.0)
│   ├── PERFORMANCE.md                   # NFR citations + benchmark stub
│   └── INCIDENTS.md                     # append-only single-file log
├── scripts/
│   ├── README.md                        # script conventions
│   ├── sync_version.py                  # version propagation
│   └── setup-dev.sh                     # one-time dev environment setup
└── .github/workflows/ci.yml             # CI workflow (mirrored to .gitea/ if asked)
```

### Conditionally-present files (asked at invoke time)

```
docker-compose.yml + dev/prod/caddy.yml  # if "uses Docker"
Caddyfile.example                        # if Caddy overlay is enabled
.env.example                             # if any env vars detected in compose
.gitea/workflows/ci.yml                  # if "uses Gitea"
docs/RUNBOOK.md                          # if "operational runbook" flag
docs/rfcs/0000-template.md               # if "RFC process" flag
.github/ISSUE_TEMPLATE/*.md              # if "external contributions" flag
.github/PULL_REQUEST_TEMPLATE.md         # ditto
CODE_OF_CONDUCT.md                       # if "external contributions" flag
.github/dependabot.yml                   # if "dependency bot" flag
docs/PRIVACY.md                          # always written; one short doc
```

### Files NOT written (mention-only in patterns/)

These exist in the skill's `patterns/` reference but the skill does not scaffold them:
- ADR directory `docs/decisions/` — pattern doc explains the migration trigger.
- Diátaxis-named docs — convention is followed without naming.
- SBOM tooling
- CSP headers
- Property-based testing harness
- Mutation testing
- Visual regression testing

---

## What the skill asks

### Implicit (extracted from conversation, confirmation step)

The skill prints what it extracted and asks "ready? or correct anything first?". This is the only mandatory user interaction.

Extracted fields:
- **Project name** (slug for paths, label for prose)
- **One-line description** (tagline)
- **Audience statement** (who this is for)
- **Principles** (P1..Pn, derived from conversation; ≥3, ≤8)
- **Inviolable rules** (R1..Rn, derived from principles + sacred invariants discussed)
- **Initial milestones** (M0..MN, ≥3 milestones)
- **Stack profile** (one of: `python-only` / `node-only` / `python+node` / `go-only` / `rust-only` / `polyglot` / `none-yet`)
- **Backend framework** (if applicable)
- **Frontend framework** (if applicable)
- **Has user-content sub-repos?** (controls whether CLAUDE.md §6.3 two-repo section is included)
- **Deploy model** (one of: `docker-compose` / `single-binary` / `library` / `none-yet`)

### Explicit (always asked)

1. **License** — pick from common defaults (MIT, Apache-2.0, AGPL-3.0-only, GPL-3.0-only, BSL, "private/proprietary"), or "Other" with text input. Skill writes canonical text.
2. **Optional add-ons** — multiselect menu (the 12 flags from step 3). Each item has a one-line description. Defaults: `secret-scanning-precommit` ON; everything else OFF.

### Explicit (asked only when ambiguous)

If the conversation didn't establish:
- Stack profile → ask.
- Deploy model → ask.
- Has user-content sub-repos → ask.
- Project name slug → ask.

If it did, confirm in the extraction step.

---

## The optional-add-ons menu

When the skill asks "any optional add-ons?", it presents this multiselect:

| Flag | Description | Default |
|---|---|---|
| `rfc-process` | Scaffold `docs/rfcs/` with template + CLAUDE.md note | off |
| `readme-badges` | Add CI / version / license badges to README | off |
| `runbook` | Add `docs/RUNBOOK.md` operational playbook | off |
| `observability-stub` | Wire structured logging + `/metrics` endpoint stub | off |
| `signed-tags` | `make release` uses `git tag -s` instead of `-a` | off |
| `digest-pinned-images` | Pin Docker base images by sha256 instead of tag | off |
| `sast` | Add SAST tool to CI (bandit/semgrep) | off |
| `a11y-checks` | Add automated accessibility checks (frontend only) | off |
| `i18n-scaffold` | Wire i18n library with `en.json` (frontend only) | off |
| `external-contributions` | Add CoC, issue/PR templates | off |
| `dependency-bot` | Add Dependabot or Renovate config | off |
| `gitea-mirror` | Also write `.gitea/workflows/` mirror of CI | off |
| `secret-scanning-precommit` | `detect-secrets` pre-commit hook | **on** |
| `cve-scan-ci` | `pip-audit` / `pnpm audit` job in CI | **on** |

The user picks any subset; defaults pre-checked.

---

## The confirmation step

After extraction and the two explicit asks, the skill prints something like:

```
About to bootstrap "habittrack" with:

  Description: A self-hosted habit-and-metric tracker.
  Audience: A solo user who wants their habit data in plain files.
  Stack: python+node (FastAPI + Vue 3)
  Deploy: docker-compose
  License: MIT
  User-content sub-repos: yes (matches libreta-pattern)

  Principles (4):
    P1 — The filesystem is the source of truth.
    P2 — Every save is a commit.
    P3 — No realtime collaboration in v1.
    P4 — No reliance on public services at runtime.

  Inviolable rules (3):
    R1 — Filesystem source-of-truth (P1)
    R2 — Save = commit (P2)
    R3 — No public-CDN runtime deps (P4)

  Milestones (5):
    M0 — Foundations
    M1 — Read-only browse
    M2 — Editing & commits
    M3 — Search & attachments
    M4 — v1.0 release

  Optional add-ons enabled:
    • secret-scanning-precommit (default)
    • cve-scan-ci (default)

Ready to write 28 files into ./habittrack/, or want to correct something?
```

User says "go" or corrects.

If anything is missing (e.g. extraction gave only 2 principles, skill needs ≥3), the skill asks specifically for the missing bits.

---

## What the skill writes per file

(Detailed templates land in `skill/templates/`. This is the abstract spec.)

### `README.md`

Sections:
1. `# {{project_name}}` + `> {{tagline}}` blockquote
2. `## Status` line: `**Status**: v{{version}} — {{current_milestone}}` with links to PROGRESS and ROADMAP
3. `## Why this exists` — comparison table OR narrative paragraph (asked: "do you have direct competitors?")
4. `## Quickstart` — three commands (varies by deploy model)
5. `## Documentation` — index table with three columns: Page / What's there / Read it when…
6. `## Privacy` — one-line: "{{project_name}} stores no telemetry, no analytics. Your data lives at: {{data_path}}"
7. `## License` — short paragraph + SPDX line + LICENSE link

Conditional:
- Badge row at top if `readme-badges` flag set.

### `CLAUDE.md`

Sections (numbered):
1. **Orientation** — file tree + mental model
2. **Inviolable rules** — R1..Rn, each citing the P-N principle, header note about lifecycle (RV-31)
3. **Working in the {{primary_layer}}** — pre-flight checks, conventions
4. **Working in the {{secondary_layer}}** (if polyglot) — same shape
5. **Working with the docker stack** (if deploy_model = docker-compose)
6. **Commits and branches** — Conventional Commits, branch naming, two-repo distinction (conditional on `has_user_content_subrepos`)
7. **Updating project documents** — what to edit when conventions change
8. **When to stop and ask** — trigger list + inverse "default to action" list (RV-32)
9. **Things that look fine but aren't** — empty list with header note "Add to it" (RV-33)
10. **Quick reference** — table per-stack
11. **Updating this manual** — meta-note about evolution (RV-35)

### `docs/PROJECT.md`

Sections:
1. **Audience** — one paragraph (RV-04)
2. **Vision** — paragraph
3. **Background** — narrative (no comparison table; that's in README) (RV-03)
4. **Principles** — P1..Pn, each as decision-rule + lifecycle note
5. **Goals** — Must / Should subsections (no v2+; routed to ROADMAP) (RV-01)
6. **Non-goals** — bullet list (forever)
7. **Functional requirements** — F-NN table (RV-02)
8. **Non-functional requirements** — perf / footprint / portability with `(set: YYYY-MM-DD)` stamps (RV-05)
9. **Success criteria** — bullet list
10. **Out of scope** — bullet list (for-this-version)

### `docs/ARCHITECTURE.md`

Sections:
1. TOC at top (mandatory)
2. **Overview** — paragraph + key data shape
3. **System diagram** — mermaid placeholder with `{{TODO}}`
4. **Trust boundaries** — list (RV-11)
5. **Components** — one subsection each
6. **Technology choices** — table with Why column (RV-09)
7. **Decisions deliberately deferred** — short bullet list (RV-10)
8. **Data model** — for stack-applicable
9. **Storage layer** — for stack-applicable
10. **Failure modes** — table: Component / What fails / User-visible / Recovery (RV-12)
11. **HTTP API** (if applicable) — tables per resource
12. **Frontend** (if applicable)
13. **Deployment topology** — mermaid + brief
14. **Key decisions** — D-01..D-NN, each `### D-NN — title (date)` + Why + Consequence (RV-15 enforces dates)
15. **Open questions** — `(Leaning, YYYY-MM-DD: ...)` format (RV-14)
    - **Resolved** sub-section (mini-log)

### `docs/ROADMAP.md`

Sections:
1. Header note about polish-milestones being first-class (RV-16)
2. **M0 — Foundations** ... **MN — v1.0** — each: Goal / checklist / Exit criteria / optional Kill criteria (I-2)
3. **Beyond v1: planned but not committed** — split from "Anytime backlog" (RV-17)
4. **Anytime backlog** — small items, can ship between milestones
5. **What we will not do** — closing immune-response section (RV-19)

ROADMAP also includes a v1.0 milestone line item: `[ ] Populate docs/BACKUP.md, docs/SECURITY-REVIEW.md, docs/PERFORMANCE.md before v1.0 tag` (RV-70).

### `docs/PROGRESS.md`

Sections:
1. **Status** block: current milestone / next milestone / next action / `started: YYYY-MM-DD` (RV-21)
2. **At a glance** — milestone status table
3. **Log** — empty initially, with one "Project kickoff" entry seeded (RV-24 sign-off format)
4. **Backlog** — empty list with usage note (RV-25)
5. **Decisions log** — pointer table (Date / D-NN / Title / Link) (RV-22), not duplicate
6. **How to update this file** — recipe at bottom (RV-23)

### `docs/DEPLOY.md`

If `deploy_model = docker-compose`:
1. **Is it alive?** — quick smoke commands at the top (RV-27)
2. **Architecture overview** — paragraph
3. **Prerequisites** — bullet list
4. **Get the source** — git clone
5. **Build** — `make build-prod`
6. **Configure** — `.env` + `.env.example` reference
7. **Deploy** — `docker compose up -d` (RV-26 separation)
8. **Initial setup** — post-deploy admin tasks
9. **Front with TLS** — Caddy overlay (optional section)
10. **Backups** — link to BACKUP.md
11. **Upgrades** — flow with VERSION pinning
12. **Operational notes** — logs, healthchecks, resource limits + production hardening checklist (RV-30)
13. **Tearing it down**
14. **Troubleshooting** — "First, check:" subsection then symptoms (RV-29)

If `deploy_model = single-binary`: shorter doc, same shape.
If `deploy_model = library`: `DEPLOY.md` becomes `PUBLISH.md` (release flow + how to install).
If `deploy_model = none-yet`: stub with TODO marker.

### `docs/BACKUP.md`

Sections:
1. **Targets** — RTO and RPO lines (C-4)
2. **What state exists** — table (Where / What / Authoritative? / Backup priority)
3. **Strategy** — paragraph
4. **Backing up** — quick + scheduled
5. **Restoring** — three scenarios (single-item / lost-volume / lost-host)
6. **Verifying restores work** — quarterly cadence (C-5)
7. **What this doc doesn't cover** — limitations

### `docs/SECURITY-REVIEW.md`

Stub. Sections present, mostly empty:
1. **Threat model** — `{{TODO: enumerate adversaries}}`
2. **What was audited** — empty table
3. **Findings** — empty
4. **What I checked but found OK** — empty
5. **Known limitations** — empty
6. **How to reproduce** — `{{TODO}}`
7. **Sign-off** — `{{TODO: date and reviewer}}`

ROADMAP v1.0 milestone item enforces population.

### `docs/PERFORMANCE.md`

Stub. Cites NFRs from PROJECT.md by quote, then:
1. **Reproducing** — `{{TODO: smoke bench command}}`
2. **Results** — empty table for now
3. **What this doesn't measure** — list (already populated; universal)
4. **When to re-run** — list (already populated; universal)

### `docs/INCIDENTS.md`

Append-only single-file log. Header explains format. Empty body.

### `docs/PRIVACY.md`

Short doc:
- **What this project collects**: nothing (or fill in)
- **What this project sends**: nothing (or fill in)
- **Where your data lives**: <data path>
- **Telemetry**: none

### `Makefile`

Sections (RV-41 awk explanation comment, RV-42 project-specific section, RV-43 doctor target):

```makefile
# Header
.DEFAULT_GOAL := help
.PHONY: help install dev check format lint typecheck test build clean version sync-version version-bump version-set release doctor sync-ci

# Variables (stack-driven)
BACKEND := backend
FRONTEND := frontend
VERSION := $(shell cat VERSION 2>/dev/null)
COMPOSE_DEV := docker compose -f docker-compose.yml -f docker-compose.dev.yml --profile dev

# Help (with awk explanation comment)
help: ## Show this help

# install / dev / check / format / lint / typecheck / test / build / clean
# ... (same shape as libreta)

# doctor: env check
doctor: ## Verify dev tools are installed (docker, language toolchain, lockfiles fresh)

# sync-ci: copies .github/workflows to .gitea/workflows (if both exist)
sync-ci: ## Copy CI workflow to mirror provider

# versioning + release
version / sync-version / version-bump / version-set / build-prod / release

# ---------- project-specific ----------
# Add your one-shot scripts here. Each should have foo and foo-dry where applicable.
```

### `docker-compose.yml` family

Per RV-47..RV-54:
- Base file: services with healthchecks, log-rotation `logging:` block, commented-out resource limits, no absolute host paths.
- Dev overlay: bind-mount source, reloader command, PYTHONPATH if Python.
- Prod overlay: image-pin to `${VERSION}`, `pull_policy: never` until registry wired.
- Caddy overlay: `ports: !reset []` with explanation comment, HTTP/3, separate `caddy-data` volume.

### `.env.example`

Auto-generated by parsing the env vars referenced in compose files. Each var present with a `# TODO: set me` comment.

### `.pre-commit-config.yaml`

Universal hooks + ruff/mypy/prettier/eslint by stack + `detect-secrets` (RV-65 / E-2).

### `.github/workflows/ci.yml` (and optional `.gitea/workflows/ci.yml` mirror)

CI per RV-61: `make check-backend` and `make check-frontend` (single source of truth). Per RV-63 (E-1): optional `security` job runs `pip-audit`, `pnpm audit`, etc.

### `scripts/`

- `sync_version.py` — generalized to read a `[tool.bootstrap-version]` table or fallback to libreta's two-target shape (RV-55).
- `setup-dev.sh` — installs pre-commit hooks, runs `make install`, prints dev URL (RV-59).
- `README.md` — script conventions (one script per file, idempotent, --dry-run, runnable via make, no shared state).

### `BOOTSTRAP-MANIFEST.md`

Generated at write time. Sections:
1. **Generated by** — skill name + version + date
2. **Spec used** — extracted fields (project name, principles, milestones, stack, license, add-ons enabled)
3. **Files written** — full list with one-line description per file
4. **`{{TODO}}` markers remaining** — grep across templates for `{{TODO}}` markers; list with file paths
5. **Next 30 minutes** — punch list (RV-89): `git init`, draft system diagram, fill F-NN, etc.

### `.bootstrap-meta.yaml`

```yaml
bootstrap_skill_version: 0.1.0
generated: 2026-05-10T11:30:00Z
spec:
  project_name: habittrack
  stack_profile: python+node
  license: MIT
  add_ons:
    - secret-scanning-precommit
    - cve-scan-ci
```

Used by future skill versions to detect "this project was bootstrapped" and offer migrations.

---

## The skill's behavior in detail

### Invariants

1. **Never write outside the project root** (RV-90).
2. **Never clobber existing files**. If a file exists, log "skipped (exists): path/to/file" and continue (RV-92).
3. **Skill version stamped** in `.bootstrap-meta.yaml` (RV-91).
4. **Cross-references between docs use canonical paths** — `docs/PROJECT.md`, never relative cleverness (RV-83).
5. **Every `{{TODO}}` marker is enumerated** in BOOTSTRAP-MANIFEST so user has a punch list.

### Order of operations

1. Read conversation; extract spec.
2. Print extracted spec; ask user to confirm or correct.
3. Ask explicit questions (license, add-ons).
4. Re-confirm if anything changed.
5. Plan files to write (universal + conditional).
6. For each planned file: render template with spec values; write only if absent; otherwise log skip.
7. Generate `BOOTSTRAP-MANIFEST.md` after all writes.
8. Generate `.bootstrap-meta.yaml`.
9. Print "next 30 minutes" punch list.

### Template language

Simple `{{placeholder}}` substitution. Supported placeholders:
- `{{project_name}}`, `{{project_slug}}`, `{{tagline}}`, `{{audience}}`, `{{description}}`
- `{{user_email}}` — for SECURITY.md
- `{{license_name}}`, `{{license_spdx}}`
- `{{version}}` — initially `0.1.0`
- `{{date_today}}`
- `{{principles}}` — rendered list
- `{{rules}}` — rendered list
- `{{milestones}}` — rendered list
- `{{stack_profile}}`
- `{{deploy_model}}`
- Conditional sections via simple `{{#if flag}}...{{/if}}` for known flags.

No full templating language. Markdown stays markdown.

---

## Skill file tree (what lives in `~/.claude/skills/bootstrap-project/`)

```
bootstrap-project/
├── SKILL.md                    # frontmatter + brief description (harness reads this)
├── INSTRUCTIONS.md             # the playbook Claude follows
├── templates/
│   ├── README.md.tmpl
│   ├── CLAUDE.md.tmpl
│   ├── CONTRIBUTING.md.tmpl
│   ├── SECURITY.md.tmpl
│   ├── CHANGELOG.md.tmpl
│   ├── VERSION.tmpl
│   ├── BOOTSTRAP-MANIFEST.md.tmpl
│   ├── .bootstrap-meta.yaml.tmpl
│   ├── .editorconfig.tmpl
│   ├── .gitignore.tmpl
│   ├── Makefile.tmpl
│   ├── .pre-commit-config.yaml.tmpl
│   ├── docs/
│   │   ├── PROJECT.md.tmpl
│   │   ├── ARCHITECTURE.md.tmpl
│   │   ├── ROADMAP.md.tmpl
│   │   ├── PROGRESS.md.tmpl
│   │   ├── DEPLOY.md.tmpl
│   │   ├── BACKUP.md.tmpl
│   │   ├── SECURITY-REVIEW.md.tmpl
│   │   ├── PERFORMANCE.md.tmpl
│   │   ├── INCIDENTS.md.tmpl
│   │   ├── PRIVACY.md.tmpl
│   │   ├── RUNBOOK.md.tmpl                    # conditional
│   │   └── rfcs/
│   │       └── 0000-template.md.tmpl          # conditional
│   ├── scripts/
│   │   ├── sync_version.py                    # not a template — copied as-is
│   │   ├── setup-dev.sh.tmpl
│   │   └── README.md.tmpl
│   ├── docker-compose/
│   │   ├── docker-compose.yml.tmpl            # conditional
│   │   ├── docker-compose.dev.yml.tmpl
│   │   ├── docker-compose.prod.yml.tmpl
│   │   ├── docker-compose.caddy.yml.tmpl
│   │   ├── Caddyfile.example.tmpl
│   │   └── .env.example.tmpl
│   ├── ci/
│   │   ├── github-ci.yml.tmpl
│   │   └── gitea-ci.yml.tmpl
│   ├── github-extras/
│   │   ├── CODE_OF_CONDUCT.md.tmpl            # conditional (Contributor Covenant)
│   │   ├── ISSUE_TEMPLATE/
│   │   │   ├── bug_report.md.tmpl
│   │   │   └── feature_request.md.tmpl
│   │   ├── PULL_REQUEST_TEMPLATE.md.tmpl
│   │   └── dependabot.yml.tmpl
│   └── licenses/
│       ├── MIT.txt
│       ├── Apache-2.0.txt
│       ├── AGPL-3.0-only.txt
│       ├── GPL-3.0-only.txt
│       ├── BSL-1.0.txt
│       └── proprietary.txt
└── patterns/
    ├── README.md
    ├── adr-vs-inline-decisions.md
    ├── threat-modeling-cadence.md
    ├── property-based-testing.md
    ├── csp-headers.md
    ├── sbom.md
    ├── image-signing.md
    ├── reproducible-builds.md
    ├── visual-regression-testing.md
    ├── coverage-thresholds-considered-harmful.md
    ├── feature-flags.md
    ├── slos-vs-targets.md
    ├── definition-of-done-considered-bureaucratic.md
    ├── stack-shaped-practices.md
    └── why-libreta-shape.md
```

The `the repo's `skill/`` directory mirrors this exactly. `install.sh` copies it into `~/.claude/skills/bootstrap-project/`.

---

## What `install.sh` does

```bash
#!/usr/bin/env bash
set -euo pipefail
SRC="$(cd "$(dirname "$0")" && pwd)/skill"
DEST="$HOME/.claude/skills/bootstrap-project"
mkdir -p "$DEST"
rsync -a --delete "$SRC/" "$DEST/"
echo "Installed to $DEST"
echo "Test by invoking the skill in a Claude Code session: /bootstrap-project"
```

Simple `rsync --delete` so the install is reproducible and removes stale files from previous installs.

---

## What I will write next

Starting now (within this same step 4):

1. The `skill/SKILL.md` — frontmatter + description.
2. The `skill/INSTRUCTIONS.md` — the playbook.
3. The high-priority templates: README, CLAUDE, PROJECT, ARCHITECTURE, ROADMAP, PROGRESS, DEPLOY, Makefile, docker-compose family.
4. The conditional templates (BACKUP, SECURITY-REVIEW, PERFORMANCE, INCIDENTS, RUNBOOK, etc.).
5. The patterns/ docs.
6. `install.sh`.
7. The bootstrap-project-skill repo's own README, CHANGELOG, VERSION (eat dogfood).

Each template is short — the tedious work is making sure cross-references are wired (e.g. CLAUDE.md mentions PROJECT.md by exact path, ROADMAP.md links to PROGRESS.md by exact path).

The volume is high; I'll work through it systematically and report back when the `skill/` tree is complete. Then we review.
