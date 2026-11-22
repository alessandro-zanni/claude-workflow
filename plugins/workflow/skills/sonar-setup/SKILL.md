---
name: sonar-setup
description: Adds SonarQube static analysis (local server) to a JS/TS project - sonar-project.properties, sonar script, SonarLint connection in VS Code - and explains how to read results and recurring false positives. Use it when the user wants SonarQube in a repo, wants to run a scan, or asks why the quality gate is red.
---

# SonarQube in a project

Prerequisites (tell the user if missing, don't install them yourself):

- a SonarQube server on `http://localhost:9000`, e.g.
  `docker run -d --name sonarqube -p 9000:9000 sonarqube:community`;
- a user token in the shell as `SONAR_TOKEN` (never in the repo or in chat). The project is created
  on the server automatically at the first scan.

Only for projects with application code, not docs- or config-only repos.

## Files to add

`sonar-project.properties` (project key = repo name):

```properties
sonar.projectKey=<repo>
sonar.host.url=http://localhost:9000
sonar.sourceEncoding=UTF-8
sonar.sources=<source folders, e.g. app,lib,components>
sonar.test.inclusions=**/*.test.ts,**/*.test.tsx
sonar.exclusions=<generated code, generated UI primitives (components/ui/**), build, **/*.config.*, coverage/**>
sonar.javascript.lcov.reportPaths=coverage/lcov.info
# Coverage only on logic the tests actually cover; no tests: **/*
sonar.coverage.exclusions=<...>
```

- devDependency `@sonar/scan`; script `"sonar": "<tests with lcov coverage> && sonar-scanner-npm"`
  (with bun: `bun test --coverage --coverage-reporter=lcov`).
- `.scannerwork` in `.gitignore`.
- Versioned `.vscode/`: `settings.json` with
  `"sonarlint.connectedMode.project": {"connectionId": "sonarqube-local", "projectKey": "<repo>"}`,
  `extensions.json` recommending `SonarSource.sonarlint-vscode`.
- A "Static analysis" section in the repo docs.

Scan before a release and after big changes: new bugs and vulnerabilities get fixed, code smells
get evaluated.

## Reading results without the UI

The server processes the report a few seconds after the scan ends: wait before reading.

```bash
curl -s -u "$SONAR_TOKEN:" "http://localhost:9000/api/qualitygates/project_status?projectKey=<key>"
curl -s -u "$SONAR_TOKEN:" "http://localhost:9000/api/issues/search?componentKeys=<key>&inNewCodePeriod=true"
```

## Gotchas

- The "Sonar way" gate fails on **a single new issue** and on new-code coverage below 80%: a project
  without tests needs `sonar.coverage.exclusions=**/*`.
- Touching a line with an old warning makes it "new": rewrite the construct instead of disabling
  the rule.
- For false positives use `sonar.issue.ignore.multicriteria` scoped to the file, with the reason in
  a comment next to it. No `// NOSONAR`.
- Recurring false positives (React/Next): S6478 on TanStack Table `header`/`cell` functions and
  render props; S7780 `String.raw` on Next's `config.matcher`; S7784 `structuredClone` is not
  equivalent to `JSON.parse(JSON.stringify())`.
- Generated types (e.g. `database.types.ts`) → `sonar.exclusions`. Translation dictionaries →
  `sonar.cpd.exclusions`.
- `sort()` without a comparator is a bug (S2871): use `localeCompare`.
- `.astro` files are not analyzed by SonarQube Community.
