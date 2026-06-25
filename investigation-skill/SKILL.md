---
name: bootstrap-investigation
description: |
  Crystallize an investigation-design conversation into a complete
  investigation/documentation project scaffold. For projects whose deliverable
  is *understanding and a record* — recoveries, reverse-engineering efforts,
  forensics, research write-ups, post-mortems — NOT software built from source.

  Reads the current session for project name, subject, principles, phases, and
  audience; writes the docs quintet (PROJECT, FOUNDATION, PROCEDURE, SUBJECT,
  WRITEUP), a phased plan/ROADMAP, a dated append-only logbook/, evidence/ and
  sources/ directories, CLAUDE.md, LICENSE, CHANGELOG, and supporting files.
  Asks an artifact-provenance policy (private-archive / public-writeup / none)
  and offers an optional go/no-go GATES decision-log add-on.

  Use this when the user says "bootstrap this investigation", "scaffold this
  recovery/research project", "set up the documentation project", or invokes
  /bootstrap-investigation. The skill is a finalizer — it assumes the
  investigation-design conversation has happened in this session and extracts
  spec from context. It asks only the minimum follow-ups (license, artifact
  policy, gates add-on, anything missing).

  Do NOT use this for: software projects built from source code (use
  /bootstrap-project instead — it owns the stack-profile/deploy-model axes,
  Makefile lint/test targets, CI, and code-shaped PROGRESS); existing projects
  (the skill refuses to clobber files); greenfield brainstorming (have the
  design conversation first).
---

# bootstrap-investigation

This skill produces a scaffold for an **investigation / documentation project**:
one whose output is understanding plus a durable, auditable record — not a built
software artifact. Its shape is distilled from a real firmware-recovery project
(phased plan, go/no-go gates, an append-only dated logbook, evidence and source
archives, and per-artifact provenance manifests).

It is the investigation sibling of [`bootstrap-project`](../bootstrap-project/).
Where `bootstrap-project` asks "what stack, what deploy model" and writes a
Makefile/CI/PROGRESS for code, this skill asks "what subject, what artifact
policy" and writes a FOUNDATION/PROCEDURE/logbook for an inquiry.

The full playbook lives in [`INSTRUCTIONS.md`](./INSTRUCTIONS.md). Read it when
the skill is invoked. The short version:

1. Extract an investigation spec from the current conversation.
2. Print it; ask the user to confirm or correct.
3. Ask explicitly: license, artifact-provenance policy, gates add-on.
4. Write the scaffold using `templates/`. Skip files that already exist.
5. Generate `BOOTSTRAP-MANIFEST.md` and `.bootstrap-meta.yaml` (mode: investigation).
6. Print the "next 30 minutes" punch list.

The skill is **same-session only**. If invoked cold (no prior design
conversation in this session), refuse and ask the user to have the
investigation-design conversation first or paste a summary.

The skill **never writes outside the project root** and **never clobbers
existing files**.

## Artifact-provenance policy

Investigations vary in how they handle the evidence and tooling they gather.
The skill asks which posture applies:

- `private-archive` — the repo is the durable backup; it **commits** scarce or
  proprietary artifacts (leaked tools, firmware, licenses, photos) with a
  per-artifact manifest (sha256 + provenance), and carries "keep this repo
  private" warnings. Only reproducible blobs (disk images) are git-ignored.
- `public-writeup` — no proprietary blobs committed; artifacts are referenced,
  not stored. Manifests optional. Suitable for a publishable write-up.
- `none` — no artifact machinery; just the docs, logbook, evidence, and sources.

## Optional gates add-on

Risk-laden investigations (a step can brick the subject or terminate the
project) benefit from an explicit **go/no-go decision log**. With the gates
add-on, the skill writes `plan/GATES.md` (OPEN / BLOCKED / PASSED / FAILED per
gate, with condition / status / evidence / history) and shapes `plan/ROADMAP.md`
so each phase ends in a gate. Without it, the ROADMAP is a plain phased plan.

For background on why the scaffold has this shape, see
[`patterns/investigation-shape.md`](./patterns/investigation-shape.md).

See [`CHANGELOG.md`](./CHANGELOG.md) for version history.
