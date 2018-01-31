-- Beware, space mines ahead.

local physics = require("physics")
local sprites = require("engine.sprites")
local collection = require("engine.collection")
local groups = require("engine.groups")

local mines = collection.new()

-- -----------------------------------------------------------------------------------
-- Public API
-- -----------------------------------------------------------------------------------

local M = {}

function M.spawn()
    local group = groups.get("main")
    local newMine = display.newImageRect(group, sprites, 1, 102, 85)
    newMine.myName = "mine" -- Used for collision detection
    newMine.points = 250

    physics.addBody(newMine, "dynamic", {radius = 40, bounce = 0.8})

    newMine.x = math.random(display.contentWidth)
    newMine.y = -60
    newMine:setLinearVelocity(math.random(-40, 40), math.random(40, 120))

    mines:add(newMine)
end

function M.remove(mine)
    mines:remove(mine)
end

function M.removeOffScreen()
    mines:removeOffScreen()
end

function M.clear()
    mines:clear()
end

function M.count()
    return mines:count()
end

return M
