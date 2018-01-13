
local composer = require( "composer" )

local scene = composer.newScene()

-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------

local physics = require("physics")
local sounds = require("libs.sounds")
local player = require("engine.player")
local asteroids = require("engine.asteroids")
local enemies = require("engine.enemies")
local background = require("engine.background")
local collision = require("engine.collision")

local score = 0

local gameLoopTimer
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
function scene:updateLives()
  livesText.text = "Lives: " .. self.playerShip.lives
end

function scene:updateScore()
  score = score + 100
  scoreText.text = "Score: " .. score
end

function scene:endGame()
  asteroids.reset()
  enemies.reset()
  composer.setVariable("finalScore", score)
  composer.removeScene("scenes.highscores")
  composer.gotoScene("scenes.highscores", { time=800, effect="crossFade" })
end

local function gameLoop()
  asteroids.newAsteroid(mainGroup)
  asteroids.removeOffScreen()

  enemies.newEnemyShip(mainGroup)
  enemies.removeOffScreen()
end

local function startGame()
  physics.start()
  background.start()
  collision.start()
  gameLoopTimer = timer.performWithDelay(500, gameLoop, 0)
  sounds.playStream("gameMusic")
end

local function stopGame()
  background.pause()
  collision.pause()
  physics.pause()
  sounds.stop()
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

	backGroup = display.newGroup()  -- Display group for the background image
	sceneGroup:insert(backGroup)

	mainGroup = display.newGroup()  -- Display group for the ship, asteroids, lasers, etc.
	sceneGroup:insert(mainGroup)

	uiGroup = display.newGroup()    -- Display group for UI objects like the score
	sceneGroup:insert(uiGroup)

  background.init(backGroup)
  self.playerShip = player.newShip(mainGroup)

	livesText = display.newText(uiGroup, "Lives: " .. self.playerShip.lives, 200, 80, native.systemFont, 36)
	scoreText = display.newText(uiGroup, "Score: " .. score, 400, 80, native.systemFont, 36)
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
function scene:hide( event )
	local sceneGroup = self.view
	local phase = event.phase

	if phase == "will" then
		-- Code here runs when the scene is on screen (but is about to go off screen)
		timer.cancel(gameLoopTimer)
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
