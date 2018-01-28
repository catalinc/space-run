-- The bad guys.

local mathutils = require("libs.mathutils")
local entities = require("engine.entities")
local enemy = require("engine.enemy")

local random = math.random
local randomSequence = mathutils.randomSequence
local randomLanes = {}
local MAX_LANES = 4
local LANE_WIDTH = display.contentWidth / MAX_LANES

local function randomX()
    if #randomLanes == 0 then
        randomLanes = randomSequence(0, MAX_LANES - 1)
    end

    local lane = table.remove(randomLanes, 1)
    return LANE_WIDTH * (lane + 0.5)
end

local enemies = entities.new()

-- -----------------------------------------------------------------------------------
-- Public API
-- -----------------------------------------------------------------------------------

local M = {}

function M.spawn(group, player)
    local newEnemy = enemy.new(group, randomX(), -60,
                               {showHealthBar = true, target = player,
                                velocity = {x = random(-40, 40), y = random(40, 120)}})
    enemies:add(newEnemy)
end

function M.remove(enemy)
    enemies:remove(enemy)
end

function M.collect()
    enemies:collect()
end

function M.cleanup()
    enemies:clear()
end

function M.count()
    return enemies:count()
end

return M
