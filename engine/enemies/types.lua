-- Enemy types.

local imageSheet = require("engine.ui.sprites")
local behaviours = require("engine.enemies.behaviours")

local M = {
    grunt = {
        sprite = {sheet = imageSheet, frameIndex = 4, width = 98, height = 79},
        points = 100,
        maxHealth = 100,
        damage = 20,
        fireInterval = 1000,
        behaviour = behaviours.grunt,
    },
    boss = {
        sprite = {sheet = imageSheet, frameIndex = 4, width = 98, height = 79},
        points = 1000,
        maxHealth = 500,
        damage = 50,
        fireInterval = 300,
        behaviour = behaviours.boss,
    },
}

return M