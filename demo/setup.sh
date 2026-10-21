#!/usr/bin/env bash
# Run ONCE, today. Creates a demo user and publishes the clean 1.0.0.
set -euo pipefail
source "$(dirname "$0")/env.sh"

npm_major_minor=$(npm --version | awk -F. '{print $1*100+$2}')
if [ "$npm_major_minor" -lt 1110 ]; then
  echo "npm $(npm --version) is too old for min-release-age. Run: npm i -g npm@11"; exit 1
fi
curl -sf "${REGISTRY}-/ping" >/dev/null || { echo "Start ./start-registry.sh first"; exit 1; }

token=$(curl -s -X PUT "${REGISTRY}-/user/org.couchdb.user:demo" \
  -H 'content-type: application/json' \
  -d '{"name":"demo","password":"demo-pass-123"}' \
  | node -pe 'JSON.parse(require("fs").readFileSync(0)).token')
[ -n "$token" ] && [ "$token" != "undefined" ] || { echo "Could not get a token from Verdaccio"; exit 1; }

cat > "$NPM_CONFIG_USERCONFIG" <<EOF
registry=${REGISTRY}
//localhost:4873/:_authToken=${token}
prefer-online=true
audit=false
fund=false
update-notifier=false
EOF

(cd "$DEMO_DIR/packages/demo-utils-1.0.0" && npm publish)
echo "Published @demo/demo-utils@1.0.0 at $(date -u +%FT%TZ). Keep this registry until the talk."
