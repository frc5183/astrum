-- Imports
local button = {}
local count=0;
local ClickOrigin=require"lib.gui.subsystem.ClickOrigin"
local safety=require"lib.safety"
--- Internal Init function for buttons
-- @param x the x position
-- @param y the y position
-- @param width the width
-- @param height the height
-- @param node the ClickNode used for receiving events
function button:initButton(x, y, width, height, node)
  safety.ensureNumber(x, "x")
  safety.ensureNumber(y, "y")
  safety.ensureNumber(width, "width")
  safety.ensureNumber(height, "height")
  if (node==nil) then
    node=ClickOrigin
  end
  
  safety.ensurePulse(node, "node: SHOULD BE A CLICK NODE")
  self.node=node
  self.count=0
  self.x=x
  self.y=y
  self.width=width
  self.height=height
  count=count+1
  self.id=count
end
--- Registers a function callback to the ClickNode for Click (mouse release)
-- @param func the callback function
-- @return the id of the callback, for later optional removal
function button:onClick(func)
  safety.ensureFunction(func)
  local c = self.count+1
  self.count=self.count+1
  self.node:onEvent("onClick", "Button(".. tostring(self.id) .. ") Callback(" .. tostring(c) .. ")", 
    function (pt, button, presses, ...) 
      if (self.adapter~=nil) then
        safety.ensureFunction(self.adapter, "self.adapter must be a function or nil")
        pt = adapter(self, pt)
        
      end
      func(pt, button, presses, ...)
    end)
  return c
end
--- Removes a callback function based on it's id (mouse release)
-- @param id the callback id
function button:removeOnClick(id)
  safety.ensureNumber(id, "id")
  local c = id
  self.node:removeOnEvent("onClick", "Button(".. tostring(self.id) .. ") Callback(" .. tostring(c) .. ")")
end
--- Registers a function callback to the ClickNode for Click (mouse press)
-- @param func the callback function
-- @return the id of the callback, for later optional removal
function button:onPress(func)
  safety.ensureFunction(func)
  local c = self.count+1
  self.count=self.count+1
  self.node:onEvent("onPress", "Button(".. tostring(self.id) .. ") Callback(" .. tostring(c) .. ")", 
    function (pt, button, presses, ...) 
      if (self.adapter~=nil) then
        safety.ensureFunction(self.adapter, "self.adapter must be a function or nil")
        pt = adapter(self, pt)
        
      end
      func(pt, button, presses, ...)
    end)
  return c
end
--- Removes a callback function based on it's id (mouse press)
-- @param id the callback id
function button:removeOnPress(id)
  safety.ensureNumber(id, "id")
  local c = id
  self.node:removeOnEvent("onPress", "Button(".. tostring(self.id) .. ") Callback(" .. tostring(c) .. ")")
end
--- A forwarder for pulse:require() (mouse release)
-- @param id the id of the callback to require
-- @param .. all extend ids
function button:requireClick(id, ...)
  safety.ensureNumber(id, "id")
  local c = id
  self.node:require("onClick","Button(".. tostring(self.id) .. ") Callback(" .. tostring(c) .. ")", ...)
end
--- A forwarder for pulse:require() (mouse press)
-- @param id the id of the callback to require
-- @param .. all extend ids
function button:requirePress(id, ...)
  safety.ensureNumber(id, "id")
  local c = id
  self.node:require("onPress","Button(".. tostring(self.id) .. ") Callback(" .. tostring(c) .. ")", ...)
end
--- A useful function for callbacks to test if a point is within the button's bounds
-- @param point the Point2D point
function button:contains(point) 
  safety.ensurePoint2D(point, "point")
  return point.x>=self.x and point.x<=self.x+self.width and point.y>=self.y and point.y<=self.y+self.height
end

-- Return
return button