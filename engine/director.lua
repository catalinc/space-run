-- The game driver.

local background = require("engine.background")
local asteroids = require("engine.asteroids")
local enemies = require("engine.enemies")
local mines = require("engine.mines")
local player = require("engine.player")

local listenersTable = {}
local ship

local currentLevel
local currentWave
local lastWaveTime
local getTimer = system.getTimer
local gameLoopTimer

local score = 0
local lives = 3

local entityGroup

-- -----------------------------------------------------------------------------------
-- Game loop functions
-- -----------------------------------------------------------------------------------

local function invokeListener(name, arg)
    local listener = listenersTable[name]
    if listener then listener(arg) end
end

local function isEndOfLevel()
    return enemies.count() + asteroids.count() + mines.count() == 0
end

local function gameLoop()
    if currentLevel then
        asteroids.collect()
        enemies.collect()
        mines.collect()

        local wave = currentLevel.waves[currentWave]
        if wave then
            local now = getTimer()
            local elapsed = (now - lastWaveTime) / 1000
            if elapsed >= wave.after then
                lastWaveTime = now
                currentWave = currentWave + 1
                for i = 1, #wave.generate do
                    local kind = wave.generate[i]
                    if kind == "enemy" then
                        enemies.create(entityGroup, ship)
                    elseif kind == "asteroid" then
                        asteroids.create(entityGroup)
                    elseif kind == "mine" then
                        mines.create(entityGroup)
                    end
                end
            end
        elseif isEndOfLevel() then invokeListener("endLevel") end
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

local function increaseScore(amount)
    score = score + amount
    invokeListener("score", score)
end

local function killPlayer()
    if not ship.isExploding then
        ship:explode()

        lives = lives - 1
        invokeListener("life", lives)

        if lives == 0 then
            display.remove(ship)
            timer.performWithDelay(2000, function() invokeListener("gameOver") end)
        else
            timer.performWithDelay(1000, function () ship:restore() end)
        end
    end
end

local function onCollision(event)
    if event.phase == "began" then
        local object1 = event.object1
        local object2 = event.object2

        local asteroid = getEntityByName(object1, object2, "asteroid")
        local player = getEntityByName(object1, object2, "ship")
        local laser = getEntityByName(object1, object2, "laser")
        local enemy = getEntityByName(object1, object2, "enemy")
        local enemyLaser = getEntityByName(object1, object2, "enemyLaser")
        local mine = getEntityByName(object1, object2, "mine")

        if laser and asteroid then
            increaseScore(asteroid.scorePoints)
            display.remove(laser)
            asteroids.remove(asteroid)
        elseif laser and enemy then
            display.remove(laser)
            enemy:takeDamage(laser.damage)
            if enemy:isDead() then
                increaseScore(enemy.scorePoints)
                enemies.remove(enemy)
            end
        elseif laser and mine then
            increaseScore(mine.scorePoints)
            display.remove(laser)
            mines.remove(mine)
        elseif enemyLaser and asteroid then
            display.remove(enemyLaser)
            asteroids.remove(asteroid)
        elseif enemyLaser and player then
            display.remove(enemyLaser)
            killPlayer()
        elseif enemy and player then
            enemies.remove(enemy)
            killPlayer()
        end
    end
end

-- -----------------------------------------------------------------------------------
-- Public API
-- -----------------------------------------------------------------------------------

local M = {}

function M.init(mainGroup, backGroup)
    entityGroup = mainGroup
    ship = player.new(entityGroup)
    score = 0
    lives = 3

    background.init(backGroup)
end

function M.start()
    background.start()

    gameLoopTimer = timer.performWithDelay(500, gameLoop, 0)
    Runtime:addEventListener("collision", onCollision)
end

function M.pause()
    background.stop()

    timer.cancel(gameLoopTimer)
    gameLoopTimer = nil
    Runtime:removeEventListener("collision", onCollision)
end

function M.stop()
    background.stop()

    if gameLoopTimer then timer.cancel(gameLoopTimer) end
    Runtime:removeEventListener("collision", onCollision)

    asteroids.cleanup()
    enemies.cleanup()
    mines.cleanup()

    for i = #listenersTable, 1, -1 do
        table.remove(listenersTable, i)
    end
end

function M.addListener(name, listener)
    listenersTable[name] = listener
end

function M.getScore()
    return score
end

function M.loadLevel(num)
    asteroids.cleanup()
    enemies.cleanup()
    mines.cleanup()

    currentWave = 1
    currentLevel = require("levels.level"..num)
    lastWaveTime = getTimer()
end

return M