-- Level driver
local asteroids = require("engine.asteroids")
local enemies = require("engine.enemies")

local M = {}

local uiGroup
local gameLoopTimer

local function gameLoop()
  asteroids.newAsteroid(uiGroup)
  asteroids.removeOffScreen()

  enemies.newEnemyShip(uiGroup)
  enemies.removeOffScreen()
end

function M.init(group)
  uiGroup = group or display.currentStage
end

function M.start()
  gameLoopTimer = timer.performWithDelay(500, gameLoop, 0)
end

function M.stop()
  timer.cancel(gameLoopTimer)
end

return M