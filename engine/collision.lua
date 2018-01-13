-- Collision handling

local composer = require("composer")
local asteroids = require("engine.asteroids")
local enemies = require("engine.enemies")

local M = {}

local function getByName(obj1, obj2, name)
  if obj1.myName == name then return obj1 end
  if obj2.myName == name then return obj2 end
  return nil
end

local function explodeShip(ship, scene)
  if not ship.isExploding then
    ship:explode()
    scene:updateLives()
    if ship:isDead() then
      display.remove(ship)
      timer.performWithDelay(2000, function() scene:endGame() end)
    else
      timer.performWithDelay(1000, function () ship:restore() end)
    end
  end
end

local function onCollision(event)
  local scene = composer.getScene(composer.getSceneName('current'))
  if scene then
    if event.phase == "began" then
      local obj1 = event.object1
      local obj2 = event.object2

      local asteroid = getByName(obj1, obj2, "asteroid")
      local ship = getByName(obj1, obj2, "ship")
      local laser = getByName(obj1, obj2, "laser")
      local enemy = getByName(obj1, obj2, "enemy")
      local enemyLaser = getByName(obj1, obj2, "enemyLaser")

      if laser and asteroid then
        display.remove(laser)
        asteroids.remove(asteroid)
        scene:updateScore()
      elseif laser and enemy then
        display.remove(laser)
        enemies.remove(enemy)
        scene:updateScore()
      elseif enemyLaser and asteroid then
        display.remove(enemyLaser)
        asteroids.remove(asteroid)
      elseif enemyLaser and ship then
        display.remove(enemyLaser)
        explodeShip(ship, scene)
      elseif ship and asteroid then
        asteroids.remove(asteroid)
        explodeShip(ship, scene)
      elseif ship and enemy then
        enemies.remove(enemy)
        explodeShip(ship, scene)
      end
    end
  end
end

function M.start()
  Runtime:addEventListener("collision", onCollision)
end

function M.pause()
  Runtime:removeEventListener("collision", onCollision)
end

return M