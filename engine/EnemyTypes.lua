-- Bad guys

-- Behaviours

function fallAndShoot(enemy)
    if enemy.state == "idle" then
        enemy:fall()
    end

    if enemy:canAttack() then
        enemy:fireLaser()
    end
end

function interceptAndShoot(enemy)
    if enemy.state == "idle" then
        enemy:moveToIntercept(100)
    elseif enemy.state == "moving" then
        if enemy:canAttack() then
            enemy:fireLaser()
        end
    end
end

-- Type objects

local EnemyTypes = {}

EnemyTypes.grunt = {
        sprite = {frameIndex = 4, width = 98, height = 79},
        physics = {radius = 30, isSensor = true},
        points = 100,
        maxHealth = 100,
        damage = 20,
        interval = 2000,
        duration = 2000,
        behaviour = fallAndShoot,
        showHealthBar = true,
}

EnemyTypes.boss = {
        sprite = {frameIndex = 4, width = 98, height = 79},
        physics = {radius = 30, isSensor = true},
        points = 1000,
        maxHealth = 500,
        damage = 50,
        interval = 1000,
        duration = 1000,
        behaviour = interceptAndShoot,
        showHealthBar = true,
}

return EnemyTypes