-- Imports
local class = require "lib.external.class"
local Button = require "lib.gui.mixin.Button"
local safety = require "lib.safety"
local Base = require "lib.gui.element.Base"
---@class AdapterButton : Base, Button
---@overload fun(x:number, y:number, width:number, height:number):AdapterButton
local AdapterButton = class("AdapterButton", Base)
AdapterButton:include(Button)
--- Adapter Button is a the most basic implementation of Button: it simply is a empty unvisual button
---@param x number
---@param y number
---@param width number
---@param height number
function AdapterButton:initialize(x, y, width, height)
  safety.ensureNumber(x, "x")
  safety.ensureNumber(y, "y")
  safety.ensureNumberOver(width, 0, "width")
  safety.ensureNumberOver(height, 0, "height")
  self:initButton(x, y, width, height)
end

-- Return
return AdapterButton
