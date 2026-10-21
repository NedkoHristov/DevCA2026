#!/usr/bin/env bash
# "Who is still running things at 03:30?"  Lists every scheduled workflow you can see,
# with its cron, when the file was last touched and by whom.
# usage: ./scripts/census.sh <user-or-org>
set -euo pipefail
owner="${1:?usage: ./scripts/census.sh <user-or-org>}"
printf "%-40s %-35s %-18s %-12s %s\n" REPO WORKFLOW CRON LAST_CHANGE AUTHOR
gh repo list "$owner" --limit 500 --no-archived --json nameWithOwner --jq '.[].nameWithOwner' |
while read -r repo; do
  gh api "repos/$repo/contents/.github/workflows" --jq '.[].path' 2>/dev/null |
  while read -r path; do
    body="$(gh api "repos/$repo/contents/$path" --jq .content 2>/dev/null | base64 -d 2>/dev/null || true)"
    cron="$(echo "$body" | grep -oE "cron: *['\"][^'\"]+['\"]" | head -1 | sed -E "s/cron: *['\"]//; s/['\"]$//")"
    [ -z "$cron" ] && continue
    last="$(gh api "repos/$repo/commits?path=$path&per_page=1" --jq '.[0] | "\(.commit.author.date[0:10]) \(.commit.author.name)"' 2>/dev/null || echo "? ?")"
    printf "%-40s %-35s %-18s %-12s %s\n" "$repo" "${path##*/}" "$cron" "${last%% *}" "${last#* }"
  done
done
