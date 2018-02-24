local Enemy = require("engine.ships.Enemy")

local options = {
  sprite = {frameIndex = 4, width = 98, height = 79}, 
  physics = {radius = 30, isSensor = true}, 
  maxHealth = 100, 
  damage = 20, 
  fireInterval = 1500, 
  showHealthBar = true, 
}

local function behaviour(self)
  if self.state == "idle" then
    self:fall()
  end

  if self:canAttack() then
    self:fireWeapon("Bullet", {direction = "down", time = 1500})
  end
end

local Grunt = {}

function Grunt.create(group, x, y)
  local newGrunt = Enemy.create(group, x, y, options)
  newGrunt.behaviour = behaviour
  newGrunt:setFillColor(0.5, 0.5, 0.5)
  return newGrunt
end

return Grunt
