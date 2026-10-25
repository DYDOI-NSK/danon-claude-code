#!/bin/sh

file="$1"
branch="${BRANCH:-$(git symbolic-ref --short -q HEAD)}"

case "$branch" in
  feature/?*) prefix="feat(${branch#feature/}): " ;;
  develop)    prefix="develop: " ;;
  main)       prefix="chore: " ;;
  *)          exit 0 ;;
esac

first=$(head -n 1 "$file")

case "$first" in
  ""|"#"*|Merge\ *|Revert\ *|fixup!\ *|squash!\ *|amend!\ *) exit 0 ;;
  "$prefix"*) exit 0 ;;
esac

tmp=$(mktemp)
{ printf '%s%s\n' "$prefix" "$first"; tail -n +2 "$file"; } > "$tmp"
cat "$tmp" > "$file"
rm -f "$tmp"
