# Inviolable rules — derivation and lifecycle

`CLAUDE.md` §2 lists the project's "Inviolable rules" (R-N). This doc explains how rules derive from principles, how they relate to other guardrails, and how they change.

## Rules derive from principles

A **principle** (P-N in PROJECT.md) is a value statement: "the filesystem is the source of truth."

A **rule** (R-N in CLAUDE.md) is the code-level enforcement of a principle: "no code path stores user content only in SQLite/memory/etc."

The relationship is one-to-many: one principle may produce zero, one, or several rules. A principle that has no obvious code-level violation may collapse to itself in the rule list.

Each rule cites the principle it enforces:

```markdown
### R1. The markdown round-trip is sacred.

`docs/PROJECT.md` P3. Any change that breaks the byte-identical round-trip
on the fixture corpus is rejected.
```

The citation makes the rule legitimate. Rules without principles are arbitrary.

## How to derive a rule from a principle

For each principle, ask: **"What would *break* this principle in code?"**

The rule is the negative form of that breakage.

Examples:

| Principle | What would break it | Resulting rule |
|---|---|---|
| Filesystem is source of truth | Storing user data only in a DB | "No code path stores user content only in SQLite/memory/etc." |
| Every save is a commit | A "save without commit" path for performance | "There is no 'save without commit' code path." |
| No reliance on public services at runtime | Loading drawio from `embed.diagrams.net` | "Required components ship with the stack." |
| No custom markdown syntax | Adding a `:::admonition` block | "CommonMark + GFM only." |

Aim for **fewer rules than principles**. Rules are the surface agents enforce; principles are the constitutional layer.

## Rule lifecycle

Rules are inviolable in the sense that **breaking them silently is a bug**. To change a rule:

1. Edit the principle in PROJECT.md.
2. Update the rule in CLAUDE.md to match.
3. Commit both in one change.
4. Note the change in PROGRESS.md and (if user-visible) CHANGELOG.md.

**Never weaken a rule to make a feature land.** If a feature would require breaking a rule, the feature is redesigned or dropped — not the rule.

If you find yourself wanting to weaken a rule, the question to ask is: "is the principle behind this rule still right?" If yes, the rule stays; the feature changes. If no, the principle changes — and that's a project-level decision, not a feature-level one.

## What rules are not

Rules are not a coding-style guide. Style is captured by linters (ruff, eslint, prettier) and by the per-language `### Conventions` subsections in CLAUDE.md (§3.5, §4.5).

Rules are not best practices. Best practices are advice; rules are commitments.

Rules are not testing requirements. "All code must have tests" is a habit, not a rule. Rules are about what the code does (or refuses to do), not about how it's developed.

## Counter-examples — what makes a bad rule

- **Too vague**: "Be careful with security." (Not enforceable.)
- **Too narrow**: "All functions must return Result types." (Style, not principle.)
- **Not derived from a principle**: "Always use async." (Where's the underlying value?)
- **Aspirational**: "Code should be elegant." (Not a decision rule.)

A rule that doesn't pass "what would breaking this look like in code?" is not a rule.

## Default count

A typical project has **3–6 rules** derived from **3–8 principles**. Fewer principles than rules is suspicious — the rules don't have enough constitutional grounding. Many more principles than rules is fine; some principles are values that don't have direct code analogues.
