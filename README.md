# Scoring

You've probably noticed that our game gets pretty boring as soon as the ball passes a paddle, because we don't have any logic indicating when a point is scored and that the game should reset with a new serve.  Let's change that now.

In our ball.lua file, we're going to add a function that will detect if the ball is off the screen on the horizontal access.
**ball.lua**
```lua
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
```

The function also accepts a `score` parameter.  That parameter is meant to be a table that we create in the main file and will hold player1 and player2's scores.

In the main.lua file, we're going to add the score check in the `love.update` function:

**main.lua**
```lua
local text = require "text"
local ball_object = require "ball"
local paddle = require "paddle"
local ball_speed = 700
local paddle_speed = 700
local score = {player1 = 0, player2 = 0}

function love.load()
  game_state = "start_screen"
  pong = text.new("PONG", "assets/Teko-Bold.ttf", 48)
  enter = text.new("press enter", "assets/Teko-Bold.ttf", 18)
  pong:center_screen()
  enter:align_x_center(pong)
  enter:between_bottom(pong)
  enter:up(30)
  ball = ball_object.new(1, 1, 1, 5, 0, 0, ball_speed)
  player1 = paddle.new(20, 100, paddle_speed)
  player2 = paddle.new(20, 100)
  player2:align_right_screen(0)
end

function love.update(dt)
  if game_state == "start_screen" then
    if love.keyboard.isDown("return") then
      game_state = "game_start"
    end
  end
  if game_state == "game_start" then
    ball:center_screen()
    ball:start()
    player1:center_y_screen()
    player2:center_y_screen()
    game_state = "play"
  end
  if game_state == "play" then
    ball:move(dt)
    player1:move(dt)
    if ball:is_collision(player1) or ball:is_collision(player2) then
      ball:paddle_bounce()
    end
    if ball:is_point(score) then
      game_state = "game_start"
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

We created a new table called `score` which has to properties, player\_1 and player\_2, and declare when the app is loaded that each player has 0 points.

You'll also noticed that we moved the initial player1 & player2 `center_y_screen` functions calls to the `love.update` function when the game state is equal to "game\_start".  Now the paddles will be recentered after each point.

