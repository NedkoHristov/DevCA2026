#!/usr/bin/env bash
# Resolve every `uses: owner/repo@tag` in .github/workflows to a full commit SHA.
# Prints suggested replacements; review them, do not pipe into sed blindly.
set -euo pipefail
grep -rhoE 'uses: *[A-Za-z0-9_.-]+/[A-Za-z0-9_./-]+@[^ #]+' .github/workflows \
 | sed -E 's/uses: *//' | sort -u | while read -r ref; do
  action="${ref%@*}"; tag="${ref#*@}"
  [[ "$tag" =~ ^[0-9a-f]{40}$ ]] && { echo "ok      $ref"; continue; }
  repo="$(echo "$action" | cut -d/ -f1-2)"
  sha="$(gh api "repos/$repo/commits/$tag" --jq .sha)"
  echo "pin     $ref  ->  $action@$sha # $tag"
done
