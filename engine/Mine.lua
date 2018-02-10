-- Nasty mines

local Unit = require("engine.Unit")

local Mine = {}

function Mine.new(group, x, y, options)
    return Unit.new("Mine", group, x, y, options)
end

return Mine