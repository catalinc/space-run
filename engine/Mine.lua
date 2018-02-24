-- Nasty mines

local Unit = require("engine.Unit")

local Mine = {}

function Mine.create(group, x, y, options)
  return Unit.create("Mine", group, x, y, options)
end

return Mine
