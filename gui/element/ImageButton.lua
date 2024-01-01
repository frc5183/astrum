---@module 'lib.external.class'
local class = require 'lib.external.class'
---@module 'lib.gui.mixin.Button'
local Button = require 'lib.gui.mixin.Button'
---@module 'lib.safety'
local safety = require 'lib.safety'
---@module 'lib.gui.element.Base'
local Base = require 'lib.gui.element.Base'
---@module 'lib.gui.mixin.Scaler'
local Scaler = require 'lib.gui.mixin.Scaler'
---@module 'lib.math2'
local math2 = require 'lib.math2'
---@class ImageButton : Base, Button, Scaler
---@overload fun(x:number, y:number, image:love.Image, quad:love.Quad|nil, sx:number|nil, sy:number|nil):ImageButton
local ImageButton = class('ImageButton', Base)
ImageButton:include(Button)
ImageButton:include(Scaler)
---@param x number
---@param y number
---@param image love.Image
---@param quad love.Quad|nil
---@param sx number|nil
---@param sy number|nil
function ImageButton:initialize(x, y, image, quad, sx, sy)
  safety.ensureNumber(x, 'x')
  safety.ensureNumber(y, 'y')
  safety.ensureUserdata(image, 'image')
  if quad ~= nil then
    safety.ensureUserdata(quad, 'quad')
    local _, _, w, h = quad:getViewport()
    self.owidth = w
    self.oheight = h
  else
    self.owidth = image:getWidth()
    self.oheight = image:getHeight()
  end
  if sx ~= nil then safety.ensureNumber(sx, 'sx') end
  if sy ~= nil then safety.ensureNumber(sy, 'sy') end
  self.x = x
  self.y = y
  self.osx = sx or 1
  self.osy = sy or 1
  self.sx = 1
  self.sy = 1
  self.image = image
  self.quad = quad
  self:initButton(x, y, self.owidth * sx, self.oheight * sy)
  self:initScaler(x, y, self.owidth * sx, self.oheight * sy)
end
-- Draws the image
function ImageButton:draw()
  love.graphics.push()
  love.graphics.translate(self.x + (self.width / 2), self.y + (self.height / 2))
  love.graphics.scale(self.osx * self.sx, self.osy * self.sy)
  if self.quad ~= nil then
    love.graphics.draw(self.image, self.quad, -(self.owidth / 2),
                       -(self.oheight / 2))
  else
    love.graphics.draw(self.image, -(self.owidth / 2), -(self.oheight / 2))
  end
  love.graphics.pop()
end
---@param dt number
---@param pt Point2D
function ImageButton:update(dt, pt)
  safety.ensureNumber(dt)
  safety.ensurePoint2D(pt)
  self:updateScaler(dt, pt)
end
-- Return
return ImageButton
