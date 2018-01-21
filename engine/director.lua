-- Game driver

local background = require("engine.background")
local asteroids = require("engine.asteroids")
local enemies = require("engine.enemies")
local ship = require("engine.ship")

local M = {}

local listenersTable = {}
local asteroidsTable = {}
local enemiesTable = {}
local playerShip

local currentLevel
local currentWave
local lastWaveTime
local getTimer = system.getTimer
local gameLoopTimer

local score = 0
local lives = 3

local mainGroup

local MIN_X = -100
local MAX_X = display.contentWidth + 100
local MIN_Y = -100
local MAX_Y = display.contentHeight + 100

-- -----------------------------------------------------------------------------------
-- Game loop functions
-- -----------------------------------------------------------------------------------

local function invokeListener(name, arg)
    local listener = listenersTable[name]
    if listener then listener(arg) end
end

local function isOffScreen(object)
    return object.x < MIN_X or object.x > MAX_X or object.y < MIN_Y or object.y > MAX_Y
end

local function removeOffScreenObjects()
    for i = #asteroidsTable, 1, -1 do
        local thisAsteroid = asteroidsTable[i]
        if isOffScreen(thisAsteroid) then
            display.remove(thisAsteroid)
            table.remove(asteroidsTable, i)
        end
    end

    for i = #enemiesTable, 1, -1 do
        local thisEnemy = enemiesTable[i]
        if isOffScreen(thisEnemy) then
            display.remove(thisEnemy)
            table.remove(enemiesTable, i)
        end
    end
end

local function isEndOfLevel()
    return #asteroidsTable + #enemiesTable == 0
end

local function gameLoop()
    if currentLevel then
        removeOffScreenObjects()

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
                        local newEnemy = enemies.new(mainGroup, playerShip)
                        table.insert(enemiesTable, newEnemy)
                    elseif kind == "asteroid" then
                        local newAsteroid = asteroids.new(mainGroup)
                        table.insert(asteroidsTable, newAsteroid)
                    end
                end
            end
        elseif isEndOfLevel() then invokeListener("endLevel") end
    end
end

-- -----------------------------------------------------------------------------------
-- Collision handling functions
-- -----------------------------------------------------------------------------------

local function getObjectByName(object1, object2, name)
    if object1.myName == name then return object1 end
    if object2.myName == name then return object2 end
    return nil
end

local function removeObject(t, o)
    for i = #t, 1, -1 do
        if t[i] == o then
            display.remove(o)
            table.remove(t, i)
            break
        end
    end
end

local function removeAsteroid(asteroid)
    removeObject(asteroidsTable, asteroid)
end

local function removeEnemy(enemy)
    removeObject(enemiesTable, enemy)
end

local function increaseScore(amount)
    score = score + amount
    invokeListener("score", score)
end

local function killPlayer()
    if not playerShip.isExploding then
        playerShip:explode()

        lives = lives - 1
        invokeListener("life", lives)

        if lives == 0 then
            display.remove(playerShip)
            timer.performWithDelay(2000, function() invokeListener("gameOver") end)
        else
            timer.performWithDelay(1000, function () playerShip:restore() end)
        end
    end
end

local function onCollision(event)
    if event.phase == "began" then
        local object1 = event.object1
        local object2 = event.object2

        local asteroid = getObjectByName(object1, object2, "asteroid")
        local player = getObjectByName(object1, object2, "ship")
        local laser = getObjectByName(object1, object2, "laser")
        local enemy = getObjectByName(object1, object2, "enemy")
        local enemyLaser = getObjectByName(object1, object2, "enemyLaser")

        if laser and asteroid then
            display.remove(laser)
            removeAsteroid(asteroid)
            increaseScore(100)
        elseif laser and enemy then
            display.remove(laser)
            removeEnemy(enemy)
            increaseScore(200)
        elseif enemyLaser and asteroid then
            display.remove(enemyLaser)
            removeAsteroid(asteroid)
        elseif enemyLaser and player then
            display.remove(enemyLaser)
            killPlayer()
        elseif enemy and player then
            removeEnemy(enemy)
            killPlayer()
        end
    end
end

-- -----------------------------------------------------------------------------------
-- Public API
-- -----------------------------------------------------------------------------------

local function clearTable(t)
    for i = #t, 1, -1 do
        display.remove(t[i])
        table.remove(t, i)
    end
end

function M.init(group)
    mainGroup = group
    playerShip = ship.new(mainGroup)
    score = 0
    lives = 3
end

function M.start()
    gameLoopTimer = timer.performWithDelay(500, gameLoop, 0)
    Runtime:addEventListener("collision", onCollision)
    background.start()
end

function M.pause()
    timer.cancel(gameLoopTimer)
    gameLoopTimer = nil
    Runtime:removeEventListener("collision", onCollision)
end

function M.stop()
    if gameLoopTimer then timer.cancel(gameLoopTimer) end
    Runtime:removeEventListener("collision", onCollision)

    clearTable(asteroidsTable)
    clearTable(enemiesTable)

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
    clearTable(asteroidsTable)
    clearTable(enemiesTable)

    currentWave = 1
    currentLevel = require("levels.level"..num)
    lastWaveTime = getTimer()
end

return M


