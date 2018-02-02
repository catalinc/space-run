-- Asteroid behaviours.

local M = {}

local WIDTH = display.contentWidth
local random = math.random

function M.flyRandom(thisAsteroid)
    xVelocity, yVelocity = thisAsteroid:getLinearVelocity()
    if xVelocity == 0 and yVelocity == 0 then
        local whereFrom = random(3)
        if whereFrom == 1 then
            -- From the left
            thisAsteroid.x = -60
            thisAsteroid.y = random(500)
            thisAsteroid:setLinearVelocity(random(40, 120), random(20, 60))
        elseif whereFrom == 2 then
            -- From the top
            thisAsteroid.x = random(WIDTH)
            thisAsteroid.y = -60
            thisAsteroid:setLinearVelocity(random(-40, 40), random(40, 120))
        elseif whereFrom == 3 then
            -- From the right
            thisAsteroid.x = WIDTH + 60
            thisAsteroid.y = random(500)
            thisAsteroid:setLinearVelocity(random(-120, -40), random(20, 60))
        end

        thisAsteroid:applyTorque(random(-6, 6))
    end
end

return M