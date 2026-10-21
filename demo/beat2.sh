#!/usr/bin/env bash
set -euo pipefail
source "$(dirname "$0")/env.sh"
cd "$APP"; clean_app; rm -f package-lock.json
say "Sunday, 03:12. Same command. Same package.json. Nobody changed anything."
show npm install
say "Looks fine. Did anything run?"
show ls
show cat demo-utils-was-here.txt
