-- Asteroids field

local physics = require( "physics" )
local sounds = require( "libs.sounds" )
local sprites = require( "engine.sprites" )

local M = {}

local asteroidsTable = {}

-- Create new asteroid
function M.generate( group )
    local newAsteroid = display.newImageRect( group, sprites, 1, 102, 85 )
    newAsteroid.myName = "asteroid" -- Used for collision detection
    table.insert( asteroidsTable, newAsteroid )
    physics.addBody( newAsteroid, "dynamic", { radius=40, bounce=0.8 } )

    local whereFrom = math.random( 3 )
    if ( whereFrom == 1 ) then
        -- From the left
        newAsteroid.x = -60
        newAsteroid.y = math.random( 500 )
        newAsteroid:setLinearVelocity( math.random( 40,120 ), math.random( 20,60 ) )
    elseif ( whereFrom == 2 ) then
        -- From the top
        newAsteroid.x = math.random( display.contentWidth )
        newAsteroid.y = -60
        newAsteroid:setLinearVelocity( math.random( -40,40 ), math.random( 40,120 ) )
    elseif ( whereFrom == 3 ) then
        -- From the right
        newAsteroid.x = display.contentWidth + 60
        newAsteroid.y = math.random( 500 )
        newAsteroid:setLinearVelocity( math.random( -120,-40 ), math.random( 20,60 ) )
    end

    newAsteroid:applyTorque( math.random( -6,6 ) )
end

-- Remove asteroids which have drifted off screen
function M.removeDrifted()
    for i = #asteroidsTable, 1, -1 do
        local thisAsteroid = asteroidsTable[i]
        if ( thisAsteroid.x < -100 or
             thisAsteroid.x > display.contentWidth + 100 or
             thisAsteroid.y < -100 or
             thisAsteroid.y > display.contentHeight + 100 )
        then
            display.remove( thisAsteroid )
            table.remove( asteroidsTable, i )
        end
    end
end

-- Remove a specific asteroid (e.g. after collision)
function M.remove( asteroid )
    for i = #asteroidsTable, 1, -1 do
        if asteroidsTable[i] == asteroid then
            sounds.play( "explosion" )
            display.remove( asteroid )
            table.remove( asteroidsTable, i )
            break
        end
    end
end

-- Remove all asteroids (e.g. before switch scene)
function M.cleanup()
    for i = #asteroidsTable, 1, -1 do
        display.remove( asteroidsTable[i] )
        table.remove( asteroidsTable, i )
    end
end

return M