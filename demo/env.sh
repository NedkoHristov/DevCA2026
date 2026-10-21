# Sourced by every script. Keeps the demo away from your real ~/.npmrc and npm cache.
DEMO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
APP="$DEMO_DIR/app"
export REGISTRY="http://localhost:4873/"
export NPM_CONFIG_USERCONFIG="$DEMO_DIR/.npmrc-demo"
export NPM_CONFIG_CACHE="$DEMO_DIR/.npm-cache"

# Print the command, wait for Enter, run it. DEMO_AUTO=1 skips the wait (for testing).
show() {
  printf '\n\033[1;36m$ %s\033[0m' "$*"
  if [ "${DEMO_AUTO:-0}" = "1" ]; then echo; else read -r _; fi
  eval "$*"
}
say() { printf '\n\033[1;33m# %s\033[0m\n' "$*"; }
clean_app() { rm -rf "$APP/node_modules" "$APP/demo-utils-was-here.txt"; }
need_registry() {
  curl -sf "${REGISTRY}-/ping" >/dev/null || { echo "Registry not running. In another terminal: ./start-registry.sh"; exit 1; }
}
