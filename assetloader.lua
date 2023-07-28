-- Imports
local AssetLoader = {}
local log = require"lib.log"
local AssetManager = require"lib.assetmanager"
local channel = love.thread.getChannel("assets")
love.filesystem.setIdentity(love.filesystem.getIdentity(), true)
local int_asset_scripts = love.filesystem.getDirectoryItems("asset/script")
local threads = {}
local isFinished=false
--- loads files from a directory
-- @param dir the string for the directory to be searched
-- @param script_type the script type. if Local, will only load files within the source code package or directory
local function load_dir(dir, script_type)
  local asset_scripts
  asset_scripts = love.filesystem.getDirectoryItems(dir)

  for i, filename in ipairs(asset_scripts) do
    local go = true
    local path = dir .. "/" .. filename
    if script_type=="Local" then
      go = (not (love.filesystem.getRealDirectory(path) == love.filesystem.getSaveDirectory()))
    end
    if (go) then
      local info
      info = love.filesystem.getInfo(path)
      if (info.type=="directory") then
        load_dir(dir.. "/" .. filename, script_type)
      end
      if (info.type=="file" and string.sub(filename, -4, -1)==".lua") then
        local file
        file= path

        local thread = love.thread.newThread(file)
        thread:start()
        log.info("Starting " .. script_type .. " Asset Script: " .. path)
        table.insert(threads, #threads+1, thread)
      end
    end
  end
end
local external = false
--- Enables external scripts
function AssetLoader.enableExternal()
  external=true
end
--- Starts loading scripts
function AssetLoader.start()
  load_dir("asset/script", "Local")
  if (external) then
    load_dir(love.filesystem.getSaveDirectory() .. "/external/asset/script", "External")
  end
end
--- Manages running scripts and receives incoming assets 
function AssetLoader.update()
  
  local rm = {}
  for i, v in ipairs(threads) do
    if (not v:isRunning()) then
      table.insert(rm, i)
      if (v:getError()) then
        error("Asset Script Failed With Error: " .. v:getError())
      end
    end
  end
  for i, v in ipairs(rm) do
    table.remove(threads, v)
  end
  local pop = channel:pop()
  while (pop~=nil) do
    if (type(pop)=="table" and type(pop.category)=="string" and type(pop.id)=="string" and type(pop.asset)~="nil") then
      pcall(AssetManager.registerCategory, pop.category)
      AssetManager.registerAsset(pop.category, pop.id, pop.asset)
    else 
      error("Invalid Asset Loaded")
    end
    pop = channel:pop()
  end
  if #threads==0 then
    isFinished=true
  end
end
--- Returns if all scripts are finished running
-- @return isFinished
function AssetLoader.isFinished()
  return isFinished
end
--[[
IMPORTANT NOTES:
ASSET SCRIPTS SHOULD RETURN ASSETS TO THE CHANNEL "assets"
ASSETS SHOULD BE RETURNED IN THE FORM {category=category, id=id, asset=asset}
EXTERNAL ASSET SCRIPTS ARE RISKY AND NOT RECOMMENDED AS ANY CODE COULD BE COLLECTED AND RUN, INCLUDING MALICIOUS CODE
SCRIPTS ARE RUN AS THREADS AND THEREFORE MAY NEED TO RELOAD CERTAIN REQUIRED LOVE2D OR ASTRUM LIBRARIES
LOCAL SCRIPTS SHOULD BE INCLUDED IN THE src/asset/script/ DIRECTORY
EXTERNAL SCRIPTS SHOULD BE INCLUDED IN THE LOVESAVEDIRECTORY/external/asset/script/ DIRECTORY
ANY DATA SENT AS AN ASSET CANNOT INCLUDE FUNCTIONS, COROUTINES OR NON LOVE2D-USERDATA
CLASS INSTANCES SHOULD BE DECLASSIFIED IF LOADING THEM AS AN ASSET IS NECESSARY
--]]
-- Return
return AssetLoader