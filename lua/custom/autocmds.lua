-- lua/custom/autocmds.lua
-- Personal autocommands: auto-reload and auto-save.

-- Reload file from disk when Neovim regains focus or a buffer is entered
vim.o.autoread = true
vim.api.nvim_create_autocmd({ 'FocusGained', 'BufEnter' }, {
  command = "if mode() != 'c' | checktime | endif",
  pattern = '*',
})

-- Automatically save the file after leaving insert mode or changing text
local function clear_cmdarea()
  vim.defer_fn(function()
    vim.api.nvim_echo({}, false, {})
  end, 800)
end

vim.api.nvim_create_autocmd({ 'InsertLeave', 'TextChanged' }, {
  callback = function()
    if vim.bo.buftype ~= '' or vim.bo.modifiable == false then
      return
    end

    if #vim.api.nvim_buf_get_name(0) ~= 0 and vim.bo.buflisted then
      vim.cmd 'silent w'

      local time = os.date '%I:%M %p'
      vim.api.nvim_echo({ { '󰄳', 'LazyProgressDone' }, { ' file autosaved at ' .. time } }, false, {})

      clear_cmdarea()
    end
  end,
})
