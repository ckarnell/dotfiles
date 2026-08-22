-- Completion, in place of coc.nvim's popup.
--
-- The keys are deliberately the same three the coc config used, so Vim and
-- Neovim feel identical: Tab and Shift-Tab cycle, Enter accepts, and nothing
-- is preselected (coc's "suggest.noselect": true). Because nothing is
-- preselected, Enter with the menu open but no item chosen falls through and
-- inserts a newline, which is the behaviour that setting was chosen for.
--
-- UltiSnips is untouched: it expands on <c-l> and jumps on <c-n>/<c-z>, none
-- of which the popup claims.

local M = {}

function M.setup()
  require('blink.cmp').setup({
    keymap = {
      preset = 'none',
      ['<Tab>']     = { 'select_next', 'fallback' },
      ['<S-Tab>']   = { 'select_prev', 'fallback' },
      ['<CR>']      = { 'accept', 'fallback' },
      ['<C-Space>'] = { 'show', 'hide' },
      ['<C-e>']     = { 'cancel', 'fallback' },
      ['<Up>']      = { 'select_prev', 'fallback' },
      ['<Down>']    = { 'select_next', 'fallback' },
    },

    completion = {
      list = { selection = { preselect = false, auto_insert = false } },
      documentation = { auto_show = true, auto_show_delay_ms = 200 },
      -- Ghost text would collide with copilot.vim, which draws its own and is
      -- accepted with <c-j>.
      ghost_text = { enabled = false },
    },

    signature = { enabled = true },

    sources = { default = { 'lsp', 'path', 'snippets', 'buffer' } },

    -- 'prefer_rust' uses blink's prebuilt native matcher when it downloaded
    -- cleanly and silently falls back to the Lua one when it did not, which is
    -- what makes this work on a machine with no toolchain and no network.
    fuzzy = { implementation = 'prefer_rust' },
  })
end

return M
