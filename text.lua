local object = require "object"

local text = {}
text.__index = text
setmetatable(text, object)

function newText(string, font_location, font_size)
  return love.graphics.newText(
    love.graphics.newFont(font_location, font_size),
    string)
end

--x and y are optional
function text.new(string, font_location, font_size, x, y)
  local instance = setmetatable({}, text)
  instance.font_location = font_location
  instance.font_location = font_size
  instance.string = newText(string, font_location, font_size)
  instance.w = instance.string:getWidth()
  instance.h = instance.string:getHeight()
  instance.x = x or 0
  instance.y = y or 0
  return instance
end

function text:update_string(string)
  if type(string) == "string" then
    self.string = newText(string, self.font_location, self.font_size)
  else
    self.string = newText(tostring(string), self.font_location, self.font_size)
  end
end

function text:draw()
  love.graphics.draw(self.string, self.x, self.y)
end

return text
