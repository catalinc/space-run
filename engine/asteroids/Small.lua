local Asteroid = require("engine.asteroids.Asteroid")

local options = {
  sprite = {frameIndex = 2, width = 90, height = 83}, 
  physics = {radius = 40, bounce = 0.7}, 
  damage = 5, 
  maxHealth = 1, 
}

local function behaviour(self)
  if self.state == "idle" then
    self.state = "moving"
    self:setLinearVelocity(math.random(-5, 5), math.random(50, 150))
    self:applyTorque(math.random(-2, 2))
  end
end

local Small = {}

function Small.create(group, x, y)
  local newRock = Asteroid.create(group, x, y, options)
  newRock.behaviour = behaviour
  return newRock
end

return Small
