# bootstrap-project skill (+ retrofit-project, bootstrap-investigation)

> Three Claude Code skills that crystallize a design conversation into a complete project scaffold.
>
> - **`bootstrap-project`** writes a software-project scaffold from scratch in an empty directory.
> - **`retrofit-project`** brings an existing software project up to the same canonical shape without losing content, history, or working code.
> - **`bootstrap-investigation`** writes an *investigation/documentation* scaffold — for projects whose deliverable is understanding plus an auditable record (recoveries, reverse-engineering, forensics, research write-ups), not software built from source.

All three are **finalizers**: have the design conversation (or analysis conversation, for retrofits) as normal — vision, principles, milestones/phases, stack/subject, audience — then invoke the relevant skill to write everything down using a consistent, opinionated structure.

`bootstrap-project` and `retrofit-project` share `templates/`, the same five-question spec, and the same `.bootstrap-meta.yaml` semantics; they differ in *path* (bootstrap writes into emptiness; retrofit negotiates with existing content — see [`retrofit-skill/patterns/why-retrofit-is-different.md`](./retrofit-skill/patterns/why-retrofit-is-different.md)). `bootstrap-investigation` is the investigation **sibling**: it ships its own `templates/` and swaps the stack/deploy axes for a *subject* + *artifact-provenance policy*, a phased plan with an optional go/no-go **gates** decision log, and an append-only **logbook**. See [`investigation-skill/patterns/investigation-shape.md`](./investigation-skill/patterns/investigation-shape.md) for why its shape differs.

## What you get

A populated project tree:

- **`docs/`** — the four-tier doc structure (PROJECT, ARCHITECTURE, ROADMAP, PROGRESS) plus DEPLOY, BACKUP, SECURITY-REVIEW, PERFORMANCE, INCIDENTS, PRIVACY.
- **`CLAUDE.md`** — operating manual for Claude Code agents working on the new project.
- **`Makefile`** — `make help` menu, pre-flight checks, version targets, doctor.
- **`docker-compose*.yml`** — base + dev + prod + optional Caddy TLS overlay.
- **CI workflow** — GitHub Actions, optional Gitea mirror.
- **`.pre-commit-config.yaml`** — universal hooks + secret scanning.
- **`VERSION` + `scripts/sync_version.py`** — single-source version propagation.
- **`README.md`, `CHANGELOG.md`, `CONTRIBUTING.md`, `SECURITY.md`** — the standard top-level docs.
- **`LICENSE` placeholder** — with a one-line `curl` to fetch the canonical SPDX text.
- **`BOOTSTRAP-MANIFEST.md`** — what the skill wrote and what `{{TODO}}` markers remain.

The shape comes from [Libreta](https://github.com/joseluisamado/libreta), refined and extended through a deliberate review documented in [`02-review-notes.md`](./02-review-notes.md) and [`03-missing-practices.md`](./03-missing-practices.md).

## Install

```bash
./install.sh
```

This installs **all three** skills:

- `skill/` → `~/.claude/skills/bootstrap-project/`
- `retrofit-skill/` → `~/.claude/skills/retrofit-project/` (with `templates/` copied from bootstrap so the skill is self-contained)
- `investigation-skill/` → `~/.claude/skills/bootstrap-investigation/` (self-contained; ships its own `templates/`)

Re-run to update.

## Use

### bootstrap-project (fresh)

In a Claude Code session, in an empty directory:

1. **Have a design conversation**. Discuss vision, principles, milestones, stack, audience. Use Claude as a thinking partner.
2. **Invoke the skill**: say "bootstrap this project" or `/bootstrap-project`.
3. **Confirm**: the skill prints what it extracted; correct anything wrong.
4. **Answer the spec questions**: license, optional add-ons.
5. **Done**: the skill writes the scaffold and prints a "next 30 minutes" punch list.

Refuses on non-empty directories.

### retrofit-project (existing)

In a Claude Code session, in an existing project (needs a `.git/`):

1. **Have an analysis conversation**. What is the project? What are its principles? What milestone is it on? What's the stack?
2. **Invoke the skill**: say "retrofit this project" or `/retrofit-project`.
3. **Review the inventory diff**: the skill walks the project and classifies every file as missing / present-template-shape / present-bespoke / empty-placeholder. Most important step — say go or correct.
4. **Answer the spec questions**: license, optional add-ons, deploy_model, permissions scope, content-preservation strategy.
5. **Confirm the plan**: which files get written, rewritten, moved, deleted.
6. **Done**: the skill executes, backfills CHANGELOG from git history, writes `.bootstrap-meta.yaml` with `mode: retrofit`, and prints the punch list.

Refuses if there's no `.git/` (the safety net) or if the project was already bootstrapped at the current skill version.

### bootstrap-investigation (new, from scratch)

In a Claude Code session, in an empty directory, for an **investigation/documentation** project (a recovery, reverse-engineering effort, forensic study, or research write-up — not software built from source):

1. **Have an investigation-design conversation**. What's the subject? The question you're chasing? The principles/disciplines? The rough phases?
2. **Invoke the skill**: say "bootstrap this investigation" or `/bootstrap-investigation`.
3. **Confirm the spec**: subject, mode (learning vs. production-stakes), principles, rules, phases.
4. **Answer the asks**: license, **artifact-provenance policy** (private-archive / public-writeup / none), and whether to add the go/no-go **gates** decision log.
5. **Done**: the skill writes the docs quintet (PROJECT, FOUNDATION, PROCEDURE, SUBJECT, WRITEUP), a phased `plan/ROADMAP.md` (+ `plan/GATES.md` if gated), an append-only `logbook/`, `evidence/` and `sources/` archives, optional `artifacts/manifests/`, and prints the punch list.

Refuses on non-empty directories. (Retrofitting an existing investigation is out of scope for v0.1.0.)

All three skills are **same-session only**. If invoked cold, they refuse with a clear message.

## Design

This repo contains the skills themselves plus the design history that produced them:

| File | Purpose |
|---|---|
| [`skill/`](./skill/) | The `bootstrap-project` skill — copied to `~/.claude/skills/bootstrap-project/`. |
| [`retrofit-skill/`](./retrofit-skill/) | The `retrofit-project` skill — copied to `~/.claude/skills/retrofit-project/`. Shares `templates/` with bootstrap. |
| [`retrofit-skill/patterns/why-retrofit-is-different.md`](./retrofit-skill/patterns/why-retrofit-is-different.md) | Why retrofit is a separate skill, not a flag on bootstrap. |
| [`investigation-skill/`](./investigation-skill/) | The `bootstrap-investigation` skill — copied to `~/.claude/skills/bootstrap-investigation/`. Self-contained (own `templates/`). |
| [`investigation-skill/patterns/investigation-shape.md`](./investigation-skill/patterns/investigation-shape.md) | Why the investigation scaffold has its shape, and why it's a sibling skill rather than a flag on bootstrap. |
| [`01-libreta-inventory.md`](./01-libreta-inventory.md) | Step 1 — what was extracted from Libreta. |
| [`02-review-notes.md`](./02-review-notes.md) | Step 2 — 92 findings (improve / add / drop / keep). |
| [`03-missing-practices.md`](./03-missing-practices.md) | Step 3 — 47 engineering practices evaluated. |
| [`04-final-design.md`](./04-final-design.md) | Step 4 — synthesized design spec. |
| [`CHANGELOG.md`](./CHANGELOG.md) | Skill release history. |
| [`MIGRATIONS.md`](./MIGRATIONS.md) | How to upgrade projects bootstrapped with older skill versions. |

## Contributing

These skills are meant to evolve. When you bootstrap or retrofit a project and find a rough edge:

1. Open an issue describing what could be improved.
2. If you have a fix, edit the relevant template or playbook: `skill/templates/` (shared by bootstrap + retrofit) or `investigation-skill/templates/` (investigation only), or the relevant `INSTRUCTIONS.md` / `patterns/` under `skill/`, `retrofit-skill/`, or `investigation-skill/`.
3. Bump the skill version in the relevant `VERSION` and add a CHANGELOG entry.
4. Re-run `./install.sh` to update all three local installs.
5. Test against the next project you bootstrap or retrofit.

The skills' evolution mirrors what they teach: small, deliberate, well-documented changes.

## License

This skill is dedicated to the public domain (CC0). Use it however you like.

(The bootstrapped projects pick their own license per the skill's prompt — that's a separate question from the skill itself.)
