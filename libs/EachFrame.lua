--[[
    A handy manager for Corona's 'enterFrame' runtime event.

    This library registers a single 'enterFrame' listener to call all the other listeners.

    In addition it provides the delta time between frames and the timestamp of the last frame.
    These can be useful for sprite animation and/or game logic.

    Listeners can be functions or tables. A table listener must provide a 'eachFrame' method
    in order to be called.

    Do not forget to remove a listener when is not needed anymore. In case the listener is a
    display object you can use Corona's 'finalize' event to remove it.
--]]

local EachFrame = {deltaTime = 0, lastFrameTime = 0}

local function enterFrame()
    local now = system.getTimer()
    EachFrame.deltaTime = now - EachFrame.lastFrameTime
    EachFrame.lastFrameTime = now

    for i = 1, #EachFrame.listeners do
        local listener = EachFrame.listeners[i]
        if type(listener) == 'function' then
            listener()
        elseif type(listener) == 'table' and type(listener.eachFrame) == 'function' then
            listener:eachFrame()
        end
    end
end

function EachFrame.add(listener)
    if not EachFrame.listeners then
        EachFrame.listeners = {}
        Runtime:addEventListener('enterFrame', enterFrame)
    end
    table.insert(EachFrame.listeners, listener)
end

function EachFrame.remove(listener)
    if not listener or not EachFrame.listeners then return end
    local index = table.indexOf(EachFrame.listeners, listener)
    if index then
        table.remove(EachFrame.listeners, index)
        if #EachFrame.listeners == 0 then
            Runtime:removeEventListener('enterFrame', enterFrame)
            EachFrame.listeners = nil
        end
    end
end

return EachFrame