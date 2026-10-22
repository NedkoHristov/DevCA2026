#!/usr/bin/env bash
# ILLUSTRATION for the Tripwires slide. Prints what a canary-token hit looks like.
# Nothing is called, nothing is sent. Label the screenshot "illustration".
# The real thing (free, no AWS account needed): see hardening/tripwires/README.md
b='\033[1m'; y='\033[1;33m'; r='\033[1;31m'; d='\033[2m'; n='\033[0m'
printf "${b}\$ aws sts get-caller-identity --profile prod-admin${n}\n"
sleep 1
cat <<'JSON'
{
    "UserId": "AKIAVW5AZXGDGGENLSHW",
    "Account": "AAH1T3PEHy3kNMRo4/fuw3cqLFsG4ANriqSXF5cq",
    "Arn": "arn:aws:iam::843093809573:user/prod-admin"
}
JSON
sleep 2
printf "\n${d}──────────────────  2 minutes later, your phone  ──────────────────${n}\n"
printf "${r}  Canarytoken triggered:${n} ${y}\"DevCA2026 - laptop ~/.aws\"${n}\n"
printf "    Source IP:    203.0.113.47\n"
printf "    User agent:   aws-cli/2.x Python/3.x Darwin\n"
printf "    API call:     sts:GetCallerIdentity\n"
printf "    Reminder:     decoy key in ~/.aws/credentials [prod-admin]\n"
printf "${d}  (illustration - 203.0.113.0/24 is a reserved documentation range)${n}\n"
