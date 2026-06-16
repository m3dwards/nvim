-- lua/custom/config.lua
--
-- Personal configuration entry point, loaded at the end of init.lua.
-- Add or remove requires below to enable/disable optional kickstart plugins
-- and your own custom configuration modules.

-- ============================================================
-- OPTIONAL KICKSTART PLUGINS
-- Uncomment/comment lines here to enable/disable them.
-- ============================================================
require 'kickstart.plugins.debug'
require 'kickstart.plugins.indent_line'
require 'kickstart.plugins.lint'
require 'kickstart.plugins.autopairs'
require 'kickstart.plugins.neo-tree'
require 'kickstart.plugins.gitsigns'

-- ============================================================
-- CUSTOM PLUGINS
-- All files in lua/custom/plugins/ are loaded automatically.
-- Add a new .lua file there to add a new plugin.
-- ============================================================
require 'custom.plugins'

-- ============================================================
-- CUSTOM CONFIGURATION
-- Options, keymaps, autocommands, and LSP additions
-- ============================================================
require 'custom.options'
require 'custom.keymaps'
require 'custom.autocmds'
require 'custom.lsp'
