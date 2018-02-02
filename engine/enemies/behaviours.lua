-- Enemy behaviour.

local sounds = require("libs.sounds")
local eachframe = require("libs.eachframe")
local laser = require("engine.weapons.laser")

local abs = math.abs
local random = math.random
local HEIGHT = display.contentHeight

local M = {}

function M.grunt(thisEnemy)
    if not thisEnemy.velocitySet then  -- TODO: replace with test on getLinearVelocityY
        xVelocity = random(-5, 5)
        yVelocity = random(20, 150)
        thisEnemy:setLinearVelocity(xVelocity, yVelocity)
        thisEnemy.velocitySet = true
    end

    local target = thisEnemy.target
    if not target then return end
    if target.isExploding then return end
    if not thisEnemy.isVisible then return end -- Don't attack if we are not visible

    local now = eachframe.lastFrameTime
    local dx = abs(thisEnemy.x - target.x)

    if not thisEnemy.lastFireTime then
        thisEnemy.lastFireTime = 0
    end

    if now - thisEnemy.lastFireTime > thisEnemy:getFireInterval() and dx < 10 then
        thisEnemy.lastFireTime = now
        laser.fire(thisEnemy.x, thisEnemy.y,
                   {y = HEIGHT + 40,
                    name="enemyLaser",
                    duration = 2000,
                    damage = thisEnemy:getDamage()})
    end
end

function M.boss(thisEnemy)
    if not thisEnemy.velocitySet then
        xVelocity = random(-5, 5)
        yVelocity = random(20, 150)
        thisEnemy:setLinearVelocity(xVelocity, yVelocity)
        thisEnemy.velocitySet = true
    end

    local target = thisEnemy.target
    if not target then return end
    if target.isExploding then return end
    if not thisEnemy.isVisible then return end -- Don't attack if we are not visible

    local now = eachframe.lastFrameTime
    local dx = abs(thisEnemy.x - target.x)

    if not thisEnemy.lastFireTime then
        thisEnemy.lastFireTime = 0
    end

    if now - thisEnemy.lastFireTime > thisEnemy:getFireInterval() and dx < 10 then
        thisEnemy.lastFireTime = now
        laser.fire(thisEnemy.x, thisEnemy.y,
                   {y = HEIGHT + 40,
                    name="enemyLaser",
                    duration = 2000,
                    damage = thisEnemy:getDamage()})
    end
end

return M