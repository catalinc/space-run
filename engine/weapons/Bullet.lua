local Sounds = require("libs.Sounds")
local Weapon = require("engine.weapons.Weapon")

local options = {
  sprite = {frameIndex = 5, width = 14, height = 40},
}

local Y_UP = -15
local Y_DOWN = display.contentHeight + 15

local function fire(self, options)
  if options.playSound then
    Sounds.play("fire")
  end

  local y = options.direction == "up" and Y_UP or Y_DOWN
  local t = options.time or 1000

  transition.to(self, {y = y, time = t, onComplete = function() display.remove(self) end})
end

local Bullet = {}

function Bullet.create(source)
  local newBullet = Weapon.create(source, options)

  newBullet.fire = fire

  return newBullet
end

return Bullet
