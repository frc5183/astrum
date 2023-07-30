-- Imports
local pulse = require"lib.pulse"
local math2 = require"lib.math2"
local safety = require"lib.safety"
local ClickPulser = pulse({"onClick", "onPress"})
local count = 0

--- Returns a new ClickNode
-- If Origin is True, then it creates a top level node, otherwise it creates a child node of the ClickNode that Origin is
return function (origin, adapter)
  safety.ensureFunction(adapter, "adapter")
  local o = pulse({"onClick", "onPress"})
  if origin~=true then
    safety.ensureInstanceType(origin, pulse, "origin")
    origin:onEvent("onPress", "ClickNode" .. count+1, 
    function (pt, button, presses, ...) 
      pt, button, presses = adapter(pt, button, presses)
      o:emit("onPress", pt, button, presses, ...)
    end)
    origin:onEvent("onClick", "ClickNode" .. count+1,
    function (pt, button, presses, ...)
      pt, button, presses = adapter(pt, button, presses)
      o:emit("onClick", pt, button, presses, ...)
      end)
    count=count+1
  else
    function o:mouseReleased(x, y, button, presses)
      safety.ensureNumber(x, "x")
      safety.ensureNumber(y, "y")
      safety.ensureNumber(button, "button")
      safety.ensureNumber(presses, "presses")
      self:emit("onClick", math2.Point2D(x, y), button, presses)
    end

    function o:mousePressed(x, y, button, presses)
      safety.ensureNumber(x, "x")
      safety.ensureNumber(y, "y")
      safety.ensureNumber(button, "button")
      safety.ensureNumber(presses, "presses")
      self:emit("onPress", math2.Point2D(x, y), button, presses)
    end
  end
  return o
end