# Reproducible builds

The skill does not aim for fully reproducible builds. Reproducibility is a real engineering discipline (locked timestamps, sorted file orderings, deterministic compression, etc.) and overkill for the libreta-shaped target.

What the skill *does* do is the 80/5 rule — 80% of the value at 5% of the cost.

## What the skill provides

- **Lockfiles**: `uv.lock`, `pnpm-lock.yaml`, `Cargo.lock`, `go.sum`, etc. — every dep version pinned. CI uses `--frozen` to refuse drift.
- **Tag-pinned base images**: `FROM python:3.12.7-slim-bookworm` — a specific minor + patch, not a moving `:3.12-slim`.
- **Single-source `VERSION`**: builds tag images with the same version they declare in code.
- **CI runs the same commands as `make check`**: no CI-only tooling drift.

This is enough for most projects to answer "this image came from this commit" with high confidence.

## What you'd need for *fully* reproducible builds

If you require bit-identical artifacts from the same source:

- **Digest-pinned base images**: `FROM python:3.12.7-slim-bookworm@sha256:...`. The `digest-pinned-images` skill flag enables this. Tradeoff: digests go stale, you fall behind security patches if you don't bump.
- **`SOURCE_DATE_EPOCH`**: set the build timestamp to the commit timestamp so file mtimes are deterministic.
- **Sorted file ordering** in tar / zip steps — most tooling does this by default but it's worth verifying.
- **Deterministic compression**: `gzip -n` (no timestamp), `zstd --no-check`.
- **Build-environment isolation**: each build runs in a clean container, with all toolchain versions pinned.

If your project genuinely benefits from reproducibility (e.g. you ship binaries to consumers who want to verify them), it's worth the engineering. For most projects, the 80% rule is sufficient.

## When to verify

If you do aim for reproducibility, verify periodically:

```bash
# Build twice from clean state, compare digests.
make build-prod
docker save <image>:<tag> | sha256sum > digest1.txt
make clean && make build-prod
docker save <image>:<tag> | sha256sum > digest2.txt
diff digest1.txt digest2.txt
```

If the digests differ, you've drifted. Find the source of nondeterminism and fix it.
