# Starting the Game

Now we need our game to actually do something.  So when the user starts the game, let's have the ball fire in a random direction.

**main.lua**
```lua
local text = require "text"
local ball_object = require "ball"
local paddle = require "paddle"

function love.load()
  game_state = "start_screen"
  pong = text.new("PONG", "assets/Teko-Bold.ttf", 48)
  enter = text.new("press enter", "assets/Teko-Bold.ttf", 18)
  pong:center_screen()
  enter:align_x_center(pong)
  enter:between_bottom(pong)
  enter:up(30)
  ball = ball_object.new(1, 1, 1, 5)
  ball:center_screen()
  player1 = paddle.new(20, 100)
  player1:center_y_screen()
  player2 = paddle.new(20, 100)
  player2:align_left_screen(0)
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
    math.randomseed(os.time())
    local dx = math.random(-250, 250)
    local dy = math.random(-250, 250)
    ball:setDirection(dx, dy)
    game_state = "play"
  end
  if game_state == "play" then
    ball:move(dt)
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

The `love.load` function hasn't changed at all.  However, in the love.update, we've added some logic to take a random value between -250 and 250 and set those values as the ball's direction.  Then, we change the state to play, and call if the state is play, we run the `ball:move` function.  Let's take a look at the new ball functionality.

**ball.lua**
```lua
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

```

The new `ball:setDirection` simply sets the dx and dy properties on the ball object.  The `ball:move` takes the dt (delta time, which means the amount of time since the `love.update` function was last called, and then multiplies that dt value against the dx and dy properties and sets the x and y value of the ball accordingly.

When we run the app using `loverun .`, we see the start screen, then we hit enter and the ball moves in a random direction.  However, there's nothing keeping the ball from moving very slowly sometimes, and it's possible that the ball moves only vertically, which means the ball would never get to a paddle.  Our next step will be to set some parameters around how the ball should move to keep the speed consistent, and always moving toward a paddle.

You can read up more about the functions used at:

[math.randomseed](http://lua-users.org/wiki/MathLibraryTutorial) 
[love.update](https://love2d.org/wiki/love.update) 

