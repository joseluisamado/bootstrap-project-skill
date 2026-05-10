# bootstrap-project skill

> A Claude Code skill that crystallizes a project-design conversation into a complete project scaffold.

The skill is a **finalizer**: have the design conversation as normal (vision, principles, milestones, stack, audience), then invoke the skill to write everything down using a consistent, opinionated structure.

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

This copies `skill/` to `~/.claude/skills/bootstrap-project/`. Re-run to update.

## Use

In a Claude Code session:

1. **Have a design conversation**. Discuss vision, principles, milestones, stack, audience. Use Claude as a thinking partner.
2. **Invoke the skill**: say "bootstrap this project" or `/bootstrap-project`.
3. **Confirm**: the skill prints what it extracted; correct anything wrong.
4. **Answer two questions**: license, optional add-ons.
5. **Done**: the skill writes the scaffold and prints a "next 30 minutes" punch list.

The skill is **same-session only**. If invoked cold (no prior design conversation), it refuses with a clear message.

## Design

This repo contains the skill itself plus the design history that produced it:

| File | Purpose |
|---|---|
| [`skill/`](./skill/) | The actual skill, copied to `~/.claude/skills/bootstrap-project/` by `install.sh`. |
| [`01-libreta-inventory.md`](./01-libreta-inventory.md) | Step 1 — what was extracted from Libreta. |
| [`02-review-notes.md`](./02-review-notes.md) | Step 2 — 92 findings (improve / add / drop / keep). |
| [`03-missing-practices.md`](./03-missing-practices.md) | Step 3 — 47 engineering practices evaluated. |
| [`04-final-design.md`](./04-final-design.md) | Step 4 — synthesized design spec. |
| [`CHANGELOG.md`](./CHANGELOG.md) | Skill release history. |
| [`MIGRATIONS.md`](./MIGRATIONS.md) | How to upgrade projects bootstrapped with older skill versions. |

## Contributing

This skill is meant to evolve. When you bootstrap a new project and find a rough edge:

1. Open an issue describing what could be improved.
2. If you have a fix, edit the relevant template under `skill/templates/` or pattern under `skill/patterns/`.
3. Bump the skill version in `VERSION` and add a CHANGELOG entry.
4. Re-run `./install.sh` to update your local install.
5. Test against the next project you bootstrap.

The skill's evolution mirrors what it teaches: small, deliberate, well-documented changes.

## License

This skill is dedicated to the public domain (CC0). Use it however you like.

(The bootstrapped projects pick their own license per the skill's prompt — that's a separate question from the skill itself.)
