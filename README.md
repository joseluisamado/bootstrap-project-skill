# bootstrap-project skill (+ retrofit-project)

> Two Claude Code skills that crystallize a project-design conversation into a complete project scaffold.
>
> - **`bootstrap-project`** writes the scaffold from scratch in an empty directory.
> - **`retrofit-project`** brings an existing project up to the same canonical shape without losing content, history, or working code.

Both are **finalizers**: have the design conversation (or analysis conversation, for retrofits) as normal — vision, principles, milestones, stack, audience — then invoke the relevant skill to write everything down using a consistent, opinionated structure.

The two skills share `templates/`, the same five-question spec, and the same `.bootstrap-meta.yaml` semantics. They differ in *path*: bootstrap writes into emptiness; retrofit negotiates with existing content. See [`retrofit-skill/patterns/why-retrofit-is-different.md`](./retrofit-skill/patterns/why-retrofit-is-different.md) for the operational asymmetries.

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

This installs **both** skills:

- `skill/` → `~/.claude/skills/bootstrap-project/`
- `retrofit-skill/` → `~/.claude/skills/retrofit-project/` (with `templates/` copied from bootstrap so the skill is self-contained)

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

Both skills are **same-session only**. If invoked cold, they refuse with a clear message.

## Design

This repo contains the skills themselves plus the design history that produced them:

| File | Purpose |
|---|---|
| [`skill/`](./skill/) | The `bootstrap-project` skill — copied to `~/.claude/skills/bootstrap-project/`. |
| [`retrofit-skill/`](./retrofit-skill/) | The `retrofit-project` skill — copied to `~/.claude/skills/retrofit-project/`. Shares `templates/` with bootstrap. |
| [`retrofit-skill/patterns/why-retrofit-is-different.md`](./retrofit-skill/patterns/why-retrofit-is-different.md) | Why retrofit is a separate skill, not a flag on bootstrap. |
| [`01-libreta-inventory.md`](./01-libreta-inventory.md) | Step 1 — what was extracted from Libreta. |
| [`02-review-notes.md`](./02-review-notes.md) | Step 2 — 92 findings (improve / add / drop / keep). |
| [`03-missing-practices.md`](./03-missing-practices.md) | Step 3 — 47 engineering practices evaluated. |
| [`04-final-design.md`](./04-final-design.md) | Step 4 — synthesized design spec. |
| [`CHANGELOG.md`](./CHANGELOG.md) | Skill release history. |
| [`MIGRATIONS.md`](./MIGRATIONS.md) | How to upgrade projects bootstrapped with older skill versions. |

## Contributing

These skills are meant to evolve. When you bootstrap or retrofit a project and find a rough edge:

1. Open an issue describing what could be improved.
2. If you have a fix, edit the relevant template under `skill/templates/` (shared by both skills) or the relevant playbook (`skill/INSTRUCTIONS.md`, `retrofit-skill/INSTRUCTIONS.md`) or pattern (`skill/patterns/`, `retrofit-skill/patterns/`).
3. Bump the skill version in `VERSION` and add a CHANGELOG entry.
4. Re-run `./install.sh` to update both local installs.
5. Test against the next project you bootstrap or retrofit.

The skills' evolution mirrors what they teach: small, deliberate, well-documented changes.

## License

This skill is dedicated to the public domain (CC0). Use it however you like.

(The bootstrapped projects pick their own license per the skill's prompt — that's a separate question from the skill itself.)
