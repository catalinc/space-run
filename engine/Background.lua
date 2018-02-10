-- Scrolling background

local EachFrame = require("libs.EachFrame")

local speed = 1.6

local HEIGHT = display.actualContentHeight
local MID_Y = display.actualContentHeight * 0.5
local START_Y = display.contentCenterY - display.actualContentHeight

local function scroll(self)
    local delta = EachFrame.deltaTime
    self.background1.y = self.background1.y + speed * delta
    self.background2.y = self.background2.y + speed * delta

    if (self.background1.y - MID_Y) > HEIGHT then
        self.background1.y = START_Y
    end

    if (self.background2.y - MID_Y) > HEIGHT then
        self.background2.y = START_Y
    end
end

local Background = {}
Background.__index = Background

function Background.new(group)
    local newBackground = {}

    local backgroundImage = {type = "image", filename = "graphics/background.png"}

    newBackground.background1 = display.newRect(group, 0, 0, display.actualContentWidth, display.actualContentHeight)
    newBackground.background1.fill = backgroundImage
    newBackground.background1.x = display.contentCenterX
    newBackground.background1.y = display.contentCenterY

    newBackground.background2 = display.newRect(group, 0, 0, display.actualContentWidth, display.actualContentHeight)
    newBackground.background2.fill = backgroundImage
    newBackground.background2.x = display.contentCenterX
    newBackground.background2.y = display.contentCenterY - display.actualContentHeight

    newBackground.eachFrame = scroll

    return setmetatable(newBackground, Background)
end

function Background:start()
    EachFrame.add(self)
end

function Background:pause()
    EachFrame.remove(self)
end

function Background:resume()
    EachFrame.add(self)
end

function Background:destroy()
    EachFrame.remove(self)

    display.remove(self.background1)
    self.background1 = nil
    display.remove(self.background2)
    self.background2 = nil
end

return Background