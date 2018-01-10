-- Scrolling background

local eachframe = require("libs.eachframe")

local M = {}

local background1
local background2
local lastFrameTime = 0
local scrollSpeed = 1.6

local function scroll(delta)
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
  scroll(delta)
end

function M.init(group)
  group = group or display.currentStage

  local backgroundImage = { type="image", filename="graphics/background.png" }

  background1 = display.newRect(group, 0, 0, display.contentWidth, display.actualContentHeight)
  background1.fill = backgroundImage
  background1.x = display.contentCenterX
  background1.y = display.contentCenterY

  background2 = display.newRect(group, 0, 0, display.contentWidth, display.actualContentHeight)
  background2.fill = backgroundImage
  background2.x = display.contentCenterX
  background2.y = display.contentCenterY - display.actualContentHeight
end

function M.start()
  eachframe.add(enterFrame)
end

function M.stop()
  eachframe.remove(enterFrame)
end

return M