# claude-workflow

A [Claude Code](https://claude.com/claude-code) plugin with an opinionated workflow: git
conventions, automatic type checking, and skills to resume and wrap up work.

## Install

```
/plugin marketplace add alessandro-zanni/claude-workflow
/plugin install workflow@claude-workflow
```

## What's inside

| | What it does |
|---|---|
| `Stop` hook | at the end of each turn runs the `typecheck` script from `package.json` and ESLint on changed `.ts/.tsx` files; on failure Claude fixes the errors before stopping (at most 3 times in a row). Does nothing in projects without a `typecheck` script. Package manager detected from the lockfile. |
| `/workflow:conventions` | gitflow, Conventional Commits, semver from commits, `.env.example`, worktrees |
| `/workflow:sonar-setup` | local SonarQube in a JS/TS project, and reading the results |
| `/workflow:brief` | where we left off in the current repo, what's open, next step |
| `/workflow:wrap` | when work is done, proposes what to save in repo docs and in your notes vault; writes only what you approve |
| `/workflow:overview` | status table of every repo in a folder |

Skills also trigger on their own when the request matches (e.g. "where were we?" → `brief`).

## Requirements and configuration

- `git` and `jq`; `gh` for issues (optional).
- `BRAIN_DIR`: a git-versioned Markdown notes vault (e.g. Obsidian) with `projects/`, `areas/`,
  `resources/`. Default `~/brain`. Without a vault, `brief` and `wrap` work on the repo only.
- `PROJECTS_DIR`: folder holding your repos, for `overview`. Default `~/projects`.
- For `sonar-setup`: a local SonarQube server and `SONAR_TOKEN` in your shell.

Set the variables in your shell profile or in `~/.claude/settings.json` under `env`.

## Your own rules: CLAUDE.md

A plugin can't ship a `CLAUDE.md`, and always-on rules (language, preferred stack, how much
autonomy Claude has) are personal anyway. [`examples/CLAUDE.md`](examples/CLAUDE.md) is a starting
point: copy it to `~/.claude/CLAUDE.md` and edit it.

## Recommended skills

Not bundled (they belong to their authors and update on their own schedule), but they pair well
with this workflow. Install them with the [`skills`](https://github.com/vercel-labs/skills) CLI:

| Skills | For | Install |
|---|---|---|
| [Impeccable](https://github.com/pbakaus/impeccable) | designing, critiquing and polishing UI | `npx skills add pbakaus/impeccable` |
| [Supabase agent skills](https://github.com/supabase/agent-skills) | Supabase (auth, RLS, migrations) and Postgres best practices | `npx skills add supabase/agent-skills` |
| [Marketing skills](https://github.com/coreyhaines31/marketingskills) | copywriting, SEO, launch, pricing, CRO… | `npx skills add coreyhaines31/marketingskills` |

The marketing pack has ~50 skills: if you only need a few, disable the rest with
`skillOverrides` in `settings.json` to keep the skill list short.

## Development

```
bash plugins/workflow/hooks/verify-ts.test.sh
claude plugin validate .
```

## License

MIT
