# Inheritence

Now that we can create text objects and place them on the screen easily, it would be nice if every object that we work on had that same functionality, not just text objects.  We're in luck.  Lua allows us to do this by using metatables.

1. select a font and a size
2. provide a string
3. draw to the screen at a given x,y coordinates

It would be nice if we could organize our code so that all of the information regarding text was stored in a single place, then we could reuse that code again and again whenever we needed to display text.  Making your code reusable is called "abstraction," and it almost always leads to code easier to maintain and to debug.  Let's go ahead and abstract all of our code about creating text to display on the screen into a different lua file, just like we did for positioning logic.

**text.lua**
```lua
local object = require "object"

local text = {}
text.__index = text
setmetatable(text, object)

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

return text
```

At the top of the file, you'll notice that we're requiring the object.lua file, and that we've added some additional lines after we declare the text table.  First, we've added `text.__index = text`. The `__index` property of a table states that there is some type of inheritence going on, so if a property isn't found, we should look for a metatable that the table can fall back on.  We specify what should be used as the metatable in `setmetatable(text, object)` line, where we basically are saying, if a property can't be found in the text table, look for it in the object table.

Let's take a look at the object table:

**object.lua**
```lua
local object = {}
object.__index = object

function object:center_screen()
  local win_w, win_h = love.graphics.getDimensions()
  local center_x = win_w / 2
  local center_y = win_h / 2
  local half_w = self.w / 2
  local half_h = self.h / 2
  self.x = center_x - half_w
  self.y = center_y - half_h
end

-- target: object
function object:align_x_center(target)
  self.x = target.x + (target.w/2) - (self.w/2)
end

function object:between_bottom(target)
  local win_h = love.graphics.getHeight()
  local target_bottom = target.y + target.h
  local mid = (win_h - target_bottom)/2 + target_bottom
  self.y = mid - (self.h/2)
end

function object:up(pixels)
  self.y = self.y - pixels
end

return object
```

Here we're doing the same thing, we create the object table, and state that the table has a `__index` property of itself, but now we don't specify a metatable to fall back to, because we're not inheriting any additional properties.  We then have a a few functions that specify how to place an object on the screen.  We'll continue to add functionality to this object table as needed.

