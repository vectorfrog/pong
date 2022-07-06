# Display Scoring

OK, so we are keeping score, but the users have no idea what the score is, we need to figure out a way to display the scoring to them.  I think the expected behavior would be to have the score be shown to the user before the start of each point.  However, we'll want the score to be visible for a second or so before the game moves on, so we're going to have to figure out how to work with time so we show the score for a given amount of time before the game moves on to the play state.

To do that, we'll introduce a new variable called `seconds_score_shown` which will contain the number of seconds that the score should show.  Next we'll create a function that will determine whether the score should be shown called `should_show_score` and that will return a true of false value. In that function we'll subtract the `dt` value from the `love.update` function which provides the number of seconds since the last time the love.update function was called, if the value is less than 0, then we're reset the `seconds_score_shown` to 1 and return false.  We then can can change the `game_state` to play and the game begins.

**main.lua**
```lua
local text = require "text"
local ball_object = require "ball"
local paddle = require "paddle"
local grid_object = require "grid"
local ball_speed = 700
local paddle_speed = 700
local seconds_score_shown = 1

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
  score = {player1 = 0, player2 = 0}
  player1_score = text.new(score.player1, "assets/Teko-Bold.ttf", 128)
  player2_score = text.new(score.player2, "assets/Teko-Bold.ttf", 128)
  grid = grid_object.new(1,2)
  player1_score:align_center(grid[1])
  player2_score:align_center(grid[2])
end

function should_show_score(dt)
  seconds_score_shown = seconds_score_shown - dt
  if seconds_score_shown < 0 then
    seconds_score_shown = 1
    return false
  else
    return true
  end
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
    if should_show_score(dt) then
      show_score = true
    else
      show_score = false
      game_state = "play"
    end
  end
  if game_state == "play" then
    ball:move(dt)
    player1:move(dt)
    if ball:is_collision(player1) or ball:is_collision(player2) then
      ball:paddle_bounce()
    end
    if ball:is_point(score) then
      player1_score:update_string(score.player1)
      player2_score:update_string(score.player2)
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
    if show_score then
      player1_score:draw()
      player2_score:draw()
    end
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

