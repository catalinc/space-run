local composer = require("composer")

local scene = composer.newScene()

-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------

local widget = require("widget")
local Settings = require("libs.Settings")
local Sounds = require("libs.Sounds")

local function closeOverlay()
  composer.hideOverlay("slideUp", 500)
end

local function onMusicSwitchPress(event)
  local switch = event.target
  Settings.isMusicOn = switch.isOn
  if switch.isOn then
    Sounds.playStream("menuMusic")
  else
    Sounds.stop()
  end
end

local function onSoundsSwitchPress(event)
  local switch = event.target
  Settings.isSoundOn = switch.isOn
  if switch.isOn then
    Sounds.play("fire")
  end
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

  local musicLabel = display.newText(
    {
      parent = sceneGroup,
      text = "Music",
      x = display.contentCenterX,
      y = 450,
      font = native.systemFont,
      fontSize = 44
    }
  )
  musicLabel:setFillColor(0.82, 0.86, 1)

  local checkboxMusic = widget.newSwitch(
    {
        x = display.contentCenterX + 100,
        y = 455,
        style = "checkbox",
        id = "MusicCheckbox",
        initialSwitchState = Settings.isMusicOn,
        onPress = onMusicSwitchPress,
    }
  )
  sceneGroup:insert(checkboxMusic)

  local soundsLabel = display.newText(
    {
      parent = sceneGroup, text = "Sounds",
      x = display.contentCenterX,
      y = 600,
      font = native.systemFont,
      fontSize = 44,
    }
  )
  soundsLabel:setFillColor(0.75, 0.78, 1)

  local checkboxSounds = widget.newSwitch(
    {
        x = display.contentCenterX + 100,
        y = 605,
        style = "checkbox",
        id = "SoundsCheckbox",
        initialSwitchState = Settings.isSoundOn,
        onPress = onSoundsSwitchPress,
    }
  )
  sceneGroup:insert(checkboxSounds)

  local closeButton = display.newText({
    parent = sceneGroup, text = "Close",
    x = display.contentCenterX, y = 750,
    font = native.systemFont, fontSize = 44
  })
  closeButton:setFillColor(0.75, 0.78, 1)
  closeButton:addEventListener("tap", closeOverlay)
end

function scene:show(event)
  local sceneGroup = self.view
  local phase = event.phase

  if phase == "will" then
    -- Code here runs when the scene is still off screen (but is about to come on screen)
  elseif phase == "did" then
    -- Code here runs when the scene is entirely on screen
  end
end

function scene:hide(event)
  local sceneGroup = self.view
  local phase = event.phase

  if phase == "will" then
    -- Code here runs when the scene is on screen (but is about to go off screen)
  elseif phase == "did" then
    -- Code here runs immediately after the scene goes entirely off screen
  end
end

function scene:destroy(event)
  local sceneGroup = self.view
  -- Code here runs prior to the removal of scene's view
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
