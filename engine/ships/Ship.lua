local EachFrame = require("libs.EachFrame")
local Unit = require("engine.unit.Unit")
local WeaponFactory = require("engine.weapons.WeaponFactory")

local function fireWeapon(self, name, options)
  local now = EachFrame.lastFrameTime
  if now - self.lastFireTime > self.fireInterval then
    local newWeapon = WeaponFactory.create(name, self)
    if newWeapon then
      newWeapon:fire(options)
      self.lastFireTime = now
    end
  end
end

local Ship = {}

function Ship.create(name, group, x, y, options)
  local newShip = Unit.create(name, group, x, y, options)

  newShip.fireInterval = options.fireInterval or 500 -- millis
  newShip.lastFireTime = 0
  newShip.fireWeapon = fireWeapon

  return newShip
end

return Ship
