-- Player types

-- Behaviours

function noop(player) end

-- Type objects

local PlayerTypes = {}

PlayerTypes.default = {
  sprite = {frameIndex = 4, width = 98, height = 79}, 
  physics = {radius = 30, isSensor = true}, 
  maxLives = 3, 
  maxHealth = 100, 
  damage = 50, 
  interval = 300, 
  duration = 500, 
  behaviour = noop, 
}

return PlayerTypes
