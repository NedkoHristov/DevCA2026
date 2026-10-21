# Stage demo: same command, different night

## Today (once)
1. npm i -g npm@11 verdaccio@6
2. Terminal 1: ./start-registry.sh
3. Terminal 2: ./setup.sh            # publishes 1.0.0, keep this registry until the talk
4. Rehearse: ./publish-new.sh, then ./beat1.sh ... ./beat5.sh
5. Record the screen during the rehearsal. That's your fallback video.
6. ./reset.sh                        # removes 1.1.0 only

## Morning of the talk
1. ./start-registry.sh
2. ./publish-new.sh                  # 1.1.0 is now minutes old, 1.0.0 is 2 days old
3. Wi-Fi off. Font size 28+. Dark theme.

## On stage (press Enter for every command)
beat1  night before   -> 1.0.0, no file
beat2  that night     -> "added 1 package", nothing visible... ls -> demo-utils-was-here.txt
beat3  LOCK  npm ci   -> 1.0.0, no file
beat4  WAIT  cooldown -> 1.0.0, no file
beat5  INSPECT        -> 1.1.0 installed, no file

## The line after beat 2
"npm hides dependency install-script output by default. You saw nothing. It ran anyway."
