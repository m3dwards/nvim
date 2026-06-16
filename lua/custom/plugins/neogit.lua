-- lua/custom/plugins/neogit.lua
-- Git UI using neogit + diffview
-- Note: plenary.nvim and telescope.nvim are already installed by init.lua

vim.pack.add {
  'https://github.com/NeogitOrg/neogit',
  'https://github.com/sindrets/diffview.nvim',
}

local neogit = require 'neogit'
neogit.setup {}

vim.keymap.set('n', '<leader>gs', function()
  neogit.open { kind = 'auto' }
end, { desc = '[G]it [S]tatus' })
