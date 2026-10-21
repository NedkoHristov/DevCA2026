#!/usr/bin/env bash
# Default: remove only 1.1.0 (keeps 1.0.0, so it keeps aging for the cooldown beat).
# --all: wipe everything. Afterwards restart the registry and run ./setup.sh again.
set -euo pipefail
source "$(dirname "$0")/env.sh"
clean_app
rm -f "$APP/package-lock.json"
if [ "${1:-}" = "--all" ]; then
  rm -rf "$DEMO_DIR/storage" "$DEMO_DIR/htpasswd" "$NPM_CONFIG_USERCONFIG" "$NPM_CONFIG_CACHE" "$APP"/package-lock*.json
  echo "Wiped. Stop the registry (Ctrl+C), start it again, then run ./setup.sh"
else
  need_registry
  npm unpublish @demo/demo-utils@1.1.0 --force || true
  rm -rf "$NPM_CONFIG_CACHE"
  echo "1.1.0 removed. Run ./publish-new.sh when you want it back."
fi
