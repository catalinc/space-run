local composer = require("composer")

local scene = composer.newScene()

-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------

local Settings = require("libs.Settings")
local Sounds = require("libs.Sounds")

local function gotoGame()
  composer.removeScene("scenes.Game")
  composer.gotoScene("scenes.Game", {time = 800, effect = "crossFade"})
end

local function newGame()
  Settings.currentLevel = 1
  gotoGame()
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

  local title = display.newImageRect(sceneGroup, "graphics/title.png", 500, 80)
  title.x = display.contentCenterX
  title.y = 200

  local newGameButton = display.newText({parent = sceneGroup, 
    text = "New Game", 
    x = display.contentCenterX, 
    y = 500, 
    font = native.systemFont, 
  fontSize = 44})
  newGameButton:setFillColor(0.82, 0.86, 1)
  newGameButton:addEventListener("tap", newGame)

  local continueGameButton = display.newText({parent = sceneGroup, 
    text = "Continue", 
    x = display.contentCenterX, 
    y = 650, 
    font = native.systemFont, 
  fontSize = 44})
  continueGameButton:setFillColor(0.82, 0.86, 1)
  continueGameButton:addEventListener("tap", gotoGame)
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
