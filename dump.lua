local depth = 0
--- Returns the length of a table
---@param t table
---@return number
local function tablelength(t)
    local count = 0
    for k, v in pairs(t) do
        count = count + 1
    end
    return count
end
--- Recursively iterates over any data structure and represents it in as much detail as possible
---@param o any
---@param i boolean|nil
---@param disable_tostr boolean|nil
---@return string
local function dump2(o, i, disable_tostr)
    local tostr = disable_tostr
    depth = depth + 1
    if depth == 1 then i = true end
    if type(o) == 'table' then
        ---[[
        if o.__tostring and not tostr then
            depth = depth - 1
            local l = tostring(o)
            if type(o) == 'string' then l = '"' .. l .. '"' end
            if not i then l = l .. ',' end
            return l
        end
        --]]
        local s = "\n" .. string.rep('	', depth - 1) .. '{ \n'
        local count = 0
        local skip = false
        if o.__index then s = s .. string.rep('	', depth) .. '["__index"] = ' .. tostring(o.__index) .. '\n' end
        for k, v in pairs(o) do
            skip = false
            if k == '__index' then skip = true end
            if k == '_G' then skip = true end
            if v == package.loaded then skip = true end
            if not skip then
                local u = false
                count = count + 1
                if count == tablelength(o) then u = true end
                if type(k) ~= 'number' then k = '"' .. k .. '"' end
                s = s .. string.rep('	', depth) .. '[' .. k .. '] = ' .. dump2(v, u, tostr) .. '\n'
            end
        end
        depth = depth - 1
        local l = s .. string.rep('	', depth) .. '}'
        if not i then l = l .. ', ' end
        return l
    else
        depth = depth - 1
        local l = tostring(o)
        if type(o) == 'string' then l = '"' .. l .. '"' end
        if not i then l = l .. ',' end
        return l
    end
end
local d = {
    dump2 = dump2,
    dump = function(...)
        print(dump2(...))
    end
}
local dmt = { __call = d.dump }
setmetatable(d, dmt)
return d
