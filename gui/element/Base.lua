-- Imports
local class = require "lib.external.class"
local math2 = require "lib.math2"
---@class Base
---@field include fun(self:Base, mixin:any)
---@field x number
---@field y number
---@field width number
---@field height number
local Base = class("Base")
function Base:draw() end

---@param dt number
---@param pt Point2D
function Base:update(dt, pt) end

---@param x number
---@param y number
---@param dx number
---@param dy number
---@param istouch boolean
function Base:mousemoved(x, y, dx, dy, istouch) end

---@param dx number
---@param dy number
---@param x number
---@param y number
function Base:wheelmoved(dx, dy, x, y) end

---@param text string
function Base:textinput(text) end

---@param key string
---@param scancode string
---@param isrepeat boolean
function Base:keypressed(key, scancode, isrepeat) end

---@param pt Point2D
---@param button number
---@param presses number
---@param ... any
function Base:click(pt, button, presses, ...) end

---@param pt Point2D
---@param button number
---@param presses number
---@param ... any
function Base:press(pt, button, presses, ...) end

-- Return
return Base
