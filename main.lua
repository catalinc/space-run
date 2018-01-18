local composer = require( "composer" )
local databox = require("libs.databox")
local sounds = require("libs.sounds")

math.randomseed(os.time())

display.setStatusBar(display.HiddenStatusBar)

local platform = system.getInfo('platformName')

-- Hide navigation bar on Android
if platform == 'Android' then
    native.setProperty('androidSystemUiVisibility', 'immersiveSticky')
end

-- Exit and enter fullscreen mode
-- CMD+CTRL+F on OS X
-- F11 or ALT+ENTER on Windows
if platform == 'Mac OS X' or platform == 'Win' then
    Runtime:addEventListener('key',
        function(event)
            if event.phase == 'down' and
                ((platform == 'Mac OS X' and event.keyName == 'f' and event.isCommandDown and event.isCtrlDown) or
                 (platform == 'Win' and (event.keyName == 'f11' or (event.keyName == 'enter' and event.isAltDown))))
            then
                if native.getProperty('windowMode') == 'fullscreen' then
                    native.setProperty('windowMode', 'normal')
                else
                    native.setProperty('windowMode', 'fullscreen')
                end
            end
        end
    )
end

-- Add support for back button on Android and Window Phone
-- When it's pressed, check if current scene has a special field gotoPreviousScene
-- If it's a function - call it, if it's a string - go back to the specified scene
if platform == 'Android' or platform == 'WinPhone' then
    Runtime:addEventListener('key',
        function(event)
            if event.phase == 'down' and event.keyName == 'back' then
                local scene = composer.getScene(composer.getSceneName('current'))
                if scene then
                    if type(scene.gotoPreviousScene) == 'function' then
                        scene:gotoPreviousScene()
                        return true
                    elseif type(scene.gotoPreviousScene) == 'string' then
                        composer.gotoScene(scene.gotoPreviousScene, {time = 500, effect = 'slideRight'})
                        return true
                    end
                end
            end
        end
    )
end

-- Set default settings
databox({ isSoundOn = true, isMusicOn = true })
databox.isMusicOn = false -- Temporary
databox.isSoundOn = false -- Temporary

-- Sound settings
sounds.isSoundOn = databox.isSoundOn
sounds.isMusicOn = databox.isMusicOn

-- Automatically remove scenes from memory
composer.recycleOnSceneChange = true

-- Go to the menu screen
composer.gotoScene("scenes.menu")
