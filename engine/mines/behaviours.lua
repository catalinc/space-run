-- Mine behaviours.

local M = {}

local WIDTH = display.contentWidth
local random = math.random

function M.fall(thisMine)
    xVelocity, yVelocity = thisMine:getLinearVelocity()
    if xVelocity == 0 and yVelocity == 0 then
        thisMine.x = random(30, WIDTH - 30)
        thisMine.y = -60
        thisMine:setLinearVelocity(random(-40, 40), random(40, 120))
    end
end

return M