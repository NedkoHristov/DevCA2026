# Screenshots: when to take them

Slide numbers refer to the current Google Slides deck (35 slides, talk content from slide 14).

## Session A: the night before (BEFORE publishing v1.1.0, cannot be redone)

1. `package.json` on GitHub, the `"^1.0.0"` line highlighted -> slide 19
2. Nightly Build run overview: four green jobs -> slide 20
3. `floating` job log: `npm ls` shows 1.0.0 -> slide 20 (left half of the before/after pair)
4. `security-scan.yml` file view (it asks for `DEPLOY_TOKEN`) -> slide 22/26

## Session B: that night (24 h+ after v1.0.0, within 24 h of v1.1.0)

5. `floating` job log: resolves 1.1.0, red SIMULATED PAYLOAD banner -> slide 20
6. Run overview again: `floating` still has a **green check** -> slide 23/27 ("this is fine")
7. `cooldown` job log: same range, still 1.0.0 -> slide 20 (WAIT)
8. `hardened` job log: `--ignore-scripts`, no banner, Harden-Runner egress summary -> defenses
   Shoot 5, 7 and 8 at the same window size so they sit side by side.

## Session C: the reveal

9. Terminal: `git log -1` with "temp fix for release, will clean up later" -> slide 28
10. Terminal: `grep -n cron .github/workflows/deploy-nightly.yml` -> slide 28
11. Deploy Nightly run page: event `schedule`, actor shown as the bot/owner -> slide 28
12. `./scripts/census.sh <you>` output -> slide 28 or defenses

## Anytime, your own terminal

13. `./scripts/blast-radius.sh` (live gulp/semver numbers) -> slide 18
14. VS Code split: `uses: actions/checkout@v7` vs the SHA line in `hardening/actions/tag-vs-sha.yml` -> slide 21
15. `hardening/linux/Dockerfile` FROM line with the digest -> slide 21
16. `hardening/npm/.npmrc` (all four verbs in 10 lines) -> slide 20
