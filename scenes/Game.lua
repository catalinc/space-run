local composer = require("composer")

local scene = composer.newScene()

-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------

local physics = require("physics")
local Settings = require("libs.Settings")
local Sounds = require("libs.Sounds")
local World = require("engine.World")
local EventBus = require("engine.EventBus")
local HealthBar = require("engine.HealthBar")

local world
local healthText
local healthBar
local livesText
local waveText
local levelText

physics.start()
physics.setGravity(0, 0)

-- -----------------------------------------------------------------------------------
-- Scene game functions
-- -----------------------------------------------------------------------------------

local function updateLives(player)
    healthBar:setHealth(player.health, player.maxHealth)
    livesText.text = "Lives: " .. player.lives
end

local function updateWave(waveData)
    waveText.text = "Wave: " .. waveData.current .. "/" .. waveData.total
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

local function gotoProgress()
    if Settings.currentLevel == Settings.maxLevel then
        composer.removeScene("scenes.Win")
        composer.gotoScene("scenes.Win", {time = 800, effect = "crossFade"})
    else
        composer.removeScene("scenes.Progress")
        composer.gotoScene("scenes.Progress", {time = 800, effect = "crossFade"})
    end
end

local function gotoGameOver()
    composer.removeScene("scenes.Lose")
    composer.gotoScene("scenes.Lose", {time = 800, effect = "crossFade"})
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

    EventBus.subscribe("newWave", updateWave)
    EventBus.subscribe("playerHit", updateLives)
    EventBus.subscribe("playerRestored", updateLives)
    EventBus.subscribe("levelCleared", gotoProgress)
    EventBus.subscribe("gameOver", gotoGameOver)

    -- Setup the world

    world = World.new(sceneGroup)
    world:loadLevel(Settings.currentLevel)

    -- Setup the UI

    local uiGroup = display.newGroup() -- Display group for UI objects like the score
    sceneGroup:insert(uiGroup)

    local y = 20

    -- TODO: All texts should be created with modern syntax
    healthText = display.newText({parent = uiGroup,
                                 text = "Shield: ",
                                 align = "right",
                                 x = 120, y = y,
                                 width = 100,
                                 font = native.systemFont,
                                 fontSize = 24})
    healthBar = HealthBar.create(uiGroup, 180, y - 3 , 100, 10)
    livesText = display.newText(uiGroup, "Lives: " .. 3, 340, y, native.systemFont, 24)
    levelText = display.newText(uiGroup, "Level: " .. Settings.currentLevel, 500, y, native.systemFont, 24)
    waveText = display.newText(uiGroup, "Wave " .. world.currentWave .. "/" .. world.wavesCount, 600, y, native.systemFont, 24)
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