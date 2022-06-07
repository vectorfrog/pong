function love.load()
  font = love.graphics.newFont("assets/Teko-Bold.ttf", 48)
  game_title = love.graphics.newText(font, "Pong")
end

function love.draw()
  love.graphics.draw(game_title, 400, 300)
end
