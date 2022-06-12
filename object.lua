local object = {}
object.__index = object

function object.new()
  local instance = setmetatable({}, object)
  instance.w = nil
  instance.h = nil
  instance.x = nil
  instance.y = nil
  return instance
end

return object
