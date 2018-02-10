-- Space rocks

local Unit = require("engine.Unit")

local Asteroid = {}

function Asteroid.new(group, x, y, options)
    return Unit.new("Asteroid", group, x, y, options)
end

return Asteroid