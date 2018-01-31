local M = {
    waves = {
        {after = 1, generate = {"asteroid", "enemy", "enemy"}},
        {after = 5, generate = {"asteroid", "asteroid", "enemy"}},
        {after = 3, generate = {"asteroid", "enemy", "enemy"}},
        {after = 5, generate = {"enemy", "enemy", "enemy", "enemy"}},
        {after = 3, generate = {"mine", "mine"}},
        {after = 3, generate = {"enemy", "asteroid", "enemy"}},
        {after = 5, generate = {"enemy", "asteroid", "asteroid"}},
    }
}

return M