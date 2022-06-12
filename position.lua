position = {}

function position.center(w, h)
  local win_w, win_h = love.graphics.getDimensions()
  local center_x = win_w / 2
  local center_y = win_h / 2
  local half_w = w / 2
  local half_h = h / 2
  local x = center_x - half_w
  local y = center_y - half_h
  return x, y
end

return position
