# Basic Love2d Structure

The Love2d library provides several other callback functions that we can utilize to build our game.  We've already used the love.draw callback, which draws objects to the application screen.  Now let's dive into the love.load callback which is executed only once during the initial load of the application.  Let's add it to our main.lua file, above the love.draw function and use it to create our welcome screen.

```lua
function love.load()
  font = love.graphics.newFont("assets/Teko-Bold.ttf")
  game_title = love.graphics.newText(font, "Pong", 48)
end
```

You'll notice that we are loading a font file.  You can download the file [here](https://fonts.google.com/specimen/Teko), and unzip it and move the Teko-Bold.ttf into a new assets directory in our project directory.  This is something that the `love.load` function is frequently used for, loading in the different assets that the game is going to use.  In this case, we're loading the font, and setting the text.


```lua
function love.draw()
  love.graphics.print("Hello World", 400, 300)
end
```

Now let's use that alias we set up earlier in the terminal
```bash
$ loverun .
```

You should see an empty application with the words "Hello World" printed somewhere inside of it.  Congratulations, you just created your first love2d game...It's the most boring game ever, but a game nonetheless.

Now let's breakdown the code a little bit to explain what we've done:

The `love.draw` function is a callback function.  A callback function is simply a special function that a library provides that accomplishes something in that library.  In the case of love2d, the `love.draw` function oversees drawing objects in the game application.  We've only provided one item to draw on the screen, and that's the text of "Hello World".  We can't just send text to the application however, we need to provide additional information, such as where where to place the text.  We provide that information using the `love.graphics.print` function.  In this case, we are specifying that the text be written 400 pixels to the right of the left side of the application window, and 300 pixels down from the top.

You can read up `love.draw` and `love.graphics.print` in the links below:

- [love.graphics.print](https://love2d.org/wiki/love.graphics.print) 
- [love.draw](https://love2d.org/wiki/love.draw) 
