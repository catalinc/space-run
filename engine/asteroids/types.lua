-- Asteroid types.

local imageSheet = require("engine.ui.sprites")
local behaviours = require("engine.asteroids.behaviours")

local M = {
    rock1 = {
        sprite = {sheet = imageSheet, frameIndex = 1, width = 102, height = 85},
        points = 50,
        damage = 10,
        behaviour = behaviours.flyRandom,
    },
    rock2 = {
        sprite = {sheet = imageSheet, frameIndex = 2, width = 90, height = 83},
        points = 80,
        damage = 20,
        behaviour = behaviours.flyRandom,
    },
    rock3 = {
        sprite = {sheet = imageSheet, frameIndex = 3, width = 100, height = 97},
        points = 100,
        damage = 30,
        behaviour = behaviours.flyRandom,
    },
}

return M