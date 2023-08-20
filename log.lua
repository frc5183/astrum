--- Imports
local safety = require "lib.safety"
---@type table
local log = {}
--- Prints log messages to the console
---@param level string
---@param msg string
local function Log(level, msg)
	safety.ensureString(level, "level")
	safety.ensureString(msg, "msg")
	print("[" .. level .. "] " .. msg)
end


--- Prints warning log messages to the console
---@param msg string
function log.warn(msg)
	safety.ensureString(msg, "msg")
	Log("WARN", msg)
end

--- Prints info log messages to the console
---@param msg string
function log.info(msg)
	safety.ensureString(msg, "msg")
	Log("INFO", msg)
end

--- Prints error log messages to the console
---@param msg string
function log.error(msg)
	safety.ensureString(msg, "msg")
	Log("ERROR", msg)
end

--- Prints fatal log messages to the console
---@param msg string
function log.fatal(msg)
	safety.ensureString(msg, "msg")
	Log("FATAL", msg)
end

-- Return
log.custom = Log
log.info("Console Logging Library Loaded.")
return log
