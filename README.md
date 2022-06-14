# Creating the Ball

Looking back at what's supposed to happen at the start of the game, we should have the ball in the center of the screen and it shoots in a random direction. So let's make that happen now. The ball is going to have an x,y access, and we're going to need to draw it to the screen, so it's a great candidate to be built off of the object metatable we created earlier.  However, it also is going to be moving around the screen, so it's more than just an object.  Let's create a new ball.lua file to contain all of the logic that the ball will need during our game.

**main.lua**
```lua
local text = require "text"
local ball_object = require "ball"

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
end

function love.update(dt)
  if game_state == "start_screen" then
    if love.keyboard.isDown("return") then
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
  end
end
```

At the top of the file, we've added a require to bring the ball.lua file into our app.  I've named it `ball_object` so we can use the `ball` as the instance name.  In the `love.load` function, we instantiate the ball and pass the rgb colors and radius of the ball, and then we center the ball on the screen using the same `center_screen` function from the object model.  Let's take a look at the new ball.lua file

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

return ball

```

The top of the file should look pretty familiar.  Again, we're using the object table as the meta table, which will provide the object functions to our `ball` objects.  The `ball.new` function is where we create the instance of the ball object.  Here is where we set the rgb colors, and the radius.  We also derive the width and height from the radius.  Finally, we create a draw function that will draw the circle to the screen.

When we fire up the application, we see the start screen, and then when we hit enter, we see the ball in the center of the screen.  Nice, now we need to build the paddles.

You can read up on the `love.graphics.circle` function here:

[love.graphics.circle](https://love2d.org/wiki/love.graphics.circle) 
