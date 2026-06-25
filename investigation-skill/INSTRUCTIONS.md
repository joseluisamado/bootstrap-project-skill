# INSTRUCTIONS.md — bootstrap-investigation skill playbook

You (Claude) have been invoked as the `bootstrap-investigation` skill. The user
has just had an investigation-design conversation in this session and wants to
crystallize it into files.

An **investigation project** is one whose deliverable is *understanding plus a
durable, auditable record* — a recovery, a reverse-engineering effort, a
forensic study, a research write-up, a deep post-mortem. It is **not** software
built from source. If the user actually wants to scaffold a software project
(stack, build, deploy, CI), stop and point them at the `bootstrap-project`
skill instead — that one owns the stack-profile/deploy-model axes, the Makefile
lint/test machinery, and the code-shaped PROGRESS log.

Your job is to:

1. **Refuse if invoked cold.** If no design conversation precedes this
   invocation, stop immediately: "I need an investigation-design conversation
   before I can scaffold. Tell me the subject, the question you're chasing, the
   principles you'll hold to, and the rough phases — then invoke me again."
   Do not proceed to extraction.

2. **Extract** an investigation spec from the current conversation.

3. **Confirm** the spec with the user in a single block.

4. **Ask** for license, artifact-provenance policy, and the gates add-on.

5. **Write** the scaffold using `templates/` in this skill directory.

6. **Report** what was written and what remains for the user to fill in.

Read the rest of this document carefully before starting.

---

## 1. Verifying the conversation

Before extracting, verify these signals from earlier in the conversation:

- A project name (or working name).
- A **subject** — what is being investigated (a device, a system, a dataset,
  a question).
- A one-line description of the goal (what "done" or "understood" looks like).
- At least one principle, value, or discipline the work will hold to.
- At least a hint of phases, stages, or "what to do first."

If two or more signals are missing, refuse politely and ask the user to fill
them in before continuing.

---

## 2. Extraction

Build a spec object with these fields:

| Field | Required | Source |
|---|---|---|
| `project_name` | yes | Conversation; ask if ambiguous. |
| `project_slug` | yes | Lowercase-hyphenated `project_name`; confirm. |
| `tagline` | yes | One-line description of the goal; ask if missing. |
| `subject` | yes | What is being investigated (the device/system/question). Replaces "stack". |
| `audience` | yes | Who the record is for (future self, a team, the public); ask if missing. |
| `description` | yes | Short paragraph; derive from tagline + subject + context. |
| `mode` | yes | `learning/experimental` (risk-tolerant, no precious stakes) vs. `production-stakes` (irreversible loss possible). Sets the risk-framing tone in FOUNDATION/README. |
| `principles` | yes (≥3) | List of disciplines; if fewer than 3, ask. |
| `rules` | yes (≥1) | Inviolable rules derived from principles + the subject's failure modes. |
| `phases` | yes (≥3) | Phase 0..N investigation stages; if fewer, ask. |
| `artifact_policy` | yes | `private-archive` / `public-writeup` / `none`. Asked via AskUserQuestion in §4. |
| `use_gates` | yes (bool) | Whether to scaffold the go/no-go GATES decision log. Asked in §4. |
| `has_hands_on_sessions` | yes (bool) | Does the work involve dated hands-on sessions (lab work, runs, captures) worth a `logbook/sessions/` dir? Default yes. |
| `license` | yes | Asked in §4. |
| `user_email` | yes | For provenance/contact. From session env or ask. |

For each field, write down where you got it from (conversation, inference). If a
field is inferred rather than stated, mark it clearly when you confirm.

### Subject vs. stack

`bootstrap-project` asks "what language/framework". This skill asks "what
subject". The subject is the *thing the investigation is about* — concretely
enough that the SUBJECT.md fact-sheet has something to hold (e.g. a specific
device down to its controller, components, and revision — not just "an SSD";
a specific dataset down to its schema, origin, and version — not just "the
logs"). If the user is vague, push once for specifics; the fact-sheet is where
mis-identification gets caught early.

### Deriving rules from principles

Rules (R-N) are stricter than principles (P-N). A principle is "respect the
provenance of every artifact"; a rule is "no artifact enters the repo without a
manifest carrying its sha256 and source."

Heuristics:

- For each principle, ask: "what concrete action would *violate* this?"
- The rule is the prohibition of that action.
- Rules cite principles by number: `R1 (from P1) — ...`
- For investigations, the richest rules come from the **subject's failure
  modes**: what single mistake bricks the device / corrupts the evidence /
  invalidates the finding? Encode that as a rule. The archetype: when a wrong
  configuration value would irreversibly damage the subject, the rule is
  "the configuration must be verified against the subject's exact identity
  before any write."

Aim for 3–6 rules and 3–8 principles.

---

## 3. Confirming the spec

Print the spec in a single block and ask "ready to write, or correct anything?"
Format:

```
About to bootstrap investigation "{{project_name}}" with:

  Goal: {{tagline}}
  Subject: {{subject}}
  Audience: {{audience}}
  Mode: {{mode}}
  License: <not yet asked>
  Artifact policy: <not yet asked>
  Gates decision log: <not yet asked>

  Principles ({{N}}):
    P1 — ...
    P2 — ...
    ...

  Rules ({{N}}):
    R1 (from P1) — ...
    R2 (from P2) — ...
    ...

  Phases ({{N}}):
    Phase 0 — Identification / foundations
    Phase 1 — ...
    ...

About to ask: license, artifact-provenance policy, gates add-on.

Ready, or correct anything first?
```

If the user corrects, re-print and confirm again. Do not proceed until they say
"go" or equivalent.

---

## 4. Explicit asks

### License

Use `AskUserQuestion`. Investigation repos are often private archives, so offer
proprietary prominently:

- proprietary / all-rights-reserved (Recommended for a private archive)
- CC-BY-4.0 (Recommended for a public write-up)
- CC-BY-SA-4.0 (public write-up, share-alike)
- MIT (if helper scripts should be reusable)
- Apache-2.0 (permissive with patent clause)

The license applies to the **original written record and scripts**, not to any
third-party artifacts the repo may store (those keep their own terms — note this
in PRIVACY.md).

License-writing uses the **same SPDX-fetch mechanism** as `bootstrap-project`
(see [`../bootstrap-project/templates/licenses/README.md`](../bootstrap-project/templates/licenses/README.md)):
the skill does **not** paste canonical license text. Instead, for a chosen SPDX
license it writes a short `LICENSE` stub naming the SPDX id and a one-line
`curl` to fetch the canonical text, and records that fetch in the manifest's
"Next 30 minutes":

```
SPDX-License-Identifier: <ID>

This project is licensed under the <Name>.
Canonical text: https://spdx.org/licenses/<ID>.txt

Run once after scaffolding:
    curl -sLo LICENSE https://spdx.org/licenses/<ID>.txt
```

SPDX ids for the offered options: `CC-BY-4.0`, `CC-BY-SA-4.0`, `MIT`,
`Apache-2.0`. For **proprietary / all-rights-reserved**, write the
"All rights reserved" note (no SPDX line, no fetch) exactly as `bootstrap-project`
does. Record the chosen SPDX id (or `proprietary`) in `.bootstrap-meta.yaml`.

### Artifact-provenance policy

Use `AskUserQuestion` (single-select):

| Option | Meaning | Scaffolds |
|---|---|---|
| `private-archive` (Recommended for recoveries/RE with scarce tooling) | The repo is the durable backup; commit scarce/proprietary artifacts with per-artifact manifests; only reproducible blobs ignored. | `artifacts/README.md`, `artifacts/manifests/{_TEMPLATE.md,INDEX.md}`; "always-private" warnings in README + CLAUDE.md; `.gitignore` excludes reproducible blobs (images, dumps). |
| `public-writeup` | No proprietary blobs committed; artifacts referenced, not stored. | `artifacts/README.md` (reference-only variant), manifests optional. No private-repo warnings. |
| `none` | No artifact machinery. | Nothing under `artifacts/`. |

### Gates add-on

Use `AskUserQuestion` (single-select): "Does this investigation have hard
go/no-go decision points — a step that can terminate the project or
irreversibly damage the subject?"

- `yes — add GATES decision log` (Recommended when `mode = production-stakes`
  or any step is irreversible) → sets `use_gates = true`. The skill writes
  `plan/GATES.md` and renders `plan/ROADMAP.md` from the gated variant (each
  phase ends in a gate with a condition).
- `no — plain phased plan` → `use_gates = false`. `plan/ROADMAP.md` is the
  simple phased variant; no `GATES.md`.

### Optional small add-ons

Use `AskUserQuestion` (multiSelect) only if relevant:

- `secret-scanning-precommit` — `detect-secrets` pre-commit hook (ON if the repo
  may hold credentials/keys among evidence; otherwise OFF).
- `external-contributions` — only if the write-up is public and collaborative.

Most investigation projects need neither; skip the question if nothing applies.

---

## 5. Planning files to write

Compute the file list:

- All "always-present" files from §6.
- Conditional files based on `artifact_policy`, `use_gates`, and add-ons.
- Skip any file that already exists at the target path.

Print the planned list before writing:

```
Planning to write 19 files:
  ✓ README.md
  ✓ CLAUDE.md
  ⊘ docs/FOUNDATION.md (already exists; will skip)
  ...
```

Then write.

---

## 6. Writing files

Use the `Write` tool, never `Bash` shell redirection.

### Derived render-flags

Templates use `{{#if flag}}…{{/if}}` blocks keyed on these derived booleans.
Compute them from the spec before rendering:

| Flag | True when |
|---|---|
| `mode_is_learning` | `mode = learning/experimental` |
| `mode_is_production` | `mode = production-stakes` |
| `use_gates` | gates add-on chosen |
| `private_archive` | `artifact_policy = private-archive` |
| `public_writeup` | `artifact_policy = public-writeup` |
| `no_artifacts` | `artifact_policy = none` |
| `has_artifacts` | `artifact_policy != none` (i.e. private_archive OR public_writeup) |

And these substitution placeholders (fill from the spec / conversation):
`{{description}}`, `{{tagline}}`, `{{subject}}`, `{{audience}}`, `{{mode}}`,
`{{mode_note}}`, `{{mode_risk_prompt}}`, `{{learning_stakes_note}}`,
`{{principles_block}}` (rendered `P1 — …` list), `{{rules_block}}` (rendered
`R1 (from P1) — …` list, also used inline in CLAUDE.md as bullet rules),
`{{phases_block}}` (the ROADMAP phases — gated variant ends each phase in a
`> GATE X — <condition>` block pointing at `GATES.md`; plain variant omits it),
`{{gates_block}}` + `{{gates_summary_table}}` (per-gate sections + summary table),
`{{artifacts_map_note}}`, `{{kickoff_who}}`, `{{date_today}}`,
`{{user_email}}`, `{{license_spdx}}`, `{{license_name}}`, `{{skill_version}}`
(from this skill's `VERSION`), and the manifest tables
(`{{files_written_table}}`, `{{todo_markers_table}}`, `{{addons_yaml_list}}`,
`{{addons_list}}`, `{{principles_count}}`, `{{phases_count}}`).

For each templated file:

1. Read the template from `templates/<path>.tmpl`.
2. Render it: substitute `{{placeholder}}` values; expand `{{#if flag}}...{{/if}}`.
3. Write to the target path inside the project root.

For files copied verbatim (`.editorconfig`, the chosen `LICENSE` text), skip
templating and copy bytes.

### Always-present files

```
README.md
CLAUDE.md
LICENSE
CHANGELOG.md
BOOTSTRAP-MANIFEST.md
.bootstrap-meta.yaml
.editorconfig            # copied verbatim
.gitignore
docs/PROJECT.md          # vision, principles P-N, rules R-N, audience
docs/FOUNDATION.md       # the deep briefing / original problem statement
docs/PROCEDURE.md        # the method/runbook (fills in as it's validated)
docs/SUBJECT.md          # the subject fact-sheet (catches mis-identification)
docs/WRITEUP.md          # the narrative (starts as an outline)
docs/PRIVACY.md          # provenance + privacy + third-party-terms posture
plan/ROADMAP.md          # phased plan (gated variant if use_gates)
logbook/LOG.md           # append-only dated journal, newest at bottom
logbook/TEMPLATE.md      # entry format
evidence/README.md       # what goes in evidence/, naming convention
sources/README.md        # the source/reference index
```

### Conditional files

| Condition | Files |
|---|---|
| `use_gates = true` | `plan/GATES.md`; `plan/ROADMAP.md` rendered from the gated variant (phases end in gates) |
| `has_hands_on_sessions = true` | `logbook/sessions/.gitkeep` |
| `artifact_policy = private-archive` | `artifacts/README.md` (committed-archive variant), `artifacts/manifests/_TEMPLATE.md`, `artifacts/manifests/INDEX.md` |
| `artifact_policy = public-writeup` | `artifacts/README.md` (reference-only variant); manifests dir omitted unless the user keeps any local artifacts |
| `artifact_policy = none` | (nothing under `artifacts/`) |
| `secret-scanning-precommit` | `.pre-commit-config.yaml` (detect-secrets only) |
| `external-contributions` | `CODE_OF_CONDUCT.md`, `CONTRIBUTING.md` |

### Rendering notes per file

- **README.md** — leads with the one-paragraph status, a repository map table,
  a "where to start" list, the current phase, and (if `private-archive`) a
  privacy/provenance note (per the template's shape).
- **CLAUDE.md** — "orient yourself first" pointer list (GATES if present →
  ROADMAP → LOG → PROCEDURE → FOUNDATION → SUBJECT), the logging discipline
  (log meaningful discoveries, not every turn), the subject's #1 failure-mode
  rule, the provenance rule (every artifact gets a manifest) if applicable, and
  the privacy posture. Git policy defers to the user's global prefs.
- **plan/ROADMAP.md** — phases with `[ ] [~] [x] [!]` task checkboxes. Gated
  variant ends each phase in a `> GATE X — condition` block pointing at
  `GATES.md`.
- **plan/GATES.md** — one section per gate: Condition / Why it matters /
  To close / History. A "Current position" summary table at the top
  (Gate | Guards entry to | Status | Settled by). Status values OPEN / BLOCKED
  / PASSED / FAILED.
- **logbook/LOG.md** — append-only, newest at the bottom, with a header
  explaining the discipline. Seed one entry: "Project kickoff — scaffolded".
- **logbook/TEMPLATE.md** — `## YYYY-MM-DD — title` / Phase[/Gate] / Who /
  Did / Result (errors verbatim) / Artifacts / Next.
- **docs/SUBJECT.md** — a fact-sheet table: identity, key part numbers /
  versions / dimensions, known state, unknowns to resolve. This is where the
  investigation pins down exactly what it's looking at.

### Invariants when writing

- **Never write outside the project root.** Compute paths from `cwd`; refuse if
  any path resolves outside.
- **Never clobber existing files.** Read first to check existence; if it exists,
  log "skipped (exists): path" and continue.
- **Cross-references between docs use canonical relative paths** (README links
  to `docs/FOUNDATION.md`, `plan/GATES.md`, etc.). Templates encode this.
- **Dates absolute** (`YYYY-MM-DD`). Use the session's current date.

---

## 7. After writing

### Generate `BOOTSTRAP-MANIFEST.md`

Sections: Spec used (project, subject, mode, license, artifact policy, gates,
principles N, phases N) · Files written (table) · TODO markers (count by file;
search `grep -rn '{{TODO' --include='*.md'`) · Next 30 minutes.

### Generate `.bootstrap-meta.yaml`

```yaml
# Generated by bootstrap-investigation skill. Do not edit by hand.
bootstrap_skill: bootstrap-investigation
bootstrap_skill_version: {{skill_version}}
mode: investigation
generated: {{iso_timestamp}}

spec:
  project_name: {{project_slug}}
  subject: {{subject}}
  investigation_mode: {{mode}}        # learning | production-stakes
  license: {{license_spdx}}
  artifact_policy: {{artifact_policy}}
  use_gates: {{use_gates}}
  add_ons:
{{addons_yaml_list}}
```

### Print the punch list

```
Wrote {{N}} files. Manifest: BOOTSTRAP-MANIFEST.md

Next 30 minutes:
  1. git init && git add . && git commit -m "Initial investigation scaffold"
{{#if private_archive}}     (keep this repo PRIVATE — it will hold scarce artifacts){{/if}}
  2. Fill docs/SUBJECT.md — pin down exactly what you're investigating
  3. Fill docs/FOUNDATION.md — the deep briefing / problem statement
  4. Draft plan/ROADMAP.md phases{{#if use_gates}} and plan/GATES.md conditions{{/if}}
  5. Make the first logbook/LOG.md entry when you take your first real action
  6. Fill remaining {{TODO}} markers (see manifest)

Skill version: {{skill_version}}. Future versions can detect this scaffold via
.bootstrap-meta.yaml.
```

End the skill invocation here. Do not start the investigation itself; that's the
user's call.

---

## 8. Edge cases and refusals

- **Invoked in a non-empty project.** If the cwd already has more than 5 of the
  always-present files, refuse: "This directory already looks like a
  bootstrapped investigation. To re-bootstrap, delete the existing files first."
  Do not partial-write. (Retrofitting an existing investigation to this shape is
  out of scope for v0.1.0.)
- **This is actually a software project.** If extraction reveals a stack, a
  build, a deploy target, or "ship a binary/service" — stop and recommend
  `bootstrap-project`. The two skills are mutually exclusive; pick by deliverable
  (software artifact → bootstrap-project; understanding + record →
  bootstrap-investigation).
- **No clear principles.** If extraction can't find ≥3 principles/disciplines,
  ask. If the user can't produce them, refuse: "Principles are the load-bearing
  layer the rules and CLAUDE.md anchor to. Can you state 3–8, or shall we resume
  after more design discussion?"
- **Vague subject.** Push once for specifics. A SUBJECT.md with nothing concrete
  in it is the leading cause of mis-identification later. If the subject is
  genuinely unknown-yet (that's the investigation), say so explicitly in
  SUBJECT.md under "unknowns to resolve" and make resolving it Phase 0.

---

## 9. The skill's own evolution

When the skill itself is updated:

1. Bump the skill's top-level `VERSION` file. `{{skill_version}}` (used in
   `.bootstrap-meta.yaml.tmpl` and `BOOTSTRAP-MANIFEST.md.tmpl`) is sourced from
   it, so new scaffolds stamp the new version automatically.
2. Update `CHANGELOG.md` in the skill repo.
3. Keep parity with `bootstrap-project` where the two share machinery
   (license texts, `.editorconfig`, meta-file shape) so a future merged or
   cross-referencing tool stays coherent.
