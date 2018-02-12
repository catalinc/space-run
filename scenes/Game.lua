
local composer = require("composer")

local scene = composer.newScene()

-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------

local physics = require("physics")
local Sounds = require("libs.Sounds")
local World = require("engine.World")
local EventBus = require("engine.EventBus")
local HealthBar = require("engine.HealthBar")

local world
local healthBar
local livesText
local scoreText

physics.start()
physics.setGravity(0, 0)

-- -----------------------------------------------------------------------------------
-- Scene game functions
-- -----------------------------------------------------------------------------------

local function updateLives(player)
    healthBar:setHealth(player.health, player.maxHealth)
    livesText.text = "Lives: " .. player.lives
end

local function updateScore(score)
    scoreText.text = "Score: " .. score
end

local function start()
    physics.start()
    world:start()
    Sounds.playStream("gameMusic")
end

local function pause()
    physics.pause()
    world:pause()
    Sounds.stop()
end

local function cleanup()
    EventBus.clear()

    physics.stop()
    world:destroy()

    Sounds.stop()
    Sounds.dispose("explosion")
    Sounds.dispose("fire")
    Sounds.dispose("gameMusic")
end

local function gameOver()
    composer.setVariable("finalScore", world.score)
    composer.removeScene("scenes.HighScores")
    composer.gotoScene("scenes.HighScores", {time = 800, effect = "crossFade"})
end

local function levelCleared()
    gameOver() -- TODO: should redirect to end level scene
end

-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------

function scene:create(event)
    -- Code here runs when the scene is first created but has not yet appeared on screen
    local sceneGroup = self.view

    -- Temporarly pause physiscs until the scene is created

    physics.pause()

    -- Setup events

    EventBus.subscribe("scoreUpdated", updateScore)
    EventBus.subscribe("playerHit", updateLives)
    EventBus.subscribe("playerRestored", updateLives)
    EventBus.subscribe("levelCleared", levelCleared)
    EventBus.subscribe("gameOver", gameOver)

    -- Setup the world

    world = World.new(sceneGroup)
    world:loadLevel(1)  -- TODO: Level should be read from settings

    -- Setup the UI

    local uiGroup = display.newGroup() -- Display group for UI objects like the score
    sceneGroup:insert(uiGroup)

    healthBar = HealthBar.new(uiGroup, 100, 80, 100, 10)
    livesText = display.newText(uiGroup, "Lives: " .. 3, 300, 80, native.systemFont, 36)
    scoreText = display.newText(uiGroup, "Score: " .. 0, 500, 80, native.systemFont, 36)
end

function scene:show(event)
    local phase = event.phase

    if phase == "will" then
        -- Code here runs when the scene is still off screen (but is about to come on screen)
    elseif phase == "did" then
        -- Code here runs when the scene is entirely on screen
        start()
    end
end

function scene:hide(event)
    local phase = event.phase

    if phase == "will" then
        -- Code here runs when the scene is on screen (but is about to go off screen)
        pause()
    elseif phase == "did" then
        -- Code here runs immediately after the scene goes entirely off screen
    end
end

function scene:destroy(event)
    -- Code here runs prior to the removal of scene's view
    cleanup()
end

-- -----------------------------------------------------------------------------------
-- Scene event function listeners
-- -----------------------------------------------------------------------------------
scene:addEventListener("create", scene)
scene:addEventListener("show", scene)
scene:addEventListener("hide", scene)
scene:addEventListener("destroy", scene)
-- -----------------------------------------------------------------------------------

return scene