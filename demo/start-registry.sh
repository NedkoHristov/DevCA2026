#!/usr/bin/env bash
# Terminal 1. Leave it running. Stop with Ctrl+C.
set -euo pipefail
cd "$(dirname "$0")"
command -v verdaccio >/dev/null || { echo "Install first: npm i -g verdaccio@6"; exit 1; }
exec verdaccio --config ./config.yaml
