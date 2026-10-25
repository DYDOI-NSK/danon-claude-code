#!/usr/bin/env bash
# Plugins can't ship rules, so link rules/ into the user-level rules dir.
set -euo pipefail
src="$(cd "$(dirname "$0")" && pwd)/plugins/danon/rules"
dest="${CLAUDE_CONFIG_DIR:-$HOME/.claude}/rules/danon"
mkdir -p "$(dirname "$dest")"
if [ -e "$dest" ] && [ ! -L "$dest" ]; then
  echo "$dest exists and is not a symlink, refusing to overwrite" >&2
  exit 1
fi
ln -sfn "$src" "$dest"
echo "Linked $dest -> $src"
