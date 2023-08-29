-- Imports
local Container = require "lib.gui.element.Container"
local Base = require "lib.gui.element.Base"
local safety = require "lib.safety"
local Color = require "lib.gui.color"
local TextButton = require "lib.gui.element.TextButton"
local TextInput = require "lib.gui.element.TextInput"
local AdapterButton = require "lib.gui.element.AdapterButton"
local ScrollBar = require "lib.gui.element.ScrollBar"
local VisualButton = require "lib.gui.element.VisualButton"
local TextRectangle = require "lib.gui.element.TextRectangle"
-- Assembler
---@param minimum integer the amount on the top of the List that will be left blank
---@param x number
---@param y number
---@param width integer
---@param height integer
---@param color Color
---@param spacing integer
return function(minimum, x, y, width, height, color, spacing)
    safety.ensureIntegerOver(minimum, -1, "minimum")
    safety.ensureNumber(x, "x")
    safety.ensureNumber(y, "y")
    safety.ensureIntegerOver(width, 0, "width")
    safety.ensureIntegerOver(height, 0, "height")
    safety.ensureColor(color, "color")
    safety.ensureIntegerOver(spacing, -1, "spacing")
    ---@type integer
    local twidth = 1
    ---@type integer
    local theight = minimum
    ---@type boolean
    local complete = false
    ---@type Container
    local container
    ---@type table
    local objects = {}
    ---@type table
    local out = {}
    ---@param obj Base
    local function add(obj)
        if (complete) then
            error("You have already constructed this list, you cannot add more")
        end
        safety.ensureInstanceType(obj, Base, "obj")
        table.insert(objects, obj)
        theight = theight + obj.height + spacing
        twidth = math.max(obj.width, twidth)
        print(theight, twidth)
    end

    ---@param width integer
    ---@param height integer
    ---@param color Color
    ---@param text string
    ---@param fontsize number
    ---@param align "left"|"center"|"right"
    function out.TextButton(width, height, color, text, fontsize, align)
        local t = TextButton(0, theight, width, height, color, text, fontsize, align)
        add(t)
        return t
    end

    ---@param width integer
    ---@param height integer
    ---@param color Color
    function out.VisualButton(width, height, color)
        local t = VisualButton(0, theight, width, height, color)
        add(t)
        return t
    end

    ---@param height integer
    ---@param width integer
    ---@param percentage number
    ---@param color Color
    ---@param isVertical boolean
    function out.ScrollBar(width, height, percentage, color, isVertical)
        local t = ScrollBar(0, theight, width, height, percentage, color, isVertical)
        add(t)
        return t
    end

    ---@param width integer
    ---@param height integer
    ---@param color Color
    ---@param twidth integer
    ---@param theight integer
    function out.Container(width, height, color, twidth, theight)
        local t = Container(0, theight, width, height, color, twidth, theight)
        add(t)
        return t
    end

    ---@param width integer
    ---@param height integer
    ---@param color Color
    ---@param text string
    ---@param fontsize integer
    ---@param align "left"|"center"|"right"
    ---@param mode "normal"|"password"|"multiwrap"|"multinowrap"|nil
    function out.TextInput(width, height, color, text, fontsize, align, mode)
        local t = TextInput(0, theight, width, height, color, text, fontsize, align, mode)
        add(t)
        return t
    end

    ---@param width integer
    ---@param height integer
    ---@param color Color
    ---@param text string
    ---@param fontsize number
    ---@param align "left"|"center"|"right"
    function out.TextRectangle(width, height, color, text, fontsize, align)
        local t = TextRectangle(0, theight, width, height, color, text, fontsize, align)
        add(t)
        return t
    end

    function out.construct()
        if (complete) then
            error("You have already constructed this list, you cannot add more")
        end
        local container = Container(x, y, width, height, color, math.max(twidth + 20, width),
            math.max(theight + 20, height))
        ---@param k integer
        ---@param v Base
        for k, v in ipairs(objects) do
            container:add(v)
        end
        complete = true
        return container
    end

    return out
end
