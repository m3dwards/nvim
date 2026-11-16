-- lua/custom/options.lua
-- Personal option overrides applied after all plugins are loaded.

-- Show percentage through document in the statusline (e.g. "42% 12:5")
local statusline = require 'mini.statusline'
---@diagnostic disable-next-line: duplicate-set-field
statusline.section_location = function()
  return '%p%% %2l:%-2v'
end

-- Clipboard over ssh. This host has no X, no Wayland and no xclip/wl-copy, so
-- `clipboard = 'unnamedplus'` (set in init.lua) routes yanks to a provider that
-- does not exist and they are silently dropped. 'osc52' hands the text to the
-- terminal instead. Guarded so any host with a real clipboard keeps it: macOS
-- keeps pbcopy, an X session keeps xclip.
if vim.fn.has('linux') == 1 and vim.env.DISPLAY == nil and vim.env.WAYLAND_DISPLAY == nil then
  vim.g.clipboard = 'osc52'
end
