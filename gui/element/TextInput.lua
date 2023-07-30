-- Import
local class=require"lib.external.class"
local Color = require"lib.gui.color"
local Rectangle=require"lib.gui.mixin.RoundRectangle"
local safety=require"lib.safety"
local InputField = require"lib.external.InputField"
local TextInput=class"TextInput"
local FontCache=require"lib.gui.subsystem.FontCache"
local TextButton = require"lib.gui.element.TextButton"
local ClickOrigin = require"lib.gui.subsystem.ClickOrigin"
local math2 = require"lib.math2"
local scrollButton
local AdapterButton = require"lib.gui.element.AdapterButton"
local VisualButton = require"lib.gui.element.VisualButton"
local ActiveText
local clear = false
local count = 0
TextInput:include(Rectangle)
local list = {}
--- Creates a Text Input that uses a Rectangle as a background. pre() and post() are a must to use
-- @param x the x position
-- @param y the y position
-- @param width the input width
-- @param height the input height
-- @param color the button Color
-- @param text the default text
-- @param fontesize the fontsize
-- @param align the align mode
-- @param mode the TextInput mode
-- @param node the ClickNode. If left out, ClickOrigin is used as a default
-- @return the new TextInput
function TextInput:initialize(x, y, width, height, color, text, fontsize, align, mode, node)
  table.insert(list, self)
  safety.ensureNumber(x, "x")
  safety.ensureNumber(y, "y")
  safety.ensureNumberOver(width, 0, "width")
  safety.ensureNumberOver(height, 0, "height")
  safety.ensureColor(color, "color")
  safety.ensureString(text, "text")
  safety.ensureIntegerOver(fontsize, 0, "fontsize")
  safety.ensureString(align, "align")
  if (align~="left" and align ~="center" and align ~= "right") then
    error("Align must be a value of either: left, right, or center")
  end
  if (mode~=nil) then
    safety.ensureString(mode, "mode")
    if (mode~="normal" and mode~="password" and mode~="multiwrap" and mode~="multinowrap") then
      error("Mode must be a vlue of either: normal, password, multiwrap, or multinowrap. It also may optionally be omited, in which the default value of multiwrap will apply")
    end
    self.mode=mode
  else
    self.mode = "multiwrap"
  end
  if (node==nil) then
    node=ClickOrigin
  end
  safety.ensurePulse(node, "node")
  self.node=node
  count=count+1
  self:initRectangle(x, y, width, height, color, Color(0, 0, 0, 1))
  self.node:onEvent("onPress", "TextInput".. tostring(count), function (pt, button) 
    if button~=1 then return end
      local v=self
      if v.enabled and v.button:contains(pt) then
        clear=false
    end
    
  end)
  self.x=x
  self.y=y
  self.width=width
  self.height=height
  self.color=color
  self.text=text
  self.font=FontCache:getFont(fontsize)
  self.input = InputField(text, self.mode)
  self.input:setFont(self.font)
  self.input:setWidth(self.width- 2*math.min(self.width/8, self.height/8))
  self.input:setHeight(math.floor((self.height- 2*math.min(self.width/8, self.height/8))/self.font:getHeight())*self.font:getHeight())
  self.textCanvas=love.graphics.newCanvas(self.width- 2*math.min(self.width/8, self.height/8), math.floor((self.height- 2*math.min(self.width/8, self.height/8))/self.font:getHeight())*self.font:getHeight())
  self.button=AdapterButton(self.x+math.min(self.width/8, self.height/8), self.y+math.min(self.width/8, self.height/8), self.width- 2*math.min(self.width/8, self.height/8), math.floor((self.height- 2*math.min(self.width/8, self.height/8))/self.font:getHeight())*self.font:getHeight(), self.node)
  self.buttonPressFunc = (function (pt, button, presses) if self.button:contains(pt) then 
      if (love.system.getOS() == "Android" or love.system.getOS() == "iOS") then
      love.keyboard.setTextInput(true, self.button.x, self.button.y, self.button.width, self.button.height)
      
    end
    ActiveText=self
      self.input:mousepressed(pt.x-self.button.x, pt.y-self.button.y, button, presses) else self.input:releaseMouse() end end)
  self.buttonReleaseFunc = (function (pt, button, presses) if self.button:contains(pt) then self.input:mousereleased(pt.x-self.button.x, pt.y-self.button.y, button, presses) else self.input:releaseMouse() end end)
  self.upFunc = (function (pt, button, presses) if self.upButton:contains(pt) then self.input:keypressed("up", false) end end)
  self.leftFunc = (function (pt, button, presses) if self.leftButton:contains(pt) then self.input:keypressed("left", false) end end)
  self.rightFunc = (function (pt, button, presses) if self.rightButton:contains(pt) then self.input:keypressed("right", false) end end)
  self.downFunc = (function (pt, button, presses) if self.downButton:contains(pt) then self.input:keypressed("down", false) end end)
  local min8 = math.min(self.width/8, self.height/8)
  
  self.upButton = VisualButton(self.x+min8, self.y, self.width-(2*min8), min8, Color(color.r*0.5, color.g*0.5, color.b*0.5, color.a), self.node)
  self.downButton = VisualButton(self.x+min8, self.y+self.height-(min8), self.width-(2*min8), min8, Color(color.r*0.5, color.g*0.5, color.b*0.5, color.a), self.node)
  self.leftButton = VisualButton(self.x, self.y+min8, min8, self.height-(2*min8), Color(color.r*0.5, color.g*0.5, color.b*0.5, color.a), self.node)
  self.rightButton = VisualButton(self.x+self.width-(min8), y+min8, min8, self.height-(2*min8), Color(color.r*0.5, color.g*0.5, color.b*0.5, color.a), self.node)
  
  self.enabled=false
end
--- Enables the TextInput
function TextInput:enable()
  self.pressid=self.button:onPress(self.buttonPressFunc)
  self.releaseid=self.button:onClick(self.buttonReleaseFunc)
  self.upid = self.upButton:onPress(self.upFunc)
  self.downid = self.downButton:onPress(self.downFunc)
  self.leftid = self.leftButton:onPress(self.leftFunc)
  self.rightid = self.rightButton:onPress(self.rightFunc)
  self.enabled=true
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
  self.pressid=nil
  self.releaseid=nil
  self.enabled=false
  end
end
-- Draws the TextInput
function TextInput:draw()
  if (self.enabled) then
    self:drawRectangle()
    self.upButton:draw()
    self.downButton:draw()
    self.leftButton:draw()
    self.rightButton:draw()
    local oldCanvas = love.graphics.getCanvas()
    love.graphics.setCanvas(self.textCanvas)
    love.graphics.clear()
    love.graphics.setColor(0, 0, 1)
		for _, x, y, w, h in self.input:eachSelection() do
			love.graphics.rectangle("fill", x, y, w, h)
		end
    local oldFont = love.graphics.getFont()
    love.graphics.setFont(self.font)
		love.graphics.setColor(1, 1, 1)
		for _, text, x, y in self.input:eachVisibleLine() do
			love.graphics.print(text, x, y)
		end
    love.graphics.setFont(oldFont)
		local x, y, h = self.input:getCursorLayout()
		love.graphics.rectangle("fill", x, y, 1, h)
	
    
    love.graphics.setCanvas(oldCanvas)
    love.graphics.draw(self.textCanvas, self.button.x, self.button.y, 0, self.sx or 1, self.sy or 1)
  end
end
--- MouseMoved callback
-- @param x the mouse x coordinate
-- @param y the mouse y coordine
function TextInput:mousemoved(x, y)
  if (self.enabled) then
    self.input:mousemoved(x-self.button.x, y-self.button.y)
  end
end
--- WheelMoved callback
-- @param dx the change in x
-- @param dy the change in y
function TextInput:wheelmoved(dx, dy)
  local go = true
  if (love.system.getOS() == "Windows" or love.system.getOS() == "Linux" or love.system.getOS() == "OS X") then
    local x, y = love.mouse.getPosition()
    x=x or -1
    y=y or -1
    local go = self.button:contains(math2.Point2D(x, y)) 
  end
  
  if (self.enabled) then
    self.input:wheelmoved(dx, dy)
  end
end
--- KeyPressed callback
-- @param key the pressed key
-- @param scancode the key scancode
-- @param isRepeat whether it is a repeat press
function TextInput:keypressed(key, scancode, isRepeat)
  if (self.enabled and ActiveText==self) then
    self.input:keypressed(key, isRepeat)
  end
end
--- TextInput callback
-- @param text the input text
function TextInput:textinput(text)
  if (self.enabled and ActiveText==self) then
    self.input:textinput(text)
  end
end
--- Update callback
-- @param dt the change in time
function TextInput:update(dt)
  if (self.enabled and ActiveText==self) then
    self.input:update(dt)
  end
end
--- Returns the typed text
-- @return the type text
function TextInput:getText()
  return self.input:getText()
end
--- Sets the text
-- @param text the text to set
function TextInput:setText(text)
  safety.ensureString(text, "text")
  self.input:setText(text)
end
--- To be run before ClickOrigin:onPress()
function TextInput.pre()
  clear = true
end
--- To be run after ClickOrigin:onPress()
function TextInput.post()
  if (clear and (love.system.getOS()=="Android" or love.system.getOS() == "iOS")) then
    love.keyboard.setTextInput(false)
  end
  if (clear) then
    ActiveText=nil
  end
end

return TextInput