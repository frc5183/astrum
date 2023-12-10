local class = require "lib.external.class"
local Button = require "lib.gui.mixin.Button"
local Rectangle = require "lib.gui.mixin.RoundRectangle"
local safety = require "lib.safety"
local Base = require "lib.gui.element.Base"
---@class Checkbox : Base, Button, Rectangle
---@overload fun(x:number, y:number, width:number, height:number, color:Color, internalcolor:Color, selectedcolor:Color):Checkbox
local Checkbox = class("Checkbox", Base)
Checkbox:include(Button)
Checkbox:include(Rectangle)
--- A checkbox is an implentation of Button than contains a Rectangle as a background and switches states when clicked between selected and unselected
---@param x number
---@param y number
---@param width integer
---@param height integer
---@param color Color
---@param internalcolor Color
---@param selectedcolor Color
function Checkbox:initialize(x, y, width, height, color, internalcolor,
                             selectedcolor)
  safety.ensureNumber(x, "x")
  safety.ensureNumber(y, "y")
  safety.ensureNumberOver(width, 0, "width")
  safety.ensureNumberOver(height, 0, "height")
  safety.ensureColor(color, "color")
  safety.ensureColor(internalcolor, "internalcolor")
  safety.ensureColor(selectedcolor, "selectedcolor")
  self:initButton(x, y, width, height)
  self:initRectangle(x, y, width, height, color, internalcolor)
  self.selectedcolor = selectedcolor
  self.normalcolor = internalcolor
  self.selected = false
  self:onClick(function(pt, button, presses)
    if (self:contains(pt) and button == 1) then
      self.selected = not self.selected
      if (self.selected) then
        self.int_color = self.selectedcolor
      else
        self.int_color = self.normalcolor
      end
    end
  end)
end
--- Draws the Checkbox
function Checkbox:draw() self:drawRectangle() end
---Checks if the checkbox is selected.
---@return boolean: true if the checkbox is selected, false otherwise.
function Checkbox:isSelected() return self.selected end
return Checkbox
