local composer = require("composer")

local scene = composer.newScene()

-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------

local Settings = require("libs.Settings")
local Sounds = require("libs.Sounds")

local function gotoGame()
  Settings.currentLevel = 1
  composer.removeScene("scenes.Game")
  composer.gotoScene("scenes.Game", {time = 800, effect = "crossFade"})
end

local function gotoMenu()
  composer.removeScene("scenes.Menu")
  composer.gotoScene("scenes.Menu", {time = 800, effect = "crossFade"})
end

-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------

function scene:create(event)
  local sceneGroup = self.view
  -- Code here runs when the scene is first created but has not yet appeared on screen

  local background = display.newImageRect(sceneGroup, "graphics/background.png", 800, 1400)
  background.x = display.contentCenterX
  background.y = display.contentCenterY

  local winText = display.newText({parent = sceneGroup, 
    text = "Yay! :)", 
    x = display.contentCenterX, 
    y = 300, 
    font = native.systemFont, 
  fontSize = 48})
  winText:setFillColor(0.76, 0.92, 0.34)

  local playButton = display.newText({parent = sceneGroup, 
    text = "New Game", 
    x = display.contentCenterX, 
    y = 450, 
    font = native.systemFont, 
  fontSize = 44})
  playButton:setFillColor(0.82, 0.86, 1)
  playButton:addEventListener("tap", gotoGame)

  local menuButton = display.newText({parent = sceneGroup, 
    text = "Menu", 
    x = display.contentCenterX, 
    y = 600, 
    font = native.systemFont, 
  fontSize = 44})
  menuButton:setFillColor(0.75, 0.78, 1)
  menuButton:addEventListener("tap", gotoMenu)
end

function scene:show(event)
  local sceneGroup = self.view
  local phase = event.phase

  if phase == "will" then
    -- Code here runs when the scene is still off screen (but is about to come on screen)
  elseif phase == "did" then
    -- Code here runs when the scene is entirely on screen
    Sounds.playStream("menuMusic")
  end
end

function scene:hide(event)
  local sceneGroup = self.view
  local phase = event.phase

  if phase == "will" then
    -- Code here runs when the scene is on screen (but is about to go off screen)
  elseif phase == "did" then
    -- Code here runs immediately after the scene goes entirely off screen
    Sounds.stop()
  end
end

function scene:destroy(event)
  local sceneGroup = self.view
  -- Code here runs prior to the removal of scene's view
  Sounds.dispose("menuMusic")
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
