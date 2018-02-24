local knownMines = {"Slow"}

local registry = {}

for i = 1, #knownMines do
  local name = knownMines[i]
  local module = require("engine.mines." .. name)
  registry[name] = module
end

local MineFactory = {}

function MineFactory.create(name, group, x, y)
  local module = registry[name]
  if module then
    return module.create(group, x, y)
  end
end

return MineFactory
