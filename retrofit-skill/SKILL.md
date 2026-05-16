---
name: retrofit-project
description: |
  Reshape an existing project to the bootstrap-project skill standard
  without losing content, history, or working code. Walks the repo, classifies
  every file as missing / present-template-shape / present-bespoke / empty-placeholder,
  asks the same five spec questions as bootstrap-project (plus a content-strategy
  question), reshapes the docs quintet, backfills CHANGELOG from git history,
  moves files with reference-updating, and marks the project with
  `.bootstrap-meta.yaml` mode: retrofit.

  Use this when the user says "retrofit this project", "bring this repo up to
  the bootstrap-project standard", "reshape this to skill shape", or invokes
  /retrofit-project. Like bootstrap-project, it is a finalizer — it assumes
  the analysis conversation has happened in this session and extracts spec
  from context. Unlike bootstrap-project, it does NOT refuse on non-empty
  projects — that is its entire reason to exist.

  Do NOT use this for: greenfield projects (use /bootstrap-project instead);
  projects without a `.git/` directory (the CHANGELOG backfill and the
  "everything is in git" safety net require git history); already-bootstrapped
  projects whose `.bootstrap-meta.yaml` reports the same skill version (no
  work to do — say so and stop).
---

# retrofit-project

This skill produces the same end-state as `bootstrap-project` (same templates,
same canonical shape) on a repo that already has content. The hard part is
not the writing — it is the *negotiation* with what is already there:
preserving facts under reshape, finding canonical homes for bespoke content,
moving files without breaking references, and being explicit about what was
deleted and why.

The full playbook lives in [`INSTRUCTIONS.md`](./INSTRUCTIONS.md). Read it
when the skill is invoked. The short version:

1. **Refuse if invoked cold or on a non-git repo.** Need analysis context
   and a git safety net.
2. **Inventory diff.** Walk every always-present file from the bootstrap
   spec; classify as missing / present-template-shape / present-bespoke /
   empty-placeholder. Print the table.
3. **Extract spec from conversation** — same fields as bootstrap-project
   (project_name, principles, milestones, stack_profile, deploy_model,
   audience, license, add-ons), plus content-preservation strategy.
4. **Confirm the plan** in one block: what gets written, rewritten, moved,
   deleted. Wait for "go."
5. **Execute** in this order: (a) write missing always-present files;
   (b) rewrite bespoke docs to canonical shape, preserving content;
   (c) move files with reference-updating sub-passes; (d) delete with
   explicit justification; (e) backfill CHANGELOG from `git tag` +
   `git log` + any existing PROGRESS versioning table; (f) write
   `.bootstrap-meta.yaml` with `mode: retrofit`.
6. **Generate `BOOTSTRAP-MANIFEST.md`** with the richer retrofit shape:
   `files written / rewritten / moved / deleted / preserved unchanged`.
7. **Final compliance review.** Cross-ref check, no-clobber check,
   no-forbidden-file check. Print the "next 30 minutes" punch list.

The skill **shares `templates/`** with `bootstrap-project` — same renderers,
same conditional flags. Don't duplicate.

The skill **never deletes silently**. Every deletion appears in the
confirmation block before execution and in the manifest after.

For background on why retrofits are not just "bootstrap on a dirty
directory," see [`patterns/why-retrofit-is-different.md`](./patterns/why-retrofit-is-different.md).
