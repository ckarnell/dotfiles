-- Treesitter highlighting, in place of the five regex syntax plugins Vim still
-- loads (python-syntax, vim-javascript, vim-json, scss-syntax, vim-graphql).
--
-- Highlighting only. Indent is left to the existing indent/ files, which are
-- tuned for how this config actually wants Python to indent and are better at
-- it than the generic Treesitter indenter; folding is left alone because
-- 'foldenable' is on and a Treesitter foldexpr would close every function the
-- moment a file opens.

local M = {}

local parsers = {
  'bash', 'css', 'diff', 'gitcommit', 'graphql', 'html', 'javascript', 'json',
  'lua', 'markdown', 'markdown_inline', 'python', 'scss', 'sql',
  'toml', 'tsx', 'typescript', 'vim', 'vimdoc', 'yaml',
}

-- Filetypes above, in Vim's names rather than Treesitter's.
local filetypes = {
  'bash', 'css', 'diff', 'gitcommit', 'graphql', 'html', 'javascript',
  'javascriptreact', 'json', 'lua', 'markdown', 'python', 'scss',
  'sh', 'sql', 'toml', 'typescript', 'typescriptreact', 'vim', 'yaml',
}

function M.setup()
  local ok, ts = pcall(require, 'nvim-treesitter')
  if not ok then return end

  -- Install in the background on first run. Parsers are compiled per machine,
  -- so they cannot be committed to the dotfiles repo. Skipped without the
  -- tree-sitter CLI, which is what actually builds them -- editor.tools offers
  -- to install it, and until then this stays silent rather than printing one
  -- build failure per language on every launch.
  if vim.fn.executable('tree-sitter') == 1 then
    local installed = require('nvim-treesitter.config').get_installed('parsers')
    local missing = vim.tbl_filter(function(p)
      return not vim.tbl_contains(installed, p)
    end, parsers)
    if #missing > 0 then ts.install(missing) end
  end

  vim.api.nvim_create_autocmd('FileType', {
    group = vim.api.nvim_create_augroup('editor_treesitter', { clear = true }),
    pattern = filetypes,
    callback = function()
      -- Fails quietly for a filetype whose parser has not finished installing
      -- yet; the regex syntax stays up in the meantime.
      pcall(vim.treesitter.start)
    end,
  })
end

return M
