# Milestone shape

Each milestone in `docs/ROADMAP.md` has four parts. Three required, one optional.

## Required

### Goal

One paragraph stating what this milestone delivers. Should be readable as the answer to "what does shipping this milestone earn us?"

Bad: "Implement the search feature."
Good: "Add full-text search across all pages so users stop using `grep` on the working tree."

### Checklist

`- [ ]` items, each a discrete deliverable. The checklist is what you tick off as you go. Keep items concrete:

Bad: "Make search work."
Good: "SQLite FTS5 index built and updated on save."

A milestone with one checklist item is suspicious — usually it's hiding sub-tasks. A milestone with twenty is also suspicious — it's probably two milestones that should split.

### Exit criteria

One sentence stating what "done" means. Read this *before* starting; if you can't write a clear exit criterion, the milestone is too vague to start.

Examples:

> Daily-driver-able for a single user editing markdown. Round-trip tests passing for ≥ 50 fixtures.

> All non-diagram editing features feel "done." Search finds anything in under 300 ms.

> First external user installs the project and uses it for a week without filing critical bugs.

The exit criterion is a *test* — when you think you're done, you check whether the criterion is satisfied. If it is, ship; if not, you're not done.

## Optional

### Kill criteria

One sentence: "if this turns out to be true, stop and re-plan." Use only for milestones with genuine uncertainty (research, exploration, "we'll see if this approach works").

Most milestones don't need a kill criterion — for routine work, you finish or you don't. But for a milestone like "explore CRDT layer for offline edits", a kill criterion like "if implementation cost exceeds a week of focused work, drop and revisit at v3" gives explicit permission to abandon.

## What's not part of the shape

- **Dates**. The roadmap is dateless; pace varies.
- **Effort estimates**. Ditto. If you must estimate, do it in the PR or RFC, not the roadmap.
- **Owner names**. Assumed from project context. If the project has multiple authors and ownership matters, add it via PR description, not the milestone.
- **Definition of Done checklist** — the exit criterion *is* the DoD. No separate checklist.

## When milestones close

Mark complete with `✅ (date, shipped at vX.Y.Z)`. The version pin ties the roadmap to release tags so a future reader can find the actual code.

## Polish milestones

If real usage of M_N surfaces rough edges that you don't want to mix into M_{N+1}, insert M_N.5 between them. Example: between M0 (foundations) and M1 (read-only), libreta inserted M0.5 "read-experience polish." Polish milestones are not slipped feature milestones — they're their own thing, named, with their own exit criteria.

The roadmap template's header note signals that polish milestones are first-class.
