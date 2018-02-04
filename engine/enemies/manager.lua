-- Bad guys generator.

local types = require("engine.enemies.types")
local enemy = require("engine.enemies.enemy")
local Collection = require("engine.common.collection")

local random = math.random
local randomLanes = {}
local MAX_LANES = 4
local LANE_WIDTH = display.contentWidth / MAX_LANES
local START_Y = -60

local function randomSequence(min, max)
    local t = {}
    for i = min, max do
        t[#t + 1] = i
    end
    for i = #t, 1, -1 do
        local j = math.random(1, i)
        t[i], t[j] = t[j], t[i]
    end
    return t
end

local function randomX()
    if #randomLanes == 0 then
        randomLanes = randomSequence(1, MAX_LANES - 1)
    end

    local lane = table.remove(randomLanes, 1)
    return LANE_WIDTH * lane
end

local Enemies = Collection:new()

function Enemies:spawn(typeName, target)
    local typeObject = types.get(typeName)
    local newEnemy = enemy.new(randomX(), START_Y, typeObject, target)
    self:add(newEnemy)
end

return Enemies