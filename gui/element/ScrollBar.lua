local class = require"lib.external.class"
local VisualButton = require"lib.gui.element.VisualButton"
local safety = require"lib.safety"
local Color = require"lib.gui.color"
local ScrollBar = class("ScrollBar")
local dump = require"lib.dump"
function ScrollBar:initialize(x, y, width, height, percentage, color, isVertical)
  safety.ensureNumber(x, "x")
  safety.ensureNumber(y, "y")
  safety.ensureNumberOver(width, 0, "width")
  safety.ensureNumberOver(height, 0, "height")
  safety.ensureColor(color, "color")
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
    self.button = VisualButton(x, y, width, height*percentage, color)
  else
    self.pos=x
    self.button = VisualButton(x, y, width*percentage, height, color)
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


function ScrollBar:draw()
  if self.enabled==true then
    love.graphics.draw(self.canvas, self.x, self.y)
    self.button:draw()
  end
end
local function clamp(x, min, max)
  if (x<min) then return min end
  if (x>max) then return max end
  return x
end
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
function ScrollBar:enable()
  self.enabled=true
end
function ScrollBar:disable()
  self.disabled=true
end
return ScrollBar