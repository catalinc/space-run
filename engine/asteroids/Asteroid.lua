local Unit = require("engine.unit.Unit")

local Asteroid = {}

function Asteroid.create(group, x, y, options)
  local newAsteroid = Unit.create("Asteroid", group, x, y, options)
  return newAsteroid
end

return Asteroid
