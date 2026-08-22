-- Neovim-only configuration, loaded from nvim/init.vim after the shared vimrc.
--
-- Everything here is something Neovim 0.12 can do and Vim cannot: the built-in
-- LSP client, Treesitter, and a fuzzy completion engine. The shared vimrc
-- stays the single place where behaviour common to both editors is defined --
-- if a setting would work in Vim too, it belongs there, not here.
--
-- Each module is wrapped so that one broken plugin degrades that one feature
-- instead of aborting the rest of startup and leaving a half-configured editor.

local modules = { 'tools', 'lsp', 'completion', 'finder', 'treesitter' }

for _, name in ipairs(modules) do
  local ok, err = pcall(function() require('editor.' .. name).setup() end)
  if not ok then
    vim.schedule(function()
      vim.notify(('editor.%s failed to load: %s'):format(name, err), vim.log.levels.WARN)
    end)
  end
end
