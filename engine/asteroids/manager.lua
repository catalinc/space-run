-- Asteroids generator.

local physics = require("physics")
local types = require("engine.asteroids.types")
local asteroid = require("engine.asteroids.asteroid")
local collection = require("engine.common.collection")

local M = {}

local asteroids = collection.new()

function M.spawn(name)
    local asteroidType = types.get(name)
    local newAsteroid = asteroid.new(asteroidType)
    asteroids:add(newAsteroid)
end

function M.remove(asteroid)
    asteroids:remove(asteroid)
end

function M.removeOffScreen()
    asteroids:removeOffScreen()
end

function M.clear()
    asteroids:clear()
end

function M.count()
    return asteroids:count()
end

return M