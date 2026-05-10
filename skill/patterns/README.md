# patterns/

Reference docs the skill reads internally and that the user can browse to understand the *why* behind the scaffold.

These are not templates and are not written into the bootstrapped project. They explain conventions, capture rejected alternatives, and describe practices the skill mentions but doesn't scaffold.

## Inventory

| File | Topic |
|---|---|
| [`why-libreta-shape.md`](./why-libreta-shape.md) | The lineage of the conventions baked into this skill. |
| [`adr-vs-inline-decisions.md`](./adr-vs-inline-decisions.md) | When to migrate from inline `D-NN` entries to per-file ADRs. |
| [`milestone-shape.md`](./milestone-shape.md) | What makes a good milestone (goal, exit criteria, optional kill criteria). |
| [`progress-log-shape.md`](./progress-log-shape.md) | Conventions for PROGRESS.md log entries and the pre-flight sign-off line. |
| [`inviolable-rules.md`](./inviolable-rules.md) | How rules derive from principles, and how rules change. |
| [`threat-modeling-cadence.md`](./threat-modeling-cadence.md) | When to re-run a security review. |
| [`property-based-testing.md`](./property-based-testing.md) | When invariant-based testing earns its complexity. |
| [`csp-headers.md`](./csp-headers.md) | When to add a Content-Security-Policy header. |
| [`sbom.md`](./sbom.md) | When to ship a Software Bill of Materials. |
| [`image-signing.md`](./image-signing.md) | When to sign container images. |
| [`reproducible-builds.md`](./reproducible-builds.md) | When reproducible-build effort earns its cost. |
| [`coverage-thresholds-considered-harmful.md`](./coverage-thresholds-considered-harmful.md) | Why the skill does not gate CI on coverage. |
| [`feature-flags.md`](./feature-flags.md) | When feature-flag infrastructure earns its weight. |
| [`slos-vs-targets.md`](./slos-vs-targets.md) | Why the skill uses NFR targets instead of SLOs/error budgets. |
| [`definition-of-done-considered-bureaucratic.md`](./definition-of-done-considered-bureaucratic.md) | Why a separate DoD checklist is redundant with milestone exit criteria + pre-merge checklist. |
| [`stack-shaped-practices.md`](./stack-shaped-practices.md) | Practices that are stack-specific and live outside this skill's generic core. |
