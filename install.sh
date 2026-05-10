#!/usr/bin/env bash
# install.sh — install the bootstrap-project skill into ~/.claude/skills/.
#
# Idempotent. Re-run to update an existing install.

set -euo pipefail

SRC="$(cd "$(dirname "$0")" && pwd)/skill"
DEST="${CLAUDE_SKILLS_DIR:-$HOME/.claude/skills}/bootstrap-project"

if [[ ! -d "$SRC" ]]; then
    echo "✗ Source directory not found: $SRC" >&2
    exit 1
fi

mkdir -p "$(dirname "$DEST")"

# rsync --delete so the install removes stale files from previous installs.
# Without --delete, deleted templates would linger.
if command -v rsync >/dev/null 2>&1; then
    rsync -a --delete "$SRC/" "$DEST/"
else
    # Fallback: rm -rf + cp -R. Slower but rsync isn't always present.
    rm -rf "$DEST"
    mkdir -p "$DEST"
    cp -R "$SRC/." "$DEST/"
fi

echo "✓ Installed bootstrap-project skill to $DEST"
echo
echo "Test it: open a Claude Code session and invoke /bootstrap-project"
echo "(after having a design conversation about a project to scaffold)."
