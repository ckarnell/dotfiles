#!/usr/bin/env bash
#
# One script to bring a machine to the state described by this repo.
# Safe to run repeatedly: everything below is idempotent.
#
# Deliberately written for bash 3.2, the version macOS still ships. Do not
# introduce associative arrays (`declare -A`) or other bash 4 features here;
# `/usr/bin/env bash` resolves to 3.2 on a stock Mac and the script will die at
# runtime rather than at parse time, which is how this went unnoticed before.

set -euo pipefail

REPO="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BACKUP_DIR="$HOME/.dotfiles_backup"
TIMESTAMP="$(date +%Y%m%d-%H%M%S)"

LINKED=0
BACKED_UP=0
SKIPPED=0

step() { printf '\n\033[1m%s\033[0m\n' "$*"; }
info() { printf '  %s\n' "$*"; }
warn() { printf '  ! %s\n' "$*" >&2; }

# link <path-relative-to-repo> <absolute-target>
link() {
  local rel="$1" dst="$2" src backup
  src="$REPO/$rel"

  if [ ! -e "$src" ]; then
    warn "missing in repo, skipping: $rel"
    SKIPPED=$((SKIPPED + 1))
    return 0
  fi

  mkdir -p "$(dirname "$dst")"

  if [ -L "$dst" ] && [ "$(readlink "$dst")" = "$src" ]; then
    info "already linked: $dst"
    return 0
  fi

  if [ -e "$dst" ] || [ -L "$dst" ]; then
    mkdir -p "$BACKUP_DIR"
    backup="$BACKUP_DIR/$(basename "$dst").$TIMESTAMP"
    info "backup: $dst -> $backup"
    mv "$dst" "$backup"
    BACKED_UP=$((BACKED_UP + 1))
  fi

  ln -sfn "$src" "$dst"
  info "linked: $dst"
  LINKED=$((LINKED + 1))
}

# ---------------------------------------------------------------- shell/editor

step "Shell and editor"
link vimrc     "$HOME/.vimrc"
link tmux.conf "$HOME/.tmux.conf"
link zshrc     "$HOME/.zshrc"
link vim       "$HOME/.vim"
link tmux      "$HOME/.tmux"

# ---------------------------------------------------------------------- claude

# Link individual files rather than the whole ~/.claude directory: that
# directory also holds session state (projects/, history, local settings) that
# must not be replaced by a symlink into this repo.
step "Claude Code"
link claude/CLAUDE.md            "$HOME/.claude/CLAUDE.md"
link claude/settings.json        "$HOME/.claude/settings.json"
link claude/bin/shared-chrome.sh "$HOME/.claude/bin/shared-chrome.sh"

# --------------------------------------------------------------- launch agents

# Copied rather than symlinked: launchd is unreliable about loading plists that
# live behind a symlink. Re-copying on every run keeps it in sync with the repo.
install_launch_agent() {
  local rel="$1" src dst label
  src="$REPO/$rel"
  label="$(basename "$rel" .plist)"
  dst="$HOME/Library/LaunchAgents/$(basename "$rel")"

  if [ "$(uname -s)" != "Darwin" ]; then
    info "not macOS, skipping: $label"
    SKIPPED=$((SKIPPED + 1))
    return 0
  fi
  if [ ! -f "$src" ]; then
    warn "missing in repo, skipping: $rel"
    SKIPPED=$((SKIPPED + 1))
    return 0
  fi

  mkdir -p "$HOME/Library/LaunchAgents"
  cp "$src" "$dst"
  launchctl unload "$dst" >/dev/null 2>&1 || true
  if launchctl load "$dst" >/dev/null 2>&1; then
    info "loaded: $label"
  else
    warn "installed but failed to load: $label"
  fi
}

step "Launch agents"
install_launch_agent launchd/com.cohen.playwright-shared-chrome.plist

# ------------------------------------------------------------------ mcp servers

# Registered through the CLI rather than by committing ~/.claude.json, which is
# machine-local state (project history, per-directory settings) and not
# something to version control.
register_mcp_server() {
  local name="$1"
  shift

  if ! command -v claude >/dev/null 2>&1; then
    info "claude CLI not found, skipping: $name"
    SKIPPED=$((SKIPPED + 1))
    return 0
  fi

  if claude mcp get "$name" >/dev/null 2>&1; then
    if claude mcp get "$name" 2>/dev/null | grep -q -- "$1"; then
      info "already registered: $name"
      return 0
    fi
    info "reconfiguring: $name"
    claude mcp remove "$name" -s user >/dev/null 2>&1 || true
  fi

  if claude mcp add "$name" -s user -- "$@" >/dev/null 2>&1; then
    info "registered: $name"
  else
    warn "failed to register: $name"
  fi
}

step "MCP servers"
# One shared browser on CDP 9222, so concurrent sessions never fight over a
# Chrome profile lock. See claude/CLAUDE.md for the rules agents follow.
register_mcp_server playwright \
  npx @playwright/mcp@latest --cdp-endpoint http://127.0.0.1:9222

# ---------------------------------------------------------------------- summary

step "Done"
info "linked $LINKED, backed up $BACKED_UP, skipped $SKIPPED"
[ "$BACKED_UP" -gt 0 ] && info "backups in $BACKUP_DIR"
exit 0
