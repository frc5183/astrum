-- Imports
local class = require "lib.external.class"
local Button = require "lib.gui.mixin.Button"
local Rectangle = require "lib.gui.mixin.RoundRectangle"
local safety = require "lib.safety"
local Base = require "lib.gui.element.Base"
---@class VisualButton : Base, Button, Rectangle
---@overload fun(x:number, y:number, width:number, height:number, color:Color):VisualButton
local VisualButton = class("VisualButton", Base)
VisualButton:include(Button)
VisualButton:include(Rectangle)
--- A visual button is an implentation of Button than contains a Rectangle as a background
---@param x number
---@param y number
---@param width integer
---@param height integer
---@param color Color
function VisualButton:initialize(x, y, width, height, color)
  safety.ensureNumber(x, "x")
  safety.ensureNumber(y, "y")
  safety.ensureNumberOver(width, 0, "width")
  safety.ensureNumberOver(height, 0, "height")
  safety.ensureColor(color, "color")
  self:initButton(x, y, width, height)
  self:initRectangle(x, y, width, height, color)
end

--- Draws the VisualButton
function VisualButton:draw()
  self:drawRectangle()
end

return VisualButton
