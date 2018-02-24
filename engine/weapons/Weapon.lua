local physics = require("physics")
local SpriteSheet = require("engine.shared.SpriteSheet")

local Weapon = {}

function Weapon.create(source, options)
  local sprite = options.sprite
  local newWeapon = display.newImageRect(source.parent, SpriteSheet, sprite.frameIndex, sprite.width, sprite.height)

  newWeapon.name = source.name .. "Weapon"
  newWeapon.source = source
  newWeapon.damage = options.damage or source.damage
  newWeapon.x = source.x
  newWeapon.y = source.y
  newWeapon.isBullet = true
  newWeapon:toBack()

  physics.addBody(newWeapon, "dynamic", {isSensor = true})

  return newWeapon
end

return Weapon
