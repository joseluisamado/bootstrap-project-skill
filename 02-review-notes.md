# Step 2 — Review notes

Critical pass over `01-libreta-inventory.md`. For each artifact, I ask:

1. **Does the libreta version have rough edges that should be smoothed before templating?**
2. **Is the structure too rigid for projects that aren't shaped exactly like libreta?**
3. **Are cross-references brittle?**
4. **What's libreta-specific masquerading as universal?**
5. **What would the skill add to make this *better* than libreta?**

Reviews are organized as **Findings** (numbered RV-NN, "review-finding"), each with a **status**: `keep-as-is` / `improve` / `drop` / `add` / `decide-with-user`.

The 13 "items that would benefit libreta itself" from step 1 are absorbed into the relevant findings rather than listed separately. New ones surfaced during this pass are added to the list.

---

## Layer 1 — Documentation

### `docs/PROJECT.md`

**RV-01 (improve)** — *The "must / should / future" triage is good but slips into "Goals" instead of being the primary axis.* Libreta's structure is "Goals" → "Must have (v1.0)" → "Should have (v1.x)" → "Future (v2+)". The future bucket competes with ROADMAP's "Beyond v1" section and they drift. **Fix in template**: keep must/should as `Goals → v1.0 / v1.x`, drop "v2+" entirely from PROJECT.md and route everything beyond v1 to ROADMAP. PROJECT.md is constitutional; planning lives in ROADMAP.

**RV-02 (improve)** — *F-NN table mixes "must" and "should" in one table with a Priority column; works but harder to scan.* **Fix**: keep one table; add column ordering `ID / Requirement / Priority` consistently; sort by Priority then ID. Tiny improvement, big readability win.

**RV-03 (decide-with-user)** — *Comparison table belongs in README, not PROJECT.md.* PROJECT.md says "Background" with the comparison; README also has it. Either deduplicate or pick one home. **Lean**: comparison lives in README (reader-facing). PROJECT.md "Background" becomes a short narrative without a table.

**RV-04 (add)** — *No explicit "Audience" line.* "Who is this for?" is missing. A one-line audience statement at the top (e.g. "Audience: a single self-hoster who wants their personal wiki to outlive any tool") sharpens scope. **Add as the first paragraph after Vision.**

**RV-05 (improve)** — *NFRs use specific numbers without dating them.* "Page loads under 200 ms on a Pi 4" is good but the date this target was set is missing — by year 3, a Pi 4 might be a Pi 5 and the number stale. **Fix**: stamp NFR targets with `(set: YYYY-MM-DD)` so they're revisitable.

**RV-06 (keep-as-is)** — Principles-as-decision-rules framing is the doc's best feature. Don't touch.

**RV-07 (keep-as-is)** — "Out of scope" + "Non-goals" being separate sections is intentional and correct. Non-goals are forever; out-of-scope is for-this-version.

---

### `docs/ARCHITECTURE.md`

**RV-08 (improve)** — *D-NN inline format is good but doesn't scale past ~20 entries.* Libreta is at D-10 and counting. When the count crosses ~15 the doc becomes hard to navigate. **Decision for skill**: support both modes — start with inline D-NN; add a guidance note "if you cross 15 entries, extract to `docs/decisions/NNNN-title.md` (Michael Nygard ADR format) and leave a 1-line summary inline." Don't force ADRs from day one — premature for solo work.

**RV-09 (improve)** — *Tech-stack table has a "Why" column but several rows say things like "User preference" or "Familiar territory".* This is honest but not load-bearing reasoning that survives. **Fix in template**: header guidance says "If your reason is 'familiarity', say so but also list a *specific* property of this tool that mattered. 'I know it' is not a tech-choice rationale; 'I know it AND it has good async support' is."

**RV-10 (improve)** — *"Decisions deliberately deferred" lives inside Tech choices; should be its own subsection.* Decisions to defer are scattered (Tech choices, Auth section, Open questions). **Fix**: one consolidated "Deferred decisions" subsection right before "Open questions". Open questions = "we don't know"; Deferred = "we know but chose not to decide yet."

**RV-11 (add)** — *No "Trust boundaries" subsection.* Where does data cross from trusted to untrusted (network in, filesystem out, third-party services)? Libreta's SECURITY-REVIEW.md has this in its threat model but ARCHITECTURE doesn't. **Add**: a small "Trust boundaries" subsection near the system diagram. Identifies the surfaces where security-review work will eventually focus.

**RV-12 (add)** — *No "Failure modes" subsection.* What happens when each component dies? Libreta's storage layer documents push retry but ARCHITECTURE doesn't enumerate the failure-mode catalog. **Add**: a "Failure modes" subsection with rows like `Component → What fails → User-visible behavior → Recovery`.

**RV-13 (keep-as-is)** — Mermaid diagram inline is the right move. No change.

**RV-14 (improve)** — *"Open questions" section uses "(Leaning: …)" but doesn't capture *who* is leaning or *when* they leaned.* Useful when revisiting six months later. **Fix**: format becomes `(Leaning, YYYY-MM-DD: …)`. Also: when a question is resolved, move it into the relevant section above with a date stamp — already in libreta's CLAUDE.md §7 instructions but not enforced visually. **Add**: "Resolved questions" mini-log at the bottom of the Open questions section as a one-line trail.

**RV-15 (decide-with-user)** — *D-NN entries are dated some times, undated other times in libreta.* D-09 and D-10 are dated; D-01..D-08 are not. **Decision for skill**: dating is mandatory. Template enforces it.

---

### `docs/ROADMAP.md`

**RV-16 (improve)** — *Polish-milestone insertion (M0.5, M3.5) was a real lesson but the roadmap doesn't *signal that this can happen*.* A reader looking at the roadmap doesn't know polish milestones are a normal thing to insert. **Fix**: header note above the milestone list — "Polish milestones (e.g. M2.5) may be inserted between feature milestones when real usage surfaces rough edges. They are first-class, not deviations."

**RV-17 (improve)** — *"Beyond v1" section mixes large extensions (multi-user) with small anytime items (orphan asset cleanup, mermaid editor).* These are different categories of work. **Fix**: split into "Beyond v1: planned but not committed" (real future milestones M6..MN) and "Anytime backlog" (small items that can ship between milestones).

**RV-18 (add)** — *No explicit "Definition of done" per milestone beyond the exit criterion.* "Exit criterion" is good but a single line. **Decision for skill**: the exit criterion is enough — adding a checklist on top is bureaucratic for solo work. Keep as-is. **Status: keep-as-is, noted for completeness.**

**RV-19 (keep-as-is)** — "What we will not do" closing section is the right move and should be enforced in the template.

**RV-20 (improve)** — *Milestones are marked complete with `✅ (date)` inline, but old milestones don't get a "shipped at vX.Y.Z" pointer.* Useful for archaeology. **Fix**: when a milestone closes, add `(shipped at v0.X.Y)` next to the date. Ties roadmap to release tags.

---

### `docs/PROGRESS.md`

**RV-21 (improve)** — *"Latest at top" is right but new readers can't easily find the "first" entry.* The kickoff entry is at the very bottom. **Fix**: status block at top includes a "started: YYYY-MM-DD" line so the project's age is one glance away.

**RV-22 (improve)** — *Decisions log table at the bottom duplicates D-NN entries from ARCHITECTURE.* Each decision is in two places. **Fix**: PROGRESS decisions log becomes a *pointer* table (`Date | D-NN | Title | Link`) rather than a duplicate. Single source of truth = ARCHITECTURE.md D-NN entries.

**RV-23 (keep-as-is)** — "How to update this file" recipe at the bottom is excellent. Keep verbatim in template.

**RV-24 (add)** — *No "Pre-flight sign-off" template at the bottom.* Each entry uses the format consistently but the convention isn't documented. **Fix**: "How to update" section explicitly says "every entry ends with a pre-flight sign-off line in this format: `**Pre-flight**: <component> <X>/<Y> tests pass, <linter> clean. <repeat per component>.`"

**RV-25 (decide-with-user)** — *Backlog section in libreta is empty after early entries.* Reality: backlog items got moved into milestones. The empty backlog is fine but suggests the section sometimes isn't useful. **Decision for skill**: keep, with a note "Items here mean 'noticed but not yet milestone-bound'. Move into a milestone or close as won't-do; don't let the list grow."

---

### `docs/DEPLOY.md`

**RV-26 (improve)** — *§6 mixes "deploy the software" with "configure the software at runtime" (add SSH key, add git source).* These are different things; conflated they're confusing for a deployer who hasn't seen the project. **Fix**: separate "Deploy" (sections 1–5 + TLS) from "Initial setup" (sections 6+). The skill template makes this split structural.

**RV-27 (add)** — *No "minimum to verify it's working" command at the very top.* Reader has to scroll to find smoke-test. **Fix**: top of doc includes a `<60 seconds` "is it alive?" command, before prerequisites.

**RV-28 (keep-as-is)** — Numbered linear sections are right.

**RV-29 (improve)** — *Troubleshooting is symptom→cause but doesn't link to operational logs.* Where does the user look first? **Fix**: troubleshooting section starts with a "First, check:" sub-section listing the 3 things to look at (`docker compose logs api`, `make ps`, `curl /healthz`). Then symptoms.

**RV-30 (add)** — *No "production hardening checklist".* Items are scattered: "use a reverse proxy", "use the Caddy overlay", "back up". A 6-line checklist in the deploy doc puts them in one place. **Add**.

---

### `CLAUDE.md`

**RV-31 (improve)** — *R-rules are presented as "Inviolable rules" but their lifecycle isn't.* If a rule turns out to be wrong, how does it change? **Fix**: header note — "Rules are inviolable in the sense that *breaking them silently is a bug*. To change a rule, edit the principle in PROJECT.md, then update the rule here, then commit both. Never weaken a rule to make a feature land."

**RV-32 (improve)** — *§8 "When to stop and ask" is good but lacks the inverse (when *not* to ask).* Without it, agents over-ask. **Fix**: add a parallel mini-list: "Default to action when: editing files in your scope, fixing local linter/test errors, refactoring within a single file, adjusting docs to match code." Reduces ask-fatigue.

**RV-33 (keep-as-is)** — §9 "Things that look fine but aren't" is the most valuable section in practice. Template should explicitly call it out as "the place where future-you will dump traps as you find them."

**RV-34 (improve)** — *§6.3 two-repo distinction is critical for libreta but only applies if the project has user content in a sub-repo.* For projects without that pattern, the section is dead weight. **Fix**: skill conditionally includes §6.3 based on a "does this project produce user-content git repos?" flag in the design conversation.

**RV-35 (add)** — *No "How to update CLAUDE.md itself" guidance.* The doc is meant to evolve as conventions accumulate but doesn't say so. **Add**: a closing §11 "Updating this manual" — "When you find yourself correcting the same thing twice, add a Things-that-look-fine entry. When a new convention sticks for two weeks, add it to the relevant numbered section."

**RV-36 (keep-as-is)** — Quick reference table at the end is a great idea. Keep.

---

### `README.md`

**RV-37 (improve)** — *Status line at the top is informal ("Status: v1.0 release candidate.").* Slips out of date. **Fix**: status format becomes `**Status**: v{{VERSION}} — {{milestone}}`. Skill auto-fills VERSION from the file; user fills the milestone phrase. Still slips, but smaller surface.

**RV-38 (improve)** — *"Why this exists" comparison table only works for projects with established competitors.* For greenfield projects (no obvious comparison) it's awkward. **Fix**: skill asks "Does your project have a 'why not X?' angle?" — yes → comparison table; no → narrative paragraph instead.

**RV-39 (add)** — *No "Status" badge convention.* Badges (build / version / license) are standard on GitHub README; libreta has none. **Decide-with-user**: the skill could scaffold badges based on CI provider + license + version. Optional — some prefer no badges. Default off.

**RV-40 (keep-as-is)** — Documentation index table is excellent. Keep.

---

## Layer 2 — Operations

### `Makefile`

**RV-41 (improve)** — *`help` target uses `awk` to parse `## comment` syntax.* The awk recipe is opaque to first-time readers. **Fix**: add a short comment above the awk line explaining the convention. One-line, "Targets with `## description` after the colon appear in `make help`."

**RV-42 (improve)** — *Project-specific targets (`import-dokuwiki`, `compute-tags`, `import-apple-notes`) live in the same file as universal targets.* They drift in and out as features land. **Fix**: skill template has a `# ---------- project-specific ----------` section at the bottom with a comment "Add your one-shot scripts here. Each should have a `make foo` and `make foo-dry` (or equivalent) where applicable."

**RV-43 (improve)** — *No `make doctor` / `make env-check` target.* "Is my dev environment set up correctly?" is unanswered. **Add**: `make doctor` checks for required tools (docker, docker compose, language toolchain), prints what's missing, exits non-zero if anything is.

**RV-44 (improve)** — *`make release` flow does bump → build → tag but doesn't push tags or images.* Last step is manual ("Push: docker push …"). **Decide-with-user**: keep manual (libreta does, on purpose — pushing is destructive). The template should keep manual but the help text should make the manual step obvious. Add a `make release-push` target as opt-in.

**RV-45 (add)** — *No `make changelog` target.* CHANGELOG generation isn't wired. **Decide-with-user, defer to step 3 research**.

**RV-46 (keep-as-is)** — Two-layer per-language targets (`make format` + `make format-backend` + `make format-frontend`) are the right convention.

---

### `docker-compose.yml` family

**RV-47 (drop)** — *Libreta's base file has an absolute host path bind-mount (`/abs/host/path:...`).* This is a development convenience that leaked. Should never be in a template. **Drop entirely**, document as a counter-example in patterns/.

**RV-48 (improve)** — *Healthchecks are not declared in the compose file.* `docker compose ps` shows "running" not "healthy". **Add**: every service in the template gets a `healthcheck:` block with sensible defaults. For HTTP services, `curl -f http://localhost:PORT/healthz`.

**RV-49 (add)** — *No resource limits in the base file.* `mem_limit` is mentioned in DEPLOY.md operational notes but not set. **Add**: commented-out `mem_limit:` and `cpus:` blocks per service so the operator can uncomment, with sensible defaults in comments.

**RV-50 (improve)** — *Logging driver is implicit (Docker default).* For long-running deploys this means logs grow forever. **Add**: `logging:` block with `json-file` driver + `max-size: 10m` + `max-file: 5` per service.

**RV-51 (add)** — *`networks:` is implicit (single default network).* Fine for libreta; for projects with multiple service tiers (e.g. "internal" backend not exposed), explicit networks matter. **Add as commented example** in the base file: a `networks:` block with two networks (`internal`, `public`) and which services attach where. Operators uncomment if useful.

**RV-52 (improve)** — *Caddy overlay's `ports: !reset []` trick is clever but undocumented.* Anyone reading the file thinks it's a typo. **Fix**: comment above the line explains the override. Already partially commented in libreta; tighten in template.

**RV-53 (keep-as-is)** — Four-file overlay pattern (base + dev + prod + caddy) is correct.

**RV-54 (decide-with-user)** — *Image registry is not specified.* Libreta is local-builds-only (`pull_policy: never`). For projects that publish images, the skill should ask "do you publish to a registry?" and wire `image: <registry>/<name>:${VERSION}` if yes. Defaulted to local-only.

---

### `VERSION` + `scripts/sync_version.py`

**RV-55 (improve)** — *Script is parameterized for libreta's exact two-stack layout.* For Python-only or Node-only projects, it has missing-file warnings. **Fix in template**: script reads a small config (e.g. `[tool.bootstrap-version]` in pyproject.toml or a `.version-targets` file at root) listing which files to update. No code change for new stacks; add a target file.

**RV-56 (add)** — *Script supports `--bump` and `--set` but not `--prerelease`* (e.g. `1.0.0-rc.1`). For projects that release candidates, this matters. **Decide-with-user**: skip in v1 of skill; libreta doesn't use RCs and most personal projects don't. Add issue in skill backlog.

**RV-57 (keep-as-is)** — Single-file `VERSION` as source of truth is the right call.

---

### `scripts/`

**RV-58 (add)** — *No `scripts/README.md` in libreta.* Convention is implicit. **Add to template**: `scripts/README.md` describing the convention ("one script per file, idempotent, `--dry-run` flag where applicable, runnable via `make <name>`, no shared state across scripts").

**RV-59 (add)** — *No standard `scripts/setup-dev.sh` for first-time clone.* "Clone, then run this, then you're set up" is missing. **Add**: a `scripts/setup-dev.sh` template that installs pre-commit hooks, runs `make install`, prints the dev URL.

---

### CI workflows

**RV-60 (improve)** — *Two identical files in `.github/` and `.gitea/`.* Drift risk. **Fix**: keep two files (the skill ships both); add a comment at the top of both saying "This file is mirrored to `.github/workflows/ci.yml` and `.gitea/workflows/ci.yml`. Edit both or use `make sync-ci`." Provide a `make sync-ci` target that copies one to the other.

**RV-61 (add)** — *No CI step that runs `make check`.* CI duplicates the commands rather than calling the make target. Risk: drift between local and CI. **Fix**: CI step becomes `run: make check-backend` / `run: make check-frontend`. Single command, single source of truth.

**RV-62 (add)** — *No CI matrix for multiple Python / Node versions.* Libreta pins Python 3.12, Node 20. Fine for self-hosted; if the project becomes a library, matrix matters. **Decide-with-user**: skill asks "is this an application or a library?" Library → matrix; application → pinned single version (libreta's choice, sensible default).

**RV-63 (add)** — *No security/CVE scan in CI.* `pip-audit` and `pnpm audit` are run manually pre-release. **Add**: optional `security` job in CI that runs both, fails on high-severity, warns on medium. Off by default in template (noisy on personal projects); flag in the skill conversation.

---

### `.pre-commit-config.yaml`

**RV-64 (keep-as-is)** — `check-added-large-files --maxkb=512` is a critical guard that's easy to forget. Keep, default 512 KB.

**RV-65 (add)** — *No `detect-secrets` hook.* Pre-commit can scan for accidentally-committed secrets. Standard hook from the same `pre-commit-hooks` repo. **Add**: `detect-secrets` (or `detect-private-key`) hook.

**RV-66 (improve)** — *Local hooks for prettier/eslint shell out to `cd frontend &&`.* Works but is a smell. **Fix**: keep the same approach but add a comment explaining why (the hooks need the project's pinned versions, not standalone mirrors).

---

### `.editorconfig`

**RV-67 (keep-as-is)** — Ship as-is. Ten lines of universal value.

---

### `.gitignore`

**RV-68 (improve)** — *Project-specific ignores (`/data/`, `backend/data/`) are mixed with universal ones.* **Fix in template**: split into sections — `# Universal` / `# Language-specific` / `# Editor` / `# Project-specific (sub-repos, env files)` — the last section is the only one the user fills.

**RV-69 (keep-as-is)** — Including `.claude/settings.local.json` is correct.

---

## Layer 3 — Release artifacts

### `docs/BACKUP.md`, `SECURITY-REVIEW.md`, `PERFORMANCE.md`

**RV-70 (improve)** — *These three docs land at M5 (release time) but the skill should announce them as obligations from M0.* Without the obligation upfront, they get skipped. **Fix**: ROADMAP template includes a "Release artifacts (must exist before v1.0 tag)" checklist on the v1 milestone with these three docs as line items. Visible from M0.

**RV-71 (decide-with-user)** — *Should the skill *generate stubs* of these three docs at bootstrap, or only mention them as obligations?* Two options:
- **Stubs at bootstrap** — files exist on day one with `{{TODO: populate before v1.0}}` markers. Pro: visible reminder. Con: clutter, false sense of completeness.
- **Mention only** — files don't exist; ROADMAP entry says "create `docs/BACKUP.md` before v1.0".  Pro: clean. Con: easy to forget.
- **Lean**: stubs at bootstrap. The clutter is a feature — empty `BACKUP.md` is a forcing function.

**RV-72 (add)** — *No `docs/RUNBOOK.md` template.* Operational scenarios ("X is broken, do Y"). DEPLOY.md troubleshooting is closest. **Decide-with-user**: add as optional. For personal projects often unused; for anything operationally serious, valuable. Skill asks; default off.

---

## New items surfaced during review (not in step 1's "items that would benefit libreta")

**RV-73 (add)** — *`CHANGELOG.md` is missing from libreta.* PROGRESS.md is dev log; CHANGELOG is user-facing per-release. **Add to template**: `CHANGELOG.md` skeleton in [Keep a Changelog](https://keepachangelog.com/) format. `make release` should remind operator to update it.

**RV-74 (add)** — *`CONTRIBUTING.md` is missing.* Even solo, useful as "future me, here's how to set up." **Add**: short template (3 sections — Setup / Pre-flight / Sending changes) that points at CLAUDE.md + DEPLOY.md.

**RV-75 (add)** — *`SECURITY.md` (GitHub disclosure file) is missing.* Different from SECURITY-REVIEW.md. **Add**: short template — "Report vulnerabilities to <email>. Don't open a public issue. Expect a response within N days." Personal projects often skip; the skill can default it on with the user's email.

**RV-76 (decide-with-user)** — *`CODE_OF_CONDUCT.md`* — *cargo-cult for solo, expected if PRs come from outside.* Default off; skill asks if the project will accept external contributions.

**RV-77 (add)** — *`.env.example`* missing in libreta. `.env` is gitignored but no template shows what variables exist. **Add**: skill generates `.env.example` from the env vars listed in `docker-compose.yml` (parsed automatically) with `# TODO: set me` placeholders.

**RV-78 (add)** — *No `LICENSE` decision flow.* Libreta picked AGPL-3.0-only; skill should walk the user through picking. **Add**: skill asks license, writes canonical text to `LICENSE`, adds SPDX identifier to `pyproject.toml` / `package.json`. Common defaults: MIT, Apache-2.0, AGPL-3.0-only, GPL-3.0-only, "private/proprietary (no license)".

**RV-79 (decide-with-user)** — *Dependency policy* — pinning, upgrade cadence, who owns it. Libreta has lockfiles but no policy. **Lean**: skill writes a one-page `docs/DEPENDENCIES.md` covering "we use lockfiles", "we update at release boundaries", "we run `pip-audit` / `pnpm audit` before tagging." Optional.

**RV-80 (decide-with-user)** — *Observability stub* — structured logging convention, metrics endpoint, trace headers. Libreta has none. For personal projects, fine; for self-hosted services that you want to debug remotely, valuable. **Lean**: skill asks "scaffold observability stub?" — yes adds `/metrics` endpoint with Prometheus shape + structured logging via `structlog` (Python) or pino (Node).

**RV-81 (decide-with-user)** — *Data retention / privacy stance* — one-line statement. Libreta stores no telemetry. **Add**: a `docs/PRIVACY.md` (or section in PROJECT.md) — "We collect: nothing. We send: nothing. Your data lives at: <path>." Honest, useful.

**RV-82 (add)** — *No `Dockerfile` template.* Libreta has separate Dockerfiles per service; skill should scaffold them. **Add as part of stack-specific templates** (out of scope for the generic core, but the skill should know to ask).

**RV-83 (improve)** — *Cross-references between docs use relative paths that depend on directory structure.* Brittle if files move. **Fix**: skill enforces conventional locations (`docs/PROJECT.md` etc.) and templates use those paths verbatim. No flexibility = no brittleness.

**RV-84 (add)** — *No `docs/decisions/` directory option even mentioned.* See RV-08. **Add**: pattern-only — `patterns/adr-vs-inline-decisions.md` explains when to switch.

**RV-85 (decide-with-user)** — *Should the skill generate `make doctor` or `make env-check`?* Useful but tied to which tools the project uses. **Lean**: yes, generate. Detects docker / language toolchain / lockfile freshness.

**RV-86 (keep-as-is)** — *Conventional Commits convention from libreta CLAUDE.md §6.2.* Universal, ship verbatim with examples adapted to project name.

---

## Cross-cutting decisions surfaced in review

**RV-87** — **The skill needs a "stack profile" parameter** beyond the design conversation. Even being "stack-agnostic," it makes a difference whether the project has 1, 2, or N runtimes. The Makefile, CI, pre-commit, and gitignore all branch on this. Profile values: `python-only` / `node-only` / `python+node` / `go-only` / `rust-only` / `polyglot` / `none-yet`. Skill picks based on what the design conversation actually said; defaults to `none-yet` if unclear.

**RV-88** — **The skill should produce a manifest of what it generated.** A `BOOTSTRAP-MANIFEST.md` in the new project listing every file the skill wrote, what it's for, and what `{{TODO}}` markers remain. Operator-facing: "what did this scaffolding do?" Single point to look at.

**RV-89** — **The skill should output a "next 30 minutes" punch list** at the very end. Not a roadmap — a literal "do this, then this, then this": `git init`, `git add .`, write the system diagram in ARCHITECTURE.md, fill the F-NN table in PROJECT.md, set the email in SECURITY.md, etc. Short, actionable, ordered.

**RV-90** — **The skill must not write files outside the project root.** Pure hygiene rule. The output is one directory tree, no homedir touches.

**RV-91** — **Versioning of the skill itself**. The skill writes a `<project>/.bootstrap-meta.yaml` line `bootstrap_skill_version: <version>` so future-you knows which version of the skill produced these files. Tiny but useful for evolution.

**RV-92** — **The skill should skip generating files that already exist.** If you run it in a non-empty directory (say, after `git init`), it must not clobber. Each templated file: write only if absent; otherwise log "skipped (exists): path/to/file".

---

## What got rejected during review

A few candidates I considered and rejected, with reasoning:

- **Diátaxis-style docs split** (tutorials / how-tos / reference / explanation). Useful for libraries with docs sites; overkill for a self-hosted app. The PROJECT/ARCHITECTURE/ROADMAP/PROGRESS/DEPLOY split *is* a Diátaxis-shaped layout in disguise (PROJECT = explanation, ARCHITECTURE = reference, DEPLOY = how-to, README = tutorial). Don't add the Diátaxis names.

- **Issue templates** (`.github/ISSUE_TEMPLATE/`). Useful when accepting outside contributions; overhead for solo. Skill default off; mention as opt-in in patterns.

- **Renovate / Dependabot config**. Standard but opinion-dividing. Skill default off; mention in patterns/.

- **Storybook / component catalog**. Frontend-specific and stack-coupled. Out of scope for generic core.

- **Husky / lint-staged**. JS-ecosystem alternative to pre-commit framework. Pre-commit is universal across stacks; redundant to ship both.

- **Per-PR preview deploys** (Netlify, Vercel). Cloud-native conventions; libreta is self-host-first. Skip.

---

## Summary — what changes from libreta-as-is to skill-as-template

### Drop (3)
- Absolute host path bind-mount in docker-compose.yml (RV-47)
- "v2+" bucket from PROJECT.md (RV-01) — re-routed to ROADMAP
- Comparison table from PROJECT.md "Background" (RV-03) — kept in README only

### Improve (≈30 findings)
- Most concentrated in: making structural conventions explicit (date-stamps mandatory, decisions log as pointer table, polish-milestones signaled), tightening cross-references, adding "lifecycle" guidance for things that change (rules, decisions, docs).

### Add (≈20)
- New top-level docs: `CHANGELOG.md`, `CONTRIBUTING.md`, `SECURITY.md` (disclosure), `LICENSE`, `.env.example`, `BOOTSTRAP-MANIFEST.md`.
- Make targets: `doctor`, optionally `release-push`, optionally `changelog`, optionally `sync-ci`.
- Docker compose: healthchecks, log rotation, commented resource limits.
- Pre-commit: secret detection.
- CI: `make check` invocation, optional security job.
- Scripts: `setup-dev.sh`, `scripts/README.md`.
- Patterns docs: ADR-vs-inline-decisions, milestone-shape, progress-log-shape, inviolable-rules, etc.

### Decide-with-user (8)
- Comparison table or narrative in README (RV-38)
- README badges (RV-39)
- Stub release-artifact docs at bootstrap, or only as roadmap obligation (RV-71)
- `RUNBOOK.md` (RV-72)
- `CODE_OF_CONDUCT.md` (RV-76)
- Dependency policy doc (RV-79)
- Observability stub (RV-80)
- Image registry wiring (RV-54)

### Keep-as-is (≈12)
- All the load-bearing conventions: principles-as-decision-rules, F-NN tables, D-NN format, exit criteria, "what we will not do," pre-flight checks, two-layer Make targets, single-VERSION source of truth, `.editorconfig`, conventional commits.

---

## Hand-off to step 3

Step 3's research candidates (already drafted in step 1's "items that would benefit libreta itself") need to be evaluated against the skill's target shape (solo/small-team self-hosted apps). The list to research and rate:

- ADR formal vs inline (partly addressed by RV-08)
- Threat modeling as a process (partly by RV-11)
- Observability (RV-80 — needs research depth)
- SLOs / error budgets
- Runbooks (RV-72 — needs research depth)
- RFC process for non-trivial changes
- Dependency policy (RV-79 — needs research depth)
- Release engineering — semver, changelog, signed tags
- Accessibility (a11y)
- i18n
- Data retention & privacy (RV-81 — needs research depth)
- Backup verification cadence
- Disaster recovery (RTO/RPO)
- Feature flags
- Testing pyramid
- Code review checklist
- Documentation tiers (Diátaxis — already rejected)
- Onboarding doc
- Roadmap hygiene (already covered)
- Security baselines (SBOM, dep scanning, secret scanning, CSP)
- Supply chain (pinned base images, reproducible builds, image signing)
- Performance budgets
- Analytics & telemetry policy
- Definition of Done (already rejected as bureaucratic)
- Postmortems / lessons-learned log

Each will be rated **adopt / mention-only / skip** with reasoning, in step 3.
