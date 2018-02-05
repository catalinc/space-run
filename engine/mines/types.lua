-- Mine types.

local imageSheet = require("engine.ui.sprites")
local behaviours = require("engine.mines.behaviours")

local M = {
    static = {
        sprite = {sheet = imageSheet, frameIndex = 1, width = 102, height = 85},
        points = 250,
        damage = 200,
        behaviour = behaviours.fall,
    },
}

return M
