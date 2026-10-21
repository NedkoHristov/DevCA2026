# Tripwires: make the harvest a detection event

The payloads in this talk grab every credential they find. Give them one that pages you.

1. Create a free AWS-key canary at https://canarytokens.org (type: AWS API key).
2. Plant it where real keys used to live:

```ini
# ~/.aws/credentials on laptops and self-hosted runners
[prod-admin]
aws_access_key_id = AKIA...CANARY
aws_secret_access_key = ...
```

3. Optional: a decoy `.npmrc` line with a fake `_authToken` and a canary DNS host as the registry.

Any use of the key emails you with source IP and user agent. Nobody legitimate
ever uses it, so false positives are close to zero.

Fire drill (slide: "timed"): plant one, start a stopwatch, measure
minutes-to-detect and minutes-to-dead-everywhere.
