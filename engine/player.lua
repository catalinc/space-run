-- Player ship

local physics = require("physics")
local sounds = require("libs.sounds")
local sprites = require("engine.sprites")

local M = {}

local function clamp( v, min, max )
    if v < min then return min end
    if v > max then return max end
    return v
end

function M.newShip(group)
    group = group or display.currentStage

    local newShip = display.newImageRect(group, sprites, 4, 98, 79)
    newShip.x = display.contentCenterX
    newShip.y = display.contentHeight - 100
    newShip.myName = "ship" -- Used for collision detection
    newShip.lastFireTime = 0
    newShip.isExploding = false
    newShip.lives = 3

    physics.addBody(newShip, {radius=30, isSensor=true})

    function newShip:fireLaser()
        sounds.play( "fire" )

        local newLaser = display.newImageRect(group, sprites, 5, 14, 40)
        newLaser.isBullet = true
        newLaser.myName = "laser"
        newLaser.x = self.x
        newLaser.y = self.y

        newLaser:toBack()
        physics.addBody(newLaser, "dynamic", {isSensor=true})

        transition.to(newLaser, {y=-40, time=500,
            onComplete = function() display.remove(newLaser) end
        })
    end

    function newShip:touch(event)
        if self.isExploding then return end

        local phase = event.phase

        local now = event.time
        if now - self.lastFireTime > 300 then
            self:fireLaser()
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
            self.x = clamp(self.x, 0, display.contentWidth)
            self.y = clamp(self.y, 0, display.contentHeight)
        elseif "ended" == phase or "cancelled" == phase then
            -- Release touch focus on the player
            display.currentStage:setFocus(nil)
        end

        return true  -- Prevents touch propagation to underlying objects
    end

    newShip:addEventListener("touch", newShip)

    function newShip:isDead() return self.lives == 0 end

    function newShip:explode()
        sounds.play("explosion")

        self.lives = self.lives - 1
        self.isExploding = true
        self.alpha = 0
    end

    function newShip:restore()
        self.isBodyActive = false
        self.x = display.contentCenterX
        self.y = display.contentHeight - 100

        -- Fade in the player
        transition.to(self, {alpha=1, time=2000,
            onComplete = function()
                self.isBodyActive = true
                self.isExploding = false
            end
        })
    end

    return newShip
end

return M
