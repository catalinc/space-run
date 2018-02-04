-- Asteroids generator.

local types = require("engine.asteroids.types")
local asteroid = require("engine.asteroids.asteroid")
local Collection = require("engine.common.collection")

local Asteroids = Collection:new()

function Asteroids:spawn(typeName)
    local typeObject = types.get(typeName)
    local newAsteroid = asteroid.new(typeObject)
    self:add(newAsteroid)
end

return Asteroids