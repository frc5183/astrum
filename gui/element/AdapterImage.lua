local Base = require "lib.gui.element.Base"
local safety = require "lib.safety"
local class = require "lib.external.class"
---@class AdapterImage : Base
---@overload fun(x:number, y:number, image:love.Image, quad:love.Quad|nil, sx:number|nil, sy:number|nil):AdapterImage
local AdapterImage = class("AdapterImage", Base)
---@param x number
---@param y number
---@param image love.Image
---@param quad love.Quad|nil
---@param sx number|nil
---@param sy number|nil
function AdapterImage:initialize(x, y, image, quad, sx, sy)
  safety.ensureNumber(x, "x")
  safety.ensureNumber(y, "y")
  safety.ensureUserdata(image, "image")
  if (quad ~= nil) then
    safety.ensureUserdata(quad, "quad")
    local _, _, w, h = quad:getViewport()
    self.width = w
    self.height = h
  else
    self.width = image:getWidth()
    self.height = image:getHeight()
  end
  if (sx ~= nil) then safety.ensureNumber(sx, "sx") end
  if (sy ~= nil) then safety.ensureNumber(sy, "sy") end
  self.x = x
  self.y = y
  self.sx = sx or 1
  self.sy = sy or 1
  self.image = image
  self.quad = quad
end
-- Draws the image
function AdapterImage:draw()
  love.graphics.push()
  love.graphics.translate(self.x + (self.width * self.sx / 2),
                          self.y + (self.height * self.sy / 2))
  love.graphics.scale(self.sx, self.sy)
  if (self.quad ~= nil) then
    love.graphics.draw(self.image, self.quad, -(self.width / 2),
                       -(self.height / 2))
  else
    love.graphics.draw(self.image, -(self.width / 2), -(self.height / 2))
  end
  love.graphics.pop()
  love.graphics.rectangle("line", self.x, self.y, self.width * self.sx,
                          self.height * self.sy)
  love.graphics.rectangle("line", 0, 0, self.x, self.y)
end

-- Return
return AdapterImage
