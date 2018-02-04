-- Space rock.

local physics = require("physics")
local groups = require("engine.common.groups")

local M = {}

function M.new(asteroidType)
    local group = groups.get("main")
    local sprite = asteroidType.sprite
    local newAsteroid = display.newImageRect(group, sprite.sheet, sprite.frameIndex, sprite.width, sprite.height)
    newAsteroid.myName = "asteroid"
    newAsteroid.type = asteroidType

    physics.addBody(newAsteroid, "dynamic", {radius = 40, bounce = 0.8})

    newAsteroid.type.behaviour(newAsteroid)

    function newAsteroid:getDamage()
        return newAsteroid.type.damage
    end

    function newAsteroid:getPoints()
        return newAsteroid.type.points
    end

    return newAsteroid
end

return M