local Unit = require("engine.Unit")

local Asteroid = {}

function Asteroid.create(group, x, y, options)
    return Unit.create("Asteroid", group, x, y, options)
end

return Asteroid