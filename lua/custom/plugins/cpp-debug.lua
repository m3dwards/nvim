-- lua/custom/plugins/cpp-debug.lua
-- C/C++ debugging via codelldb.
-- nvim-dap and nvim-dap-ui are already configured by kickstart.plugins.debug,
-- so we only need to register the codelldb adapter and C/C++ configurations.

-- Ensure codelldb is installed via Mason
vim.schedule(function()
  local ok, registry = pcall(require, 'mason-registry')
  if not ok then return end
  registry.refresh(function()
    if not registry.is_installed 'codelldb' then
      local pkg = registry.get_package 'codelldb'
      if pkg then pkg:install() end
    end
  end)
end)

-- Register the codelldb adapter and C/C++ DAP configurations once dap is available
vim.schedule(function()
  local ok, dap = pcall(require, 'dap')
  if not ok then return end

  local mason_data = vim.fn.stdpath 'data' .. '/mason/packages/codelldb'
  dap.adapters.codelldb = {
    type = 'server',
    port = '${port}',
    executable = {
      command = mason_data .. '/codelldb',
      args = { '--port', '${port}' },
    },
  }

  local cpp_config = {
    {
      name = 'Launch (codelldb)',
      type = 'codelldb',
      request = 'launch',
      program = function()
        return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
      end,
      cwd = '${workspaceFolder}',
      stopOnEntry = false,
      args = {},
    },
    {
      name = 'Attach to process (codelldb)',
      type = 'codelldb',
      request = 'attach',
      pid = function() return require('dap.utils').pick_process() end,
      args = {},
    },
  }

  dap.configurations.cpp = cpp_config
  dap.configurations.c = cpp_config
end)

