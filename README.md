# DevCA2026: Keep Yourself Positive in the World of Security

Demo repo for the talk **"Keep Yourself Positive in the World of Security: A DevOps Perspective"**
by Nedko Hristov, DEV: Challenge Accepted 2026, 23.10.2026, Sofia Tech Park.

> Everything "malicious" here is a simulation. The v1.1.0 postinstall only prints a banner,
> `security-scan.yml` is inert, and nothing reads or sends credentials. Safe to make public.

## The story in one paragraph

Sunday, 03:30. Nobody pushed anything, yet production is compromised. No commits, no logins,
no leaked keys. The cause: a caret range (`^1.0.0`) let the pipeline pick up a fresh release
of a dependency, a long-lived token outlived the person who created it, and the thing that
acted at 03:30 was not a person at all.

## Slide map

| Deck slide | What | Where in this repo |
|---|---|---|
| 18 Incident log | Blast radius: one install, hundreds of packages you trust | `scripts/blast-radius.sh` |
| 19 Finding 1 | Version operators: what `^ ~ > =` actually allow | `hardening/linux/python-pinning.md` (npm vs pip table) |
| 20 Remediation in Node.js | **Pin, lock, wait, inspect** | `.github/workflows/nightly.yml`, `hardening/npm/`, `hardening/pnpm/`, `scripts/npm-diff.sh` |
| 21 Mutable references | apt, pip hashes, Docker digests, Actions SHAs | `hardening/linux/`, `hardening/actions/`, `scripts/pin-actions.sh` |
| 22/26 Incident log 2 | Workflows dressed as security (GhostAction) | `.github/workflows/security-scan.yml` |
| 23/27 Finding 2 | The credential outlived its owner -> OIDC | `hardening/credentials/` |
| 28 Finding 3 | The actor cannot be a person | `_staging/deploy-nightly.yml`, `scripts/census.sh` |
| Defenses | Tripwires, CODEOWNERS, cooldown, egress | `hardening/tripwires/`, `.github/CODEOWNERS`, `.github/dependabot.yml`, `hardened` job |

## The four jobs in Nightly Build

| Job | What it does | Night before | That night (after v1.1.0) |
|---|---|---|---|
| floating | deletes lockfile, `npm install` | 1.0.0 | **1.1.0 + red banner, still green** |
| pinned | `npm ci` from the committed lockfile | 1.0.0 | 1.0.0 |
| cooldown | no lockfile, `npm install --min-release-age=1` | 1.0.0 | 1.0.0 (1.1.0 is too young) |
| hardened | egress allowlist + lockfile-lint + `npm ci --ignore-scripts --min-release-age=1` | 1.0.0 | 1.0.0, no scripts ran |

## Setup (about 30 minutes)

Timing matters: **publish v1.0.0 at least 24 hours before** the "that night" run,
otherwise the cooldown job has nothing old enough to install.

1. Create an empty repo `DevCA2026` on GitHub, push this folder, then:
   ```bash
   ./scripts/bootstrap.sh <your-github-username>
   git commit -am "bootstrap owner" && git push
   ```
2. Create a classic PAT with `write:packages` (publishing only, expire it after the talk) and add to `~/.npmrc`:
   ```
   //npm.pkg.github.com/:_authToken=ghp_xxx
   ```
3. Publish the clean release and commit the lockfile:
   ```bash
   (cd demo-utils && npm publish)
   npm install            # creates package-lock.json pinned to 1.0.0
   git add package-lock.json && git commit -m "lockfile is a contract" && git push
   ```
   The `repository` field links the package to this repo, so `GITHUB_TOKEN` can read it in Actions.
   If a job gets 403, open the package settings -> Manage Actions access -> add this repo.
4. Run **Nightly Build** manually -> take Session A screenshots (see `SCREENSHOTS.md`).
5. At least 24 h later: `(cd demo-utils-v1.1.0 && npm publish)` -> run **Nightly Build** again
   within the next 24 h -> Session B screenshots.
6. The reveal:
   ```bash
   git mv _staging/deploy-nightly.yml .github/workflows/
   git commit -m "temp fix for release, will clean up later" && git push
   ```
   For the `github-actions[bot]`/`schedule` screenshot without waiting for Sunday, temporarily set
   the cron to `"*/15 * * * *"`, wait for one run, screenshot, set it back.
7. Run `./scripts/census.sh <your-username>` for the "who runs things at 03:30" table.
8. After the talk: delete the PAT and the `DEPLOY_TOKEN` secret if you created one.

## Known risks before the live run

- **min-release-age needs the registry to publish release times.** npm reads the `time` field.
  Check GitHub Packages returns it: `npm view @<you>/demo-utils time --registry https://npm.pkg.github.com`.
  If it is empty, the cooldown job fails with ETARGET. Fallback: show the cooldown with a public
  package locally (`npm install semver --min-release-age=3` then `npm ls semver`) and keep the
  CI screenshot for floating vs pinned.
- **Harden-Runner in block mode** stops anything not allowlisted. If the hardened job fails on a
  host, switch to `egress-policy: audit`, run once, read the detected endpoints, add them.
- Cron is UTC. `30 0 * * 0` is 03:30 in Sofia only while on summer time (until 25.10.2026).

## Useful one-liners for the slides

```bash
npm config set save-exact true                          # PIN
npm ci                                                  # LOCK
npm config set min-release-age 3                        # WAIT (days)
npm diff --diff=pkg@1.0.0 --diff=pkg@1.1.0              # INSPECT
docker buildx imagetools inspect node:24-slim           # digest for FROM ...@sha256:
gh api repos/actions/checkout/commits/v7 --jq .sha      # tag -> SHA
```
