local M = {
    waves = {
        {after = 1, generate = {
            {"enemy", "grunt"},
            {"enemy", "grunt"},
            {"asteroid", "rock1"},
        }},
        {after = 5, generate = {
            {"enemy", "grunt"},
            {"asteroid", "rock1"},
            {"asteroid", "rock2"},
        }},
        {after = 3, generate = {
            {"enemy", "grunt"},
            {"enemy", "grunt"},
            {"asteroid", "rock3"},
            {"asteroid", "rock2"},
        }},
        {after = 5, generate = {
            {"enemy", "grunt"},
            {"enemy", "grunt"},
            {"enemy", "grunt"},
            {"asteroid", "rock1"},
            {"asteroid", "rock2"},
            {"asteroid", "rock3"},
        }},
        {after = 3, generate = {
            {"enemy", "grunt"},
            {"enemy", "grunt"},
            {"mine", "static"},
            {"mine", "static"},
            {"asteroid", "rock1"},
            {"asteroid", "rock2"},
        }},
        {after = 3, generate = {
            {"enemy", "grunt"},
            {"enemy", "grunt"},
            {"enemy", "grunt"},
            {"asteroid", "rock1"},
            {"asteroid", "rock2"},
            {"asteroid", "rock3"},
        }},
        {after = 5, generate = {
            {"enemy", "grunt"},
            {"asteroid", "rock1"},
            {"asteroid", "rock3"},
        }},
        {after = 10, generate = {
            {"enemy", "boss"},
            {"enemy", "grunt"},
            {"asteroid", "rock1"},
        }}
    }
}

return M