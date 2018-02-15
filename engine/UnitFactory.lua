-- Spawns units and keeps track of the population

local EventBus = require("engine.EventBus")

local unitNames = {"Asteroid", "Mine", "Enemy", "Player"}

local UnitFactory = {}
UnitFactory.__index = UnitFactory

function UnitFactory.new(group)
    local newUnitFactory = {}

    newUnitFactory.group = group
    newUnitFactory.counter = {}
    newUnitFactory.registry = {}

    for i = 1, #unitNames do
        local name = unitNames[i]
        local classMod = require("engine." .. name)
        local typesMod = require("engine." .. name .. "Types")
        newUnitFactory.registry[name] = {classMod = classMod, typesMod = typesMod}
    end

    newUnitFactory.unitCreated = function (unit)
        local name = unit.name
        local count = newUnitFactory.counter[name] or 0
        newUnitFactory.counter[name] = count + 1
    end

    newUnitFactory.unitDestroyed = function (unit)
        local name = unit.name
        local count = newUnitFactory.counter[name] or 0
        newUnitFactory.counter[name] = count - 1
    end

    EventBus.subscribe("unitCreated", newUnitFactory.unitCreated)
    EventBus.subscribe("unitDestroyed", newUnitFactory.unitDestroyed)

    return setmetatable(newUnitFactory, UnitFactory)
end

function UnitFactory:create(name, type)
    local entry = self.registry[name]
    if entry then
        local classMod = entry.classMod
        local typesMod = entry.typesMod
        local unitType = typesMod[type]
        if unitType then
            x = math.random(200, display.contentWidth - 200) -- TODO: find something smarter
            classMod.create(self.group, x, nil, unitType)
        end
    end
end

function UnitFactory:getUnitsCount(names)
    local total = 0
    for i = 1, #names do
        local name = names[i]
        total = total + (self.counter[name] or 0)
    end
    return total
end

function UnitFactory:destroy()
    EventBus.unsubscribe("unitCreated", self.unitCreated)
    EventBus.unsubscribe("unitDestroyed", self.unitDestroyed)
    self.registry = nil
    self.counter = nil
end

return UnitFactory