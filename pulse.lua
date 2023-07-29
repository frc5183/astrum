local class = require"lib.external.class"
local Pulse = class("Pulse")
local safety = require"lib.safety"
--- A Pulse is an event emitter class. Instances can be used to construct complex callback-based programming
-- @type Pulse
-- @param events a nullable table that contains strings to be initialized as events
-- @return a new Pulse instance
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
--- Registers a new event for the Pulse
-- @param event the string name for the event
function Pulse:newEvent(event)
  safety.ensureString(event, "event")
  self.events[event]={}
end
--- Unregisters an event for the Pulse
-- @param event the string name for the event
function Pulse:removeEvent(event)
  safety.ensureString(event, "event")
  self.events[event]=nil
end
--- Registers (or replaces) a new callback for the Pulse
-- @param event the string name for the event: MUST BE REGISTERED ALREADY
-- @param id the string id for the callback: Must be unique if not trying to replace other callbacks
-- @param func the callback function itself
function Pulse:onEvent(event, id, func)
  safety.ensureString(event, "event")
  safety.ensureString(id, "id")
  safety.ensureFunction(func, "func")
  if (type(self.events[event]~="table")) then
    safety.ensureTable(self.events[event], "event " .. event .. " unregistered. Register using Pulse:newEvent(event).")
  end
  self.events[event][id]=func
end
--- Removes a callback, whether it exists or not, for the Pulse 
-- @param event the string name for the event: MUST BE REGISTERED ALREADY
-- @param id the id for the callback
function Pulse:removeOnEvent(event, id)
  safety.ensureString(event, "event")
  safety.ensureString(id, "id")
  
  if (type(self.events[event]~="table")) then
    safety.ensureTable(self.events[event], "event " .. event .. " unregistered. Register using Pulse:newEvent(event). Perhaps you already unregistered the event?")
  end
  
end
--- Emits an event with arguments to all registered callbacks for that event
-- @param event the string name for the event: MUST BE REGISTERED ALREADY
-- @param ... any additional paramaters will be passed to callback functions
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
--- Used by callbacks to ensure that any other callbacks that must be run before them are completed before their execution
-- @param event the string name for the event: MUST BE REGISTERED ALREADY
-- @param id the id for the required callback
-- @param ... the extra paramaters to be passed to the callback
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
--- Ensures that a certain named value is a pulse
-- @param val the value to be evaluated
-- @param name the optional name of the value
function safety.ensurePulse(val, name)
  safety.ensureInstanceType(val, Pulse, name)
end
-- Return
return Pulse
