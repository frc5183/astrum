local safety = require"lib.safety"
local assets = {}
local asset_manager = {}
local class = require"lib.external.class"
local Asset = class("Asset")
function Asset:initialize(category, id)
  safety.ensureString(category, "category")
  safety.ensureString(id, "id")
  self.category=category
  self.id=id
  self.data={}
end
function Asset:getAsset()
  return assets[self.category][self.id]
end
function Asset:export()
  return {category=self.category, id=self.id, data=self.data}
end
function asset_manager.registerCategory(category)
  safety.ensureString(category, "category")
  if (assets[category]~=nil) then 
    error("Category Already Registered: " .. category)
  end
  assets[category]={}
end

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
function asset_manager.getAssetClass() return Asset end
return asset_manager