-- Imports
local math2 = require "lib.math2"

---@class Scaler
---@field tween nil|{stop:fun()}
---@field sx number
---@field sy number
---@field x number
---@field y number
---@field width number
---@field height number
local Scaler = {}
local safety = require "lib.safety"
local flux = require "lib.external.flux"
--- The initializng Scaler
---@param x number
---@param y number
---@param width number
---@param height number
function Scaler:initScaler(x, y, width, height)
  safety.ensureNumber(x, "x")
  safety.ensureNumber(y, "y")
  safety.ensureNumber(width, "width")
  safety.ensureNumber(height, "height")
  self.x = x
  self.y = y
  self.width = width
  self.height = height
  self.sx = 1
  self.sy = 1
end

--- Updates the scaler
---@param dt number
---@param pt Point2D
function Scaler:updateScaler(dt, pt)
  safety.ensureNumber(dt, "dt")
  safety.ensurePoint2D(pt, "pt")
  ---@type number
  local x = pt.x
  ---@type number
  local y = pt.y
  if (x >= self.x and x <= self.x + self.width and y >= self.y and y <= self.y +
    self.height) then
    self.tween = flux.to(self, 0.5, {sx = 1.2, sy = 1.2})
  elseif self.tween then
    self.tween:stop()
    self.tween = nil
    self.sx = 1
    self.sy = 1
  end
end

-- Return
return Scaler
