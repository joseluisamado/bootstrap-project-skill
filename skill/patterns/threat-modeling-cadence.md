# Threat-modeling cadence

The skill scaffolds `docs/SECURITY-REVIEW.md` as a **stub** — it does not bake in a threat-modeling framework like STRIDE or LINDDUN. Those frameworks are valuable but heavyweight; for solo / small-team self-hosted apps, the libreta-style "named adversaries + explicitly out-of-scope adversaries" shape is sufficient.

## When to populate the stub

Before any release that exposes the project to a network beyond your trusted local hosts.

Concretely: before `v1.0`, before opening to the public, before deploying to a server with an inbound TLS endpoint.

## When to re-run

Schedule a re-review when **any** is true:

- The network surface changes (new ingress, new outbound dependencies, new integration).
- A new auth boundary lands (new role, new token type, new principal source).
- A new trust boundary is crossed (e.g. you start accepting content from third-party imports).
- A year has passed since the last review, regardless of changes.

The first three are the high-yield triggers. The yearly cadence catches drift.

## What the SECURITY-REVIEW.md template captures

Six sections:

- **Threat model** — named adversaries + explicit out-of-scope adversaries.
- **What was audited** — surface-to-files table.
- **Findings** — P1/P2/P3/info severity scheme.
- **What I checked but found OK** — *negative* results, so future-you doesn't re-check the same things.
- **Known limitations (L-N)** — deliberate, documented gaps.
- **How to reproduce** — commands to re-run the audit.

This is enough structure to be rigorous without being ceremonial.

## When STRIDE / LINDDUN earn their weight

If the project grows past the "solo / small-team self-hosted" shape — multi-tenant, regulated data, contractual security obligations — adopt a formal framework. Until then, the simpler shape is correct.

If you do adopt a framework, document the switch in `PROGRESS.md` and update the SECURITY-REVIEW template.
