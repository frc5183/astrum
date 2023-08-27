-- Imports
local safety = require "lib.safety"
---@type table
local assets = {}
---@type table
local asset_manager = {}
local class = require "lib.external.class"
---@class Asset
---@field category string
---@field id string
---@field data table
---@overload fun(category:string, y:string):Asset
---@type Asset
local Asset = class("Asset")
--- An Asset to be returned by AssetManager
--- The Idea is that Assets can be serialized while maintaining their link to their asset contents when reloaded
--- the Asset.data may also be used to persist data in an instance of Asset through serialization.
---@param category string
---@param id string
function Asset:initialize(category, id)
  safety.ensureString(category, "category")
  safety.ensureString(id, "id")
  self.category = category
  self.id = id
  self.data = {}
end

--- Returns the actual digital asset from the asset_manager
---@return any
function Asset:getAsset()
  return assets[self.category][self.id]
end

--- Declassifies the Asset, useful for serialization
---@return {category:string, id:string, data:table}
function Asset:export()
  return { category = self.category, id = self.id, data = self.data }
end

--- Registers a category within the asset_manager, with strict duplicate checking
---@param category string
function asset_manager.registerCategory(category)
  safety.ensureString(category, "category")
  if (assets[category] ~= nil) then
    error("Category Already Registered: " .. category)
  end
  assets[category] = {}
end

--- Registers an asset within a registered category, with strict duplicate checking, and requires a registered Category via .registerCategory()
---@param category string
---@param id string
---@param asset any
function asset_manager.registerAsset(category, id, asset)
  safety.ensureString(category, "category")
  safety.ensureString(id, "id")
  if (assets[category] == nil) then
    error("Unregistered Category: " .. category)
  end
  if (assets[category][id] ~= nil) then
    error("Already Registered Asset within Category (" .. category .. "): " .. id)
  end
  if (asset == nil) then
    error("Must not include nil asset. Assets should not be unregistered via registerAsset but instead removeAsset")
  end
  assets[category][id] = asset
end

--- Removes strictly an existing asset within a registered category
---@param category string
---@param id string
function asset_manager.removeAsset(category, id)
  safety.ensureString(category, "category")
  safety.ensureString(id, "id")
  if (assets[category] == nil) then
    error("Unregistered Category: " .. category)
  end
  if (assets[category][id] == nil) then
    error("Cannot remove non-existant asset within Category (" .. category .. "): " .. id)
  end
  assets[category][id] = nil
end

--- Fetches an asset with the category and id, requring a registered category and a registered asset
---@param category string
---@param id string
---@return Asset
function asset_manager.fetchAsset(category, id)
  safety.ensureString(category, "category")
  safety.ensureString(id, "id")
  if (assets[category] == nil) then
    error("Unregistered Category: " .. category)
  end
  if (assets[category][id] == nil) then
    error("Cannot fetch non-existant asset within Category (" .. category .. "): " .. id)
  end
  return Asset(category, id)
end

--- Assembles an asset with existing data,  requring a registered category and a registered asset
--- Useful for Deserialization
---@param category string
---@param id string
---@param data table|nil
---@return Asset
function asset_manager.assembleAsset(category, id, data)
  safety.ensureString(category, "category")
  safety.ensureString(id, "id")
  if (type(data) ~= "nil") then
    safety.ensureTable(data, "data")
  end
  if (assets[category] == nil) then
    error("Unregistered Category: " .. category)
  end
  if (assets[category][id] == nil) then
    error("Cannot fetch non-existant asset within Category (" .. category .. "): " .. id)
  end
  local out = Asset(category, id)
  out.data = data or {}
  return out
end

--- Returns the Asset class for rare needs for it
---@return table
function asset_manager.getAssetClass() return Asset end

-- Return
return asset_manager
