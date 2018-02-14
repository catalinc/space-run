-- Spawns units and keeps track of the population

local EventBus = require("engine.EventBus")

local unitNames = {"Asteroid", "Mine", "Enemy", "Player"}

local Spawner = {}
Spawner.__index = Spawner

function Spawner.new(group)
    local newSpawner = {}

    newSpawner.group = group
    newSpawner.counter = {}
    newSpawner.registry = {}

    for i = 1, #unitNames do
        local name = unitNames[i]
        local classMod = require("engine." .. name)
        local typesMod = require("engine." .. name .. "Types")
        newSpawner.registry[name] = {classMod = classMod, typesMod = typesMod}
    end

    newSpawner.unitCreated = function (unit)
        local name = unit.name
        local count = newSpawner.counter[name] or 0
        newSpawner.counter[name] = count + 1
    end

    newSpawner.unitDestroyed = function (unit)
        local name = unit.name
        local count = newSpawner.counter[name] or 0
        newSpawner.counter[name] = count - 1
    end

    EventBus.subscribe("unitCreated", newSpawner.unitCreated)
    EventBus.subscribe("unitDestroyed", newSpawner.unitDestroyed)

    return setmetatable(newSpawner, Spawner)
end

function Spawner:spawn(name, type)
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

function Spawner:getUnitsCount(names)
    local total = 0
    for i = 1, #names do
        local name = names[i]
        total = total + (self.counter[name] or 0)
    end
    return total
end

function Spawner:destroy()
    EventBus.unsubscribe("unitCreated", self.unitCreated)
    EventBus.unsubscribe("unitDestroyed", self.unitDestroyed)
    self.registry = nil
    self.counter = nil
end

return Spawner