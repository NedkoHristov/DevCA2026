#!/usr/bin/env bash
set -euo pipefail
source "$(dirname "$0")/env.sh"; need_registry
cd "$APP"; clean_app; rm -f package-lock.json
say "Friday. Only 1.0.0 exists yet (--before replays Friday)."
show npm install --before="$(npm view @demo/demo-utils 'time[1.0.0]')"
show npm ls @demo/demo-utils
cp package-lock.json package-lock.1.0.0.json   # silently keep the good lockfile for beat 3
