require "position"
text = {}
text.__index = text

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

function text:center_screen()
  self.x, self.y = position.center(self.w, self.h)
end

-- expects table with w and x
function text:align_center(target)
  self.x = target.x + (target.w/2) - (self.w/2)
end

return text

