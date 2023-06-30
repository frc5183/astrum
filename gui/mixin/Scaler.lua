local Scaler = {}
local safety = require"lib.safety"
local flux = require"lib.external.flux"
function Scaler:initScaler()
  self.sx=1
  self.sy=1
end
function Scaler:updateScaler(dt, pt) 
  safety.ensureNumber(dt, "dt")
  safety.ensurePoint2D(pt, "pt")
  local x, y = pt.x, pt.y
  if (x>=self.x and x<=self.x+self.width and y>=self.y and y<=self.y+self.height) then
    self.tween=flux.to(self, 0.5, {sx=1.2, sy=1.2})
  elseif self.tween then
    self.tween:stop()
    self.tween=nil
    self.sx=1
    self.sy=1
  end
end
return Scaler