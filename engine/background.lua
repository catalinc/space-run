-- Scrolling background

local eachframe = require("libs.eachframe")

local M = {}

local background1
local background2
local speed = 1.6

local midY =  math.floor(display.actualContentHeight * 0.5)
local scrollStartY = math.floor(display.contentCenterY - display.actualContentHeight)

local function eachFrame()
  local delta = eachframe.deltaTime
  background1.y = background1.y + speed * delta
  background2.y = background2.y + speed * delta

  if (background1.y - midY) > display.actualContentHeight then
      background1.y = scrollStartY
  end

  if (background2.y - midY) > display.actualContentHeight then
      background2.y = scrollStartY
  end
end

function M.init(sceneGroup)
  local group = sceneGroup or display.currentStage

  local backgroundImage = { type="image", filename="graphics/background.png" }

  background1 = display.newRect(group, 0, 0, display.actualContentWidth, display.actualContentHeight)
  background1.fill = backgroundImage
  background1.x = display.contentCenterX
  background1.y = display.contentCenterY

  background2 = display.newRect(group, 0, 0, display.actualContentWidth, display.actualContentHeight)
  background2.fill = backgroundImage
  background2.x = display.contentCenterX
  background2.y = display.contentCenterY - display.actualContentHeight
end

function M.start()
  eachframe.add(eachFrame)
end

function M.stop()
  eachframe.remove(eachFrame)
end

return M