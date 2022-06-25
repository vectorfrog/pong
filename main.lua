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
