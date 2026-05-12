local EventBus = require("engine.shared.EventBus")

-- typeId constants must match engine/unit/Unit.lua and engine/weapons/Weapon.lua
local TYPE_PLAYER_WEAPON = 5
local TYPE_ENEMY_WEAPON  = 6

local CollisionHandler = {}
CollisionHandler.__index = CollisionHandler

function CollisionHandler.new(world)
  local newHandler = {}
  newHandler.world = world
  newHandler.globalHandler = function(event)
    newHandler:onCollision(event)
  end
  return setmetatable(newHandler, CollisionHandler)
end

function CollisionHandler:start()
  Runtime:addEventListener("collision", self.globalHandler)
end

function CollisionHandler:stop()
  Runtime:removeEventListener("collision", self.globalHandler)
end

local function isWeapon(typeId)
  return typeId == TYPE_PLAYER_WEAPON or typeId == TYPE_ENEMY_WEAPON
end

function CollisionHandler:onCollision(event)
  if event.phase ~= "began" then return end
  local o1, o2 = event.object1, event.object2

  if isWeapon(o1.typeId) then
    self:onUnitWeaponCollision(o2, o1)
  elseif isWeapon(o2.typeId) then
    self:onUnitWeaponCollision(o1, o2)
  else
    self:onUnitUnitCollision(o1, o2)
  end
end

function CollisionHandler:onUnitWeaponCollision(unit, weapon)
  unit:takeDamage(weapon.damage)
  if unit:isDead() then display.remove(unit) end
  weapon:release()
end

function CollisionHandler:onUnitUnitCollision(unit1, unit2)
  unit1:takeDamage(unit2.damage)
  unit2:takeDamage(unit1.damage)
  if unit1:isDead() then display.remove(unit1) end
  if unit2:isDead() then display.remove(unit2) end
end

return CollisionHandler
