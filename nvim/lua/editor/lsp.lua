-- Neovim's built-in LSP client, in place of coc.nvim and jedi-vim.
--
-- Neovim 0.12 reads server definitions from lsp/<name>.lua anywhere on the
-- runtimepath, which is exactly what nvim-lspconfig ships -- so lspconfig is
-- data here, not a framework, and vim.lsp.enable() is the whole wiring.
--
-- Servers are only enabled when their executable is actually present. That
-- keeps a machine that has not run :EditorTools yet quiet instead of throwing
-- a "cmd not executable" error for every buffer opened.

local M = {}

-- lspconfig server name -> the binary that has to exist to start it
local servers = {
  basedpyright = 'basedpyright-langserver',
  ruff         = 'ruff',
  ts_ls        = 'typescript-language-server',
  jsonls       = 'vscode-json-language-server',
  cssls        = 'vscode-css-language-server',
  lua_ls       = 'lua-language-server',
}

-- Filetypes where the LSP client formats on save. JS/TS are deliberately
-- absent: ALE already runs prettier and eslint there as fixers, and two
-- formatters fighting over one buffer is worse than either alone.
local format_on_save = { python = true, lua = true }

local function organize_imports()
  vim.lsp.buf.code_action({
    context = { only = { 'source.organizeImports' }, diagnostics = {} },
    apply = true,
  })
end

local function on_attach(buf)
  local function map(mode, lhs, rhs, desc)
    vim.keymap.set(mode, lhs, rhs, { buffer = buf, silent = true, desc = 'LSP: ' .. desc })
  end

  -- The keys jedi-vim and coc used to own, pointed at the LSP client so they
  -- now mean the same thing in every language rather than only Python or only
  -- TypeScript.
  map('n', '<leader>g', vim.lsp.buf.definition, 'go to definition')
  map('n', '<leader>u', function() require('fzf-lua').lsp_references() end, 'references')
  map('n', '<leader>r', vim.lsp.buf.rename, 'rename')
  map('n', '<leader>i', vim.lsp.buf.code_action, 'code action')
  map('n', '<leader>oi', organize_imports, 'organize imports')

  -- K is investigate.vim (Dash lookup) and stays that way; hover gets its own
  -- key rather than quietly stealing one that already does something.
  map('n', '<leader>k', function() vim.lsp.buf.hover() end, 'hover')

  -- <F4> was coc's "add the missing import" in TS. Python keeps python-imports'
  -- :ImportName on that key, which is better at exactly that one job.
  if vim.bo[buf].filetype ~= 'python' then
    map('n', '<F4>', vim.lsp.buf.code_action, 'code action (add import)')
  end
end

-- Format on save, wired once rather than per client.
--
-- The obvious version of this -- check supports_method('textDocument/formatting')
-- inside on_attach -- silently does nothing, because ruff registers its
-- formatting capability dynamically after initialize: at LspAttach time it
-- still answers false. Deciding at write time avoids the race entirely, and
-- vim.lsp.buf.format() already picks out the clients that can format.
local function format_on_write()
  vim.api.nvim_create_autocmd('BufWritePre', {
    group = vim.api.nvim_create_augroup('editor_lsp_format', { clear = true }),
    pattern = '*',
    callback = function(ev)
      if not format_on_save[vim.bo[ev.buf].filetype] then return end
      if #vim.lsp.get_clients({ bufnr = ev.buf }) == 0 then return end
      vim.lsp.buf.format({ bufnr = ev.buf, timeout_ms = 2000 })
    end,
  })
end

function M.setup()
  -- ruff and basedpyright both attach to Python. ruff is the faster, better
  -- linter and formatter; basedpyright is the one that knows types. Silencing
  -- ruff's hover stops the two of them racing to answer the same request.
  vim.lsp.config('ruff', {
    on_attach = function(client)
      client.server_capabilities.hoverProvider = false
    end,
  })

  vim.lsp.config('basedpyright', {
    settings = {
      basedpyright = {
        -- 'recommended' turns on a wall of strictness that is miserable on an
        -- existing codebase. 'standard' is roughly what pyright gives you.
        analysis = { typeCheckingMode = 'standard' },
      },
    },
  })

  vim.lsp.config('lua_ls', {
    settings = {
      Lua = {
        runtime = { version = 'LuaJIT' },
        diagnostics = { globals = { 'vim' } },
        workspace = { checkThirdParty = false },
        telemetry = { enable = false },
      },
    },
  })

  local enabled = {}
  for name, exe in pairs(servers) do
    if vim.fn.executable(exe) == 1 then table.insert(enabled, name) end
  end
  if #enabled > 0 then vim.lsp.enable(enabled) end

  format_on_write()

  vim.api.nvim_create_autocmd('LspAttach', {
    group = vim.api.nvim_create_augroup('editor_lsp_attach', { clear = true }),
    callback = function(ev) on_attach(ev.buf) end,
  })

  -- Same gutter marks ALE used, so the signs mean what they always meant.
  vim.diagnostic.config({
    severity_sort = true,
    virtual_text = { spacing = 2, prefix = '·' },
    signs = {
      text = {
        [vim.diagnostic.severity.ERROR] = '🐛',
        [vim.diagnostic.severity.WARN]  = '🐋',
        [vim.diagnostic.severity.INFO]  = '·',
        [vim.diagnostic.severity.HINT]  = '·',
      },
    },
    float = { border = 'rounded', source = true },
  })

  vim.api.nvim_create_user_command('Format', function()
    vim.lsp.buf.format({ timeout_ms = 5000 })
  end, { desc = 'Format the buffer with the attached language server' })

  vim.api.nvim_create_user_command('LspStatus', function()
    local clients = vim.lsp.get_clients({ bufnr = 0 })
    if #clients == 0 then return vim.notify('No language server attached to this buffer.') end
    vim.notify(table.concat(vim.tbl_map(function(c) return c.name end, clients), ', ')
      .. ' attached')
  end, { desc = 'Which language servers are attached to this buffer' })
end

return M
