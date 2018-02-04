-- The game driver.

local background = require("engine.ui.background")
local events = require("engine.common.events")
local player = require("engine.player.ship")
local Asteroids = require("engine.asteroids.manager")
local Enemies = require("engine.enemies.manager")
local Mines = require("engine.mines.manager")

local M = {}

local asteroids = Asteroids:new()
local enemies = Enemies:new()
local mines = Mines:new()

local playerShip
local currentLevel
local currentWave
local lastWaveTime
local getTimer = system.getTimer
local gameLoopTimer

local function isEndOfLevel()
    return enemies:count() + asteroids:count() + mines:count() == 0
end

local function gameLoop()
    if currentLevel then
        asteroids:removeOffScreen()
        enemies:removeOffScreen()
        mines:removeOffScreen()

        local waveData = currentLevel.waves[currentWave]
        if waveData then
            local now = getTimer()
            local elapsed = (now - lastWaveTime) / 1000 -- Seconds
            if elapsed >= waveData.after then
                lastWaveTime = now
                for i = 1, #waveData.generate do
                    local entityData = waveData.generate[i]
                    local className = entityData[1]
                    local typeName = entityData[2]
                    if className == "asteroid" then
                        asteroids:spawn(typeName)
                    elseif className == "mine" then
                        mines:spawn(typeName)
                    elseif className == "enemy" then
                        enemies:spawn(typeName, playerShip)
                    end
                end
                currentWave = currentWave + 1
            end
        elseif isEndOfLevel() then events.publish("levelCleared") end
    end
end

local function getEntityByName(object1, object2, name)
    if object1.myName == name then return object1 end
    if object2.myName == name then return object2 end
    return nil
end

local function playerHit(damage)
    if not playerShip.isExploding then
        playerShip:takeDamage(damage)
        if playerShip:isDead() then
            display.remove(playerShip)
            timer.performWithDelay(2000, function() events.publish("gameOver") end)
        end
    end
end

local function enemyHit(enemy, damage)
    enemy:takeDamage(damage)
    if enemy:isDead() then
        playerShip:increaseScore(enemy:getPoints())
        enemies:remove(enemy)
    end
end

local function onCollision(event)
    if event.phase == "began" then
        local o1 = event.object1
        local o2 = event.object2

        local asteroid = getEntityByName(o1, o2, "asteroid")
        local player = getEntityByName(o1, o2, "player")
        local laser = getEntityByName(o1, o2, "laser")
        local enemy = getEntityByName(o1, o2, "enemy")
        local enemyLaser = getEntityByName(o1, o2, "enemyLaser")
        local mine = getEntityByName(o1, o2, "mine")

        if laser and asteroid then
            playerShip:increaseScore(asteroid:getPoints())
            display.remove(laser)
            asteroids:remove(asteroid)
        elseif laser and enemy then
            display.remove(laser)
            enemyHit(enemy, laser.damage)
        elseif laser and mine then
            playerShip:increaseScore(mine:getPoints())
            display.remove(laser)
            mines:remove(mine)
        elseif enemyLaser and asteroid then
            display.remove(enemyLaser)
            asteroids:remove(asteroid)
        elseif enemyLaser and player then
            display.remove(enemyLaser)
            playerHit(enemyLaser.damage)
        elseif enemy and player then
            enemies:remove(enemy)
            playerHit(enemy:getDamage())
        elseif asteroid and player then
            asteroids:remove(asteroid)
            playerHit(asteroid:getDamage())
        elseif mine and player then
            mines:remove(mine)
            playerHit(mine:getDamage())
        end
    end
end

local function removeAllEntities()
    asteroids:clear()
    enemies:clear()
    mines:clear()
end

function M.start()
    background.start()
    gameLoopTimer = timer.performWithDelay(500, gameLoop, 0)
    Runtime:addEventListener("collision", onCollision)
end

function M.resume()
    background.resume()
    gameLoopTimer = timer.performWithDelay(500, gameLoop, 0)
    Runtime:addEventListener("collision", onCollision)
end

function M.pause()
    background.pause()
    timer.cancel(gameLoopTimer)
    Runtime:removeEventListener("collision", onCollision)
end

function M.stop()
    M.pause()
    background.stop()
    removeAllEntities()
end

function M.loadLevel(num)
    removeAllEntities()
    playerShip = player.new()
    currentWave = 1
    currentLevel = require("levels.level"..num)
    lastWaveTime = getTimer()
end

function M.getScore()
    return playerShip.score
end

return M