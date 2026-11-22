#!/bin/bash
# Stop hook: typecheck + ESLint sui file .ts/.tsx modificati dall'ultimo turno.
# Se falliscono, exit 2: Claude riceve l'errore e corregge prima di fermarsi.
# Esce 0 (non blocca) se il progetto non ha uno script "typecheck" o nulla è cambiato.
set -u

input=$(cat)
cwd=$(printf '%s' "$input" | jq -r '.cwd // empty')
sid=$(printf '%s' "$input" | jq -r '.session_id // "nosession"')

cd "$cwd" 2>/dev/null || exit 0
jq -e '.scripts.typecheck' package.json >/dev/null 2>&1 || exit 0

state="${TMPDIR:-/tmp}/verify-ts-$sid"
marker="$state.mark"

# File TS modificati, staged o nuovi (esclusi i cancellati), toccati dopo il turno precedente
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

# Al massimo 3 blocchi consecutivi: poi lascia fermare Claude (niente loop infinito di fix),
# ma i controlli girano comunque, così il contatore si azzera appena passano.
blocks=$(cat "$state.count" 2>/dev/null || echo 0)
[ "$blocks" -ge 3 ] && exit 0
echo $((blocks + 1)) > "$state.count"
{
  echo "Typecheck o ESLint falliti sui file modificati: correggi prima di chiudere il turno."
  printf '%s\n' "$out" | tail -40
} >&2
exit 2
