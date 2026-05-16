#!/usr/bin/env bash
# install.sh — install the bootstrap-project + retrofit-project skills
# into ~/.claude/skills/.
#
# Both skills share the same `templates/` directory. retrofit-skill gets a
# copy of the shared templates at install time so the two skills are
# self-contained at the install destination.
#
# Idempotent. Re-run to update an existing install.

set -euo pipefail

ROOT="$(cd "$(dirname "$0")" && pwd)"
SRC_BOOTSTRAP="$ROOT/skill"
SRC_RETROFIT="$ROOT/retrofit-skill"
SKILLS_DIR="${CLAUDE_SKILLS_DIR:-$HOME/.claude/skills}"
DEST_BOOTSTRAP="$SKILLS_DIR/bootstrap-project"
DEST_RETROFIT="$SKILLS_DIR/retrofit-project"

if [[ ! -d "$SRC_BOOTSTRAP" ]]; then
    echo "✗ bootstrap source not found: $SRC_BOOTSTRAP" >&2
    exit 1
fi
if [[ ! -d "$SRC_RETROFIT" ]]; then
    echo "✗ retrofit source not found: $SRC_RETROFIT" >&2
    exit 1
fi

mkdir -p "$SKILLS_DIR"

sync_dir() {
    local src="$1"
    local dest="$2"
    if command -v rsync >/dev/null 2>&1; then
        rsync -a --delete "$src/" "$dest/"
    else
        rm -rf "$dest"
        mkdir -p "$dest"
        cp -R "$src/." "$dest/"
    fi
}

# Install bootstrap-project.
sync_dir "$SRC_BOOTSTRAP" "$DEST_BOOTSTRAP"
echo "✓ Installed bootstrap-project skill to $DEST_BOOTSTRAP"

# Install retrofit-project. Copy the shared templates from bootstrap into
# the retrofit install directory so the skill is self-contained.
sync_dir "$SRC_RETROFIT" "$DEST_RETROFIT"
sync_dir "$SRC_BOOTSTRAP/templates" "$DEST_RETROFIT/templates"
echo "✓ Installed retrofit-project skill to $DEST_RETROFIT"
echo "  (templates/ copied from bootstrap-project; the two skills share shape)"

echo
echo "Test bootstrap-project: invoke /bootstrap-project after a design conversation."
echo "Test retrofit-project:  invoke /retrofit-project in an existing repo (needs .git/)."
