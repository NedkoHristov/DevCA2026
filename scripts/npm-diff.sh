#!/usr/bin/env bash
# INSPECT: review what ships, not what is in git (the xz lesson).
# usage: ./scripts/npm-diff.sh <package> <old-version> <new-version>
set -euo pipefail
pkg="${1:?package}"; old="${2:?old}"; new="${3:?new}"
npm diff --diff="$pkg@$old" --diff="$pkg@$new" --diff-name-only
echo "---- full diff of package.json (look for new scripts) ----"
npm diff --diff="$pkg@$old" --diff="$pkg@$new" package.json || true
