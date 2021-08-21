ESX = nil
local Licenses  = {}
--Make peds face playerped
Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
	ESX.Game.MakeEntityFaceEntity = function(entity1, entity2)
		local p1 = GetEntityCoords(entity1, true)
		local p2 = GetEntityCoords(entity2, true)
	
		local dx = p2.x - p1.x
		local dy = p2.y - p1.y
	
		local heading = GetHeadingFromVector_2d(dx, dy)
		SetEntityHeading( entity1, heading )
	end
end)


--Add as many sellpoints as you wish
local shopnpc = {
    {x =-1845.49, y = -1196.50, z = 18.18},
    --{x =-1845.49, y = -1196.50, z = 18.18},
    --{x =-1845.49, y = -1196.50, z = 18.18}
}

--Function to spawn shopnpc
function spawnshopnpc()
	Citizen.CreateThread(function()
		local sleep = 1000
		local ped = GetHashKey("s_m_m_linecook")
		RequestModel(ped)
		while not HasModelLoaded(ped) do 
			Citizen.Wait(1)
		end
		for k,v in pairs(shopnpc) do
			shop = CreatePed(4, ped, v.x, v.y, v.z, 78.20, false, true)
			local npc = GetEntityCoords(shop)
			local playerped = GetEntityCoords(PlayerPedId())
			local dist = #(npc - playerped)
			SetEntityInvincible(shop, true)
			PlaceObjectOnGroundProperly(shop)
			TaskSetBlockingOfNonTemporaryEvents(shop, true)
			Citizen.Wait(1000)
			FreezeEntityPosition(shop, true)
			while true do
				Citizen.Wait(50)
				playerped = GetEntityCoords(PlayerPedId())
				dist = #(npc - playerped)
				if dist < 5 then
					ESX.Game.MakeEntityFaceEntity(shop, PlayerPedId())
				else
					Citizen.Wait(sleep)
				end
			end
		end
	end)
end

--Shop purchase
function fishshop()
    local ownedLicenses = {}
	for i=1, #Licenses, 1 do
		ownedLicenses[Licenses[i].type] = true
	end
	ESX.UI.Menu.CloseAll()
	FreezeEntityPosition(PlayerPedId(),true)
	local elements = {}
	table.insert(elements, {label = 'Purchase fishing rod - <span style="color:green;">200$</span>', value = 'buyrod'})
	if Config.licenses then
		if not ownedLicenses['fishing'] then
			table.insert(elements, {label = 'Purchase Fishing Permit - <span style="color:green;">250$</span>', value = 'buylice'})
		else
			table.insert(elements, {label = 'You already own <span style="color:lightblue;">Fishing permits</span>', value = 'exit'})
		end
	end
	table.insert(elements, {label = 'Exit', value = 'exit'})
    ESX.UI.Menu.Open(
        'default', GetCurrentResourceName(), 'fishingshop',
    {
        title = 'Fish shop',
        align = 'center',
		elements = elements
    },
   function(data, menu)
        if data.current.value == 'buyrod' then
			TriggerServerEvent("s_fishing:buyrod")
		elseif data.current.value == 'buylice' then
			ESX.TriggerServerCallback('s_fishing:buyLicense', function(bought)
				if bought then
					menu.close()
				end
			end)	
		elseif data.current.value == 'exit' then
			ESX.UI.Menu.CloseAll()
        end
		FreezeEntityPosition(PlayerPedId(),false)
        ESX.UI.Menu.CloseAll()
    end)
end

--Shop sell 
function shopsell()
	ESX.UI.Menu.CloseAll()
	FreezeEntityPosition(PlayerPedId(),true)
    ESX.UI.Menu.Open(
        'default', GetCurrentResourceName(), 'fshop',
    {
        title = 'Fish market',
        align = 'center',
        elements = {
            {label = 'Sell fish', value = 'sell'},
			{label = 'Exit', value = 'exit'},
        },
    },
   function(data, menu)
        if data.current.value == 'sell' then
			TriggerServerEvent("s_fishing:sell", source)
			ESX.UI.Menu.CloseAll()
		elseif data.current.value == 'exit' then
			ESX.UI.Menu.CloseAll()
		end
		FreezeEntityPosition(PlayerPedId(),false)
        ESX.UI.Menu.CloseAll()
    end)
end

--Store stuff 
Citizen.CreateThread(function()
	while true do
	Citizen.Wait(5)
	local playerped = GetEntityCoords(PlayerPedId())
	local dist = #(vector3(-1845.49, -1196.50, 19.18) - playerped)
	local ClockTime = GetClockHours()
	local x,y,z = -1845.49, -1196.50, 19.18
	local w = 1000
        if dist < 5 then
            Draw3DText2(x, y, z + 0.5, "[~r~E~w~] Open shop | [~g~G~w~] Sell your fishes")
            if IsControlJustReleased(0, 38) then 
                if ClockTime >= 6 -1 and ClockTime < 22 then
                    fishshop()
                else
                    TriggerEvent('mythic_notify:client:slerba', { type = 'error', length = 7000, text = 'Shop is currently unavailable' })
                end
            elseif IsControlJustPressed(0, 47) then
                shopsell()
            end
        else
            Citizen.Wait(w)
        end
	end
end)

--License stuff from copied from esx_dmvschool 
RegisterNetEvent('s_fishing:loadLicenses')
AddEventHandler('s_fishing:loadLicenses', function(licenses)
	Licenses = licenses
end)

--Blip and npc stuff
Citizen.CreateThread(function()
	spawnshopnpc()
    sellblip = AddBlipForCoord(-1845.49, -1196.50, 19.18)
	SetBlipSprite(sellblip, 356)
	SetBlipColour(sellblip, 83)
	SetBlipScale(sellblip, 0.8)
	SetBlipAsShortRange(sellblip, true)
	BeginTextCommandSetBlipName('STRING')
	AddTextComponentString('Fish market') -- set blip's "name"
	EndTextCommandSetBlipName(sellblip)
end)

--3D text stuff
function Draw3DText2(x,y,z, text)
    local onScreen,_x,_y=World3dToScreen2d(x,y,z)
    local px,py,pz=table.unpack(GetGameplayCamCoords())
    
    SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(text)
    DrawText(_x,_y)
    local factor = (string.len(text)) / 370
    DrawRect(_x,_y+0.0125, 0.015+ factor, 0.03, 0, 0, 0, 68)
end