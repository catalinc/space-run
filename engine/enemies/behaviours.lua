-- Enemy behaviour.

local M = {}

function M.grunt(thisEnemy)
    if thisEnemy.state == "idle" then
        thisEnemy:fall()
    end

    if thisEnemy:canAttack() then
        thisEnemy:fireLaser()
    end
end

function M.boss(thisEnemy)
    local target = thisEnemy.target
    if thisEnemy.state == "idle" then
        thisEnemy:moveToIntercept()
    elseif thisEnemy.state == "moving" then
        if thisEnemy:canAttack() then
            thisEnemy:fireLaser()
        end
    end
end

return M