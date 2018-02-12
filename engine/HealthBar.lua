-- Unit health bar

local HealthBar = {}

function HealthBar.create(group, x, y, width, height)
    width = width or 35
    height = height or 6

    local newHealthBar = display.newGroup()
    newHealthBar.anchorX = 0
    newHealthBar.anchorY = 0
    newHealthBar.anchorChildren = true

    local redBar = display.newRect(0, 0, width, height)
    redBar.anchorX = 0
    redBar.anchorY = 0
    redBar:setFillColor(255, 0, 0)
    newHealthBar:insert(redBar)

    local greenBar = display.newRect(0, 0, width, height)
    greenBar.anchorX = 0
    greenBar.anchorY = 0
    greenBar:setFillColor(0, 255, 0)
    newHealthBar:insert(greenBar)

    function newHealthBar:setHealth(current, max)
        local percent = current / max
        if percent == 0 then percent = 0.01 end
        greenBar.xScale = percent
    end

    group:insert(newHealthBar)
    newHealthBar.x = x
    newHealthBar.y = y

    return newHealthBar
end

return HealthBar
