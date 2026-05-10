# PROGRESS.md log entry shape

Each dated entry in `docs/PROGRESS.md` "Log" section has a consistent shape.

## Anatomy

```markdown
### YYYY-MM-DD — Short title

**What changed**: One paragraph or a few bullets stating what landed in this chunk.

- Specific change 1.
- Specific change 2.
- ...

**How it works** (optional): One paragraph or bullets if the implementation is non-obvious.

**Decision** (optional): If a non-trivial choice was made, summarize it here and add a `D-NN` to ARCHITECTURE.md.

**Pre-flight**: <component> <X>/<Y> tests pass, <linter> clean. <repeat per component>.
```

## The pre-flight sign-off

The closing line is the most important part:

> **Pre-flight**: backend 95/95 tests pass, ruff/mypy clean. Frontend 65/65 tests pass, vue-tsc clean.

This makes the entry self-verifying. Without it, "I shipped X" is a claim. With it, the claim is checkable — anyone reading later can re-run the same checks and see whether the assertion holds.

If a check is *not* clean, say so:

> **Pre-flight**: backend 95/95 tests pass, ruff has 5 pre-existing housekeeping items unrelated to this work, mypy clean. Frontend 65/65 tests pass, vue-tsc clean.

Honest sign-offs build trust in the log over time. Lying sign-offs poison it.

## Entry granularity

One entry per coherent chunk of work. Examples:

- "M3 Search (FTS5 index, API, UI, CLI)" — four sub-tasks landed together, one entry.
- "M2 Diff view + external-edit watcher closed out" — two final items of a milestone, one entry.

Don't write one entry per commit; that's what `git log` is for.

Don't batch a week of unrelated work into one entry; the trail becomes useless.

## Latest at top

The PROGRESS log is reverse-chronological. The most recent entry is the first one a reader sees after the Status block. This means anyone catching up reads the relevant context first.

If you find yourself scrolling past stale entries to find the latest, reorder. The convention is non-negotiable.

## What goes in PROGRESS vs CHANGELOG

- **PROGRESS** — dev log. What did we do, why, with what reasoning. Audience: future-you, future agents working on the project.
- **CHANGELOG** — user log. What changed in each release, in user-facing language. Audience: users upgrading.

Most chunks of work go in PROGRESS. Only user-visible changes in shipped releases go in CHANGELOG.

## Decision pointer, not duplicate

PROGRESS's "Decisions log" table at the bottom is a *pointer* to D-NN entries in ARCHITECTURE.md, not a duplicate. Single source of truth = ARCHITECTURE; the table lets you scan dates fast.

## Status block convention

The Status block at the top of PROGRESS.md must always reflect reality. If the line is wrong, the doc is broken — fix it before doing anything else. The block answers three questions:

- Where are we right now?
- What's next?
- What's the very next concrete action?

If the third answer is "I don't know", that's the bug to fix. PROGRESS exists to keep that answer always in front of you.
