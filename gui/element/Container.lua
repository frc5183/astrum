-- Imports
local class = require "lib.external.class"
local Base = require "lib.gui.element.Base"
---@class Container : Base
---@field x number
---@field y number
---@field width integer
---@field height integer
---@field twidth integer
---@field theight integer
---@field posx number
---@field posy number
---@field color Color
---@field canvas love.Canvas
---@field adapter fun(pt:Point2D, button:number, presses:number):Point2D, number, number
---@field widthbar ScrollBar
---@field heightbar ScrollBar
local Container = class("Container", Base)
local ScrollBar = require "lib.gui.element.ScrollBar"
local safety = require "lib.safety"
local math2 = require "lib.math2"
local color = require "lib.gui.color"
--- A Container holds and scrolls other Base objects, including other Containers
--- If twidth or theight are larger than their counterparts, it allows the Container to scroll in that direction and adds a Scrollbar accordingly.
--- Containers sizes are one and done, they CANNOT be resized.
---@param x number
---@param y number
---@param width integer
---@param height integer
---@param color Color
---@param twidth integer
---@param theight integer
function Container:initialize(x, y, width, height, color, twidth, theight)
  safety.ensureNumber(x, "x")
  safety.ensureNumber(y, "y")
  safety.ensureIntegerOver(width, 0, "width")
  safety.ensureIntegerOver(height, 0, "height")
  safety.ensureIntegerOver(twidth, 0, "width")
  safety.ensureIntegerOver(theight, 0, "height")
  safety.ensureColor(color, "color")
  self.canvas = love.graphics.newCanvas(twidth, theight)
  self.posx = 0
  self.posy = 0
  self.x = x
  self.y = y
  self.twidth = twidth
  self.theight = theight
  self.width = width
  self.height = height
  self.color = color
  if (twidth < width) then
    error("twidth must be at least width")
  end
  if (theight < height) then
    error("theight must be at least height")
  end

  self.adapter = function(pt, button, presses)
    local x, y = pt.x, pt.y
    if (x < self.x or x > self.x + self.width or y < self.y or y > self.y + self.height) then
      return math2.Point2D(-1, -1), button, presses
    end
    x = x - self.x + self.posx
    y = y - self.y + self.posy
    return math2.Point2D(x, y), button, presses
  end
  self.objects = {}
  if (twidth > width) then
    self.widthbar = ScrollBar(0, height - 20, width, 20, width / twidth, self.color, false)
    self.widthbar:enable()
  end
  if (theight > height) then
    self.heightbar = ScrollBar(width - 20, 0, 20, height, height / theight, self.color, true)
    self.heightbar:enable()
  end
end

function Container:draw()
  local oldCanvas = love.graphics.getCanvas()
  love.graphics.setCanvas(self.canvas)
  love.graphics.clear()
  local ox, oy, owidth, oheight = love.graphics.getScissor()
  love.graphics.setScissor(self.posx, self.posy, self.width, self.height)
  ---@param k integer
  ---@param v Base
  for k, v in pairs(self.objects) do
    v:draw()
  end
  love.graphics.setCanvas(oldCanvas)
  love.graphics.setScissor(ox, oy, owidth, oheight)
  love.graphics.draw(self.canvas, self.x - self.posx, self.y - self.posy)
  if self.widthbar then self.widthbar:draw() end
  if self.heightbar then self.heightbar:draw() end
end

---@param dt number
---@param pt Point2D
function Container:update(dt, pt)
  local pt_ = self.adapter(pt, 1, 1)
  ---@param k integer
  ---@param v Base
  for k, v in pairs(self.objects) do
    v:update(dt, pt_)
  end
  if (self.widthbar) then
    self.widthbar:update(dt, pt)
    self.posx = (self.twidth - self.width) * self.widthbar:getPosition()
  end
  if (self.heightbar) then
    self.heightbar:update(dt, pt)
    self.posy = (self.theight - self.height) * self.heightbar:getPosition()
  end
end

---@param text string
function Container:textinput(text)
  ---@param k integer
  ---@param v Base
  for k, v in pairs(self.objects) do
    v:textinput(text)
  end
end

---@param key string
---@param scancode string
---@param isrepeat boolean
function Container:keypressed(key, scancode, isrepeat)
  ---@param k integer
  ---@param v Base
  for k, v in pairs(self.objects) do
    v:keypressed(key, scancode, isrepeat)
  end
end

---@param dx number
---@param dy number
---@param x number
---@param y number
function Container:wheelmoved(dx, dy, x, y)
  local pt, _a, _b = self.adapter(math2.Point2D(x, y), 1, 1)
  ---@param k integer
  ---@param v Base
  for k, v in pairs(self.objects) do
    v:wheelmoved(dx, dy, pt.x, pt.y)
  end
end

---@param x number
---@param y number
---@param dx number
---@param dy number
---@param istouch boolean
function Container:mousemoved(x, y, dx, dy, istouch)
  local pt = self.adapter(math2.Point2D(x, y), 1, 1)
  ---@param k integer
  ---@param v Base
  for k, v in pairs(self.objects) do
    v:mousemoved(x, y, dx, dy, istouch)
  end
end

---@param pt Point2D
---@param button number
---@param presses number
---@param ... any
function Container:press(pt, button, presses, ...)
  if (self.heightbar) then
    self.heightbar:press(pt, button, presses, ...)
  end
  if (self.widthbar) then
    self.widthbar:press(pt, button, presses, ...)
  end
  local pt = self.adapter(pt, 1, 1)
  safety.ensurePoint2D(pt, "pt")
  safety.ensureNumber(button, "button")
  safety.ensureNumber(presses, "presses")
  ---@param k integer
  ---@param v Base
  for k, v in pairs(self.objects) do
    v:press(pt, button, presses, ...)
  end
end

---@param pt Point2D
---@param button number
---@param presses number
---@param ... any
function Container:click(pt, button, presses, ...)
  if (self.heightbar) then
    self.heightbar:click(pt, button, presses, ...)
  end
  if (self.widthbar) then
    self.widthbar:click(pt, button, presses, ...)
  end
  local pt = self.adapter(pt, 1, 1)
  safety.ensurePoint2D(pt, "pt")
  safety.ensureNumber(button, "button")
  safety.ensureNumber(presses, "presses")
  ---@param k integer
  ---@param v Base
  for k, v in pairs(self.objects) do
    v:click(pt, button, presses, ...)
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
