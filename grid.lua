local class = require"lib.external.class"
local Grid = class("Grid")
local safety = require"lib.safety"
local AssetManager = require"lib.assetmanager"
local json = require "lib.external.json"
function Grid:initialize(width, height)
  safety.ensureNumber(width, "width")
  safety.ensureNumber(height, "height")
  if (width<1 or math.floor(width)~=width) then
    error("Width must be an integer value greater than 0. Width value of (" .. width .. ") does not match.")
  end
  if (height<1 or math.floor(height)~=height) then
    error("Height must be an integer value greater than 0. Height value of (" .. height .. ") does not match.")
  end
  self.tiles={}
  for k=1, width do
    self.tiles[k] = {}
  end
  self.width=width
  self.height=height
end

-- GRID:EXTEND (LEFT RIGHT DOWN UP)
-- GRID FROM JSON
-- GRID USES ASSET MANAGER 
function Grid:extend(left, right, up, down)
  safety.ensureNumber(left, "left")
  safety.ensureNumber(right, "right")
  safety.ensureNumber(up, "up")
  safety.ensureNumber(down, "down")
  if (left<0 or math.floor(left)~=left) then
    error("Left must be an integer value greather than or equal to 0. Left value of (" .. left .. ") does not match.")
  end
  if (right<0 or math.floor(right)~=right) then
    error("Right must be an integer value greather than or equal to 0. Right value of (" .. right .. ") does not match.")
  end
  if (up<0 or math.floor(up)~=up) then
    error("Up must be an integer value greather than or equal to 0. Up value of (" .. up .. ") does not match.")
  end
  if (down<0 or math.floor(down)~=down) then
    error("Down must be an integer value greather than or equal to 0. Down value of (" .. down .. ") does not match.")
  end
  if (right>0) then
    for x=#self.tiles+1, #self.tiles+right do
      self.tiles[x]={}
    end
  end
  if (left>0) then
    for x=#self.tiles, 1, -1 do
      self.tiles[x+left]=self.tiles[x]
    end
    for x=1, left do
      self.tiles[x]={}
    end
  end
  if (up>0) then
    for x=1, #arr do
      for y=#arr[1], 1, -1 do
        self.tiles[x][y+up]=self.tites[x][y]
      end
    end
    for y=1, up do
      self.tiles[x][y]=nil
    end
  end
  self.width=self.width+left+right
  self.height=self.height+up+down
end

function Grid:setTile(x, y, asset)
  safety.ensureNumber(x, "x")
  safety.ensureNumber(y, "y")
  if (x<1 or x>self.width) then
    error("X must be within the grid bounds of 1 and " .. self.width)
  end
  if (y<1 or y>self.height) then
    error("Y must be within the grid bounds of 1 and " .. self.height)
  end
  safety.ensureInstanceType(asset, AssetManager.getAssetClass(), "asset")
  self.tiles[x][y]=asset
end

function Grid:getTile(x, y)
  safety.ensureNumber(x, "x")
  safety.ensureNumber(y, "y")
  if (x<1 or x>self.width) then
    error("X must be within the grid bounds of 1 and " .. self.width)
  end
  if (y<1 or y>self.height) then
    error("Y must be within the grid bounds of 1 and " .. self.height)
  end
  return self.tiles[x][y]
end

function Grid:export()
  local out1= {}
  out1.tiles={}
  local out = out1.tiles
  for x=1, self.width do
    out[x]={}
    for y=1, self.height do
      if (self:getTile(x, y)) then
        out[x][y] = self:getTile(x, y):export()
      end
    end
  end
  out1.width=self.width
  out1.height=self.height
  return out1
end

function Grid:exportJSON()
  return json.encode(self:export())
end

function Grid.import(tbl)
  safety.ensureTable(tbl)
  local width=tbl.width
  local height=tbl.height
  local out = Grid(width, height)
  for x=1, width do
    for y=1, height do
      local success, asset = pcall(AssetManager.assembleAsset, tbl.tiles[x][y].category, tbl.tiles[x][y].id, tbl.tiles[x][y].data)
      out:setTile(x, y, asset)
    end
  end
  return out
end  
function Grid.importJSON(str)
  return Grid.import(json.decode(str))
end
return Grid