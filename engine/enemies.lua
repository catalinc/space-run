-- The bad guys

local physics = require("physics")
local composer = require("composer")
local sounds = require("libs.sounds")
local eachframe = require("libs.eachframe")
local sprites = require("engine.sprites")

local M = {}

local enemiesTable = {}

-- Create a new enemy ship
function M.newEnemyShip(group)
  group = group or display.currentStage

  local enemyShip = display.newImageRect(group, sprites, 4, 98, 79)
  enemyShip.yScale = -1
  enemyShip.myName = "enemy" -- Used for collision detection

  physics.addBody(enemyShip, {radius=30, isSensor=true})

  table.insert(enemiesTable, enemyShip)

  local lane = math.random(display.contentWidth / enemyShip.contentWidth)
  enemyShip.y = -100
  enemyShip.x = lane * enemyShip.contentWidth

  enemyShip:setLinearVelocity(math.random(-40, 40), math.random(40, 120))

  local scene = composer.getScene(composer.getSceneName("current"))
  local playerShip = scene.playerShip

  enemyShip.lastFireTime = 0

  function enemyShip:eachFrame()
    if self.y < 50 then return end -- No need to fire laser because we are outside screen

    if playerShip.isExploding then return end

    local now = eachframe.lastFrameTime
    local dx = math.abs(self.x - playerShip.x)

    if now - self.lastFireTime > 500 and dx < 10 then
      self:fireLaser()
      self.lastFireTime = now
    end
  end

  function enemyShip:fireLaser()
    sounds.play("fire")

    local newLaser = display.newImageRect(group, sprites, 5, 14, 40)
    newLaser.isBullet = true
    newLaser.myName = "enemyLaser"
    newLaser.x = self.x
    newLaser.y = self.y

    newLaser:toBack()
    physics.addBody(newLaser, "dynamic", {isSensor=true})

    transition.to(newLaser, {y=display.contentHeight + 40, time=2000,
        onComplete = function() display.remove(newLaser) end
    })
  end

  eachframe.add(enemyShip)

  function enemyShip:finalize(event)
    eachframe.remove(self)
  end

  enemyShip:addEventListener("finalize")

  return enemyShip
end

-- Remove enemies which have drifted off screen
function M.removeOffScreen()
  for i = #enemiesTable, 1, -1 do
    local thisEnemy = enemiesTable[i]
    if  thisEnemy.x < -100 or thisEnemy.x > display.contentWidth + 100 or
        thisEnemy.y < -100 or thisEnemy.y > display.contentHeight + 100
    then
      display.remove(thisEnemy)
      table.remove(enemiesTable, i)
    end
  end
end

-- Remove a specific enemy (e.g. after collision)
function M.remove(enemy)
  for i = #enemiesTable, 1, -1 do
    if enemiesTable[i] == enemy then
      sounds.play("explosion")
      display.remove(enemy)
      table.remove(enemiesTable, i)
      break
    end
  end
end

-- Remove all enemies (e.g. before switching scene)
function M.reset()
  for i = #enemiesTable, 1, -1 do
    display.remove(enemiesTable[i])
    table.remove(enemiesTable, i)
  end
end

return M