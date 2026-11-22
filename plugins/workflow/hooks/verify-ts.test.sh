#!/bin/bash
# Self-check di verify-ts.sh su un repo finto: typecheck simulato, nessun ESLint.
# Uso: bash hooks/verify-ts.test.sh
set -u
hook="$(cd "$(dirname "$0")" && pwd)/verify-ts.sh"
repo=$(mktemp -d)
export TMPDIR=$(mktemp -d)
trap 'rm -rf "$repo" "$TMPDIR"' EXIT

run() { printf '{"cwd":"%s","session_id":"t"}' "$1" | bash "$hook" 2>/dev/null; echo $?; }
check() { [ "$2" = "$3" ] && echo "ok   $1" || { echo "FAIL $1: atteso $3, ottenuto $2"; exit 1; }; }

check "senza package.json non blocca" "$(run "$repo")" 0

cd "$repo" && git init -q && echo '{"scripts":{"typecheck":"exit 0"}}' > package.json
git add -A && git -c user.email=t@t -c user.name=t commit -qm init
check "nessun file TS modificato" "$(run "$repo")" 0

echo 'export const a = 1' > a.ts
touch -t 202601010000 "$TMPDIR/verify-ts-t.mark"
check "typecheck ok" "$(run "$repo")" 0

echo '{"scripts":{"typecheck":"echo type error && exit 1"}}' > package.json
touch -t 202601010000 "$TMPDIR/verify-ts-t.mark"
check "typecheck fallito blocca" "$(run "$repo")" 2
check "file non ritoccati dopo il turno: non blocca" "$(run "$repo")" 0

for i in 2 3; do touch -t 202601010000 "$TMPDIR/verify-ts-t.mark"; run "$repo" >/dev/null; done
touch -t 202601010000 "$TMPDIR/verify-ts-t.mark"
check "dopo 3 blocchi smette di bloccare" "$(run "$repo")" 0

echo '{"scripts":{"typecheck":"exit 0"}}' > package.json
touch -t 202601010000 "$TMPDIR/verify-ts-t.mark"
check "controllo passato con tetto raggiunto" "$(run "$repo")" 0
echo '{"scripts":{"typecheck":"echo type error && exit 1"}}' > package.json
touch -t 202601010000 "$TMPDIR/verify-ts-t.mark"
check "dopo un passaggio il contatore riparte e blocca di nuovo" "$(run "$repo")" 2
echo "tutti i controlli passati"
