#!/usr/bin/env bash
set -euo pipefail
source "$(dirname "$0")/env.sh"; need_registry
cd "$APP"; clean_app; rm -f package-lock.json
say "INSPECT: take the new version, but don't let dependencies run code."
show npm install --ignore-scripts
show npm ls @demo/demo-utils
show ls
say "1.1.0 is installed. Its script never ran."
