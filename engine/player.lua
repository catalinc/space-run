-- Player ship

local physics = require( "physics" )
local sounds = require( "libs.sounds" )
local sprites = require( "engine.sprites" )
 
local M = {}

local function clamp( v, min, max )
    if v < min then return min end
    if v > max then return max end
    return v
end

function M.new( group )
    local newPlayer = display.newImageRect( group, sprites, 4, 98, 79 )
    newPlayer.x = display.contentCenterX
    newPlayer.y = display.contentHeight - 100
    newPlayer.myName = "ship" -- Used for collision detection
    newPlayer.lastFireTime = 0
    newPlayer.died = false
    newPlayer.lives = 3

    physics.addBody( newPlayer, { radius=30, isSensor=true } )

    function newPlayer:fireLaser()

        sounds.play( "fire" )

        local newLaser = display.newImageRect( group, sprites, 5, 14, 40 )        
        newLaser.isBullet = true
        newLaser.myName = "laser"
        newLaser.x = self.x
        newLaser.y = self.y

        newLaser:toBack()

        physics.addBody( newLaser, "dynamic", { isSensor=true } )

        transition.to( newLaser, { y=-40, time=500,
            onComplete = function() display.remove( newLaser ) end
        } )
    end

    function newPlayer:touch( event )
        local phase = event.phase
        local now = event.time

        if ( now - self.lastFireTime > 300 ) then
            self:fireLaser()
            self.lastFireTime = now
        end

        if ( "began" == phase ) then
            -- Set touch focus on the player
            display.currentStage:setFocus( self )
            -- Store initial offset position
            self.touchOffsetX = event.x - self.x
            self.touchOffsetY = event.y - self.y

        elseif ( "moved" == phase ) then
            -- Move the player to the new touch position
            self.x = event.x - self.touchOffsetX
            self.y = event.y - self.touchOffsetY

            self.x = clamp( self.x, 0, display.contentWidth )
            self.y = clamp( self.y, 0, display.contentHeight )

        elseif ( "ended" == phase or "cancelled" == phase ) then
            -- Release touch focus on the player
            display.currentStage:setFocus( nil )
        end

        return true  -- Prevents touch propagation to underlying objects
    end

    newPlayer:addEventListener( "touch", newPlayer )

    function newPlayer:isAlive() return self.died == false end

    function newPlayer:isDead() return self.lives == 0 end

    function newPlayer:die()
        sounds.play( "explosion" )

        self.lives = self.lives - 1
        self.died = true
        self.alpha = 0
    end

    function newPlayer:restore()
        self.isBodyActive = false
        self.x = display.contentCenterX
        self.y = display.contentHeight - 100

        -- Fade in the player
        transition.to( self, { alpha=1, time=4000,
            onComplete = function()
                self.isBodyActive = true
                self.died = false
            end
        } )
    end

    return newPlayer
end

return M
