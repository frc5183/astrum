-- Imports
---@class Rectangle
---@field x number
---@field y number
---@field width integer
---@field height integer
---@field sx number
---@field sy number
---@field rectangleCanvas love.Canvas
---@field color Color
---@field int_color Color
local rectangle = {}
local safety = require "lib.safety"
local flux = require "lib.external.flux"
local Color = require "lib.gui.color"
--- Rectangle is an easy to use dynamic Drawable
-- @param x the x positon
-- @param y the y position
-- @param width the rectangle width
-- @param heigh the rectangle height
-- @param color the rectangle color
-- @param int_color the rectangle internal color, nullable
function rectangle:initRectangle(x, y, width, height, color, int_color)
  safety.ensureNumber(x, "x")
  safety.ensureNumber(y, "y")
  safety.ensureNumberOver(width, 0, "width")
  safety.ensureNumberOver(height, 0, "height")
  safety.ensureColor(color, "color")
  if int_color ~= nil then
    safety.ensureColor(int_color, "int_color")
    self.int_color = int_color
  else
    self.int_color = color
  end
  self.rectangleCanvas = love.graphics.newCanvas(width, height)
  if (int_color == nil) then
    self.color = Color(color.r * 0.5, color.g * 0.5, color.b * 0.5, color.a)
  else
    self.color = color
  end
  self.sx = 1
  self.sy = 1
end

--- Draws the rectangle
function rectangle:drawRectangle()
  ---@type love.Canvas
  local oldCanvas = love.graphics.getCanvas()
  ---@type table
  local oldScissor = { love.graphics.getScissor() }
  ---@type table
  local oldColor = { love.graphics.getColor() }
  ---@type number
  local oldLineWidth = love.graphics.getLineWidth()
  love.graphics.setCanvas(self.rectangleCanvas)
  love.graphics.clear()
  love.graphics.setScissor(unpack(oldScissor))

  love.graphics.setColor(self.int_color:unpack())
  love.graphics.setLineWidth(math.min(self.width / 8, self.height / 8))
  love.graphics.rectangle("fill", 0, 0, self.width, self.height,
    math.min(self.width / 8, self.height / 8),
    math.min(self.width / 8, self.height / 8))
  love.graphics.setColor(self.color:unpack())
  love.graphics.rectangle("line", math.min(self.width / 8, self.height / 8) / 2,
    math.min(self.width / 8, self.height / 8) / 2,
    self.width - math.min(self.width / 8, self.height / 8),
    self.height -
    math.min(self.width / 8, self.height / 8),
    math.min(self.width / 8, self.height / 8) * 0.45,
    math.min(self.width / 8, self.height / 8) * 0.45)

  love.graphics.setLineWidth(oldLineWidth)
  love.graphics.setCanvas(oldCanvas)
  love.graphics.setColor(unpack(oldColor))
  love.graphics.push()
  love.graphics.translate(self.x + (self.width / 2), self.y + (self.height / 2))
  love.graphics.scale(self.sx, self.sy)
  love.graphics
      .draw(self.rectangleCanvas, -(self.width / 2), -(self.height / 2))
  love.graphics.pop()
end

-- Return
return rectangle
