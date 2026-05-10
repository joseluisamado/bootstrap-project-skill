# SLOs vs targets

The skill scaffolds **NFR targets** in `docs/PROJECT.md` and `docs/PERFORMANCE.md`. It does not scaffold **SLOs** (Service Level Objectives) or error budgets.

## The distinction

- **Target**: "Page loads under 200 ms on a Pi 4." A measurement that should be true.
- **SLO**: "99.9% of requests complete within 500 ms over 30 days." A reliability commitment with a quantitative tail.
- **Error budget**: "We're allowed 0.1% misses per 30 days. Burn it on launches; conserve it during freezes."

Targets are aspirational; SLOs are accounting; error budgets are governance.

## Why targets are sufficient for the libreta shape

The libreta shape is solo / small-team self-hosted. The operator is also (usually) the user. "Is it up?" is observable, not a 9s discussion.

NFR targets give:

- A specific number to test against.
- A regression check (the 2× rule in `PERFORMANCE.md`).
- A revisit prompt (date stamps).

SLOs add:

- Continuous measurement infrastructure (uptime probes, percentile latency tracking).
- A burn-rate calculation.
- A multi-stakeholder negotiation about how much risk is acceptable.

The infrastructure cost is real. The negotiation cost only earns its weight when there are multiple stakeholders disagreeing about reliability. For solo work, you've already agreed with yourself.

## When to graduate from targets to SLOs

Adopt SLOs when **any** is true:

- The project is a service with paying customers, and reliability is contractual.
- Multiple teams own different parts and need to coordinate "how much risk is OK."
- You have on-call rotation and need a forcing function for engineering vs feature work.

If none applies, targets are correct.

## How NFR targets are kept honest

- **Date-stamped**: `(set: YYYY-MM-DD)` so they're revisitable.
- **Cited verbatim** in `PERFORMANCE.md` so the connection to measurement is explicit.
- **Re-run triggers** in `PERFORMANCE.md` say *when* to re-measure (before releases, after specific files change, after specific deps bump).
- **2× regression threshold** as early warning (a number is required; "any regression" produces too many false alarms).

This is enough rigor to catch slowness; SLOs would be more rigor than the audience justifies.
