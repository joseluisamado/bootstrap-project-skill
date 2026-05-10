# Stack-shaped practices

The skill's generic core is stack-agnostic. Some practices, though, are stack-specific and live outside the core. This doc captures them as reference.

## Database migrations

If your project uses a database, you need a migration tool. Pick one before writing the second migration; switching tools later is painful.

Common picks per stack:

- **Python + SQLAlchemy** → Alembic.
- **Python + Django** → Django migrations.
- **Node + Prisma** → Prisma migrations.
- **Node + Knex** → Knex migrations.
- **Go** → `golang-migrate`, `goose`, or `atlas`.
- **Rust + sqlx** → sqlx migrations.

Convention regardless of tool:

- Migrations live at `<project>/migrations/` (or wherever the tool defaults).
- One migration per logical change, not "weekly batch."
- Migrations are forward-only by default. Down migrations are nice but rarely correct in practice.
- Migrations run as part of deploy, not as a manual step.

The skill's `docs/DEPLOY.md` template includes a placeholder for the migration step in §5 if you have one.

## API contract testing

If your project has a public API contract (REST, GraphQL, gRPC), consider adding contract tests separate from unit tests:

- **OpenAPI**: generate the schema, validate responses against it (`schemathesis` for Python, `openapi-validator` for Node).
- **GraphQL**: schema is the contract; introspection-based clients catch drift.
- **gRPC**: proto file is the contract; generated clients catch drift at compile.

Contract tests catch "we changed the response shape and didn't update the docs" — a class of bug pure unit tests miss.

## Frontend bundle-size budgets

For frontend-heavy projects, set a bundle-size budget:

- `bundlesize` (npm) for size assertions in CI.
- Vite + `rollup-plugin-visualizer` for diagnosing large chunks.

The libreta target (self-hosted, single-user-ish) doesn't need this — you control the network. For projects shipped to mass users on slow networks, it matters.

## Database seed / fixture data

If the project has a database with non-trivial setup, ship a `make seed` target that populates a minimum useful state. Keep seed data idempotent (running twice produces the same result).

Seed data lives at `scripts/seed.<lang>` or similar. Don't put it in test fixtures — those are for tests; this is for dev / demo.

## Per-stack lint configs

The skill scaffolds lint commands but doesn't ship per-stack configs (`.ruff.toml`, `.eslintrc`, `.prettierrc`). Configs are stack-and-team-specific; the skill assumes you'll add them in M0 housekeeping.

Reasonable defaults:

- **Python (ruff)**: enable a sensible rule set; default `pyproject.toml` config.
- **TypeScript (eslint)**: `@typescript-eslint/recommended` + `eslint-plugin-vue` or `eslint-plugin-react` per framework.
- **Go (golangci-lint)**: enable the default linters, add `goimports`.
- **Rust (clippy)**: default lints; consider `clippy::pedantic` for new projects.

## Stack-shaped practices the skill explicitly skips

- **Frontend a11y testing** — depends on framework, available as `a11y-checks` flag.
- **i18n** — depends on framework, available as `i18n-scaffold` flag.
- **GraphQL schema-first development** — graphql-specific.
- **Server-side rendering / static-site generation** — varies wildly per stack.
- **Realtime layer** (websockets, SSE, WebRTC) — too project-specific.

If your project needs any of these, scaffold them in M0 / M1 alongside the rest of the stack work.
