-- Imports
local fontCache = {}
---@module 'lib.safety'
local safety = require "lib.safety"
--- Returns a cached font, or if unavailable, creates the font and adds it to the cache.
--- Used to prevent overuse of font creation
---@param num number
---@return love.Font
function fontCache:getFont(num)
  safety.ensureNumber(num, "num")
  if (not fontCache[num]) then fontCache[num] = love.graphics.newFont(num) end
  return fontCache[num]
end

-- Return
return fontCache
