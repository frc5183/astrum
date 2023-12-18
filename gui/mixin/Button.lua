-- Imports
---@class Button
---@field x number
---@field y number
---@field width number
---@field height number
---@field _count_click integer
---@field _count_press integer
---@field _callbacks_click table
---@field _callbacks_press table
local button = {}
local safety = require "lib.safety"
--- Internal Init function for buttons
---@param x number
---@param y number
---@param width number
---@param height number
function button:initButton(x, y, width, height)
  safety.ensureNumber(x, "x")
  safety.ensureNumber(y, "y")
  safety.ensureNumber(width, "width")
  safety.ensureNumber(height, "height")

  self._count_click = 0
  self._count_press = 0
  self._callbacks_click = {}
  self._callbacks_press = {}
  self.x = x
  self.y = y
  self.width = width
  self.height = height
end

--- Registers a function callback for Click  (mouse release)
---@param func fun(pt:Point2D, button:number, presses:number, ...:any):any
---@return number the id of the callback, for later optional removal
function button:onClick(func)
  safety.ensureFunction(func)
  local c = self._count_click + 1
  self._count_click = self._count_click + 1
  table.insert(self._callbacks_click, c, func)
  return c
end

--- Removes a callback function based on it's id (mouse release)
---@param id number
function button:removeOnClick(id)
  safety.ensureNumber(id, "id")
  table.remove(self._callbacks_click, id)
end

--- Registers a function callback for Press (mouse press)
---@param func fun(pt:Point2D, button:number, presses:number, ...:any):any
---@return number the id of the callback, for later optional removal
function button:onPress(func)
  safety.ensureFunction(func)
  local c = self._count_press + 1
  self._count_press = self._count_press + 1
  table.insert(self._callbacks_press, c, func)
  return c
end

--- Removes a callback function based on it's id (mouse press)
-- @param id the callback id
function button:removeOnPress(id)
  safety.ensureNumber(id, "id")
  table.remove(self._callbacks_press, id)
end

--- A useful function for callbacks to test if a point is within the button's bounds
---@param point Point2D
---@return boolean
function button:contains(point)
  safety.ensurePoint2D(point, "point")
  return point.x >= self.x and point.x <= self.x + self.width and point.y >=
      self.y and point.y <= self.y + self.height
end

--- Triggers all click callbacks
---@param pt Point2D
---@param button number
---@param presses number
---@param ... any
function button:click(pt, button, presses, ...)
  ---@param k integer
  ---@param v fun(pt:Point2D, button:number, presses:number, ...:any):any
  for k, v in ipairs(self._callbacks_click) do v(pt, button, presses, ...) end
end

--- Triggers all press callbacks
---@param pt Point2D
---@param button number
---@param presses number
---@param ... any
function button:press(pt, button, presses, ...)
  ---@param k integer
  ---@param v fun(pt:Point2D, button:number, presses:number, ...:any):any
  for k, v in ipairs(self._callbacks_press) do v(pt, button, presses, ...) end
end

-- Return
return button
