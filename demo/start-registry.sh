#!/usr/bin/env bash
# Terminal 1. Leave it running. Install once beforehand: npm i -g verdaccio@6
set -euo pipefail
cd "$(dirname "$0")"
exec verdaccio --config ./config.yaml
