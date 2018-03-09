local physics = require("physics")
local EachFrame = require("libs.EachFrame")
local SpriteSheet = require("engine.shared.SpriteSheet")

local MIN_X = -100
local MAX_X = display.contentWidth + 100
local MIN_Y = -100
local MAX_Y = display.contentHeight + 100

local function eachFrame(self)
  if self.x < MIN_X or self.x > MAX_X or
    self.y < MIN_Y or self.y > MAX_Y then
    display.remove(self)
    return
  end
  if self.behaviour then
    self.behaviour(self)
  end
end

local function finalize(self)
  EachFrame.remove(self)
end

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

  newWeapon.finalize = finalize
  newWeapon:addEventListener("finalize")

  newWeapon.eachFrame = eachFrame
  EachFrame.add(newWeapon)

  physics.addBody(newWeapon, "dynamic", {isSensor = true})

  return newWeapon
end

return Weapon
