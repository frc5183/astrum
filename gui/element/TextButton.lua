-- Imports
local class=require"lib.external.class"
local Button=require"lib.gui.mixin.Button"
local Rectangle=require"lib.gui.mixin.RoundRectangle"
local Text=require"lib.gui.mixin.Text"
local safety=require"lib.safety"
local Scaler = require"lib.gui.mixin.Scaler"
local TextButton=class"TextButton"
TextButton:include(Button)
TextButton:include(Rectangle)
TextButton:include(Text)
TextButton:include(Scaler)
--- A Button implentation that also includes a Text+Rectangle to allow for a Text Visual Button
-- @param x the x coordinate
-- @param y the y coordinate
-- @param width the button width
-- @param height the button height
-- @param color the button Color
-- @param text the initial text
-- @param fontsize the button font size
-- @param align the text align mode
-- @param node the ClickNode, defaults to ClickOrigin
-- @return the new TextButton
function TextButton:initialize(x, y, width, height, color, text, fontsize, align, node)
  safety.ensureNumber(x, "x")
  safety.ensureNumber(y, "y")
  safety.ensureNumberOver(width, 0, "width")
  safety.ensureNumberOver(height, 0, "height")
  safety.ensureColor(color, "color")
  safety.ensureString(text, "text")
  safety.ensureIntegerOver(fontsize, 0, "fontsize")
  safety.ensureString(align, "align")
  self:initButton(x, y, width, height, node)
  self:initRectangle(x, y, width, height, color)
  self:initText(x, y, width, height, text, fontsize, align)
  self:initScaler()
end
--- Draws the TextButton
function TextButton:draw()
  self:drawRectangle()
  self:drawText()
end
--- Updates the TextButton. Leave out to disable Scaling
-- @param dt the change in time
-- @param the mouse position
function TextButton:update(dt, pt)
  safety.ensureNumber(dt, "dt")
  safety.ensurePoint2D(pt, "pt")
  self:updateScaler(dt, pt)
end
-- Return
return TextButton