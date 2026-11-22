---
name: overview
description: Overview of all projects in $PROJECTS_DIR (default ~/projects) - branch, last commit, uncommitted changes, open issues, what is in progress. Use it when the user asks how their projects are doing, where to pick up, or what was left hanging.
allowed-tools: Bash(sh *context.sh*), Bash(git *), Bash(gh issue list *)
---

# Projects overview

!`sh "${CLAUDE_SKILL_DIR}/status.sh"`

Local extensions (`~/.claude/workflow/overview.md`, optional):
!`sh "${CLAUDE_SKILL_DIR}/../../scripts/context.sh" ext overview`

If local extensions are present, follow them as extra steps of this skill: they add to these
instructions and win where they conflict.

## What to do

Read-only: don't modify any file.

For projects that look active (modified files, commits in the last week or open issues), open the
repo's status file (named in its AGENTS.md, e.g. `docs/status.md`) and take only what is in
progress. Ignore the others: the digest line is enough for them.

## Answer

Reply in the user's language. A table: project, one-line status, next step. At most two lines per project, and at the end one
line on which project to resume first and why. Repos marked `(fork)` (they have an `upstream`
remote) go at the bottom, separated from the others.
