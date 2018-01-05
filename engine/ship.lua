-- TODO move all player related code here

local physics = require( "physics" )
local sprites = require( "engine.sprites" )
local sounds  = require( "libs.sounds" )
 
local M = {}

local function clamp( v, min, max )
    if v < min then return min end
    if v > max then return max end
    return v
end

function M.new( group )

    local ship = display.newImageRect( group, sprites, 4, 98, 79 )

    ship.x = display.contentCenterX
    ship.y = display.contentHeight - 100
    ship.myName = "ship" -- Used for collision detection
    ship.lastFireTime = 0
    ship.died = false
    ship.lives = 3

    physics.addBody( ship, { radius=30, isSensor=true } )

    function ship:fireLaser()

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

    function ship:touch( event )

        local phase = event.phase
        local now = event.time

        if ( now - self.lastFireTime > 300 ) then
            self:fireLaser()
            self.lastFireTime = now
        end

        if ( "began" == phase ) then
            -- Set touch focus on the ship
            display.currentStage:setFocus( self )
            -- Store initial offset position
            self.touchOffsetX = event.x - self.x
            self.touchOffsetY = event.y - self.y

        elseif ( "moved" == phase ) then
            -- Move the ship to the new touch position
            self.x = event.x - self.touchOffsetX
            self.y = event.y - self.touchOffsetY

            self.x = clamp( self.x, 0, display.contentWidth )
            self.y = clamp( self.y, 0, display.contentHeight )

        elseif ( "ended" == phase or "cancelled" == phase ) then
            -- Release touch focus on the ship
            display.currentStage:setFocus( nil )
        end

        return true  -- Prevents touch propagation to underlying objects
    end

    ship:addEventListener( "touch", ship )

    function ship:isAlive()
        return self.died == false
    end

    function ship:isReallyDead()
        return self.lives == 0
    end

    function ship:die()

        sounds.play( "explosion" )

        self.lives = self.lives - 1
        self.died = true
        self.alpha = 0
    end

    function ship:restore()

        self.isBodyActive = false
        self.x = display.contentCenterX
        self.y = display.contentHeight - 100

        -- Fade in the ship
        transition.to( self, { alpha=1, time=4000,
            onComplete = function()
                self.isBodyActive = true
                self.died = false
            end
        } )
    end

    return ship
end

return M
