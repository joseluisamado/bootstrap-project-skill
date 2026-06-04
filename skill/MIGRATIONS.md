# Migrations — bootstrap-project skill

Notes for upgrading a project's `.bootstrap-meta.yaml` when the skill
bumps to a new version. The skill itself never auto-migrates a project
in v0.x; the operator decides whether a project's scaffold is worth
updating. This document is the lookup table.

---

## v0.1.0 → v0.2.0

### Summary

v0.2.0 adds a `nix-flake` stack profile and an `artifacts` deploy model.
**No file-level changes are required** for projects already bootstrapped
on v0.1.0. The new profile is opt-in for new projects only.

### Optional: re-label an ad-hoc Nix project

If a project was bootstrapped on v0.1.0 with `stack_profile: polyglot`
or `stack_profile: none-yet` but the actual stack is a Nix flake (e.g.
because the new profile didn't exist yet), the `.bootstrap-meta.yaml`
can be updated for clarity. This is purely cosmetic — it has no effect
on the project itself.

```yaml
# Before (v0.1.0 .bootstrap-meta.yaml):
spec:
  stack_profile: polyglot
  deploy_model: single-binary   # or wherever you landed

# After (v0.2.0 .bootstrap-meta.yaml):
spec:
  stack_profile: nix-flake
  deploy_model: artifacts
```

Add a note in the project's CHANGELOG so future-you knows the relabeling
happened.

### Optional: backfill the nix-flake scaffold into an existing project

The `retrofit-project` skill (sibling skill) is the tool for this. It can
detect the v0.1.0 scaffold via `.bootstrap-meta.yaml`, ask the v0.2.0
questions, and selectively overlay the nix-flake profile templates onto
the existing tree without clobbering bespoke content. This is the
intended path if you want the structured Nix scaffold (host registry,
sops-nix wiring, services template) without rewriting the project from
scratch.

### What did NOT change

- Existing stack profiles (`python-only`, `node-only`, etc.) — unchanged.
- Existing deploy models (`docker-compose`, `single-binary`, `library`,
  `none-yet`) — unchanged.
- Always-present file list and the docs quintet — unchanged.
- Add-on flag set — unchanged.

### Skill-version detection

When the skill is invoked in a project with `.bootstrap-meta.yaml`
declaring `bootstrap_skill_version: 0.1.0`, the skill v0.2.0 logs the
version mismatch but does not auto-migrate (per INSTRUCTIONS §9). The
project keeps working; only the `.bootstrap-meta.yaml` carries the
older version stamp.

---

## Future migrations

When v0.3.0 lands, append a new section above. Keep this file ordered
newest-first so the most recent migration is at the top.
