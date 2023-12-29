---@module 'lib.safety'
local safety = require "lib.safety"
---@type table
local Sizer = {}
---@type boolean
local init = false
---@type integer
local _width
---@type integer
local _height
---@type boolean
local active = false
---@type boolean
local widthLonger
---@type number
local factor
---@type number
local scalar
---@type love.Canvas
local canvas
---Sets up the Sizer
---@param width integer
---@param height integer
function Sizer.init(width, height)
  safety.ensureIntegerOver(width, 0, "width")
  safety.ensureIntegerOver(height, 0, "height")
  _width = width
  _height = height
  if love.graphics.getWidth() / love.graphics.getHeight() > _width / _height then
    active = true
    widthLonger = true
    factor = (width / height)
  elseif love.graphics.getWidth() / love.graphics.getHeight() < _width / _height then
    active = true
    widthLonger = false
    factor = (height / width)
  else
    active = false
    factor = 1
  end
  canvas = love.graphics.newCanvas(width, height)
  scalar = math.min(love.graphics.getWidth() / _width,
                    love.graphics.getHeight() / _height)
end

---Clears and sets the framebuffer
function Sizer.begin()
  love.graphics.setCanvas(canvas)
  love.graphics.clear()
end

---Actually draws the framebuffer to the screen
function Sizer.finish()
  love.graphics.setCanvas()
  ---@type number
  local x = 0
  ---@type number
  local y = 0
  if (active) then
    if (widthLonger) then
      x = (love.graphics.getWidth() - (love.graphics.getHeight() * (factor))) /
            2
    else
      y = (love.graphics.getHeight() - (love.graphics.getWidth() * (factor))) /
            2
    end
  end
  love.graphics.draw(canvas, x, y, 0, scalar, scalar)
end

---Translates love2d coordinates to Sizer coordinates
---@param x number
---@param y number
---@return number, number
function Sizer.translate(x, y)
  ---@type number
  local _x = 0
  ---@type integer
  local _y = 0
  if (active) then
    if (widthLonger) then
      _x = (love.graphics.getWidth() - (love.graphics.getHeight() * (factor))) /
             2
    else
      _y = (love.graphics.getHeight() - (love.graphics.getWidth() * (factor))) /
             2
    end
  end
  return (x - _x) / scalar, (y - _y) / scalar
end

---Scales delta changes from screen space changes
---@param dx number
---@param dy number
---@return number, number
function Sizer.scale(dx, dy) return dx / scalar, dy / scalar end

-- Return
return Sizer
