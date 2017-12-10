-- Logging library.
-- All logging goes to stdout.

local _M = {}

local levels = { 'ERROR', 'INFO', 'WARNING', 'DEBUG' }

local currentLevel = 4

local function log(level, message)
    if level >= currentLevel then 
        print(levels[level] .. ': ' .. message)
    end
end

function _M.debug(message)
    log(4, message)
end

function _M.info(message)
    log(3, message)
end

function _M.warn(tag, message)
    log(2, message)
end

function _M.error(tag, message)
    log(1, message)
end

function _M.setLevel(level)
    for i = #levels, 1, -1 do
        if levels[i] == level then
            currentLevel = i
            break
        end
    end
end

function _M.isDebugEnabled()
    return currentLevel >= 4
end

return _M