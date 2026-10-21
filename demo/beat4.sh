#!/usr/bin/env bash
set -euo pipefail
source "$(dirname "$0")/env.sh"
cd "$APP"; clean_app; rm -f package-lock.json

# Use the real cooldown if 1.0.0 is old enough; otherwise fall back to --before (same mechanism).
t100=$(npm view @demo/demo-utils 'time[1.0.0]')
t110=$(npm view @demo/demo-utils 'time[1.1.0]')
age_h=$(node -e "console.log(Math.floor((Date.now()-Date.parse('$t100'))/36e5))")

say "WAIT: no lockfile, same caret range, but fresh releases are invisible."
if [ "$age_h" -ge 24 ]; then
  show npm install --min-release-age=1
else
  before=$(node -e "console.log(new Date(Date.parse('$t110')-1000).toISOString())")
  say "(rehearsal: 1.0.0 is only ${age_h}h old, so using --before, the same mechanism)"
  show npm install --before="$before"
fi
show npm ls @demo/demo-utils
show ls
