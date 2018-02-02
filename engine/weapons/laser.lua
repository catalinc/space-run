-- Fire phasers!

local sounds = require("libs.sounds")
local groups = require("engine.ui.groups")
local sprites = require("engine.ui.sprites")

local M = {}

local HEIGHT = display.contentHeight

function M.fire(x, y, options)
    sounds.play("fire")

    options = options or {}
    local name = options.name or "laser"
    local damage = options.damage or 100
    local duration = options.duration or 1000
    local toY = options.y or 0

    local group = groups.get("main")
    local newLaser = display.newImageRect(group, sprites, 5, 14, 40)
    newLaser.isBullet = true
    newLaser.x = x
    newLaser.y = y
    newLaser.myName = name
    newLaser.damage = damage
    newLaser:toBack()

    physics.addBody(newLaser, "dynamic", {isSensor = true})

    transition.to(newLaser, {y = toY, time = duration,
                  onComplete = function() display.remove(newLaser) end})
end

return M