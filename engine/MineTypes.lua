-- Mines types

-- Behaviours

function fall(mine)
    if mine.state == "idle" then
        mine.state = "moving"
        mine:setLinearVelocity(0, math.random(20, 100))
    end
end

-- Type objects

local MineTypes = {}

MineTypes.static = {
        sprite = {frameIndex = 1, width = 102, height = 85},
        physics = {radius = 40, isSensor = true},
        points = 250,
        damage = 200,
        behaviour = fall,
        showHealthBar = true,
}

return MineTypes