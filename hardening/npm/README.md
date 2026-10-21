# npm: pin, lock, wait, inspect

| Verb | What | Command / config |
|---|---|---|
| PIN | No ranges enter package.json | `save-exact=true` in `.npmrc`; existing ranges: `npx npm-check-updates --target semver -u` then remove `^`/`~` |
| LOCK | CI installs only the lockfile | `npm ci` (fails if package.json and lockfile disagree) |
| WAIT | Fresh releases are invisible | `min-release-age=3` in `.npmrc` + Dependabot `cooldown` |
| INSPECT | Know what changed before it runs | `npm diff --diff=pkg@old --diff=pkg@new`, `npx lockfile-lint ...`, `ignore-scripts=true`, Socket CLI |

Copy `.npmrc` from this folder to the repo root to harden the whole demo.
