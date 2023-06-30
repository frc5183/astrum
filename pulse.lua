local class = require"lib.external.class"
local Pulse = class("Pulse")
local safety = require"lib.safety"

function Pulse:initialize(events)
  if not (type(events)=="table" or type(events)=="nil") then
    safety.ensureTable(events, "events")
  end
  events = events or {}
  self.events={}
  self.cache={}
  for k, v in pairs(events) do
    safety.ensureString(v, "events should be a table of only strings")
    self.events[v]={}
  end
end

function Pulse:newEvent(event)
  safety.ensureString(event, "event")
end

function Pulse:removeEvent(event)
  safety.ensureString(event, "event")
  self.events[event]=nil
end

function Pulse:onEvent(event, id, func)
  safety.ensureString(event, "event")
  safety.ensureString(id, "id")
  safety.ensureFunction(func, "func")
  if (type(self.events[event]~="table")) then
    safety.ensureTable(self.events[event], "event " .. event .. " unregistered. Register using Pulse:newEvent(event).")
  end
  self.events[event][id]=func
end

function Pulse:removeOnEvent(event, id)
  safety.ensureString(event, "event")
  safety.ensureString(id, "id")
  
  if (type(self.events[event]~="table")) then
    safety.ensureTable(self.events[event], "event " .. event .. " unregistered. Register using Pulse:newEvent(event). Perhaps you already unregistered the event?")
  end
  
end

function Pulse:emit(event, ...)
  safety.ensureString(event, "event")
  if (type(self.events[event]~="table")) then
    safety.ensureTable(self.events[event], "event " .. event .. " unregistered. Register using Pulse:newEvent(event).")
  end
  self.cache[event]={}
  for k, v in pairs(self.events[event]) do
    if (not self.cache[event][k]) then
      v(...)
      self.cache[event][k]=true
    end
  end
  self.cache[event]=nil
end

function Pulse:require(event, id, ...)
  safety.ensureString(event, "event")
  safety.ensureString(id, "id")
  if (type(self.events[event]~="table")) then
    safety.ensureTable(self.events[event], "event " .. event .. " unregistered. Register using Pulse:newEvent(event).")
  end
  safety.ensureFunction(self.events[event][id], "callback function in Pulse.events[" .. event .. "][" .. id .. "]. This function may be unregistered in the Pulse")
  safety.ensureTable(self.cache[event], "self.cache[event] does not exist. This probably means Pulse:require() was called outside of Pulse:emit()'s callbacks. ")
  if (not self.cache[event][id]) then
    self.events[event][id](...)
    self.cache[event][id]=true
  end
end

return Pulse
