-- Bad guys

local EachFrame = require("libs.EachFrame")
local Unit = require("engine.Unit")
local WeaponFactory = require("engine.WeaponFactory")

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
  local target = self:getTarget()
  return (self.y > self.contentHeight / 2) and target and target.state == "active"
end

local function fireLaser(self)
  if self:canAttack() then
    local target = self:getTarget()
    if target then
      local now = EachFrame.lastFrameTime
      local dx = math.abs(self.x - target.x)
      local dt = now - self.lastFireTime
      if dt >= self.interval and dx <= target.radius then
        self:fireWeapon("Bullet", "default", {direction = "down"})
        self.lastFireTime = now
      end
    end
  end
end

local function moveToIntercept(self, distance)
  local target = self:getTarget()
  if target and target.state == "active" then
    local toX = target.x
    local toY = math.max(0, target.y - distance)
    self.state = "moving"
    transition.to(self, {x = toX, 
      y = toY, 
    time = 2000, onComplete = function() self.state = "idle" end})
  end
end

local function fall(self)
  self.state = "moving"
  self:setLinearVelocity(math.random(-2, 2), math.random(40, 120))
end

local Enemy = {}

function Enemy.create(group, x, y, options)
  local newEnemy = Unit.create("Enemy", group, x, y, options)
  newEnemy.yScale = -1 -- Temporary until replaced with proper sprite
  newEnemy.interval = options.interval or 1000
  newEnemy.duration = options.duration or 1000
  newEnemy.lastFireTime = 0

  newEnemy.getTarget = getTarget
  newEnemy.canAttack = canAttack
  newEnemy.fireLaser = fireLaser
  newEnemy.moveToIntercept = moveToIntercept
  newEnemy.fall = fall

  return newEnemy
end

return Enemy
