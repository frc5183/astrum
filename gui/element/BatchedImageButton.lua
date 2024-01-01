-- Imports
---@module 'lib.external.class'
local class = require "lib.external.class"
---@module 'lib.safety'
local safety = require "lib.safety"
---@module 'lib.gui.element.Base'
local Base = require "lib.gui.element.Base"
---@module 'lib.gui.element.Batcher'
local Batcher = require "lib.gui.element.Batcher"
---@module 'lib.gui.mixin.Button'
local Button = require "lib.gui.mixin.Button"
---@module 'lib.gui.mixin.Scaler'
local Scaler = require "lib.gui.mixin.Scaler"
---@class BatchedImageButton : Base, Button, Scaler
---@overload fun(x:number, y:number, batcher:Batcher, quad:love.Quad|nil, sx:number|nil, sy:number|nil):BatchedImageButton
local BatchedImageButton = class("BatchedImageButton", Base)
BatchedImageButton:include(Button)
BatchedImageButton:include(Scaler)
---@param x number
---@param y number
---@param batcher Batcher
---@param quad love.Quad|nil
---@param sx number|nil
---@param sy number|nil
function BatchedImageButton:initialize(x, y, batcher, quad, sx, sy)
  safety.ensureNumber(x, "x")
  safety.ensureNumber(y, "y")
  safety.ensureBatcher(batcher, "batcher")
  if (quad ~= nil) then safety.ensureUserdata(quad, "quad") end
  if (sx ~= nil) then safety.ensureNumber(sx, "sx") end
  if (sy ~= nil) then safety.ensureNumber(sy, "sy") end
  self.x = x
  self.y = y
  self.osx = sx or 1
  self.osy = sy or 1
  self.sx = 1
  self.sy = 1
  self._sx = 1
  self._sy = 1
  self.quad = quad
  self.batcher = batcher
  if (self.quad) then
    self.id = batcher:add(x, y, nil, self.osx, self.osy, nil, nil, nil, nil,
                          quad)
    local _x, _y, w, h = self.quad:getViewport()
    self.width, self.height = w * self.osx, h * self.osy
  else
    self.id = batcher:add(x, y, nil, self.osx, self.osy)
    local w, h = self.batcher.batch:getTexture():getDimensions()
    self.width, self.height = w * self.osx, h * self.osy
  end
  self:initButton(x, y, self.width, self.height)
  self:initScaler(x, y, self.width, self.height)
end
---@param x number|nil
---@param y number|nil
---@param quad love.Quad|nil
---@param sx number|nil
---@param sy number|nil
---@param temp boolean|nil
function BatchedImageButton:replace(x, y, quad, sx, sy, temp)
  if (temp == nil) then
    temp = false
  else
    safety.ensureBoolean(temp, "temp")
  end
  local x = x or self.x
  local y = y or self.y
  local quad = quad or self.quad

  if (quad) then
    self.batcher:set(self.id, x, y, nil, sx, sy, nil, nil, nil, nil, quad)
    self.quad = quad
    local _x, _y, w, h = self.quad:getViewport()
    self.width, self.height = w * self.osx, h * self.osy
  else
    self.batcher:set(self.id, x, y, nil, sx, sy)
    local w, h = self.batcher.batch:getTexture():getDimensions()
    self.width, self.height = w * self.osx, h * self.osy
  end
  if (not temp) then
    self:initButton(x, y, self.width, self.height)
    self:initScaler(x, y, self.width, self.height)
    self.width = self.width / self.osx * sx
    self.height = self.height / self.osy * sy
    self.osx = sx
    self.osy = sy
  end
end
--- Removes the batched image from the batcher, although it can still be returned as it cannot truly be removed
--- Scaler/Button functionality is disabled until it is restored
function BatchedImageButton:remove()
  self.batcher:remove(self.id)
  self:initButton(0, 0, -1, -1)
  self:initScaler(0, 0, -1, -1)
end
---@param dt number
---@param pt Point2D
function BatchedImageButton:update(dt, pt)
  -- print(self.x, self.y)
  safety.ensureNumber(dt)
  safety.ensurePoint2D(pt)
  self:updateScaler(dt, pt)
  if (self._sx ~= self.sx or self._sy ~= self.sy) then
    self:replace(self.x - ((self.sx - 1) * self.width / 2),
                 self.y - ((self.sy - 1) * self.height / 2), nil,
                 self.sx * self.osx, self.sy * self.osy, true)
  end
  self._sx = self.sx
  self._sy = self.sy
end
-- Return
return BatchedImageButton
