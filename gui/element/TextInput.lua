local class=require"lib.external.class"
local Color = require"lib.gui.color"
local Rectangle=require"lib.gui.mixin.RoundRectangle"
local safety=require"lib.safety"
local InputField = require"lib.external.InputField"
local TextInput=class"TextInput"
local FontCache=require"lib.gui.subsystem.FontCache"
local TextButton = require"lib.gui.element.TextButton"
local ClickPulser = require"lib.gui.subsystem.ClickPulser"
local math2 = require"lib.math2"
local scrollButton
local AdapterButton = require"lib.gui.element.AdapterButton"
TextInput:include(Rectangle)
local list = {}
function TextInput:initialize(x, y, width, height, color, text, fontsize, align, mode)
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
  self:initRectangle(x, y, width, height, color, Color(0, 0, 0, 1))
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
  print()
  self.button=AdapterButton(self.x+math.min(self.width/8, self.height/8), self.y+math.min(self.width/8, self.height/8), self.width- 2*math.min(self.width/8, self.height/8), math.floor((self.height- 2*math.min(self.width/8, self.height/8))/self.font:getHeight())*self.font:getHeight())
  self.buttonPressFunc = (function (pt, button, presses) if self.button:contains(pt) then 
      if (love.system.getOS() == "Android" or love.system.getOS() == "iOS") then
      love.keyboard.setTextInput(true, self.button.x, self.button.y, self.button.width, self.button.height)
    end
      self.input:mousepressed(pt.x-self.button.x, pt.y-self.button.y, button, presses) else self.input:releaseMouse() end end)
  self.buttonReleaseFunc = (function (pt, button, presses) if self.button:contains(pt) then self.input:mousereleased(pt.x-self.button.x, pt.y-self.button.y, button, presses) else self.input:releaseMouse() end end)
  self.upFunc = (function (pt, button, presses) if self.upButton:contains(pt) then self.input:keypressed("up", false) end end)
  self.leftFunc = (function (pt, button, presses) if self.leftButton:contains(pt) then self.input:keypressed("left", false) end end)
  self.rightFunc = (function (pt, button, presses) if self.rightButton:contains(pt) then self.input:keypressed("right", false) end end)
  self.downFunc = (function (pt, button, presses) if self.downButton:contains(pt) then self.input:keypressed("down", false) end end)
  local min8 = math.min(self.width/8, self.height/8)
  
  self.upButton = TextButton(self.x+min8, self.y, self.width-(2*min8), min8, Color(color.r*0.5, color.g*0.5, color.b*0.5, color.a), "", 12, "left")
  self.downButton = TextButton(self.x+min8, self.y+self.height-(min8), self.width-(2*min8), min8, Color(color.r*0.5, color.g*0.5, color.b*0.5, color.a), "", 12, "left")
  self.leftButton = TextButton(self.x, self.y+min8, min8, self.height-(2*min8), Color(color.r*0.5, color.g*0.5, color.b*0.5, color.a), "", 12, "left")
  self.rightButton = TextButton(self.x+self.width-(min8), y+min8, min8, self.height-(2*min8), Color(color.r*0.5, color.g*0.5, color.b*0.5, color.a), "", 12, "left")
  
  self.enabled=false
end
function TextInput:enable()
  self.pressid=self.button:onPress(self.buttonPressFunc)
  self.releaseid=self.button:onClick(self.buttonReleaseFunc)
  self.upid = self.upButton:onPress(self.upFunc)
  self.downid = self.downButton:onPress(self.downFunc)
  self.leftid = self.leftButton:onPress(self.leftFunc)
  self.rightid = self.rightButton:onPress(self.rightFunc)
  self.enabled=true
end
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

function TextInput:mousemoved(x, y)
  if (self.enabled) then
    self.input:mousemoved(x-self.button.x, y-self.button.y)
  end
end

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
function TextInput:keypressed(key, scancode, isRepeat)
  if (self.enabled) then
    self.input:keypressed(key, isRepeat)
  end
end
function TextInput:textinput(text)
  if (self.enabled) then
    self.input:textinput(text)
  end
end
function TextInput:update(dt)
  if (self.enabled) then
    self.input:update(dt)
  end
end
function TextInput:getText()
  return self.input:getText()
end
function TextInput:setText(text)
  safety.ensureString(text, "text")
  self.input:setText(text)
end
ClickPulser:onEvent("onPress", "TextInput", function (pt, button) 
    if button~=1 then return end
    local clear = true
    for i, v in ipairs(list) do
      if v.enabled and v.button:contains(pt) then
        clear=false
      end
    end
    if (clear and (love.system.getOS()=="Android" or love.system.getOS() == "iOS")) then
      love.keyboard.setTextInput(false)
    end
  end)
return TextInput