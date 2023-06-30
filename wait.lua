local safety=require"lib.safety"
local active={}
local wait = {}
setmetatable(wait, {
	__call=function (self, seconds, func, args)
	safety.ensureNumber(seconds, "seconds")
	if type(func)~="nil" then
		safety.ensureFunction(func, "func")
	end
	table.insert(active, {love.timer.getTime()+seconds, func, args})
end})

function wait.update()
	for k, v in pairs(active) do
		if love.timer.getTime()>=v[1] then
			if v[2] then
				v[2](v[3])
			end
			table.remove(active, k)
		end
	end
end

return wait