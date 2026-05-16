# INSTRUCTIONS.md — retrofit-project skill playbook

You (Claude) have been invoked as the `retrofit-project` skill. The user
has an existing project that already has docs, code, and possibly an older
or bespoke scaffold. They want to bring it up to the `bootstrap-project`
skill standard without losing what's already there.

Your job is to:

1. **Refuse if invoked cold, or if there is no `.git/` directory.**
2. **Inventory diff** the project against the always-present file list.
3. **Extract spec** from the analysis conversation.
4. **Confirm the plan** — what gets written, rewritten, moved, deleted.
5. **Execute** in the documented order, with reference-updating on moves.
6. **Backfill CHANGELOG** from git history + any existing PROGRESS.
7. **Write `.bootstrap-meta.yaml`** with `mode: retrofit`.
8. **Generate the richer retrofit manifest.**
9. **Final compliance review.**

Read the rest carefully before starting.

---

## 1. Refusals

Refuse immediately, with a clear message, in any of these cases:

- **No `.git/` directory.** Retrofits depend on git history for two
  things: backfilling the CHANGELOG and the "everything is recoverable"
  safety net. Without git, the user is asking you to make destructive
  changes to working files with no way back. Refuse: "I need a git repo
  to retrofit safely. Run `git init && git add . && git commit -m
  'pre-retrofit snapshot'` first, then invoke me again."

- **Cold invocation (no analysis conversation in this session).** The
  spec extraction needs context about the project — what it does, who
  it's for, what its principles are, what milestones it's on. Without
  that, you'd be guessing. Refuse: "I need an analysis conversation
  before I can retrofit a project. Discuss what the project is, its
  principles, its current milestone, and its stack first, then invoke
  me again. If you'd prefer to skip the conversation, paste a summary."

- **Already-current bootstrap.** If `.bootstrap-meta.yaml` exists *and*
  its `bootstrap_skill_version` matches the current skill version *and*
  its `mode:` is `fresh`, the project is already canonical. Refuse:
  "This project was bootstrapped with the current skill version. There
  is nothing to retrofit. If you believe something is out of shape,
  point at the specific file and I'll fix it directly without the
  skill."

If `.bootstrap-meta.yaml` exists with a different version or with `mode:
retrofit`, proceed — this is a re-retrofit (intentional, to absorb
template improvements).

---

## 2. Inventory diff

Before extracting spec, walk the project and classify every file from the
bootstrap-project always-present list (see §6 of the bootstrap-project
INSTRUCTIONS.md) plus any conditional files implied by the skill's
add-ons.

For each file, classify as:

- **`missing`** — does not exist on disk.
- **`present-template-shape`** — exists and roughly matches the canonical
  template (correct headings, recognizable structure). Light editing only.
- **`present-bespoke`** — exists but in a different shape (custom
  headings, missing sections, alternative framing). Will need to be
  rewritten in place, preserving content but reslotting into canonical
  sections.
- **`present-empty-placeholder`** — exists but is empty or a stub with no
  real content. Treat as `missing` for writing purposes; flag separately
  so the user knows it's being overwritten.

Walk the *project tree* once and classify any additional files:

- **`bespoke-with-canonical-home`** — files whose content should migrate
  to a canonical template path (e.g. `docs/BOOTSTRAP.md` → `docs/DEPLOY.md`,
  or `docs/01 Foo.md` → `docs/design/01-foo.md`). Candidates for *move*
  + *content-migrate*, not *delete*.
- **`empty-deferred-phase`** — empty directories or stub packages whose
  purpose belongs to a later phase per CLAUDE.md / ROADMAP (e.g. empty
  `docker/` when deploy is library; empty `src/<pkg>/api/` when API is
  Phase 2). Candidates for *delete*, but always with the user's
  confirmation and explicit justification.
- **`preserve-as-is`** — working code, tests, fixtures, ADRs, third-party
  vendored files, `.git/`, the user's `.claude/settings*.json`. Never
  touched.

Print the inventory diff as a table:

```
File                                  Status
---                                   ---
README.md                             present-bespoke
CLAUDE.md                             present-bespoke
CONTRIBUTING.md                       missing
SECURITY.md                           missing
CHANGELOG.md                          missing (backfill from git tags + PROGRESS)
LICENSE                               missing (will ask for choice)
VERSION                               missing (will derive from pyproject.toml)
Makefile                              missing
.pre-commit-config.yaml               missing
.editorconfig                         missing
docs/PROJECT.md                       present-bespoke
docs/ARCHITECTURE.md                  present-bespoke
docs/ROADMAP.md                       present-bespoke
docs/PROGRESS.md                      present-template-shape
docs/PUBLISH.md / docs/DEPLOY.md      missing (depends on deploy_model)
docs/SECURITY-REVIEW.md               missing
docs/PERFORMANCE.md                   missing
docs/INCIDENTS.md                     missing
docs/PRIVACY.md                       missing
scripts/sync_version.py               missing
scripts/setup-dev.sh                  missing
scripts/README.md                     missing
.github/workflows/ci.yml              present-template-shape
.bootstrap-meta.yaml                  missing
BOOTSTRAP-MANIFEST.md                 missing

Project-tree extras requiring decisions:
  docs/BOOTSTRAP.md                   bespoke-with-canonical-home → docs/DEPLOY.md + scripts/setup-dev.sh
  docs/01 Some Long Name.md           bespoke-with-canonical-home → docs/design/01-some-long-name.md (will update refs)
  docker/                             empty-deferred-phase (delete? deploy_model = library)
  src/<pkg>/api/                      empty-deferred-phase (delete? CLAUDE.md forbids Phase 2 surface)
```

This table is the single most important artifact of the retrofit before
execution. The user reads it, you wait for confirmation.

---

## 3. Extracting spec

Same fields as bootstrap-project INSTRUCTIONS.md §2, plus:

| Field | Required | Source |
|---|---|---|
| (all bootstrap fields) | yes | Conversation; see bootstrap-project §2. |
| `existing_version` | yes | Read from `VERSION` if present, else `pyproject.toml` / `package.json` / `Cargo.toml`, else default to `0.1.0`. |
| `content_strategy` | yes | New question — see §4. |
| `git_remote` | optional | `git remote get-url origin` if present; used for README badges and SECURITY contact context. |

For existing principles, milestones, decisions: read the bespoke docs and
extract. Don't ask the user to retype them. If `docs/PROJECT.md` already
has 6 principles in a bespoke shape, your reshape preserves all 6 and
just reslots them under the canonical `## Principles` heading with the
"decision rules, not aspirations" framing.

If the existing docs have *more* than the canonical template covers
(e.g. a "Strategic positioning" section, a "Community strategy" section),
preserve them as sub-sections under the nearest canonical heading (e.g.
under `## Background`). Don't drop content. Don't invent canonical
headings the template doesn't have.

---

## 4. Explicit asks

Use `AskUserQuestion` for the same five questions as bootstrap-project:

1. **License** (same options as bootstrap-project §4).
2. **Optional add-ons** (same flags, same defaults). For an existing
   project, default to ON anything the project already does (e.g. if
   `.github/dependabot.yml` exists, default `dependency-bot` to ON).
3. **Deploy model** (same options). Default based on existing artifacts:
   if a `docker-compose.yml` exists at the root, default to `docker-compose`;
   if a `Cargo.toml` exists, default to `single-binary`; if it's a
   library or CLI, default to `library`. Print the inferred default.
4. **Permissions scope** — where to write the allowlist (project
   settings.json / user settings.json / don't pre-grant). Same as
   bootstrap-project.
5. **Content-preservation strategy** — *new for retrofit*:

   - **`rewrite-in-place`** (Recommended) — reshape files directly,
     trusting git for recoverability. Cleanest result.
   - **`write-alongside-with-.bak`** — write the canonical version
     next to the bespoke one as `<file>.canonical`; user merges
     manually. Safer when the bespoke shape carries content the user
     wants to preserve in a custom way.

   For most projects, `rewrite-in-place` is right. The `.bak` option
   exists for cases where the user wants visual diff control.

---

## 5. Confirming the plan

Print the plan in one block, structured as the retrofit manifest will be:

```
About to retrofit "<project_name>" with content_strategy = <strategy>:

  Files to WRITE (new):
    + LICENSE                          (placeholder; license: <choice>)
    + VERSION                          (0.2.0 — derived from pyproject.toml)
    + CONTRIBUTING.md
    + SECURITY.md                      (email: <user_email>)
    + CHANGELOG.md                     (backfilling 0.1.0 + 0.2.0 from git tags)
    + Makefile                         (python-only profile; no compose)
    + .pre-commit-config.yaml
    + .editorconfig
    + scripts/sync_version.py
    + scripts/setup-dev.sh
    + scripts/README.md
    + docs/PUBLISH.md                  (library deploy model)
    + docs/SECURITY-REVIEW.md          (stub)
    + docs/PERFORMANCE.md              (stub)
    + docs/INCIDENTS.md                (empty log)
    + docs/PRIVACY.md
    + BOOTSTRAP-MANIFEST.md
    + .bootstrap-meta.yaml             (mode: retrofit)

  Files to REWRITE (preserving content, reshaping to canonical):
    ~ README.md                        (~30 lines → template skeleton; quickstart preserved)
    ~ CLAUDE.md                        (bespoke → §1..§N template; current rules → R-N)
    ~ docs/PROJECT.md                  (bespoke → Audience/Vision/Background/Principles/.../F-NN)
    ~ docs/ARCHITECTURE.md             (bespoke → Overview/diagram/.../D-NN; D-01..D-04 extracted)
    ~ docs/ROADMAP.md                  (month-based → M0..M7 with Goal/Checklist/Exit-criteria)
    ~ docs/PROGRESS.md                 (bespoke → Status/At-a-glance/Log/Backlog/Decisions log)
    ~ pyproject.toml                   (add license SPDX; add header pointing to VERSION)
    ~ .gitignore                       (extend with cache patterns)
    ~ .github/workflows/ci.yml         (add mypy step; add security job)

  Files to MOVE (with reference-updating):
    → docs/01 Foo.md           → docs/design/01-foo.md
      Updates: src/<pkg>/scaffolding.py (1 occurrence)
    → docs/BOOTSTRAP.md        → CONTENT-MIGRATED to docs/DEPLOY.md + scripts/setup-dev.sh,
                                 then deleted

  Files to DELETE (with justification):
    - docker/                          empty; deploy_model = library
    - src/<pkg>/api/                   empty; CLAUDE.md R8 forbids Phase 2 surface in Phase 1

  Files PRESERVED unchanged:
    = src/                             (working code)
    = tests/
    = docs/decisions/                  (existing ADRs)
    = .claude/settings.local.json
    = <user-content paths>

Ready, or correct anything first?
```

Wait for "go." If the user wants to change something (e.g. "don't delete
`src/<pkg>/api/`; I have plans"), re-print and re-confirm.

---

## 6. Executing the retrofit

In this order. Each step is recoverable via git, but the order minimizes
in-flight broken states.

### 6.1 Write missing always-present files

Use the same templates as bootstrap-project (`templates/` is shared). Skip
files classified as `present-template-shape` — they're already correct.
Files classified as `present-empty-placeholder` get overwritten (no clobber
warning needed since the user saw them in the plan).

### 6.2 Rewrite bespoke docs

The hard step. For each bespoke doc:

1. Read the full existing file.
2. Read the canonical template.
3. Identify content from the existing file that maps to a canonical
   section.
4. Identify content with no canonical home — reslot under the nearest
   semantic match (often `## Background` in PROJECT.md or an extra
   sub-section under `## Components` in ARCHITECTURE.md). Never drop.
5. Add an "Open questions"/"Resolved" trail to ARCHITECTURE.md if the
   existing doc had decisions but no D-NN structure.
6. Write the rewritten file.

If `content_strategy = write-alongside-with-.bak`, write to
`<file>.canonical` instead and skip the in-place overwrite. The user
merges manually.

For PROGRESS.md specifically: if the existing file has a log, preserve
every dated entry verbatim. Add the Status block + At-a-glance table +
Decisions log around them. Add one new entry dated today describing the
retrofit itself (this is the only fresh content).

### 6.3 Move files with reference-updating

For each move:

1. Read the source file.
2. Grep the project for references to the source path (excluding `.git/`,
   `node_modules/`, `.venv/`, `dist/`, `build/`). Search both with the
   exact path and with the bare filename. Common locations: source code,
   YAML configs, markdown prompts, other docs.
3. Print the list of references that will be updated.
4. Move the file (use `Bash` `git mv` if the file is tracked; otherwise
   `Bash` `mv`).
5. Edit each referencing file to point to the new path.
6. Re-grep to verify zero remaining references to the old path.

If the move is actually a content migration into multiple new homes (as
with `docs/BOOTSTRAP.md` → `docs/DEPLOY.md` + `scripts/setup-dev.sh`),
do the writes first, then delete the source.

### 6.4 Delete with explicit justification

Each deletion was already in the plan block (§5). Execute, no prompts.
Use `rm -rf` for directories that are empty or contain only empty
`__init__.py` files; refuse to delete anything with non-trivial code (the
inventory diff should have caught this — if it didn't, treat it as a bug
in the inventory step, not a license to delete).

### 6.5 Backfill CHANGELOG

Generate `CHANGELOG.md` per Keep-a-Changelog. Sources, in order of
precedence:

1. **Existing CHANGELOG.md** — if present, preserve verbatim; only add
   a new `[Unreleased]` section for the retrofit changes if not already
   present.
2. **`git tag` + `git log <tag>..<next-tag>`** — for each annotated tag
   matching `v?\d+\.\d+\.\d+`, extract the commits since the prior tag.
   Generate a `## [X.Y.Z] — DATE` section with `### Added` / `Changed` /
   `Fixed` / etc. inferred from conventional-commit prefixes.
3. **`docs/PROGRESS.md` versioning table** — if PROGRESS has a `|
   Version | Date | Milestone |` table, cross-reference it with the git
   tags. Use the milestone descriptions to fill the `Added` section.
4. **A new `[Unreleased]` section** describing the retrofit changes
   themselves (what got reshaped, what got added, what got deleted).

If git history is too sparse to reconstruct meaningful sections, write
one section per existing version with a single "see git history" bullet,
and an `[Unreleased]` with the retrofit.

### 6.6 Write `.bootstrap-meta.yaml` with retrofit marker

```yaml
bootstrap_skill_version: <current version>
generated: <iso timestamp>
mode: retrofit
retrofit_source: <one of: bespoke, earlier-skill-version-X.Y.Z, partial-bootstrap>
spec:
  project_name: <name>
  ...
  add_ons:
    - ...
  add_ons_declined:
    - ...
```

The `add_ons_declined` field is required for retrofits so future
re-retrofits know not to re-prompt for flags the user already rejected.

### 6.7 Pre-commit baseline file

If `secret-scanning-precommit` is enabled and `.secrets.baseline` does
not exist, create an empty baseline file with the standard detect-secrets
shape. (Pre-commit will fail on first run otherwise.)

---

## 7. The retrofit manifest

Generate `BOOTSTRAP-MANIFEST.md` with the richer retrofit sections:

```markdown
# Bootstrap manifest

Generated by **retrofit-project** skill v<version> on <date>, against an
existing project.

> The companion skill `bootstrap-project` refuses to operate on non-empty
> directories. This skill is the retrofit path. Result: same canonical
> shape; same `.bootstrap-meta.yaml` semantics; preserved content.

## Spec used

<same as bootstrap-project manifest>

## Files written (new)

| Path | Purpose |
|---|---|
| ... | ... |

## Files rewritten

| Path | What changed |
|---|---|
| `README.md` | <one-line summary> |
| ... | ... |

## Files moved

| From | To | References updated |
|---|---|---|
| `docs/01 Foo.md` | `docs/design/01-foo.md` | `src/<pkg>/scaffolding.py` |
| ... | ... | ... |

## Files deleted

| Path | Replaced by / Justification |
|---|---|
| `docker/` | empty; deploy_model = library |
| `src/<pkg>/api/` | empty; CLAUDE.md R8 forbids Phase 2 surface |
| ... | ... |

## Files preserved unchanged

- `src/<pkg>/{...}`
- `tests/`
- `docs/decisions/`
- `.claude/settings.local.json`
- ...

## TODO markers

<same as bootstrap-project manifest>

## Cross-reference check

<same as bootstrap-project manifest>

## Next 30 minutes

1. **Review the diff**: `git status` then skim `git diff` per file.
   Everything is in git, so nothing is irrecoverable.
2. **Commit the retrofit** as a single docs/refactor commit:
   ```bash
   git add .
   git commit -m "chore: refactor to bootstrap-project skill standard"
   ```
3. **Verify the build**: `make doctor && make check`.
4. **Fill `{{TODO}}` markers** in stub docs (SECURITY-REVIEW, PERFORMANCE,
   PROJECT.md F-NN table if not extracted from existing content).
5. **Set up local hooks**: `./scripts/setup-dev.sh`.
6. **Re-read the new CLAUDE.md** — the constitutional layer (P-N + R-N)
   is the only material change to how you'll work day-to-day.

## Skill-version metadata

See `.bootstrap-meta.yaml`. `mode: retrofit` distinguishes this from a
fresh bootstrap. Future skill versions can detect this and offer
migrations.
```

---

## 8. Final compliance review

After everything is written, run these checks and report:

- **Always-present files present:** Every file from the bootstrap-project
  always-present list (plus add-on-conditional ones) exists.
- **No forbidden files:** Based on `deploy_model`:
  - `library` → no `docker-compose*.yml`, no `docs/DEPLOY.md`, no `docs/BACKUP.md`. Has `docs/PUBLISH.md`.
  - `docker-compose` → has the compose family, has `docs/DEPLOY.md` and `docs/BACKUP.md`. No `docs/PUBLISH.md`.
  - `single-binary` → has `docs/PUBLISH.md`. Compose family is optional (typically lives under `dev-infra/`, not at root).
- **Cross-references resolve:**
  - `grep -l docs/PROJECT.md README.md CLAUDE.md docs/*.md` → ≥1 result.
  - Same for ARCHITECTURE.md, ROADMAP.md.
- **VERSION ↔ pyproject sync:** `cat VERSION` matches `grep '^version' pyproject.toml` (or `package.json` / `Cargo.toml`).
- **Scripts executable:** `scripts/sync_version.py` and `scripts/setup-dev.sh` have +x.
- **Smoke test:** `python3 scripts/sync_version.py --print` returns the right version. `make help` parses.
- **Reference-update completeness:** For every move in the plan, re-grep
  for the old path. Zero hits expected.
- **No untracked deletions:** Every deletion appears in the manifest.

Print a green/red summary; fix or document any reds.

---

## 9. Edge cases and refusals

- **Project has `.bootstrap-meta.yaml` `mode: fresh` matching current
  version.** Refuse (see §1). Don't re-retrofit a current project.

- **Project has bespoke docs with substantially more content than the
  canonical template covers.** Preserve all content. Reslot under the
  nearest canonical heading. If a chunk truly has no home, add a
  `## Additional context` section under PROJECT.md before `## Out of
  scope` and put it there with a note: "Preserved from pre-retrofit
  PROJECT.md; consider whether to keep, split, or drop."

- **Project has user-content sub-repos (libreta pattern).** If
  `has_user_content_subrepos = true`, the same conditional CLAUDE.md
  §6.3 block applies. Detect by asking; don't infer from filesystem
  layout (false positives are too easy).

- **Project uses a stack the templates don't fully cover (Rust, Go,
  polyglot).** Render the templates with `stack_profile` set as
  documented; leave language-specific Makefile targets empty with a
  `# TODO: fill in <lang>-specific targets` comment. Don't pretend to
  generate code you can't generate.

- **`docs/decisions/` already has ADRs.** Preserve as-is. The new
  `D-NN` entries in `ARCHITECTURE.md` "Key decisions" are an inline
  alternative, not a replacement. When the inline list grows past ~15
  entries, the bootstrap-project pattern `adr-vs-inline-decisions.md`
  applies — note this in the manifest if it's already the case.

- **Existing CHANGELOG has a non-Keep-a-Changelog shape.** Don't
  rewrite it. Add a `## [Unreleased]` section at the top in
  Keep-a-Changelog format for the retrofit, and leave a note in the
  manifest: "CHANGELOG.md preserved in its existing format; new
  entries follow Keep-a-Changelog."

- **`.git/` exists but has no tags.** CHANGELOG backfill falls back to
  one `[Unreleased]` section describing the retrofit. Don't invent
  versions that were never tagged.

---

## 10. The skill's own evolution

The retrofit skill shares the `templates/` directory and the skill
version with `bootstrap-project`. They release together:

- When a template changes, both skills emit the new shape on next
  invocation.
- When the always-present file list changes, both skills handle it
  (bootstrap-project writes them fresh; retrofit-project adds them
  during the "write missing" step).
- When the spec questions change, both skills ask the new questions.

The retrofit skill's `mode: retrofit` marker in `.bootstrap-meta.yaml`
distinguishes retrofit history from fresh-bootstrap history, but is not
otherwise different — re-retrofits and migrations work the same way for
both modes.
