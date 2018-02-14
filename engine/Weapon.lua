-- Base class for all weapons.

local SpriteSheet = require("engine.SpriteSheet")

local Weapon = {}

function Weapon.create(name, group, source, target, options)
    local sprite = options.sprite
    local newWeapon = display.newImageRect(group, SpriteSheet, sprite.frameIndex, sprite.width, sprite.height)
    newWeapon.name = name
    newWeapon.source = source
    newWeapon.target = target
    newWeapon.x = source.x
    newWeapon.y = source.y
    newWeapon.damage = options.damage or source.damage
    newWeapon:toBack()
    return newWeapon
end

return Weapon