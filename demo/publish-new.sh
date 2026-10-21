#!/usr/bin/env bash
# "That night": run on the morning of the talk, so 1.1.0 is less than a day old on stage.
set -euo pipefail
source "$(dirname "$0")/env.sh"
(cd "$DEMO_DIR/packages/demo-utils-1.1.0" && npm publish)
npm view @demo/demo-utils time --json
