-- Some utility functions.

-- -----------------------------------------------------------------------------------
-- Public API
-- -----------------------------------------------------------------------------------

local M = {}

function M.clamp(v, min, max)
    if v < min then return min end
    if v > max then return max end
    return v
end

function M.randomSequence(min, max)
    local t = {}
    for i = min, max do
        t[#t + 1] = i
    end
    for i = #t, 1, -1 do
        local j = math.random(1, i)
        t[i], t[j] = t[j], t[i]
    end
    return t
end

return M
