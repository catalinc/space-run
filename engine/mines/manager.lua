-- Beware, space mines ahead.

local types = require("engine.mines.types")
local mine = require("engine.mines.mine")
local Collection = require("engine.common.collection")

local Mines = Collection:new()

function Mines:spawn(typeName)
    local typeObject = types.get(typeName)
    local newMine = mine.new(typeObject)
    self:add(newMine)
end

return Mines