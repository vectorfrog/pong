local object = require "object"

local ball = {}
ball.__index = ball
setmetatable(ball, object)

function ball.new(r, g, b, rad, x, y, ball_speed)
  local instance = setmetatable({}, ball)
  instance.r = r or 1
  instance.g = g or 1
  instance.b = b or 1
  instance.rad = rad or 1
  instance.x = x or 1
  instance.y = y or 1
  instance.w = rad * 2
  instance.h = rad * 2
  instance.ball_speed = ball_speed
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

function ball:start()
  local pos_or_neg ={1, -1}
  math.randomseed(os.time())
  local dx = math.random(25, self.ball_speed) * pos_or_neg[math.random(1,2)]
  local dy = (self.ball_speed - math.abs(dx)) * pos_or_neg[math.random(1,2)]
  ball:setDirection(dx, dy)
end

function ball:vert_bounce()
    self.dy = self.dy * -1
end

function ball:move(dt)
  self.x = self.x + self.dx * dt
  if self.dy < 0 then
    if self:can_move_up() then
      self.y = self.y + self.dy * dt
    else
      self:vert_bounce()
    end
  else
    if self:can_move_down() then
      self.y = self.y + self.dy * dt
    else
      self:vert_bounce()
    end
  end
end

function ball:paddle_bounce()
  self.dx = self.dx * -1
end

function ball:is_point(score)
  if (self.x + self.w) < 0 then
    score.player2 = score.player2 + 1
    return true
  end
  if self.x > love.graphics.getWidth() then
    score.player1 = score.player1 + 1
    return true
  end
  return false
end

return ball

