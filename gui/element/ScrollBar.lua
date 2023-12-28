-- Imports
local class = require "lib.external.class"
local VisualButton = require "lib.gui.element.VisualButton"
local safety = require "lib.safety"
local Color = require "lib.gui.color"
local math2 = require "lib.math2"
local Base = require "lib.gui.element.Base"
---@class ScrollBar : Base
---@field canvas love.Canvas
---@field x number
---@field y number
---@field width integer
---@field height integer
---@field isVertical boolean
---@field enabled boolean
---@field percentage number
---@field pos number
---@field button VisualButton
---@field startpt Point2D|nil
---@field mvpt Point2D|nil
---@field dtpt Point2D|nil
---@field opt Point2D|nil
---@overload fun(x:number, y:number, height:integer, width:integer, percentage:number, color:Color, isVertical:boolean):ScrollBar
local ScrollBar = class("ScrollBar", Base)
--- A scroll bar can be a vertical or horizontal bar with a dragable button
---@param x number
---@param y number
---@param height integer
---@param width integer
---@param percentage number
---@param color Color
---@param isVertical boolean
function ScrollBar:initialize(x, y, width, height, percentage, color, isVertical)
  safety.ensureNumber(x, "x")
  safety.ensureNumber(y, "y")
  safety.ensureNumberOver(width, 0, "width")
  safety.ensureNumberOver(height, 0, "height")
  safety.ensureColor(color, "color")
  self.canvas = love.graphics.newCanvas(width, height)
  self.enabled = false
  self.x = x
  self.y = y
  self.width = width
  self.height = height
  self.isVertical = isVertical
  self.percentage = percentage
  if (isVertical) then
    self.pos = y
    self.button = VisualButton(x, y, width, height * percentage, color)
  else
    self.pos = x
    self.button = VisualButton(x, y, width * percentage, height, color)
  end
  self.button:onPress(function(pt, button, presses)
    if self.enabled and self.button:contains(pt) and button == 1 then
      self.startpt = pt
      self.mvpt = pt
      self.opt = pt
      self.dtpt = math2.Point2D(0, 0)
    end
  end)
  self.button:onClick(function(pt, button, presses)
    if self.enabled and button == 1 then
      self.startpt = nil
      self.mvpt = nil
      self.dtpt = math2.Point2D(0, 0)
    end
  end)
  ---@type love.Canvas
  local oldCanvas = love.graphics.getCanvas()
  love.graphics.setCanvas(self.canvas)
  ---@type integer
  local oldWidth = love.graphics.getLineWidth()
  ---@type table
  local oldColor = {love.graphics.getColor()}
  love.graphics.setColor(color:unpack())
  love.graphics.setLineWidth(10)
  if (isVertical) then
    love.graphics.line(0, 4.5, width, 4.5)
    love.graphics.line(0, height - 4.5, width, height - 4.5)
    love.graphics.setLineWidth(3)
    love.graphics.line(width / 2, 0, width / 2, height)
  else
    love.graphics.line(4.5, 0, 4.5, height)
    love.graphics.line(width - 4.5, 0, width - 4.5, height)
    love.graphics.setLineWidth(3)
    love.graphics.line(0, height / 2, width, height / 2)
  end
  love.graphics.setColor(oldColor)
  love.graphics.setLineWidth(oldWidth)
  love.graphics.setCanvas(oldCanvas)
end

--- Returns the percentage the ScrollBar has moved
---@return number
function ScrollBar:getPosition()
  if self.isVertical then
    return (self.button.y - self.y) / (self.height - self.button.height)
  else
    return (self.button.x - self.x) / (self.width - self.button.width)
  end
end

--- Sets the amount the ScrollBar has moved by percentage
---@param pos number
function ScrollBar:setPosition(pos)
  safety.ensureNumber(pos)
  if (pos < 0 or pos > 1) then error("pos must be between 0 and 1") end
  if self.isVertical then
    self.button.y = self.y + ((self.height - self.button.height) * pos)
  else
    self.button.x = self.x + ((self.width - self.button.width) * pos)
  end
end

--- Draws the ScrollBar
function ScrollBar:draw()
  if self.enabled == true then
    local oldmode, oldalphamode = love.graphics.getBlendMode()
    love.graphics.setBlendMode("alpha", "premultiplied")
    love.graphics.draw(self.canvas, self.x, self.y)
    love.graphics.setBlendMode(oldmode, oldalphamode)
    self.button:draw()
  end
end

--- Ensures that a value is between a lower and upper bound. If it is outside bound, it returns the respective bound, otherwise returns the value
---@param x number
---@param min number
---@param max number
---@return number
local function clamp(x, min, max)
  if (x < min) then return min end
  if (x > max) then return max end
  return x
end
--- Updates the ScrollBar
-- @param dt the change in time
-- @param pt the mouse position
function ScrollBar:update(dt, pt)
  if (self.startpt) then
    self.mvpt = pt

    self.dtpt =
      math2.Point2D(self.mvpt.x - self.opt.x, self.mvpt.y - self.opt.y)
    if self.isVertical then
      self.button.y = clamp(self.button.y + self.dtpt.y, self.y,
                            self.y + self.height * (1 - self.percentage))
    else
      self.button.x = clamp(self.button.x + self.dtpt.x, self.x,
                            self.x + self.width * (1 - self.percentage))
    end
    self.opt = pt
  end
end

--- Enables the ScrollBar
function ScrollBar:enable() self.enabled = true end

function ScrollBar:click(pt, button, presses, ...)
  if (self.enabled) then self.button:click(pt, button, presses, ...) end
end

function ScrollBar:press(pt, button, presses, ...)
  if (self.enabled) then self.button:press(pt, button, presses, ...) end
end

--- Disables the ScrollBar
function ScrollBar:disable() self.disabled = true end

-- Return
return ScrollBar
