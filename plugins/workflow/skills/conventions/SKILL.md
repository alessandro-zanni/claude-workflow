---
name: conventions
description: Convenzioni di lavoro su git e repo - gitflow, Conventional Commits, versione semver di un rilascio, .env.example, worktree per task paralleli. Usala prima di creare un branch, committare, fare merge, rilasciare o taggare una versione, aggiungere variabili d'ambiente o aprire un worktree.
---

# Convenzioni

L'AGENTS.md (o CLAUDE.md) del repo ha la precedenza su queste regole.

## Commit

- Piccoli e atomici, in inglese, formato Conventional Commits (`feat:`, `fix:`, `docs:`,
  `refactor:`, `chore:`, …). `!` dopo il tipo o `BREAKING CHANGE:` nel corpo per le rotture.
- Commit e push solo quando l'utente lo chiede.

## Branch: gitflow

- `feat/` e `fix/` partono da `develop` e tornano su `develop`. Il merge su `develop` è il rilascio
  su staging.
- Il rilascio vero è il merge di `develop` su `main`, dopo i test su staging, e lo decide l'utente.
  La versione si imposta con un commit su `main`, che riceve il tag `vX.Y.Z` (pushato con `main`).
  Poi `main` si riporta su `develop` e si eliminano, locali e remoti, i branch entrati nel rilascio.
- `hotfix/` parte da `main`, torna su `main` con versione aggiornata, poi `main` si riporta su
  `develop`.

## Versione di un rilascio (anche hotfix)

Dai commit dall'ultimo tag (`git log $(git describe --tags --abbrev=0)..HEAD --oneline`):

- `!` o `BREAKING CHANGE` → major
- almeno un `feat:` → minor
- altrimenti → patch

La prima versione è `1.0.0`. Prima di rilasciare, di' quale versione proponi e perché, e aspetta la
conferma.

## Variabili d'ambiente

- Quando crei un `.env*` o aggiungi una variabile, crea o aggiorna `.env.example` committato: nomi
  delle variabili, valori vuoti, mai segreti.
- Se `.gitignore` copre `.env*`, aggiungi l'eccezione `!.env.example`.
- Chiavi API di terzi: una per ambiente (`<progetto>-local`, `-staging`, `-prod`) quando il servizio
  lo consente, così se ne revoca una senza toccare le altre. Mai incollarle in chat.

## Task paralleli: worktree

- Due task indipendenti sullo stesso repo (che non toccano gli stessi file) → un worktree per task.
- Prima di aprirlo, controlla che `.worktreeinclude` copra i file gitignorati necessari (`.env*`,
  `.envrc`, dati locali); se manca qualcosa, aggiungilo.
- A lavoro concluso (branch committato) elimina il worktree con `git worktree remove`. Il branch di
  lavoro resta.

## Fork

Un fork segue le convenzioni dell'upstream (file di istruzioni, stile dei commit) e resta allineato:
solo `main`, nessun commit proprio sul fork.
