local discordWebhook = ""

RegisterCommand('me', function(source, args)
	local name = getIdentity(source)
	local adsoyad = name.firstname .. ' ' .. name.lastname
    local text = "" .. Languages[Config.language].prefix .. table.concat(args, " ") .. ""
    TriggerClientEvent('3dme:shareDisplay', -1, text, source)
	TriggerClientEvent("sendProximityMessageMe", -1, source, adsoyad, table.concat(args, " "))

    sendDiscordLog(adsoyad, table.concat(args, " "), "me")
end)

RegisterCommand('do', function(source, args)
	local name = getIdentity(source)
	local adsoyad = name.firstname .. ' ' .. name.lastname
    local text = "" .. Languages[Config.language].prefix .. table.concat(args, " ") .. ""
    TriggerClientEvent('3dme:shareDisplayDo', -1, text, source)
	TriggerClientEvent("sendProximityMessageDo", -1, source, adsoyad, table.concat(args, " "))

    sendDiscordLog(adsoyad, table.concat(args, " "), "do")
end)

function getIdentity(source)
	local identifier = GetPlayerIdentifiers(source)[1]
	local result = MySQL.Sync.fetchAll("SELECT * FROM users WHERE identifier = @identifier", {['@identifier'] = identifier})
	if result[1] ~= nil then
		local identity = result[1]

		return {
			identifier = identity['identifier'],
			firstname = identity['firstname'],
			lastname = identity['lastname'],
			dateofbirth = identity['dateofbirth'],
			sex = identity['sex'],
			height = identity['height']
		}
	else
		return nil
	end
end

function sendDiscordLog(adsoyad, message, commandType)
    local playerName = adsoyad
    local command = ""
    if commandType == "me" then
        command = "(me)"
    elseif commandType == "do" then
        command = "(do)"
    else
        command = "(Unknown)"
    end

    local chatMessage = {
        {
            ["color"] = "16711680",
            ["title"] = "c4pkin - Me / Do Log :",
            ["description"] = "Oyuncu **" .. playerName .. "** bir komut kullandı: `" .. message .. "` " .. command,
            ["footer"] = {
                ["text"] = "c4pkinforever"
            },
            ["timestamp"] = os.date("!%Y-%m-%dT%H:%M:%SZ")
        }
    }

    PerformHttpRequest(discordWebhook, function(err, text, headers) end, 'POST', json.encode({embeds = chatMessage}), {['Content-Type'] = 'application/json'})
end

