local object = {
  x = 0,
  y = 0,
  w = 0,
  h = 0,
  dx = 0,
  dy = 0
}
object.__index = object

function object.new(x,y,w,h,dx,dy)
  local instance = setmetatable({}, object)
  instance.x = x or 0
  instance.y = y or 0
  instance.w = w or 0
  instance.h = h or 0
  instance.dx = dx or 0
  instance.dy = dy or 0
  return instance
end

function object:center_screen()
  self:center_x_screen()
  self:center_y_screen()
end

function object:center_x_screen()
  local win_w = love.graphics.getWidth()
  local center_x = win_w / 2
  local half_w = self.w / 2
  self.x = center_x - half_w
end

function object:center_y_screen()
  local win_h = love.graphics.getHeight()
  local center_y = win_h / 2
  local half_h = self.h / 2
  self.y = center_y - half_h
end

function object:align_center(target)
  self:align_x_center(target)
  self:align_y_center(target)
end

function object:align_x_center(target)
  self.x = target.x + (target.w/2) - (self.w/2)
end

function object:align_y_center(target)
  self.y = target.y + (target.h/2) - (self.h/2)
end

function object:align_right_screen(offset)
  offset = offset or 0
  self.x = love.graphics.getWidth() - self.w - offset
end

function object:align_left_screen(offset)
  offset = offset or 0
  self.x = offset
end

function object:align_top_screen(offset)
  offset = offset or 0
  self.y = offset
end

function object:align_bottom_screen(offset)
  offset = offset or 0
  self.y = love.graphics.getHeight() - self.h - offset
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

function object:down(pixels)
  self.y = self.y + pixels
end

function object:can_move_up()
  return self.y > 0
end

function object:can_move_down()
  return self.y + self.h < love.graphics.getHeight()
end

function object:is_collision(obj)
  return self.x < obj.x + obj.w and
         obj.x < self.x + self.w and
         self.y < obj.y + obj.h and
         obj.y < self.y + self.h
end

return object
