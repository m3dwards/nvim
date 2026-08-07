-- lua/custom/lsp.lua
-- Additional LSP server configurations beyond kickstart defaults.

local function mason_ensure_installed(tool)
  vim.schedule(function()
    local ok, registry = pcall(require, 'mason-registry')
    if not ok then return end
    registry.refresh(function()
      if not registry.is_installed(tool) then
        local pkg = registry.get_package(tool)
        if pkg then pkg:install() end
      end
    end)
  end)
end

-- Python LSP
vim.lsp.config('pyright', {})
vim.lsp.enable('pyright')
mason_ensure_installed 'pyright'

-- C/C++ LSP
-- Match the indexer to the toolchain each project builds with.
-- Bitcoin Core builds with Apple clang on macOS, so use Apple's clangd
-- there; everywhere else (incl. Linux) fall back to the default clangd.
local clangd_cmd = (function()
  local default = { 'clangd', '--background-index', '--clang-tidy' }
  if vim.fn.has 'mac' ~= 1 then return default end
  -- Detect which repo we're opening, robust to launch directory.
  local first = vim.fn.argv(0)
  local start = (type(first) == 'string' and first ~= '') and vim.fn.fnamemodify(first, ':p') or vim.uv.cwd()
  local root = vim.fs.root(start, { '.git' }) or vim.uv.cwd()
  if root and vim.fs.basename(root) == 'bitcoin' then return { '/usr/bin/clangd', '--background-index', '--clang-tidy' } end
  return default
end)()

vim.lsp.config('clangd', { cmd = clangd_cmd })
vim.lsp.enable('clangd')
mason_ensure_installed 'clangd'

-- Switch between header and source file (clangd-specific)
vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('custom-clangd-attach', { clear = true }),
  callback = function(event)
    local client = vim.lsp.get_client_by_id(event.data.client_id)
    if not client or client.name ~= 'clangd' then return end
    vim.keymap.set('n', '<leader>ch', function()
      vim.lsp.buf.execute_command { command = 'clangd.switchSourceHeader', arguments = { vim.uri_from_bufnr(0) } }
    end, { buffer = event.buf, desc = 'clangd: Switch [H]eader/Source' })
  end,
})
