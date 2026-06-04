# INSTRUCTIONS.md — bootstrap-project skill playbook

You (Claude) have been invoked as the `bootstrap-project` skill. The user
has just had a project-design conversation in this session and wants to
crystallize it into files.

Your job is to:

1. **Refuse if invoked cold.** If no design conversation precedes this
   invocation, stop immediately and tell the user: "I need a design
   conversation before I can scaffold a project. Discuss vision,
   principles, milestones, and stack first, then invoke me again."
   Do not proceed to extraction.

2. **Extract** a project spec from the current conversation.

3. **Confirm** the spec with the user in a single block.

4. **Ask** for license and optional add-ons.

5. **Write** the scaffold using `templates/` in this skill directory.

6. **Report** what was written and what remains for the user to fill in.

Read the rest of this document carefully before starting.

---

## 1. Verifying the conversation

Before extracting, verify these signals from earlier in the conversation:

- A project name (or working name).
- A vision or one-line description.
- At least one principle, value, or sacred invariant.
- At least a hint of milestones, phases, or "what to ship first."
- Some indication of stack (or "we'll figure it out").

If two or more signals are missing, refuse politely and ask the user to
fill them in before continuing.

---

## 2. Extraction

Build a spec object with these fields:

| Field | Required | Source |
|---|---|---|
| `project_name` | yes | Conversation; ask if ambiguous. |
| `project_slug` | yes | Lowercase-hyphenated `project_name`; confirm. |
| `tagline` | yes | One-line description from conversation; ask if missing. |
| `audience` | yes | Who this is for; ask if missing. |
| `description` | yes | Short paragraph; can derive from tagline + context. |
| `principles` | yes (≥3) | List of principles; if fewer than 3 in conversation, ask. |
| `rules` | yes (≥1) | Inviolable rules derived from principles + sacred invariants. |
| `milestones` | yes (≥3) | M0..MN; if fewer, ask. |
| `stack_profile` | yes | One of: python-only / node-only / python+node / go-only / rust-only / nix-flake / polyglot / none-yet. |
| `backend_framework` | conditional | If stack has a backend, the framework name. |
| `frontend_framework` | conditional | If stack has a frontend, the framework name. |
| `has_user_content_subrepos` | yes (bool) | Does the project produce user-content git repos? (Like libreta's `data/`.) |
| `deploy_model` | yes | docker-compose / single-binary / artifacts / library / none-yet. |
| `nixpkgs_channel` | conditional | If `stack_profile = nix-flake`. Default: latest stable release. |
| `local_domain` | conditional | If `stack_profile = nix-flake` and the project hosts LAN services (e.g. `home.arpa`). |
| `example_host_name` | conditional | If `stack_profile = nix-flake`. The first host to scaffold. |
| `example_host_system` | conditional | nixpkgs system tuple for the example host (e.g. `aarch64-linux`). |
| `example_host_class` | conditional | One of: `arm-sbc` / `x86-mini-pc` / `riscv-sbc` / `vm`. |
| `has_services` | conditional | If `stack_profile = nix-flake`. Does this project run services on its hosts? |
| `has_dns_service` | conditional | If `has_services`, does the appliance run its own DNS (changes the example host's network config to point at `127.0.0.1`)? |
| `user_email` | yes | For SECURITY.md disclosure. Get from session env or ask. |
| `competitors` | optional | If the user mentioned alternatives, the comparison-table candidates. |

For each field, write down where you got it from (conversation timestamp,
inference, etc.). If a field is inferred rather than stated, mark it
clearly when you confirm with the user.

### Deriving rules from principles

Rules (R-N) are stricter than principles (P-N). A principle is "the
filesystem is the source of truth"; a rule is "no code path stores user
content only in SQLite/memory/etc."

Heuristics for deriving rules from a principle:

- For each principle, ask: "what would *break* this principle in code?"
- The rule is the negative form of that breakage.
- Rules cite principles by number: `R1 (from P1) — ...`
- If the principle has no obvious code-level violation, the rule may
  collapse to the principle itself.

Aim for fewer rules (3–6) than principles (3–8). Rules are the surface
agents enforce; principles are the constitutional layer.

---

## 3. Confirming the spec

Print the spec in a single block and ask "ready to write, or correct
anything?" Format:

```
About to bootstrap "{{project_name}}" with:

  Description: {{tagline}}
  Audience: {{audience}}
  Stack: {{stack_profile}} ({{backend_framework}} + {{frontend_framework}})
  Deploy: {{deploy_model}}
  License: <not yet asked>
  User-content sub-repos: {{has_user_content_subrepos}}
{{#if stack_profile_is_nix_flake}}
  Nix profile:
    nixpkgs channel: {{nixpkgs_channel}}
    Example host: {{example_host_name}} ({{example_host_system}}, {{example_host_class}})
    Services surface: {{has_services}}
    DNS service on appliance: {{has_dns_service}}
    Local domain: {{local_domain}}
{{/if}}

  Principles ({{N}}):
    P1 — ...
    P2 — ...
    ...

  Rules ({{N}}):
    R1 (from P1) — ...
    R2 (from P2) — ...
    ...

  Milestones ({{N}}):
    M0 — Foundations
    M1 — ...
    ...

About to ask: license choice, optional add-ons.

Ready, or correct anything first?
```

If the user corrects, re-print the corrected version and confirm again.
Do not proceed until they say "go" or equivalent.

---

## 4. Explicit asks

### License

Use `AskUserQuestion` to offer:

- MIT (Recommended for permissive)
- Apache-2.0 (permissive with patent clause)
- AGPL-3.0-only (Recommended for self-hosted services with copyleft)
- GPL-3.0-only (copyleft, not network-aware)
- BSL-1.0 (source-available, becomes Apache after N years)
- proprietary (no public license)

The user picks one. Skill writes the canonical text from
`templates/licenses/<name>.txt` to `LICENSE` and notes the SPDX
identifier in `pyproject.toml` / `package.json` if applicable.

### Optional add-ons

Use `AskUserQuestion` (multiSelect=true) with these flags. Defaults:

- `secret-scanning-precommit` — ON
- `cve-scan-ci` — ON
- everything else OFF

| Flag | Description |
|---|---|
| `rfc-process` | Scaffold `docs/rfcs/` with template + CLAUDE.md note |
| `readme-badges` | Add CI / version / license badges to README |
| `runbook` | Add `docs/RUNBOOK.md` operational playbook |
| `observability-stub` | Wire structured logging + `/metrics` endpoint stub |
| `signed-tags` | `make release` uses `git tag -s` instead of `-a` |
| `digest-pinned-images` | Pin Docker base images by sha256 instead of tag |
| `sast` | Add SAST tool to CI (bandit / semgrep) |
| `a11y-checks` | Add automated accessibility checks (frontend only) |
| `i18n-scaffold` | Wire i18n library with `en.json` (frontend only) |
| `external-contributions` | Add CoC, issue/PR templates |
| `dependency-bot` | Add Dependabot or Renovate config |
| `gitea-mirror` | Also write `.gitea/workflows/` mirror of CI |
| `secret-scanning-precommit` | `detect-secrets` pre-commit hook |
| `cve-scan-ci` | `pip-audit` / `pnpm audit` job in CI |

Some flags are conditional: `a11y-checks` and `i18n-scaffold` are only
shown if the stack has a frontend.

### Nix-flake profile asks

When `stack_profile = nix-flake`, ask these in addition to the standard
license + add-ons set. Defaults marked **(Recommended)**:

1. **nixpkgs channel** — `nixos-XX.YY` (latest stable, **Recommended**) vs.
   `nixos-unstable`. The skill keeps the current stable in
   `templates/profiles/nix-flake/CHANNEL` (one line, e.g. `nixos-25.05`).
   Read it; bump it manually when a new release lands.
2. **Example host name** — short slug for the first declared host
   (e.g. `nanopi`, `nuc`, `vm`). The scaffold creates `hosts/<name>/`
   and references it across Makefile targets.
3. **Example host system** — nixpkgs system tuple (`aarch64-linux` Recommended
   for SBCs; `x86_64-linux` for mini-PCs; `riscv64-linux` for RISC-V).
4. **Example host class** — `arm-sbc` / `x86-mini-pc` / `riscv-sbc` / `vm`.
   Used only as documentation metadata in `hosts/<name>/meta.nix`.
5. **`has_services`** — does this project run services on its hosts (Pi-hole,
   Caddy, etc.)? **Recommended** for appliance-shaped projects; skip for
   pure host-config (laptop dotfiles-as-NixOS) projects.
6. **`has_dns_service`** — conditional on `has_services`. Does the appliance
   run its own DNS resolver (Pi-hole, dnsmasq, Unbound)? If yes, the
   example host's `network.nix` sets `dns = [ "127.0.0.1" ]` so the host
   uses its own resolver; otherwise public resolvers are configured.
7. **Local domain** — conditional on `has_services`. The DNS domain for
   LAN services (`home.arpa` Recommended per RFC 8375; or `lan`, `local`,
   or a real subdomain you own).

The default `deploy_model` for `stack_profile = nix-flake` is `artifacts`
unless the user opts otherwise.

---

## 5. Planning files to write

Compute the file list:

- All "always-present" files from §6.
- Conditional files based on flags from §6 conditional list.
- Skip any file that already exists at the target path.

Print the planned list before writing:

```
Planning to write 28 files:
  ✓ README.md
  ✓ CLAUDE.md
  ⊘ docs/PROJECT.md (already exists; will skip)
  ...
```

Then write.

---

## 6. Writing files

Use the `Write` tool, never `Bash` shell redirection.

For each templated file:

1. Read the template from `templates/<path>.tmpl`.
2. Render it: substitute `{{placeholder}}` values; expand `{{#if flag}}...{{/if}}` blocks.
3. Write to the target path inside the project root.

For files copied verbatim (e.g. `scripts/sync_version.py`,
`scripts/changelog.py`, `templates/licenses/<name>.txt` → `LICENSE`,
`.editorconfig`), skip templating and copy bytes.

### Always-present files

```
README.md
CLAUDE.md
CONTRIBUTING.md
SECURITY.md
CHANGELOG.md
LICENSE
VERSION
BOOTSTRAP-MANIFEST.md
.bootstrap-meta.yaml
.editorconfig
.gitignore
Makefile
.pre-commit-config.yaml
docs/PROJECT.md
docs/ARCHITECTURE.md
docs/ROADMAP.md
docs/PROGRESS.md
docs/DEPLOY.md          # tailored to deploy_model; "library" → PUBLISH.md
docs/BACKUP.md          # only if deploy_model != library
docs/SECURITY-REVIEW.md # stub
docs/PERFORMANCE.md     # stub
docs/INCIDENTS.md       # empty log
docs/PRIVACY.md         # short doc
scripts/README.md
scripts/sync_version.py # copied verbatim
scripts/changelog.py    # copied verbatim — commit-driven release cut
scripts/setup-dev.sh
.github/workflows/ci.yml
```

### Conditional files

| Flag | Files |
|---|---|
| `deploy_model = docker-compose` | `docker-compose.yml`, `docker-compose.dev.yml`, `docker-compose.prod.yml`, `.env.example` |
| `deploy_model = docker-compose` AND user enables Caddy | `docker-compose.caddy.yml`, `Caddyfile.example` |
| `stack_profile = nix-flake` | `flake.nix`, `hosts/_common/base.nix`, `hosts/<example_host_name>/{default,hardware,network,meta}.nix`, `.sops.yaml`, `secrets/README.md`, `.gitignore`, profile's `Makefile`, profile's `.pre-commit-config.yaml`, profile's `.github/workflows/ci.yml`, `scripts/check-sops.sh` |
| `stack_profile = nix-flake` AND `has_services = true` | `services/_template/{README.md,meta.nix,compose.yml}` |
| `deploy_model = artifacts` | Skips `docker-compose*.yml`; `docs/DEPLOY.md` rendered from the artifact variant (flash + bootstrap guide instead of compose-up). |
| `gitea-mirror` | `.gitea/workflows/ci.yml` |
| `runbook` | `docs/RUNBOOK.md` |
| `rfc-process` | `docs/rfcs/0000-template.md` |
| `external-contributions` | `CODE_OF_CONDUCT.md`, `.github/ISSUE_TEMPLATE/bug_report.md`, `.github/ISSUE_TEMPLATE/feature_request.md`, `.github/PULL_REQUEST_TEMPLATE.md` |
| `dependency-bot` | `.github/dependabot.yml` |

### Profile templates

Templates that vary by `stack_profile` live under `templates/profiles/<profile>/`.
Files in there can shadow always-present templates with the same name (e.g. the
`Makefile.tmpl` under `profiles/nix-flake/` replaces the default `Makefile.tmpl`
when `stack_profile = nix-flake`). The flat `templates/` files remain the default
for stack profiles without a dedicated profile directory.

Current profiles:

- `nix-flake` — see [`patterns/appliance-nixos.md`](./patterns/appliance-nixos.md)
  for the design rationale.

Caddy isn't a separate flag in §4 — ask "include Caddy TLS overlay?" only
if `deploy_model = docker-compose`.

### Invariants when writing

- **Never write outside the project root.** Compute paths from `cwd`,
  refuse if any path resolves outside.
- **Never clobber existing files.** Use Read first to check existence;
  if file exists, log "skipped (exists): path" and continue.
- **Cross-references between docs use canonical relative paths.**
  README links to `docs/PROJECT.md`, not `./docs/PROJECT.md` and not
  `docs/PROJECT`. Templates encode this; don't rewrite.

---

## 7. After writing

### Generate `BOOTSTRAP-MANIFEST.md`

Sections:

```markdown
# Bootstrap manifest

Generated by **bootstrap-project** skill v{{skill_version}} on {{date}}.

## Spec used

- Project name: {{project_name}}
- Stack: {{stack_profile}}
- Deploy: {{deploy_model}}
- License: {{license_name}}
- User-content sub-repos: {{has_user_content_subrepos}}
- Principles: {{N}}
- Milestones: {{N}}
- Add-ons enabled: {{list}}

## Files written

| Path | Purpose |
|---|---|
| `README.md` | ... |
| ... | ... |

## TODO markers

Files containing `{{TODO}}` markers (count by file). Search:
`grep -rn '{{TODO' --include='*.md'`.

| File | Markers |
|---|---:|
| `docs/ARCHITECTURE.md` | 3 |
| ... | ... |

## Next 30 minutes

1. `git init && git add . && git commit -m "Initial scaffold from bootstrap-project skill"`
2. Open `docs/ARCHITECTURE.md`, draft the system diagram (mermaid).
3. Open `docs/PROJECT.md`, fill the F-NN table.
4. Set `<your-email>` in `SECURITY.md`.
5. Run `make doctor` to verify dev environment.
6. Decide on the first PR: typically M0 housekeeping.
```

### Generate `.bootstrap-meta.yaml`

```yaml
bootstrap_skill_version: {{skill_version}}
generated: {{iso_timestamp}}
spec:
  project_name: {{project_slug}}
  stack_profile: {{stack_profile}}
  deploy_model: {{deploy_model}}
  license: {{license_spdx}}
  has_user_content_subrepos: {{has_user_content_subrepos}}
  add_ons:
    - {{flag}}
    - ...
```

### Print the punch list

Print to user:

```
Wrote {{N}} files. Manifest: BOOTSTRAP-MANIFEST.md

Next 30 minutes:
  1. git init && git add . && git commit -m "Initial scaffold"
  2. Fill {{TODO}} markers (see manifest for the list)
  3. make doctor — verify dev environment
  4. Open the docs/ quintet and read; everything cross-references
  5. Drafted in your own time: system diagram, F-NN table, first commit

Skill version: {{skill_version}}. Future versions can detect this scaffold
via .bootstrap-meta.yaml and offer migrations.
```

End the skill invocation here. Do not start writing the first PR; that's
the user's call.

---

## 8. Edge cases and refusals

- **Invoked in a non-empty project.** If the cwd already has more than 5
  of the always-present files, refuse: "This directory already looks like
  a bootstrapped project. To re-bootstrap, delete the existing files
  first." Do not partial-write.
- **Conversation has no clear principles.** If the extraction can't find
  ≥3 principles, ask explicitly. If the user can't produce them, refuse
  politely: "Principles are the load-bearing constitutional layer.
  Without them, the rules and CLAUDE.md don't have anything to anchor
  to. Can you state 3–8 principles, or shall we stop and resume after
  more design discussion?"
- **Stack profile = `none-yet`.** Allowed. Skill writes a stack-agnostic
  scaffold with no Makefile language-specific targets. CLAUDE.md becomes
  a stub for the technical sections.
- **Deploy model = `library`.** Skill writes `docs/PUBLISH.md` instead of
  `docs/DEPLOY.md`, skips compose files, skips BACKUP.md.
- **Deploy model = `artifacts`.** New in v0.2.0. Skill renders the
  artifacts variant of `docs/DEPLOY.md` (flash-and-bootstrap guide,
  not a compose-up guide). Skips `docker-compose*.yml`. Compatible with
  any `stack_profile`; the natural pairing is `nix-flake`, but a Go
  project shipping a single binary + an installer script also fits.
- **Stack profile = `nix-flake`.** Skill loads templates from
  `templates/profiles/nix-flake/` shadowing the flat defaults. Asks
  the nix-flake-specific questions per §4. Defaults `deploy_model` to
  `artifacts`. Skips `pyproject.toml` / `package.json` propagation in
  `scripts/sync_version.py` (TARGETS stays empty). See
  [`patterns/appliance-nixos.md`](./patterns/appliance-nixos.md) for
  the design rationale captured during v0.2.0 development.

---

## 9. The skill's own evolution

When the skill itself is updated:

1. Bump the skill's top-level `VERSION` file. `{{skill_version}}` (used in
   `.bootstrap-meta.yaml.tmpl` and `BOOTSTRAP-MANIFEST.md.tmpl`) is sourced
   from it, so new scaffolds stamp the new version automatically.
2. Update `CHANGELOG.md` (in the skill repo), and copy it into `skill/` if you
   keep the in-skill copy in sync.
3. If the new version changes any always-present file's shape, add a
   migration note in `MIGRATIONS.md` so projects on older skill versions
   know what to do.

The skill detects the existing `.bootstrap-meta.yaml` if a project was
previously bootstrapped, but in v0.x it only logs the version mismatch
and does not auto-migrate.
