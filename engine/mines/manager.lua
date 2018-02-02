-- Beware, space mines ahead.

local physics = require("physics")
local types = require("engine.mines.types")
local mine = require("engine.mines.mine")
local collection = require("engine.common.collection")

local M = {}

local mines = collection.new()

function M.spawn(name)
    local mineType = types.get(name)
    local newMine = mine.new(mineType)
    mines:add(newMine)
end

function M.remove(mine)
    mines:remove(mine)
end

function M.removeOffScreen()
    mines:removeOffScreen()
end

function M.clear()
    mines:clear()
end

function M.count()
    return mines:count()
end

return M
