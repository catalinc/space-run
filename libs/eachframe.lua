-- EachFrame library
-- This is a handy manager for the enterFrame runtime event.
-- Listeners can be both functions and objects.
-- The point of this module is to have only one runtime listener to call all other listeners.
-- This leads to less runtime errors.
-- Don't forget to remove the listeners when they are not needed anymore. Use Corona's finalize event.

local M = {}

local function enterFrame()
  for i = 1, #M.enterFrameListeners do
    if type(M.enterFrameListeners[i]) == 'function' then
      M.enterFrameListeners[i]()
    elseif type(M.enterFrameListeners[i]) == 'table' and type(M.enterFrameListeners[i].eachFrame) == 'function' then
      M.enterFrameListeners[i]:eachFrame()
    end
  end
end

function M.add(listener)
  if not M.enterFrameListeners then
    M.enterFrameListeners = {}
    Runtime:addEventListener('enterFrame', enterFrame)
  end
  table.insert(M.enterFrameListeners, listener)
  return listener
end

function M.remove(listener)
  if not listener or not M.enterFrameListeners then return end
  local ind = table.indexOf(M.enterFrameListeners, listener)
  if ind then
    table.remove(M.enterFrameListeners, ind)
    if #M.enterFrameListeners == 0 then
      M.removeAll()
    end
  end
end

function M.removeAll()
  Runtime:removeEventListener('enterFrame', enterFrame)
  M.enterFrameListeners = nil
end

return M
