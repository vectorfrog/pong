# Basic Love2d Structure

The Love2d library provides several other callback functions that we can utilize to build our game.  We've already used the love.draw callback, which draws objects to the application screen.  Now let's dive into the love.load callback which is executed only once during the initial load of the application.  Let's add it to our main.lua file, above the love.draw function and use it to create our welcome screen.

**main.lua**
```lua
function love.load()
  font = love.graphics.newFont("assets/Teko-Bold.ttf", 48)
  game_title = love.graphics.newText(font, "PONG")
  w, h = game_title:getDimensions()
end
```

You'll notice that we are loading a font file.  You can download the file [here](https://fonts.google.com/specimen/Teko), and unzip it and move the Teko-Bold.ttf into a new assets directory in our project directory.  This is something that the `love.load` function is frequently used for, loading in the different assets that the game is going to use.  In this case, we're loading the font, and creating a text object using that font.

We're then getting the bounding box of the text object using the `Text:getDimensions()` method.  The Text object is stored in the game_title variable, so to get the bounding box for game_title, we just call `game_title:getDimensions()`.  You can call any method on a Text object listed [here](https://love2d.org/wiki/Text).  Also, a method is simply a function that lives inside an object, most developers use the terms 'function' and 'method' interchangably.

Now that we have our "PONG" text object, and the dimensions for the text object, let's figure out a way to center the text on the screen.  Let's create a new lua file where we can store all the reusable logic to position objects on the screen dynamically (for instance, we might want to throw a "You Win" message later on, or maybe we'll want to center the ball to start a game).  We'll call this new lua file "position.lua":

**main.lua**
```lua
position = {}

function position:center(w, h)
  win_w, win_h = love.graphics.getDimensions()
  center_x = win_w / 2
  center_y = win_h / 2
  half_w = w / 2
  half_h = h / 2
  x = center_x - half_w
  y = center_y - half_h
  return x, y
end

return position
```

Here we're creating an empty table called "position".  A table is lua's version of an object, it can store values and functions.  We then add a function to the position table called "center", which takes the width and height of an object, and then returns what they x,y coordinates would be if we wanted to center that object on the screen.

To do this, we get the window width and height by calling `love.graphics.getDimensions()`, and then we find the midpoint of the window by dividing both the width and height by 2 to get the center_x and center_y coordinates.  Now, we want to place the box directly ontop of that midpoint, however, we need to shift the box so the center of the box aligns with the midpoint.  To do that, we just divide the width and height of the box by 2, and then subtract both those values from the window's center_x and center_y values.  Notice that we can return 2 values by coma delimiting them.

Finally, we need to return the "position" object that we created so we can call it from our main.lua file.  So at the top of the main.lua file we can simply add a `require("position")` statement:

**main.lua**
```lua
require "position"
```

Now let's update our `love.draw` function to make use of the position:center function we created:

**main.lua**
```lua
function love.draw()
  love.graphics.draw(game_title, position:center(w,h))
end
```

Now let's run the app:
```bash
$ loverun .
```

You should see an empty application with the word "PONG" printed in large letters smack dab in the center!

You can read up the `Text` and `Font` objects in the links below:

- [Text](https://love2d.org/wiki/Text)
- [Font](https://love2d.org/wiki/Font) 
