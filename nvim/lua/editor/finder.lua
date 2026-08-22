-- Fuzzy finding, in place of CtrlP.
--
-- <c-p> stays <c-p>, so the one key that mattered is unchanged; it is just
-- backed by ripgrep now, which respects .gitignore and does not need
-- g:ctrlp_custom_ignore to be kept in sync by hand. Everything CtrlP could not
-- do -- live grep across the tree, jumping to a symbol, walking diagnostics --
-- lives under <leader>f.

local M = {}

function M.setup()
  local fzf = require('fzf-lua')

  fzf.setup({
    winopts = {
      height = 0.85,
      width = 0.85,
      preview = { layout = 'vertical', vertical = 'down:45%' },
    },
    -- Filename first, then the directory dimmed after it: the part you are
    -- reading is at a fixed left margin instead of wherever the path ends.
    files = { formatter = 'path.filename_first' },
    grep = { formatter = 'path.filename_first' },
  })

  -- Route vim.ui.select through fzf-lua as well, so choosing a code action or
  -- a rename target uses the same picker as everything else instead of the
  -- built-in numbered inputlist().
  fzf.register_ui_select()

  local function map(lhs, rhs, desc)
    vim.keymap.set('n', lhs, rhs, { silent = true, desc = 'Find: ' .. desc })
  end

  map('<c-p>', fzf.files, 'files')
  map('<leader>ff', fzf.files, 'files')
  map('<leader>fg', fzf.live_grep, 'live grep')
  map('<leader>fw', fzf.grep_cword, 'grep word under cursor')
  map('<leader>fb', fzf.buffers, 'buffers')
  map('<leader>fo', fzf.oldfiles, 'recent files')
  map('<leader>fs', fzf.lsp_document_symbols, 'symbols in this file')
  map('<leader>fS', fzf.lsp_live_workspace_symbols, 'symbols in the project')
  map('<leader>fd', fzf.diagnostics_document, 'diagnostics in this file')
  map('<leader>fD', fzf.diagnostics_workspace, 'diagnostics in the project')
  map('<leader>fh', fzf.helptags, 'help')
  map('<leader>fr', fzf.resume, 'reopen the last picker')

  -- Grep the visual selection.
  vim.keymap.set('v', '<leader>fg', fzf.grep_visual, { silent = true, desc = 'Find: grep selection' })
end

return M
