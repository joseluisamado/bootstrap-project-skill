# Definition of Done considered bureaucratic

Some methodologies prescribe a per-task **Definition of Done** (DoD): a checklist that every task must satisfy before being called complete. The skill does not scaffold one, deliberately.

## The argument for DoD

"Without an explicit DoD, 'done' is fuzzy. People declare victory at different points. A checklist standardizes."

Sounds reasonable. In practice, on the project shapes the skill targets, the result is usually:

- A checklist that's a copy of the things you'd do anyway (tests, docs, lint).
- Bureaucratic friction — people tick boxes without thinking.
- Maintenance overhead — the DoD itself rots.

## What the skill provides instead

The roles a DoD plays are already covered:

- **What "done" means for a milestone**: the milestone's **Exit criterion** in `docs/ROADMAP.md`. One sentence per milestone, written before starting. Specific, testable, project-relevant.
- **What "done" means for a chunk of work**: the **Pre-merge checklist** in `CLAUDE.md` §3.4 / §4.4. Five items, derived from project conventions, not generic.
- **What "done" means for a release**: the v1.0 milestone in ROADMAP includes "Populate `docs/BACKUP.md`, `docs/SECURITY-REVIEW.md`, `docs/PERFORMANCE.md`" as line items.

This is enough structure without a separate doc.

## When a DoD makes sense

If your team grows past the point where pre-merge checklist + exit criteria suffice, a DoD becomes useful. Common triggers:

- Multiple teams with different practices need to converge.
- Compliance requires an explicit, named DoD.
- Onboarding load — new contributors keep asking "is X required?" and a DoD answers reliably.

If you adopt a DoD later, build it from the existing pre-merge checklist + exit criteria. Don't import a generic template.
