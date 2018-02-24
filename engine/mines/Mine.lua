local Unit = require("engine.unit.Unit")

local Mine = {}

function Mine.create(group, x, y, options)
  local newMine = Unit.create("Mine", group, x, y, options)
  return newMine
end

return Mine
