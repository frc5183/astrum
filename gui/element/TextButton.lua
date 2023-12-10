-- Imports
local class = require "lib.external.class"
local Button = require "lib.gui.mixin.Button"
local Rectangle = require "lib.gui.mixin.RoundRectangle"
local Text = require "lib.gui.mixin.Text"
local safety = require "lib.safety"
local Scaler = require "lib.gui.mixin.Scaler"
local Base = require "lib.gui.element.Base"
---@class TextButton : Base, Text, Scaler, Button, Rectangle
---@overload fun(x:number, y:number, width:integer, height:integer, color:Color, text:string, fontsize:number, align:"left"|"center"|"right"):TextButton
local TextButton = class("TextButton", Base)
TextButton:include(Button)
TextButton:include(Rectangle)
TextButton:include(Text)
TextButton:include(Scaler)
--- A Button implentation that also includes a Text+Rectangle to allow for a Text Visual Button
---@param x number
---@param y number
---@param width integer
---@param height integer
---@param color Color
---@param text string
---@param fontsize number
---@param align "left"|"center"|"right"
---@param internalcolor Color|nil
function TextButton:initialize(x, y, width, height, color, text, fontsize, align, internalcolor)
  safety.ensureNumber(x, "x")
  safety.ensureNumber(y, "y")
  safety.ensureNumberOver(width, 0, "width")
  safety.ensureNumberOver(height, 0, "height")
  safety.ensureColor(color, "color")
  safety.ensureString(text, "text")
  safety.ensureIntegerOver(fontsize, 0, "fontsize")
  safety.ensureString(align, "align")
  if (internalcolor ~= nil) then
    safety.ensureColor(internalcolor, "internalcolor")
  end
  self:initButton(x, y, width, height)
  self:initRectangle(x, y, width, height, color, internalcolor)
  self:initText(x, y, width, height, text, fontsize, align)
  self:initScaler(x, y, width, height)
end

--- Draws the TextButton
function TextButton:draw()
  self:drawRectangle()
  self:drawText()
end

--- Updates the TextButton. Leave out to disable Scaling
---@param dt number
---@param pt Point2D
function TextButton:update(dt, pt)
  safety.ensureNumber(dt, "dt")
  safety.ensurePoint2D(pt, "pt")
  self:updateScaler(dt, pt)
end

-- Return
return TextButton
