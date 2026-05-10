# Image signing (cosign)

The skill does not scaffold image signing. Self-hosted personal apps usually don't publish signed images.

## When to sign

Sign container images when **any** is true:

- You publish to a public registry that downstream operators pull from.
- Your build pipeline is reproducible enough that signatures are meaningful.
- Compliance requires signed artifacts.

If you're the only consumer of your images, signing is theatre.

## Tools

- **`cosign`** (Sigstore) — keyless signing via OIDC, or with a managed key. Default choice.
- **`docker trust`** — older, less flexible.

## Minimum useful flow

```bash
# Sign on push
cosign sign <registry>/<image>:<tag>

# Verify on pull
cosign verify <registry>/<image>:<tag> --certificate-identity ...
```

For keyless signing (recommended), the signing identity is a GitHub Actions OIDC token; verifications match the workflow that produced the image.

## Where to wire it

If you adopt signing, do it as part of `make release-push`:

```makefile
release-push: ## Push images and sign them
    docker push <registry>/<image>:$(VERSION)
    cosign sign <registry>/<image>:$(VERSION)
    git push --tags
```

Document the verification command in `DEPLOY.md` so consumers know how to check.
