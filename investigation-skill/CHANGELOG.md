# Changelog — bootstrap-investigation skill

All notable changes to this skill are recorded here. The skill stamps its
version into every scaffold's `.bootstrap-meta.yaml`.

## [0.1.0] — 2026-06-25

Initial release. The investigation/documentation sibling of `bootstrap-project`.

### Added

- Same-session finalizer that crystallizes an investigation-design conversation
  into a scaffold: docs quintet (PROJECT, FOUNDATION, PROCEDURE, SUBJECT,
  WRITEUP), phased `plan/ROADMAP.md`, append-only `logbook/`, `evidence/` and
  `sources/` archives, CLAUDE.md, LICENSE, CHANGELOG, `.gitignore`,
  `.editorconfig`, `BOOTSTRAP-MANIFEST.md`, and `.bootstrap-meta.yaml`.
- **Subject** spec axis (replaces bootstrap-project's stack) with a
  `docs/SUBJECT.md` fact-sheet to catch mis-identification early.
- **Artifact-provenance policy** ask: `private-archive` (commit scarce/
  proprietary artifacts with per-artifact sha256 + provenance manifests, repo
  as durable backup, private-repo warnings) / `public-writeup` (reference-only)
  / `none`.
- **Gates add-on**: optional `plan/GATES.md` go/no-go decision log
  (OPEN/BLOCKED/PASSED/FAILED) with a gated `ROADMAP.md` variant, for
  risk-laden investigations with terminal or irreversible decision points.
- License texts shared with `bootstrap-project` (single source of truth).

### Design notes

- Shape distilled from a real firmware-recovery project: phased plan,
  hard gates, dated logbook, evidence/sources archives, provenance manifests.
  See [`patterns/investigation-shape.md`](./patterns/investigation-shape.md).
- Retrofit of existing investigation projects is out of scope for v0.1.0.
