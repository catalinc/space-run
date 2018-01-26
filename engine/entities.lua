-- Container for display objects.

local MIN_X = -100
local MAX_X = display.contentWidth + 100
local MIN_Y = -100
local MAX_Y = display.contentHeight + 100

-- -----------------------------------------------------------------------------------
-- Entity collection.
-- -----------------------------------------------------------------------------------

local Collection = {}

function Collection:add(entity)
    table.insert(self.data, entity)
end

function Collection:removeAt(i)
    local entity = self.data[i]
    if type(entity.destroy) == "function" then
        entity:destroy()
    else
        display.remove(entity)
    end
    table.remove(self.data, i)
end

function Collection:remove(entity)
    for i = #self.data, 1, -1 do
        if self.data[i] == entity then
            self:removeAt(i)
            break
        end
    end
end

function Collection:collect()
    for i = #self.data, 1, -1 do
        local thisEntity = self.data[i]
        if thisEntity.x < MIN_X or thisEntity.x > MAX_X or
            thisEntity.y < MIN_Y or thisEntity.y > MAX_Y then
            self:removeAt(i)
        end
    end
end

function Collection:clear()
    for i = #self.data, 1, -1 do
        self:removeAt(i)
    end
end

function Collection:count()
    return #self.data
end

-- -----------------------------------------------------------------------------------
-- Public API
-- -----------------------------------------------------------------------------------

local M = {}

function M.new()
    return setmetatable({data = {}}, {__index = Collection})
end

return M