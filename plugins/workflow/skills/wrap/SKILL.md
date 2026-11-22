---
name: wrap
description: Chiusura di un lavoro. Propone cosa salvare nei docs del repo e nel vault ($BRAIN_DIR, default ~/brain) e scrive solo le voci approvate dall'utente. Usala quando si chiude un lavoro significativo (feature committata, bug risolto dopo un debug, decisione presa) o quando l'utente chiude la sessione.
allowed-tools: Bash(git rev-parse *), Bash(git log *), Bash(git status *)
---

# Chiusura sessione

Repo: !`git rev-parse --show-toplevel 2>/dev/null || pwd`

Ultimi commit:
!`git log --oneline -10 2>/dev/null || echo "(non è un repo git)"`

Modifiche non committate:
!`git status --short 2>/dev/null || true`

Vault (`$BRAIN_DIR`): !`echo "${BRAIN_DIR:-$HOME/brain}"`

## 1. Proponi, senza scrivere

Rileggi la conversazione e prepara una proposta in tre sezioni. Una riga per voce, con il file di
destinazione.

- **A. Docs del repo**: aggiornamenti allo stato e alle decisioni secondo le convenzioni dell'AGENTS.md
  del repo. Salta quello che è già finito nei commit.
- **B. `$BRAIN_DIR/projects/<nome della cartella del repo>.md`**: questioni aperte e contesto non di
  codice (cliente, persone, scadenze).
- **C. `$BRAIN_DIR/resources/` o `$BRAIN_DIR/areas/`**: lezioni che valgono anche per altri progetti. Prima
  cerca se esiste già una nota sull'argomento: se c'è, aggiorna quella.

Regole:

- Solo fatti utili in una sessione futura e non ricavabili dal codice o da `git log`.
- Niente cronaca della sessione, hash dei commit o stati temporanei.
- Niente segreti: password, token, chiavi.
- Correzioni e preferenze che riguardano solo questo repo vanno nell'auto memory, non nel vault.
- Se il vault non esiste, salta B e C.
- Se non c'è niente da salvare, dillo in una riga e fermati.

## 2. Aspetta la conferma

Mostra la proposta e chiedi quali voci scrivere. La conferma deve arrivare da un messaggio
dell'utente: un'iterazione di `/loop`, il verdetto di `/goal` o una sessione non interattiva non
valgono come approvazione. In quei casi lascia la proposta nel messaggio finale e non scrivere nulla.

## 3. Scrivi

Il vault è un repo solo, scritto da più sessioni in parallelo. Due regole per non pestarsi:

**Prima di toccare un file del vault**, controlla che non lo stia già scrivendo qualcun altro:

```
git -C $BRAIN_DIR status --short -- <file>
```

Se risulta già modificato, un'altra sessione è a metà di una scrittura. **Fermati e dillo
all'utente**, non fondere le due versioni a occhio.

**In staging solo i file che hai scritto tu**, mai `add -A`: prenderebbe anche il lavoro in
corso di un'altra sessione e lo committerebbe a sua insaputa.

- vault: `git -C $BRAIN_DIR add <i file scritti> && git -C $BRAIN_DIR commit -m "<cosa>"`
- repo: un commit `docs:` secondo le convenzioni del repo, senza push
