-- lua/custom/plugins/cpp.lua
-- C/C++ formatting with clang-format.

-- Extend conform with C/C++ formatters (conform merges multiple setup calls safely)
require('conform').setup {
  formatters_by_ft = {
    cpp = { 'clang-format' },
    c = { 'clang-format' },
    objcpp = { 'clang-format' },
  },
}

-- Format C/C++ files on save
vim.api.nvim_create_autocmd('BufWritePre', {
  group = vim.api.nvim_create_augroup('custom-cpp-format', { clear = true }),
  pattern = { '*.c', '*.cc', '*.cpp', '*.cxx', '*.h', '*.hh', '*.hpp', '*.hxx' },
  callback = function(args)
    require('conform').format { bufnr = args.buf, timeout_ms = 500 }
  end,
})

-- Ensure clang-format is installed via Mason
vim.schedule(function()
  local ok, registry = pcall(require, 'mason-registry')
  if not ok then return end
  registry.refresh(function()
    if not registry.is_installed 'clang-format' then
      local pkg = registry.get_package 'clang-format'
      if pkg then pkg:install() end
    end
  end)
end)
