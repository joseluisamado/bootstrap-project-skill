# Step 3 — Missing engineering practices

For each candidate practice, evaluated against **target shape: solo / small-team self-hosted apps** (libreta-shaped projects).

Verdicts:
- **adopt** — bake into the skill's templates by default.
- **flag** — skill asks at invoke time; opt-in.
- **mention-only** — capture in `patterns/` so the user knows it exists; skill doesn't scaffold it.
- **skip** — out of scope for this shape; would be cargo-cult.

Each entry: what it is, what it costs, what it earns, verdict + reasoning.

---

## A. Decision and design practices

### A-1. Architecture Decision Records (ADRs) as separate files

**What**: Each significant decision gets its own `docs/decisions/NNNN-title.md` file (Michael Nygard format: Context, Decision, Consequences). Numbered, immutable, superseded-not-edited.

**Cost**: One file per decision; mental overhead choosing whether something is "ADR-worthy"; link maintenance.

**Earns**: Scales past ~15 decisions. Each ADR is a self-contained context dump for the future.

**Verdict**: **mention-only**. Libreta's inline D-NN entries in ARCHITECTURE.md work well at current scale (10 entries). The skill ships the inline pattern; `patterns/adr-vs-inline-decisions.md` covers the migration trigger ("when you cross 15 D-NN entries, extract to `docs/decisions/`"). Premature for solo work.

---

### A-2. RFC / design-doc process for non-trivial changes

**What**: Before implementing X, write `docs/rfcs/NNNN-X.md` with motivation, design, alternatives. Discussed, then implemented (or not).

**Cost**: Real friction — slows down small changes. Solo developers often skip and regret it later, or write and never get reviewed.

**Earns**: Forces thinking. Makes design reversible at design time, not implementation time. Captures the "why we didn't do Y" trail.

**Verdict**: **flag**. For team-of-one, overkill. For team-of-2-3, the line between "RFC" and "PR description" blurs — a good PR description does the same job. Skill asks: "do you want an RFC process scaffolded?" Default off. If yes, generates `docs/rfcs/0000-template.md` + a CLAUDE.md note about when to write one.

---

### A-3. Threat modeling as a recurring practice (STRIDE / LINDDUN / attack trees)

**What**: Periodic structured threat-model review, not just a one-shot audit. STRIDE: enumerate Spoofing/Tampering/Repudiation/Info-disclosure/DoS/Elevation per surface.

**Cost**: 2–4 hours per pass; needs adversarial mindset.

**Earns**: Catches mismatches between what the system *protects against* and what it *should* protect against. Libreta's SECURITY-REVIEW.md is a one-shot — fine for v1.0, but doesn't repeat.

**Verdict**: **mention-only**. The SECURITY-REVIEW.md template (already in step 2) implicitly does threat modeling for the v1.0 release. `patterns/threat-modeling.md` adds: "re-run when the network surface changes, when a new auth boundary lands, or yearly — whichever first." STRIDE is overkill for the audience; the simpler libreta shape (named adversaries + explicitly out-of-scope) is the recommendation.

---

### A-4. Postmortems / lessons-learned log

**What**: When something breaks, write a short "what happened, what we learned, what we changed" doc. `docs/postmortems/YYYY-MM-DD-incident.md`.

**Cost**: 30 minutes per incident; discipline to write up "trivial" ones.

**Earns**: Compounds. The 5th time you write "foo failed because of X", you stop forgetting. Most valuable doc category over a 5-year horizon.

**Verdict**: **adopt** (lightweight version). Skill scaffolds `docs/INCIDENTS.md` as a single append-only file (not per-file directory) with a one-line "How to add an entry" recipe at the top. Per-file format is too heavy for solo. Single-file version is one entry per incident, dated, with: what broke / what fixed it / what we changed to prevent recurrence.

---

## B. Documentation practices

### B-1. Diátaxis four-tier (tutorials / how-tos / reference / explanation)

**What**: Mental model for splitting docs by user intent. Tutorials = "learning oriented"; how-tos = "task oriented"; reference = "information oriented"; explanation = "understanding oriented."

**Cost**: Conceptual overhead choosing which bucket; can feel pedantic.

**Earns**: User can find the right doc by their current intent rather than guessing.

**Verdict**: **skip**. Already addressed in step 2 review (RV-rejected). Libreta's PROJECT/ARCHITECTURE/ROADMAP/PROGRESS/DEPLOY split happens to map onto Diátaxis without naming it; adding the framework names would be ceremony. The skill's docs structure *is* Diátaxis-shaped; it doesn't need to advertise it.

---

### B-2. CHANGELOG.md (Keep a Changelog format)

**What**: User-facing per-release changelog. Sections per release: Added / Changed / Fixed / Removed / Deprecated / Security. "Unreleased" section at top.

**Cost**: One discipline ask: write CHANGELOG entry as part of every PR.

**Earns**: Releases have a coherent "what changed" doc. PROGRESS.md is dev-log; CHANGELOG is for users.

**Verdict**: **adopt**. Already in step 2 (RV-73). Skill scaffolds `CHANGELOG.md` with empty `[Unreleased]` section. `make release` reminds operator to move Unreleased → versioned heading. Single-file, low friction.

---

### B-3. README badges (build / version / license / coverage)

**What**: Image badges at the top of README — CI status, version, license, etc.

**Cost**: A handful of `![]()` lines; some users find them noise.

**Earns**: At-a-glance status for visitors (especially "is the build green?").

**Verdict**: **flag**. Step 2 RV-39. Skill asks; default off (libreta has none, operator preference). If yes, generates badges based on CI provider + license + version.

---

### B-4. CONTRIBUTING.md

**What**: How to set up dev env, run tests, propose changes. Even solo, "future me" doc.

**Cost**: One short file; lives in project root.

**Earns**: Onboarding (your future self after 6 months absence; outside contributors when they appear).

**Verdict**: **adopt**. RV-74. Short template (Setup / Pre-flight / Sending changes), pointing at CLAUDE.md and DEPLOY.md.

---

### B-5. SECURITY.md (vulnerability disclosure)

**What**: GitHub-recognized file. "How to report a vulnerability" + expected response time.

**Cost**: Minimal — one short file.

**Earns**: Anyone who finds a vuln knows where to report. GitHub also surfaces the file with a special link.

**Verdict**: **adopt**. RV-75. Default to user's email + 7-day response window; user edits.

---

### B-6. CODE_OF_CONDUCT.md

**What**: Behavioral expectations for contributors. Contributor Covenant is the standard text.

**Cost**: One file. Most users copy-paste verbatim.

**Earns**: Signal that the project has thought about it. Required-ish for projects accepting outside contributions.

**Verdict**: **flag**. Skill asks "does this project accept external contributions?" Yes → scaffold CC. No → skip.

---

### B-7. Privacy / data-retention statement

**What**: One-line or short doc: "We collect: nothing. We send: nothing. Data lives at: <path>."

**Cost**: Trivial.

**Earns**: Honest. Pre-empts questions like "does this phone home?"

**Verdict**: **adopt**. Section in README ("## Privacy") and a one-line in PROJECT.md NFRs ("No telemetry, no analytics."). For self-hosted personal apps this is table stakes and free to state.

---

### B-8. Onboarding doc / first-run experience

**What**: "What to read first" trail. README-pointers with reading order.

**Cost**: Minimal — README's docs index already does this.

**Earns**: New collaborator (or future-you) doesn't have to guess.

**Verdict**: **adopt** (minimal). README's docs-index table (libreta has it) is the onboarding doc. No separate file; tighten the convention in the README template — first column "Page", second column "What's there", third column "Read it when…".

---

## C. Operations practices

### C-1. Runbooks for incident response

**What**: `docs/RUNBOOK.md` — operational playbook for common scenarios. "If X is unhealthy, do Y."

**Cost**: Maintenance — runbooks rot if not used.

**Earns**: 3 a.m. clarity. Even solo, last-week-you forgets.

**Verdict**: **flag**. For self-hosted personal apps that aren't on-call: skip. For self-hosted services someone is running for users: valuable. Skill asks. Default off; if yes, scaffolds skeleton with one entry ("If `make ps` shows api unhealthy → check `docker compose logs api` first → if 502, restart api → if persistent, check disk space").

---

### C-2. SLOs / error budgets

**What**: Service Level Objectives — quantitative targets (99% uptime, 95th percentile <300ms). Error budget = how much you're allowed to miss.

**Cost**: Real measurement infrastructure (uptime monitor, latency stats). Discipline to honor budgets.

**Earns**: Right-sized reliability investment. Stops over-engineering.

**Verdict**: **skip**. SLOs are a team practice. Solo self-hosted: the operator is the user; "is it up?" is observable. Libreta's NFRs (200ms / 500ms targets) are the lightweight equivalent and they're *targets*, not budgets. The skill's NFR table is enough.

---

### C-3. Observability stub (structured logs + metrics)

**What**: Pre-wire structured logging (JSON or key-value), a `/metrics` endpoint (Prometheus shape), and trace-id propagation.

**Cost**: Real — adds dependencies, log volume, an extra container if you want to scrape metrics.

**Earns**: Debuggability. "Why is this slow?" answerable from logs alone.

**Verdict**: **flag**. RV-80. Skill asks. For personal projects often skipped (logs to stdout is fine); for anything you'll deploy and then forget about, valuable. If yes:
- Backend: structured logging via `structlog` (Python) or pino (Node), with a `request_id` middleware.
- `/healthz` always; `/metrics` if user opts in.
- No tracing scaffold by default — too heavy.

---

### C-4. Disaster recovery — RTO/RPO documented

**What**: Recovery Time Objective and Recovery Point Objective stated. "We can recover within X hours, losing at most Y minutes of data."

**Cost**: Trivial to write; non-trivial to *meet* — backup cadence determines RPO.

**Earns**: Backup strategy has a target to validate against.

**Verdict**: **adopt** (in BACKUP.md template). Add a top-of-doc "Targets" line: "RTO: <fill in> · RPO: <fill in>". Two short lines. User fills based on their backup cadence. For libreta-shaped projects, default suggestion: RTO = "1 hour to restore on a fresh host"; RPO = "loss of changes since last successful git push (typically seconds)."

---

### C-5. Backup verification cadence

**What**: Schedule for testing restores — a backup is fictional until you've restored from it.

**Cost**: 30 minutes quarterly to do a test restore.

**Earns**: Catches bit-rot, missed paths, broken snapshot tools.

**Verdict**: **adopt** (in BACKUP.md template). Section "## Verifying restores work" with: "Quarterly: take the most recent snapshot, restore to a throwaway host or VM, verify the smoke-test commands pass. If you haven't restored in 6 months, your backups are unverified."

---

### C-6. Health endpoints (liveness + readiness)

**What**: `/healthz` (alive — process is up), `/readyz` (ready — dependencies reachable). Distinct.

**Cost**: Two endpoints; often easy.

**Earns**: Container orchestrators behave correctly. `/healthz` says "don't kill me"; `/readyz` says "send me traffic."

**Verdict**: **adopt** (where applicable, conditional on backend stack). Skill asks "does this project have an HTTP backend?" If yes, references the convention in CLAUDE.md and ARCHITECTURE.md API table — "every backend exposes `/healthz` and `/readyz`. Use them in compose `healthcheck:` blocks."

---

## D. Release engineering

### D-1. Semantic versioning + signed tags

**What**: SemVer (major.minor.patch) + GPG-signed git tags.

**Cost**: GPG setup; one-time discipline.

**Earns**: Verifiable releases. "This tag really came from me."

**Verdict**: **adopt** SemVer (libreta already uses it). **flag** signed tags — skill asks. Most personal projects don't sign; for anything someone else might run, valuable. If yes, `make release` becomes `git tag -s` instead of `git tag -a`.

---

### D-2. Release notes (separate from CHANGELOG)

**What**: Per-release prose summary, often pasted into GitHub releases.

**Cost**: 10 minutes per release.

**Earns**: Readable narrative for users — "what's new and why."

**Verdict**: **mention-only**. CHANGELOG (D-NN release sections) is enough for solo. Pattern note: "if you publish to a registry or your audience is non-developers, consider a separate `RELEASE-NOTES.md` or GitHub release prose."

---

### D-3. Reproducible builds

**What**: Same source produces same artifact bit-for-bit. Pinned base images, pinned timestamps, deterministic packaging.

**Cost**: Real engineering effort. Locked timestamps, sorted file ordering, etc.

**Earns**: Supply-chain auditability — "I can verify the binary I'm running matches the source."

**Verdict**: **skip**. Overkill for self-hosted personal apps. The lockfiles + pinned base images give you 80% of the value at 5% of the cost. Mention in patterns/ as a pointer.

---

### D-4. SBOM (Software Bill of Materials)

**What**: Machine-readable list of every dependency + version + license. SPDX or CycloneDX format.

**Cost**: Tooling (`syft`, `cyclonedx-bom`); one-line script.

**Earns**: When CVE-2025-NNNN drops, you can answer "are we affected?" in seconds.

**Verdict**: **mention-only**. For personal projects: skip. For projects shipped to others: useful. `patterns/sbom.md` describes the trigger ("ship an SBOM if you ship binaries to others; skip otherwise") and the tooling.

---

### D-5. Pinned base images

**What**: `FROM python:3.12.7-slim-bookworm@sha256:...` instead of `FROM python:3.12-slim`.

**Cost**: Discipline to bump the digest periodically.

**Earns**: Build reproducibility; supply-chain control.

**Verdict**: **flag**. Tradeoff: digests go stale and you fall behind security patches if you don't bump. For solo work, tag-pinning (`python:3.12.7-slim`, not `:3.12-slim`) is the right balance — locked enough to reproduce, loose enough to get security patches via rebuild. Skill defaults to tag-pinning. If user wants digest pinning, opt-in flag.

---

### D-6. Image signing (cosign)

**What**: Sign container images so consumers can verify provenance.

**Cost**: cosign tooling, key management.

**Earns**: Supply-chain trust for consumers.

**Verdict**: **skip**. Self-hosted apps don't typically publish signed images. Mention in patterns/ as opt-in for projects that do publish.

---

## E. Security baselines

### E-1. CVE / dependency scanning in CI

**What**: `pip-audit`, `pnpm audit`, `cargo audit`, etc. fail the build on high-severity vulns.

**Cost**: Minimal — adds a CI step.

**Earns**: Vulnerable transitive dep gets caught at push time, not at security-review-eve.

**Verdict**: **adopt**. Already covered in step 2 RV-63. Skill scaffolds an optional `security` job in CI. Default: warn-on-medium, fail-on-high. Conditioned on stack (Python → pip-audit; Node → pnpm audit; Rust → cargo audit; etc.).

---

### E-2. Secret scanning (pre-commit + CI)

**What**: Detect API keys, private keys, passwords accidentally committed. Tools: `detect-secrets`, `gitleaks`, `trufflehog`.

**Cost**: Pre-commit hook adds a few seconds; CI step adds half a minute.

**Earns**: Catches the most common security mistake before it lands.

**Verdict**: **adopt**. Step 2 RV-65. Skill adds `detect-secrets` to pre-commit. Optional CI job to also scan history (`gitleaks` or `trufflehog`).

---

### E-3. Static security analysis (SAST)

**What**: `bandit` (Python), `semgrep`, etc. — patterns known to be insecure.

**Cost**: Noisy. False-positive rate high in early projects. Suppressing requires comments.

**Earns**: Catches obvious "you wrote `pickle.loads(user_input)`" bugs.

**Verdict**: **flag**. Useful but noisy. Default off; skill asks. If yes, `bandit` for Python, `semgrep` for general.

---

### E-4. Content Security Policy (CSP) headers

**What**: HTTP `Content-Security-Policy` header restricts what the browser will execute and load.

**Cost**: Real — debugging "why does my page look broken?" when CSP blocks something legitimate.

**Earns**: Defense in depth against XSS.

**Verdict**: **mention-only**. For self-hosted personal apps with no untrusted content (libreta-shaped), risk is low. `patterns/csp.md` covers when to add: "Add CSP when accepting content from untrusted sources, when the project will be used by people other than the operator, or when wrapping anything externally embedded (iframe, third-party script)."

---

### E-5. Subresource Integrity (SRI) for CDN-loaded assets

**What**: `<script integrity="sha384-...">` — browser refuses to load script if hash doesn't match.

**Cost**: Update hash when CDN file changes (rare).

**Earns**: Supply-chain protection for CDN-loaded assets.

**Verdict**: **skip**. Libreta's R5 forbids CDN-loaded runtime assets. Skill should reinforce that pattern (no public-CDN dependencies at runtime); SRI becomes irrelevant.

---

## F. Testing practices

### F-1. Testing pyramid (unit / integration / e2e)

**What**: Mostly unit tests, fewer integration, few e2e. Each level slower and broader than the one below.

**Cost**: Discipline. Tempting to write only the level you're comfortable with.

**Earns**: Test runtime stays manageable. Layered confidence.

**Verdict**: **mention-only**. Libreta has unit + integration; e2e (Playwright) is mentioned in CLAUDE.md but not heavily used. The skill's CI template runs unit + integration; e2e is per-project. `patterns/testing-pyramid.md` covers the convention: tests live in `tests/unit/`, `tests/integration/`, `tests/e2e/` (per stack); CI runs unit always, integration always, e2e in a separate job that may be slow.

---

### F-2. Property-based testing

**What**: Hypothesis (Python), fast-check (JS) — generate random inputs, assert invariants hold.

**Cost**: Learning curve. Test runtimes vary.

**Earns**: Catches edge cases humans miss. Excellent for parsers, serializers, anything with invariants.

**Verdict**: **mention-only**. Libreta would benefit (the markdown round-trip is *defined* by an invariant) but doesn't use it. Pattern doc mentions: "If you have a serializer, parser, or anything with a 'roundtrip should be identity' shape, use Hypothesis-style testing."

---

### F-3. Snapshot testing

**What**: Record output once, fail if it changes. Common in frontend (Jest snapshots, Vitest).

**Cost**: Snapshot rot. Tempting to "just update snapshots" without thinking.

**Earns**: Cheap regression coverage for output-heavy code.

**Verdict**: **mention-only**. Use case-dependent. Pattern note about when to use vs. when to avoid (avoid when the output is supposed to change frequently).

---

### F-4. Coverage thresholds

**What**: CI fails if test coverage drops below X%.

**Cost**: Game-able. Engineers write nominal tests to hit coverage without testing meaningfully.

**Earns**: Visible signal when tests stop being added alongside code.

**Verdict**: **skip**. The metric is more harmful than helpful. Pattern note: "Track coverage if you want to *see it*; do not gate CI on it."

---

### F-5. Mutation testing

**What**: Mutate the source code, run tests, check which mutations the tests catch. Truer signal than line coverage.

**Cost**: Slow. Adds 5–10× test runtime.

**Earns**: Real signal about test quality.

**Verdict**: **skip**. Overkill for self-hosted personal apps. Mention in patterns/ for completeness.

---

## G. Frontend / UX

### G-1. Accessibility (a11y) — automated checks

**What**: `axe-core`, `pa11y`, Lighthouse a11y score. Often integrated into vitest/playwright.

**Cost**: Adds CI time. Some false positives.

**Earns**: Catches the most common a11y bugs (missing labels, contrast, keyboard traps).

**Verdict**: **flag**. Conditional on the project having a frontend. If yes, skill asks "scaffold a11y checks?" Default on for any user-facing UI. Adds an axe-core integration test that runs against the built bundle.

---

### G-2. Internationalization (i18n)

**What**: Externalize all user-facing strings to a translation layer.

**Cost**: Real — every string change is now a two-file change.

**Earns**: Multi-language support.

**Verdict**: **flag**. For solo personal apps in one language: skip. For projects that *might* go multi-language: opt-in scaffolding (i18n library wired, English `en.json` populated). Skill asks; default off.

---

### G-3. Performance budgets (frontend bundle size)

**What**: CI fails if JS bundle exceeds N KB. `webpack-bundle-analyzer`, `bundlesize`.

**Cost**: Adds CI step.

**Earns**: Bundle bloat caught at PR time.

**Verdict**: **mention-only**. For self-hosted single-user apps: low value (you control the network path). Pattern note about when to enable.

---

### G-4. Visual regression testing

**What**: Screenshot every page, diff on PR.

**Cost**: Real infrastructure (Percy, Chromatic, or self-hosted).

**Earns**: Catches accidental visual breakage.

**Verdict**: **skip**. Overkill for self-hosted personal apps.

---

## H. Workflow

### H-1. Trunk-based development + feature flags

**What**: Single long-lived branch. Risky changes hidden behind feature flags.

**Cost**: Feature-flag infrastructure.

**Earns**: Continuous integration; no long branches.

**Verdict**: **skip** for solo (no branches to integrate). **mention-only** otherwise. Solo work is naturally trunk-based.

---

### H-2. Pre-commit hooks (already addressed)

Already covered. Skill ships pre-commit config.

---

### H-3. Code review checklist (even solo)

**What**: Before pressing merge, run through a checklist (tests added, docs updated, CHANGELOG updated, perf considered).

**Cost**: 2 minutes per merge.

**Earns**: Habit. Catches "I forgot to update the docs" reliably.

**Verdict**: **adopt** (lightweight). Skill adds a "Pre-merge checklist" subsection to CLAUDE.md §3.3 / §4.3 (alongside pre-flight checks). Five bullets: tests pass, types pass, lint clean, CHANGELOG entry added if user-visible, docs updated if behavior changed.

---

### H-4. Issue templates / PR templates

**What**: GitHub `.github/ISSUE_TEMPLATE/` and `PULL_REQUEST_TEMPLATE.md` for structured reports.

**Cost**: One-time setup.

**Earns**: Better-formed issues.

**Verdict**: **flag**. Conditional on "accepts external contributions". Default off.

---

### H-5. Renovate / Dependabot / mend

**What**: Bot opens PRs to bump dependencies.

**Cost**: PR noise. Discipline to triage.

**Earns**: Dependencies don't go stale; CVEs get patched without manual work.

**Verdict**: **flag**. Skill asks. Default on for projects with a long horizon; off for short-lived ones.

---

## I. Process

### I-1. Definition of Done (per-task checklist)

**What**: Explicit checklist for "is this task done?" — tests added, docs updated, etc.

**Cost**: Bureaucratic for solo; redundant with milestone exit criteria + pre-flight checks.

**Earns**: Marginal — already covered by the existing patterns.

**Verdict**: **skip**. Already in step 2 (RV-18). The roadmap exit criterion + the pre-merge checklist (H-3) cover this without adding ceremony.

---

### I-2. Roadmap "kill criteria"

**What**: Each milestone has both exit criteria *and* kill criteria — "if this is true, stop work and re-plan."

**Cost**: Mental discipline.

**Earns**: Permission to abandon. Sunk-cost defense.

**Verdict**: **adopt** (lightweight). ROADMAP template has each milestone optional add a "**Kill criteria**:" line. Often left blank — only fill when the milestone is genuinely uncertain. Useful for "explore X" milestones.

---

### I-3. Quarterly review / retrospective

**What**: Every 3 months, review what shipped, what didn't, what to adjust.

**Cost**: Half a day quarterly.

**Earns**: Strategic correction. Roadmap stays honest.

**Verdict**: **mention-only**. Pattern doc note: "Once a quarter or every 3 milestones (whichever first), append a 'Review' section to PROGRESS.md: what shipped, what slipped, what to adjust." Lightweight enough not to be a separate doc.

---

## J. Stack-shaped practices (depend on project stack)

These aren't universal but shape what the skill scaffolds.

### J-1. Backend framework conventions

Skill detects (or asks) backend framework: FastAPI / Flask / Express / Gin / Axum / Rails / Django / etc. Conventions vary; the skill won't bake in any single framework.

**Verdict**: **mention-only at core**. Stack-specific templates would be a layer on top (deferred per step 1's user choice "generic discipline core").

---

### J-2. Frontend framework conventions

Same as J-1. Vue 3 / React / Svelte / SolidJS.

**Verdict**: **mention-only at core**.

---

### J-3. Database and migration tooling

Alembic / migrate / sqlx / etc. Hugely opinion-dependent.

**Verdict**: **mention-only at core**. Pattern doc: "If your project has a database, you need a migration tool. Pick one before writing the second migration."

---

## K. Culture

### K-1. Blameless postmortems

**What**: Postmortems focus on systems and processes, not individuals.

**Cost**: Mindset.

**Earns**: People report incidents instead of hiding them.

**Verdict**: **mention-only**. For solo, irrelevant. For team, important. Pattern doc references it as a heading in the INCIDENTS.md template.

---

### K-2. Decision-making processes (consensus, RACI, advice process)

**What**: Explicit "who decides" framework.

**Cost**: Process overhead.

**Earns**: Clarity on authority.

**Verdict**: **skip**. Solo / small-team self-hosted: the operator decides. Heavier processes are out of scope.

---

## Summary of step 3 verdicts

### Adopt (15)
- Lightweight ADR pattern: stay inline, migrate at 15 entries (A-1 mention-only with trigger)
- INCIDENTS.md as single-file append-only log (A-4)
- CHANGELOG.md (B-2)
- CONTRIBUTING.md (B-4)
- SECURITY.md disclosure (B-5)
- Privacy/no-telemetry statement in README + PROJECT.md NFRs (B-7)
- Onboarding via README docs-index "Read it when…" column (B-8)
- RTO/RPO line in BACKUP.md (C-4)
- Backup-verification cadence section in BACKUP.md (C-5)
- `/healthz` + `/readyz` convention (C-6)
- SemVer (D-1, already in libreta)
- CVE scanning in CI as opt-in default (E-1)
- Secret-scanning pre-commit (E-2)
- Pre-merge checklist in CLAUDE.md (H-3)
- Roadmap kill-criteria as optional line (I-2)

### Flag (skill asks at invoke time, ~10)
- RFC process scaffold (A-2)
- README badges (B-3)
- CODE_OF_CONDUCT.md (B-6)
- RUNBOOK.md (C-1)
- Observability stub (C-3)
- Signed tags via GPG (D-1 sub-flag)
- Digest-pinned base images (D-5)
- SAST tooling (E-3)
- a11y automated checks (G-1)
- i18n scaffold (G-2)
- Issue/PR templates (H-4)
- Renovate/Dependabot (H-5)

### Mention-only (in patterns/, ~12)
- ADR-vs-inline-decisions migration trigger (A-1)
- Threat-modeling cadence (A-3)
- Diátaxis naming (B-1) — *intentionally not adopted*
- Release notes separate from CHANGELOG (D-2)
- SBOM (D-4)
- Image signing (D-6)
- CSP headers (E-4)
- Testing pyramid layout (F-1)
- Property-based testing (F-2)
- Snapshot testing (F-3)
- Performance budgets (G-3)
- Quarterly review (I-3)
- Stack-shaped practices (J-1..J-3)
- Blameless postmortems (K-1)

### Skip (10)
- SLOs / error budgets (C-2)
- Reproducible builds (D-3)
- SRI for CDN assets (E-5)
- Coverage thresholds (F-4)
- Mutation testing (F-5)
- Visual regression testing (G-4)
- Trunk-based + feature flags (H-1)
- Definition of Done (I-1)
- Decision-making frameworks (K-2)
- Premature ADR directory (covered by A-1)

---

## Net effect on the skill

Step 1 had ~30 templates. Step 2 added ~20 modifications/additions. Step 3 adds ~15 more practices the skill bakes in by default and ~10 it offers as flags. The skill's surface grows, but each addition is justified and shipped with sensible defaults.

The skill's invocation conversation now needs to surface (at least implicitly):
- Stack profile (RV-87)
- License choice (RV-78)
- Whether to scaffold release-artifact stubs at bootstrap (RV-71)
- Whether to scaffold optional flags from this step (RFC, badges, CoC, runbook, observability, signed tags, digest pinning, SAST, a11y, i18n, issue templates, dep-bot)

That's a lot of questions. **Mitigation**: skill asks the *minimum* set (stack profile, license, "any optional add-ons?") and infers the rest from sensible defaults. The full menu is exposed via a "show me all options" path; the default path produces a sane scaffold without 12 prompts.

---

## Hand-off to step 4

Step 4 synthesizes everything into a final design: `04-final-design.md`. That doc fixes:

- The exact file tree the skill writes.
- The exact questions the skill asks (and which it infers).
- The exact `SKILL.md` + `INSTRUCTIONS.md` shape.
- The exact `templates/` and `patterns/` contents.
- The `BOOTSTRAP-MANIFEST.md` format.
- The `.bootstrap-meta.yaml` shape (skill version tracking, RV-91).
- The `install.sh` behavior.

Then step 4 writes the actual templates and patterns files into `skill/`, ready for review.
