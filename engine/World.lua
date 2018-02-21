-- The game driver.

local Starfield = require("engine.Starfield")
local EventBus = require("engine.EventBus")
local UnitFactory = require("engine.UnitFactory")
local CollisionHandler = require("engine.CollisionHandler")

local World = {}
World.__index = World

function World.new(group)
    local newWorld = {}

    local backGroup = display.newGroup()
    group:insert(backGroup)

    local foreGroup = display.newGroup()
    group:insert(foreGroup)

    newWorld.foreGroup = foreGroup
    newWorld.backGroup = backGroup

    newWorld.starfield = Starfield.new(backGroup)
    newWorld.collisionHandler = CollisionHandler.new(newWorld)

    newWorld.unitCounter = {}

    newWorld.unitCreated = function (unit)
        local name = unit.name
        local count = newWorld.unitCounter[name] or 0
        newWorld.unitCounter[name] = count + 1
    end

    newWorld.unitDestroyed = function (unit)
        local name = unit.name
        local count = newWorld.unitCounter[name] or 0
        newWorld.unitCounter[name] = count - 1
    end

    EventBus.subscribe("unitCreated", newWorld.unitCreated)
    EventBus.subscribe("unitDestroyed", newWorld.unitDestroyed)

    return setmetatable(newWorld, World)
end

function World:start()
    self.starfield:start()
    self.collisionHandler:start()
    self.timer = timer.performWithDelay(500, function() self:tick() end, 0)
end

function World:pause()
    self.starfield:stop()
    self.collisionHandler:stop()
    timer.cancel(self.timer)
end

function World:resume()
    self.starfield:start()
    self.collisionHandler:start()
    self.timer = timer.performWithDelay(500, function() self:tick() end, 0)
end

function World:destroy()
    self:pause()

    EventBus.unsubscribe("unitCreated", self.unitCreated)
    EventBus.unsubscribe("unitDestroyed", self.unitDestroyed)
    self.unitCounter = nil

    self.collisionHandler = nil

    self.starfield:destroy()
    self.starfield = nil

    display.remove(self.rootGroup)
    self.rootGroup = nil
end

function World:loadLevel(num)
    self.currentLevel = require("levels.Level"..num)
    self.currentWave = 1
    self.wavesCount = #self.currentLevel.waves
    self.lastWaveTime = system.getTimer()
    self.unitCounter = {}
end

function World:isEndOfLevel()
    local names = {"Asteroid", "Mine", "Enemy"}
    local total = 0
    for i = 1, #names do
        local name = names[i]
        total = total + (self.unitCounter[name] or 0)
    end
    return total == 0
end

function World:tick()
    if self.currentLevel then
        local waveData = self.currentLevel.waves[self.currentWave]
        if waveData then
            local now = system.getTimer()
            local elapsed = (now - self.lastWaveTime) / 1000 -- seconds
            if elapsed >= waveData.after then
                self.lastWaveTime = now
                for i = 1, #waveData.generate do
                    local toGenerate = waveData.generate[i]
                    local name = toGenerate[1]
                    local type = toGenerate[2]
                    UnitFactory.create(self.foreGroup, name, type)
                end
                self.currentWave = self.currentWave + 1
                local current = self.currentWave
                if current > self.wavesCount then current = self.wavesCount end
                EventBus.publish("newWave", {current = current, total = self.wavesCount})
            end
        elseif self:isEndOfLevel() then
            EventBus.publish("levelCleared")
        end
    end
end

return World