-- Imports
local Class = require"lib.external.class"
local Color = Class("Color")
local safety = require("lib.safety")
--- Tests if two colors are equal
-- @param color1 the first color
-- @param color2 thr second color
-- @return whether the colors are equal
Color.__eq = function (color1, color)
  safety.ensureInstanceType(color1, Color, "color1")
  safety.ensureInstanceType(color2, Color, "color2")
  return color1.r==color2.r and color1.g==color2.g and color1.b==color2.b and color1.a==color2.a
end
--- Converts the color into a string that contains all rgba values 
-- @param color the color to convert
-- @return the new String
Color.__tostring = function (color)
  return "Color: {" .. color.r .. ", " .. color.g .. ", " .. color.b .. ", " .. color.a .. "}"
end
--- A color for Love2D, convienently in Class form
-- @param r the red value
-- @param g the green value
-- @param b the blue value
-- @param a the alpha value
-- @return the new Color instance
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
--- Unpacks the color for use in Love2D functions
-- @return r the red value
-- @return g the green value
-- @return b the blue value
-- @return a the alpha value
function Color:unpack()
  return self.r, self.g, self.b, self.a
end
--- Ensures that a certain named value is a Color
-- @param val the value to be evaluated
-- @param name the optional name of the value
function safety.ensureColor(val, name)
  safety.ensureInstanceType(val, Color, name)
end
-- Return
return Color