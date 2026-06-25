# Changelog — bootstrap-project skill

All notable changes to this skill are recorded here.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/)
and the skill adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

The version recorded in a project's `.bootstrap-meta.yaml` matches the
version below at the time of scaffolding. See [`MIGRATIONS.md`](./MIGRATIONS.md)
for upgrade notes when the skill version bumps.

## [Unreleased]

### Added

- **New sibling skill: `bootstrap-investigation`** (own version, starting at
  0.1.0; see [`investigation-skill/CHANGELOG.md`](./investigation-skill/CHANGELOG.md)).
  Scaffolds investigation/documentation projects — recoveries, reverse-engineering,
  forensics, research write-ups — whose deliverable is understanding plus an
  auditable record rather than software built from source. Swaps bootstrap's
  stack/deploy axes for a *subject* + *artifact-provenance policy*
  (private-archive / public-writeup / none), a phased `plan/ROADMAP.md` with an
  optional go/no-go **gates** decision log, an append-only **logbook/**, and
  `evidence/` + `sources/` archives. Shape distilled from a real firmware-recovery
  project. `install.sh` now installs all three skills; `investigation-skill/`
  ships its own `templates/` (not shared with bootstrap).

## [0.3.0] — 2026-06-04

### Added

- **Commit-driven CHANGELOG + one-command release.** New verbatim template
  `scripts/changelog.py` generates `CHANGELOG.md` from Conventional Commit
  subjects (feat→Added, fix→Fixed, perf/refactor→Changed, docs→Documentation,
  breaking `!`→BREAKING CHANGES; chore/test/ci/build/style dropped), bumps
  `VERSION`, and propagates to stack manifests via `sync_version`'s TARGETS.
  Modes: `--level`/`--set` (prompts if neither), `--check`, `--revert`,
  `--backfill`, `--dry-run`. Generalized from the Libreta reference project.

### Changed

- **`Makefile.tmpl` release flow reworked.** `make release` is now a single
  orchestrator: check for unreleased commits → prompt for LEVEL (or `LEVEL=`)
  → write VERSION+CHANGELOG → build → **revert the cut if the build fails** →
  commit `chore(release): vX.Y.Z` → tag (→ push images if `has_compose`). New
  `make release-current` re-ships the current VERSION as-is; new `make
  changelog` / `changelog-backfill`. The version bump moved out of the release
  target into `scripts/changelog.py`.
- **`CHANGELOG.md.tmpl`** reseeded to the generator's header format with a
  single dated version section (was the old `[Unreleased]`-accumulation shape).
- **Docs templates** updated to the generated-changelog reality: `CLAUDE.md`
  (pre-flight + living-docs note), `CONTRIBUTING.md` ("your commit subject is
  the changelog entry"), and `docs/DEPLOY.md` (new §8b "Cutting a release").

### Migration

See [`MIGRATIONS.md`](./MIGRATIONS.md) for v0.2.0 → v0.3.0 notes. Existing
projects keep working unchanged; the new release flow is opt-in.

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
