#!/usr/bin/env bash
# Slide 18 - live numbers instead of screenshots that go stale.
set -euo pipefail
pkgs="${*:-gulp semver}"
for p in $pkgs; do
  dl=$(curl -s "https://api.npmjs.org/downloads/point/last-week/$p" | python3 -c 'import json,sys; print("{:,}".format(json.load(sys.stdin)["downloads"]))')
  echo "$p: $dl downloads last week"
done
tmp=$(mktemp -d); cd "$tmp"
npm init -y >/dev/null
npm install gulp --ignore-scripts --silent >/dev/null 2>&1
total=$(npm ls --all --parseable | tail -n +2 | wc -l)
echo "npm install gulp -> $total packages on disk (1 you chose, $((total-1)) you trust)"
rm -rf "$tmp"
