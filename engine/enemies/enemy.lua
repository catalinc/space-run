-- Enemy ship.

local physics = require("physics")
local eachframe = require("libs.eachframe")
local healthbar = require("engine.ui.healthbar")
local laser = require("engine.weapons.laser")
local groups = require("engine.common.groups")

local abs = math.abs
local max = math.max
local rnd = math.random
local HEIGHT = display.contentHeight

local M = {}

function M.new(x, y, typeObject, target)
    local group = groups.get("main")
    local sprite = typeObject.sprite
    local newEnemy = display.newImageRect(group, sprite.sheet, sprite.frameIndex, sprite.width, sprite.height)
    newEnemy.yScale = -1
    newEnemy.x = x
    newEnemy.y = y
    newEnemy.type = typeObject
    newEnemy.health = typeObject.maxHealth
    newEnemy.target = target
    newEnemy.myName = "enemy" -- Used for collision detection
    newEnemy.state = "idle"
    newEnemy.healthBar = healthbar.new(group, x, y, newEnemy.contentWidth - 10, 5)
    newEnemy.lastFireTime = 0

    physics.addBody(newEnemy, {radius = sprite.radius, isSensor = true})

    function newEnemy:eachFrame()
        self.healthBar.x = self.x - (self.contentWidth / 2) + 5
        self.healthBar.y = self.y - (self.contentHeight / 2) - 5
        newEnemy.type.behaviour(self)
    end

    eachframe.add(newEnemy)

    function newEnemy:takeDamage(amount)
        self.health = self.health - amount
        if self.health < 0 then
            self.health = 0
        end
        self.healthBar:setHealth(self.health, self.type.maxHealth)
    end

    function newEnemy:isDead()
        return self.health == 0
    end

    function newEnemy:getFireInterval()
        return self.type.fireInterval
    end

    function newEnemy:getFireDuration()
        return self.type.fireDuration
    end

    function newEnemy:getDamage()
        return self.type.damage
    end

    function newEnemy:getPoints()
        return self.type.points
    end

    function newEnemy:finalize(event)
        display.remove(self.healthBar)
        eachframe.remove(self)
    end

    newEnemy:addEventListener("finalize")

    function newEnemy:canAttack()
        if not self.isVisible then return false end
        if not self.target then return false end
        if self.target.isExploding then return false end
        return true
    end

    function newEnemy:fireLaser()
        local target = self.target
        if not target then return end
        local now = eachframe.lastFrameTime
        local dx = abs(self.x - target.x)
        if (now - self.lastFireTime > self:getFireInterval()) and dx < target.radius then
            laser.fire(self.x, self.y,
                       {y = HEIGHT + 40, name="enemyLaser",
                       duration = self:getFireDuration(), damage = self:getDamage()})
            self.lastFireTime = eachframe.lastFrameTime
        end
    end

    function newEnemy:moveToIntercept()
        local target = self.target
        if not target then return end
        local toX = target.x
        local toY = max(0, target.y - target.radius * 15)
        self.state = "moving"
        transition.to(self, {x = toX, y = toY, time = 2000,
                       onComplete = function() self.state = "idle" end})
    end

    function newEnemy:fall()
        self.state = "moving"
        self:setLinearVelocity(rnd(-5, 5), rnd(20, 150))
    end

    return newEnemy
end

return M