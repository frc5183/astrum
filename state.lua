-- Imports
local log = require"lib.log"
local safety = require"lib.safety"
local state={}
local active={name="init"}
--- A function that allows quick switching between different functions for the Love2D callbacks like love.draw() and love.update().
-- A table is passed in containing all replacement callbacks. In addition to Love2D callbacks, two more are available:
-- the callback switchaway() is used after the state.switch() is called again to allow cleaning up if needed to fully disable the state.
-- the callback switchto() is the complement to switchaway() it is called immediately when state.switch() is called and allows setup that may be needed to enable the state again
-- @param newState a table that contains all replacment callbacks
function state.switch(newState)
  safety.ensureTable(newState, "newState")
  if (not (type(name) == "nil")) then
    safety.ensureString(name, "newState.name")
  end
	local name=newState.name
	if (not (type(name) == "nil")) then
    safety.ensureString(name, "newState.name")
  end
	if (not name or name=="") then
		log.warn("Switching to a state without a name. Defaulting to name NONAME")
		name="NONAME"
		newState.name=name
	end
	log.info("Switching to a new gamestate with name: " .. name)
	if (not (type(active.switchaway) == "nil")) then
    safety.ensureFunction(active.switchaway, "active.switchaway: THIS INDICATES THE LAST STATE IS THE PROBLEM. NOT THE ONE THAT IS BEING SWITCHED TO")
    active.switchaway()
  end
	if (not (type(newState.switchto)=="nil")) then
    safety.ensureFunction(newState.switchto, "newState.switchto")
    newState.switchto()
  end
	
	for k, v in pairs(newState) do
		if k=="content" then
		elseif k=="name" then
		elseif k=="switchto" then
		elseif k=="switchaway" then
		else
			love[k]=v
		end
	end
	active=newState
end
--- A function that gets the name of the currently active state.
-- @return the name of the currently active state
function state.getStateName()
	return active.name
end
-- Return
return state