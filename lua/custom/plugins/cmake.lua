-- lua/custom/plugins/cmake.lua
-- CMake project integration via cmake-tools.nvim.
-- Provides build, run, configure, and test commands for CMake projects.

vim.pack.add { 'https://github.com/Civitasv/cmake-tools.nvim' }

require('cmake-tools').setup {
  cmake_build_directory = 'build/${variant:buildType}',
  cmake_generate_options = { '-DCMAKE_EXPORT_COMPILE_COMMANDS=ON' },
}

-- Register <leader>cm group with which-key if available
local ok, wk = pcall(require, 'which-key')
if ok then
  wk.add { { '<leader>cm', group = '[C]Make' } }
end

vim.keymap.set('n', '<leader>cmg', '<cmd>CMakeGenerate<cr>', { desc = 'CMake: [G]enerate' })
vim.keymap.set('n', '<leader>cmb', '<cmd>CMakeBuild<cr>', { desc = 'CMake: [B]uild' })
vim.keymap.set('n', '<leader>cmr', '<cmd>CMakeRun<cr>', { desc = 'CMake: [R]un' })
vim.keymap.set('n', '<leader>cmt', '<cmd>CMakeSelectBuildType<cr>', { desc = 'CMake: Select Build [T]ype' })
vim.keymap.set('n', '<leader>cmc', '<cmd>CMakeSelectBuildTarget<cr>', { desc = 'CMake: Select Build [C]onfig' })
vim.keymap.set('n', '<leader>cmd', '<cmd>CMakeDebug<cr>', { desc = 'CMake: [D]ebug' })
vim.keymap.set('n', '<leader>cmx', '<cmd>CMakeClose<cr>', { desc = 'CMake: Close' })
