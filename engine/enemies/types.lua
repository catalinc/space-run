-- Enemy types.

local imageSheet = require("engine.ui.sprites")
local behaviours = require("engine.enemies.behaviours")

local M = {
    grunt = {
        sprite = {sheet = imageSheet, frameIndex = 4, width = 98, height = 79, radius = 30},
        points = 100,
        maxHealth = 100,
        damage = 20,
        fireInterval = 2000,
        fireDuration = 2000,
        behaviour = behaviours.grunt,
    },
    boss = {
        sprite = {sheet = imageSheet, frameIndex = 4, width = 98, height = 79, radius = 30},
        points = 1000,
        maxHealth = 500,
        damage = 50,
        fireInterval = 1000,
        fireDuration = 1000,
        behaviour = behaviours.boss,
    },
}

return M