local Text = {}
local FontCache = require"lib.gui.subsystem.FontCache"
local safety = require"lib.safety"
function Text:initText(x, y, width, height, text, fontsize, align)
  if (align==nil) then align="left" end
  safety.ensureNumber(width, "width")
  safety.ensureNumber(height, "height")
  safety.ensureString(text, "text")
  safety.ensureNumber(fontsize, "fontsize")
  safety.ensureString(align, "align")
  self.x=x
  self.y=y
  self.fontsize=fontsize
  self.align=align
  self.width=width
  self.height=height
  self.font=FontCache:getFont(fontsize)
  self.text=love.graphics.newTextBatch(self.font)
  self.textCanvas=love.graphics.newCanvas(self.width- 2*math.min(self.width/8, self.height/8), math.floor((self.height - (2*math.min(self.width/8, self.height/8)))/self.font:getHeight())*self.font:getHeight())
  self.text:setf(text, self.width-2*math.min(self.width/8, self.height/8), self.align)
end


function Text:drawText()
  local oldCanvas = love.graphics.getCanvas()
  love.graphics.setCanvas(self.textCanvas)
  love.graphics.clear()
  love.graphics.draw(self.text)
  
  love.graphics.setCanvas(oldCanvas)
  love.graphics.push()
  love.graphics.translate(self.x + (self.width/2), self.y + (self.height/2))
  love.graphics.scale(self.sx, self.sy)
  love.graphics.draw(self.textCanvas, -(self.width/2 - math.min(self.width/8, self.height/8)), -(self.height/2 -math.min(self.width/8, self.height/8)))
  love.graphics.pop()
end

function Text:changeText(text)
  safety.ensureString(text)
 self.text:setf(text, self.width-math.min(self.width/8, self.height/8), self.align)
end
return Text