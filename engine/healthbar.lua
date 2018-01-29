-- Health bar for enemies.

-- -----------------------------------------------------------------------------------
-- Public API
-- -----------------------------------------------------------------------------------

local M = {}

function M.new(parent, x, y, width, height)
    width = width or 35
    height = height or 6

    local group = display.newGroup()
    group.anchorX = 0
    group.anchorY = 0
    group.anchorChildren = true

    local redBar = display.newRect(0, 0, width, height)
    redBar.anchorX = 0
    redBar.anchorY = 0
    redBar:setFillColor(255, 0, 0)
    group:insert(redBar)

    local greenBar = display.newRect(0, 0, width, height)
    greenBar.anchorX = 0
    greenBar.anchorY = 0
    greenBar:setFillColor(0, 255, 0)
    group:insert(greenBar)

    function group:setHealth(current, max)
        local percent = current / max
        if percent == 0 then percent = 0.01 end
        greenBar.xScale = percent
    end

    parent:insert(group)
    group.x = x
    group.y = y

    return group
end

return M
