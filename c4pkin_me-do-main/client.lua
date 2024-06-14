local pedDisplaying = {}

local function DrawText3D(coords, text)
    local camCoords = GetGameplayCamCoord()
    local dist = #(coords - camCoords)
    
    local scale = 200 / (GetGameplayCamFov() * dist)

    local c = Config.visual.color
    SetTextColour(c.r, c.g, c.b, c.a)
    SetTextScale(0.0, Config.visual.scale * scale)
    SetTextFont(Config.visual.font)
    SetTextDropshadow(0, 0, 0, 0, 55)
    SetTextDropShadow()
    SetTextCentre(true)

    BeginTextCommandDisplayText("STRING")
    AddTextComponentSubstringPlayerName(text)
    SetDrawOrigin(coords, 0)
    EndTextCommandDisplayText(0.0, 0.0)
    ClearDrawOrigin()

end

local function DrawText3Ds(coords, text)
    local camCoords = GetGameplayCamCoord()
    local dist = #(coords - camCoords)
    
    local scale = 200 / (GetGameplayCamFov() * dist)

    local c = Config.visuals.color
    SetTextColour(c.r, c.g, c.b, c.a)
    SetTextScale(0.0, Config.visuals.scale * scale)
    SetTextFont(Config.visuals.font)
    SetTextDropshadow(0, 0, 0, 0, 55)
    SetTextDropShadow()
    SetTextCentre(true)

    BeginTextCommandDisplayText("STRING")
    AddTextComponentSubstringPlayerName(text)
    SetDrawOrigin(coords, 0)
    EndTextCommandDisplayText(0.0, 0.0)
    ClearDrawOrigin()

end


local function Display(ped, text)

    local playerPed = PlayerPedId()
    local playerCoords = GetEntityCoords(playerPed)
    local pedCoords = GetEntityCoords(ped)
    local dist = #(playerCoords - pedCoords)

    if dist <= Config.visual.dist then

        pedDisplaying[ped] = (pedDisplaying[ped] or 1) + 1

        local display = true

        Citizen.CreateThread(function()
            Wait(Config.visual.time)
            display = false
        end)

        local offset = 0.8 + pedDisplaying[ped] * 0.1
        while display do
            if HasEntityClearLosToEntity(playerPed, ped, 17 ) then
                local x, y, z = table.unpack(GetEntityCoords(ped))
                z = z + offset
                DrawText3D(vector3(x, y, z-1.0), text)
            end
            Wait(0)
        end

        pedDisplaying[ped] = pedDisplaying[ped] - 1

    end
end

local function DisplayDo(ped, text)

    local playerPed = PlayerPedId()
    local playerCoords = GetEntityCoords(playerPed)
    local pedCoords = GetEntityCoords(ped)
    local dist = #(playerCoords - pedCoords)

    if dist <= Config.visual.dist then

        pedDisplaying[ped] = (pedDisplaying[ped] or 1) + 1

        local display = true

        Citizen.CreateThread(function()
            Wait(Config.visual.time)
            display = false
        end)

        local offset = 0.8 + pedDisplaying[ped] * 0.1
        while display do
            if HasEntityClearLosToEntity(playerPed, ped, 17 ) then
                local x, y, z = table.unpack(GetEntityCoords(ped))
                z = z + offset
                DrawText3Ds(vector3(x, y, z-1.0), text)
            end
            Wait(0)
        end

        pedDisplaying[ped] = pedDisplaying[ped] - 1

    end
end

RegisterNetEvent('3dme:shareDisplay')
AddEventHandler('3dme:shareDisplay', function(text, serverId)
    local player = GetPlayerFromServerId(serverId)
    if player ~= -1 then
        local ped = GetPlayerPed(player)
        Display(ped, text)
    end
end)

RegisterNetEvent('3dme:shareDisplayDo')
AddEventHandler('3dme:shareDisplayDo', function(text, serverId)
    local player = GetPlayerFromServerId(serverId)
    if player ~= -1 then
        local ped = GetPlayerPed(player)
        DisplayDo(ped, text)
    end
end)

local LANGUAGE = Config.language
TriggerEvent('chat:addSuggestion', '/' .. Languages[LANGUAGE].commandName, Languages[LANGUAGE].commandDescription, Languages[LANGUAGE].commandSuggestion)

RegisterNetEvent('sendProximityMessageMe')
AddEventHandler('sendProximityMessageMe', function(id, name, message)
  local myId = PlayerId()
  local pid = GetPlayerFromServerId(id)
  if pid == myId then
	TriggerEvent('chat:addMessage', {
			template = '<div style="padding: 8px; margin: 8px; background-color: rgba(136, 75, 116, 1.0); border-radius: 6px;"><i class="fas fa-bell"style="font-size:15px"></i>^*{0}^r {1}</font></i></b></div>',
            args = { name , message }
			})
  
  elseif pid ~= -1 and GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(myId)), GetEntityCoords(GetPlayerPed(pid)), true) < 5.0 then
	TriggerEvent('chat:addMessage', {
			template = '<div style="padding: 8px; margin: 8px; background-color: rgba(136, 75, 116, 1.0); border-radius: 6px;"><i class="fas fa-bell"style="font-size:15px"></i>^*{0}^r {1}</font></i></div>',
            args = { name , message }
			})
  end
end)

RegisterNetEvent('sendProximityMessageDo')
AddEventHandler('sendProximityMessageDo', function(id, name, message)
  local myId = PlayerId()
  local pid = GetPlayerFromServerId(id)
  if pid == myId then
    TriggerEvent('chat:addMessage', {
			template = '<div style="padding: 8px; margin: 8px; background-color: rgba(55, 120, 105, 1.0); border-radius: 6px;"><i class="fas fa-bell"style="font-size:15px"></i>{1} ^*({0})</font></i></b></div>',
            args = { name , message }
			})
  elseif pid ~= -1 and GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(myId)), GetEntityCoords(GetPlayerPed(pid)), true) < 5.0 then
    TriggerEvent('chat:addMessage', {
			template = '<div style="padding: 8px; margin: 8px; background-color: rgba(55, 120, 105, 1.0); border-radius: 6px;"><i class="fas fa-bell"style="font-size:15px"></i>{1} ^*({0})</font></i></b></div>',
            args = { name , message }
			})
  end
end)