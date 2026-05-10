# ADR vs inline decisions

The skill scaffolds **inline `D-NN` entries** in `docs/ARCHITECTURE.md` "Key decisions" rather than a separate `docs/decisions/NNNN-title.md` directory.

## Why inline at start

For projects with fewer than ~15 decisions, a flat `Key decisions` section in ARCHITECTURE.md is:

- Easier to scan (one file, top-to-bottom).
- Easier to maintain (no per-file boilerplate).
- Easier to reference (D-NN identifiers within a single doc).

The Michael Nygard ADR format (Status, Context, Decision, Consequences) and per-file numbering is excellent at scale — but its overhead doesn't earn its weight until decisions cross ~15.

## When to migrate

Switch to per-file ADRs when **any** of these is true:

- The "Key decisions" section in ARCHITECTURE.md exceeds ~15 entries.
- A single decision needs more than ~2 paragraphs of context.
- Multiple decisions get superseded and the supersession trail becomes hard to follow inline.
- More than one author is maintaining the decision log and the "who decided what when" is becoming muddled.

Until any of these is true, stay inline.

## How to migrate

1. Create `docs/decisions/`.
2. For each existing `D-NN` entry, create `docs/decisions/NNNN-slug.md`. Use the Nygard format:
   ```markdown
   # NNNN — Title

   ## Status

   Accepted (YYYY-MM-DD).

   ## Context

   What problem prompted this decision? (was: the surrounding paragraphs in ARCHITECTURE.md)

   ## Decision

   What we decided. (was: the D-NN sentence)

   ## Consequences

   What follows from accepting this. (was: **Consequence:** line)
   ```
3. In ARCHITECTURE.md, replace each D-NN long-form entry with a one-line summary linking to the new file:
   ```markdown
   - **D-09 (2026-05-03)** — Git sources replace fixed bind-mount. See `docs/decisions/0009-git-sources.md`.
   ```
4. From this point, all new decisions go into per-file ADRs. ARCHITECTURE.md keeps the index but not the prose.

## What stays the same

- Each decision is dated.
- Each decision has a Why and a Consequence.
- Decisions are immutable; supersessions add new entries citing the old.
- `PROGRESS.md` decisions log remains a pointer table.
