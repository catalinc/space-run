-- The game driver.

local Background = require("engine.Background")
local EventBus = require("engine.EventBus")
local Spawner = require("engine.Spawner")
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

    newWorld.background = Background.new(backGroup)
    newWorld.spawner = Spawner.new(foreGroup)
    newWorld.collision = CollisionHandler.new(newWorld)

    return setmetatable(newWorld, World)
end

function World:start()
    self.background:start()
    self.collision:start()
    self.timer = timer.performWithDelay(500, function() self:tick() end, 0)
end

function World:pause()
    self.background:pause()
    self.collision:stop()
    timer.cancel(self.timer)
end

function World:resume()
    self.background:resume()
    self.collision:start()
    self.timer = timer.performWithDelay(500, function() self:tick() end, 0)
end

function World:destroy()
    self:pause()

    self.collision = nil

    self.spawner:destroy()
    self.spawner = nil

    self.background:destroy()
    self.background = nil

    display.remove(self.rootGroup)
    self.rootGroup = nil
end

function World:loadLevel(num)
    self.currentLevel = require("levels.Level"..num)
    self.currentWave = 1
    self.wavesCount = #self.currentLevel.waves
    self.lastWaveTime = system.getTimer()
end

function World:isEndOfLevel()
    return self.spawner:getUnitsCount({"Asteroid", "Mine", "Enemy"}) == 0
end

function World:tick()
    if self.currentLevel then
        local waveData = self.currentLevel.waves[self.currentWave]
        if waveData then
            local now = system.getTimer()
            local elapsed = (now - self.lastWaveTime) / 1000 -- Seconds
            if elapsed >= waveData.after then
                self.lastWaveTime = now
                for i = 1, #waveData.generate do
                    local toGenerate = waveData.generate[i]
                    local name = toGenerate[1]
                    local type = toGenerate[2]
                    self.spawner:spawn(name, type)
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