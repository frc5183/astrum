local Container = require "lib.gui.element.Container"
local safety = require "lib.safety"
local math2 = require "lib.math2"
local Grid = require "lib.grid"
local Color = require "lib.gui.color"
local TextButton = require "lib.gui.element.TextButton"
local TextRectangle = require "lib.gui.element.TextRectangle"
local TextInput = require "lib.gui.element.TextInput"
local VisualButton = require "lib.gui.element.VisualButton"
local AdapterButton = require "lib.gui.element.AdapterButton"
local Checkbox = require "lib.gui.element.Checkbox"
local ScrollBar = require "lib.gui.element.ScrollBar"
local class = require "lib.external.class"

---@class Grider
local Grider = class("Grider")

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

function Grider:TextInput(xwidth, yheight, color, text, fontsize, align,
                          textcolor, internalcolor)
  safety.ensureIntegerOver(xwidth, 0, "xwidth")
  safety.ensureIntegerOver(yheight, 0, "yheight")
  local ox, oy = self:ClearRoom(xwidth, yheight)
  local owidth = (self.tilewidth + self.xspacing) * xwidth - self.xspacing
  local oheight = (self.tileheight + self.yspacing) * yheight - self.yspacing
  local t = TextInput(((self.tilewidth + self.xspacing) * (ox - 1)),
                      ((self.tileheight + self.yspacing) * (oy - 1)), owidth,
                      oheight, color, text, fontsize, align, textcolor,
                      internalcolor)
  for x = ox, ox + xwidth - 1 do
    for y = oy, oy + yheight - 1 do self.grid:set(x, y, t) end
  end
  self.container:add(t)
  return t
end

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

function Grider:TextRectangle(xwidth, yheight, color, text, fontsize, align,
                              textcolor, internalcolor)
  safety.ensureIntegerOver(xwidth, 0, "xwidth")
  safety.ensureIntegerOver(yheight, 0, "yheight")
  local ox, oy = self:ClearRoom(xwidth, yheight)
  print(ox, oy)
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

function Grider:draw() self.container:draw() end

function Grider:update(dt, pt) self.container:update(dt, pt) end

function Grider:textinput(text) self.container:textinput(text) end

function Grider:mousepressed(pt, button, presses)
  self.container:mousepressed(pt, button, presses)
end

function Grider:mousemoved(pt, dx, dy, istouch)
  self.container:mousemoved(pt, dx, dy, istouch)
end

function Grider:keypressed(key, scancode, isrepeat)
  self.container:keypressed(key, scancode, isrepeat)
end

function Grider:wheelmoved(dx, dy, x, y) self.container:wheelmoved(dx, dy, x, y) end

function Grider:press(pt, button, presses)
  self.container:press(pt, button, presses)
end

function Grider:click(pt, button, presses)
  self.container:click(pt, button, presses)
end

return Grider
