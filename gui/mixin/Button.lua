local button = {}
local count=0;
local ClickPulser=require"lib.gui.subsystem.ClickPulser"
local safety=require"lib.safety"
function button:initButton(x, y, width, height)
  safety.ensureNumber(x, "x")
  safety.ensureNumber(y, "y")
  safety.ensureNumber(width, "width")
  safety.ensureNumber(height, "height")
  self.count=0
  self.x=x
  self.y=y
  self.width=width
  self.height=height
  count=count+1
  self.id=count
end

function button:onClick(func)
  safety.ensureFunction(func)
  local c = self.count+1
  self.count=self.count+1
  ClickPulser:onEvent("onClick", "Button(".. tostring(self.id) .. ") Callback(" .. tostring(c) .. ")", func)
  return c
end

function button:removeOnClick(id)
  safety.ensureNumber(id, "id")
  local c = id
  ClickPulser:removeOnEvent("onClick", "Button(".. tostring(self.id) .. ") Callback(" .. tostring(c) .. ")")
end

function button:onPress(func)
  safety.ensureFunction(func)
  local c = self.count+1
  self.count=self.count+1
  ClickPulser:onEvent("onPress", "Button(".. tostring(self.id) .. ") Callback(" .. tostring(c) .. ")", func)
  return c
end

function button:removeOnPress(id)
  safety.ensureNumber(id, "id")
  local c = id
  ClickPulser:removeOnEvent("onPress", "Button(".. tostring(self.id) .. ") Callback(" .. tostring(c) .. ")")
end

function button:requireClick(id, ...)
  safety.ensureNumber(id, "id")
  local c = id
  ClickPulser:require("onClick","Button(".. tostring(self.id) .. ") Callback(" .. tostring(c) .. ")", ...)
end

function button:requirePress(id, ...)
  safety.ensureNumber(id, "id")
  local c = id
  ClickPulser:require("onPress","Button(".. tostring(self.id) .. ") Callback(" .. tostring(c) .. ")", ...)
end

function button:contains(point) 
  safety.ensurePoint2D(point, "point")
  return point.x>=self.x and point.x<=self.x+self.width and point.y>=self.y and point.y<=self.y+self.height
end


return button