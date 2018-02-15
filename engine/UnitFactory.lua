-- Creates units according to their name and type.

local EventBus = require("engine.EventBus")

local registry = {}

local knownUnits = {"Asteroid", "Mine", "Enemy", "Player"}

for i = 1, #knownUnits do
    local name = knownUnits[i]
    local classMod = require("engine." .. name)
    local typesMod = require("engine." .. name .. "Types")
    registry[name] = {classMod = classMod, typesMod = typesMod}
end

local UnitFactory = {}

function UnitFactory.create(group, name, type)
    local entry = registry[name]
    if entry then
        local classMod = entry.classMod
        local typesMod = entry.typesMod
        local unitType = typesMod[type] -- type object
        if unitType then
            x = math.random(200, display.contentWidth - 200) -- TODO: find something smarter
            classMod.create(group, x, nil, unitType)
        end
    end
end

return UnitFactory