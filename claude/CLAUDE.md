# Global instructions

## Playwright uses one shared, always-on browser

Playwright MCP is configured with `--cdp-endpoint http://127.0.0.1:9222`. It does
**not** launch its own browser. It attaches to a single Chrome for Testing kept
alive by the LaunchAgent `com.cohen.playwright-shared-chrome`, running on the
profile `~/Library/Caches/ms-playwright-mcp/shared`. Every concurrent session
attaches to that same browser and shares one tab space.

### Claim your own tab before you do anything else

**Your first browser action in a session must be `browser_tabs` with
`action: "new"`** (pass your first `url` to it if you have one). Then work only in
that tab.

This is not tidiness, it is correctness. A freshly attached server does **not**
open a tab of its own: on its first `browser_navigate` it adopts whatever tab is
at index 0 and drives that. Two sessions therefore both grab tab 0 and navigate
each other's page out from under them, silently, with neither one doing anything
wrong. Claiming a tab up front is what prevents it. Verified behaviour, not theory.

### Other rules

- **Never kill the browser.** No `pkill chrome`, no killing PIDs on port 9222. That
  destroys other sessions' work, and the LaunchAgent respawns it anyway.
  `browser_close` only detaches your client, which is fine and expected.
- **`browser_tabs` lists every session's tabs, not just yours.** Do not close or
  select tabs you did not create; assume unfamiliar tabs are in active use.
- **Cookies and logins are shared and persistent.** Anything you log into is visible
  to every other session. Treat the profile as shared state.
- **If CDP is unreachable**, the browser is down rather than locked. Restart it with
  `launchctl kickstart -k gui/$(id -u)/com.cohen.playwright-shared-chrome`, then wait
  a few seconds for port 9222. Do not launch Chrome by hand, and do not switch the MCP
  config to `--isolated`; that reintroduces the profile-lock problem this setup solves.
- A genuinely isolated browser is still available when a task must not touch shared
  state, but it is a deliberate exception. Ask before changing MCP configuration.

Setup lives in `~/.claude/bin/shared-chrome.sh` and
`~/Library/LaunchAgents/com.cohen.playwright-shared-chrome.plist`.
