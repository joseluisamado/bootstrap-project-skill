# Why retrofit is different from bootstrap

`bootstrap-project` and `retrofit-project` share the same templates, the same canonical shape, the same five-question spec, and the same `.bootstrap-meta.yaml` semantics. So why are they two skills instead of one with a `--mode` flag?

This doc captures the operational asymmetries — the things a retrofit has to *do* that a fresh bootstrap never thinks about. Understanding these is what makes the skill safe.

## 1. Bootstrap writes; retrofit negotiates

A bootstrap on an empty directory has one mode of operation: write the templates. There is no other content to consider.

A retrofit on an existing project has four distinct operations on every file: **write** (it's missing), **rewrite** (it's there but in the wrong shape), **move** (it's in the wrong place), **delete** (it shouldn't exist). Each operation has different failure modes and requires different confirmation pressure from the user.

The split into a separate skill makes those four operations first-class in the playbook. A `--mode=retrofit` flag on the bootstrap skill would have to hide them inside the existing single-write flow, which loses the clarity.

## 2. The inventory diff is the most important artifact

For a fresh bootstrap, the file plan is mechanical: `templates/` × `add_ons` = file list. The user mostly skims it.

For a retrofit, the inventory diff is what the user actually reviews. They are looking at it and asking: *did the skill correctly identify that my custom `docs/PROJECT.md` is bespoke-shaped and not template-shaped? Did it correctly flag `docker/` as empty-and-deletable? Did it correctly recognize that `docs/01 Foo.md` should move to `docs/design/01-foo.md`?*

This step needs to be early, prominent, and re-runnable. Bootstrap's terse "Planning to write 28 files:" is wrong shape for retrofits. The diff table is the right shape.

## 3. Moves require reference-updating

A move is not just `git mv old new`. It is `git mv old new` followed by a grep across the whole project for references to `old`, followed by edits to each referencing file, followed by a verification grep.

The youtube retrofit moved `docs/01 Faceless youtube channel playbook.md` to `docs/design/01-playbook.md`. That move required editing `src/tutorial_pipeline/scaffolding.py` (the orchestrator reads the research doc at runtime). Without the reference-update sub-pass, the move would have silently broken the code.

Bootstrap never moves files, so it never has this concern. Retrofit has to think about it on every move.

## 4. Content preservation is judgment-shaped

Mapping a bespoke `docs/PROJECT.md` into the canonical `Audience / Vision / Background / Principles / Goals / Non-goals / F-NN / NFRs / Success / Out of scope` skeleton is genuinely LLM-shaped work. There is no algorithm.

But the *procedure* around it is consistent: read the existing file, identify content per canonical section, reslot, preserve overflow content under `## Background` or `## Additional context`, never drop. That procedure is what the skill encodes. The judgment happens inside it.

A fresh bootstrap has no analog. The PROJECT.md template gets written with `{{TODO}}` markers; the user fills them later. Retrofit fills them *from existing content* — a fundamentally different operation.

## 5. CHANGELOG backfill needs git history

Bootstrap writes `[Unreleased] - Initial scaffold` and stops.

Retrofit reads `git tag` + `git log` + any existing `PROGRESS.md` versioning table, infers what each version added/changed/fixed from conventional-commit prefixes, and writes a Keep-a-Changelog history. This is mechanical but tedious; automating it is high-value.

It also requires `.git/`, which is why retrofit refuses without it.

## 6. The "everything is in git" safety net

Retrofit is destructive: it rewrites existing files, deletes others, moves files between locations. The single thing that makes this safe is git: every change is recoverable.

The skill's refusal-without-git is not paranoia. It's the only thing standing between "elegant reshape" and "I lost three weeks of design work." The first thing the manifest's "Next 30 minutes" section says is *"Review the diff; everything is in git, so nothing is irrecoverable."*

Bootstrap operates on empty directories where there is nothing to lose. Retrofit operates on directories full of work.

## 7. Re-retrofit is normal; re-bootstrap is not

Once a project is bootstrapped, you never bootstrap it again. The skill refuses (5-of-N always-present files trip the check).

A retrofit project, by contrast, can be retrofitted again — when the skill ships template improvements you want to absorb, when the project's shape has drifted, when a new add-on becomes appropriate. The `mode: retrofit` marker and the `add_ons_declined` list exist precisely so re-retrofits don't lose information.

## 8. The questions feel similar but defaults differ

Bootstrap asks the user to choose deploy_model from a flat list.

Retrofit asks the same question but defaults based on what already exists: a `docker-compose.yml` at the root suggests `docker-compose`; a `Cargo.toml` suggests `single-binary`; a Python package with just a CLI suggests `library`. The user can override, but the default carries the existing reality.

Same pattern for add-ons: `dependency-bot` defaults ON if `.github/dependabot.yml` exists; `secret-scanning-precommit` defaults ON if `.secrets.baseline` exists.

This isn't a UX nicety. It's recognition that the existing project already encodes decisions the bootstrap flow would force the user to re-state.

## 9. The result is the same, the path is the difference

After both skills run, the user has an identical canonical shape: same files, same headings, same conventions, same `.bootstrap-meta.yaml` semantics (`mode:` distinguishes provenance). The compatibility is intentional — any tooling that reads the bootstrap shape works on both fresh and retrofitted projects.

What differs is the *path* to that result. Bootstrap's path is "write files into emptiness." Retrofit's path is "negotiate existing content into a canonical shape without losing anything." Two different procedures, same end-state.

That's why they're two skills.
