# Tripwires: make the harvest a detection event

The payloads in this talk grab every credential they find. Give them one that pages you.

## Slide illustration (no account, nothing sent)

    ./scripts/canary-mock.sh

Label the screenshot "illustration".

## The real thing (free, no AWS account of your own)

1. https://canarytokens.org -> pick the tile **"AWS API Key"**
   (NOT "AWS Infrastructure" - that one needs your own AWS account and an IAM role).
2. Enter an email + a reminder ("laptop ~/.aws"). No account ID, no region.
3. Put the generated key into `~/.aws/credentials` under a believable profile, e.g. `[prod-admin]`.
4. Any use of the key (even `aws sts get-caller-identity`) emails you with source IP and user agent.
   AWS logging delays the alert by 2-30 minutes.

The key lives in Thinkst's AWS account and has no permissions.

## Where to plant them

| Where | Why |
|---|---|
| `~/.aws/credentials` on laptops | payloads scan home dirs and dotfiles |
| home dir of self-hosted runners | Shai-Hulud 2.0 targeted runners |
| a GitHub Actions secret referenced in a workflow | GhostAction copied secret names from workflows |
| old git history of a decoy repo | the Oct 2026 GhostAction wave scanned history |

One token per location, each with its own reminder, so the alert tells you which machine.
