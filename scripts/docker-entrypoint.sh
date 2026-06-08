#!/usr/bin/env bash
set -euo pipefail

for dir in /app/danmaku/deps /app/danmaku/_build /app/danmaku/assets/node_modules; do
  mkdir -p "$dir"
done

for dir in /app/danmaku/deps /app/danmaku/_build /app/danmaku/assets/node_modules; do
  marker="$dir/.owner-initialized"
  if [ ! -f "$marker" ]; then
    chown -R app:app "$dir"
    touch "$marker"
    chown app:app "$marker"
  fi
done

exec gosu app "$@"
