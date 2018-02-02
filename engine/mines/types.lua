-- Asteroid types.

local imageSheet = require("engine.ui.sprites")
local behaviours = require("engine.mines.behaviours")

local types = {
    static = {
        sprite = {sheet = imageSheet, frameIndex = 1, width = 102, height = 85},
        points = 250,
        damage = 200,
        behaviour = behaviours.fall,
    },
}

local M = {}

function M.get(name)
    return types[name]
end

return M
