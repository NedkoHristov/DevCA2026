#!/usr/bin/env bash
# "That night": publish the simulated bad 1.1.0. On the talk day, run this the same morning.
set -euo pipefail
source "$(dirname "$0")/env.sh"
need_registry
(cd "$DEMO_DIR/packages/demo-utils-1.1.0" && npm publish)
npm view @demo/demo-utils time --json
