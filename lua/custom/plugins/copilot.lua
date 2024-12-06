return {
  {
    'github/copilot.vim',
    config = function()
      vim.api.nvim_set_keymap('i', '<C-C>', 'copilot#Accept("<CR>")', { silent = false, expr = true })
      vim.g.copilot_no_tab_map = true
      vim.g.copilot_assume_mapped = true
    end,
  },
}
