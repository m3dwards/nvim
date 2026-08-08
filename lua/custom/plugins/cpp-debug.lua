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

  -- Don't auto-break on C++ throw/catch (avoids stopping in __cxa_throw with no source).
  dap.defaults.fallback.exception_breakpoints = {}

  -- Launch config as a callable table: dap invokes the __call metamethod after
  -- the config is picked (see dap.prepare_config), so the prompts run in a
  -- guaranteed order (executable first, then args) rather than the
  -- non-deterministic order of function-valued fields.
  local launch_codelldb = setmetatable({ name = 'Launch (codelldb)' }, {
    __call = function()
      local program = vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
      local args = vim.split(vim.fn.input 'Args: ', ' ', { trimempty = true })
      return {
        name = 'Launch (codelldb)',
        type = 'codelldb',
        request = 'launch',
        program = program,
        args = args,
        cwd = '${workspaceFolder}',
        stopOnEntry = false,
      }
    end,
  })

  local cpp_config = {
    launch_codelldb,
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

