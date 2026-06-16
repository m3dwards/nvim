-- lua/custom/plugins/telescope.lua
-- Extended telescope configuration: hidden file support and file browser.
-- This overrides the basic telescope setup from init.lua.
-- Note: telescope core plugins are already installed by init.lua.

vim.pack.add { 'https://github.com/nvim-telescope/telescope-file-browser.nvim' }

-- Override setup to add file browser extension and hidden file defaults
require('telescope').setup {
  extensions = {
    ['ui-select'] = {
      require('telescope.themes').get_dropdown(),
    },
    file_browser = {
      theme = 'ivy',
      hijack_netrw = true,
    },
  },
  defaults = {
    vimgrep_arguments = {
      'rg',
      '--color=never',
      '--no-heading',
      '--with-filename',
      '--line-number',
      '--column',
      '--smart-case',
      '--hidden',
      '--glob',
      '!.git/*',
    },
  },
}

pcall(require('telescope').load_extension, 'fzf')
pcall(require('telescope').load_extension, 'ui-select')
require('telescope').load_extension 'file_browser'

-- Find files with <C-h> toggling visibility of hidden/ignored files
local my_find_files
my_find_files = function(opts, no_ignore)
  opts = opts or {}
  no_ignore = vim.F.if_nil(no_ignore, false)
  opts.attach_mappings = function(_, map)
    map({ 'n', 'i' }, '<C-h>', function(prompt_bufnr)
      local prompt = require('telescope.actions.state').get_current_line()
      require('telescope.actions').close(prompt_bufnr)
      no_ignore = not no_ignore
      my_find_files({ default_text = prompt }, no_ignore)
    end)
    return true
  end

  if no_ignore then
    opts.no_ignore = true
    opts.hidden = true
    opts.prompt_title = 'Find Files <ALL>'
    require('telescope.builtin').find_files(opts)
  else
    opts.prompt_title = 'Find Files'
    require('telescope.builtin').find_files(opts)
  end
end

local builtin = require 'telescope.builtin'
vim.keymap.set('n', '<leader>sh', builtin.help_tags, { desc = '[S]earch [H]elp' })
vim.keymap.set('n', '<leader>sk', builtin.keymaps, { desc = '[S]earch [K]eymaps' })
vim.keymap.set('n', '<leader>sf', my_find_files, { desc = '[S]earch [F]iles' })
vim.keymap.set('n', '<leader>sd', ':Telescope file_browser path=%:p:h select_buffer=true<CR>', { desc = '[S]earch [D]irectory' })
vim.keymap.set('n', '<leader>st', ':Telescope file_browser<CR>', { desc = '[S]earch [T]ree' })
vim.keymap.set('n', '<leader>ss', builtin.builtin, { desc = '[S]earch [S]elect Telescope' })
vim.keymap.set({ 'n', 'v' }, '<leader>sw', builtin.grep_string, { desc = '[S]earch current [W]ord' })
vim.keymap.set('n', '<leader>sg', builtin.live_grep, { desc = '[S]earch by [G]rep' })
vim.keymap.set('n', '<leader>sx', builtin.diagnostics, { desc = '[S]earch Diagnostics' })
vim.keymap.set('n', '<leader>sr', builtin.resume, { desc = '[S]earch [R]esume' })
vim.keymap.set('n', '<leader>s.', builtin.oldfiles, { desc = '[S]earch Recent Files ("." for repeat)' })
vim.keymap.set('n', '<leader><leader>', builtin.buffers, { desc = '[ ] Find existing buffers' })

vim.keymap.set('n', '<leader>/', function()
  builtin.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
    winblend = 10,
    previewer = false,
  })
end, { desc = '[/] Fuzzily search in current buffer' })

vim.keymap.set('n', '<leader>s/', function()
  builtin.live_grep {
    grep_open_files = true,
    prompt_title = 'Live Grep in Open Files',
  }
end, { desc = '[S]earch [/] in Open Files' })

vim.keymap.set('n', '<leader>sn', function()
  builtin.find_files { cwd = vim.fn.stdpath 'config', follow = true }
end, { desc = '[S]earch [N]eovim files' })
