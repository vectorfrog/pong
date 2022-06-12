require "text"

function love.load()
  pong = text.new("PONG", "assets/Teko-Bold.ttf", 48)
  enter = text.new("press enter", "assets/Teko-Bold.ttf", 18, 200, 200)
  pong:center_screen()
  enter:align_center(pong)
end

function love.update(dt)
end

function love.draw()
  pong:draw()
  enter:draw()
end
