# claude-workflow

Plugin per [Claude Code](https://claude.com/claude-code) con il mio modo di lavorare: convenzioni
git, controllo dei tipi automatico e skill per riprendere e chiudere il lavoro.

## Installazione

```
/plugin marketplace add alessandro-zanni/claude-workflow
/plugin install workflow@claude-workflow
```

## Cosa contiene

| | Cosa fa |
|---|---|
| hook `Stop` | a fine turno lancia `typecheck` (script del `package.json`) ed ESLint sui file `.ts/.tsx` modificati; se falliscono, Claude corregge prima di fermarsi (massimo 3 volte di fila). Non fa nulla nei progetti senza script `typecheck`. |
| `/conventions` | gitflow, Conventional Commits, versione semver dai commit, `.env.example`, worktree |
| `/sonar-setup` | SonarQube locale in un progetto JS/TS e lettura dei risultati |
| `/brief` | dove eravamo nel repo corrente, cosa è aperto, prossimo passo |
| `/wrap` | a fine lavoro propone cosa salvare nei docs del repo e nel vault, scrive solo ciò che approvi |
| `/panoramica` | tabella di stato di tutti i repo in una cartella |

## Prerequisiti e configurazione

- `jq` e `git`; `gh` per le issue (facoltativo).
- `BRAIN_DIR`: vault Markdown (es. Obsidian) versionato con git, con `projects/`, `areas/`,
  `resources/`. Default `~/brain`. Senza vault `/brief` e `/wrap` lavorano solo sul repo.
- `PROJECTS_DIR`: cartella dei repo per `/panoramica`. Default `~/projects`.
- Per `/sonar-setup`: un server SonarQube locale e `SONAR_TOKEN` nella shell.

Le variabili si impostano nel profilo della shell o in `~/.claude/settings.json` sotto `env`.

## Regole personali

Un plugin non può distribuire un `CLAUDE.md`. Le regole sempre attive (lingua, stack preferito,
ecc.) vanno nel tuo `~/.claude/CLAUDE.md`; le convenzioni condivise stanno nella skill
`conventions`.

## Sviluppo

```
bash plugins/workflow/hooks/verify-ts.test.sh
claude plugin validate .
```
