-- Imports
local safety = require"lib.safety"
local assets = {}
local asset_manager = {}
local class = require"lib.external.class"
local Asset = class("Asset")
--- An Asset to be returned by AssetManager
-- The Idea is that Assets can be serialized while maintaining their link to their asset contents when reloaded
-- the Asset.data may also be used to persist data in an instance of Asset through serialization. 
-- @param category the string category where the asset is contained within the assetmanager
-- @param id the string id within the category where the asset is found
-- @returnt the asset object
function Asset:initialize(category, id)
  safety.ensureString(category, "category")
  safety.ensureString(id, "id")
  self.category=category
  self.id=id
  self.data={}
end
--- Returns the actual digital asset from the asset_manager
-- @return the actual asset
function Asset:getAsset()
  return assets[self.category][self.id]
end
--- Declassifies the Asset, useful for serialization
-- @return the declassified asset
function Asset:export()
  return {category=self.category, id=self.id, data=self.data}
end
--- Registers a category within the asset_manager, with strict duplicate checking
-- @param the string category to register
function asset_manager.registerCategory(category)
  safety.ensureString(category, "category")
  if (assets[category]~=nil) then 
    error("Category Already Registered: " .. category)
  end
  assets[category]={}
end
--- Registers an asset within a registered category, with strict duplicate and required registerd category
-- @param category the REGISTERED category
-- @param id the id to register
-- @param asset the asset to which the category+id refers
function asset_manager.registerAsset(category, id, asset)
  safety.ensureString(category, "category")
  safety.ensureString(id, "id")
  if (assets[category]==nil) then
    error("Unregistered Category: " .. category)
  end
  if (assets[category][id]~=nil) then
    error("Already Registered Asset within Category (" .. category .. "): " .. id)
  end
  if (asset==nil) then
    error("Must not include nil asset. Assets should not be unregistered via registerAsset but instead removeAsset")
  end
  assets[category][id]=asset
end
--- Removes an asset within a registered category, with strict duplicate and required registerd category
-- @param category the REGISTERED category
-- @param id the id to register
function asset_manager.removeAsset(category, id)
  safety.ensureString(category, "category")
  safety.ensureString(id, "id")
  if (assets[category]==nil) then
    error("Unregistered Category: " .. category)
  end
  if (assets[category][id]==nil) then 
    error("Cannot remove non-existant asset within Category (" .. category .. "): " .. id)
  end
  assets[category][id]=nil
end
--- Fetches an asset with the category and id, with strict registration requirements
-- @param category the REGISTERED category
-- @param id the REGISTERED id-asset
-- @return a NEW asset instance for that registered asset
function asset_manager.fetchAsset(category, id)
  safety.ensureString(category, "category")
  safety.ensureString(id, "id")
  if (assets[category]==nil) then
    error("Unregistered Category: " .. category)
  end
  if (assets[category][id]==nil) then 
    error("Cannot fetch non-existant asset within Category (" .. category .. "): " .. id)
  end
  return Asset(category, id)
end
--- Assembles an asset with existing data, and a registerd category and id
-- Useful for Deserialization
-- @param category the REGISTERED category
-- @param id the REGISTERED id-asset
-- @param data the nullable data to assemble the asset with
-- @return the new reassembled Asset instance
function asset_manager.assembleAsset(category, id, data)
  safety.ensureString(category, "category")
  safety.ensureString(id, "id")
  if (type(data)~="nil") then
    safety.ensureTable(data, "data")
  end
  if (assets[category]==nil) then
    error("Unregistered Category: " .. category)
  end
  if (assets[category][id]==nil) then 
    error("Cannot fetch non-existant asset within Category (" .. category .. "): " .. id)
  end
  local out = Asset(category, id)
  out.data=data or {}
  return out
end
--- Returns the Asset class for rare needs for it 
-- @return the Asset class
function asset_manager.getAssetClass() return Asset end
-- Return
return asset_manager