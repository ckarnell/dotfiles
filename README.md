# Dotfiles

Configuration for Vim, tmux, Zsh, and Claude Code.

## Setting up a new machine

```bash
git clone git@github.com:ckarnell/dotfiles.git ~/dotfiles
cd ~/dotfiles
./setup_dotfiles.sh
```

That is the whole process. The script is idempotent, so run it again any time
you pull changes or want to repair a machine's state.

## What the script does

| Section | Action |
| --- | --- |
| Shell and editor | Symlinks `.vimrc`, `.tmux.conf`, `.zshrc`, `.vim`, `.tmux`, `~/.config/nvim` |
| Claude Code | Symlinks `~/.claude/CLAUDE.md`, `~/.claude/settings.json`, `~/.claude/bin/shared-chrome.sh` |
| Launch agents | Copies plists into `~/Library/LaunchAgents` and loads them |
| MCP servers | Registers Claude Code MCP servers through the `claude` CLI |

Anything already present at a target path is moved into `~/.dotfiles_backup`
with a timestamp before being replaced. Nothing is overwritten in place.

Steps degrade rather than fail: on a non-Mac the launch agents are skipped, and
if the `claude` CLI is not installed the MCP registration is skipped. The script
reports what it skipped and keeps going.

## Layout

```
vimrc, vim/          Vim and Neovim (shared config and runtime dir)
nvim/                Neovim bootstrap, linked into ~/.config/nvim
tmux.conf, tmux/     tmux
zshrc                Zsh
claude/              Claude Code config, linked into ~/.claude
launchd/             macOS LaunchAgent plists
setup_dotfiles.sh    the installer
```

## Claude Code specifics

Three files are tracked, and one deliberately is not.

`claude/CLAUDE.md` is user-level instructions loaded into every Claude Code
session in every project. `claude/settings.json` holds user preferences such as
the default model. `claude/bin/shared-chrome.sh` launches the shared browser
described below.

`~/.claude.json` is **not** tracked. It mixes real configuration with per-machine
state (project history, per-directory settings) and would conflict constantly
across machines. MCP servers are declared in `setup_dotfiles.sh` instead and
applied with `claude mcp add`, which is the durable way to express them.

### The shared browser

Playwright MCP is registered with `--cdp-endpoint http://127.0.0.1:9222` rather
than being allowed to launch its own browser. A LaunchAgent keeps one Chrome for
Testing running on a dedicated profile, and every Claude Code session attaches to
it over CDP.

This exists because Chrome permits only one process per profile directory. With
each session launching its own browser against a shared profile, the first
session to start took the lock and every other session failed with
`Browser is already in use` for its entire lifetime. Attaching to one long-lived
browser removes the contention: sessions share cookies and logins, and each works
in its own tab.

The rules agents follow when using it are in `claude/CLAUDE.md`. The important
one is that a session must claim its own tab before doing anything else, because
a newly attached client otherwise adopts whatever tab is at index 0 and will
navigate another session's page out from under it.

To restart the browser by hand:

```bash
launchctl kickstart -k gui/$(id -u)/com.cohen.playwright-shared-chrome
```

## Compatibility note

`setup_dotfiles.sh` targets bash 3.2, which is what macOS still ships. Avoid
bash 4 features when editing it, particularly associative arrays (`declare -A`).
An earlier version used them, and because `/usr/bin/env bash` resolves to 3.2 on
a stock Mac, it aborted at runtime before linking anything while still passing a
syntax check.
