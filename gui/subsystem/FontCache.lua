-- Imports
local fontCache={}
local safety=require"lib.safety"
--- Returns a cached font, or if unavailable, creates the font and adds it to the cache.
-- Used to prevent overuse of font creation
-- @param num the font size
-- @return the font with the size specified
function fontCache:getFont(num)
  safety.ensureNumber(num, "num")
  if (not fontCache[num]) then
    fontCache[num]=love.graphics.newFont(num)
  end
  return fontCache[num]
end
-- Return
return fontCache