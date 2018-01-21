
local composer = require("composer")

local scene = composer.newScene()

-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------

local physics = require("physics")
local sounds = require("libs.sounds")
local director = require("engine.director")

local livesText
local scoreText

local backGroup
local mainGroup
local uiGroup

physics.start()
physics.setGravity(0, 0)

-- -----------------------------------------------------------------------------------
-- Scene game functions
-- -----------------------------------------------------------------------------------
local function updateLives(lives)
    livesText.text = "Lives: " .. lives
end

local function updateScore(score)
    scoreText.text = "Score: " .. score
end

local function startGame()
    physics.start()
    director.start()
    sounds.playStream("gameMusic")
end

local function pauseGame()
    director.pause()
    physics.pause()
    sounds.stop()
end

local function stopGame()
    physics.stop()
    director.stop()
    sounds.stop()
end

local function endGame()
    composer.setVariable("finalScore", director.getScore())
    composer.removeScene("scenes.highscores")
    composer.gotoScene("scenes.highscores", {time = 800, effect = "crossFade"})
end

-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------

-- create()
function scene:create(event)
    -- Code here runs when the scene is first created but has not yet appeared on screen

    local sceneGroup = self.view

    physics.pause()

    -- Set up display groups

    backGroup = display.newGroup() -- Display group for the background image
    sceneGroup:insert(backGroup)

    mainGroup = display.newGroup() -- Display group for the ship, asteroids, lasers, etc.
    sceneGroup:insert(mainGroup)

    uiGroup = display.newGroup() -- Display group for UI objects like the score
    sceneGroup:insert(uiGroup)

    director.init(mainGroup, backGroup)
    director.addListener("score", updateScore)
    director.addListener("life", updateLives)
    director.addListener("gameOver", endGame)

    livesText = display.newText(uiGroup, "Lives: " .. 3, 200, 80, native.systemFont, 36)
    scoreText = display.newText(uiGroup, "Score: " .. 0, 400, 80, native.systemFont, 36)
end

-- show()
function scene:show(event)
    local sceneGroup = self.view
    local phase = event.phase

    if phase == "will" then
        -- Code here runs when the scene is still off screen (but is about to come on screen)
    elseif phase == "did" then
        -- Code here runs when the scene is entirely on screen
        startGame()
    end
end

-- hide()
function scene:hide(event)
    local sceneGroup = self.view
    local phase = event.phase

    if phase == "will" then
        -- Code here runs when the scene is on screen (but is about to go off screen)
        pauseGame()
    elseif phase == "did" then
        -- Code here runs immediately after the scene goes entirely off screen
        stopGame()
    end
end

-- destroy()
function scene:destroy(event)
    -- Code here runs prior to the removal of scene's view
    local sceneGroup = self.view

    sounds.dispose("explosion")
    sounds.dispose("fire")
    sounds.dispose("gameMusic")
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
