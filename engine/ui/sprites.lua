-- Sprites sheet.

local options =
{
    frames =
    {
        {-- 1) asteroid 1
            x = 0,
            y = 0,
            width = 102,
            height = 85
        },
        {-- 2) asteroid 2
            x = 0,
            y = 85,
            width = 90,
            height = 83
        },
        {-- 3) asteroid 3
            x = 0,
            y = 168,
            width = 100,
            height = 97
        },
        {-- 4) ship
            x = 0,
            y = 265,
            width = 98,
            height = 79
        },
        {-- 5) laser
            x = 98,
            y = 265,
            width = 14,
            height = 40
        },
    },
}

return graphics.newImageSheet("graphics/gameObjects.png", options)
