---
name: wrap
description: Wraps up a piece of work. Proposes what to save in the repo docs and in the notes vault ($BRAIN_DIR, default ~/brain) and writes only the entries the user approves. Use it when significant work is done (feature committed, bug fixed after debugging, decision made) or when the user ends the session.
allowed-tools: Bash(git rev-parse *), Bash(git log *), Bash(git status *)
---

# Wrap-up

Repo: !`git rev-parse --show-toplevel 2>/dev/null || pwd`

Recent commits:
!`git log --oneline -10 2>/dev/null || echo "(not a git repo)"`

Uncommitted changes:
!`git status --short 2>/dev/null || true`

Vault (`$BRAIN_DIR`): !`echo "${BRAIN_DIR:-$HOME/brain}"`

## 1. Propose, don't write

Re-read the conversation and prepare a proposal in three sections. One line per entry, with the
target file.

- **A. Repo docs**: status and decision updates, following the conventions in the repo's
  AGENTS.md (or CLAUDE.md). Skip what is already captured in commits.
- **B. `$BRAIN_DIR/projects/<repo folder name>.md`**: open questions and non-code context (client,
  people, deadlines).
- **C. `$BRAIN_DIR/resources/` or `$BRAIN_DIR/areas/`**: lessons that apply to other projects too.
  First search for an existing note on the topic: if there is one, update it.

Rules:

- Only facts useful in a future session and not derivable from the code or `git log`.
- No session narrative, commit hashes or temporary states.
- No secrets: passwords, tokens, keys.
- Corrections and preferences that only concern this repo go in auto memory, not the vault.
- If the vault doesn't exist, skip B and C.
- If there is nothing to save, say so in one line and stop.

## 2. Wait for confirmation

Show the proposal and ask which entries to write. Confirmation must come from a user message: a
`/loop` iteration, a `/goal` verdict or a non-interactive session do not count as approval. In
those cases leave the proposal in the final message and write nothing.

## 3. Write

The vault is a single repo, written by several sessions in parallel. Two rules to avoid collisions:

**Before touching a vault file**, check nobody else is writing it:

```
git -C $BRAIN_DIR status --short -- <file>
```

If it is already modified, another session is mid-write. **Stop and tell the user**; don't merge
the two versions by eye.

**Stage only the files you wrote**, never `add -A`: it would pick up another session's work in
progress and commit it behind its back.

- vault: `git -C $BRAIN_DIR add <files written> && git -C $BRAIN_DIR commit -m "<what>"`
- repo: a `docs:` commit following the repo's conventions, no push
