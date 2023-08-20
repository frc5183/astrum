-- Imports
local safety = require "lib.safety"
local active = {}
local wait = {}

---@overload fun(seconds:number, func:function, ...:any)
setmetatable(wait, {
	---@param self table
	---@param seconds number
	---@param func function
	---@param ... any
	__call = function(self, seconds, func, ...)
		safety.ensureNumber(seconds, "seconds")
		if type(func) ~= "nil" then
			safety.ensureFunction(func, "func")
		end
		table.insert(active, { love.timer.getTime() + seconds, func, { ... } })
	end
})
-- Called every single frame-update in love.update
function wait.update()
	---@param k any
	---@param v table
	for k, v in pairs(active) do
		if love.timer.getTime() >= v[1] then
			if v[2] then
				v[2](unpack(v[3] or {}))
			end
			table.remove(active, k)
		end
	end
end

-- Return
return wait
