---
name: sonar-setup
description: Aggiunge l'analisi statica SonarQube (server locale) a un progetto JS/TS - sonar-project.properties, script sonar, collegamento a SonarLint in VS Code - e spiega come leggere i risultati e i falsi positivi ricorrenti. Usala quando l'utente vuole SonarQube in un repo, lanciare una scan o capire perché il quality gate è rosso.
---

# SonarQube nel progetto

Prerequisiti (dillo all'utente se mancano, non installarli da solo):

- un server SonarQube su `http://localhost:9000`, es.
  `docker run -d --name sonarqube -p 9000:9000 sonarqube:community`;
- un token utente nella shell come `SONAR_TOKEN` (mai nel repo né in chat). Il progetto sul server
  si crea da solo alla prima scan.

Solo per progetti con codice applicativo, non per repo di soli docs o config.

## File da aggiungere

`sonar-project.properties` (project key = nome del repo):

```properties
sonar.projectKey=<repo>
sonar.host.url=http://localhost:9000
sonar.sourceEncoding=UTF-8
sonar.sources=<cartelle sorgente, es. app,lib,components>
sonar.test.inclusions=**/*.test.ts,**/*.test.tsx
sonar.exclusions=<codice generato, primitive UI generate (components/ui/**), build, **/*.config.*, coverage/**>
sonar.javascript.lcov.reportPaths=coverage/lcov.info
# Copertura solo sulla logica coperta davvero dai test; senza test: **/*
sonar.coverage.exclusions=<...>
```

- devDependency `@sonar/scan`; script `"sonar": "<test con coverage lcov> && sonar-scanner-npm"`
  (con bun: `bun test --coverage --coverage-reporter=lcov`).
- `.scannerwork` in `.gitignore`.
- `.vscode/` versionata: `settings.json` con
  `"sonarlint.connectedMode.project": {"connectionId": "sonarqube-local", "projectKey": "<repo>"}`,
  `extensions.json` che raccomanda `SonarSource.sonarlint-vscode`.
- Una sezione "Static analysis" nei docs del repo.

Scan prima di un rilascio e dopo cambi grossi: bug e vulnerabilità nuovi si correggono, i code
smell si valutano.

## Leggere i risultati senza la UI

Il server elabora il report qualche secondo dopo la scan: aspetta prima di leggere.

```bash
curl -s -u "$SONAR_TOKEN:" "http://localhost:9000/api/qualitygates/project_status?projectKey=<key>"
curl -s -u "$SONAR_TOKEN:" "http://localhost:9000/api/issues/search?componentKeys=<key>&inNewCodePeriod=true"
```

## Tranelli

- Il gate "Sonar way" fallisce con **un solo problema nuovo** e con copertura del codice nuovo
  sotto l'80%: in un progetto senza test serve `sonar.coverage.exclusions=**/*`.
- Toccare una riga con un vecchio avviso lo rende "nuovo": riscrivi il costrutto invece di spegnere
  la regola.
- Per i falsi positivi usa `sonar.issue.ignore.multicriteria` limitato al file, con il motivo in un
  commento accanto. Niente `// NOSONAR`.
- Falsi positivi ricorrenti (React/Next): S6478 su `header`/`cell` di TanStack Table e render prop;
  S7780 `String.raw` sul `config.matcher` di Next; S7784 `structuredClone` al posto di
  `JSON.parse(JSON.stringify())` non è equivalente.
- Tipi generati (es. `database.types.ts`) → `sonar.exclusions`. Dizionari di traduzione →
  `sonar.cpd.exclusions`.
- `sort()` senza comparatore è un bug (S2871): usa `localeCompare`.
- I file `.astro` non vengono analizzati da SonarQube Community.
