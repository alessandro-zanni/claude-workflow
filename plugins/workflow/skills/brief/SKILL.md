---
name: brief
description: Read-only briefing on the current repo (where we left off, what is open, next step). Use it when the user wants to resume work ("let's pick up", "where were we", "what's the status").
allowed-tools: Bash(sh *context.sh*), Bash(git rev-parse *), Bash(git log *), Bash(git status *), Bash(gh issue list *)
---

# Session brief

Repo: !`git rev-parse --show-toplevel 2>/dev/null || pwd`

Vault (`$BRAIN_DIR`): !`sh "${CLAUDE_SKILL_DIR}/../../scripts/context.sh" vault`

Recent commits:
!`git log --oneline -10 2>/dev/null || echo "(not a git repo)"`

Uncommitted changes:
!`git status --short 2>/dev/null || true`

Open issues:
!`gh issue list --state open --limit 10 2>/dev/null || true`

Local extensions (`~/.claude/workflow/brief.md`, optional):
!`sh "${CLAUDE_SKILL_DIR}/../../scripts/context.sh" ext brief`

If local extensions are present, follow them as extra steps of this skill: they add to these
instructions and win where they conflict.

## What to do

Read-only: don't modify any file.

1. From the repo's AGENTS.md (or CLAUDE.md) find the status file (e.g. `docs/status.md`) and read
   only the "in progress" and "not started" sections.
2. If the repo has a decision log (e.g. `docs/decisions.md`), look for open or under-discussion
   entries.
3. Read `$BRAIN_DIR/projects/<repo folder name>.md`, if it exists.

Silently skip files that don't exist (including the whole vault, if missing).

## Answer

Reply in the user's language. At most 10 lines (13 with the Parallelizable block), in blocks:

- **Where we left off**: the last work done, from commits and uncommitted changes
- **Open**: open questions and pending decisions
- **Next step**: a single proposal
- **Parallelizable** (only with at least 2 open, concrete tasks): one line per task with the areas
  or files it will likely touch, estimated from status, issues and commits without exploring the
  code, and which other tasks it can safely run alongside (in separate worktrees). Flag database
  migrations, shared config and tasks touching the same areas as not parallelizable. At most 3
  tasks. If there aren't two independent ones, skip the block.
