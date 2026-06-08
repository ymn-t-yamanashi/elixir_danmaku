#!/usr/bin/env bash
set -euo pipefail

APP_DIR="${APP_DIR:-$PWD}"
LOG_FILE="${TMPDIR:-/tmp}/danmaku-browser-check.log"

(cd "$APP_DIR" && if [ ! -d deps ] || [ -z "$(find deps -mindepth 1 -maxdepth 1 -print -quit 2>/dev/null)" ]; then mix deps.get; fi)

echo "ensuring browser dependencies"
(cd "$APP_DIR/assets" && if [ ! -d node_modules/playwright-core ]; then npm ci --no-audit --no-fund; fi)

echo "building assets"
(cd "$APP_DIR" && mix assets.build)

cd "$APP_DIR"

echo "starting server"
mix phx.server >"$LOG_FILE" 2>&1 &
SERVER_PID=$!

cleanup() {
  kill "$SERVER_PID" >/dev/null 2>&1 || true
}

trap cleanup EXIT INT TERM

for _ in {1..60}; do
  if curl -fsS http://127.0.0.1:4000 >/dev/null 2>&1; then
    break
  fi
  sleep 1
done

echo "running browser script"
node assets/browser-check.mjs
