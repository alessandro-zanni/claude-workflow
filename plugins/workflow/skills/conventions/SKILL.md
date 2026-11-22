---
name: conventions
description: Git and repo conventions - gitflow, Conventional Commits, semver release versioning, .env.example, worktrees for parallel tasks. Use it before creating a branch, committing, merging, releasing or tagging a version, adding environment variables or opening a worktree.
---

# Conventions

The repo's AGENTS.md (or CLAUDE.md) takes precedence over these rules.

## Commits

- Small and atomic, in English, Conventional Commits format (`feat:`, `fix:`, `docs:`,
  `refactor:`, `chore:`, …). `!` after the type or `BREAKING CHANGE:` in the body for breaking
  changes.
- Commit and push only when the user asks.

## Branches: gitflow

- `feat/` and `fix/` branch off `develop` and merge back into `develop`. Merging into `develop` is
  the staging release.
- The real release is merging `develop` into `main`, after testing on staging, and the user decides
  when. The version is set with a commit on `main`, tagged `vX.Y.Z` (pushed with `main`). Then
  `main` is merged back into `develop` and the released branches are deleted, locally and remotely.
- `hotfix/` branches off `main`, returns to `main` with a bumped version, then `main` is merged back
  into `develop`.

## Release version (hotfixes too)

From the commits since the last tag (`git log $(git describe --tags --abbrev=0)..HEAD --oneline`):

- `!` or `BREAKING CHANGE` → major
- at least one `feat:` → minor
- otherwise → patch

The first version is `1.0.0`. Before releasing, state which version you propose and why, and wait
for confirmation.

## Environment variables

- When you create a `.env*` file or add a variable, create or update a committed `.env.example`:
  variable names, empty values, never secrets.
- If `.gitignore` covers `.env*`, add the exception `!.env.example`.
- Third-party API keys: one per environment (`<project>-local`, `-staging`, `-prod`) when the
  service allows it, so one can be revoked without touching the others. Never paste them in chat.

## Parallel tasks: worktrees

- Two independent tasks on the same repo (not touching the same files) → one worktree per task.
- Before opening one, check that `.worktreeinclude` covers the gitignored files needed (`.env*`,
  `.envrc`, local data); add what is missing.
- When done (branch committed) remove the worktree with `git worktree remove`. The work branch
  stays.

## Forks

A fork follows the upstream's conventions (instruction files, commit style) and stays in sync: only
`main`, no commits of your own on the fork.
