-- Imports
---@module 'lib.external.class'
local class = require "lib.external.class"
---@module 'lib.gui.mixin.RoundRectangle'
local Rectangle = require "lib.gui.mixin.RoundRectangle"
---@module 'lib.gui.mixin.Text'
local Text = require "lib.gui.mixin.Text"
---@module 'lib.safety'
local safety = require "lib.safety"
---@module 'lib.gui.element.Base'
local Base = require "lib.gui.element.Base"
---@class TextRectangle : Base, Rectangle, Text
---@overload fun(x:number, y:number, width:integer, height:integer, color:Color, text:string, fontsize:number, align:"left"|"center"|"right", textcolor:Color, internalcolor:Color|nil):TextRectangle
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
---@param textcolor Color
---@param internalcolor Color|nil
function TextRectangle:initialize(x, y, width, height, color, text, fontsize,
                                  align, textcolor, internalcolor)
  safety.ensureNumber(x, "x")
  safety.ensureNumber(y, "y")
  safety.ensureNumberOver(width, 0, "width")
  safety.ensureNumberOver(height, 0, "height")
  safety.ensureColor(color, "color")
  safety.ensureString(text, "text")
  safety.ensureIntegerOver(fontsize, 0, "fontsize")
  safety.ensureString(align, "align")
  safety.ensureColor(textcolor, "textcolor")
  if (internalcolor ~= nil) then
    safety.ensureColor(internalcolor, "internalcolor")
  end
  self:initRectangle(x, y, width, height, color, internalcolor)
  self:initText(x, y, width, height, text, fontsize, align, textcolor)
end

--- Draws the TextRectangle
function TextRectangle:draw()
  self:drawRectangle()
  self:drawText()
end

-- Return
return TextRectangle
