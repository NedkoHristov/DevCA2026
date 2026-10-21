#!/usr/bin/env bash
# Default: remove only 1.1.0 (keeps 1.0.0 old enough for the cooldown beat).
# --all: wipe everything, including 1.0.0 (then the cooldown beat needs a day again).
set -euo pipefail
source "$(dirname "$0")/env.sh"
clean_app
rm -f "$APP/package-lock.json"
if [ "${1:-}" = "--all" ]; then
  rm -rf "$DEMO_DIR/storage" "$DEMO_DIR/htpasswd" "$NPM_CONFIG_USERCONFIG" "$NPM_CONFIG_CACHE" "$APP"/package-lock*.json
  echo "Wiped. Restart the registry and run setup.sh."
else
  npm unpublish @demo/demo-utils@1.1.0 --force || true
  rm -rf "$NPM_CONFIG_CACHE"
  echo "1.1.0 removed. Run publish-new.sh when you want it back."
fi
