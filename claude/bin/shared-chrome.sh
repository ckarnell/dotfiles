#!/bin/sh
# One long-lived Chrome that every Claude Code session attaches to over CDP.
# Each session gets its own tab/window; all of them share this one profile.
set -e

# Resolve the newest Playwright-managed Chrome for Testing, so a Playwright
# update doesn't silently break this by bumping the chromium-NNNN directory.
BASE="$HOME/Library/Caches/ms-playwright"
CHROME=$(ls -d "$BASE"/chromium-*/chrome-mac-arm64/"Google Chrome for Testing.app" 2>/dev/null \
  | sort -t- -k2 -n | tail -1)/Contents/MacOS/"Google Chrome for Testing"

if [ ! -x "$CHROME" ]; then
  echo "No Chrome for Testing found under $BASE" >&2
  exit 1
fi

PROFILE="$HOME/Library/Caches/ms-playwright-mcp/shared"
mkdir -p "$PROFILE"

exec "$CHROME" \
  --user-data-dir="$PROFILE" \
  --remote-debugging-port=9222 \
  --use-mock-keychain --password-store=basic \
  --no-first-run --no-default-browser-check \
  --disable-background-networking --disable-component-update \
  about:blank
