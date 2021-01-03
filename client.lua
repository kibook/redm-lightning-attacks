local Enabled = false
local CooldownActive = false

RegisterNetEvent('lightning-attacks:toggle')
RegisterNetEvent('lightning-attacks:strike')

function ForceLightningFlashAtCoords(x, y, z, p3)
	return Citizen.InvokeNative(0x67943537D179597C, x, y, z, p3)
end

function LightningStrike(targetPos)
	TriggerServerEvent('lightning-attacks:strike', targetPos)
end

function Toggle()
	Enabled = not Enabled

	TriggerEvent('chat:addMessage', {
		color = {255, 255, 128},
		args = {'Lightning Attacks', Enabled and 'on' or 'off'}
	})
end

AddEventHandler('lightning-attacks:toggle', Toggle)

AddEventHandler('lightning-attacks:strike', function(targetPos, addExplosion)
	local ped = PlayerPedId()
	local pos = GetEntityCoords(ped)
	local distance = #(targetPos - pos)

	if distance <= Config.MaxDistance then
		ForceLightningFlashAtCoords(targetPos.x, targetPos.y, targetPos.z, -1.0)

		if AddExplosion then
			Wait(300)
			AddExplosion(targetPos.x, targetPos.y, targetPos.z, 25, 10000.0, true, false, 1.0)
		end

		CooldownActive = true
		SetTimeout(Config.Cooldown, function()
			CooldownActive = false
		end)
	end
end)

CreateThread(function()
	while true do
		Wait(0)

		if Enabled then
			if CooldownActive then
				DisablePlayerFiring(PlayerId(), true)
			else
				local firedWeapon, impactCoords = GetPedLastWeaponImpactCoord(PlayerPedId())

				if firedWeapon then
					LightningStrike(impactCoords)
				end
			end
		end
	end
end)
