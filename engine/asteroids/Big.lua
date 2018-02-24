local Asteroid = require("engine.asteroids.Asteroid")

local options = {
  sprite = {frameIndex = 3, width = 100, height = 97}, 
  physics = {radius = 40, bounce = 0.2}, 
  damage = 30, 
  maxHealth = 1, 
}

local function behaviour(self)
  if self.state == "idle" then
    self.state = "moving"
    self:setLinearVelocity(math.random(-1, 1), math.random(10, 20))
    self:applyTorque(math.random(-1, 1))
  end
end

local Big = {}

function Big.create(group, x, y)
  local newRock = Asteroid.create(group, x, y, options)
  newRock.behaviour = behaviour
  return newRock
end

return Big
