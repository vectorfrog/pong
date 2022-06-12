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
