-- Imports
local log = {}
--- Prints log messages to the console
-- @param level the custom log type name
-- @param msg the log message to be printed to the console
local function Log(level, msg)
	print("[" .. level .. "] " .. msg)
end


--- Prints warning log messages to the console
-- @param msg the log message to be printed to the console
function log.warn(msg)
	Log("WARN", msg)
end
--- Prints info log messages to the console
-- @param msg the log message to be printed to the console
function log.info(msg)
	Log("INFO", msg)
end
--- Prints error log messages to the console
-- @param msg the log message to be printed to the console
function log.error(msg)
	Log("ERROR", msg)
end
--- Prints fatal log messages to the console
-- @param msg the log message to be printed to the console
function log.fatal(msg)
	Log("FATAL", msg)
end
-- Return
log.custom=Log
log.info("Console Logging Library Loaded.")
return log