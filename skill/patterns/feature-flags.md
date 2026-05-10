# Feature flags

The skill does not scaffold feature-flag infrastructure. For solo / small-team self-hosted apps, the cost-benefit isn't there.

## When feature flags earn their weight

Use feature flags when **any** is true:

- You deploy continuously to production and need to decouple "merged" from "released."
- You want to A/B test changes with subsets of users.
- You're rolling out a risky change and want a kill switch separate from a deploy rollback.
- You have multiple long-lived branches you need to converge.

For solo deploy-on-tag work, none of these typically applies. You merge, you tag, you deploy; if it's bad, you tag the previous version and deploy that.

## What feature flags cost

- Infrastructure (a flag service or a config layer).
- Code complexity — every flagged code path is now `if flag: ... else: ...`.
- Cognitive overhead — "is X live? for whom?"
- Cleanup discipline — flags are easy to add and hard to remove. Stale flags accumulate.

The libreta shape ships behind a single VERSION. If something needs to be opt-in, it's opt-in via env var or config (already used for things like `LIBRETA_DRAWIO_URL`); not via a runtime flag service.

## When to add them anyway

If your project shape changes — multi-tenant, public users, continuous deploy — adopt flags then. Common starting points:

- **Environment-variable flags** for trivial cases. No infrastructure needed.
- **Config-file flags** for slightly less trivial. The config is the source of truth; restart picks up changes.
- **Flag service** (LaunchDarkly, ConfigCat, Unleash) for genuine A/B and rollout needs.

Don't start with the flag service. Start with env vars; promote when env vars stop being enough.
