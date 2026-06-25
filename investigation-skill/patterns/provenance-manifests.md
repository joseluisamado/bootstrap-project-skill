# Provenance manifests and the private-archive posture

Investigations accumulate artifacts: tools, firmware, datasets, documents,
photos. Some are scarce, proprietary, or hard to re-source. Three questions
recur: *what is this blob, where did it come from, and is it safe to run?* A
binary doesn't answer any of them. A **manifest** does.

## The manifest discipline

Every artifact that enters the repo gets a one-file manifest in
`artifacts/manifests/` (copy `_TEMPLATE.md`), recording:

- **sha256** — compute on arrival: `shasum -a 256 <file>`. This is the artifact's
  identity; it lets you detect substitution or corruption later.
- **size** and **type**.
- **Provenance** — where and when it was obtained (URL, forum thread, post,
  person), and any chain of custody. This is the auditable record the file
  itself lacks.
- **Scan status** — for executables/binaries: virus-scan / sandbox status.
  *Treat every downloaded binary as untrusted* until noted otherwise, and run
  only in a disposable environment.

A row per artifact in `manifests/INDEX.md` makes the whole inventory scannable.

## The three artifact policies

The skill asks which posture applies, because investigations differ:

### `private-archive`

The repo **is the durable backup**. Scarce/proprietary artifacts are *committed*
— losing them would be worse than the risk of storing them — alongside their
manifests. The repo carries explicit warnings: **keep it private; never push to
a shared or public remote**, because it holds proprietary binaries, licenses,
and possibly identifying evidence (serial numbers, photos).

Only **reproducible** blobs are git-ignored: a disk image you can re-create from
the subject, a multi-gigabyte dump. Those bloat history and can be regenerated;
the scarce inputs can't.

This is the right posture for recoveries and reverse-engineering where the
tooling is hard to find again.

### `public-writeup`

No proprietary blobs are committed. Artifacts are *referenced* (a manifest may
still record their sha256 and provenance for reproducibility), but the files
themselves live outside the repo. The repo is safe to publish. This is the right
posture for a research write-up or a teaching narrative.

### `none`

No artifact machinery at all — just docs, logbook, evidence, and sources. For
investigations that are pure analysis or where artifacts are trivially available.

## Why commit artifacts at all (the unusual choice)

Committing leaked/proprietary binaries to git is normally wrong. For a
private-archive investigation it's the deliberate, eyes-open choice: the artifacts
are the scarce inputs to a one-shot effort, and a private git repo is the most
durable, integrity-checked store available. The manifests + the `.gitignore`
boundary (scarce in, reproducible out) make it auditable. The privacy warning is
the load-bearing safety rail — the skill writes it prominently into both README
and CLAUDE.md so no one fat-fingers a push to a public remote.

## Third-party terms

The project's own LICENSE covers the *written record and scripts you authored*.
It does **not** relicense third-party artifacts the repo stores — those keep
their own terms. `docs/PRIVACY.md` records this distinction so the boundary is
explicit.
