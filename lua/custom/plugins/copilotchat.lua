-- lua/custom/plugins/copilotchat.lua
-- Conversational code explanations via CopilotChat.nvim, powered by the
-- existing GitHub Copilot subscription (auth is shared with github/copilot.vim).
-- plenary.nvim is already installed by init.lua, so it is not re-added here.
--
-- Typical use: visually select a function or a few lines, then press
-- <leader>cce ("explain"), and ask follow-up questions in the chat window.

vim.pack.add { 'https://github.com/CopilotC-Nvim/CopilotChat.nvim' }

require('CopilotChat').setup {
  -- Open the chat in a right-hand vertical split.
  window = {
    layout = 'vertical',
    width = 0.4,
  },
}

-- Register the <leader>cc group with which-key if available (matches the
-- <leader>cm CMake group convention).
local ok, wk = pcall(require, 'which-key')
if ok then
  wk.add { { '<leader>cc', group = '[C]opilot [C]hat' } }
end

-- Keymaps in normal and visual mode. The selection commands use the ':<C-u>'
-- idiom (not '<cmd>') so Visual mode is exited before the command runs. This
-- matters because '<cmd>' *preserves* Visual mode, which leaves the '< / '>
-- marks pointing at the *previous* Visual area (see :help <Cmd>). CopilotChat
-- reads those marks for #neovim://selection, so with '<cmd>' the selection
-- resolves empty. Exiting Visual first sets the marks to the current selection.
vim.keymap.set({ 'n', 'v' }, '<leader>cct', '<cmd>CopilotChatToggle<cr>', { desc = 'Copilot Chat: [T]oggle window' })
vim.keymap.set({ 'n', 'v' }, '<leader>cce', ':<C-u>CopilotChatExplain<cr>', { desc = 'Copilot Chat: [E]xplain selection' })
vim.keymap.set({ 'n', 'v' }, '<leader>ccr', ':<C-u>CopilotChatReview<cr>', { desc = 'Copilot Chat: [R]eview selection' })
vim.keymap.set({ 'n', 'v' }, '<leader>ccf', ':<C-u>CopilotChatFix<cr>', { desc = 'Copilot Chat: [F]ix selection' })
vim.keymap.set({ 'n', 'v' }, '<leader>cco', ':<C-u>CopilotChatOptimize<cr>', { desc = 'Copilot Chat: [O]ptimize selection' })

-- Free-form question about the current selection / buffer. <Esc> first so the
-- '< / '> marks are set before the prompt is sent.
vim.keymap.set({ 'n', 'v' }, '<leader>ccq', function()
  vim.cmd 'normal! \27' -- <Esc>: leave Visual mode so selection marks are set
  local input = vim.fn.input 'Ask Copilot: '
  if input ~= '' then
    require('CopilotChat').ask(input)
  end
end, { desc = 'Copilot Chat: [Q]uestion (ask)' })
