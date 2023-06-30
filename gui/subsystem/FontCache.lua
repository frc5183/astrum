local fontCache={}
local safety=require"lib.safety"
fontCache[12]=love.graphics.newFont(12)
fontCache[14]=love.graphics.newFont(14)
function fontCache:getFont(num)
  safety.ensureNumber(num, "num")
  if (not fontCache[num]) then
    fontCache[num]=love.graphics.newFont(num)
  end
  return fontCache[num]
end

return fontCache