# Instructions for agents working in this repo

This repo brings a macOS machine to a known state: Vim, tmux, Zsh, and Claude
Code configuration. Everything is applied by one idempotent script,
`setup_dotfiles.sh`. Prefer running that script over performing its steps by
hand, and prefer extending it over making one-off changes to a machine.

Read `README.md` for the human-facing overview. This file covers what an agent
needs in order to install, verify, repair, and extend the setup without
rediscovering the traps.

## Setting up a fresh machine

Run these in order. The order matters: step 4 cannot succeed before step 3.

```bash
# 1. Clone
git clone git@github.com:ckarnell/dotfiles.git ~/dotfiles
cd ~/dotfiles

# 2. Apply everything. Idempotent, safe to re-run.
./setup_dotfiles.sh

# 3. Install a browser for Playwright. The LaunchAgent from step 2 points at
#    Chrome for Testing inside Playwright's cache, which does not exist yet on a
#    fresh machine, so the agent will have loaded but have nothing to launch.
npx playwright install chromium

# 4. Start the shared browser now that a binary exists.
launchctl kickstart -k gui/$(id -u)/com.cohen.playwright-shared-chrome
```

Missing prerequisites are not fatal. On a non-Mac the launch agents are skipped;
without the `claude` CLI the MCP registration is skipped. The script reports
what it skipped and exits 0.

## Verifying the result

Run all of these and confirm each. Do not report success without checking.

```bash
# Dotfiles are symlinks pointing into the repo, not copies
ls -l ~/.vimrc ~/.zshrc ~/.tmux.conf ~/.vim ~/.tmux

# Claude config is linked file by file (NOT the whole ~/.claude directory)
ls -l ~/.claude/CLAUDE.md ~/.claude/settings.json ~/.claude/bin/shared-chrome.sh

# Playwright MCP points at the shared browser, not at a user-data-dir
claude mcp get playwright          # expect: --cdp-endpoint http://127.0.0.1:9222

# The launch agent is loaded and its last run did not fail
launchctl list | grep playwright-shared-chrome   # expect a pid and exit code 0

# The shared browser is actually answering
curl -s http://127.0.0.1:9222/json/version       # expect JSON naming a Chrome build
```

## Traps, and why the code looks the way it does

Each of these caused a real failure. Preserve them.

**`setup_dotfiles.sh` must stay bash 3.2 compatible.** macOS ships bash 3.2 and a
stock machine has no Homebrew bash, so `#!/usr/bin/env bash` resolves to 3.2. An
earlier version used `declare -A`. It passed `bash -n`, then died at runtime on
the first array declaration before linking anything, which made it look like it
worked. Do not introduce associative arrays, `mapfile`, `readarray`, or `${var^}`
case conversion. Verify edits with `/bin/bash -n setup_dotfiles.sh` and, better,
by running the script under a sandboxed `HOME` (see below).

**Never symlink `~/.claude` itself.** That directory also holds session state:
`projects/`, history, and local settings. Link the individual files the repo owns
and leave the rest alone.

**`~/.claude.json` is intentionally untracked.** It is generated state that mixes
configuration with per-machine data (project history, per-directory settings) and
would conflict on every machine. MCP servers are declared in `setup_dotfiles.sh`
and applied with `claude mcp add`. Never commit this file, and never hand-edit it
to configure something that should be declared in the installer.

**LaunchAgent plists are copied, not symlinked.** launchd is unreliable about
loading a plist that lives behind a symlink. The script re-copies on every run,
so editing the plist in the repo and re-running is the way to update it.

**The shared browser is a single point of failure by design.** Every Claude Code
session attaches to one Chrome over CDP rather than launching its own. If it is
down, browser automation is down everywhere. `KeepAlive` in the plist handles
crashes; see the repair table for anything else.

## Repairing a broken machine

| Symptom | Cause | Fix |
| --- | --- | --- |
| `Browser is already in use for .../mcp-chrome-*` | MCP config drifted back to `--user-data-dir`; sessions are each launching their own Chrome against one profile | Re-run `./setup_dotfiles.sh`, then confirm with `claude mcp get playwright` |
| CDP on 9222 unreachable | Shared browser is down | `launchctl kickstart -k gui/$(id -u)/com.cohen.playwright-shared-chrome`, then check `/tmp/playwright-shared-chrome.err` |
| Browser will not start, log says no Chrome found | Playwright's browser cache is empty | `npx playwright install chromium`, then kickstart |
| Installer prints nothing and exits non-zero | A bash 4 feature crept in | `/bin/bash -n setup_dotfiles.sh`, then grep for `declare -A` |
| Claude sessions ignore the browser rules | `~/.claude/CLAUDE.md` missing or not linked | Re-run the installer; confirm with `ls -l ~/.claude/CLAUDE.md` |
| Two Chromes fighting over port 9222 | A second LaunchAgent or a hand-launched Chrome | `pgrep -fl "remote-debugging-port=9222"`; keep only the launchd-owned one |

## Extending the setup

Add to the installer rather than configuring a machine directly. The point of
this repo is that a new machine needs one command.

- **A new dotfile:** commit it, then add one `link <repo-path> <target>` call in
  the "Shell and editor" section.
- **A new MCP server:** add a `register_mcp_server <name> <command> [args...]`
  call. Do not capture it by committing `~/.claude.json`.
- **A new launch agent:** commit the plist under `launchd/`, then add an
  `install_launch_agent launchd/<file>.plist` call.
- **New Claude Code user config:** commit it under `claude/` and add a `link`
  call in the "Claude Code" section.

### Testing installer changes safely

Run it against a throwaway `HOME` with the system tools stubbed, so nothing real
is touched:

```bash
SANDBOX=$(mktemp -d); mkdir -p "$SANDBOX/home" "$SANDBOX/bin"
printf '#!/bin/sh\nexit 0\n' > "$SANDBOX/bin/launchctl"
printf '#!/bin/sh\nexit 1\n' > "$SANDBOX/bin/claude"
chmod +x "$SANDBOX/bin"/*
env -i PATH="$SANDBOX/bin:/usr/bin:/bin:/usr/sbin" HOME="$SANDBOX/home" \
  /bin/bash ./setup_dotfiles.sh
find "$SANDBOX/home" -maxdepth 3 \( -type l -o -type f \)
env -i PATH="$SANDBOX/bin:/usr/bin:/bin:/usr/sbin" HOME="$SANDBOX/home" \
  /bin/bash ./setup_dotfiles.sh   # second run must link 0
rm -rf "$SANDBOX"
```

A stubbed `claude` that exits 1 is deliberate: it proves a failing step reports
and continues instead of aborting the run.

## Why the shared browser exists

Chrome permits only one process per profile directory, enforced by a
`SingletonLock` naming the owning PID. When every Claude Code session launched
its own browser against one shared profile, the first session took the lock and
every other session failed for its entire lifetime with `Browser is already in
use`. That is structural, not a race worth retrying.

The fix is one long-lived Chrome, owned by launchd, that every session attaches
to over CDP. Sessions share cookies and logins, and each works in its own tab.

One behaviour cannot be fixed by configuration and so lives as a rule in
`claude/CLAUDE.md`: a newly attached client does not open a page of its own, and
on its first navigation it adopts whatever tab sits at index 0. Two sessions will
therefore both seize that tab and navigate each other's page away, silently, with
neither doing anything wrong. Every session must claim its own tab first with
`browser_tabs` using `action: "new"`. If you edit the browser setup, keep that
rule intact.
