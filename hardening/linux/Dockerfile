# Slide 21 - "a mutable reference means someone else decides what runs".

# BAD: the tag can be re-pointed tomorrow
# FROM node:24-slim

# GOOD: the digest is the content. Get it with:
#   docker buildx imagetools inspect node:24-slim --format '{{json .Manifest.Digest}}'
FROM node:24-slim@sha256:REPLACE_WITH_DIGEST

# Pin OS packages to exact versions (find them with: apt-cache policy curl)
RUN apt-get update \
 && apt-get install -y --no-install-recommends curl=REPLACE_VERSION \
 && rm -rf /var/lib/apt/lists/*

WORKDIR /app
COPY package.json package-lock.json ./
RUN npm ci --omit=dev --ignore-scripts
COPY . .
USER node
CMD ["node", "index.js"]
