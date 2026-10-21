#!/usr/bin/env bash
# Replace the OWNER placeholder with your GitHub username/org (lowercase for npm scope).
set -euo pipefail
owner="${1:?usage: ./scripts/bootstrap.sh <github-username>}"
lower="$(echo "$owner" | tr '[:upper:]' '[:lower:]')"
grep -rl --exclude-dir=.git --exclude-dir=node_modules 'OWNER' . | while read -r f; do
  [ "$f" = "./scripts/bootstrap.sh" ] && continue
  # npm scope must be lowercase; repo paths keep the original case
  sed -i.bak -e "s/@OWNER/@${lower}/g" -e "s/OWNER/${owner}/g" "$f" && rm -f "$f.bak"
  echo "updated $f"
done
