local pulse = require"lib.pulse"
local math2 = require"lib.math2"
local safety = require"lib.safety"
local ClickPulser = pulse({"onClick", "onPress"})

function ClickPulser:mouseReleased(x, y, button, presses)
  safety.ensureNumber(x, "x")
  safety.ensureNumber(y, "y")
  safety.ensureNumber(button, "button")
  safety.ensureNumber(presses, "presses")
  self:emit("onClick", math2.Point2D(x, y), button, presses)
end

function ClickPulser:mousePressed(x, y, button, presses)
  safety.ensureNumber(x, "x")
  safety.ensureNumber(y, "y")
  safety.ensureNumber(button, "button")
  safety.ensureNumber(presses, "presses")
  self:emit("onPress", math2.Point2D(x, y), button, presses)
end

return ClickPulser