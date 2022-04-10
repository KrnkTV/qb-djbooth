Config = {}

Config.DefaultVolume = 0.05 -- Accepted values are 0.01 - 1

Config.Locations = {
    ['vanilla'] = {
        ['job'] = 'vu', -- Required job to use booth
        ['radius'] = 30, -- The radius of the sound from the booth
        ['coords'] = vector3(120.52, -1281.5, 29.48), -- Where the booth is located
        ['playing'] = false
    }
}

Config.Booths = {
    [1] = vector3(120.15, -1281.57, 29.43),
}
