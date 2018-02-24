local knownAsteroids = {"Small", "Medium", "Big"}

local registry = {}

for i = 1, #knownAsteroids do
  local name = knownAsteroids[i]
  local module = require("engine.asteroids." .. name)
  registry[name] = module
end

local AsteroidFactory = {}

function AsteroidFactory.create(name, group, x, y)
  local module = registry[name]
  if module then
    return module.create(group, x, y)
  end
end

return AsteroidFactory
