local store = {}
local sealed = false

local Pool = {}

function Pool.get(key)
  local p = store[key]
  if p and #p > 0 then
    return table.remove(p)
  end
end

function Pool.put(key, obj)
  if sealed then return end
  local p = store[key]
  if not p then
    p = {}
    store[key] = p
  end
  p[#p + 1] = obj
end

-- Seal the pool and discard all entries. Any deferred timers that fire
-- after this point will have their Pool.put calls silently ignored.
function Pool.clearAll()
  store = {}
  sealed = true
end

-- Unseal the pool at the start of a new game session.
function Pool.open()
  sealed = false
end

return Pool
