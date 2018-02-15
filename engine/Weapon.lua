-- Base weapon

local SpriteSheet = require("engine.SpriteSheet")

local Weapon = {}

function Weapon.create(source, target, options)
    local sprite = options.sprite
    local newWeapon = display.newImageRect(source.parent, SpriteSheet, sprite.frameIndex, sprite.width, sprite.height)
    newWeapon.name = source.name .. "Weapon"
    newWeapon.source = source
    newWeapon.target = target
    newWeapon.x = source.x
    newWeapon.y = source.y
    newWeapon.damage = options.damage or source.damage
    newWeapon.duration = options.duration or source.duration
    newWeapon.isBullet = true
    newWeapon:toBack()

    physics.addBody(newWeapon, "dynamic", {isSensor = true})

    return newWeapon
end

return Weapon