# pong

This git repo is designed to walk a new user through creating the game of pong incrementally.  The main branch contains the full working version of the game. However, each branch explains the different steps used to create the finalized a version.  These instructions are only for Mac users for now.

If you'd like to play the completed game so you can see what our end goal looks like.  You can do so by installing the lua and the love2d game engine:

[Install Lua](https://www.lua.org/start.html#installing) 

[Install Love2d](https://love2d.org/#download) 

Once you've installed both, update your ~/.zshrc with some handy aliases:

```bash
alias love="/Applications/love.app/Contents/MacOS/love"
alias loverun="open -n -a love"
```

source your .zshrc file in your terminal, and now you can run the game by just typing

```bash
$ loverun "path/to/this/git_repo"
```
