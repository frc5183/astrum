-- Imports
local class=require"lib.external.class"
local Button=require"lib.gui.mixin.Button"
local Rectangle=require"lib.gui.mixin.RoundRectangle"
local safety=require"lib.safety"
local VisualButton=class"VisualButton"
VisualButton:include(Button)
VisualButton:include(Rectangle)
--- A visual button is an implentation of Button than contains a Rectangle as a background
-- @param x the x position
-- @param y the y position
-- @param width the button width
-- @param height the button height
-- @param color the button Color
-- @param node the optional ClickNode
function VisualButton:initialize(x, y, width, height, color, node)
  safety.ensureNumber(x, "x")
  safety.ensureNumber(y, "y")
  safety.ensureNumberOver(width, 0, "width")
  safety.ensureNumberOver(height, 0, "height")
  safety.ensureColor(color, "color")
  self:initButton(x, y, width, height, node)
  self:initRectangle(x, y, width, height, color)
end
function VisualButton:draw()
  self:drawRectangle()
end
function VisualButton:update(dt, pt)
  safety.ensureNumber(dt, "dt")
  safety.ensurePoint2D(pt, "pt")
  self:updateRectangle(dt, pt)
end
return VisualButton