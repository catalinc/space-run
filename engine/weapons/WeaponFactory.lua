local knownWeapons = {"Bullet"}

local registry = {}

for i = 1, #knownWeapons do
  local name = knownWeapons[i]
  local module = require("engine.weapons." .. name)
  registry[name] = module
end

local WeaponFactory = {}

function WeaponFactory.create(name, source)
  local module = registry[name]
  if module then
    return module.create(source)
  end
end

return WeaponFactory
