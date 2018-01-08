
local composer = require( "composer" )

local scene = composer.newScene()

-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------

local physics = require( "physics" )
local eachframe = require( "libs.eachframe" )
local sounds = require( "libs.sounds" )
local sprites = require( "engine.sprites" )
local player = require( "engine.player" )
local asteroids = require( "engine.asteroids" )

local lives = 3 -- TODO move to player?
local score = 0

local gameLoopTimer
local livesText
local scoreText
local ship

local backGroup
local mainGroup
local uiGroup

local background1
local background2
local lastFrameTime = 0
local scrollSpeed = 1.6

physics.start()
physics.setGravity( 0, 0 )

local function updateText()
	livesText.text = "Lives: " .. lives
	scoreText.text = "Score: " .. score
end

local function gameLoop()
	asteroids.generate(mainGroup)
	asteroids.removeDrifted()
end

local function endGame()
	asteroids.cleanup()
	composer.setVariable( "finalScore", score )
	composer.removeScene( "scenes.highscores" )
	composer.gotoScene( "scenes.highscores", { time=800, effect="crossFade" } )
end

local function onCollision( event )

	if ( event.phase == "began" ) then

		local obj1 = event.object1
		local obj2 = event.object2

		if ( ( obj1.myName == "laser" and obj2.myName == "asteroid" ) or
			 ( obj1.myName == "asteroid" and obj2.myName == "laser" ) )
		then
			-- Remove the laser
			if obj1.myName == "laser" then display.remove( obj1 ) end
			if obj2.myName == "laser" then display.remove( obj2 ) end

			if obj1.myName == "asteroid" then asteroids.remove( obj1 ) end
			if obj2.myName == "asteroid" then asteroids.remove( obj2 ) end

			-- Increase score
			score = score + 100
			scoreText.text = "Score: " .. score

		elseif ( ( obj1.myName == "ship" and obj2.myName == "asteroid" ) or
				 ( obj1.myName == "asteroid" and obj2.myName == "ship" ) )
		then
			if ( ship:isAlive() ) then
				ship:die()

				livesText.text = "Lives: " .. ship.lives

				if ( ship:isDead() ) then
					display.remove( ship )
					timer.performWithDelay( 2000, endGame )
				else
					timer.performWithDelay( 1000, function () ship:restore() end )
				end
			end
		end
	end
end

local function scrollBackground( delta )
    background1.y = background1.y + scrollSpeed * delta
    background2.y = background2.y + scrollSpeed * delta

    if ( background1.y - display.contentHeight / 2 ) > display.actualContentHeight then
        background1:translate(0, -background1.contentHeight * 2)
    end

    if ( background2.y - display.contentHeight / 2 ) > display.actualContentHeight then
        background2:translate(0, -background2.contentHeight * 2)
    end
end

local function getDeltaTime()
   local now   = system.getTimer()
   local delta = ( now - lastFrameTime ) / ( 1000 / 60 )
   lastFrameTime = now
   return delta
end

local function enterFrame()
	local delta = getDeltaTime()
	scrollBackground(delta)
end

-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------

-- create()
function scene:create( event )

	local sceneGroup = self.view
	-- Code here runs when the scene is first created but has not yet appeared on screen

	physics.pause()  -- Temporarily pause the physics engine

	-- Set up display groups
	backGroup = display.newGroup()  -- Display group for the background image
	sceneGroup:insert( backGroup )  -- Insert into the scene's view group

	mainGroup = display.newGroup()  -- Display group for the ship, asteroids, lasers, etc.
	sceneGroup:insert( mainGroup )  -- Insert into the scene's view group

	uiGroup = display.newGroup()    -- Display group for UI objects like the score
	sceneGroup:insert( uiGroup )    -- Insert into the scene's view group

	-- Load the background
	-- local background = display.newImageRect( backGroup, "graphics/background.png", 800, 1400 )
	-- background.x = display.contentCenterX
	-- background.y = display.contentCenterY

	-- Scrolling background prototype
   local backgroundImage = { type="image", filename="graphics/background.png" }

    -- Add first background image
    background1 = display.newRect( backGroup, 0, 0, display.contentWidth, display.actualContentHeight )
    background1.fill = backgroundImage
    background1.x = display.contentCenterX
    background1.y = display.contentCenterY

    -- Add second background image
    background2 = display.newRect( backGroup, 0, 0, display.contentWidth, display.actualContentHeight )
    background2.fill = backgroundImage
    background2.x = display.contentCenterX
    background2.y = display.contentCenterY - display.actualContentHeight

    ship = player.new(mainGroup)

	-- Display lives and score
	livesText = display.newText( uiGroup, "Lives: " .. lives, 200, 80, native.systemFont, 36 )
	scoreText = display.newText( uiGroup, "Score: " .. score, 400, 80, native.systemFont, 36 )
end


-- show()
function scene:show( event )

	local sceneGroup = self.view
	local phase = event.phase

	if ( phase == "will" ) then
		-- Code here runs when the scene is still off screen (but is about to come on screen)

	elseif ( phase == "did" ) then
		-- Code here runs when the scene is entirely on screen
		physics.start()
		Runtime:addEventListener( "collision", onCollision )
		gameLoopTimer = timer.performWithDelay( 500, gameLoop, 0 )
		-- Start background scrolling
		eachframe.add( enterFrame )
		-- Start the music!
		sounds.playStream( "gameMusic" )
	end
end


-- hide()
function scene:hide( event )

	local sceneGroup = self.view
	local phase = event.phase

	if ( phase == "will" ) then
		-- Code here runs when the scene is on screen (but is about to go off screen)
		timer.cancel( gameLoopTimer )

	elseif ( phase == "did" ) then
		-- Code here runs immediately after the scene goes entirely off screen
		eachframe.remove( enterFrame )
		Runtime:removeEventListener( "collision", onCollision )
		physics.pause()
		-- Stop the music!
		sounds.stop()
	end
end


-- destroy()
function scene:destroy( event )

	local sceneGroup = self.view
	-- Code here runs prior to the removal of scene's view
	-- Dispose audio!
	sounds.dispose( "explosion" )
	sounds.dispose( "fire" )
	sounds.dispose( "gameMusic" )
end


-- -----------------------------------------------------------------------------------
-- Scene event function listeners
-- -----------------------------------------------------------------------------------
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )
-- -----------------------------------------------------------------------------------

return scene
