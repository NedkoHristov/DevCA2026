#!/usr/bin/env bash
set -euo pipefail
source "$(dirname "$0")/env.sh"
cd "$APP"; clean_app; cp package-lock.1.0.0.json package-lock.json
say "LOCK: install exactly what the lockfile says."
show npm ci
show npm ls @demo/demo-utils
show ls
