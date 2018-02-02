-- Enemy ship.

local physics = require("physics")
local eachframe = require("libs.eachframe")
local groups = require("engine.ui.groups")
local healthbar = require("engine.ui.healthbar")

local M = {}

function M.new(x, y, enemyType, target)
    local group = groups.get("main")
    local sprite = enemyType.sprite
    local newEnemy = display.newImageRect(group, sprite.sheet, sprite.frameIndex, sprite.width, sprite.height)
    newEnemy.yScale = -1
    newEnemy.x = x
    newEnemy.y = y
    newEnemy.type = enemyType
    newEnemy.health = enemyType.maxHealth
    newEnemy.target = target
    newEnemy.myName = "enemy" -- Used for collision detection
    newEnemy.healthBar = healthbar.new(group, x, y, newEnemy.contentWidth - 10, 5)

    physics.addBody(newEnemy, {radius = 30, isSensor = true})

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

    return newEnemy
end

return M