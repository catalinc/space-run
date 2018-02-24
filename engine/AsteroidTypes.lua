-- Asteroid types

-- Behaviours

function fall(asteroid)
  if asteroid.state == "idle" then
    asteroid.state = "moving"
    asteroid:setLinearVelocity(math.random(-5, 5), math.random(50, 150))
    asteroid:applyTorque(math.random(-10, 10))
  end
end

-- Type objects

local AsteroidTypes = {}

AsteroidTypes.rock1 = {
  sprite = {frameIndex = 1, width = 102, height = 85}, 
  physics = {radius = 40, bounce = 0.8}, 
  damage = 10, 
  health = 10, 
  behaviour = fall, 
}

AsteroidTypes.rock2 = {
  sprite = {frameIndex = 2, width = 90, height = 83}, 
  physics = {radius = 40, bounce = 0.8}, 
  damage = 20, 
  health = 10, 
  behaviour = fall, 
}

AsteroidTypes.rock3 = {
  sprite = {frameIndex = 3, width = 100, height = 97}, 
  physics = {radius = 40, bounce = 0.8}, 
  damage = 30, 
  health = 10, 
  behaviour = fall, 
}

return AsteroidTypes
