-- Space rock.

local physics = require("physics")
local groups = require("engine.ui.groups")

local M = {}

function M.new(mineType)
    local group = groups.get("main")
    local sprite = mineType.sprite
    local newMine = display.newImageRect(group, sprite.sheet, sprite.frameIndex, sprite.width, sprite.height)
    newMine.myName = "mine"
    newMine.type = mineType

    physics.addBody(newMine, "dynamic", {radius = 40, bounce = 0.8})

    newMine.type.behaviour(newMine)

    function newMine:getDamage()
        return newMine.type.damage
    end

    function newMine:getPoints()
        return newMine.type.points
    end

    return newMine
end

return M