-- lua/custom/options.lua
-- Personal option overrides applied after all plugins are loaded.

-- Show percentage through document in the statusline (e.g. "42% 12:5")
local statusline = require 'mini.statusline'
---@diagnostic disable-next-line: duplicate-set-field
statusline.section_location = function()
  return '%p%% %2l:%-2v'
end
