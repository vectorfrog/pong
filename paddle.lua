local object = require "object"

local paddle = {}
paddle.__index = paddle
setmetatable(paddle, object)

function paddle.new(w, h, speed)
  local instance = setmetatable({}, paddle)
  instance.w = w
  instance.h = h
  instance.speed = speed
  return instance
end

function paddle:draw()
  love.graphics.rectangle("fill", self.x, self.y, self.w, self.h)
end

function paddle:move(dt)
  if self:can_move_up() then
    if love.keyboard.isDown("up") then
      self:up(self.speed * dt)
    end
  end
  if self:can_move_down() then
    if love.keyboard.isDown("down") then
      self:down(self.speed * dt)
    end
  end
end

return paddle
