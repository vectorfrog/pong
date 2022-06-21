local object = require "object"

local ball = {}
ball.__index = ball
setmetatable(ball, object)

function ball.new(r, g, b, rad, x, y)
  local instance = setmetatable({}, ball)
  instance.r = r or 1
  instance.g = g or 1
  instance.b = b or 1
  instance.rad = rad or 1
  instance.x = x or 1
  instance.y = y or 1
  instance.w = rad * 2
  instance.h = rad * 2
  return instance
end

function ball:draw()
  love.graphics.setColor(self.r, self.g, self.b)
  love.graphics.circle("fill", self.x, self.y, self.rad)
end

function ball:setDirection(dx, dy)
  self.dx = dx
  self.dy = dy
end

function ball:move(dt)
  self.x = self.x + self.dx * dt
  self.y = self.y + self.dy * dt
end

return ball

