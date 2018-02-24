local EventBus = require("engine.shared.EventBus")

local MIN_X = 200
local MIN_Y = -40

local knownUnits = {
  Asteroid = "engine.asteroids.AsteroidFactory", 
  Mine = "engine.mines.MineFactory", 
  Ship = "engine.ships.ShipFactory", 
}

local registry = {}

for name, path in pairs(knownUnits) do
  registry[name] = require(path)
end

local UnitFactory = {}

function UnitFactory.create(category, name, group)
  local factory = registry[category]
  if factory then
    -- TODO: find something smarter to generate x, y
    local x = math.random(MIN_X, display.contentWidth - MIN_X)
    local y = math.random(MIN_Y, MIN_Y + 10)
    return factory.create(name, group, x, y)
  end
end

return UnitFactory
