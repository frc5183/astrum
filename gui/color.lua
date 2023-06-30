local Class = require"lib.external.class"
local Color = Class("Color")
local safety = require("lib.safety")

Color.__eq = function (color1, color)
  safety.ensureInstanceType(color1, Color, "color1")
  safety.ensureInstanceType(color2, Color, "color2")
  return color1.r==color2.r and color1.g==color2.g and color1.b==color2.b and color1.a==color2.a
end

Color.__tostring = function (color)
  return "Color: {" .. color.r .. ", " .. color.g .. ", " .. color.b .. ", " .. color.a .. "}"
end

function Color:initialize(r, g, b, a)
  safety.ensureNumber(r, "r")
  safety.ensureNumber(g, "g")
  safety.ensureNumber(b, "b")
  if a==nil then a=1 end
  safety.ensureNumber(a, "a")
  self.r=r
  self.g=g
  self.b=b
  self.a=a
end
function Color:unpack()
  return self.r, self.g, self.b, self.a
end
function safety.ensureColor(val, name)
  safety.ensureInstanceType(val, Color, name)
end
return Color