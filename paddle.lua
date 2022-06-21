local object = require "object"

local paddle = {}
paddle.__index = paddle
setmetatable(paddle, object)

function paddle.new(w, h)
  local instance = setmetatable({}, paddle)
  instance.w = w
  instance.h = h
  return instance
end

function paddle:draw()
  love.graphics.rectangle("fill", self.x, self.y, self.w, self.h)
end

return paddle
