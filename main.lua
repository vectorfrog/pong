local text = require "text"

function love.load()
  pong = text.new("PONG", "assets/Teko-Bold.ttf", 48)
  enter = text.new("press enter", "assets/Teko-Bold.ttf", 18)
  pong:center_screen()
  enter:align_x_center(pong)
  enter:between_bottom(pong)
  enter:up(30)
end

function love.update(dt)
end

function love.draw()
  pong:draw()
  enter:draw()
end
