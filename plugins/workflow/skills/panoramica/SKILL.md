---
name: panoramica
description: Vista d'insieme di tutti i progetti nella cartella $PROJECTS_DIR (default ~/projects) - branch, ultimo commit, modifiche non committate, issue aperte, cosa è in corso. Usala quando l'utente chiede come stanno i progetti, da dove ripartire o cosa è rimasto in sospeso.
allowed-tools: Bash(git *), Bash(gh issue list *)
---

# Panoramica dei progetti

!`sh "${CLAUDE_SKILL_DIR}/status.sh"`

## Cosa fare

Solo lettura: non modificare nessun file.

Per i progetti che risultano attivi (file modificati, commit dell'ultima settimana o issue aperte),
apri il file di stato del repo (indicato nel suo AGENTS.md, es. `docs/status.md`) e prendi solo
cosa è in corso. Ignora gli altri: per quelli basta la riga del digest.

## Risposta

Una tabella: progetto, stato in una riga, prossimo passo. Al massimo due righe per progetto, e in
fondo una riga su quale progetto conviene riprendere per primo e perché. I repo marcati `(fork)`
(hanno un remote `upstream`) vanno in fondo alla tabella, separati dagli altri.
