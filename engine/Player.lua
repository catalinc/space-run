-- The player

local physics = require("physics")
local EachFrame = require("libs.EachFrame")
local Sounds = require("libs.Sounds")
local Unit = require("engine.Unit")
local EventBus = require("engine.EventBus")

local MIN_X = 100
local MAX_X = display.contentWidth - 100
local MIN_Y = 0
local MAX_Y = display.contentHeight
local START_X = display.contentCenterX
local START_Y = display.contentHeight - 100

local function clamp(v, min, max)
    if v < min then return min end
    if v > max then return max end
    return v
end

local function onTouch(self, event)
    if self.state == "active" then
        local now = event.time
        if now - self.lastFireTime > self.interval then
            self:fireWeapon("Bullet", "default", {direction = "up"})
            self.lastFireTime = now
        end
        local phase = event.phase
        if "began" == phase then
            display.currentStage:setFocus(self)
            self.touchOffsetX = event.x - self.x
            self.touchOffsetY = event.y - self.y
        elseif "moved" == phase then
            self.x = clamp(event.x - self.touchOffsetX, MIN_X, MAX_X)
            self.y = clamp(event.y - self.touchOffsetY, MIN_Y, MAX_Y)
        elseif "ended" == phase or "cancelled" == phase then
            display.currentStage:setFocus(nil)
        end
    end
    return true
end

local function takeDamage(self, amount)
    if self.state == "active" then
        self.health = self.health - amount
        if self.health <= 0 then
            self.health = 0
            if self.lives > 0 then
                self.lives = self.lives - 1
                self:explode()
            end
        end
        EventBus.publish("playerHit", self)
    end
end

local function explode(self)
    Sounds.play("explosion")
    self.state = "exploding"
    self.alpha = 0
    timer.performWithDelay(1000, function() self:restore() end)
end

local function restore(self)
    self.health = self.maxHealth
    self.isBodyActive = false
    self.x = START_X
    self.y = START_Y

    transition.to(self,{alpha = 1, time = 1000,
                  onComplete = function()
                        self.isBodyActive = true
                        self.state = "active"
                        EventBus.publish("playerRestored", self)
                  end})
end

local function finalize(self)
    EachFrame.remove(self)
    EventBus.publish("unitDestroyed", self)
    EventBus.publish("gameOver", self)
end

local Player = {}

function Player.create(group, x, y, options)
    local newPlayer = Unit.create("Player", group, x, y, options)
    newPlayer.state = "active"
    newPlayer.x = START_X
    newPlayer.y = START_Y
    newPlayer.duration = options.duration or 1000
    newPlayer.interval = options.interval or 300
    newPlayer.radius = options.physics.radius or 30
    newPlayer.lastFireTime = 0
    newPlayer.touchOffsetX = 0
    newPlayer.touchOffsetY = 0

    newPlayer.touch = onTouch
    newPlayer:addEventListener("touch", newPlayer)
    newPlayer.takeDamage = takeDamage
    newPlayer.explode = explode
    newPlayer.restore = restore
    newPlayer.finalize = finalize

    return newPlayer
end

return Player
