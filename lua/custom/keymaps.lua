-- lua/custom/keymaps.lua
-- Personal keymaps added on top of kickstart defaults.

-- Switch to the most recently used buffer with <leader><Tab>
vim.keymap.set('n', '<leader><Tab>', '<C-^>', { desc = 'Switch to previous buffer' })
