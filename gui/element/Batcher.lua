-- Imports
---@module 'lib.external.class'
local class = require "lib.external.class"
---@module 'lib.safety'
local safety = require "lib.safety"
---@module 'lib.gui.element.Base'
local Base = require "lib.gui.element.Base"
---@class Batcher : Base
---@overload fun(image:love.Image):Batcher
local Batcher = class("Batcher", Base)
--- Batcher is a basic batch wrapper that adapt SpriteBatches into a Base-compatible object
---@param image love.Image
function Batcher:initialize(image)
  safety.ensureUserdata(image, "image")
  self.image = image
  self.batch = love.graphics.newSpriteBatch(image)
end
--- Draws all batched draws
function Batcher:draw() love.graphics.draw(self.batch) end
--- Clears all batched draws
function Batcher:clear() self.batch:clear() end
---@param index integer
---@param x number
---@param y number
---@param r number|nil
---@param sx number|nil
---@param sy number|nil
---@param ox number|nil
---@param oy number|nil
---@param kx number|nil
---@param ky number|nil
---@param quad love.Quad|nil
function Batcher:set(index, x, y, r, sx, sy, ox, oy, kx, ky, quad)
  safety.ensureIntegerOver(index, 0, "index")
  safety.ensureNumber(x, "x")
  safety.ensureNumber(y, "y")
  if (r ~= nil) then safety.ensureNumber(r, "r") end
  if (sx ~= nil) then safety.ensureNumber(sx, "sx") end
  if (sy ~= nil) then safety.ensureNumber(sy, "sy") end
  if (ox ~= nil) then safety.ensureNumber(ox, "ox") end
  if (oy ~= nil) then safety.ensureNumber(oy, "oy") end
  if (kx ~= nil) then safety.ensureNumber(kx, "kx") end
  if (ky ~= nil) then safety.ensureNumber(ky, "ky") end
  if (quad ~= nil) then
    safety.ensureUserdata(quad, "quad")
    self.batch:set(index, quad, x, y, r, sx, sy, ox, oy, kx, ky)
  else
    self.batch:set(index, x, y, r, sx, sy, ox, oy, kx, ky)
  end
end
---@param index integer
function Batcher:remove(index)
  safety.ensureIntegerOver(index, 0, "index")
  self.batch:set(index, 0, 0, 0, 0, 0)
end
---@param x number
---@param y number
---@param r number|nil
---@param sx number|nil
---@param sy number|nil
---@param ox number|nil
---@param oy number|nil
---@param kx number|nil
---@param ky number|nil
---@param quad love.Quad|nil
---@return integer sprite index
function Batcher:add(x, y, r, sx, sy, ox, oy, kx, ky, quad)
  safety.ensureNumber(x, "x")
  safety.ensureNumber(y, "y")
  if (r ~= nil) then safety.ensureNumber(r, "r") end
  if (sx ~= nil) then safety.ensureNumber(sx, "sx") end
  if (sy ~= nil) then safety.ensureNumber(sy, "sy") end
  if (ox ~= nil) then safety.ensureNumber(ox, "ox") end
  if (oy ~= nil) then safety.ensureNumber(oy, "oy") end
  if (kx ~= nil) then safety.ensureNumber(kx, "kx") end
  if (ky ~= nil) then safety.ensureNumber(ky, "ky") end
  if (quad ~= nil) then
    safety.ensureUserdata(quad, "quad")
    return self.batch:add(quad, x, y, r, sx, sy, ox, oy, kx, ky)
  else
    return self.batch:add(x, y, r, sx, sy, ox, oy, kx, ky)
  end
end
--- Ensures that a certain named value is a Batcher
---@param val any
---@param name string
function safety.ensureBatcher(val, name)
  safety.ensureInstanceType(val, Batcher, name)
end
-- Return
return Batcher
