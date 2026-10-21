#!/usr/bin/env bash
set -euo pipefail
source "$(dirname "$0")/env.sh"
cd "$APP"; clean_app; rm -f package-lock.json
say "Friday. Normal install."
show npm install
show npm ls @demo/demo-utils
cp package-lock.json package-lock.1.0.0.json   # silently keep the good lockfile for beat 3
