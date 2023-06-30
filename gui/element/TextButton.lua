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
function TextButton:initialize(x, y, width, height, color, text, fontsize, align)
  safety.ensureNumber(x, "x")
  safety.ensureNumber(y, "y")
  safety.ensureNumberOver(width, 0, "width")
  safety.ensureNumberOver(height, 0, "height")
  safety.ensureColor(color, "color")
  safety.ensureString(text, "text")
  safety.ensureIntegerOver(fontsize, 0, "fontsize")
  safety.ensureString(align, "align")
  self:initButton(x, y, width, height)
  self:initRectangle(x, y, width, height, color)
  self:initText(x, y, width, height, text, fontsize, align)
  self:initScaler()
end

function TextButton:draw()
  self:drawRectangle()
  self:drawText()
end

function TextButton:update(dt, pt)
  safety.ensureNumber(dt, "dt")
  safety.ensurePoint2D(pt, "pt")
  self:updateScaler(dt, pt)
end

return TextButton