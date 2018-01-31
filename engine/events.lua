-- Game events.

local bus = {}

-- -----------------------------------------------------------------------------------
-- Public API
-- -----------------------------------------------------------------------------------

local M = {}

function M.subscribe(event, listener)
    local listeners = bus[event]
    if not listeners then
        listeners = {}
        bus[event] = listeners
    end
    listeners[#listeners + 1] = listener
end

function M.unsubscribe(event, listener)
    local listeners = bus[event]
    if listeners then
        for i = #listeners, 1, -1 do
            local thisListener = listeners[i]
            if thisListener == listener then
                table.remove(listeners, i)
                break
            end
        end
    end
end

function M.publish(event, data)
    local listeners = bus[event]
    if listeners then
        for i = #listeners, 1, -1 do
            local listener = listeners[i]
            listener(data)
        end
    end
end

function M.clear()
    bus = {}
end

return M