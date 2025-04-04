local Enemy = require("engine.ships.Enemy")

local options = {
  sprite = {frameIndex = 4, width = 98, height = 79},
  physics = {radius = 30, isSensor = true},
  maxHealth = 500,
  damage = 50,
  fireInterval = 1000,
  showHealthBar = true,
}

local function behaviour(self)
  if self.state == "idle" then
    self:interceptPlayer(1000, 500)
  elseif self.state == "moving" then
    if self:canAttack() then
      if math.random() > 0.7 then
        self:fireWeapon("Missile", {target = self:getTarget(), speed = 1, maxAge = 3000, damage = 50})
      else
        self:fireWeapon("Bullet", {direction = "down", time = 800})
      end
    end
  end
end

local Boss = {}

function Boss.create(group, x, y)
  local newBoss = Enemy.create(group, x, y, options)
  newBoss.behaviour = behaviour
  newBoss:setFillColor(0.8, 0.8, 0.5)
  return newBoss
end

return Boss
