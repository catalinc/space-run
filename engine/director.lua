-- The game driver.

local asteroids = require("engine.asteroids")
local enemies = require("engine.enemies")
local mines = require("engine.mines")
local player = require("engine.player")
local events = require("engine.events")

local playerShip
local currentLevel
local currentWave
local lastWaveTime
local getTimer = system.getTimer
local gameLoopTimer

-- -----------------------------------------------------------------------------------
-- Game loop functions
-- -----------------------------------------------------------------------------------

local function isEndOfLevel()
    return enemies.count() + asteroids.count() + mines.count() == 0
end

local function gameLoop()
    if currentLevel then
        asteroids.removeOffScreen()
        enemies.removeOffScreen()
        mines.removeOffScreen()

        local waveData = currentLevel.waves[currentWave]
        if waveData then
            local now = getTimer()
            local elapsed = (now - lastWaveTime) / 1000 -- Seconds
            if elapsed >= waveData.after then
                lastWaveTime = now
                for i = 1, #waveData.generate do
                    local kind = waveData.generate[i]
                    if kind == "enemy" then
                        enemies.spawn(playerShip)
                    elseif kind == "asteroid" then
                        asteroids.spawn(group)
                    elseif kind == "mine" then
                        mines.spawn()
                    end
                end
                currentWave = currentWave + 1
            end
        elseif isEndOfLevel() then events.publish("levelCleared") end
    end
end

-- -----------------------------------------------------------------------------------
-- Collision handling functions
-- -----------------------------------------------------------------------------------

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
        playerShip:increaseScore(enemy.points)
        enemies.remove(enemy)
    end
end

local function onCollision(event)
    if event.phase == "began" then
        local object1 = event.object1
        local object2 = event.object2

        local asteroid = getEntityByName(object1, object2, "asteroid")
        local player = getEntityByName(object1, object2, "player")
        local laser = getEntityByName(object1, object2, "laser")
        local enemy = getEntityByName(object1, object2, "enemy")
        local enemyLaser = getEntityByName(object1, object2, "enemyLaser")
        local mine = getEntityByName(object1, object2, "mine")

        if laser and asteroid then
            playerShip:increaseScore(asteroid.points)
            display.remove(laser)
            asteroids.remove(asteroid)
        elseif laser and enemy then
            display.remove(laser)
            enemyHit(enemy, laser.damage)
        elseif laser and mine then
            playerShip:increaseScore(mine.points)
            display.remove(laser)
            mines.remove(mine)
        elseif enemyLaser and asteroid then
            display.remove(enemyLaser)
            asteroids.remove(asteroid)
        elseif enemyLaser and player then
            display.remove(enemyLaser)
            playerHit(enemyLaser.damage)
        elseif enemy and player then
            enemies.remove(enemy)
            playerHit(enemy.damage)
        elseif asteroid and player then
            asteroids.remove(asteroid)
            playerHit(asteroid.damage)
        end
    end
end

-- -----------------------------------------------------------------------------------
-- Public API
-- -----------------------------------------------------------------------------------

local M = {}

function M.start()
    gameLoopTimer = timer.performWithDelay(500, gameLoop, 0)
    Runtime:addEventListener("collision", onCollision)
end

function M.pause()
    timer.cancel(gameLoopTimer)
    Runtime:removeEventListener("collision", onCollision)
end

function M.stop()
    M.pause()

    asteroids.clear()
    enemies.clear()
    mines.clear()
end

function M.loadLevel(num)
    asteroids.clear()
    enemies.clear()
    mines.clear()

    playerShip = player.new()

    currentWave = 1
    currentLevel = require("levels.level"..num)
    lastWaveTime = getTimer()
end

function M.getScore()
    return playerShip.score
end

return M