local Mine = require("engine.mines.Mine")

local options = {
  sprite = {frameIndex = 1, width = 102, height = 85}, 
  physics = {radius = 40, isSensor = true}, 
  health = 250, 
  damage = 200, 
  showHealthBar = true, 
}

local function behaviour(self)
  if self.state == "idle" then
    self.state = "moving"
    self:setLinearVelocity(0, math.random(20, 40))
  end
end

local Slow = {}

function Slow.create(group, x, y)
  local newMine = Mine.create(group, x, y, options)
  newMine.behaviour = behaviour
  return newMine
end

return Slow
