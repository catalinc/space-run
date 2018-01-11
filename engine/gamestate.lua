-- Game state (score, lifes, level etc.)
local M = {}

local state = { score = 0, lifes = 3, died = false, level = 1 }

function M.isGameOver()
    return state.lifes == 0
end

function M.didPlayerDie()
    return state.died
end

function M.killPlayer()
    if state.lifes == 0 then return end
    state.lifes = state.lifes - 1
    state.died = true
end

function M.resurrectPlayer()
    state.died = false
end

function M.reset()
    state.score = 0
    state.lifes = 3
    state.died = false
    state.level = 1
end

return M