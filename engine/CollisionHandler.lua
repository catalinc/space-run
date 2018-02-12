-- Collision handling

local EventBus = require("engine.EventBus")

local CollisionHandler = {}
CollisionHandler.__index = CollisionHandler

function CollisionHandler.new(world)
    local newHandler = {}
    newHandler.world = world
    newHandler.globalHandler = function (event)
        newHandler:onCollision(event)
    end
    return setmetatable(newHandler, CollisionHandler)
end

function CollisionHandler:start()
    Runtime:addEventListener("collision", self.globalHandler)
end

function CollisionHandler:stop()
    Runtime:removeEventListener("collision", self.globalHandler)
end

function CollisionHandler:onCollision(event)
    if event.phase == "began" then
        local o1 = event.object1
        local o2 = event.object2

        local asteroid = self:getUnit(o1, o2, "Asteroid")
        local mine = self:getUnit(o1, o2, "Mine")
        local player = self:getUnit(o1, o2, "Player")
        local enemy = self:getUnit(o1, o2, "Enemy")
        local playerLaser = self:getUnit(o1, o2, "PlayerLaser")
        local enemyLaser = self:getUnit(o1, o2, "EnemyLaser")

        if playerLaser and asteroid then
            display.remove(playerLaser)
            display.remove(asteroid)
        elseif playerLaser and enemy then
            display.remove(playerLaser)
            self:enemyHit(enemy, playerLaser)
        elseif playerLaser and mine then
            display.remove(playerLaser)
            display.remove(mine)
        elseif enemyLaser and asteroid then
            display.remove(enemyLaser)
            display.remove(asteroid)
        elseif enemyLaser and player then
            display.remove(enemyLaser)
            self:playerHit(player, enemyLaser)
        elseif enemy and player then
            self:playerHit(player, enemy)
            display.remove(enemy)
        elseif asteroid and player then
            self:playerHit(player, asteroid)
            display.remove(asteroid)
        elseif mine and player then
            self:playerHit(player, mine)
            display.remove(mine)
        end
    end
end

function CollisionHandler:getUnit(o1, o2, className)
    if o1.className == className then return o1 end
    if o2.className == className then return o2 end
end

function CollisionHandler:playerHit(player, who)
    player:takeDamage(who.damage)
    if player:isDead() then
        display.remove(player)
        timer.performWithDelay(2000, function() EventBus.publish("gameOver") end)
    end
end

function CollisionHandler:enemyHit(enemy, who)
    enemy:takeDamage(who.damage)
    if enemy:isDead() then
        local player = who.source
        display.remove(enemy)
    end
end

return CollisionHandler