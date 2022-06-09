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
