-- Bad guys generator.

local mathutils = require("engine.common.mathutils")
local collection = require("engine.common.collection")
local types = require("engine.enemies.types")
local enemy = require("engine.enemies.enemy")

local random = math.random
local randomSequence = mathutils.randomSequence
local randomLanes = {}
local MAX_LANES = 4
local LANE_WIDTH = display.contentWidth / MAX_LANES

local M = {}

local function randomX()
    if #randomLanes == 0 then
        randomLanes = randomSequence(1, MAX_LANES - 1)
    end

    local lane = table.remove(randomLanes, 1)
    return LANE_WIDTH * lane
end

local enemies = collection.new()

function M.spawn(name, target)
    local enemyType = types.get(name)
    local newEnemy = enemy.new(randomX(), -60, enemyType, target)
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
