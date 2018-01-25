-- Beware, space mines ahead.

local physics = require("physics")
local sprites = require("engine.sprites")
local entities = require("engine.entities")

local collection = entities.new()

-- -----------------------------------------------------------------------------------
-- Public API
-- -----------------------------------------------------------------------------------

local M = {}

function M.create(group)
    local newMine = display.newImageRect(group, sprites, 1, 102, 85)
    newMine.myName = "mine" -- Used for collision detection

    physics.addBody(newMine, "dynamic", {radius = 40, bounce = 0.8})

    newMine.x = math.random(display.contentWidth)
    newMine.y = -60
    newMine:setLinearVelocity(math.random(-40, 40), math.random(40, 120))

    collection:add(newMine)
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
