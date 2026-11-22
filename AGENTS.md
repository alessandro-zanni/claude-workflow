# AGENTS.md

Claude Code plugin marketplace with a single plugin, `workflow` (`plugins/workflow/`). Public
repo, installed by other people: see README.md for what it ships.

## Rules

- **Everything in English** (skills, hooks, docs, commits). Skills tell Claude to reply in the
  user's language; never hardcode one.
- **Nothing personal in the plugin**: no names, emails, accounts, absolute paths, or tools only
  one person uses. Machine-specific steps go in the user's local extension files
  (`~/.claude/workflow/<skill>.md`), which `brief`, `wrap` and `overview` load.
- Paths that differ per user are env vars with a default (`BRAIN_DIR` → `~/brain`,
  `PROJECTS_DIR` → `~/projects`), documented in README.md.
- Third-party skills are recommended in README.md, never copied in.

## Checks before a release

```
bash plugins/workflow/hooks/verify-ts.test.sh
claude plugin validate .
```

## Releases

Gitflow: `feat/`/`fix/` from `develop`, back to `develop`. Release = merge `develop` into `main`,
set `version` in `plugins/workflow/.claude-plugin/plugin.json` in the release commit, tag
`vX.Y.Z`, push `main` with the tag, bring `main` back into `develop`. Users install from `main`, so
nothing on `develop` reaches them until a release.

After a release, update the local install:

```
claude plugin marketplace update claude-workflow && claude plugin update workflow@claude-workflow
```
