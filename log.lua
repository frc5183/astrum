local function Log(level, msg)
	print("[" .. level .. "] " .. msg)
end


local log = {}

function log.warn(msg)
	Log("WARN", msg)
end

function log.info(msg)
	Log("INFO", msg)
end

function log.error(msg)
	Log("ERROR", msg)
end

function log.fatal(msg)
	Log("FATAL", msg)
end

log.custom=Log
log.info("Console Logging Library Loaded.")
return log