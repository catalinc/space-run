-- Spawns units and keeps track of the population

local EventBus = require("engine.EventBus")

local ClassNames = {"Asteroid", "Mine", "Enemy", "Player"}

local Spawner = {}
Spawner.__index = Spawner

function Spawner.new(group)
    local newSpawner = {}

    newSpawner.group = group
    newSpawner.counter = {}
    newSpawner.registry = {}

    for i = 1, #ClassNames do
        local className = ClassNames[i]
        local classMod = require("engine." .. className)
        local typesMod = require("engine." .. className .. "Types")
        newSpawner.registry[className] = {classMod = classMod, typesMod = typesMod}
    end

    newSpawner.unitCreated = function (unit)
        local className = unit.className
        local count = newSpawner.counter[className] or 0
        newSpawner.counter[className] = count + 1
    end

    newSpawner.unitDestroyed = function (unit)
        local className = unit.className
        local count = newSpawner.counter[className] or 0
        newSpawner.counter[className] = count - 1
    end

    EventBus.subscribe("unitCreated", newSpawner.unitCreated)
    EventBus.subscribe("unitDestroyed", newSpawner.unitDestroyed)

    return setmetatable(newSpawner, Spawner)
end

function Spawner:spawn(className, typeName)
    local classEntry = self.registry[className]
    if classEntry then
        local classMod = classEntry.classMod
        local typesMod = classEntry.typesMod
        local unitType = typesMod[typeName]
        if unitType then
            x = math.random(200, display.contentWidth - 200) -- TODO: find something smarter
            classMod.new(self.group, x, nil, unitType)
        end
    end
end

function Spawner:getUnitsCount(classNames)
    local total = 0
    for i = 1, #classNames do
        local className = classNames[i]
        total = total + (self.counter[className] or 0)
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