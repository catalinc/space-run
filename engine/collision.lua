-- Collision handling

local composer = require("composer")
local asteroids = require("engine.asteroids")

local M = {}

local function getByName(obj1, obj2, name)
  if obj1.myName == name then return obj1 end
  if obj2.myName == name then return obj2 end
  return nil
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

      if laser and asteroid then
        display.remove(laser)
        asteroids.remove(asteroid)
        if type(scene.updateScore) == 'function' then
          scene:updateScore()
        end
      elseif ship and asteroid then
        if not ship.isExploding then
          ship:explode()
          if type(scene.updateLives) == 'function' then
            scene:updateLives()
          end
          if ship:isDead() then
            display.remove(ship)
            if type(scene.endGame) == 'function' then
              timer.performWithDelay(2000, function() scene:endGame() end)
            end
          else
            timer.performWithDelay(1000, function () ship:restore() end)
          end
        end
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