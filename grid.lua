local object = require "object"

local grid = {}
grid.__index = grid
setmetatable(grid, object)

function grid.new(rows, columns)
  local instance = setmetatable({}, grid)
  local app_h = love.graphics.getHeight()
  local app_w = love.graphics.getWidth()
  local col_w = app_w / columns
  local row_h = app_h / rows
  local count = 0
  for r = 1,rows,1 do
    for c = 1,columns,1 do
      count = count + 1
      instance[count] = object.new((c-1)*col_w, (r-1)*row_h, col_w, row_h)
    end
  end
  return instance
end

return grid
