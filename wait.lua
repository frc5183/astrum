-- Imports
local safety=require"lib.safety"
local active={}
local wait = {}
--- Sets wait() to set up a function to be ran at a later time 
-- @param seconds the time in seconds to wait for 
-- @param func the function to be ran (NULLABLE)
-- @param ... more arguments to be passed the the function. 
setmetatable(wait, {
	__call=function (self, seconds, func, ...)
	safety.ensureNumber(seconds, "seconds")
	if type(func)~="nil" then
		safety.ensureFunction(func, "func")
	end
	table.insert(active, {love.timer.getTime()+seconds, func, {...}})
end})
-- Called every single frame-update in love.update
function wait.update()
	for k, v in pairs(active) do
		if love.timer.getTime()>=v[1] then
			if v[2] then
				v[2](unpack(v[3] or {}))
			end
			table.remove(active, k)
		end
	end
end
-- Return
return wait