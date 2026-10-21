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
| Defenses | Tripwires, CODENedkoHristovS, cooldown, egress | `hardening/tripwires/`, `.github/CODENedkoHristovS`, `.github/dependabot.yml`, `hardened` job |

## The four jobs in Nightly Build

| Job | What it does | Night before | That night (after v1.1.0) |
|---|---|---|---|
| floating | deletes lockfile, `npm install` | 1.0.0 | **1.1.0 + red banner, still green** |
| pinned | `npm ci` from the committed lockfile | 1.0.0 | 1.0.0 |
| cooldown | no lockfile, skip releases < 15 min old (`--before`) | 1.0.0 | 1.0.0 (1.1.0 is too young) |
| hardened | egress allowlist + lockfile-lint + `npm ci --ignore-scripts` | 1.0.0 | 1.0.0, no scripts ran |

## Setup

Step-by-step, copy/paste: see [RUNBOOK.md](RUNBOOK.md).
Local stage demo (offline, Verdaccio): see [demo/README.md](demo/README.md).

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
