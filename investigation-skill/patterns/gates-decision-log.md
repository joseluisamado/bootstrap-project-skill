# The gates decision-log pattern

A **gate** is a checkable condition that guards entry to the next phase of an
investigation. You do not cross a gate until its condition is provably true.
This turns "should we proceed?" from a judgment call into a recorded fact.

Use gates when a phase boundary carries one of:

- **Terminal risk** — a step that, if it fails, ends the project (no covering
  license exists → the recovery is impossible).
- **Irreversible action** — a step that can't be undone or that can damage the
  subject (flashing firmware can brick the drive).
- **An expensive commitment** — past this point, sunk cost or grey-area action
  begins.

## Anatomy of a gate

Each gate in `plan/GATES.md` has:

- **Condition** — the single statement that must be true to cross. Written so
  it's unambiguously checkable ("the resource needed for the next step is in
  hand and covers the subject's exact configuration"), not aspirational
  ("we're confident we have what we need").
- **Why it matters** — what breaks downstream if you cross it falsely.
- **To close** — the concrete experiment/observation that settles it.
- **Status** — one of:
  - `OPEN` — not yet evaluable (prerequisites unmet).
  - `BLOCKED` — condition currently failing; work needed.
  - `PASSED` — condition met; may proceed.
  - `FAILED` — terminal for this path; project stops or pivots.
- **History** — dated, append-only entries recording each status change and the
  evidence (cross-referenced to the logbook).

A "Current position" table at the top of `GATES.md` summarises every gate
(Gate | Guards entry to | Status | Settled by) so the state of the whole project
is one glance.

## Gates vs. the ROADMAP

The ROADMAP holds the *work* (phases, task checkboxes). GATES holds the
*permissions* (may we move from one phase to the next). The gated ROADMAP variant
ends each phase with a `> GATE X — <condition>` block pointing at the matching
`GATES.md` section. The two stay in sync: a gate flipping to PASSED is the signal
to start the next phase's tasks.

## Hard gates

Mark a gate **HARD** when failing it likely ends the project (not just blocks a
phase). The recovery's hard gate — "is the resource the next step depends on
actually available for this exact subject?" — could have ended everything: no
resource, no firmware package, no flash, no recovery. A hard gate deserves the
most rigorous condition and the most evidence in its history; don't let optimism
paper over it. Cross it only when the condition is *proven*, and record the
proof.

## Discipline

- Update the status line and append to history **when a gate changes state** —
  not every session. A gate entry is a checkpoint, not a running commentary.
- Cross-reference the logbook entry that moved it.
- Never act past a gate whose condition isn't met. If you're tempted to "assume
  it'll pass," that's exactly the case the gate exists to stop.
