# Why the investigation scaffold has this shape

This skill's scaffold is distilled from a real project: reviving a bricked
SSD by reflashing its controller firmware, then imaging the flash. That project
produced no software from source — its deliverable was *understanding the
failure, a validated procedure, and an auditable record of every step*.
Software-project scaffolding (Makefile lint/test, CI, semver, code-shaped
PROGRESS) fit it badly. The shape below fit it well.

## The four organs of an investigation project

An investigation has four things a software project doesn't foreground:

1. **A subject that must be pinned down precisely.** Everything downstream keys
   off exactly *what* you're looking at. The recovery hinged on telling two
   near-identical controller variants apart, and on the exact flash-component
   part — a wrong identification propagates into a wrong action and a bricked
   device. → `docs/SUBJECT.md`, a fact-sheet whose job is to make
   mis-identification visible early.

2. **A method that is discovered, not designed.** You don't know the procedure
   up front; you converge on it. The doc that holds it (`docs/PROCEDURE.md`)
   starts thin and sharpens as steps are validated. The original briefing —
   the deep background and the problem as first understood — is preserved
   separately and immutably (`docs/FOUNDATION.md`), because later corrections
   are more legible against the original framing.

3. **An append-only record of what was actually done.** Not a code changelog —
   a dated logbook of physical and digital actions, results (error strings
   verbatim), and what each ruled in or out. This is the durable memory across
   sessions. → `logbook/LOG.md` + `logbook/TEMPLATE.md` + optional
   `logbook/sessions/`.

4. **Evidence and source archives with provenance.** Photos, dumps, captured
   logs (`evidence/`); the articles/threads/tools the work draws on
   (`sources/`); and — when artifacts are scarce or proprietary — the artifacts
   themselves with a per-file manifest carrying sha256 + where-and-when-found
   (`artifacts/manifests/`). → see [`provenance-manifests.md`](./provenance-manifests.md).

## Gates: the spine of a risk-laden inquiry

Some investigations have steps that can terminate the project or irreversibly
damage the subject. The recovery had a hard gate ("does any obtainable license
cover this exact config?") that could have killed the whole effort, and a flash
step that could brick the drive. For those, a phased plan isn't enough — you
need an explicit **go/no-go decision log**: each gate has a *condition* that must
be true to cross, a *status*, the *evidence* that settled it, and a *history*.
This makes "are we allowed to proceed?" a checkable fact, not a vibe. →
[`gates-decision-log.md`](./gates-decision-log.md). Offered as an add-on because
lighter investigations (a literature review, a write-up) don't need it.

## What is deliberately absent

- **No Makefile lint/test/build targets, no CI.** There is no source to build.
  If helper scripts exist (`scripts/`), they're documented, not gated by CI.
- **No semver VERSION.** An investigation has phases and gates, not releases.
  CHANGELOG is kept as a human project-level log, not a code release record.
- **No code-shaped PROGRESS.md.** The logbook plays that role, in the idiom of
  actions-taken rather than commits-landed.

## The relationship to bootstrap-project

These are siblings, not parent/child. `bootstrap-project` owns software; this
skill owns inquiry. They share license texts, `.editorconfig`, the
`.bootstrap-meta.yaml` mechanism, and the manifest discipline. Pick by
deliverable: a built artifact → `bootstrap-project`; understanding plus a
record → `bootstrap-investigation`.
