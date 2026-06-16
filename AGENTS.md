# AGENTS.md — AI Assistant Instructions for this Repository

## Overview

This is a personal Neovim configuration based on [kickstart.nvim](https://github.com/nvim-lua/kickstart.nvim).
The structure is intentionally split to allow easy upstream merges from kickstart.

---

## Critical Rule: Do NOT modify `init.lua`

`init.lua` tracks upstream kickstart.nvim. It must remain as close to upstream as possible so that
`git merge` or `git rebase` from the kickstart repository stays clean with minimal conflicts.

**Do not add, remove, or edit anything in `init.lua`.**

All personal configuration belongs in `lua/custom/`.

---

## Where to Put Things

| What you want to do | Where it goes |
|---|---|
| Enable a new LSP server | `lua/custom/lsp.lua` |
| Add a new plugin | `lua/custom/plugins/<name>.lua` |
| Add keymaps | `lua/custom/keymaps.lua` |
| Add autocommands | `lua/custom/autocmds.lua` |
| Change Neovim options | `lua/custom/options.lua` |
| Enable/disable optional kickstart plugins | `lua/custom/config.lua` |

New files in `lua/custom/plugins/` are loaded automatically — no registration needed.

---

## Adding a New LSP Server

Follow the pattern in `lua/custom/lsp.lua`:

```lua
vim.lsp.config('server_name', {})
vim.lsp.enable('server_name')
mason_ensure_installed 'server_name'  -- uses the helper defined at the top of lsp.lua
```

---

## Installing Tools via Mason

Use the Mason registry pattern (established in `lua/custom/lsp.lua`) rather than modifying
the `ensure_installed` list in `init.lua`:

```lua
vim.schedule(function()
  local ok, registry = pcall(require, 'mason-registry')
  if not ok then return end
  registry.refresh(function()
    if not registry.is_installed 'tool-name' then
      local pkg = registry.get_package 'tool-name'
      if pkg then pkg:install() end
    end
  end)
end)
```

---

## Adding Plugins

Create a new file in `lua/custom/plugins/`:

```lua
-- lua/custom/plugins/my-plugin.lua
vim.pack.add { 'https://github.com/author/plugin-name' }
require('plugin-name').setup { ... }
```

`vim.pack` is the built-in Neovim plugin manager (not lazy.nvim).

---

## Extending Existing Plugin Config

Some plugins (like `conform.nvim`) support multiple `setup()` calls that merge safely.
Call `require('plugin').setup { ... }` in a custom file to extend the config set in `init.lua`.
