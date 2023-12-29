-- Imports
---@class Text
---@field x number
---@field y number
---@field fontsize integer
---@field align "left"|"center"|"right"
---@field width integer
---@field height integer
---@field font love.Font
---@field textCanavas love.Canvas
---@field _text string
---@field sx number
---@field sy number
---@field text love.Text
local Text = {}
---@module 'lib.gui.subsystem.FontCache'
local FontCache = require "lib.gui.subsystem.FontCache"
---@module 'lib.safety'
local safety = require "lib.safety"
---@module 'lib.gui.color'
local Color = require "lib.gui.color"
--- Text initializing function
---@param x number
---@param y number
---@param width integer
---@param height integer
---@param text string
---@param fontsize integer
---@param align "left"|"center"|"right"
---@param color Color
function Text:initText(x, y, width, height, text, fontsize, align, color)
  if (align == nil) then align = "left" end
  if (color == nil) then color = Color(1, 1, 1, 1) end
  safety.ensureNumber(x, "x")
  safety.ensureNumber(y, "y")
  safety.ensureIntegerOver(width, 0, "width")
  safety.ensureIntegerOver(height, 0, "height")
  safety.ensureString(text, "text")
  safety.ensureIntegerOver(fontsize, 0, "fontsize")
  safety.ensureString(align, "align")
  safety.ensureColor(color, "color")
  self.x = x
  self.y = y
  self.fontsize = fontsize
  self.align = align
  self.width = width
  self.height = height
  self.font = FontCache:getFont(fontsize)
  ---@diagnostic disable-next-line: undefined-field
  self.text = love.graphics.newTextBatch(self.font)
  self.textCanvas = love.graphics.newCanvas(self.width - 2 *
                                              math.min(self.width / 8,
                                                       self.height / 8),
                                            math.floor(
                                              (self.height -
                                                (2 *
                                                  math.min(self.width / 8,
                                                           self.height / 8))) /
                                                self.font:getHeight()) *
                                              self.font:getHeight())
  self.text:setf(text,
                 self.width - 2 * math.min(self.width / 8, self.height / 8),
                 self.align)
  self._text = text
  self.sx = self.sx or 1
  self.sy = self.sy or 1
  self.textcolor = color
end

--- Draws the Text
function Text:drawText()
  ---@type love.Canvas
  local oldCanvas = love.graphics.getCanvas()
  local r, g, b, a = love.graphics.getColor()
  love.graphics.setCanvas(self.textCanvas)
  love.graphics.clear()
  love.graphics.setColor(self.textcolor:unpack())
  love.graphics.draw(self.text)

  love.graphics.setCanvas(oldCanvas)
  local oldmode, oldalphamode = love.graphics.getBlendMode()
  love.graphics.setBlendMode("alpha", "premultiplied")
  love.graphics.setColor(r, g, b, a)
  love.graphics.push()
  love.graphics.translate(self.x + (self.width / 2), self.y + (self.height / 2))
  love.graphics.scale(self.sx, self.sy)
  love.graphics.draw(self.textCanvas, -(self.width / 2 -
                       math.min(self.width / 8, self.height / 8)),
                     -(self.height / 2 -
                       math.min(self.width / 8, self.height / 8)))
  love.graphics.setBlendMode(oldmode, oldalphamode)
  love.graphics.pop()
end

--- Changes the Text
---@param text string
function Text:changeText(text)
  safety.ensureString(text)
  self._text = text
  self.text:setf(text, self.width - math.min(self.width / 8, self.height / 8),
                 self.align)
end

--- Gets the text
---@return string
function Text:getText() return self._text end

--- Alias for changeText
---@param text string
function Text:setText(text) self:changeText(text) end

-- Return
return Text
