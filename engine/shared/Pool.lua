local store = {}

local Pool = {}

function Pool.get(key)
  local p = store[key]
  if p and #p > 0 then
    return table.remove(p)
  end
end

function Pool.put(key, obj)
  local p = store[key]
  if not p then
    p = {}
    store[key] = p
  end
  p[#p + 1] = obj
end

function Pool.clearAll()
  store = {}
end

return Pool
