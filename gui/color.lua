-- Imports
---@module 'lib.external.class'
local Class = require "lib.external.class"
---@class Color
---@field r number
---@field g number
---@field b number
---@field a number
---@overload fun(r:number, g:number, b:number, a:number):Color
local Color = Class("Color")
---@module 'lib.safety'
local safety = require("lib.safety")
--- Tests if two colors are equal
---@param color1 Color
---@param color2 Color
---@return boolean
Color.__eq = function(color1, color2)
  safety.ensureInstanceType(color1, Color, "color1")
  safety.ensureInstanceType(color2, Color, "color2")
  return
    color1.r == color2.r and color1.g == color2.g and color1.b == color2.b and
      color1.a == color2.a
end
--- Converts the color into a string that contains all rgba values
---@param color Color
---@return string
Color.__tostring = function(color)
  return "Color: {" .. color.r .. ", " .. color.g .. ", " .. color.b .. ", " ..
           color.a .. "}"
end
--- A color for Love2D, convienently in Class form
-- @param r number
-- @param g number
-- @param b number
-- @param a number|nil
function Color:initialize(r, g, b, a)
  safety.ensureNumber(r, "r")
  safety.ensureNumber(g, "g")
  safety.ensureNumber(b, "b")
  if a == nil then a = 1 end
  safety.ensureNumber(a, "a")
  self.r = r
  self.g = g
  self.b = b
  self.a = a
end

--- Unpacks the color for use in Love2D functions
-- @return number r
-- @return number g
-- @return number b
-- @return number a
function Color:unpack() return self.r, self.g, self.b, self.a end

--- Ensures that a certain named value is a Color
---@param val any
---@param name string
function safety.ensureColor(val, name)
  safety.ensureInstanceType(val, Color, name)
end

-- Return
return Color
