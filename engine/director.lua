-- The game driver.

local background = require("engine.background")
local asteroids = require("engine.asteroids")
local enemies = require("engine.enemies")
local mines = require("engine.mines")
local player = require("engine.player")

local listeners = {}
local ship

local currentLevel
local currentWave
local lastWaveTime
local getTimer = system.getTimer
local gameLoopTimer

local score = 0
local group -- Display group for all entities (the ship, asteroids, lasers, etc.)

-- -----------------------------------------------------------------------------------
-- Game loop functions
-- -----------------------------------------------------------------------------------

local function invokeListener(name, arg)
    local listener = listeners[name]
    if listener then
        listener(arg)
    end
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
            local elapsed = (now - lastWaveTime) / 1000 -- Seconds
            if elapsed >= wave.after then
                lastWaveTime = now
                currentWave = currentWave + 1
                for i = 1, #wave.generate do
                    local kind = wave.generate[i]
                    if kind == "enemy" then
                        enemies.spawn(group, ship)
                    elseif kind == "asteroid" then
                        asteroids.spawn(group)
                    elseif kind == "mine" then
                        mines.spawn(group)
                    end
                end
            end
        elseif isEndOfLevel() then
            invokeListener("endLevel")
        end
    end
end

-- -----------------------------------------------------------------------------------
-- Collision handling functions
-- -----------------------------------------------------------------------------------

local function getEntityByName(object1, object2, name)
    if object1.myName == name then
        return object1
    end
    if object2.myName == name then
        return object2
    end
    return nil
end

local function increaseScore(amount)
    score = score + amount
    invokeListener("score", score)
end

local function gameOver()
    invokeListener("gameOver")
end

local function playerHit(damage)
    if ship.isBodyActive then
        ship:takeDamage(damage)
        if ship:isDead() then
            display.remove(ship)
            timer.performWithDelay(2000, gameOver)
        else
            invokeListener("life", {lives = ship.lives, health = ship.health, maxHealth = ship.maxHealth})
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
            increaseScore(asteroid.points)
            display.remove(laser)
            asteroids.remove(asteroid)
        elseif laser and enemy then
            display.remove(laser)
            enemy:takeDamage(laser.damage)
            if enemy:isDead() then
                increaseScore(enemy.points)
                enemies.remove(enemy)
            end
        elseif laser and mine then
            increaseScore(mine.points)
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

function M.init(mainGroup, backGroup)
    group = mainGroup
    ship = player.new(group)
    score = 0

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

    if gameLoopTimer then
        timer.cancel(gameLoopTimer)
    end

    Runtime:removeEventListener("collision", onCollision)

    asteroids.cleanup()
    enemies.cleanup()
    mines.cleanup()

    for i = #listeners, 1, -1 do
        table.remove(listeners, i)
    end
end

function M.addListener(name, listener)
    listeners[name] = listener
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