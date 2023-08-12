-- Imports
local class=require"lib.external.class"
local Base = require "lib.gui.element.Base"
local Container = class("Container", Base)
local ClickNode = require"lib.gui.subsystem.ClickNode"
local ClickOrigin = require"lib.gui.subsystem.ClickOrigin"
local ScrollBar = require"lib.gui.element.ScrollBar"
local safety = require"lib.safety"
local math2 = require"lib.math2"
local color = require"lib.gui.color"
--- A Container holds and scrolls other Base objects, including other Containers
-- If twidth or theight are larger than their counterparts, it allows the Container to scroll in that direction and adds a Scrollbar accordingly.
-- Containers sizes are one and done, they CANNOT be resized. 
-- @param x the x position 
-- @param y the y position
-- @param width the Container window width
-- @param height the Container window height
-- @param color the ScrollBar colors (may be unused)
-- @param twidth the true width of the Container, must be equal or Larger than width
-- @param theight the true height of the Container, must be equal or Larger than height
-- @param node the optional ClickNode
-- @return the new Container
function Container:initialize(x, y, width, height, color, twidth, theight, node)
  safety.ensureNumber(x, "x")
  safety.ensureNumber(y, "y")
  safety.ensureNumberOver(width, 0, "width")
  safety.ensureNumberOver(height, 0, "height")
  safety.ensureNumber(twidth, "twidth")
  safety.ensureNumber(theight, "theight")
  safety.ensureColor(color, "color")
  self.canvas = love.graphics.newCanvas(twidth, theight)
  self.posx=0
  self.posy=0
  self.x=x
  self.y=y
  self.twidth=twidth
  self.theight=theight
  self.width=width
  self.height=height
  self.color=color
  if (twidth<width) then
    error("twidth must be at least width")
  end
  if (theight<height) then
    error("theight must be at least height")
  end
  if(node~=nil) then
    safety.ensurePulse(node)
    node = node
  else 
    node=ClickOrigin
  end
  self.adapter= function (pt, button, presses)
    local x, y = pt.x, pt.y
    if (x<self.x or x>self.x+self.width or y<self.y or y>self.y+self.height) then
      return math2.Point2D(-1, -1), button, presses
    end
    x= x-self.x+self.posx
    y =y-self.y+self.posy
    return math2.Point2D(x, y), button, presses
  end
  self.node = ClickNode(node, self.adapter)
  self.objects={}
  if (twidth>width) then
    self.widthbar = ScrollBar(0, height-20, width, 20, width/twidth, self.color, false, node)
    self.widthbar:enable()
  end
  if (theight>height) then
    self.heightbar = ScrollBar(width-20, 0, 20, height, height/theight, self.color, true, node)
    self.heightbar:enable()
  end
end
--- Used to get the Container's Node
-- Should be used for every Base this Container should hold
function Container:getNode()
  return self.node
end
--- Draws all Container Objects
function Container:draw()
  local oldCanvas = love.graphics.getCanvas()
  love.graphics.setCanvas(self.canvas)
  love.graphics.clear()
  local ox, oy, owidth, oheight= love.graphics.getScissor()
  love.graphics.setScissor(self.posx, self.posy, self.width, self.height)
  for k, v in pairs(self.objects) do
    v:draw()
  end
  love.graphics.setCanvas(oldCanvas)
  love.graphics.setScissor(ox, oy, owidth, oheight)
  love.graphics.draw(self.canvas, self.x-self.posx, self.y-self.posy)
  if self.widthbar then self.widthbar:draw() end
  if self.heightbar then self.heightbar:draw() end
end
--- Updates all Container objects
-- @param dt the delta time change
-- @param pt the mouse position
function Container:update(dt, pt)
  local pt_=self.adapter(pt, nil, nil)
  for k, v in pairs(self.objects) do
    v:update(dt, pt_)
  end
  if (self.widthbar) then self.widthbar:update(dt, pt) self.posx = (self.twidth-self.width)*self.widthbar:getPosition() end
  if (self.heightbar) then self.heightbar:update(dt, pt) self.posy = (self.theight-self.height)*self.heightbar:getPosition() end
  
end
--- The textinput callback for all Container objects
-- @param text the text input
function Container:textinput(text)
  for k, v in pairs(self.objects) do
    v:textinput(text)
  end
end
--- The KeyPressed callback for all Container objects
-- @param key the pressed key
-- @param scancode the key scancode
-- @param isRepeat whether it is a repeat press
function Container:keypressed(key, scancode, isRepeat)
  for k, v in pairs(self.objects) do
    v:keypressed(key, scancode, isRepeat)
  end
end
--- The wheelmoved callback for all Container objects
-- @param dx the change in x
-- @param dy the change in y
-- @param x the x position of the mouse
-- @param y the y position of the mouse
function Container:wheelmoved(dx, dy, x, y)
  local pt, _a, _b = self.adapter(math2.Point2D(x, y), nil, nil)
  for k, v in pairs(self.objects) do
    v:wheelmoved(dx, dy, pt.x, pt.y)
  end
end
--- The mousemoved callback for all Container objects
-- @param x the x position of the mouse
-- @param y the y position of the mouse
function Container:mousemoved(x, y)
  local pt = self.adapter(math2.Point2D(x, y), nil, nil)
  for k, v in pairs(self.objects) do
    v:wheelmoved(x, y)
  end
end
--- Adds a new Base to the Container
-- @param new the new Base to add
function Container:add(new)
  safety.ensureInstanceType(new, Base, "new")
  table.insert(self.objects, new)
end
-- Return
return Container
  