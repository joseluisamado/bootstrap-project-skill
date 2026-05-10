# Why the libreta shape

The conventions this skill scaffolds come from one project — Libreta, a self-hosted wiki — and have been refined and extended through a deliberate review.

This document captures *why* the conventions look the way they do, so future-you (or anyone evolving the skill) can tell load-bearing structure from incidental detail.

## The four-tier doc structure

`PROJECT → ARCHITECTURE → ROADMAP → PROGRESS` plus `DEPLOY` is not Diátaxis under another name (though it happens to map onto it). It evolved from a different observation: software projects need four kinds of stable documents.

- **PROJECT.md** — the constitutional layer. Vision, principles, non-goals. Rarely changes. Read first.
- **ARCHITECTURE.md** — the design layer. Components, data model, decisions. Changes when the design changes. Read when making a design choice.
- **ROADMAP.md** — the planning layer. What ships when (without dates). Changes by milestone. Read when planning what to do next.
- **PROGRESS.md** — the execution layer. What did ship, when, with what reasoning. Changes after every chunk of work. Read when you need a snapshot.

`DEPLOY.md` is the operations counterpart: how to run what the other four describe.

The split has one critical property: **each layer answers a different question** ("what is this and why?", "how does it work?", "what's next?", "where are we?"). When all four exist, no single doc has to be everything.

## Principles as decision rules, not aspirations

The single most load-bearing convention in libreta's PROJECT.md is the framing of principles.

> "These are decision rules, not aspirations. When a feature request conflicts with a principle, the principle wins; the feature is redesigned or dropped."

Without that framing, "principles" become marketing — feel-good statements that don't actually decide anything. With it, principles become a contract: when you read a principle, you've signed up to refuse anything that breaks it.

The skill enforces this framing in the PROJECT template and in CLAUDE.md's R-rule lifecycle note.

## Inviolable rules cite principles

Rules (R-N in CLAUDE.md) are stricter than principles (P-N in PROJECT). A principle is a value; a rule is the code-level enforcement of that value. Each rule names the principle it enforces.

The mapping makes the rules legitimate: an agent reading CLAUDE.md can trace back to the constitutional source. Rules without principles are arbitrary. Principles without rules are toothless.

## Decisions are dated and have Why + Consequence

Every D-NN entry in ARCHITECTURE has three required parts:

- The decision itself (one or two sentences).
- **Why**: the reason it was made, including alternatives considered.
- **Consequence**: what we're now committed to as a result.

Without Why, decisions rot — six months later, no one remembers. Without Consequence, decisions feel cheap — there's no acknowledgment that choosing X means giving up Y.

Dating is mandatory because old decisions need to be revisitable. Date stamps are the easiest way to know "is this still current?"

## Roadmap without dates

Roadmaps with dates slip. Roadmaps without dates don't promise anything they can't deliver. The roadmap describes *what done looks like* (exit criteria); the *when* falls out of the work.

This is a small structural choice with an outsized cultural effect: removing dates removes the urge to ship low-quality work to hit a deadline that wasn't there to begin with.

## Polish milestones are first-class

`M0.5` between `M0` and `M1` (or `M3.5` between `M3` and `M4`) isn't a deviation — it's the right move when real usage of the previous milestone surfaces rough edges. The roadmap template signals this explicitly so a reader knows the pattern.

The lesson: don't make polish a slipped feature milestone. Make it its own thing, named, with its own exit criteria.

## "What we will not do" closes the roadmap

Scope creep enters through the roadmap. The closing "What we will not do" section is the immune response — a restatement of non-goals from PROJECT.md, explicitly listed at the end of the roadmap so anyone reading top-to-bottom finishes with the boundaries.

## PROGRESS as a self-verifying log

Each PROGRESS entry ends with a pre-flight sign-off line:

> **Pre-flight**: backend 95/95 tests pass, ruff/mypy clean. Frontend 65/65 pass, vue-tsc clean.

This isn't bureaucracy — it's the assertion that makes the entry verifiable. Without the sign-off, "I shipped X" is a claim. With it, it's a checkable claim.

## CLAUDE.md as an evolving operating manual

The most valuable section of libreta's CLAUDE.md is `§9 Things that look fine but aren't` — accumulated traps that future-agents would otherwise re-encounter. The convention "when you correct yourself twice, write it down" turns the doc into a living memory.

The skill's CLAUDE.md template ships with §9 empty and a comment that says "fill it as patterns emerge."

## Single-source-of-truth `VERSION` file

A plain-text `VERSION` file at the project root is the canonical source. Everything else (pyproject.toml, package.json, Docker tags, git tags) is derived. The propagation is a one-line script.

This pattern survives every project shape because it doesn't depend on any one stack's conventions — it imposes its own and asks each stack to follow.

## Layered docker-compose overlays

The base file is production-default. Dev overlays add bind-mounts and reloaders. Production overlays pin versions. TLS overlays add Caddy. Each is a focused concern; you compose only the overlays you need.

The pattern depends on `docker compose -f base -f overlay` — well-documented but underused. The skill makes it the default rather than a rare ceremony.

## Two-repo distinction (when applicable)

Projects that produce user-content git repos (like libreta producing the user's wiki) have *two* repositories: the project itself and the user-content one. CLAUDE.md §6.3 calls this out explicitly because conflating them is a recurring trap.

The skill includes §6.3 conditionally — only when the design conversation reveals user-content sub-repos.

## What's deliberately *not* libreta

A few things in libreta were idiosyncratic and don't ship in the skill:

- The absolute host bind-mount in `docker-compose.yml` (developer convenience that leaked).
- Tiptap-specific markdown round-trip details (project-specific R-rule, not universal).
- DokuWiki / Apple Notes importers (project-specific scripts).
- The `data/content/` content-repo bind-mount (deprecated by libreta itself in M3.5).

The skill keeps the *shape* without the libreta specifics.

---

## Reading order for evolving the skill

If you want to change the skill's conventions, read in this order:

1. The five `04-final-design.md` decisions in the parent repo.
2. The 92 findings in `02-review-notes.md`.
3. The 47 practice evaluations in `03-missing-practices.md`.
4. This document.

Each later document refines the earlier ones. Don't change a convention here without checking which finding or evaluation introduced it — there's likely a reason that won't be obvious from the template alone.
