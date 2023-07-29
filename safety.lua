-- Imports
local log = require("lib.log")
local safety = {}
--- Ensures that a certain named value is a string
-- @param val the value to be evaluated
-- @param name the optional name of the value
function safety.ensureString(val, name)
	if type(name)~="string"  then
		if type(name)=="nil" then 
			name="" 
		else
			safety.ensureString(name, "name")
		end
	end
	if (type(val)=="string") then
	else
		local str = "Value (".. name .. ") expected to be of type string. Found type " .. type(val) .. "."
		log.error(str)
		error(str)
	end
end
--- Ensures that a certain named value is a Lua Type
-- @param val the value to be evaluated
-- @param ltype the lua type that the value should be
-- @param name the optional name of the value
function safety.ensureLuaType(val, ltype, name)
	safety.ensureString(ltype, "ltype")
	if type(name)~="string"  then
		if type(name)=="nil" then 
			name="" 
		else
			safety.ensureString(name, "name")
		end
	end
	if (type(val)==ltype) then
	else
		local str = "Value (".. name .. ") expected to be of type ".. ltype ..". Found type " .. type(val) .. "."
		log.error(str)
		error(str)
	end
end
--- Ensures that a certain named value is a table
-- @param val the value to be evaluated
-- @param name the optional name of the value
function safety.ensureTable(val, name)
	safety.ensureLuaType(val, "table", name)
end
--- Ensures that a certain named value is a number
-- @param val the value to be evaluated
-- @param name the optional name of the value
function safety.ensureNumber(val, name)
	safety.ensureLuaType(val, "number", name)
end
--- Ensures that a certain named value is nil
-- @param val the value to be evaluated
-- @param name the optional name of the value
function safety.ensureNil(val, name)
	safety.ensureLuaType(val, "nil", name)
end
--- Ensures that a certain named value is a function
-- @param val the value to be evaluated
-- @param name the optional name of the value
function safety.ensureFunction(val, name)
	safety.ensureLuaType(val, "function", name)
end
--- Ensures that a certain named value is a boolean
-- @param val the value to be evaluated
-- @param name the optional name of the value
function safety.ensureBoolean(val, name)
	safety.ensureLuaType(val, "boolean", name)
end
--- Ensures that a certain named value is a coroutine
-- @param val the value to be evaluated
-- @param name the optional name of the value
function safety.ensureCoroutine(val, name)
	safety.ensureLuaType(val, "coroutine", name)
end
--- Ensures that a certain named value is a userdata
-- @param val the value to be evaluated
-- @param name the optional name of the value
function safety.ensureUserdata(val, name)
	safety.ensureLuaType(val, "userdata", name)
end
--- Ensures that a certain named value is an integer
-- @param val the value to be evaluated
-- @param name the optional name of the value
function safety.ensureInteger(val, name)
  safety.ensureNumber(val, name)
  if (val~=math.floor(val)) then
    error(name .. " must be an integer value")
  end
end
--- Ensures that a certain named value is an integer over a certain number
-- @param val the value to be evaluated
-- @param lim the limit that an integer should be over
-- @param name the optional name of the value
function safety.ensureIntegerOver(val, lim, name)
  safety.ensureInteger(val, name)
  safety.ensureNumber(lim, "lim")
  if (val<=lim) then
    error(name .. " must be an integer value greater than " .. lim ..". Value of (" .. val .. ") does not match.")
  end
end
--- Ensures that a certain named value is a number over a certain number
-- @param val the value to be evaluated
-- @param lim the limit that a number should be over
-- @param name the optional name of the value
function safety.ensureNumberOver(val, lim, name)
  safety.ensureNumber(val, name)
  safety.ensureNumber(lim, "lim")
  if (val<=lim) then
    error(name .. " must be a number value greater than " .. lim .. ". Value of (" .. val .. ") does not match.")
  end
end
--- Ensures that a certain named value is an instance of a certain class
-- @param val the value to be evaluated
-- @param class the class that the value should be an instance of
-- @param name the optional name of the value
function safety.ensureInstanceType(val, class, name)
  
	if type(name)~="string"  then
		if type(name)=="nil" then 
			name="" 
		else
			safety.ensureString(name, "name")
		end
	end
	safety.ensureTable(class, "class")
	safety.ensureTable(val, "val")
	local cname=class.name
	if type(cname)~="string"  then
		if type(cname)=="nil" then 
			cname="INVALIDCLASS" 
		else
			safety.ensureString(cname, "class.name")
		end
	end
	if (type(val.isInstanceOf)=="function") then
		if (val:isInstanceOf(class)) then
			return
		end
	end
	
	local valtype="\"Not a proper class. Could be a corrupt class or could be just a normal table\""
	if type(val.class)=="table" and type(val.class.name)=="string" then
		valtype=val.class.name
	end
	if type(val.super)=="table" and type(val.super.name)=="string" then
		valtype=val.super.name
	end
	local str = "Value (" .. name .. ") expected to be of Class type ".. cname ..". Found class/superclass " .. valtype .. "."
	log.error(str)
	error(str)
end
-- Return
return safety