# Game State

Well, we now have a welcome screen for our users, and we have a basic object that we can build on top of.  Our next step is to actually build the game.  When it comes to our game design, our user is going to encounter different experiences at different times.  I find it helpful to map the user experiences during the game:

1. User sees the welcome screen.  The user can hit enter to start the game
2. The game starts, the score is 0-0, the ball starts at the center of the screen and randomly is shot in a direction
3. The ball can bounce off of the top and bottom of the screen or the players paddles, the players can control their paddles up and down
4. If the ball passes a player's paddle and exits the screen, the opponent get's a point
5. The point loser begins the next rally by serving the ball
6. The game ends when a player scores 5 points

Now that we've mapped out the basic game, a few different contexts arise.  First, there's the title screen that we already built, then there's the game start, where the ball is randomly fired in a direction, then there is the rally play, then there is a point scored, then there is the serve to start the next rally, and finally, there is the end of the game when a player scores 5 points.  In each of the different scenarios, the user will be able to accomplish different actions (such as starting the game, moving the paddle, or serving the ball).  We need to keep track of where the user is during the game experience, we call this managing game state.

Let's start setting up our game state:

**main.lua**
```lua
local text = require "text"

function love.load()
  game_state = "start_screen"
  pong = text.new("PONG", "assets/Teko-Bold.ttf", 48)
  enter = text.new("press enter", "assets/Teko-Bold.ttf", 18)
  pong:center_screen()
  enter:align_x_center(pong)
  enter:between_bottom(pong)
  enter:up(30)
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
    text.new("game has started", "assets/Teko-Bold.ttf", 24):draw()
  end
end
```

So there's a couple of new items, first, we've added the `game_state` variable which tells us where the user is at in the game.  Next, we've added some logic to `love.update` function where it now will change the state from "start_screen" to "game_start" if the user hits the return button.  Finally, we've udpated the `love.draw` function to display different stuff depending on the state.  Awesome!

