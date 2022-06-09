require "position"

function love.load()
  local font = love.graphics.newFont("assets/Teko-Bold.ttf", 48)
  game_title = love.graphics.newText(font, "Ping Pong is so FUN!!")
  w, h = game_title:getDimensions()
end

function love.update(dt)
end

function love.draw()
  love.graphics.draw(game_title, position:center(w,h))
end
