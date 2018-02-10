-- Don't mess with lasers

local Sounds = require("libs.Sounds")
local SpriteSheet = require("engine.SpriteSheet")

local UP_Y = -40
local DOWN_Y = display.contentHeight + 40

local Laser = {}

function Laser.fire(source, direction)
    Sounds.play("fire")

    local group = source.parent
    local newLaser = display.newImageRect(group, SpriteSheet, 5, 14, 40)
    newLaser.isBullet = true
    newLaser.source = source
    newLaser.x = source.x
    newLaser.y = source.y
    newLaser.damage = source.damage
    newLaser.duration = source.duration
    newLaser.className = source.className .. "Laser"
    newLaser:toBack()

    if direction == "down" then
        toY = DOWN_Y
    else
        toY = UP_Y
    end

    physics.addBody(newLaser, "dynamic", {isSensor = true})

    transition.to(newLaser, {y = toY, time = newLaser.duration,
                  onComplete = function() display.remove(newLaser) end})
end

return Laser