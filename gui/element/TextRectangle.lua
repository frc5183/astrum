-- Imports
local class = require "lib.external.class"
local Rectangle = require "lib.gui.mixin.RoundRectangle"
local Text = require "lib.gui.mixin.Text"
local safety = require "lib.safety"
local Base = require "lib.gui.element.Base"
---@class TextRectangle : Base, Rectangle, Text
---@overload fun(x:number, y:number, width:integer, height:integer, color:Color, text:string, fontsize:number, align:"left"|"center"|"right"):TextRectangle
local TextRectangle = class("TextRectangle", Base)
TextRectangle:include(Text)
TextRectangle:include(Rectangle)
--- A Text+Rectangle to allow for a Aethstic text display
---@param x number
---@param y number
---@param width integer
---@param height integer
---@param color Color
---@param text string
---@param fontsize number
---@param align "left"|"center"|"right"
---@param internalcolor Color|nil
function TextRectangle:initialize(x, y, width, height, color, text, fontsize,
                                  align, internalcolor)
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
  self:initRectangle(x, y, width, height, color, internalcolor)
  self:initText(x, y, width, height, text, fontsize, align)
end
--- Draws the TextRectangle
function TextRectangle:draw()
  self:drawRectangle()
  self:drawText()
end
-- Return
return TextRectangle
