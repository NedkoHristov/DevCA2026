# RUNBOOK: from zip to all screenshots (~60 min, macOS)

Every block is copy/paste. Run them in order, in the same terminal, unless a step says otherwise.

## Step 1. Put the new files into your repo (5 min)

What it does: replaces everything in your repo with the new version, but keeps your git history
and your working `package-lock.json` (it holds the real checksum of the 1.0.0 you published).

```bash
cd ~/path/to/DevCA2026          # <-- your repo folder
REPO="$(pwd)"
git status --short              # should be empty; commit or stash anything first
cp package-lock.json /tmp/devca-lock-backup.json
rm -rf /tmp/devca-new && mkdir /tmp/devca-new
unzip -q ~/Downloads/DevCA2026-demo.zip -d /tmp/devca-new
rsync -a --delete --exclude .git --exclude package-lock.json --exclude node_modules \
  /tmp/devca-new/DevCA2026/ "$REPO/"
cd "$REPO"
ls package-lock.json && grep -c '"@nedkohristov/demo-utils"' package-lock.json   # must print a number >= 1
git add -A
git commit -m "Demo repo v2: evidence file, 15-min cooldown, stage demo"
git push
```

## Step 2. Check what is already published (1 min)

```bash
npm view @nedkohristov/demo-utils time --registry https://npm.pkg.github.com
```

- Only `1.0.0` listed: good, continue.
- `1.1.0` already listed: run this once, so the new banner gets a fresh version number:

```bash
sed -i '' 's/"version": "1.1.0"/"version": "1.1.1"/' demo-utils-v1.1.0/package.json
git commit -am "bad release is 1.1.1" && git push
```

Also confirm your publish token is still in place (prints one line):

```bash
grep npm.pkg.github.com ~/.npmrc
```

## Step 3. Dummy secret (30 s)

What it does: the "security scan" and "deploy" workflows reference `DEPLOY_TOKEN`. It is fake; logs show `***`.

```bash
gh secret set DEPLOY_TOKEN --body "not-a-real-token"
```

## Step 4. Start the scheduled "reveal" now (2 min)

What it does: adds a workflow nobody owns, with the classic commit message, running every 5 minutes.
GitHub can take 5-30 min to start scheduled runs, so we start the clock first.

```bash
git mv _staging/deploy-nightly.yml .github/workflows/deploy-nightly.yml
sed -i '' 's|"30 0 \* \* 0"|"*/5 * * * *"|' .github/workflows/deploy-nightly.yml
grep cron .github/workflows/deploy-nightly.yml        # must show */5
git commit -m "temp fix for release, will clean up later"
git push
```

## Step 5. "The night before" run (5 min)

```bash
gh workflow run nightly.yml
sleep 10
gh run watch "$(gh run list --workflow nightly.yml --limit 1 --json databaseId -q '.[0].databaseId')"
```

Expected: 4 green jobs. Open the run in the browser:

```bash
gh run view --web "$(gh run list --workflow nightly.yml --limit 1 --json databaseId -q '.[0].databaseId')"
```

Screenshots (Cmd+Shift+4, browser zoom 125%):
- **B1** run summary, 4 green
- **B2** floating job: expand the install step (`npm ls` -> 1.0.0) and "Did anything run?" -> "Nothing ran. Clean install."

## Step 6. Publish the "bad" release (1 min) - then a 15-minute clock starts

```bash
(cd demo-utils-v1.1.0 && npm publish)
npm view @nedkohristov/demo-utils time --registry https://npm.pkg.github.com
```

Expected: 1.0.0 (this morning) and the new version (just now). Go straight to step 7.

## Step 7. "That night" run - within 15 minutes of step 6 (5 min)

```bash
gh workflow run nightly.yml
sleep 10
gh run watch "$(gh run list --workflow nightly.yml --limit 1 --json databaseId -q '.[0].databaseId')"
gh run view --web "$(gh run list --workflow nightly.yml --limit 1 --json databaseId -q '.[0].databaseId')"
```

Expected: still 4 green. Screenshots, same window size for all:
- **A1** run summary: 4 green checks (Finding 2 / "This is fine")
- **A2** floating: `npm ls` -> **1.1.0**, then "Did anything run?" -> the banner
- **A3** cooldown: `npm ls` -> **1.0.0**, "Nothing ran"
- **A4** pinned: 1.0.0, "Nothing ran"
- **A5** hardened: "Nothing ran" + the Harden-Runner summary on the run page

If floating still shows 1.0.0: GitHub's package index lagged. Wait 1 minute, run step 7 again (still inside 15 min).

## Step 8. Terminal and editor screenshots (15 min)

```bash
./scripts/blast-radius.sh            # S1: "One install, 143 packages"
./scripts/canary-mock.sh             # S2: Tripwires slide - label it "illustration"
./scripts/census.sh NedkoHristov     # S3: Finding 3 / Monday slide
code .                               # opens VS Code
```

In VS Code / GitHub:
- **S4** `package.json`, highlight `"^1.0.0"` (Finding 1)
- **S5** `hardening/actions/tag-vs-sha.yml` (Mutable references)
- **S6** `hardening/linux/Dockerfile`, the FROM line (Mutable references)
- **S7** `hardening/npm/.npmrc` (Pin, lock, wait, inspect)
- **S8** `hardening/credentials/deploy-oidc.yml` (Credentials that die on their own)
- **S9** `.github/workflows/security-scan.yml` on GitHub (Bots / GhostAction)
- **B3** you already have it: the ENOVERSIONS cooldown log from this morning

## Step 9. The reveal (when the scheduled run appears)

```bash
gh run list --workflow deploy-nightly.yml
```

When a run with event `schedule` is listed:
- **R1** open it (`gh run view --web <id>`), screenshot the "Scheduled" trigger
- **R2** terminal:

```bash
clear
git log -1 --format='%an: %s' .github/workflows/deploy-nightly.yml
grep cron .github/workflows/deploy-nightly.yml
```

Only after R2, stop the 5-minute schedule:

```bash
sed -i '' 's|"\*/5 \* \* \* \*"|"30 0 * * 0"|' .github/workflows/deploy-nightly.yml
git commit -am "Back to Sunday 03:30"
git push
```

No scheduled run after 30 minutes? Use R2 only and run the block above anyway.

## Step 10. Local stage demo (15 min, can be tonight)

```bash
npm i -g npm@11 verdaccio@6
```

(EACCES error? You installed Node without nvm/brew. Use `sudo npm i -g npm@11 verdaccio@6`.)

Terminal 1 (leave it running):

```bash
cd ~/path/to/DevCA2026/demo && ./start-registry.sh
```

Terminal 2:

```bash
cd ~/path/to/DevCA2026/demo
./setup.sh
./publish-new.sh
./beat1.sh
./beat2.sh
./beat3.sh
./beat4.sh
./beat5.sh
./reset.sh
```

Press Enter for every command inside the beats. Record one full run with Cmd+Shift+5:
that video is your fallback if anything breaks on stage.

Morning of the talk: terminal 1 `./start-registry.sh`, terminal 2 `./publish-new.sh`. Do not run reset after that.

## Step 11. Clean up (2 min)

```bash
sed -i '' '/\[prod-admin\]/,/^$/d' ~/.aws/credentials 2>/dev/null; cat ~/.aws/credentials 2>/dev/null
```

Then revoke the classic PAT on GitHub (Settings -> Developer settings -> Personal access tokens).
CI uses `GITHUB_TOKEN`; nothing needs the PAT any more. Keep `DEPLOY_TOKEN` (fake) until after the talk.
