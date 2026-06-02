# Step 1 — Libreta inventory

Source: `the `libreta` repo` at v1.0.0 (commit `5a19cdf`, 2026-05-09).

Goal of this document: enumerate every artifact in libreta that could become part of a bootstrap-project skill, capturing for each:

- **What it is** — one-line description.
- **Why it works** — the underlying engineering principle that makes it valuable beyond libreta itself.
- **Project-specific bits** — what must be parameterized when extracted to a template.
- **Universal bits** — what can be templated as-is.
- **Dependencies** — what other artifacts it cross-references.

The inventory is grouped into three layers:

1. **Documentation layer** — the `docs/` quintet plus README/CLAUDE.
2. **Operations layer** — Makefile, docker-compose family, VERSION, scripts/, CI, pre-commit.
3. **Release-artifact layer** — the M5-stage docs (BACKUP, SECURITY-REVIEW, PERFORMANCE, MIGRATION-*).

Each artifact is rated on **template fitness**:
- 🟢 **Direct template** — strong shape, parameterize and ship as default.
- 🟡 **Pattern-only** — too project-specific to template literally; capture the *shape* in `patterns/`.
- ⚪ **Optional** — useful but skip on bootstrap; user generates when needed.

---

## Layer 1 — Documentation

### 1.1 `docs/PROJECT.md` 🟢

**What**: Project charter. The constitutional document. Vision, principles, goals (must/should/future), non-goals, functional requirements (F-NN table), non-functional requirements (perf/footprint/portability), success criteria, out-of-scope.

**Why it works**: A single document that answers "what is this and what is it deliberately not." Principles are written as **decision rules**, not aspirations — the doc says explicitly "When a feature request conflicts with a principle, the principle wins." This is the load-bearing distinction. Without it, "principles" becomes marketing.

The F-NN table forces explicit must/should triage. The non-goals section is the most-cited part in practice — it kills scope creep at design time, not after implementation.

**Project-specific bits**:
- Vision paragraph
- Comparison table (libreta vs Wiki.js vs BookStack vs Docmost)
- The 6 P-principles (P1–P6)
- The F-01..F-16 functional requirements
- Specific NFR numbers (200 ms on Pi 4, etc.)
- "Success criteria" items

**Universal bits**:
- Section structure: Vision → Background → Principles → Goals → Non-goals → Functional reqs → NFRs → Success criteria → Out-of-scope.
- The convention "P1..Pn = principles, F-NN = functional requirements".
- The decision-rule framing for principles.
- The must/should/future triage layer.
- The explicit "Non-goals" and "Out of scope" sections (separate, deliberately).

**Dependencies**: `ROADMAP.md` cites P-NN principles. `CLAUDE.md` cites P-NN as the source for inviolable rules. `PERFORMANCE.md` cites the NFRs table.

---

### 1.2 `docs/ARCHITECTURE.md` 🟢

**What**: Full technical architecture. TOC up front. Overview → mermaid system diagram → components → tech-choices table with *Why* column → data model → storage layer → HTTP API tables → frontend → editor specifics → integrations → asset handling → search → auth (forward-looking) → deployment topology → key decisions (D-NN with Why/Consequence/date) → open questions.

**Why it works**: 

1. **The Why column** in the tech-choices table is doing all the heavy lifting. Without it the table is "we picked X" and rots; with it the table is a reasoning trail that survives turnover.
2. **D-NN decisions inline, dated, with Why and Consequence**. This is poor man's ADR — no separate `adr/` directory, but the same epistemic discipline. Each D entry can be revisited and superseded; old ones aren't rewritten, they're left as history.
3. **Open questions as a first-class section**. Most arch docs pretend everything is decided; libreta's says "here's what we haven't figured out." The leaning ("Leaning: …") in each open question is a soft commitment that captures the current best guess without forcing a premature decision.
4. **Mermaid diagram** in the doc itself, not a separate `.png`. Renders on GitHub, edits in-line, never goes stale because nobody can find the source file.

**Project-specific bits**:
- The system diagram contents
- All component descriptions
- The actual D-01..D-10 list
- The HTTP API tables
- Tech-stack rows

**Universal bits**:
- TOC at top.
- Section structure (Overview → diagram → components → tech choices → data model → storage → API → frontend → integrations → deployment → key decisions → open questions).
- Tech-choices-with-Why-column convention.
- D-NN decision format: `### D-NN — short title (date)` + `**Why:**` + `**Consequence:**`.
- "Decisions deliberately deferred" subsection inside Tech choices.
- Open questions with "(Leaning: …)" pattern.

**Dependencies**: `CLAUDE.md` §1 says "Read `docs/PROJECT.md` and `docs/ARCHITECTURE.md` before making non-trivial changes." `PROGRESS.md` decisions log cross-references D-NNs.

---

### 1.3 `docs/ROADMAP.md` 🟢

**What**: Milestone-based plan, **dateless** by design ("This is a side project; pace will vary"). Each milestone has a goal, a checklist of deliverables, and an explicit **exit criteria**. Sections: M0 Foundations, M1, M0.5 polish (interpolated), M2, M3, M3.5, M4, M5, "Beyond v1" (M6..M10 + smaller anytime items), "What we will not do".

**Why it works**:
1. **No dates**. Removes the urge to slip schedule. Milestones are coherent slices of value, not calendar events.
2. **Exit criteria per milestone**. Forces clarity about *what done means* before starting. This is the single biggest quality lever in the doc.
3. **Interpolated polish milestones (M0.5, M3.5)** captured *the act of inserting them* — when real usage surfaces rough edges, a polish milestone lands between feature milestones rather than slipping into the next feature one.
4. **"Beyond v1: planned but not committed"** — separates "we will do this" from "we won't preclude this." Critical for not over-committing.
5. **"What we will not do"** at the bottom restates non-goals. Roadmaps are where scope creep enters; this section is the immune response.

**Project-specific bits**:
- Specific milestone names and contents
- Checkbox items per milestone
- M5-specific shipping details (security review, license, etc.)

**Universal bits**:
- No-dates rule.
- Milestone shape: Goal → checklist → exit criteria.
- Polish-milestone insertion pattern (M0.5 between M0 and M1, M3.5 between M3 and M4).
- "Beyond v1: planned but not committed" with M6..MN sub-sections.
- "Anytime / small backlog" callout (e.g. "`libreta gc` — orphan asset cleanup ✅" — done items inline).
- "What we will not do" closing section.

**Dependencies**: `PROGRESS.md` "At a glance" table mirrors the milestone list. `PROJECT.md` Goals → Must/Should/Future sometimes mention milestone numbers.

---

### 1.4 `docs/PROGRESS.md` 🟢

**What**: Living log. Top: **Status block** (current milestone / next milestone / next action). Then **At-a-glance table** (one row per milestone, ⚪🟡🟢🔴 status). Then **Log** with dated entries (latest first), each 3–8 bullets. Then **Backlog** (unscheduled noticed-but-not-fixed). Then **Decisions log** (date / decision / rationale table). Closing: **How to update this file** — explicit recipe for future-self.

**Why it works**:
1. **Status block at the top is always current**. The convention "Status line must always reflect reality" is enforceable: if status is wrong, the doc is broken.
2. **Latest at the top**. Nobody scrolls down past stale entries; the most recent state is always one glance away.
3. **Dated entries**. PROGRESS is a primary source for "when did we change X?" — git log can answer it but PROGRESS is faster and includes reasoning.
4. **Decisions log table**. Quick-reference for "why did we do Y?" — complements the long-form D-NN entries in ARCHITECTURE.
5. **"How to update" recipe at the bottom**. Self-documenting maintenance instructions. Without this, the doc rots after the original author leaves.
6. **Bonus**: each entry usually ends with a "Pre-flight: backend XX/XX tests pass, ruff/mypy clean. Frontend YY/YY pass, vue-tsc clean." line. Makes the entry verifiable.

**Project-specific bits**:
- All the actual log entries
- Specific milestone names in the at-a-glance table

**Universal bits**:
- Five-section shape: Status / At-a-glance / Log / Backlog / Decisions log / How to update.
- Status block format.
- Entry shape: date heading → "What changed" → bullets → "Pre-flight" sign-off.
- Decisions log table format: date / decision / rationale.
- "How to update this file" closing recipe.

**Dependencies**: References ROADMAP milestones; cross-links to ARCHITECTURE D-NN entries.

---

### 1.5 `docs/DEPLOY.md` 🟢

**What**: Bootstrap-from-scratch deployment guide. Numbered sections: Prerequisites → Get source → Build images → Configure runtime → Start the stack → Add wiki source (post-deploy admin) → Front with TLS (Caddy) → Backups → Upgrades → Operational notes → Tearing it down → Troubleshooting.

**Why it works**:
1. **Numbered linear sections**. A user can read top-to-bottom, do each step, and end up running. This is rare in deploy docs.
2. **The "you need" prerequisites section** sets expectations before any commands.
3. **Smoke-test commands** at the end of section 5 (`curl ...`) confirm the deployment is real, not just "it didn't error."
4. **"Front with TLS" as section 7** is *optional*. Deploys without TLS are valid for `localhost`/private-network use; making it optional avoids forcing users into Caddy on day one.
5. **Troubleshooting at the end** with **symptoms → causes → fixes** structure. Each entry starts with what the user *sees*, not what the system is doing wrong internally.
6. **Tearing it down** section. Most deploy docs assume immortality; libreta's says "here's how you stop." Useful for evaluators.

**Project-specific bits**:
- Specific image names, ports, env vars
- The "Add Git Source" admin step (libreta-specific feature)
- Caddyfile contents

**Universal bits**:
- Numbered linear structure.
- Prerequisites table.
- Smoke-test commands after start.
- Optional TLS section.
- Backups summary + link to BACKUP.md.
- Upgrade flow with VERSION pinning.
- Operational notes (logs, healthchecks, resource limits).
- Tearing-down section.
- Troubleshooting table at end (symptom → cause → fix).

**Dependencies**: Links to BACKUP.md. References Makefile targets (`make build-prod`).

---

### 1.6 `CLAUDE.md` 🟢

**What**: Operating manual for Claude Code agents working on the project. 10 numbered sections: Orientation → Inviolable rules (R1..R6) → Working in the backend → Working in the frontend → Working with the docker stack → Commits and branches (incl. two-repo distinction) → Updating project documents → When to stop and ask → Things that look fine but aren't → Quick reference table.

**Why it works**:
1. **Inviolable rules section is the heart of the doc**. Each R-rule maps explicitly to a P-principle in PROJECT.md. The mapping makes the rules legitimate (not arbitrary).
2. **Pre-flight checks per layer (§3.3 backend, §4.3 frontend)**. Claude Code (and humans) get an explicit "did I finish?" checklist with exact commands. This eliminates "I think it's done."
3. **§6.3 two distinct git contexts table**. Calls out a specific recurring trap — a project that uses git itself for content has *two* repos and they're different. Without this section, agents conflate them.
4. **§8 When to stop and ask**. Explicit policy on what authorisation looks like. Replaces case-by-case judgment with a fixed list of triggers.
5. **§9 "Things that look fine but aren't"** — accumulated traps with rationale. This is the most valuable section in practice; it's where bug-prone shortcuts get pre-empted.
6. **§10 Quick reference table** — backend column / frontend column / per-row tooling. Linked to from inside other sections.
7. **Conventional Commits with examples** — gives the agent concrete patterns rather than rules-without-examples.

**Project-specific bits**:
- The 6 R-rules (R1–R6) — these are libreta-specific (markdown round-trip, filesystem-truth, etc.)
- Backend conventions citing pygit2, FastAPI, uv
- Frontend conventions citing Tiptap, Vite, pnpm
- The Things-that-look-fine list

**Universal bits**:
- 10-section structure.
- Inviolable-rules section format: `### R-N. Title.` + reference to a P-principle + explanation + examples of what to push back on.
- Pre-flight checks subsection per layer.
- Conventional Commits convention (lowercase scope).
- "Two distinct git contexts" callout — universal whenever the project itself uses git for user content.
- "When to stop and ask" trigger list.
- "Things that look fine but aren't" accumulated-traps section.
- Quick reference table format.

**Dependencies**: References PROJECT.md (principles), ARCHITECTURE.md, ROADMAP.md, PROGRESS.md.

---

### 1.7 `README.md` 🟢

**What**: Project front page. Tagline → status line linking to PROGRESS/ROADMAP → "Why this exists" with comparison table → Quickstart (3 commands) → Dev vs prod table → Useful Make targets → Features list → Documentation index table → License.

**Why it works**:
1. **Tagline-first**. Reader knows in one sentence whether to keep reading.
2. **Status line links to PROGRESS and ROADMAP**. The README is a stable doorway; the dynamic state is one click away.
3. **Comparison table** ("why this exists vs alternatives") is a strong scope-defense and motivator. Same shape as the non-goals section in PROJECT.md but reader-facing.
4. **Three-command quickstart**. Anything more is a deploy guide, not a quickstart.
5. **Dev vs prod table** acknowledges that there are two ways to run, side by side.
6. **Documentation index table** — every doc has a one-line "what's there" summary. Reader can route to the right one without reading them all.

**Project-specific bits**: Comparison table contents, tagline, quickstart commands.

**Universal bits**:
- Tagline → status → "Why this exists" → Quickstart → Dev/prod → Features → Docs index → License structure.
- The docs-index-table format with a "What's there" column.

---

## Layer 2 — Operations

### 2.1 `Makefile` 🟢

**What**: Single-command task runner for the whole project. 30+ targets organized into sections: install / dev / pre-flight checks / format / lint / typecheck / test / build / docker compose lifecycle / clean / import (project-specific) / versioning + release.

**Why it works**:
1. **`.DEFAULT_GOAL := help`** + the `awk` help generator that parses `## comment` syntax. `make` with no args prints a categorized menu. The `## comment` convention is enforced by the parser, so help stays accurate.
2. **`make check` aggregates format + lint + types + tests** for both backend and frontend. The single command means "did I finish?" has one answer.
3. **Section dividers as comments** (`# ---------- install ----------`) make the file readable as documentation.
4. **Versioning targets are scripted** (`make version`, `make version-bump LEVEL=patch`, `make version-set NEW=X.Y.Z`, `make sync-version`, `make build-prod`, `make release`). The release path is one command.
5. **Compose invocation cached as a variable** (`COMPOSE_DEV := docker compose -f docker-compose.yml -f docker-compose.dev.yml --profile dev`). Long invocations live in one place.
6. **Each per-language target has a per-language sub-target** (`make format`, `make format-backend`, `make format-frontend`). You can run all or just one half.
7. **Args via Make variables** (`make import-dokuwiki SOURCE=/path` / `make version-bump LEVEL=patch`). Documented in the help text.

**Project-specific bits**:
- BACKEND/FRONTEND directory names
- Image names (`libreta-api`, `libreta-frontend`)
- Import targets (project-specific scripts)
- Specific dev-server ports

**Universal bits**:
- The whole structure: `.DEFAULT_GOAL := help`, awk help generator, section comments, `check` aggregator, two-layer per-language targets.
- Versioning targets pattern: `version` / `sync-version` / `version-bump LEVEL=` / `version-set NEW=` / `build-prod` / `release`.
- Compose invocation variable.

---

### 2.2 `docker-compose.yml` family 🟢

**What**: Layered compose files.
- `docker-compose.yml` — base. All services. Defines volumes. Production-default settings.
- `docker-compose.dev.yml` — dev overlay. Bind-mounts source, runs reloader, sets PYTHONPATH workaround.
- `docker-compose.prod.yml` — prod overlay. Pins image to `:${VERSION}`, adds frontend nginx service, exposes public port.
- `docker-compose.caddy.yml` — TLS overlay. Drops public port from frontend, adds Caddy with HTTP/3 + Let's Encrypt.

**Why it works**:
1. **Overlays compose left-to-right** — `docker compose -f base -f overlay`. Each overlay is a focused concern (dev / prod / TLS) and they can be combined or omitted.
2. **Base file is production-default**. Without overlays, you get a sensible production stack. Dev mode is opt-in via overlay.
3. **`profiles:` for dev-only services**. The `frontend` Vite container has `profiles: [dev]` so it's not started in prod by accident.
4. **Named volumes, never bind-mounts for state**. The single `libreta-data` volume holds everything stateful (clones, ssh keys, meta). Backups have one target.
5. **Comments in each overlay file explain what the overlay does and how to invoke it**. Self-documenting.
6. **Caddy overlay uses `ports: !reset []`** — surgical removal of the base file's port mapping. Replaces it with `expose:` for internal-only access.
7. **`caddy-data` volume noted as separately backupable** — operator awareness baked into comments.

**Project-specific bits**:
- Service names (api, frontend, drawio)
- Image names
- Specific env vars (`LIBRETA_*`)
- Specific port numbers (8091/8092/8093)
- The `LIBRETA_DRAWIO_URL` browser-reachability comment (drawio-specific)
- The absolute host-mount line (dev-only, accidentally absolute)

**Universal bits**:
- Four-file overlay pattern: base + dev + prod + caddy.
- `profiles:` for dev-only services.
- Single named volume for stateful data.
- `${VERSION:-latest}` pinning in prod overlay.
- `pull_policy: never` in prod overlay until a registry is wired.
- Caddyfile.example with `email`, `encode`, `request_body max_size`, `reverse_proxy` template.
- `ports: !reset []` + `expose:` pattern in TLS overlay.

⚠️ **Bug to fix in template**: the absolute host path bind-mount (`/abs/host/path:/abs/host/path`) is libreta-specific dev convenience and would be a bootstrapping disaster. Drop in template.

---

### 2.3 `VERSION` + `scripts/sync_version.py` 🟢

**What**: Plain-text top-level `VERSION` file with a single semver string. Python script that reads it and propagates to `backend/pyproject.toml` and `frontend/package.json`. Supports `--print`, `--bump {major,minor,patch}`, `--set X.Y.Z`. Wired into Makefile targets.

**Why it works**:
1. **One source of truth** — `VERSION` file. Everything else is derived.
2. **Idempotent script**. Running it twice with no changes is a no-op. Safe to run on every checkout if needed.
3. **Strict semver regex** rejects non-semver values rather than silently misbehaving.
4. **Strict propagation** — pyproject.toml regex update, package.json JSON parse + write. Each target file's idiom respected (TOML stays TOML, JSON stays JSON).
5. **`make release` chains** version-bump → build-prod → git tag. One command, reversible if it errors mid-way.
6. **Shell scripts read it via** `$(cat VERSION)` — lowest-common-denominator integration. No version-management framework needed.

**Project-specific bits**:
- Files updated: `backend/pyproject.toml`, `frontend/package.json` (which subdirs depending on stack).

**Universal bits**:
- Top-level `VERSION` file.
- The script (≈140 lines, single-file, stdlib-only).
- The Makefile targets (`version`, `sync-version`, `version-bump LEVEL=`, `version-set NEW=`, `release`).
- Build flow: bump → propagate → build → tag.

---

### 2.4 `scripts/` 🟢 as a pattern

**What**: One-off utilities that aren't part of the runtime. Libreta has 7:
- `compute_tags.py` — one-shot maintenance over the wiki corpus.
- `import_apple_notes.py`, `import_dokuwiki.py` — migration importers.
- `migrate_to_sidecars.py`, `rewrite_sidecar_refs.py` — data migration scripts (one-time, kept for repeatability).
- `smoke_bench.sh` — performance smoke test.
- `sync_version.py` — release tooling.

**Why it works**:
1. **One per script**, not one big "tools" module. Each script is self-documenting and runnable in isolation.
2. **Scripts run via Makefile targets** — discoverable through `make help`.
3. **Idempotent or `--dry-run` by default** — most scripts have a `--dry-run` flag that previews without writing.
4. **Bash + Python coexist** — bash for shell-shaped tasks (smoke_bench), Python for anything with parsing or filesystem traversal.
5. **No "scripts as part of the runtime"**. The runtime is the runtime; scripts are operator/dev tools.

**Universal bits**:
- The `scripts/` directory convention.
- Makefile target per script with a `-dry` companion where applicable.
- The convention "if it's a one-shot, put it here, don't make it part of the app."

**Template approach**: don't ship project-specific scripts; ship a `scripts/README.md` template explaining the convention plus the `sync_version.py` script as the one universal include.

---

### 2.5 `.github/workflows/ci.yml` + `.gitea/workflows/ci.yml` 🟢

**What**: Two-job CI (backend + frontend), mirrored across GitHub Actions and Gitea Actions. Backend job: ruff format check, ruff lint, mypy strict, pytest. Frontend job: prettier check, eslint, vue-tsc, vitest, vite build. Single workflow file copied to both `.github/workflows/` and `.gitea/workflows/`.

**Why it works**:
1. **Identical pre-flight to local `make check`**. CI runs the same commands the developer runs locally. No CI-only behaviors.
2. **Frozen lockfiles** (`uv sync --frozen` / `pnpm install --frozen-lockfile`). CI doesn't drift the lockfile under you.
3. **Mirror rather than fork**. Gitea's `act_runner` is GH-Actions-compatible *for actions Gitea ships*. The workflow is restricted to those actions (checkout / setup-python / setup-node / pnpm/action-setup). Same file, two homes.
4. **Per-job working directory** (`defaults: run: working-directory: backend`). Eliminates `cd backend &&` in every step.
5. **Triggers on push to main and PRs to main**. No branch-name conventions assumed.

**Project-specific bits**: language-specific tools.

**Universal bits**:
- Two-job split (backend / frontend / per-component).
- Mirror-to-both-CI-providers convention.
- "frozen lockfile" rule.
- `working-directory:` per job.
- Step list mirrors `make check` exactly.

---

### 2.6 `.pre-commit-config.yaml` 🟢

**What**: pre-commit framework config. Hooks: trailing-whitespace, end-of-file-fixer, check-yaml, check-added-large-files (--maxkb=512), check-merge-conflict, ruff (--fix), ruff-format, mypy (--strict, scoped), local prettier hook, local eslint hook.

**Why it works**:
1. **Identical lint/format to CI**, just at commit time. Catches problems before push.
2. **`check-added-large-files --maxkb=512`** — single-line guard against accidentally committing a 50 MB asset. Cheap insurance.
3. **`check-merge-conflict`** — catches `<<<<<<<` markers committed by accident.
4. **Local hooks for prettier/eslint** — they run inside `frontend/` so they pick up the project's exact pnpm-installed versions, not a separately pinned mirror.
5. **`files: ^backend/`** scoping per hook — ruff doesn't inspect frontend files, etc.

**Project-specific bits**: directory names (backend/frontend), `additional_dependencies` for mypy.

**Universal bits**:
- Hook list (whitespace / EOF / yaml / large files / merge conflict).
- Tool-specific hooks scoped via `files:`.
- `check-added-large-files --maxkb=N` pattern (pick a N).
- Local hooks for tool-monorepo cases.

---

### 2.7 `.editorconfig` 🟢

**What**: Charset utf-8, LF, final-newline, trim trailing whitespace, indent_style=space, indent_size=2 default, indent_size=4 for Python, no trim trailing whitespace for Markdown (since trailing space = hard break).

**Why it works**: Cross-editor consistency without "install this plugin" ceremony. The Markdown trailing-whitespace exception is a real lesson — trim_trailing_whitespace breaks GFM hard breaks.

**Universal**: ship as-is.

---

### 2.8 `.gitignore` 🟡

**What**: Ignores macOS .DS_Store, `data/` (the user's content repo), Python caches, Node caches, editor dirs, .env*, `.claude/settings.local.json`.

**Why it works**: The "data/ is the user's wiki and it's a separate git repo, so don't accidentally commit it" pattern is explicit and important. Generalises to: any directory that is *itself* a sub-repo.

**Project-specific bits**: `data/`, `backend/data/` are libreta-specific.

**Universal bits**: Python caches, Node caches, editor dirs, `.env*`, `.claude/settings.local.json`, "ignore sub-repos that are user content."

Template will be a base `.gitignore` with placeholders for sub-repo paths.

---

## Layer 3 — Release artifacts (M5-shipping docs)

These don't necessarily exist at bootstrap. They're obligations the skill should *announce* as upcoming work.

### 3.1 `docs/BACKUP.md` 🟢 (template, populated late)

**What**: State inventory table → strategy ("lean on git for content, snapshot the rest") → backing up (one-shot + cron skeleton + what to skip) → restoring (three scenarios: single-page / lost-volume / lost-host) → verification → "verify pushes are reaching the remote" → what this doc doesn't cover.

**Why it works**:
1. **State-inventory table at top** — every backup doc should start with "what state exists, where, and is it authoritative?" Most don't.
2. **Three named scenarios** — A/B/C cover real failure modes. Operators read the one that matches their incident.
3. **Verification section** — "after restore, run these three curls." Without this, restore is theatre.
4. **"What this doc doesn't cover"** — explicit limitations. Encryption, point-in-time, cross-version.
5. **The "verify pushes are reaching the remote" sub-section** is the gem — it's the half of the strategy that's silent when working. Operators forget to check until disaster.

**Project-specific bits**: volume names, scenario specifics.

**Universal bits**: section structure (state inventory → strategy → backup → restore → verify → limitations); the three-scenario layout (single-item / lost-volume / lost-host); the verification section.

**Template approach**: include a *populated stub* with `{{TODO}}` markers. The skill should not generate this at bootstrap; it should be a milestone obligation (M5-equivalent in user's roadmap).

---

### 3.2 `docs/SECURITY-REVIEW.md` 🟢 (template, populated late)

**What**: Threat model (named adversaries + explicitly out-of-scope adversaries) → "what was audited" table (surface → files) → findings (P1/P2/P3/info, each: title-status, narrative, fix) → "what I checked but found OK" → "known limitations (deliberate, documented)" L-N → "how to reproduce" → sign-off line with date.

**Why it works**:
1. **Threat model first**. Doesn't pretend to be exhaustive — explicitly says "we do not model X."
2. **Severity scheme is small (P1/P2/P3/info)** — easy to apply.
3. **"Found OK" section** prevents future-self from rechecking the same things. Documents the *negative* result of the audit.
4. **L-N known-limitations** — separates "we know this is bad and chose not to fix" from "we hadn't thought about it." Operator-facing.
5. **Reproducibility commands** at the end — anyone can re-run the audit with one command.
6. **Sign-off date** — a security review without a date is a fiction.

**Project-specific bits**: the actual findings.

**Universal bits**: the structure (threat model → audited surfaces → findings → found-OK → known-limits → reproduce → sign-off), severity scheme, L-N format.

---

### 3.3 `docs/PERFORMANCE.md` 🟢 (template, populated late)

**What**: Cite the NFRs from PROJECT.md → reproduce-with-this-command section → results table for current date → "what this doesn't measure" (very explicit list) → "how to extend" → "when to re-run" (specific change triggers).

**Why it works**:
1. **Cite NFRs by quote** so the targets aren't abstracted.
2. **"What this doesn't measure"** — explicit honesty about a smoke test's limits. Most perf docs over-claim.
3. **"When to re-run"** — concrete triggers ("before tagging", "after change to X file", "after bumping Y dep"). Replaces a vague "rerun periodically."
4. **Smoke bench is small** — recommends folding into a real harness (locust/k6/pytest-benchmark) when it grows teeth.
5. **2× regression as early-warning threshold** — a specific number, not "any regression." Reduces false alarms.

**Universal bits**: structure, the "what this doesn't measure" callout, the "when to re-run" triggers, the 2× threshold convention.

---

### 3.4 `docs/MIGRATION-*.md` ⚪

**What**: Per-source migration guide (Apple Notes in libreta's case). Project-specific by definition. Skip on bootstrap.

**Pattern only**: capture the *shape* — "if this project supports importing, document one MIGRATION-X.md per source."

---

### 3.5 `docs/site/` ⚪ (user-facing docs corpus)

**What**: Four-page user-facing site (index, getting-started, FAQ, troubleshooting) written in the project's own markdown convention so it dogfoods.

**Pattern only**: the dogfooding move ("write your user docs in your own format") is the lesson. Skip the literal corpus.

---

## Cross-cutting observations

These are not artifacts but conventions that show up across multiple files and deserve a place in the skill.

### A. Cross-references are dense and bidirectional

ROADMAP cites PROJECT principles. PROGRESS cites ARCHITECTURE D-NNs. CLAUDE.md §1 cites both. Each doc *names* the other docs by file. This means the skill must:
- Generate filenames in a stable convention (so cross-references don't break).
- Generate the cross-references *as part of* templating, not as a "you should add these" footnote.

### B. Tables everywhere with a "Why" or "Notes" column

Tech choices, F-NN requirements, milestone status, API surface, state inventory, troubleshooting symptoms — all tabular, all with a non-mechanical column. The pattern is: don't just list, explain.

### C. Date-stamped milestones in PROGRESS, dateless in ROADMAP

Roadmap removes time pressure; progress preserves history. Symmetric and intentional.

### D. "Things deliberately deferred" language

Recurs in ARCHITECTURE ("Decisions deliberately deferred"), ROADMAP ("Beyond v1: planned but not committed"), PROJECT ("Out of scope"), README. The pattern is: enumerate what we're *not* doing, in the same place we say what we *are* doing.

### E. Pre-flight check sign-off line

Every PROGRESS entry ends with a "backend X/X tests pass, ruff clean, mypy clean. Frontend Y/Y, vue-tsc clean." line. This is a habit pattern, not a tooling pattern, but it makes each entry self-verifying.

### F. The "open questions" are first-class, with a leaning

Both PROJECT (implicitly — non-goals + future) and ARCHITECTURE (explicitly) and roadmap (M9 may never ship) and SECURITY-REVIEW (L-1..L-5 known limitations) all have "things we haven't decided / can't do yet" sections that say so plainly. The honesty is consistent.

### G. The two-repo pattern is highlighted

CLAUDE.md §6.3 calls out the project repo vs. content repo distinction explicitly because it would otherwise be a recurring bug. Universal lesson: if your project produces user-content git repos, the operating manual must distinguish them.

### H. Pre-flight checks are aggregated at the build-tool level

`make check` exists. CI runs the same. pre-commit runs a subset. The single phrase "is it green?" maps to the same answer everywhere.

### I. Comments in config files are documentation

`docker-compose.yml`, `docker-compose.dev.yml`, `Caddyfile.example` all have multi-line header comments explaining purpose, invocation, and key gotchas. The config files are read by humans first.

### J. License is chosen and rationale stated

Libreta picked AGPL-3.0-only and PROGRESS records why. The skill should make the user *make a decision* about license; default it but never silently.

---

## Summary table — what becomes what

| Libreta artifact | In skill | Notes |
|---|---|---|
| `docs/PROJECT.md` | Template (Layer 1) | 🟢 Universal shape; principles are filled by user |
| `docs/ARCHITECTURE.md` | Template (Layer 1) | 🟢 With `{{TODO}}` for diagram, components, D-NNs |
| `docs/ROADMAP.md` | Template (Layer 1) | 🟢 Milestones from user, exit-criteria pattern preserved |
| `docs/PROGRESS.md` | Template (Layer 1) | 🟢 Skeleton with status block + decisions log header |
| `docs/DEPLOY.md` | Template (Layer 1) | 🟢 Numbered-section skeleton |
| `CLAUDE.md` | Template (Layer 1) | 🟢 R-rules derived from P-principles; §6.3 included if user has user-content repos |
| `README.md` | Template (Layer 1) | 🟢 With `{{TODO}}` for tagline + comparison table |
| `Makefile` | Template (Layer 2) | 🟢 With placeholders for backend/frontend dirs and image names |
| `docker-compose*.yml` family | Template (Layer 2) | 🟢 4-file overlay, optional based on user choice |
| `Caddyfile.example` | Template (Layer 2) | 🟢 With domain placeholder |
| `VERSION` | Template (Layer 2) | 🟢 Single line `0.1.0` |
| `scripts/sync_version.py` | Template (Layer 2) | 🟢 Ship as-is, parameterized for which files it updates |
| `scripts/README.md` | Template (Layer 2) | 🟢 New file capturing the convention |
| `.github/workflows/ci.yml` + `.gitea/workflows/ci.yml` | Template (Layer 2) | 🟢 Mirrored pair, jobs per language detected |
| `.pre-commit-config.yaml` | Template (Layer 2) | 🟢 With language-specific hooks toggled |
| `.editorconfig` | Template (Layer 2) | 🟢 Ship as-is |
| `.gitignore` | Template (Layer 2) | 🟢 Base + sub-repo placeholders |
| `docs/BACKUP.md` | Pattern (Layer 3) | 🟡 Stub with `{{TODO}}` — milestone obligation, not bootstrap output |
| `docs/SECURITY-REVIEW.md` | Pattern (Layer 3) | 🟡 Stub — milestone obligation |
| `docs/PERFORMANCE.md` | Pattern (Layer 3) | 🟡 Stub — milestone obligation |
| `docs/MIGRATION-*.md` | Pattern (Layer 3) | ⚪ Skip; mention in patterns only |
| `docs/site/` | Pattern (Layer 3) | ⚪ Skip; mention in patterns only |
| `LICENSE` | Decision (Layer 2) | 🟢 User picks; skill writes the canonical text |

---

## Items that would benefit *libreta itself* if added

(These are the lead-ins to step 2's review.)

1. **No `CHANGELOG.md`**. PROGRESS captures dev log; CHANGELOG is the user-facing what-changed-in-each-release. Standard release engineering.
2. **No `CONTRIBUTING.md`**. Even solo, good for "future me, you forgot how to set up." Mostly subsumed by README + DEPLOY but lacks the "how to propose a change" angle.
3. **No `SECURITY.md`** (the GitHub disclosure file). Different from SECURITY-REVIEW.md — SECURITY-REVIEW is internal audit; SECURITY.md is "how to report a vulnerability."
4. **No `CODE_OF_CONDUCT.md`**. Mostly cargo-cult for solo projects, but if the project ever grows to PRs from outside it's expected.
5. **No `.env.example`**. `.env` is gitignored but there's no committed template showing what variables exist. The compose file partially serves this role but isn't a substitute.
6. **No `Dockerfile.dev` distinction documented**. Dev compose extends the base image with bind-mount + reloader; works fine but the Dockerfile is shared. Worth a comment.
7. **No formal ADR directory**. Inline D-NN entries in ARCHITECTURE work well, but there's a real question about whether to extract them into `docs/decisions/NNNN-title.md` (Michael Nygard format) once the count grows. Step 3 will research.
8. **No dependency policy**. Lockfiles are pinned but there's no statement of "we update dependencies at this cadence" or "we use Renovate/Dependabot."
9. **No SBOM / supply-chain stance**. SECURITY-REVIEW addresses CVE scanning but not pinned base images, image signing, or reproducible builds.
10. **No runbook** for common incident scenarios. DEPLOY.md troubleshooting is closest; a separate `docs/RUNBOOK.md` could capture "if X fails, do Y" for the things that have failed before.
11. **No accessibility (a11y) pass documented**. Frontend is responsive but there's no axe / WAVE check, no keyboard navigation audit.
12. **No observability layer**. No metrics, no structured logging convention beyond "use logging.getLogger". For a personal wiki this is fine; for the skill we should think about whether to scaffold a stub.
13. **No data-retention statement**. Privacy / GDPR-shaped. Personal projects don't need a 50-page policy but a one-liner "Libreta stores no telemetry, no analytics, no usage data" would be honest and useful.

These feed into step 2 (review) and step 3 (missing-practices research).
