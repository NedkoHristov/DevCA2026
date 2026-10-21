# Stage demo: same command, different night

Local npm registry (Verdaccio) on your laptop. Works with Wi-Fi off.

## One-time install
    npm i -g npm@11 verdaccio@6

## Once (today)
    ./start-registry.sh        # terminal 1, leave running
    ./setup.sh                 # terminal 2: demo user + clean 1.0.0

## Rehearse
    ./publish-new.sh           # publish the "bad" 1.1.0
    ./beat1.sh ... ./beat5.sh  # press Enter for every command
    ./reset.sh                 # removes 1.1.0 only (1.0.0 keeps aging)

## Morning of the talk
    ./start-registry.sh
    ./publish-new.sh           # 1.1.0 minutes old, 1.0.0 two days old -> beat 4 uses the real min-release-age

| Beat | Shows | Result |
|---|---|---|
| 1 | Friday | 1.0.0, no file |
| 2 | Sunday 03:12, same command | "added 1 package" ... `ls` -> demo-utils-was-here.txt |
| 3 | LOCK: npm ci | 1.0.0, no file |
| 4 | WAIT: cooldown | 1.0.0, no file |
| 5 | INSPECT: --ignore-scripts | 1.1.0 installed, no file |

Line after beat 2: "npm even warned about install scripts - and ran it anyway."

Full wipe: `./reset.sh --all`, restart the registry, `./setup.sh`.
