local class = require "lib.external.class"
---@class Pulse
---@field private _events table
---@field private _cache table
---@overload fun(events:table):Pulse
local Pulse = class("Pulse")
local safety = require "lib.safety"
--- A Pulse is an event emitter class. Instances can be used to construct complex callback-based programming
---@param events table|nil
function Pulse:initialize(events)
  if not (type(events) == "table" or type(events) == "nil") then
    safety.ensureTable(events, "events")
  end
  events = events or {}
  self._events = {}
  self._cache = {}
  ---@param v string
  for _, v in pairs(events) do
    safety.ensureString(v, "events should be a table of only strings")
    self._events[v] = {}
  end
end

--- Registers a new event for the Pulse
---@param event string
function Pulse:newEvent(event)
  safety.ensureString(event, "event")
  self._events[event] = {}
end

--- Unregisters an event for the Pulse
---@param event string
function Pulse:removeEvent(event)
  safety.ensureString(event, "event")
  self._events[event] = nil
end

--- Registers (or replaces) a new callback for the Pulse
---@param event string
---@param id string
---@param func function
function Pulse:onEvent(event, id, func)
  safety.ensureString(event, "event")
  safety.ensureString(id, "id")
  safety.ensureFunction(func, "func")
  if (type(self._events[event] ~= "table")) then
    safety.ensureTable(self._events[event], "event " .. event .. " unregistered. Register using Pulse:newEvent(event).")
  end
  self._events[event][id] = func
end

--- Removes a callback, whether it exists or not, for the Pulse
---@param event string
---@param id string
function Pulse:removeOnEvent(event, id)
  safety.ensureString(event, "event")
  safety.ensureString(id, "id")

  if (type(self._events[event] ~= "table")) then
    safety.ensureTable(self._events[event],
      "event " ..
      event .. " unregistered. Register using Pulse:newEvent(event). Perhaps you already unregistered the event?")
  end
end

--- Emits an event with arguments to all registered callbacks for that event
---@param event string
---@param ... any
function Pulse:emit(event, ...)
  safety.ensureString(event, "event")
  if (type(self._events[event] ~= "table")) then
    safety.ensureTable(self._events[event], "event " .. event .. " unregistered. Register using Pulse:newEvent(event).")
  end
  self._cache[event] = {}
  ---@param k string
  ---@param v function
  for k, v in pairs(self._events[event]) do
    if (not self._cache[event][k]) then
      v(...)
      self._cache[event][k] = true
    end
  end
  self._cache[event] = nil
end

--- Used by callbacks to ensure that any other callbacks that must be run before them are completed before their execution
---@param event string
---@param id string
---@param ... any
function Pulse:require(event, id, ...)
  safety.ensureString(event, "event")
  safety.ensureString(id, "id")
  if (type(self._events[event] ~= "table")) then
    safety.ensureTable(self._events[event], "event " .. event .. " unregistered. Register using Pulse:newEvent(event).")
  end
  safety.ensureFunction(self._events[event][id],
    "callback function in Pulse.events[" .. event .. "][" .. id .. "]. This function may be unregistered in the Pulse")
  safety.ensureTable(self._cache[event],
    "self._cache[event] does not exist. This probably means Pulse:require() was called outside of Pulse:emit()'s callbacks. ")
  if (not self._cache[event][id]) then
    self._events[event][id](...)
    self._cache[event][id] = true
  end
end

--- Ensures that a certain named value is a pulse
---@param val any
---@param name string|nil
function safety.ensurePulse(val, name)
  safety.ensureInstanceType(val, Pulse, name)
end

-- Return
return Pulse
