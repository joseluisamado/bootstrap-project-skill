# Pattern: NixOS appliance / system-management flake

## When this pattern applies

You're building a project whose deliverable is **a NixOS-based system (or set of systems) declared in a flake**, not an application. Concrete shapes:

- A home-server / home-lab appliance (the homeops case).
- A laptop / workstation configuration repo (à la `dotfiles-but-NixOS`).
- A small fleet of single-purpose hosts (a media server + a backup box + a router).
- A custom NixOS-based image distribution (a derivative for a hardware vendor).

The common thread: the source of truth is a flake, the artifact is one or more **NixOS system closures** (typically materialised as SD images, USB ISOs, or remote `nixos-rebuild` activations), and the operational model is **GitOps on a tiny scale** — push to main, hosts converge.

This pattern is *not* for:

- Nix as a build tool for non-NixOS apps (use a regular stack profile + a `flake.nix` package output).
- Pure Nix libraries (modules-only, no system).
- Kubernetes-or-larger orchestration (the host is the unit; if you're managing > ~10 hosts, you're past this pattern).

## The shape

```
<project>/
├── flake.nix                 entry point; host registry; devShell; checks
├── flake.lock
├── hosts/
│   ├── _common/              shared modules across hosts
│   │   ├── base.nix          ssh, firewall, journal, nix daemon settings
│   │   ├── docker.nix        (optional) container runtime if services use it
│   │   ├── sops.nix          sops-nix wiring
│   │   └── self-update.nix   systemd timer running nixos-rebuild switch
│   └── <hostname>/
│       ├── default.nix       imports _common + host-specific files
│       ├── hardware.nix      nixos-generate-config output (real machine)
│       ├── network.nix       static IP, hostname
│       └── meta.nix          { system; class; } — tooling-readable
├── services/                 (if applicable) the GitOps surface
│   ├── _template/            copy to create new services
│   └── <name>/
│       ├── compose.yml       standard docker-compose; pinned by digest
│       ├── meta.nix          { enabled; hosts; description; }
│       └── config/           optional bind-mounts
├── modules/
│   └── service-loader.nix    walks services/, applies enabled ones per host
├── secrets/                  sops-encrypted, one file per recipient set
│   └── README.md
├── .sops.yaml                encryption rules
└── docs/                     standard quintet + DEPLOY tailored for flash/boot
```

## Why this shape

### Host registry as an attrset

`flake.nix` declares a top-level `hosts` attrset and fans `nixosConfigurations` out of it with `lib.mapAttrs`. Adding a host is one line in the attrset plus a directory under `hosts/`. Hard-coding each `nixosConfigurations.<name>` block tends to drift.

### `specialArgs` carries `hostName` and `hostMeta`

Every module imported into a host config receives `{ hostName, hostMeta, inputs, self }` as named args. This is how `hosts/_common/base.nix` can do `networking.hostName = hostName` without being host-specific. Without `specialArgs`, you end up either hard-coding hostnames or threading them through a parameter dance.

### Shared `_common/` + per-host directory

The split is structural, not aesthetic. `_common/` is "every host gets this" — promoting something there is a deliberate act. Per-host directories own everything else. This makes "what does host X actually run" answerable by reading one directory.

A trap to call out: **never edit `_common/` to fix one host's problem**. Either the change applies to all hosts (promote to `_common/`) or it doesn't (push down to `hosts/<name>/`). Mixed-purpose `_common/` modules are the start of unmaintainable Nix.

### GitOps service surface via `services/<name>/`

If the appliance hosts services (Pi-hole, Caddy, Jellyfin, whatever), declaring them as directories under `services/` with `compose.yml` + `meta.nix` keeps three properties:

1. **Standard docker-compose** stays copy-pasteable from awesome-selfhosted. The Nix layer doesn't force you to author services natively in Nix unless you want to.
2. **Per-host enablement** via `meta.nix.hosts = [ "nanopi" ]` makes "move a service from host A to host B" a one-file change.
3. **The service-loader module** is the only mechanism that turns a `services/<name>/` directory into a running container. Forbidding `docker run` on managed hosts (a project-level rule) keeps the GitOps surface authoritative.

The bridge from `compose.yml` to NixOS modules is **compose2nix**, which generates `virtualisation.oci-containers` attrs. Alternatives:

- **arion** — author services in Nix directly. More Nix-native, less portable.
- **Hand-written `oci-containers` attrs** — most control, most boilerplate, no standard format.

Default to compose2nix unless there's a reason not to.

### Secrets via sops-nix

`secrets/` holds sops-encrypted YAML. Each file has its recipient list declared in `.sops.yaml`. Plaintext never touches git; decryption happens at activation only, into `/run/secrets/`.

The corresponding **inviolable rule** that should appear in every project using this pattern: *no unencrypted secrets in git, ever* — gated by a pre-commit hook that grep'd for the `sops:` marker on every file under `secrets/`.

### Self-update via systemd timer

A small module under `hosts/_common/self-update.nix` installs a systemd timer that runs `nixos-rebuild switch --flake <pinned-repo>#<hostname>` on a schedule. NixOS's atomic generations mean a failed converge stays on the previous generation. This is strictly better than `ansible-pull` for the same reason: failures can't half-apply.

The timer interval is per-host config. Hourly is a reasonable default for home-scale; faster for development hosts; slower (or off) for stable production.

### Deploy artifact: image + flake

For appliance-shaped projects the canonical artifact is **the SD/USB/VM image built by `nixos-generators` or NixOS's built-in `sdImage`**, plus the flake repo itself. Built locally with `nix build .#nixosConfigurations.<host>.config.system.build.sdImage`, or in CI for distribution.

This is what the skill's `deploy_model = artifacts` value captures. `docker-compose` is wrong (services run inside the appliance, but the *appliance* isn't deployed as compose); `single-binary` is wrong (the closure isn't a binary); `library` is wrong (nothing is being published as a library).

## Decisions that always come up

These are decisions every project using this pattern will face. List them early so the operator decides intentionally, not by accident.

- **nixpkgs channel**: stable release vs. unstable. Stable is the safer default; unstable buys fresher service images at the cost of more churn.
- **Compose2nix vs. arion vs. raw oci-containers**: see above.
- **Where the age key lives on managed hosts**: usually `/var/lib/sops-nix/key.txt`, seeded into the image or provisioned out-of-band on first boot.
- **DHCP fallback strategy**: if this appliance serves DNS, the router DHCP must hand out a public-resolver secondary. Document as an inviolable rule.
- **State: which docker volumes are durable vs. disposable**: catalogue in `docs/BACKUP.md`. The flake repo is the authoritative backup for everything else.
- **Hardware scope**: ARM-only? x86 too? RISC-V? The flake supports all via per-host `system` fields, but binary cache hits get sparser as you leave aarch64/x86_64.

## When to depart from this pattern

- **>~20 hosts**: the flat `hosts/` directory and the single `flake.nix` get unwieldy. Consider `flake-parts` or splitting per-environment.
- **Multi-tenant / non-trivial RBAC**: this pattern assumes one operator. If multiple humans manage independent hosts, secrets isolation gets harder.
- **High availability**: the pattern accepts single-host services as fine. Active-passive HA on home scale is overkill; if you genuinely need it, build it deliberately, not by accident.

## Reference implementation

The first project to use this pattern is **homeops** (a local-DNS-first home infrastructure platform). Its `flake.nix`, host structure, and service template are good worked examples; see also its `docs/rfcs/0001-initial-flake-shape.md` for the flake-level design rationale.
