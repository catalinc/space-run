-- Display groups.

local groups = {}

-- -----------------------------------------------------------------------------------
-- Public API
-- -----------------------------------------------------------------------------------

local M = {}

function M.set(name, group)
    groups[name] = group
end

function M.get(name)
    return groups[name]
end

function M.clear()
    groups = {}
end

return M