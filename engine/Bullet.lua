-- Don't mess with lasers

local Sounds = require("libs.Sounds")
local Weapon = require("engine.Weapon")

local Y_UP = -15
local Y_DOWN = display.contentHeight + 15

local function fire(self, options)
  Sounds.play("fire")

  local y
  if options.direction == "up" then
    y = Y_UP
  else
    y = Y_DOWN
  end

  transition.to(self, {y = y, time = self.duration, onComplete = function() display.remove(self) end})
end

local Bullet = {}

function Bullet.create(source, target, options)
  local newBullet = Weapon.create(source, target, options)

  newBullet.fire = fire

  return newBullet
end

return Bullet
