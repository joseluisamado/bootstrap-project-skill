# Migrations — bootstrap-project skill

When the skill changes its scaffolded shape in a way that affects already-bootstrapped projects, the migration is documented here.

## How to identify your project's skill version

```bash
cat .bootstrap-meta.yaml | grep bootstrap_skill_version
```

If the file is missing, the project predates the skill (or was bootstrapped manually).

## Migration log

### From 0.0.x → 0.1.x

(Will be filled in when 0.1.x lands.)

---

## How migrations work in this skill

The skill follows these rules when changing scaffolded shape:

1. **Patch versions (0.0.1 → 0.0.2)**: bug fixes only. No migration needed; re-running `install.sh` is sufficient.
2. **Minor versions (0.0.x → 0.1.0)**: new templates or new optional add-ons. No migration needed for existing projects unless they want to opt in.
3. **Major versions (0.x.y → 1.0.0)**: structural changes that affect already-bootstrapped projects. Always include a migration doc here.

A "structural change that affects already-bootstrapped projects" looks like:

- Renaming a doc (`PROJECT.md` → `CHARTER.md`).
- Reorganizing the `docs/` directory.
- Splitting one template into many.
- Removing a pattern that projects might depend on.

Cosmetic changes inside templates (e.g. a better `make help` recipe) are *not* breaking — projects that want the improvement update manually; projects that don't, don't.

## Manual migration philosophy

The skill does **not** auto-migrate existing projects in v0.x. Auto-migration is risky:

- A project's docs may have been customized post-bootstrap.
- A project may have intentionally diverged from the template.
- An auto-migration that overwrites work loses data.

For now, migrations are documented here as recipes; the operator runs them by hand. This may change in v1.x if a clear pattern emerges, but the default will always be "the operator decides what to migrate."
