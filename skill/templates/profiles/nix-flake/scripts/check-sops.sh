#!/usr/bin/env bash
# check-sops.sh — gate: every YAML/JSON file under secrets/ must be
# sops-encrypted before it can land in git.
#
# A sops-encrypted YAML contains a top-level `sops:` key with metadata;
# a sops-encrypted JSON has the same under "sops". This script greps for
# that marker. Not bullet-proof, but catches the common foot-gun of
# committing a plaintext secrets file.

set -euo pipefail

cd "$(dirname "$0")/.."

if [ ! -d secrets ]; then
    exit 0
fi

failed=0
while IFS= read -r f; do
    case "$f" in
        secrets/README.md) continue ;;
        secrets/*.yaml|secrets/*.yml|secrets/*.json) ;;
        *) continue ;;
    esac

    if ! grep -q '"\?sops"\?:' "$f"; then
        echo "✗ $f is not sops-encrypted (no 'sops:' marker found)"
        failed=$((failed + 1))
    fi
done < <(find secrets -type f)

if [ "$failed" -gt 0 ]; then
    echo
    echo "Refusing to proceed: $failed unencrypted secrets file(s) above."
    echo "Encrypt with: sops --encrypt --in-place <file>"
    exit 1
fi

echo "✓ all secrets/ files are sops-encrypted"
