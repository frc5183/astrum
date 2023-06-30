local log = require("lib.log")
local state={}
local active={name="init"}

function state.switch(newState)
	if type(newState)~="table" then
		log.error("Value newState expected to be of type table. Found type " .. type(newState).. ".")
		error("Value newState expected to be of type table. Found type " .. type(newState).. ".")
	end
	local name=newState.name
	if not (type(name)=="string" or type(name)=="nil") then
		log.error("Value newState.name expected to be of type string or nil. Found type " .. type(name).. ".")
		error("Value newState.name expected to be of type string or nil. Found type " .. type(name).. ".")
	end
	if (not name or name=="") then
		log.warn("Switching to a state without a name. Defaulting to name NONAME")
		name="NONAME"
		newState.name=name
	end
	log.info("Switching to a new gamestate with name: " .. name)
	
	if type(active.switchaway)~="nil" then
		if type(active.switchaway) ~= "function" then
			log.error("Value active.switchaway expected to be of type nil or function. Found type " .. type(active.switchaway) .. ". The current call to state.switch did not cause this issue. Check the last call before this one.")
			error("Value active.switchaway expected to be of type nil or function. Found type " .. type(active.switchaway).. ". The current call to state.switch did not cause this issue. Check the last call before this one.")
		end
		active.switchaway()
	end
	
	if type(newState.switchto)~="nil" then
		if type(newState.switchto)~="function" then
			log.error("Value newState.switchto expected to be of type nil or function. Found type " .. type(newState.switchto).. ".")
			error("Value newState.switchto expected to be of type nil or function. Found type " .. type(newState.switchto).. ".")
		end
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
function state.getStateName()
	return active.name
end
log.info("Gamestate Library Loaded.")
return state