# Player Controls

Well, our game is starting to look like a game, however, we need to allow the player to move the paddle up and down.

First, let's flesh out how this will work in the main.lua file:

**main.lua**
```lua
local text = require "text"
local ball_object = require "ball"
local paddle = require "paddle"
local ball_speed = 700
local paddle_speed = 700

function love.load()
  game_state = "start_screen"
  pong = text.new("PONG", "assets/Teko-Bold.ttf", 48)
  enter = text.new("press enter", "assets/Teko-Bold.ttf", 18)
  pong:center_screen()
  enter:align_x_center(pong)
  enter:between_bottom(pong)
  enter:up(30)
  ball = ball_object.new(1, 1, 1, 5, 0, 0, ball_speed)
  ball:center_screen()
  player1 = paddle.new(20, 100, paddle_speed)
  player1:center_y_screen()
  player2 = paddle.new(20, 100)
  player2:center_y_screen()
  player2:align_right_screen(0)
end

function love.update(dt)
  if game_state == "start_screen" then
    if love.keyboard.isDown("return") then
      game_state = "game_start"
    end
  end
  if game_state == "game_start" then
    ball:start()
    game_state = "play"
  end
  if game_state == "play" then
    ball:move(dt)
    player1:move(dt)
    if ball:is_collision(player1) or ball:is_collision(player2) then
      ball:paddle_bounce()
    end
  end
end

function love.draw()
  if game_state == "start_screen" then
    pong:draw()
    enter:draw()
  end
  if game_state == "game_start" then
    ball:draw()
    player1:draw()
    player2:draw()
  end
  if game_state == "play" then
    ball:draw()
    player1:draw()
    player2:draw()
  end
end
```

So all we've done here is added the reference to `player:move(dt)` function call in the `love.update(dt)` function.

Now let's build out the `paddle:move()` function.

**paddle.lua**
```lua
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
```

We've added the `paddle:move` function and pass it the dt (delta time) that the `love.update` function provides.  This function simply checks to see if the paddle has any space to move either up or down, and if it does, it will allow the player to provide input (by pressing the up or down arrows) to move the paddle.  Of course, if the paddle doesn't have space to move up or down, then the user can still press the arrow, our game will just ignore it though.  Where did can we find the logic for the `can_move_up` and `can_move_down`?  This functionality seems like it would be pretty useful to all of our objects, so we'll put it in the object table so it can be inherited.

**object.lua**
```lua
local object = {
  x = 0,
  y = 0,
  w = 0,
  h = 0,
  dx = 0,
  dy = 0
}
object.__index = object

function object:center_screen()
  self:center_x_screen()
  self:center_y_screen()
end

function object:center_x_screen()
  local win_w = love.graphics.getWidth()
  local center_x = win_w / 2
  local half_w = self.w / 2
  self.x = center_x - half_w
end

function object:center_y_screen()
  local win_h = love.graphics.getHeight()
  local center_y = win_h / 2
  local half_h = self.h / 2
  self.y = center_y - half_h
end

function object:align_x_center(target)
  self.x = target.x + (target.w/2) - (self.w/2)
end

function object:align_x_center(target)
  self.x = target.x + (target.w/2) - (self.w/2)
end

function object:align_right_screen(offset)
  offset = offset or 0
  self.x = love.graphics.getWidth() - self.w - offset
end

function object:align_left_screen(offset)
  offset = offset or 0
  self.x = offset
end

function object:align_top_screen(offset)
  offset = offset or 0
  self.y = offset
end

function object:align_bottom_screen(offset)
  offset = offset or 0
  self.y = love.graphics.getHeight() - self.h - offset
end

function object:between_bottom(target)
  local win_h = love.graphics.getHeight()
  local target_bottom = target.y + target.h
  local mid = (win_h - target_bottom)/2 + target_bottom
  self.y = mid - (self.h/2)
end

function object:up(pixels)
  self.y = self.y - pixels
end

function object:down(pixels)
  self.y = self.y + pixels
end

function object:can_move_up()
  return self.y > 0
end

function object:can_move_down()
  return self.y + self.h < love.graphics.getHeight()
end

function object:is_collision(obj)
  return self.x < obj.x + obj.w and
         obj.x < self.x + self.w and
         self.y < obj.y + obj.h and
         obj.y < self.y + self.h
end

return object
```

Now we have these useful `can_move_up` and `can_move_down` functions, let's update our `ball:move` function to use them:

**main.lua**
```lua
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

return ball

```

