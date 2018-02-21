-- Flying through space

local EachFrame = require("libs.EachFrame")

local function eachFrame(self)
    local delta = EachFrame.deltaTime

    for i = 1, #self.smallStars do
        local star = self.smallStars[i]
        star.y = star.y + 1 * delta
        if star.y > display.contentHeight then
            star.x = math.random(display.contentWidth)
            star.y = math.random(display.contentHeight)
        end
    end

    for i = 1, #self.mediumStars do
        local star = self.mediumStars[i]
        star.y = star.y + 2 * delta
        if star.y > display.contentHeight then
            star.x = math.random(display.contentWidth)
            star.y = math.random(display.contentHeight)
        end
    end

    for i = 1, #self.bigStars do
        local star = self.bigStars[i]
        star.y = star.y + 4 * delta
        if star.y > display.contentHeight then
            star.x = math.random(display.contentWidth)
            star.y = math.random(display.contentHeight)
        end
    end
end

local function start(self)
    EachFrame.add(self)
end

local function stop(self)
    EachFrame.remove(self)
end

local function destroy(self)
    for i = 1, #self.smallStars do
        display.remove(self.smallStars[i])
        self.smallStars[i] = nil
    end
    self.smallStars = nil

    for i = 1, #self.mediumStars do
        display.remove(self.mediumStars[i])
        self.mediumStars[i] = nil
    end
    self.mediumStars = nil

    for i = 1, #self.bigStars do
        display.remove(self.bigStars[i])
        self.bigStars[i] = nil
    end
    self.bigStars = nil
end

local Starfield = {}

function Starfield.new(group)
    local newStarfield = {}

    local width = display.contentWidth
    local height = display.contentHeight

    local reduce = 8
    local ratio = 3

    local xResolution = width / (reduce * 10)
    local yResolution = height / reduce

    local maxSmallStars = xResolution * yResolution
    local maxMediumStars = (xResolution / ratio) * (yResolution / ratio)
    local maxBigStars = (xResolution / (ratio * ratio)) * (yResolution / (ratio * ratio))

    local smallStars = {}
    for i = 1, maxSmallStars do
        local x = math.random(width)
        local y = math.random(height)
        smallStars[i] = display.newCircle(group, x, y, 1)
    end

    local mediumStars = {}
    for i = 1, maxMediumStars do
        local x = math.random(width)
        local y = math.random(height)
        mediumStars[i] = display.newCircle(group, x, y, 2)
    end

    local bigStars = {}
    for i = 1, maxBigStars do
        local x = math.random(width)
        local y = math.random(height)
        bigStars[i] = display.newCircle(group, x, y, 4)
    end

    newStarfield.smallStars = smallStars
    newStarfield.mediumStars = mediumStars
    newStarfield.bigStars = bigStars
    newStarfield.eachFrame = eachFrame
    newStarfield.start = start
    newStarfield.stop = stop
    newStarfield.destroy = destroy

    return newStarfield
end

return Starfield