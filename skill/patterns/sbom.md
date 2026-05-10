# SBOM (Software Bill of Materials)

The skill does not scaffold SBOM tooling. For self-hosted personal apps, the cost-benefit doesn't add up: SBOMs are valuable when you ship binaries to others, less so when you (the operator) are also (the user).

## When to ship an SBOM

Ship one if **any** is true:

- You distribute container images or binaries to other operators.
- Your project has compliance requirements (regulated industries).
- Downstream consumers ask "are you affected by CVE-X?" and you want to answer in seconds.

If none applies, lockfiles + `pip-audit` / `pnpm audit` give you 80% of the value at 5% of the cost.

## Tools

- **`syft`** (Anchore) — generates SPDX or CycloneDX from a directory or container image.
- **`cyclonedx-bom`** (per ecosystem: `cyclonedx-py`, `cyclonedx-npm`, etc.) — language-specific SBOM generators.
- **GitHub** auto-generates basic SBOMs from dependency-graph data on every release.

For a manual one-off:

```bash
# Container image SBOM
syft <image>:<tag> -o spdx-json > sbom.spdx.json

# Source tree SBOM
syft dir:. -o cyclonedx-json > sbom.cdx.json
```

## Where to put it

If you ship release artifacts, attach the SBOM to the release (GitHub Releases, Docker Hub, etc.). Don't commit large SBOMs to the repo.

If the SBOM is part of your release process, add a `make sbom` target and document it in `DEPLOY.md`.

## Format choice

- **SPDX** — older, widely supported by compliance tooling.
- **CycloneDX** — newer, better metadata for vulnerability mapping.

For new projects, prefer CycloneDX. For projects feeding compliance pipelines, follow what the pipeline expects.
