---@module 'lib.gui.element.Container'
local Container = require "lib.gui.element.Container"
---@module 'lib.safety'
local safety = require "lib.safety"
---@module 'lib.math2'
local math2 = require "lib.math2"
---@module 'lib.grid'
local Grid = require "lib.grid"
---@module 'lib.gui.color'
local Color = require "lib.gui.color"
---@module 'lib.gui.element.TextButton'
local TextButton = require "lib.gui.element.TextButton"
---@module 'lib.gui.element.TextRectangle'
local TextRectangle = require "lib.gui.element.TextRectangle"
---@module 'lib.gui.element.TextInput'
local TextInput = require "lib.gui.element.TextInput"
---@module 'lib.gui.element.VisualButton'
local VisualButton = require "lib.gui.element.VisualButton"
---@module 'lib.gui.element.AdapterButton'
local AdapterButton = require "lib.gui.element.AdapterButton"
---@module 'lib.gui.element.Checkbox'
local Checkbox = require "lib.gui.element.Checkbox"
---@module 'lib.gui.element.ScrollBar'
local ScrollBar = require "lib.gui.element.ScrollBar"
---@module 'lib.external.class'
local class = require "lib.external.class"

---@class Grider
---@overload fun(x:integer, y:integer, tilewidth:integer, tileheight:integer, xspacing:integer, yspacing:integer, gridwidth:integer, gridheight:integer, color:Color, extendmode:"down"|"right"|"error"|"alternate", twidth:integer, theight:integer):Grider
local Grider = class("Grider")
---@param x integer
---@param y integer
---@param tilewidth integer
---@param tileheight integer
---@param xspacing integer
---@param yspacing integer
---@param gridwidth integer
---@param gridheight integer
---@param color Color
---@param extendmode "down"|"right"|"error"|"alternate"
---@param twidth integer|nil
---@param theight integer|nil
function Grider:initialize(x, y, tilewidth, tileheight, xspacing, yspacing,
                           gridwidth, gridheight, color, extendmode, twidth,
                           theight)
  safety.ensureInteger(x, "x")
  safety.ensureInteger(y, "y")
  safety.ensureIntegerOver(tilewidth, 0, "tilewidth")
  safety.ensureIntegerOver(tileheight, 0, "tileheight")
  safety.ensureIntegerOver(xspacing, -1, "xspacing")
  safety.ensureIntegerOver(yspacing, -1, "yspacing")
  safety.ensureIntegerOver(gridwidth, 0, "gridwidth")
  safety.ensureIntegerOver(gridheight, 0, "gridheight")
  safety.ensureColor(color, "color")
  safety.ensureString(extendmode, "extendmode")
  assert(
    extendmode == "down" or extendmode == "right" or extendmode == "error" or
      extendmode == "alternate",
    "You must include a valid extendmode: dowm, right, error, alternate")
  if (twidth) then
    safety.ensureIntegerOver(twidth, 0, "twidth")
  else
    twidth = (tilewidth + xspacing) * gridwidth - xspacing
  end
  if (theight) then
    safety.ensureIntegerOver(theight, 0, "theight")
  else
    theight = (tileheight + yspacing) * gridheight - yspacing
  end
  self.grid = Grid(gridwidth, gridheight)
  self.container = Container(x, y, twidth, theight, color,
                             (tilewidth + xspacing) * gridwidth - xspacing,
                             (tileheight + yspacing) * gridheight - yspacing)
  self.tilewidth = tilewidth
  self.tileheight = tileheight
  self.xspacing = xspacing
  self.yspacing = yspacing
  self.color = color
  self.extendmode = extendmode
  if extendmode == "alternate" then self.aextendmode = "down" end
  self.twidth = twidth
  self.theight = theight
end
--- Automatically finds a space in the grid for a room of a certain size, and expands if needed
---@param xwidth integer
---@param yheight integer
---@return integer, integer
function Grider:ClearRoom(xwidth, yheight)
  safety.ensureIntegerOver(xwidth, 0, "xwidth")
  safety.ensureIntegerOver(yheight, 0, "yheight")
  for x, y, tile in self.grid:iter() do
    local clear = true
    local b = false
    if (tile == nil) then
      for dx = x, x + xwidth - 1 do
        for dy = y, y + yheight - 1 do
          if self.grid:get(dx, dy) ~= nil then
            clear = false
            b = true
          end
          if b then break end
        end
        if b then break end
      end
    else
      clear = false
    end
    if clear then return x, y end
  end
  if (self.extendmode == "error") then
    error("No space for room in Grider")
  elseif (self.extendmode == "down") then
    self.grid:extend(0, 1, 0, 0)
    self.container:expand(0, self.tileheight + self.yspacing)
  elseif (self.extendmode == "right") then
    self.grid:extend(0, 0, 0, 1)
    self.container:expand(self.tilewidth + self.xspacing, 0)
  elseif (self.extendmode == "alternate") then
    if (self.aextendmode == "down") then
      self.grid:extend(0, 1, 0, 0)
      self.container:expand(0, self.tileheight + self.yspacing)
      self.aextendmode = "right"
    else
      self.grid:extend(0, 0, 0, 1)
      self.container:expand(self.tilewidth + self.xspacing, 0)
      self.aextendmode = "down"
    end
  end
  return self:ClearRoom(xwidth, yheight)
end
--- Creates a TextInput in the grid
---@param xwidth integer
---@param yheight integer
---@param color Color
---@param text string
---@param fontsize number
---@param align "left"|"center"|"right"
---@param mode "normal"|"password"|"multiwrap"|"multinowrap"
---@param textcolor Color
---@param internalcolor Color
---@return TextInput
function Grider:TextInput(xwidth, yheight, color, text, fontsize, align, mode,
                          textcolor, internalcolor)
  safety.ensureIntegerOver(xwidth, 0, "xwidth")
  safety.ensureIntegerOver(yheight, 0, "yheight")
  local ox, oy = self:ClearRoom(xwidth, yheight)
  local owidth = (self.tilewidth + self.xspacing) * xwidth - self.xspacing
  local oheight = (self.tileheight + self.yspacing) * yheight - self.yspacing
  local t = TextInput(((self.tilewidth + self.xspacing) * (ox - 1)),
                      ((self.tileheight + self.yspacing) * (oy - 1)), owidth,
                      oheight, color, text, fontsize, align, mode, textcolor,
                      internalcolor)
  for x = ox, ox + xwidth - 1 do
    for y = oy, oy + yheight - 1 do self.grid:set(x, y, t) end
  end
  self.container:add(t)
  return t
end
--- Creates a AdapterButton in the grid
---@param xwidth integer
---@param yheight integer
---@return AdapterButton
function Grider:AdapterButton(xwidth, yheight)
  safety.ensureIntegerOver(xwidth, 0, "xwidth")
  safety.ensureIntegerOver(yheight, 0, "yheight")
  local ox, oy = self:ClearRoom(xwidth, yheight)
  local owidth = (self.tilewidth + self.xspacing) * xwidth - self.xspacing
  local oheight = (self.tileheight + self.yspacing) * yheight - self.yspacing
  local t = AdapterButton(((self.tilewidth + self.xspacing) * (ox - 1)),
                          ((self.tileheight + self.yspacing) * (oy - 1)),
                          owidth, oheight)
  for x = ox, ox + xwidth - 1 do
    for y = oy, oy + yheight - 1 do self.grid:set(x, y, t) end
  end
  self.container:add(t)
  return t
end
--- Creates a Checkbox in the grid
---@param xwidth integer
---@param yheight integer
---@param color Color
---@param internalcolor Color
---@param selectedcolor Color
---@return Checkbox
function Grider:Checkbox(xwidth, yheight, color, internalcolor, selectedcolor)
  safety.ensureIntegerOver(xwidth, 0, "xwidth")
  safety.ensureIntegerOver(yheight, 0, "yheight")
  local ox, oy = self:ClearRoom(xwidth, yheight)
  local owidth = (self.tilewidth + self.xspacing) * xwidth - self.xspacing
  local oheight = (self.tileheight + self.yspacing) * yheight - self.yspacing
  local t = Checkbox(((self.tilewidth + self.xspacing) * (ox - 1)),
                     ((self.tileheight + self.yspacing) * (oy - 1)), owidth,
                     oheight, color, internalcolor, selectedcolor)
  for x = ox, ox + xwidth - 1 do
    for y = oy, oy + yheight - 1 do self.grid:set(x, y, t) end
  end
  self.container:add(t)
  return t
end
--- Creates a Grider in the grid
---@param xwidth integer
---@param yheight integer
---@param tilewidth integer
---@param tileheight integer
---@param xspacing integer
---@param yspacing integer
---@param gridwidth integer
---@param gridheight integer
---@param color Color
---@param extendmode "down"|"right"|"error"|"alternate"
---@return Grider
function Grider:Grider(xwidth, yheight, tilewidth, tileheight, xspacing,
                       yspacing, gridwidth, gridheight, color, extendmode)
  safety.ensureIntegerOver(xwidth, 0, "xwidth")
  safety.ensureIntegerOver(yheight, 0, "yheight")
  local ox, oy = self:ClearRoom(xwidth, yheight)
  local owidth = (self.tilewidth + self.xspacing) * xwidth - self.xspacing
  local oheight = (self.tileheight + self.yspacing) * yheight - self.yspacing
  local t = Grider(((self.tilewidth + self.xspacing) * (ox - 1)),
                   ((self.tileheight + self.yspacing) * (oy - 1)), tilewidth,
                   tileheight, xspacing, yspacing, gridwidth, gridheight, color,
                   extendmode, owidth, oheight)
  for x = ox, ox + xwidth - 1 do
    for y = oy, oy + yheight - 1 do self.grid:set(x, y, t) end
  end
  self.container:add(t)
  return t
end
--- Creates a ScrollBar in the grid
---@param xwidth integer
---@param yheight integer
---@param percentage number
---@param color Color
---@param isVertical boolean
---@return ScrollBar
function Grider:ScrollBar(xwidth, yheight, percentage, color, isVertical)
  safety.ensureIntegerOver(xwidth, 0, "xwidth")
  safety.ensureIntegerOver(yheight, 0, "yheight")
  local ox, oy = self:ClearRoom(xwidth, yheight)
  local owidth = (self.tilewidth + self.xspacing) * xwidth - self.xspacing
  local oheight = (self.tileheight + self.yspacing) * yheight - self.yspacing
  local t = ScrollBar(((self.tilewidth + self.xspacing) * (ox - 1)),
                      ((self.tileheight + self.yspacing) * (oy - 1)), owidth,
                      oheight, percentage, color, isVertical)
  for x = ox, ox + xwidth - 1 do
    for y = oy, oy + yheight - 1 do self.grid:set(x, y, t) end
  end
  self.container:add(t)
  return t
end
--- Creates a TextButton in the grid
---@param xwidth integer
---@param yheight integer
---@param color Color
---@param text string
---@param fontsize number
---@param align "left"|"center"|"right"
---@param textcolor Color
---@param internalcolor Color|nil
---@return TextButton
function Grider:TextButton(xwidth, yheight, color, text, fontsize, align,
                           textcolor, internalcolor)
  safety.ensureIntegerOver(xwidth, 0, "xwidth")
  safety.ensureIntegerOver(yheight, 0, "yheight")
  local ox, oy = self:ClearRoom(xwidth, yheight)
  local owidth = (self.tilewidth + self.xspacing) * xwidth - self.xspacing
  local oheight = (self.tileheight + self.yspacing) * yheight - self.yspacing
  local t = TextButton(((self.tilewidth + self.xspacing) * (ox - 1)),
                       ((self.tileheight + self.yspacing) * (oy - 1)), owidth,
                       oheight, color, text, fontsize, align, textcolor,
                       internalcolor)
  for x = ox, ox + xwidth - 1 do
    for y = oy, oy + yheight - 1 do self.grid:set(x, y, t) end
  end
  self.container:add(t)
  return t
end
--- Creates a TextRectangle in the grid
---@param xwidth integer
---@param yheight integer
---@param color Color
---@param text string
---@param fontsize number
---@param align "left"|"center"|"right"
---@param textcolor Color
---@param internalcolor Color|nil
---@return TextRectangle
function Grider:TextRectangle(xwidth, yheight, color, text, fontsize, align,
                              textcolor, internalcolor)
  safety.ensureIntegerOver(xwidth, 0, "xwidth")
  safety.ensureIntegerOver(yheight, 0, "yheight")
  local ox, oy = self:ClearRoom(xwidth, yheight)
  local owidth = (self.tilewidth + self.xspacing) * xwidth - self.xspacing
  local oheight = (self.tileheight + self.yspacing) * yheight - self.yspacing
  local t = TextRectangle(((self.tilewidth + self.xspacing) * (ox - 1)),
                          ((self.tileheight + self.yspacing) * (oy - 1)),
                          owidth, oheight, color, text, fontsize, align,
                          textcolor, internalcolor)
  for x = ox, ox + xwidth - 1 do
    for y = oy, oy + yheight - 1 do self.grid:set(x, y, t) end
  end
  self.container:add(t)
  return t
end
--- Creates a VisualButton in the grid
---@param xwidth any
---@param yheight any
---@param color any
---@param internalcolor any
---@return VisualButton
function Grider:VisualButton(xwidth, yheight, color, internalcolor)
  safety.ensureIntegerOver(xwidth, 0, "xwidth")
  safety.ensureIntegerOver(yheight, 0, "yheight")
  local ox, oy = self:ClearRoom(xwidth, yheight)
  local owidth = (self.tilewidth + self.xspacing) * xwidth - self.xspacing
  local oheight = (self.tileheight + self.yspacing) * yheight - self.yspacing
  local t = VisualButton(((self.tilewidth + self.xspacing) * (ox - 1)),
                         ((self.tileheight + self.yspacing) * (oy - 1)), owidth,
                         oheight, color, internalcolor)
  for x = ox, ox + xwidth - 1 do
    for y = oy, oy + yheight - 1 do self.grid:set(x, y, t) end
  end
  self.container:add(t)
  return t
end
--- Draws all grid elements
function Grider:draw() self.container:draw() end
--- Updates all grid elements
---@param dt number
---@param pt Point2D
function Grider:update(dt, pt) self.container:update(dt, pt) end
--- Textinputs all grid elements
---@param text string
function Grider:textinput(text) self.container:textinput(text) end
--- Mousemoves all grid elements
---@param x number
---@param y number
---@param dx number
---@param dy number
---@param istouch boolean
function Grider:mousemoved(x, y, dx, dy, istouch)
  self.container:mousemoved(x, y, dx, dy, istouch)
end
--- Keypresses all grid elements
---@param key string
---@param scancode string
---@param isrepeat boolean
function Grider:keypressed(key, scancode, isrepeat)
  self.container:keypressed(key, scancode, isrepeat)
end
--- Wheelmoves all grid elements
---@param dx number
---@param dy number
---@param x number
---@param y number
function Grider:wheelmoved(dx, dy, x, y) self.container:wheelmoved(dx, dy, x, y) end
--- Presses all grid elements
---@param pt Point2D
---@param button number
---@param presses number
function Grider:press(pt, button, presses)
  self.container:press(pt, button, presses)
end
--- Clicks all grid elements
---@param pt Point2D
---@param button number
---@param presses number
function Grider:click(pt, button, presses)
  self.container:click(pt, button, presses)
end

return Grider
