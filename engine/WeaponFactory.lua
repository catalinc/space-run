local EventBus = require("engine.EventBus")

local registry = {}

local knownWeapons = {"Bullet"}

for i = 1, #knownWeapons do
    local name = knownWeapons[i]
    local classMod = require("engine." .. name)
    local typesMod = require("engine." .. name .. "Types")
    registry[name] = {classMod = classMod, typesMod = typesMod}
end

local WeaponFactory = {}

function WeaponFactory.create(name, type, source, target)
    local entry = registry[name]
    if entry then
        local classMod = entry.classMod
        local typesMod = entry.typesMod
        local weaponType = typesMod[type] -- type object
        if weaponType then
            return classMod.create(source, target, weaponType)
        end
    end
end

return WeaponFactory