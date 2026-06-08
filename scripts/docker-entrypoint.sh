#!/usr/bin/env bash
set -euo pipefail

for dir in /app/danmaku/deps /app/danmaku/_build /app/danmaku/assets/node_modules; do
  mkdir -p "$dir"
done

chown -R app:app /app/danmaku/deps /app/danmaku/_build /app/danmaku/assets/node_modules

exec gosu app "$@"
