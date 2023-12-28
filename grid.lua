local class = require "lib.external.class"
local safety = require "lib.safety"
---@class Grid
local Grid = class("Grid")

--- A grid of cells
---@param width integer
---@param height integer
function Grid:initialize(width, height)
    safety.ensureIntegerOver(width, 0, "width")
    safety.ensureIntegerOver(height, 0, "height")
    self.grid = {}
    for h = 1, height do
        self.grid[h] = {}
    end
    self.width = width
    self.height = height
end

--- Sets a value of a single cell in the grid
---@param x integer
---@param y integer
---@param value any
function Grid:set(x, y, value)
    safety.ensureIntegerOver(x, 0, "x")
    safety.ensureIntegerOver(y, 0, "y")
    assert(x <= self.width, "x is out of bounds")
    assert(y <= self.height, "y is out of bounds")
    self.grid[y][x] = value
end

--- Gets a value of a single cell in the grid
---@param x integer
---@param y integer
---@return any
function Grid:get(x, y)
    safety.ensureIntegerOver(x, 0, "x")
    safety.ensureIntegerOver(y, 0, "y")
    assert(x <= self.width, "x is out of bounds")
    assert(y <= self.height, "y is out of bounds")
    return self.grid[y][x]
end

--- Extends the grid by a certain amount up, down, left, and right
---@param up integer
---@param down integer
---@param left integer
---@param right integer
function Grid:extend(up, down, left, right)
    safety.ensureIntegerOver(up, -1, "up")
    safety.ensureIntegerOver(down, -1, "down")
    safety.ensureIntegerOver(left, -1, "left")
    safety.ensureIntegerOver(right, -1, "right")
    for _ = 1, up do
        table.insert(self.grid, 1, {})
        self.height = self.height + 1
    end
    for k = self.height + 1, self.height + down do
        table.insert(self.grid, k, {})
        self.height = self.height + 1
    end
    for _ = 1, left do
        for k = 1, self.height do
            table.insert(self.grid[k], 1, nil)
        end
        self.width = self.width + 1
    end
    self.width = self.width + right
end

--- Gets the width of the grid
---@return integer
function Grid:getWidth()
    return self.width
end

--- Gets the height of the grid
---@return integer
function Grid:getHeight()
    return self.height
end

--- Double iterates over the grid
---@return fun():integer, integer, any
function Grid:iter()
    local y = 1
    local x = 0
    return function()
        x = x + 1
        if x > self.width then -- Reset to next row
            x = 1
            y = y + 1
        end
        if y > self.height then -- End if run out
            ---@diagnostic disable-next-line: missing-return-value, return-type-mismatch fix stupid linter
            return nil
        end
        return x, y, self.grid[y][x]
    end
end

return Grid
