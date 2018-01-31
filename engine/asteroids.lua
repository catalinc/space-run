-- Asteroids field.

local physics = require("physics")
local sprites = require("engine.sprites")
local collection = require("engine.collection")
local groups = require("engine.groups")

local asteroids = collection.new()

-- -----------------------------------------------------------------------------------
-- Public API
-- -----------------------------------------------------------------------------------

local M = {}

function M.spawn()
    local group = groups.get("main")
    local newAsteroid = display.newImageRect(group, sprites, 1, 102, 85)
    newAsteroid.myName = "asteroid" -- Used for collision detection
    newAsteroid.points = 100
    newAsteroid.damage = 20

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