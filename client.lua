-- Variables

local QBCore = exports['qb-core']:GetCoreObject()
local currentZone = nil
local PlayerData = {}

-- Handlers

AddEventHandler('onResourceStart', function(resourceName)
	if (GetCurrentResourceName() ~= resourceName) then return end
	PlayerData = QBCore.Functions.GetPlayerData()
end)

AddEventHandler('QBCore:Client:OnPlayerLoaded', function()
    PlayerData = QBCore.Functions.GetPlayerData()
end)

RegisterNetEvent('QBCore:Client:OnJobUpdate', function(JobInfo)
    PlayerData.job = JobInfo
end)

RegisterNetEvent('QBCore:Client:OnPlayerUnload', function()
    PlayerData = {}
end)

-- Static Header

RegisterNetEvent('qb-djbooth:client:playMusic', function(data)
    local hdr = 'ðŸ’¿ | DJ Booth'
    if data then currentZone = data.netid hdr = 'ðŸ“» Portable Player' end

    exports['qb-menu']:openMenu({
       {
            header = hdr,
            isHeader = true,

        },
        {
            header = 'ðŸŽ¶ | Play a song',
            txt = 'Enter a youtube URL',
            params = {
                event = 'qb-djbooth:client:musicMenu',
                args = {
                    zoneName = currentZone
                }
            }
        },
        {
            header = 'â¸ï¸ | Pause Music',
            txt = 'Pause currently playing music',
            params = {
                isServer = true,
                event = 'qb-djbooth:server:pauseMusic',
                args = {
                    zoneName = currentZone
                }
            }
        },
        {
            header = 'â–¶ï¸ | Resume Music',
            txt = 'Resume playing paused music',
            params = {
                isServer = true,
                event = 'qb-djbooth:server:resumeMusic',
                args = {
                    zoneName = currentZone
                }
            }
        },
        {
            header = 'ðŸ”ˆ | Change Volume',
            txt = 'Resume playing paused music',
            params = {
                event = 'qb-djbooth:client:changeVolume',
                args = {
                    zoneName = currentZone
                }
            }
        },
        {
            header = 'âŒ | Turn off music',
            txt = 'Stop the music & choose a new song',
            params = {
                isServer = true,
                event = 'qb-djbooth:server:stopMusic',
                args = {
                    zoneName = currentZone
                }
            }
        },
    })
end)


--Name: vu_djbooth | 2022-01-14T06:23:43Z
local vanilla = BoxZone:Create(vector3(121.21, -1281.05, 29.27), 3.2, 3.4, {
  name="vu_djbooth",
  heading=300,
  --debugPoly=true,
  minZ=28.47,
  maxZ=31.27
})


-- DJ Booths


CreateThread(function()
    while true do
        Wait(0)
        sleep = true
        if LocalPlayer.state.isLoggedIn then
            local pos = GetEntityCoords(PlayerPedId())

            if PlayerData.job.name == Config.Locations['vanilla'].job and vanilla:isPointInside(pos) then
                sleep = false
                currentZone = 'vanilla'
                for k, v in pairs(Config.Booths) do
                    local pos = GetEntityCoords(PlayerPedId())
                    if #(pos - vector3(v.x, v.y, v.z)) < 4.0 then
                        sleep = false
                        if #(pos - vector3(v.x, v.y, v.z)) < 1.5 then
                            QBCore.Functions.DrawText3D(v.x, v.y, v.z, "~g~E~w~ -  DJ")
                            if IsControlJustReleased(0, 38) then
                                TriggerEvent('dj:booth')
                            end
                        elseif #(pos - vector3(v.x, v.y, v.z)) < 2.5 then
                            QBCore.Functions.DrawText3D(v.x, v.y, v.z, "DJ")
                        end
                    end
                end
            else
                currentZone = nil
            end
        end
    end
    if sleep then
        Wait(1000)
    end
end)

-- Events

RegisterNetEvent('qb-djbooth:client:musicMenu', function(data)
    local dialog = exports['qb-input']:ShowInput({
        header = 'Song Selection',
        submitText = "Submit",
        inputs = {
            {
                type = 'text',
                isRequired = true,
                name = 'song',
                text = 'YouTube URL'
            }
        }
    })
    if dialog then
        print(dialog.song, data.zoneName)
        if not dialog.song then return end
        TriggerServerEvent('qb-djbooth:server:playMusic', dialog.song, data.zoneName)
    end
end)

RegisterNetEvent('qb-djbooth:client:changeVolume', function(data)
    local dialog = exports['qb-input']:ShowInput({
        header = 'Music Volume',
        submitText = "Submit",
        inputs = {
            {
                type = 'text', -- number doesn't accept decimals??
                isRequired = true,
                name = 'volume',
                text = 'Min: 0.01 - Max: 1.0'
            }
        }
    })
    if dialog then
        print(dialog.volume, data.zoneName)
        if not dialog.volume then return end
        TriggerServerEvent('qb-djbooth:server:changeVolume', dialog.volume, data.zoneName)
    end
end)
