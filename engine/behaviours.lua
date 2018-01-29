-- Enemy behaviours.

local sounds = require("libs.sounds")
local eachframe = require("libs.eachframe")
local laser = require("engine.laser")

local abs = math.abs
local HEIGHT = display.contentHeight

-- -----------------------------------------------------------------------------------
-- Public API
-- -----------------------------------------------------------------------------------

local M = {}

function M.simple(enemy)
    local target = enemy.target
    if not target then return end
    if not target.isBodyActive then return end
    if not enemy.isVisible then return end -- Don't attack if we are not visible

    local now = eachframe.lastFrameTime
    local dx = abs(enemy.x - target.x)

    if now - enemy.lastFireTime > enemy.fireInterval and dx < 10 then
        enemy.lastFireTime = now
        sounds.play("fire")
        laser.fire(enemy.parent, enemy.x, enemy.y,
                   {y = HEIGHT + 40,
                    name="enemyLaser",
                    duration = 2000,
                    damage = enemy.damage})
    end
end

return M