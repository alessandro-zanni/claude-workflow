# Global instructions

<!-- Copy to ~/.claude/CLAUDE.md and adapt. Every line here is loaded in every session:
     keep only rules you want always on. -->

## How I work

- Reply in <language>. Code, identifiers, commits and file names in English.
- Default web app stack: <e.g. Next.js App Router, TypeScript, Tailwind, Supabase>.
  Package manager: <bun | pnpm | npm>.
- The repo's AGENTS.md takes precedence over this file.
- Agent instructions in repos: a single `AGENTS.md` at the root.
- Git: follow the `workflow:conventions` skill (gitflow, Conventional Commits, semver).
- Static analysis: SonarQube in every project with application code (`workflow:sonar-setup`).
- Never paste API keys or secrets in chat; keep variable names in `.env.example`.

## Notes vault: `<path, e.g. ~/brain>`

- **Read** it when you need context that isn't in the repo: `projects/<repo-name>.md` for the
  project, `areas/` and `resources/` for cross-project knowledge.
- **Write** only via `/workflow:wrap` or when I ask explicitly.

## Where each piece of information goes

| What | Where |
|---|---|
| Project status and technical decisions | repo docs, per its AGENTS.md |
| Corrections and preferences for a single repo | auto memory |
| Non-code context (client, deadlines, open questions) | `<vault>/projects/<repo-name>.md` |
| Knowledge useful across projects | `<vault>/resources/` or `<vault>/areas/` |
| "Always do X" rules | this file or the repo's AGENTS.md |
