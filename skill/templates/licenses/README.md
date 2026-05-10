# Licenses

This directory does **not** ship the canonical text of any license. The skill instead instructs the user to fetch the chosen license at scaffolding time.

Reasons:

1. **Length and bulk**. Pasting AGPL-3.0 (~33 KB) and GPL-3.0 (~35 KB) into the skill repo bloats it without earning anything — the texts are public, immutable, and trivially fetchable.
2. **Authoritative source**. SPDX maintains the canonical text at `https://spdx.org/licenses/<SPDX-ID>.txt`. Fetching from there guarantees the text is current and matches the SPDX identifier in metadata files.
3. **Avoids redistribution issues**. We don't have to think about whether copy-pasting a given license text into the skill repo is itself permitted by that license.

## How the skill writes `LICENSE`

When the user picks a license, the skill writes a `LICENSE` file containing:

```
SPDX-License-Identifier: <ID>

This project is licensed under the <Name>.

Canonical text: https://spdx.org/licenses/<ID>.txt

Run this once after scaffolding:

    curl -sLo LICENSE.tmp https://spdx.org/licenses/<ID>.txt && \
    mv LICENSE.tmp LICENSE
```

Then the skill prints a one-liner reminder in `BOOTSTRAP-MANIFEST.md` "Next 30 minutes":

> **Fetch the license text**: `curl -sLo LICENSE https://spdx.org/licenses/<ID>.txt`

After running that, `LICENSE` contains the canonical SPDX-published text.

## Supported license shortcuts

The skill exposes these in the explicit "license" question. Each maps to its SPDX identifier:

| Skill option | SPDX ID | Notes |
|---|---|---|
| MIT | `MIT` | Permissive |
| Apache-2.0 | `Apache-2.0` | Permissive with patent clause |
| AGPL-3.0-only | `AGPL-3.0-only` | Network copyleft (recommended for self-hosted services) |
| GPL-3.0-only | `GPL-3.0-only` | Copyleft, not network-aware |
| BSL-1.0 | `BSL-1.0` | Boost Software License — short, permissive |
| MPL-2.0 | `MPL-2.0` | File-level copyleft |
| Unlicense | `Unlicense` | Public-domain dedication |
| proprietary | _(none)_ | Skill writes a "All rights reserved" note instead of fetching anything |

If the user picks "Other", the skill asks for an SPDX ID and uses it.

## What the skill writes for `proprietary`

```
All rights reserved.

This software is the private property of {{user_or_org}} and is not
licensed for redistribution, modification, or use beyond the scope
explicitly authorized by the copyright holder.
```

No SPDX line — proprietary is the absence of a public license.
