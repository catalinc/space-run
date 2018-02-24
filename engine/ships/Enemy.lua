local EachFrame = require("libs.EachFrame")
local Ship = require("engine.ships.Ship")

local function getTarget(self)
  if not self.target then
    local group = self.parent
    for i = 1, group.numChildren do
      local unit = group[i]
      if unit.name == "Player" then
        self.target = unit
        break
      end
    end
  end
  return self.target
end

local function canAttack(self)
  if self.y < self.contentHeight / 2 then
    return false
  end

  local target = self:getTarget()
  if (not target) or target.state == "exploding" then
    return false
  end

  local dx = math.abs(self.x - target.x)
  if dx > target.radius then
    return false
  end

  return true
end

local function interceptPlayer(self, time, distance)
  local target = self:getTarget()
  if target and target.state ~= "exploding" then
    local x = target.x
    local y = math.max(0, target.y - distance)
    self.state = "moving"
    transition.to(self, {x = x, y = y, time = time, onComplete = function() self.state = "idle" end})
  end
end

local function fall(self)
  self.state = "moving"
  self:setLinearVelocity(math.random(-2, 2), math.random(40, 120))
end

local Enemy = {}

function Enemy.create(group, x, y, options)
  local newEnemy = Ship.create("Enemy", group, x, y, options)

  newEnemy.yScale = -1 -- TODO: temporary until replaced with proper sprite

  newEnemy.getTarget = getTarget
  newEnemy.canAttack = canAttack
  newEnemy.interceptPlayer = interceptPlayer
  newEnemy.fall = fall

  return newEnemy
end

return Enemy
