#!/bin/sh
# Digest of repos in $PROJECTS_DIR (default ~/projects): branch, last commit, changes, open issues.
# GitHub queries run in parallel since each costs about half a second.
base="${PROJECTS_DIR:-$HOME/projects}"
tmp=$(mktemp -d) || exit 0
for d in "$base"/*/; do
  [ -d "$d.git" ] || continue
  name=$(basename "$d")
  (
    branch=$(git -C "$d" branch --show-current 2>/dev/null)
    last=$(git -C "$d" log -1 --format='%cr' 2>/dev/null)
    dirty=$(git -C "$d" status --porcelain 2>/dev/null | wc -l | tr -d ' ')
    slug=$(git -C "$d" remote get-url origin 2>/dev/null | sed -E 's#\.git$##; s#.*[:/]([^/:]+/[^/]+)$#\1#')
    git -C "$d" remote get-url upstream >/dev/null 2>&1 && name="$name (fork)"
    issues="-"
    [ -n "$slug" ] && issues=$(gh issue list -R "$slug" --state open --limit 100 --json number --jq length 2>/dev/null || echo "-")
    printf '%s | %s | last commit %s | %s modified files | %s open issues\n' \
      "$name" "${branch:--}" "${last:--}" "$dirty" "$issues"
  ) > "$tmp/$(basename "$d")" &
done
wait
cat "$tmp"/* 2>/dev/null | sort
rm -rf "$tmp"
