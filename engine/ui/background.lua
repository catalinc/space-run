-- Scrolling background.

local eachframe = require("libs.eachframe")
local groups = require("engine.ui.groups")

local M = {}

local background1
local background2
local speed = 1.6

local HEIGHT = display.actualContentHeight
local MID_Y = display.actualContentHeight * 0.5
local START_Y = display.contentCenterY - display.actualContentHeight

local function scroll()
    local delta = eachframe.deltaTime
    background1.y = background1.y + speed * delta
    background2.y = background2.y + speed * delta

    if (background1.y - MID_Y) > HEIGHT then
        background1.y = START_Y
    end

    if (background2.y - MID_Y) > HEIGHT then
        background2.y = START_Y
    end
end

function M.start()
    local backgroundImage = {type = "image", filename = "graphics/background.png"}
    local group = groups.get("back")

    background1 = display.newRect(group, 0, 0, display.actualContentWidth, display.actualContentHeight)
    background1.fill = backgroundImage
    background1.x = display.contentCenterX
    background1.y = display.contentCenterY

    background2 = display.newRect(group, 0, 0, display.actualContentWidth, display.actualContentHeight)
    background2.fill = backgroundImage
    background2.x = display.contentCenterX
    background2.y = display.contentCenterY - display.actualContentHeight

    eachframe.add(scroll)
end

function M.pause()
    eachframe.remove(scroll)
end

function M.resume()
    eachframe.add(scroll)
end

function M.stop()
    eachframe.remove(scroll)

    display.remove(background1)
    display.remove(background2)
end

return M