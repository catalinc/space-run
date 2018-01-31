-- The bad guys.

local mathutils = require("libs.mathutils")
local collection = require("engine.collection")
local enemy = require("engine.enemy")
local behaviours = require("engine.behaviours")
local groups = require("engine.groups")

local random = math.random
local randomSequence = mathutils.randomSequence
local randomLanes = {}
local MAX_LANES = 4
local LANE_WIDTH = display.contentWidth / MAX_LANES

local function randomX()
    if #randomLanes == 0 then
        randomLanes = randomSequence(1, MAX_LANES - 1)
    end

    local lane = table.remove(randomLanes, 1)
    return LANE_WIDTH * lane
end

local enemies = collection.new()

-- -----------------------------------------------------------------------------------
-- Public API
-- -----------------------------------------------------------------------------------

local M = {}

function M.spawn(player)
    local group = groups.get("main")
    local newEnemy = enemy.new(group, randomX(), -60,
                               {showHealthBar = true,
                                target = player,
                                velocity = {x = random(-5, 5), y = random(40, 120)},
                                behaviour = behaviours.simple})
    enemies:add(newEnemy)
end

function M.remove(enemy)
    enemies:remove(enemy)
end

function M.removeOffScreen()
    enemies:removeOffScreen()
end

function M.clear()
    enemies:clear()
end

function M.count()
    return enemies:count()
end

return M
