local class=require"lib.external.class"
local Button=require"lib.gui.mixin.Button"
local safety=require"lib.safety"
local AdapterButton=class("AdapterButton")
AdapterButton:include(Button)

function AdapterButton:initialize(x, y, width, height)
  safety.ensureNumber(x, "x")
  safety.ensureNumber(y, "y")
  safety.ensureNumberOver(width, 0, "width")
  safety.ensureNumberOver(height, 0, "height")
  self:initButton(x, y, width, height)
end


return AdapterButton