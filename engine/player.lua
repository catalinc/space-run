-- Player's ship.

local physics = require("physics")
local sounds = require("libs.sounds")
local mathutils = require("libs.mathutils")
local sprites = require("engine.sprites")
local laser = require("engine.laser")

local WIDTH = display.contentWidth
local HEIGHT = display.contentHeight
local MIN_X = 100
local MAX_X = WIDTH - 100
local MIN_Y = 0
local MAX_Y = HEIGHT

local clamp = mathutils.clamp

-- -----------------------------------------------------------------------------------
-- Public API
-- -----------------------------------------------------------------------------------

local M = {}

function M.new(group)
    local newPlayer = display.newImageRect(group, sprites, 4, 98, 79)
    newPlayer.x = display.contentCenterX
    newPlayer.y = display.contentHeight - 100
    newPlayer.health = 100
    newPlayer.myName = "ship" -- Used for collision detection
    newPlayer.lastFireTime = 0
    newPlayer.touchOffsetX = 0
    newPlayer.touchOffsetY = 0

    physics.addBody(newPlayer, {radius = 30, isSensor = true})

    function newPlayer:touch(event)
        if not self.isBodyActive then
            return
        end

        local phase = event.phase

        local now = event.time
        if now - self.lastFireTime > 300 then
            sounds.play("fire")
            laser.fire(group, self.x, self.y, {y = -40, duration = 1000, damage = 40})
            self.lastFireTime = now
        end

        if "began" == phase then
            -- Set touch focus on the player
            display.currentStage:setFocus(self)
            -- Store initial offset position
            self.touchOffsetX = event.x - self.x
            self.touchOffsetY = event.y - self.y
        elseif "moved" == phase then
            -- Move the player to the new touch position
            self.x = event.x - self.touchOffsetX
            self.y = event.y - self.touchOffsetY
            self.x = clamp(self.x, MIN_X, MAX_X)
            self.y = clamp(self.y, MIN_Y, MAX_Y)
        elseif "ended" == phase or "cancelled" == phase then
            -- Release touch focus on the player
            display.currentStage:setFocus(nil)
        end

        return true -- Prevents touch propagation to underlying objects
    end

    newPlayer:addEventListener("touch", newPlayer)

    function newPlayer:explode()
        sounds.play("explosion")
        self.alpha = 0
    end

    function newPlayer:restore()
        self.isBodyActive = false
        self.x = display.contentCenterX
        self.y = display.contentHeight - 100

        transition.to(self, {alpha = 1, time = 2000, onComplete = function()
            self.isBodyActive = true
        end})
    end

    return newPlayer
end

return M
