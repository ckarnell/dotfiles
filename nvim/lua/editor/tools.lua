-- External programs this Neovim config depends on, and how to get them.
--
-- The point is that a fresh machine only needs `git clone` plus
-- `setup_dotfiles.sh`: the first Neovim launch notices what is missing, says
-- what it is for, and offers to install it. Nothing is installed without a
-- keypress, and "never" is remembered so the prompt cannot become noise.
--
-- Adding a tool means adding one entry to M.tools. Installers are tried in
-- order and the first one whose package manager is actually on the machine
-- wins, so the same table works on a box with uv but no Homebrew and vice
-- versa.

local M = {}

local function have(exe)
  return vim.fn.executable(exe) == 1
end

-- exe:     what has to be on $PATH for this to count as installed
-- what:    human name, used in the prompt
-- why:     what stops working without it
-- install: {manager, shell command} pairs, most preferred first
M.tools = {
  {
    exe = 'rg', what = 'ripgrep', why = 'file listing and live grep',
    install = { { 'brew', 'brew install ripgrep' } },
  },
  {
    exe = 'fzf', what = 'fzf', why = 'the fuzzy picker itself',
    install = { { 'brew', 'brew install fzf' } },
  },
  {
    -- The Homebrew formula called 'tree-sitter' is the C library, not this.
    -- nvim-treesitter's main branch shells out to the CLI to build parsers and
    -- fails one parser at a time, noisily, without it.
    exe = 'tree-sitter', what = 'tree-sitter CLI', why = 'building Treesitter parsers',
    install = {
      { 'brew', 'brew install tree-sitter-cli' },
      { 'npm', 'npm install -g tree-sitter-cli' },
    },
  },
  {
    exe = 'ruff', what = 'ruff', why = 'Python diagnostics and format-on-save',
    install = {
      { 'uv', 'uv tool install ruff' },
      { 'pipx', 'pipx install ruff' },
      { 'brew', 'brew install ruff' },
    },
  },
  {
    exe = 'basedpyright-langserver', what = 'basedpyright',
    why = 'Python types, goto-definition and completion',
    install = {
      { 'uv', 'uv tool install basedpyright' },
      { 'npm', 'npm install -g basedpyright' },
    },
  },
  {
    exe = 'typescript-language-server', what = 'typescript-language-server',
    why = 'TypeScript/JavaScript language server (what coc-tsserver used to do)',
    -- typescript is pinned to 5.x on purpose. It is only the fallback for a
    -- project with no local node_modules/typescript, but plain `typescript`
    -- now resolves to 7.x, the Go rewrite, which ships no lib/tsserver.js at
    -- all -- typescript-language-server then refuses to start with "Could not
    -- find a valid TypeScript installation".
    install = { { 'npm', 'npm install -g typescript@5 typescript-language-server' } },
  },
  {
    exe = 'vscode-json-language-server', what = 'vscode-langservers-extracted',
    why = 'JSON, CSS and HTML language servers',
    install = { { 'npm', 'npm install -g vscode-langservers-extracted' } },
  },
  {
    exe = 'lua-language-server', what = 'lua-language-server',
    why = 'Lua language server, used when editing this config',
    install = { { 'brew', 'brew install lua-language-server' } },
  },
}

local declined_file = vim.fn.stdpath('state') .. '/editor-tools-declined'

local function declined()
  local set = {}
  for _, name in ipairs(vim.fn.filereadable(declined_file) == 1
      and vim.fn.readfile(declined_file) or {}) do
    set[name] = true
  end
  return set
end

local function decline(tools)
  local set = declined()
  for _, t in ipairs(tools) do set[t.what] = true end
  vim.fn.writefile(vim.tbl_keys(set), declined_file)
end

-- The command that would install a tool here, or nil if no package manager
-- this entry knows about is present.
local function installer(tool)
  for _, pair in ipairs(tool.install) do
    if have(pair[1]) then return pair[2] end
  end
end

function M.missing(include_declined)
  local skip = include_declined and {} or declined()
  return vim.tbl_filter(function(t)
    return not have(t.exe) and not skip[t.what]
  end, M.tools)
end

-- Run the installs in a terminal split rather than a background job: these
-- shell out to brew/npm/uv, they can take a minute, and watching them is the
-- difference between "it is working" and "it is hung".
function M.install(tools)
  local cmds, unavailable = {}, {}
  for _, t in ipairs(tools) do
    local cmd = installer(t)
    if cmd then
      table.insert(cmds, string.format('echo "==> %s"; %s', cmd, cmd))
    else
      table.insert(unavailable, t.what)
    end
  end

  if #unavailable > 0 then
    vim.notify('No package manager available for: ' .. table.concat(unavailable, ', '),
      vim.log.levels.WARN)
  end
  if #cmds == 0 then return end

  table.insert(cmds, 'echo; echo "Done. Restart Neovim to pick the new tools up."')
  vim.cmd('botright 18split')
  vim.cmd.terminal(vim.o.shell .. ' -lc ' .. vim.fn.shellescape(table.concat(cmds, '; ')))
  vim.cmd.startinsert()
end

-- force: ask again even about tools previously declined (what :EditorTools does)
function M.check(force)
  local missing = M.missing(force)
  if #missing == 0 then
    if force then vim.notify('All external tools present.') end
    return
  end

  local lines = { 'Neovim is missing some external tools:', '' }
  for _, t in ipairs(missing) do
    table.insert(lines, string.format('  %-32s %s%s', t.what, t.why,
      installer(t) and '' or '   [no package manager for this]'))
  end
  table.insert(lines, '')
  table.insert(lines, 'Install them now?')

  local choice = vim.fn.confirm(table.concat(lines, '\n'), '&Yes\n&Later\nNe&ver', 2)
  if choice == 1 then
    M.install(missing)
  elseif choice == 3 then
    decline(missing)
    vim.notify('Not asking again. :EditorTools re-checks anyway.')
  end
end

function M.setup()
  vim.api.nvim_create_user_command('EditorTools', function() M.check(true) end,
    { desc = 'Check for (and offer to install) external tools this config needs' })

  -- Deferred so the prompt lands after the UI has drawn rather than on top of
  -- a half-painted screen, and skipped entirely for headless or piped runs so
  -- scripts never block on a confirm().
  if vim.fn.has('gui_running') == 1 or vim.fn.has('ttyin') == 1 then
    vim.api.nvim_create_autocmd('VimEnter', {
      once = true,
      callback = function() vim.defer_fn(function() M.check(false) end, 250) end,
    })
  end
end

return M
