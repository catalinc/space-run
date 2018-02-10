local M = {
    waves = {
        {after = 1, generate = {
            {"Player", "default"},
        }},
        {after = 10, generate = {
            {"Enemy", "grunt"},
            {"Enemy", "grunt"},
            {"Asteroid", "rock1"},
        }},
    }
}

return M