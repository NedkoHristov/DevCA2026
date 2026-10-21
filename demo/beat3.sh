#!/usr/bin/env bash
set -euo pipefail
source "$(dirname "$0")/env.sh"; need_registry
cd "$APP"; clean_app
[ -f package-lock.1.0.0.json ] || { echo "Run ./beat1.sh first (it saves the good lockfile)."; exit 1; }
cp package-lock.1.0.0.json package-lock.json
say "LOCK: install exactly what the lockfile says."
show npm ci
show npm ls @demo/demo-utils
show ls
