RegisterNetEvent('lightning-attacks:strike')

AddEventHandler('lightning-attacks:strike', function(targetPos)
	for _, player in ipairs(GetPlayers()) do
		if player == source then
			TriggerClientEvent('lightning-attacks:strike', player, targetPos, true)
		else
			TriggerClientEvent('lightning-attacks:strike', player, targetPos, false)
		end
	end
end)

RegisterCommand('lightningattacks', function(source, args, raw)
	TriggerClientEvent('lightning-attacks:toggle', source)
end, true)
