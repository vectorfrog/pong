local object = require "object"

local text = {}
text.__index = text
setmetatable(text, object)

--x and y are optional
function text.new(string, font_location, font_size, x, y)
  local instance = setmetatable({}, text)
  instance.string = love.graphics.newText(
    love.graphics.newFont(font_location, font_size),
    string
  )
  instance.w = instance.string:getWidth()
  instance.h = instance.string:getHeight()
  instance.x = x or 0
  instance.y = y or 0
  return instance
end

function text:draw()
  love.graphics.draw(self.string, self.x, self.y)
end

return text
