-- Game driver

local background = require( "engine.background" )
local asteroids = require( "engine.asteroid" )
local enemies = require( "engine.enemy" )
local ship = require( "engine.ship" )

local M = { }

local listenersTable = { }
local asteroidsTable = { }
local enemiesTable = { }
local playerShip

local mainGroup
local backGroup
local gameLoopTimer

local score = 0
local lives = 3

-- -----------------------------------------------------------------------------------
-- Game loop functions
-- -----------------------------------------------------------------------------------

local function removeOffScreenObjects( )
    for i = #asteroidsTable, 1, -1 do
        local thisAsteroid = asteroidsTable[ i ]
        if thisAsteroid.x < -100 or thisAsteroid.x > display.contentWidth + 100 or
            thisAsteroid.y < -100 or thisAsteroid.y > display.contentHeight + 100 then
            display.remove( thisAsteroid )
            table.remove( asteroidsTable, i )
        end
    end

    for i = #enemiesTable, 1, -1 do
        local thisEnemy = enemiesTable[ i ]
        if thisEnemy.x < -100 or thisEnemy.x > display.contentWidth + 100 or
            thisEnemy.y < -100 or thisEnemy.y > display.contentHeight + 100 then
            display.remove( thisEnemy )
            table.remove( enemiesTable, i )
        end
    end
end

local function levelLoop( )
    local asteroid = asteroids.new( mainGroup )
    table.insert( asteroidsTable, asteroid )

    local enemy = enemies.new( mainGroup, playerShip )
    table.insert( enemiesTable, enemy )

    removeOffScreenObjects( )
end

-- -----------------------------------------------------------------------------------
-- Collision handling functions
-- -----------------------------------------------------------------------------------

local function getByName( obj1, obj2, name )
    if obj1.myName == name then return obj1 end
    if obj2.myName == name then return obj2 end
    return nil
end

local function removeAsteroid( asteroid )
    for i = #asteroidsTable, 1, -1 do
        if asteroidsTable[ i ] == asteroid then
            display.remove( asteroid )
            table.remove( asteroidsTable, i )
            break
        end
    end
end

local function removeEnemy( enemy )
    for i = #enemiesTable, 1, -1 do
        if enemiesTable[ i ] == enemy then
            display.remove( enemy )
            table.remove( enemiesTable, i )
            break
        end
    end
end

local function increaseScore( amount )
    score = score + amount
    local scoreListener = listenersTable[ "score" ]
    if scoreListener then scoreListener( score ) end
end

local function killPlayer( )
    if not playerShip.isExploding then
        playerShip:explode( )

        lives = lives - 1
        local lifeListener = listenersTable[ "life" ]
        if lifeListener then lifeListener( lives ) end

        if lives == 0 then
            display.remove( playerShip )
            local gameOverListener = listenersTable[ "gameOver" ]
            if gameOverListener then
                timer.performWithDelay( 2000, gameOverListener )
            end
        else
            timer.performWithDelay( 1000, function ( ) playerShip:restore( ) end )
        end
    end
end

local function onCollision( event )
    if event.phase == "began" then
        local obj1 = event.object1
        local obj2 = event.object2

        local asteroid = getByName( obj1, obj2, "asteroid" )
        local player = getByName( obj1, obj2, "ship" )
        local laser = getByName( obj1, obj2, "laser" )
        local enemy = getByName( obj1, obj2, "enemy" )
        local enemyLaser = getByName( obj1, obj2, "enemyLaser" )

        if laser and asteroid then
            display.remove( laser )
            removeAsteroid( asteroid )
            increaseScore( 100 )
        elseif laser and enemy then
            display.remove( laser )
            removeEnemy( enemy )
            increaseScore( 100 )
        elseif enemyLaser and asteroid then
            display.remove( enemyLaser )
            removeAsteroid( asteroid )
        elseif enemyLaser and player then
            display.remove( enemyLaser )
            killPlayer( )
        elseif enemy and player then
            removeEnemy( enemy )
            killPlayer( )
        end
    end
end

-- -----------------------------------------------------------------------------------
-- Public API
-- -----------------------------------------------------------------------------------

function M.init( mainSceneGroup, backSceneGroup )
    mainGroup = mainSceneGroup or display.currentStage
    backGroup = backSceneGroup or display.currentStage
    playerShip = ship.new( mainGroup )
    background.init( backGroup )
    score = 0
    lives = 3
end

function M.start( )
    levelLoopTimer = timer.performWithDelay( 500, levelLoop, 0 )
    Runtime:addEventListener( "collision", onCollision )
    background.start( )
end

function M.pause( )
    timer.cancel( levelLoopTimer )
    gameLoopTimer = nil
    Runtime:removeEventListener( "collision", onCollision )
    background.stop( )
end

function M.stop( )
    if gameLoopTimer then timer.cancel( gameLoopTimer ) end
    Runtime:removeEventListener( "collision", onCollision )
    background.stop( )

    for i = #asteroidsTable, 1, -1 do
        display.remove( asteroidsTable[ i ])
        table.remove( asteroidsTable, i )
    end

    for i = #enemiesTable, 1, -1 do
        display.remove( enemiesTable[ i ])
        table.remove( enemiesTable, i )
    end

    for i = #listenersTable, 1, -1 do
        table.remove( listenersTable, i )
    end
end

function M.addListener( name, listener )
    listenersTable[ name ] = listener
end

function M.getScore( )
    return score
end

return M
