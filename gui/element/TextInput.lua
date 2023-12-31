-- Import
---@module 'lib.external.class'
local class = require "lib.external.class"
---@module 'lib.gui.color'
local Color = require "lib.gui.color"
---@module 'lib.gui.mixin.RoundRectangle'
local Rectangle = require "lib.gui.mixin.RoundRectangle"
---@module 'lib.safety'
local safety = require "lib.safety"
---@module 'lib.external.InputField'
local InputField = require "lib.external.InputField"
---@module 'lib.gui.element.Base'
local Base = require "lib.gui.element.Base"
---@class TextInput: Base, Rectangle
---@overload fun(x:number, y:number, width:integer, height:integer, color:Color, text:string, fontsize:number, align:"left"|"center"|"right", mode:"normal"|"password"|"multiwrap"|"multinowrap", textcolor:Color, internalcolor:Color|nil):TextInput
---@field x number
---@field y number
---@field width integer
---@field height integer
---@field color Color
---@field text string
---@field font love.Font
---@field input table
---@field textCanvas love.Canvas
---@field mode "normal"|"password"|"multiwrap"|"multinowrap"
---@field align "left"|"center"|"right"
---@field pressid number
---@field releaseid number
---@field upid number
---@field downid number
---@field leftid number
---@field rightid number
---@field buttonPressFunc function
---@field buttonReleaseFunc function
---@field upFunc function
---@field downFunc function
---@field leftFunc function
---@field rightFunc function
---@field button AdapterButton
---@field upButton VisualButton
---@field downButton VisualButton
---@field leftButton VisualButton
---@field rightButton VisualButton
local TextInput = class("TextInput", Base)
---@module 'lib.gui.subsystem.FontCache'
local FontCache = require "lib.gui.subsystem.FontCache"
---@module 'lib.math2'
local math2 = require "lib.math2"
---@module 'lib.gui.element.AdapterButton'
local AdapterButton = require "lib.gui.element.AdapterButton"
---@module 'lib.gui.element.VisualButton'
local VisualButton = require "lib.gui.element.VisualButton"
local ActiveText
---@type boolean
local clear = false
TextInput:include(Rectangle)
local list = {}
--- Creates a Text Input that uses a Rectangle as a background. pre() and post() are a must to use
---@param x number
---@param y number
---@param width integer
---@param height integer
---@param color Color
---@param text string
---@param fontsize integer
---@param align "left"|"center"|"right"
---@param mode "normal"|"password"|"multiwrap"|"multinowrap"|nil
---@param textcolor Color|nil
---@param internalcolor Color|nil
function TextInput:initialize(x, y, width, height, color, text, fontsize, align,
                              mode, textcolor, internalcolor)
  table.insert(list, self)
  safety.ensureNumber(x, "x")
  safety.ensureNumber(y, "y")
  safety.ensureIntegerOver(width, 0, "width")
  safety.ensureIntegerOver(height, 0, "height")
  safety.ensureColor(color, "color")
  safety.ensureString(text, "text")
  safety.ensureIntegerOver(fontsize, 0, "fontsize")
  safety.ensureString(align, "align")
  if (align ~= "left" and align ~= "center" and align ~= "right") then
    error("Align must be a value of either: left, right, or center")
  end
  if (mode ~= nil) then
    safety.ensureString(mode, "mode")
    if (mode ~= "normal" and mode ~= "password" and mode ~= "multiwrap" and mode ~=
      "multinowrap") then
      error(
        "Mode must be a vlue of either: normal, password, multiwrap, or multinowrap. It also may optionally be omited, in which the default value of multiwrap will apply")
    end
    self.mode = mode
  else
    self.mode = "multiwrap"
  end
  if (textcolor ~= nil) then
    safety.ensureColor(textcolor, "textcolor")
  else
    textcolor = Color(1, 1, 1, 1) -- White
  end
  if (internalcolor ~= nil) then
    safety.ensureColor(internalcolor, "internalcolor")
  else
    internalcolor = Color(0, 0, 0, 1) -- Black
  end
  self:initRectangle(x, y, width, height, color, internalcolor)
  self.x = x
  self.y = y
  self.width = width
  self.height = height
  self.color = color
  self.text = text
  self.font = FontCache:getFont(fontsize)
  self.input = InputField(text, self.mode)
  self.textcolor = textcolor
  self.input:setFont(self.font)
  self.input:setWidth(self.width - 2 * math.min(self.width / 8, self.height / 8))
  self.input:setHeight(math.floor((self.height - 2 *
                                    math.min(self.width / 8, self.height / 8)) /
                                    self.font:getHeight()) *
                         self.font:getHeight())
  self.textCanvas = love.graphics.newCanvas(self.width - 2 *
                                              math.min(self.width / 8,
                                                       self.height / 8),
                                            math.floor(
                                              (self.height - 2 *
                                                math.min(self.width / 8,
                                                         self.height / 8)) /
                                                self.font:getHeight()) *
                                              self.font:getHeight())
  self.button = AdapterButton(
                  self.x + math.min(self.width / 8, self.height / 8),
                  self.y + math.min(self.width / 8, self.height / 8),
                  self.width - 2 * math.min(self.width / 8, self.height / 8),
                  math.floor(
                    (self.height - 2 * math.min(self.width / 8, self.height / 8)) /
                      self.font:getHeight()) * self.font:getHeight())
  self.buttonPressFunc = (function(pt, button, presses)
    if self.button:contains(pt) then
      if (love.system.getOS() == "Android" or love.system.getOS() == "iOS") then
        love.keyboard.setTextInput(true, self.button.x, self.button.y,
                                   self.button.width, self.button.height)
      end
      ActiveText = self
      self.input:mousepressed(pt.x - self.button.x, pt.y - self.button.y,
                              button, presses)
    else
      self.input:releaseMouse()
    end
  end)
  self.buttonReleaseFunc = (function(pt, button, presses)
    if self.button:contains(pt) then
      self.input:mousereleased(pt.x - self.button.x, pt.y - self.button.y,
                               button, presses)
    else
      self.input:releaseMouse()
    end
  end)
  self.upFunc = (function(pt, button, presses)
    if self.upButton:contains(pt) then self.input:keypressed("up", false) end
  end)
  self.leftFunc = (function(pt, button, presses)
    if self.leftButton:contains(pt) then self.input:keypressed("left", false) end
  end)
  self.rightFunc = (function(pt, button, presses)
    if self.rightButton:contains(pt) then
      self.input:keypressed("right", false)
    end
  end)
  self.downFunc = (function(pt, button, presses)
    if self.downButton:contains(pt) then self.input:keypressed("down", false) end
  end)
  local min8 = math.min(self.width / 8, self.height / 8)

  self.upButton = VisualButton(self.x + min8, self.y, self.width - (2 * min8),
                               min8, Color(color.r * 0.5, color.g * 0.5,
                                           color.b * 0.5, color.a))
  self.downButton = VisualButton(self.x + min8, self.y + self.height - (min8),
                                 self.width - (2 * min8), min8, Color(
                                   color.r * 0.5, color.g * 0.5, color.b * 0.5,
                                   color.a))
  self.leftButton = VisualButton(self.x, self.y + min8, min8,
                                 self.height - (2 * min8), Color(color.r * 0.5,
                                                                 color.g * 0.5,
                                                                 color.b * 0.5,
                                                                 color.a))
  self.rightButton = VisualButton(self.x + self.width - (min8), y + min8, min8,
                                  self.height - (2 * min8), Color(color.r * 0.5,
                                                                  color.g * 0.5,
                                                                  color.b * 0.5,
                                                                  color.a))

  self.enabled = false
end

--- Enables the TextInput
function TextInput:enable()
  self.pressid = self.button:onPress(self.buttonPressFunc)
  self.releaseid = self.button:onClick(self.buttonReleaseFunc)
  self.upid = self.upButton:onPress(self.upFunc)
  self.downid = self.downButton:onPress(self.downFunc)
  self.leftid = self.leftButton:onPress(self.leftFunc)
  self.rightid = self.rightButton:onPress(self.rightFunc)
  self.enabled = true
end

--- Disables the TextInput
function TextInput:disable()
  if self.enabled then
    self.button:removeOnPress(self.pressid)
    self.button:removeOnClick(self.releaseid)
    self.upButton:removeOnPress(self.upid)
    self.downButton:removeOnPress(self.downid)
    self.leftButton:removeOnPress(self.leftid)
    self.rightButton:removeOnPress(self.rightid)
    self.pressid = nil
    self.releaseid = nil
    self.enabled = false
  end
end

-- Draws the TextInput
function TextInput:draw()
  if (self.enabled) then
    local oldmode, oldalphamode = love.graphics.getBlendMode()
    local r, g, b, a = love.graphics.getColor()
    love.graphics.setBlendMode("alpha", "premultiplied")
    self:drawRectangle()
    self.upButton:draw()
    self.downButton:draw()
    self.leftButton:draw()
    self.rightButton:draw()
    local ox, oy, owidth, oheight = love.graphics.getScissor()
    love.graphics.setScissor()
    local oldCanvas = love.graphics.getCanvas()
    love.graphics.setBlendMode(oldmode, oldalphamode)
    love.graphics.setCanvas(self.textCanvas)
    love.graphics.clear()
    love.graphics.setColor(0, 0, 1)
    for _, x, y, w, h in self.input:eachSelection() do
      love.graphics.rectangle("fill", x, y, w, h)
    end
    local oldFont = love.graphics.getFont()
    love.graphics.setFont(self.font)
    love.graphics.setColor(self.textcolor:unpack())
    for _, text, x, y in self.input:eachVisibleLine() do
      love.graphics.print(text, x, y)
    end
    love.graphics.setFont(oldFont)
    local x, y, h = self.input:getCursorLayout()
    love.graphics.rectangle("fill", x, y, 1, h)
    local oldmode, oldalphamode = love.graphics.getBlendMode()
    love.graphics.setColor(r, g, b, a)
    love.graphics.setCanvas(oldCanvas)
    love.graphics.setBlendMode("alpha", "premultiplied")
    love.graphics.setScissor(ox, oy, owidth, oheight)
    love.graphics.draw(self.textCanvas, self.button.x, self.button.y, 0,
                       self.sx or 1, self.sy or 1)
    love.graphics.setBlendMode(oldmode, oldalphamode)
  end
end

--- MouseMoved callback
---@param x number
---@param y number
---@param dx number
---@param dy number
---@param istouch boolean
function TextInput:mousemoved(x, y, dx, dy, istouch)
  if (self.enabled) then
    self.input:mousemoved(x - self.button.x, y - self.button.y)
  end
end

--- WheelMoved callback
---@param dx number
---@param dy number
---@param x number
---@param y number
function TextInput:wheelmoved(dx, dy, x, y)
  local go = true
  if (love.system.getOS() == "Windows" or love.system.getOS() == "Linux" or
    love.system.getOS() == "OS X") then
    x = x or -1
    y = y or -1
    go = self.button:contains(math2.Point2D(x, y))
  end

  if (self.enabled and go) then self.input:wheelmoved(dx, dy) end
end

--- KeyPressed callback
---@param key string
---@param scancode string
---@param isrepeat boolean
function TextInput:keypressed(key, scancode, isrepeat)
  if (self.enabled and ActiveText == self) then
    self.input:keypressed(key, isrepeat)
  end
end

--- TextInput callback
---@param text string
function TextInput:textinput(text)
  if (self.enabled and ActiveText == self) then self.input:textinput(text) end
end

--- Update callback
---@param dt number
---@param pt Point2D
function TextInput:update(dt, pt)
  if (self.enabled and ActiveText == self) then self.input:update(dt) end
end

--- Returns the typed text
---@return string
function TextInput:getText() return self.input:getText() end

--- Sets the text
---@param text string
function TextInput:setText(text)
  safety.ensureString(text, "text")
  self.input:setText(text)
end

---@param pt Point2D
---@param button number
---@param presses number
---@param ... any
function TextInput:press(pt, button, presses, ...)
  if button ~= 1 then return end
  if self.enabled and self.button:contains(pt) then clear = false end
  if (self.enabled) then
    self.button:press(pt, button, presses, ...)
    self.upButton:press(pt, button, presses, ...)
    self.downButton:press(pt, button, presses, ...)
    self.leftButton:press(pt, button, presses, ...)
    self.rightButton:press(pt, button, presses, ...)
  end
end

---@param pt Point2D
---@param button number
---@param presses number
---@param ... any
function TextInput:click(pt, button, presses, ...)
  if self.enabled and self.button:contains(pt) then
    self.button:click(pt, button, presses, ...)
  end
end

--- To be run before ClickOrigin:onPress()
function TextInput.pre() clear = true end

--- To be run after ClickOrigin:onPress()
function TextInput.post()
  if (clear and
    (love.system.getOS() == "Android" or love.system.getOS() == "iOS")) then
    love.keyboard.setTextInput(false)
  end
  if (clear) then ActiveText = nil end
end

return TextInput
