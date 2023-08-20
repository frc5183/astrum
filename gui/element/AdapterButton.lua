-- Imports
local class = require "lib.external.class"
local Button = require "lib.gui.mixin.Button"
local safety = require "lib.safety"
local Base = require "lib.gui.element.Base"
local AdapterButton = class("AdapterButton", Base)
AdapterButton:include(Button)
--- Adapter Button is a the most basic implementation of Button: it simply is a empty unvisual button
-- @param x the x position
-- @param y the y position
-- @param width the button width
-- @param height the button height
-- @param node the option ClickNode, is nullable
-- @return the new AdapterButton
function AdapterButton:initialize(x, y, width, height, node)
  safety.ensureNumber(x, "x")
  safety.ensureNumber(y, "y")
  safety.ensureNumberOver(width, 0, "width")
  safety.ensureNumberOver(height, 0, "height")
  self:initButton(x, y, width, height, node)
end

-- Return
return AdapterButton
