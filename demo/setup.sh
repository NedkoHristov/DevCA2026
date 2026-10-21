#!/usr/bin/env bash
# Run ONCE. Creates a demo user and publishes the clean 1.0.0 to the local registry.
set -euo pipefail
source "$(dirname "$0")/env.sh"
need_registry

v=$(npm --version); major=${v%%.*}; rest=${v#*.}; minor=${rest%%.*}
if [ "$major" -lt 11 ] || { [ "$major" -eq 11 ] && [ "$minor" -lt 10 ]; }; then
  echo "WARNING: npm $v. Beat 4 needs npm >= 11.10 for min-release-age (it falls back to --before). Fix: npm i -g npm@11"
fi

resp=$(curl -s -X PUT "${REGISTRY}-/user/org.couchdb.user:demo" \
  -H 'content-type: application/json' \
  -d '{"name":"demo","password":"demo-pass-123"}')
token=$(printf '%s' "$resp" | node -e 'let s="";process.stdin.on("data",d=>s+=d).on("end",()=>{try{console.log(JSON.parse(s).token||"")}catch{console.log("")}})')
[ -n "$token" ] || { echo "Could not get a token from Verdaccio. Response: $resp"; exit 1; }

cat > "$NPM_CONFIG_USERCONFIG" <<CFG
registry=${REGISTRY}
//localhost:4873/:_authToken=${token}
prefer-online=true
audit=false
fund=false
update-notifier=false
CFG

if npm view @demo/demo-utils@1.0.0 version >/dev/null 2>&1; then
  echo "1.0.0 already published. Nothing to do."
else
  (cd "$DEMO_DIR/packages/demo-utils-1.0.0" && npm publish)
fi
echo "Ready. 1.0.0 published at: $(npm view @demo/demo-utils 'time[1.0.0]')"
