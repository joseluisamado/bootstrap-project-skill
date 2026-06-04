# Changelog — bootstrap-project skill

All notable changes to this skill are recorded here.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/)
and the skill adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

The version recorded in a project's `.bootstrap-meta.yaml` matches the
version below at the time of scaffolding. See [`MIGRATIONS.md`](./MIGRATIONS.md)
for upgrade notes when the skill version bumps.

## [0.2.0] — 2026-05-16

### Added

- **New stack profile: `nix-flake`** — first-class support for NixOS-based
  projects. The profile templates a complete flake skeleton with host
  registry, sops-nix wiring, services-as-compose-files GitOps surface,
  and Nix-aware Makefile / pre-commit / CI workflow.
- **New `deploy_model: artifacts`** — for projects whose deliverable is
  one or more built artifacts (OS images, single binaries with installer
  scripts) plus a config repo. `docs/DEPLOY.md` is rendered as a
  flash-and-bootstrap guide; `docker-compose*.yml` skipped.
- **Per-profile template tree**: templates that vary by stack profile
  live under `templates/profiles/<profile>/`. Profile templates shadow
  flat defaults with the same name. Sets the structural stage for
  multi-profile support without forcing the refactor yet.
- **`patterns/appliance-nixos.md`** — captures the design rationale for
  the nix-flake profile (host registry shape, sops-nix conventions,
  compose2nix bridge, when to depart from the pattern).

### Changed

- `INSTRUCTIONS.md` §2: `stack_profile` enum extended with `nix-flake`;
  `deploy_model` enum extended with `artifacts`. Seven new conditional
  fields documented (nixpkgs_channel, example_host_name/system/class,
  has_services, has_dns_service, local_domain).
- `INSTRUCTIONS.md` §4: new "Nix-flake profile asks" subsection
  documenting the additional intake questions for the new profile.
- `INSTRUCTIONS.md` §6: conditional-files table extended; profile
  templates section added.
- `INSTRUCTIONS.md` §8: new edge cases for `deploy_model = artifacts`
  and `stack_profile = nix-flake`.

### Migration

See [`MIGRATIONS.md`](./MIGRATIONS.md) for v0.1.0 → v0.2.0 notes.
No file-level changes required for projects on v0.1.0; the new profile
is opt-in for new projects only.

## [0.1.0] — 2026-04-XX

### Added

- Initial release. Docs quintet (PROJECT, ARCHITECTURE, ROADMAP, PROGRESS,
  DEPLOY), CLAUDE.md, Makefile, docker-compose family, CI workflow,
  pre-commit config, VERSION, LICENSE, CHANGELOG, BOOTSTRAP-MANIFEST,
  `.bootstrap-meta.yaml` for skill-version tracking.
- Stack profiles: `python-only`, `node-only`, `python+node`, `go-only`,
  `rust-only`, `polyglot`, `none-yet`.
- Deploy models: `docker-compose`, `single-binary`, `library`, `none-yet`.
- Add-on flags: `rfc-process`, `readme-badges`, `runbook`,
  `observability-stub`, `signed-tags`, `digest-pinned-images`, `sast`,
  `a11y-checks`, `i18n-scaffold`, `external-contributions`,
  `dependency-bot`, `gitea-mirror`, `secret-scanning-precommit`,
  `cve-scan-ci`.
