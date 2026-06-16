-- lua/custom/lsp.lua
-- Additional LSP server configurations beyond kickstart defaults.

-- Python LSP
vim.lsp.config('pyright', {})
vim.lsp.enable('pyright')

-- Ensure pyright is installed via Mason
vim.schedule(function()
  local ok, registry = pcall(require, 'mason-registry')
  if not ok then return end
  registry.refresh(function()
    if not registry.is_installed 'pyright' then
      local pkg = registry.get_package 'pyright'
      if pkg then pkg:install() end
    end
  end)
end)
