-- Collision handling

local EventBus = require("engine.EventBus")

local CollisionHandler = {}
CollisionHandler.__index = CollisionHandler

function CollisionHandler.new(world)
  local newHandler = {}
  newHandler.world = world
  newHandler.globalHandler = function (event)
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

function CollisionHandler:onCollision(event)
  if event.phase == "began" then
    local o1 = event.object1
    local o2 = event.object2

    local asteroid = self:getUnitOrWeapon(o1, o2, "Asteroid")
    local mine = self:getUnitOrWeapon(o1, o2, "Mine")
    local player = self:getUnitOrWeapon(o1, o2, "Player")
    local enemy = self:getUnitOrWeapon(o1, o2, "Enemy")
    local playerWeapon = self:getUnitOrWeapon(o1, o2, "PlayerWeapon")
    local enemyWeapon = self:getUnitOrWeapon(o1, o2, "EnemyWeapon")

    if playerWeapon and asteroid then self:onUnitWeaponCollision(asteroid, playerWeapon)
    elseif playerWeapon and enemy then self:onUnitWeaponCollision(enemy, playerWeapon)
    elseif playerWeapon and mine then self:onUnitWeaponCollision(mine, playerWeapon)
    elseif enemyWeapon and asteroid then self:onUnitWeaponCollision(asteroid, enemyWeapon)
    elseif enemyWeapon and player then self:onUnitWeaponCollision(player, enemyWeapon)
    elseif enemy and player then self:onUnitUnitCollision(player, enemy)
    elseif asteroid and player then self:onUnitUnitCollision(player, asteroid)
    elseif mine and player then self:onUnitUnitCollision(player, mine)
    end
  end
end

function CollisionHandler:getUnitOrWeapon(o1, o2, name)
  if o1.name == name then return o1 end
  if o2.name == name then return o2 end
end

function CollisionHandler:onUnitWeaponCollision(unit, weapon)
  unit:takeDamage(weapon.damage)
  if unit:isDead() then display.remove(unit) end
  display.remove(weapon)
end

function CollisionHandler:onUnitUnitCollision(unit1, unit2)
  unit1:takeDamage(unit2.damage)
  unit2:takeDamage(unit1.damage)
  if unit1:isDead() then display.remove(unit1) end
  if unit2:isDead() then display.remove(unit2) end
end

return CollisionHandler
