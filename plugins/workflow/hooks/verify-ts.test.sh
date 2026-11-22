#!/bin/bash
# Self-check for verify-ts.sh on a fake repo: simulated typecheck, no ESLint.
# Usage: bash hooks/verify-ts.test.sh
set -u
hook="$(cd "$(dirname "$0")" && pwd)/verify-ts.sh"
repo=$(mktemp -d)
export TMPDIR=$(mktemp -d)
trap 'rm -rf "$repo" "$TMPDIR"' EXIT

run() { printf '{"cwd":"%s","session_id":"t"}' "$1" | bash "$hook" 2>/dev/null; echo $?; }
check() { [ "$2" = "$3" ] && echo "ok   $1" || { echo "FAIL $1: expected $3, got $2"; exit 1; }; }

check "no package.json: no block" "$(run "$repo")" 0

cd "$repo" && git init -q && echo '{"scripts":{"typecheck":"exit 0"}}' > package.json
git add -A && git -c user.email=t@t -c user.name=t commit -qm init
check "no TS file changed" "$(run "$repo")" 0

echo 'export const a = 1' > a.ts
touch -t 202601010000 "$TMPDIR/verify-ts-t.mark"
check "typecheck ok" "$(run "$repo")" 0

echo '{"scripts":{"typecheck":"echo type error && exit 1"}}' > package.json
touch -t 202601010000 "$TMPDIR/verify-ts-t.mark"
check "failed typecheck blocks" "$(run "$repo")" 2
check "files untouched since last turn: no block" "$(run "$repo")" 0

for i in 2 3; do touch -t 202601010000 "$TMPDIR/verify-ts-t.mark"; run "$repo" >/dev/null; done
touch -t 202601010000 "$TMPDIR/verify-ts-t.mark"
check "stops blocking after 3 blocks" "$(run "$repo")" 0

echo '{"scripts":{"typecheck":"exit 0"}}' > package.json
touch -t 202601010000 "$TMPDIR/verify-ts-t.mark"
check "check passes with cap reached" "$(run "$repo")" 0
echo '{"scripts":{"typecheck":"echo type error && exit 1"}}' > package.json
touch -t 202601010000 "$TMPDIR/verify-ts-t.mark"
check "after a pass the counter resets and blocks again" "$(run "$repo")" 2
echo "all checks passed"
