-- Asteroids field.

local physics = require("physics")
local sprites = require("engine.sprites")
local entities = require("engine.entities")

local collection = entities.new()

-- -----------------------------------------------------------------------------------
-- Public API
-- -----------------------------------------------------------------------------------

local M = {}

function M.create(group)
    local newAsteroid = display.newImageRect(group, sprites, 1, 102, 85)
    newAsteroid.myName = "asteroid" -- Used for collision detection
    newAsteroid.scorePoints = 100

    physics.addBody(newAsteroid, "dynamic", {radius = 40, bounce = 0.8})

    local whereFrom = math.random(3)
    if whereFrom == 1 then
        -- From the left
        newAsteroid.x = -60
        newAsteroid.y = math.random(500)
        newAsteroid:setLinearVelocity(math.random(40, 120), math.random(20, 60))
    elseif whereFrom == 2 then
        -- From the top
        newAsteroid.x = math.random(display.contentWidth)
        newAsteroid.y = -60
        newAsteroid:setLinearVelocity(math.random(-40, 40), math.random(40, 120))
    elseif whereFrom == 3 then
        -- From the right
        newAsteroid.x = display.contentWidth + 60
        newAsteroid.y = math.random(500)
        newAsteroid:setLinearVelocity(math.random(-120, -40), math.random(20, 60))
    end

    newAsteroid:applyTorque(math.random(-6, 6))

    collection:add(newAsteroid)
end

function M.remove(asteroid)
    collection:remove(asteroid)
end

function M.collect()
    collection:collect()
end

function M.cleanup()
    collection:clear()
end

function M.count()
    return collection:count()
end

return M