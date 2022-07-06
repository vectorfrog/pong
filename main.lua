local text = require "text"
local ball_object = require "ball"
local paddle = require "paddle"
local grid_object = require "grid"
local ball_speed = 700
local paddle_speed = 700
local global_should_show = 1

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
  global_should_show = global_should_show - dt
  if global_should_show < 0 then
    global_should_show = 1
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
