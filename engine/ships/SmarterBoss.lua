local Enemy = require("engine.ships.Enemy")

local options = {
  sprite = {frameIndex = 4, width = 98, height = 79},
  physics = {radius = 30, isSensor = true},
  maxHealth = 800,
  damage = 80,
  fireInterval = 800,
  showHealthBar = true,
}

local function behaviour(self)
  if self.state == "idle" then
    if self:canAttack() then
      self:fireWeapon("Missile", {target = self:getTarget(), speed = 2, maxAge = 2000, damage = 80})
    end
    self:interceptPlayer(800, 600)
  elseif self.state == "moving" then
    if self:canAttack() then
      self:fireWeapon("Bullet", {direction = "down", time = 600})
    end
  end
end

local SmarterBoss = {}

function SmarterBoss.create(group, x, y)
  local newBoss = Enemy.create(group, x, y, options)
  newBoss.behaviour = behaviour
  newBoss:setFillColor(0.72, 0.0, 0.16, 0.78)
  return newBoss
end

return SmarterBoss
