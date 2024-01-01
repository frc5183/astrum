-- Imports
---@module 'lib.external.class'
local class = require "lib.external.class"
---@module 'lib.safety'
local safety = require "lib.safety"
---@module 'lib.gui.element.Base'
local Base = require "lib.gui.element.Base"
---@module 'lib.gui.element.Batcher'
local Batcher = require "lib.gui.element.Batcher"
---@class BatchedImage : Base
---@overload fun(x:number, y:number, batcher:Batcher, quad:love.Quad|nil, sx:number|nil, sy:number|nil):BatchedImage
local BatchedImage = class("BatchedImage", Base)
---@param x number
---@param y number
---@param batcher Batcher
---@param quad love.Quad|nil
---@param sx number|nil
---@param sy number|nil
function BatchedImage:initialize(x, y, batcher, quad, sx, sy)
  safety.ensureNumber(x, "x")
  safety.ensureNumber(y, "y")
  safety.ensureBatcher(batcher, "batcher")
  if (quad ~= nil) then safety.ensureUserdata(quad, "quad") end
  if (sx ~= nil) then safety.ensureNumber(sx, "sx") end
  if (sy ~= nil) then safety.ensureNumber(sy, "sy") end
  self.x = x
  self.y = y
  self.sx = sx or 1
  self.sy = sy or 1
  self.quad = quad
  self.batcher = batcher
  if (self.quad) then
    self.id = batcher:add(x, y, nil, self.sx, self.sy, nil, nil, nil, nil, quad)
  else
    self.id = batcher:add(x, y, nil, self.sx, self.sy)
  end
end
---@param x number|nil
---@param y number|nil
---@param quad love.Quad|nil
---@param sx number|nil
---@param sy number|nil
function BatchedImage:replace(x, y, quad, sx, sy)
  local x = x or self.x
  local y = y or self.y
  local quad = quad or self.quad
  local sx = sx or self.sx
  local sy = sy or self.sy
  if (quad) then
    self.batcher:set(self.id, x, y, nil, sx, sy, nil, nil, nil, nil, quad)
    self.quad = quad
  else
    self.batcher:set(self.id, x, y, nil, sx, sy)
  end
end
--- Removes the batched image from the batcher, although it can still be returned as it cannot truly be removed
function BatchedImage:remove() self.batcher:remove(self.id) end

-- Return
return BatchedImage
