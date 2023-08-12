-- Imports
local class = require"lib.external.class"
local VisualButton = require"lib.gui.element.VisualButton"
local safety = require"lib.safety"
local Color = require"lib.gui.color"
local Base = require "lib.gui.element.Base"
local ScrollBar = class("ScrollBar", Base)
local dump = require"lib.dump"
--- A scroll bar can be a vertical or horizontal bar with a dragable button
-- @param x the x position
-- @param y the y position
-- @param width the scroll bar width
-- @param height the scroll bar width
-- @param percentage the scroll bar percentage
-- @param color the scroll bar color
-- @param isVerticle set to true to make it vertical, false for horizontal
-- @return the new ScrollBar
function ScrollBar:initialize(x, y, width, height, percentage, color, isVertical, node)
  safety.ensureNumber(x, "x")
  safety.ensureNumber(y, "y")
  safety.ensureNumberOver(width, 0, "width")
  safety.ensureNumberOver(height, 0, "height")
  safety.ensureColor(color, "color")
  if (node~=nil) then
    safety.ensurePulse(node, "node")
  end
  self.node=node
  self.canvas = love.graphics.newCanvas(width, height)
  self.enabled=false
  self.x=x
  self.y=y
  self.width=width
  self.height=height
  self.isVertical=isVertical
  self.percentage=percentage
  if (isVertical) then
    self.pos=y
    self.button = VisualButton(x, y, width, height*percentage, color, self.node)
  else
    self.pos=x
    self.button = VisualButton(x, y, width*percentage, height, color, self.node)
  end
  self.button:onPress(function (pt, button, presses) 
    if self.enabled and self.button:contains(pt) and button==1 then
      self.startpt=pt
      self.mvpt=pt
      self.opt=pt
      self.dtpt=math.Point2D(0, 0)
    end
  end)
  self.button:onClick(function (pt, button, presses)
    if self.enabled and button==1 then
      self.startpt=nil
      self.mvpt=nil
      self.dtpt=math.Point2D(0, 0)
    end
  end)
  local oldCanvas = love.graphics.getCanvas()
  love.graphics.setCanvas(self.canvas)
  local oldWidth = love.graphics.getLineWidth()
  local oldColor  = {love.graphics.getColor()}
  love.graphics.setColor(color:unpack())
  love.graphics.setLineWidth(10)
  if (isVertical) then
    love.graphics.line(0, 4.5, width, 4.5)
    love.graphics.line(0, height-4.5, width, height-4.5)
    love.graphics.setLineWidth(3)
    love.graphics.line(width/2, 0, width/2, height) 
  else
    love.graphics.line(4.5, 0, 4.5, height)
    love.graphics.line(width-4.5, 0, width-4.5, height)
    love.graphics.setLineWidth(3)
    love.graphics.line(0, height/2, width, height/2)
  end
  love.graphics.setColor(oldColor)
  love.graphics.setLineWidth(oldWidth)
  love.graphics.setCanvas(oldCanvas)
end
--- Returns the percentage the ScrollBar has moved
-- @return the position of the ScrollBar
function ScrollBar:getPosition() 
  if self.isVertical then
    return (self.button.y-self.y)/(self.height-self.button.height)
  else
    return (self.button.x-self.x)/(self.width-self.button.width)
  end
end
function ScrollBar:setPosition(pos)
  safety.ensureNumber(pos)
  if (pos<0 or pos>1) then
    error("pos must be between 0 and 1")
  end
  if self.isVertical then
    self.button.y=self.y+( (self.height-self.button.height)*pos)
  else
    self.button.x=self.x+( (self.width-self.button.width)*pos)
  end
end
--- Draws the ScrollBar
function ScrollBar:draw()
  if self.enabled==true then
    love.graphics.draw(self.canvas, self.x, self.y)
    self.button:draw()
  end
end
--- Ensures that a value is between a lower and upper bound. If it is outside bound, it returns the respective bound, otherwise returns the value
-- @param x the value
-- @param min the minimum value
-- @param max the maximum value
-- @return the clamped value
local function clamp(x, min, max)
  if (x<min) then return min end
  if (x>max) then return max end
  return x
end
--- Updates the ScrollBar
-- @param dt the change in time
-- @param pt the mouse position
function ScrollBar:update(dt, pt)
  if (self.startpt) then
    self.mvpt=pt
    
    self.dtpt = math.Point2D(self.mvpt.x-self.opt.x, self.mvpt.y-self.opt.y)
    if self.isVertical then
      self.button.y=clamp(self.button.y+self.dtpt.y, self.y, self.y+self.height*(1-self.percentage))
    else
      self.button.x=clamp(self.button.x+self.dtpt.x, self.x, self.x+self.width*(1-self.percentage))
    end
    self.opt=pt
  end
  
end
--- Enables the ScrollBar
function ScrollBar:enable()
  self.enabled=true
end
--- Disables the ScrollBar
function ScrollBar:disable()
  self.disabled=true
end
-- Return
return ScrollBar