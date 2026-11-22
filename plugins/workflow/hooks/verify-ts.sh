#!/bin/bash
# Stop hook: typecheck + ESLint on .ts/.tsx files changed since the last turn.
# On failure, exit 2: Claude gets the error and fixes it before stopping.
# Exits 0 (no block) if the project has no "typecheck" script or nothing changed.
set -u

input=$(cat)
cwd=$(printf '%s' "$input" | jq -r '.cwd // empty')
sid=$(printf '%s' "$input" | jq -r '.session_id // "nosession"')

cd "$cwd" 2>/dev/null || exit 0
jq -e '.scripts.typecheck' package.json >/dev/null 2>&1 || exit 0

state="${TMPDIR:-/tmp}/verify-ts-$sid"
marker="$state.mark"

# Modified, staged or new TS files (deleted excluded) touched after the previous turn
changed=()
while IFS= read -r f; do
  [ -f "$f" ] || continue
  if [ ! -f "$marker" ] || [ "$f" -nt "$marker" ]; then changed+=("$f"); fi
done < <({ git diff --name-only --diff-filter=d HEAD; git ls-files --others --exclude-standard; } 2>/dev/null | grep -E '\.(ts|tsx)$' | sort -u)
touch "$marker"
[ ${#changed[@]} -gt 0 ] || exit 0

pm=npm
[ -f bun.lock ] || [ -f bun.lockb ] && pm=bun
[ -f pnpm-lock.yaml ] && pm=pnpm
[ -f yarn.lock ] && pm=yarn

out=$("$pm" run typecheck 2>&1) && {
  [ -x node_modules/.bin/eslint ] || { rm -f "$state.count"; exit 0; }
  out=$(node_modules/.bin/eslint --no-warn-ignored "${changed[@]}" 2>&1)
} && { rm -f "$state.count"; exit 0; }

# At most 3 consecutive blocks: then let Claude stop (no endless fix loop),
# but checks still run, so the counter resets as soon as they pass.
blocks=$(cat "$state.count" 2>/dev/null || echo 0)
[ "$blocks" -ge 3 ] && exit 0
echo $((blocks + 1)) > "$state.count"
{
  echo "Typecheck or ESLint failed on changed files: fix before ending the turn."
  printf '%s\n' "$out" | tail -40
} >&2
exit 2
