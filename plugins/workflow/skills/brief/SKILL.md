---
name: brief
description: Briefing sul repo corrente (dove eravamo, cosa è aperto, prossimo passo), in sola lettura. Usala quando l'utente vuole riprendere il lavoro ("riprendiamo", "dove eravamo", "a che punto siamo").
allowed-tools: Bash(git rev-parse *), Bash(git log *), Bash(git status *), Bash(gh issue list *)
---

# Brief di inizio sessione

Repo: !`git rev-parse --show-toplevel 2>/dev/null || pwd`

Vault (`$BRAIN_DIR`): !`echo "${BRAIN_DIR:-$HOME/brain}"`

Ultimi commit:
!`git log --oneline -10 2>/dev/null || echo "(non è un repo git)"`

Modifiche non committate:
!`git status --short 2>/dev/null || true`

Issue aperte:
!`gh issue list --state open --limit 10 2>/dev/null || true`

## Cosa fare

Solo lettura: non modificare nessun file.

1. Dall'AGENTS.md (o CLAUDE.md) del repo ricava qual è il file di stato (es. `docs/status.md`) e
   leggi solo le sezioni "in corso" e "non iniziato".
2. Se il repo ha un registro delle decisioni (es. `docs/decisions.md`), cerca le voci aperte o in
   discussione.
3. Leggi `$BRAIN_DIR/projects/<nome della cartella del repo>.md`, se esiste.

Salta in silenzio i file che non esistono (anche il vault intero, se non c'è).

## Risposta

Al massimo 10 righe (13 con il blocco Parallelizzabili), divise in blocchi:

- **Dove eravamo**: l'ultimo lavoro fatto, ricavato dai commit e dalle modifiche non committate
- **Aperto**: questioni aperte e decisioni in sospeso
- **Prossimo passo**: una sola proposta
- **Parallelizzabili** (solo se ci sono almeno 2 task aperte e concrete): per ogni task una riga con
  le aree o i file che probabilmente tocca, stimati da stato, issue e commit senza esplorare il
  codice, e con quali altre task è sicura in parallelo (in worktree separati). Segnala come non
  parallelizzabili migrazioni del database, config condivise e task che toccano le stesse aree.
  Massimo 3 task. Se non ce ne sono due indipendenti, salta il blocco.
