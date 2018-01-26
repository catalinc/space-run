-- The bad guys

local physics = require("physics")
local sounds = require("libs.sounds")
local eachframe = require("libs.eachframe")
local sprites = require("engine.sprites")
local entities = require("engine.entities")
local healthbar = require("engine.healthbar")
local mathutils = require("libs.mathutils")

local CW = display.contentWidth
local CH = display.contentHeight
local abs = math.abs
local random = math.random
local randomSequence = mathutils.randomSequence

local MAX_LANES = 4
local LANE_WIDTH = CW / MAX_LANES
local randomLanes = {}

local collection = entities.new()

-- -----------------------------------------------------------------------------------
-- Public API
-- -----------------------------------------------------------------------------------

local M = {}

function M.create(group, playerShip)
    local newEnemy = display.newImageRect(group, sprites, 4, 98, 79)
    newEnemy.yScale = -1
    newEnemy.myName = "enemy" -- Used for collision detection
    newEnemy.lastFireTime = 0
    newEnemy.scorePoints = 100

    newEnemy.health = 100
    newEnemy.maxHealth = 100
    newEnemy.healthBar = healthbar.new(group, newEnemy.contentWidth - 10, 5)

    if #randomLanes == 0 then randomLanes = randomSequence(0, MAX_LANES - 1) end
    local lane = table.remove(randomLanes, 1)

    newEnemy.y = -60
    newEnemy.x = LANE_WIDTH * (lane + 0.5)

    physics.addBody(newEnemy, {radius = 30, isSensor = true})
    newEnemy:setLinearVelocity(random(-40, 40), random(40, 120))

    function newEnemy:eachFrame()
        self.healthBar.x = self.x - (self.contentWidth / 2) + 5
        self.healthBar.y = self.y - (self.contentHeight / 2) - 5

        if self.y < 50 then return end -- No need to fire laser because we are outside screen
        if playerShip.isExploding then return end

        local now = eachframe.lastFrameTime
        local dx = abs(self.x - playerShip.x)

        if now - self.lastFireTime > 500 and dx < 10 then
            self.lastFireTime = now
            self:fireLaser()
        end
    end

    function newEnemy:fireLaser()
        sounds.play("fire")

        local newLaser = display.newImageRect(group, sprites, 5, 14, 40)
        newLaser.isBullet = true
        newLaser.myName = "enemyLaser"
        newLaser.x = self.x
        newLaser.y = self.y

        newLaser:toBack()

        physics.addBody(newLaser, "dynamic", {isSensor = true})

        transition.to(newLaser, {y = CH + 40, time = 2000, onComplete = function() display.remove(newLaser) end})
    end

    eachframe.add(newEnemy)

    function newEnemy:finalize(event)
        eachframe.remove(self)
    end

    newEnemy:addEventListener("finalize")

    function newEnemy:takeDamage(amount)
        self.health = self.health - amount
        if self.health < 0 then self.health = 0 end
        self.healthBar:setHealth(self.health, self.maxHealth)
    end

    function newEnemy:isDead()
        return self.health == 0
    end

    function newEnemy:destroy()
        if self.healthBar then display.remove(self.healthBar) end
        self:removeSelf()
    end

    collection:add(newEnemy)
end

function M.remove(asteroid)
    collection:remove(asteroid)
end

function M.collect()
    collection:collect()
end

function M.cleanup()
    collection:clear()
end

function M.count()
    return collection:count()
end

return M