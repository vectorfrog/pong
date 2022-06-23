# Better Movement

In the last section, we had the ball move in a random direction, however, we don't want a completely random experience, because it would be possible for the ball just bounce vertically.  So let's make some changes to make sure we have the ball moving at a pace that will keep the game interesting.

**ball.lua**
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

function ball:is_off_screen()
  return self.y < 0 or (self.y + self.h) > love.graphics.getHeight()
end

function ball:vert_bounce()
  if self:is_off_screen() then
    self.dy = self.dy * -1
  end
end

function ball:move(dt)
  self.x = self.x + self.dx * dt
  self.y = self.y + self.dy * dt
  self:vert_bounce()
end

function ball:paddle_bounce()
  self.dx = self.dx * -1
end

return ball
```

First off, we've added a new property to the ball table, and that's ball speed.  This gives us an easy way to change the speed of the ball depending on how difficult we want the game to be.

We've also created the function `ball:start` which we'll call at the start of a game.  Here we are no longer randomly setting the dx and dy values to a number between -250 and 250.  Instead, we only randomly assign the dx to a value between 25 and the ball\_speed setting, and then we randomly multiply that against 1 or -1.  Then, we take the absolute value of the dx value, and assign the dy value based on that so the dx + the dy will always equal the ball\_speed setting.

Next, we want the ball to bounce off the top and bottom of the screen.  So we've added some additional functions like `ball:is_off_screen`, `ball:vert_bounce`, and added a call to the `ball:vert_bounce` function in the `ball:move` function.  So now on every ball movement, we go to `vert_bounce` and check to see if the ball is at the top or bottom of the screen, and if it is, we change the dy value of the ball by multiplying -1.

Finally, what if the ball comes in contact with a paddle?  Instead of changing the vertical direction of the ball, we'll want to change the horizontal direction, so that's what we do with the function `ball:paddle_bounce`.

Now let's take a look at the main.lua file:

**main.lua**
```lua
local text = require "text"
local ball_object = require "ball"
local paddle = require "paddle"
local ball_speed = 700

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
  player1 = paddle.new(20, 100)
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

So not too many changes here.  We've added the ball\_speed constant, which we can fine tune to make the game just the right level of difficulty.  We also removed the game\_start code which set the ball's direction, since that now lives in the ball.lua file.  However, there is some code that hopefully you are scratching your head over.  The `if ball:is_collision(player1) or ball:is_collision(player2)`.  Here we have a call to a function in the ball table, however, we don't have that function in the ball.lua file.  What's going on here?  You have to think back to when we created the ball table.  We said that the metatable for the ball table was going to be the object table.  So if we go to the object.lua file, we'll see an `object:is_collision(obj)` function.  So the ball table _inherits_ the `is_collision` function from the object table.  So why did I place the `is_collision` function in the object table?  Well, the object table contains all of the logic that would be useful for any object in the game, so things like positioning on the screen are in the object table.  Detecting collisions between objects also seems like a functionality that would be good to have for any object in the game, so we've added it to the object table.

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

function object:is_collision(obj)
  return self.x < obj.x + obj.w and
         obj.x < self.x + self.w and
         self.y < obj.y + obj.h and
         obj.y < self.y + self.h
end

return object
```

The `object:is_collision` function takes a single parameter (which should also be an object...or a table that is using the object table as a metatable).  Remember, `self` is referring to the object that has called this function, and `obj` is another object that we are checking against.  The goal here is to determine if the two objects are overlapping at all.  To do this, we'll compare `self` top left corner (the x property), to the `obj`'s top right corner (x property plus it's width).  We'll do a similar comparison for each corner.  If any of the comparisons are false, then we know there is no collision, however, if they are all true, then that means there has to be a collision.  This comparison between 4 corners is a common practice in game development, to the point that it has it's own name, **hitboxes**.
