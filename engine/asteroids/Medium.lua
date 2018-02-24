local Asteroid = require("engine.asteroids.Asteroid")

local options = {
  sprite = {frameIndex = 1, width = 102, height = 85}, 
  physics = {radius = 30, bounce = 0.5}, 
  damage = 10, 
  maxHealth = 1, 
}

local function behaviour(self)
  if self.state == "idle" then
    self.state = "moving"
    self:setLinearVelocity(math.random(-5, 5), math.random(10, 100))
    self:applyTorque(math.random(-3, 3))
  end
end

local Medium = {}

function Medium.create(group, x, y)
  local newRock = Asteroid.create(group, x, y, options)
  newRock.behaviour = behaviour
  return newRock
end

return Medium
