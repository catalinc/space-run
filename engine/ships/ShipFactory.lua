local knownShips = {"Player", "Grunt", "Boss", "SmarterBoss"}

local registry = {}

for i = 1, #knownShips do
  local name = knownShips[i]
  local module = require("engine.ships." .. name)
  registry[name] = module
end

local ShipFactory = {}

function ShipFactory.create(name, group, x, y)
  local module = registry[name]
  if module then
    return module.create(group, x, y)
  end
end

return ShipFactory
