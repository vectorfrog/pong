# Text Obects

If we want to display text, we know that we are going to need to do the following things:

1. select a font and a size
2. provide a string
3. draw to the screen at a given x,y coordinates

It would be nice if we could organize our code so that all of the information regarding text was stored in a single place, then we could reuse that code again and again whenever we needed to display text.  Making your code reusable is called "abstraction," and it almost always leads to code easier to maintain and to debug.  Let's go ahead and abstract all of our code about creating text to display on the screen into a different lua file, just like we did for positioning logic.

**text.lua**
```lua
require "position"
text = {}
text.__index = text

--x and y are optional
function text.new(string, font_location, font_size, x, y)
  local instance = setmetatable({}, text)
  instance.string = love.graphics.newText(
    love.graphics.newFont(font_location, font_size),
    string
  )
  instance.w = instance.string:getWidth()
  instance.h = instance.string:getHeight()
  instance.x = x or 0
  instance.y = y or 0
  return instance
end

function text:draw()
  love.graphics.draw(self.string, self.x, self.y)
end

function text:center_screen()
  self.x, self.y = position.center(self.w, self.h)
end

-- expects table with w and x
function text:align_center(target)
  self.x = target.x + (target.w/2) - (self.w/2)
end

return text

```

So in this file, we're creating a new table called text, and then in that table, we have a function called new which will store all the information regarding the string we are going to print to the screen.  We also have a functions called draw which draws the text object to the screen, as well as some positioning functions (center_screen, which places the object in the center of the screen, and align_center which aligns the text objects vertical axis with another text object).

Now we can simplify our main.lua:

**main.lua**
```lua
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
```

Notice how easy it is to create new text objects in the main.lua file.  We created the enter object and placed it directly above the Pong text object.

