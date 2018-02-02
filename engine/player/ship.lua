-- Player's ship.

local physics = require("physics")
local sounds = require("libs.sounds")
local groups = require("engine.ui.groups")
local events = require("engine.ui.events")
local sprites = require("engine.ui.sprites")
local laser = require("engine.weapons.laser")
local mathutils = require("engine.common.mathutils")

local M = {}

local WIDTH = display.contentWidth
local HEIGHT = display.contentHeight
local MIN_X = 100
local MAX_X = WIDTH - 100
local MIN_Y = 0
local MAX_Y = HEIGHT
local clamp = mathutils.clamp

function M.new(options)
    options = options or {}
    local group = groups.get("main")
    local newPlayer = display.newImageRect(group, sprites, 4, 98, 79)
    newPlayer.x = display.contentCenterX
    newPlayer.y = display.contentHeight - 100
    newPlayer.score = options.score or 0
    newPlayer.lives = options.lives or 3
    newPlayer.maxHealth = options.maxHealth or 100
    newPlayer.health = options.health or newPlayer.maxHealth
    newPlayer.myName = "player" -- Used for collision detection
    newPlayer.lastFireTime = 0
    newPlayer.touchOffsetX = 0
    newPlayer.touchOffsetY = 0
    newPlayer.isExploding = false

    physics.addBody(newPlayer, {radius = 30, isSensor = true})

    function newPlayer:touch(event)
        if self.isExploding then return end

        local now = event.time
        if now - self.lastFireTime > 300 then
            laser.fire(self.x, self.y, {y = -40, duration = 1000, damage = 40})
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

        return true
    end

    newPlayer:addEventListener("touch", newPlayer)

    function newPlayer:takeDamage(amount)
        if self.isExploding then return end

        self.health = self.health - amount
        if self.health <= 0 then
            self.health = 0
            self:die()
        end

        events.publish("playerHit",
                       {lives = self.lives, health = self.health, maxHealth = self.maxHealth})
    end

    function newPlayer:die()
        sounds.play("explosion")

        self.lives = self.lives - 1
        self.alpha = 0
        self.isExploding = true

        if self.lives > 0 then
            timer.performWithDelay(1000, function() self:restore() end)
        end
    end

    function newPlayer:isDead()
        return self.lives == 0
    end

    function newPlayer:restore()
        self.health = 100
        self.isBodyActive = false
        self.x = display.contentCenterX
        self.y = display.contentHeight - 100

        transition.to(self,
                      {alpha = 1, time = 1000, onComplete = function()
                            self.isBodyActive = true
                            self.isExploding = false
                            events.publish("playerRestored",
                                           {lives = self.lives, health = self.health, maxHealth = self.maxHealth})
                        end})
    end

    function newPlayer:increaseScore(amount)
        self.score = self.score + amount
        events.publish("scoreIncreased", self.score)
    end

    return newPlayer
end

return M
