---
name: bootstrap-project
description: |
  Crystallize a project-design conversation into a complete project scaffold.
  Reads the current session for project name, principles, milestones, stack,
  and audience; writes the docs/ quintet (PROJECT, ARCHITECTURE, ROADMAP,
  PROGRESS, DEPLOY), CLAUDE.md, Makefile, docker-compose family, CI workflow,
  pre-commit config, VERSION, LICENSE, CHANGELOG, and supporting files.

  Use this when the user says "bootstrap this project", "scaffold the repo",
  "now write all of this down", or invokes /bootstrap-project. The skill is a
  finalizer — it assumes the design conversation has happened in this session
  and extracts spec from context. It will ask only the minimum follow-ups
  (license, optional add-ons, anything missing).

  Do NOT use this for: existing projects (the skill refuses to clobber files);
  greenfield brainstorming (have the design conversation first); generating
  partial output (the skill writes the full scaffold or nothing).
---

# bootstrap-project

This skill produces a project scaffold whose shape comes from libreta's
engineering conventions, refined and extended.

The full playbook lives in [`INSTRUCTIONS.md`](./INSTRUCTIONS.md). Read it
when the skill is invoked. The short version:

1. Extract a project spec from the current conversation.
2. Print it; ask the user to confirm or correct.
3. Ask explicitly: license, optional add-ons.
4. Write the scaffold using `templates/`. Skip files that already exist.
5. Generate `BOOTSTRAP-MANIFEST.md` and `.bootstrap-meta.yaml`.
6. Print the "next 30 minutes" punch list.

The skill is **same-session only**. If invoked cold (no prior design
conversation in this session), refuse with a message asking the user to
either have the design conversation first or paste a summary.

The skill **never writes outside the project root** and **never clobbers
existing files**.

For background on why the scaffold has its shape, see
[`patterns/why-libreta-shape.md`](./patterns/why-libreta-shape.md).
