ESX = nil

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)

--Some code i found in vrP_fishing
function AttachEntityToPed(prop,bone_ID,x,y,z,RotX,RotY,RotZ)
	BoneID = GetPedBoneIndex(PlayerPedId(), bone_ID)
	obj = CreateObject(GetHashKey(prop),  1729.73,  6403.90,  34.56,  true,  true,  true)
	vX,vY,vZ = table.unpack(GetEntityCoords(PlayerPedId()))
	xRot, yRot, zRot = table.unpack(GetEntityRotation(PlayerPedId(),2))
	AttachEntityToEntity(obj,  PlayerPedId(),  BoneID, x,y,z, RotX,RotY,RotZ,  false, false, false, false, 2, true)
	return obj
end

local draw = false
local rng22 = false

--starting up
RegisterNetEvent('s_fishing:start')
AddEventHandler('s_fishing:start', function()
    local pedc = GetEntityCoords(PlayerPedId())
    local boat = GetClosestVehicle(pedc.x, pedc.y, pedc.z, 5.0, 0, 12294)
    if IsEntityInWater(PlayerPedId()) or IsEntityInWater(boat) then
        if not IsPedInAnyVehicle(PlayerPedId(), false) then
            if not IsPedSwimming(PlayerPedId()) then
                ESX.UI.Menu.CloseAll()
                draw = true
                rng22 = true
                ESX.ShowNotification('Fishing...')
                TriggerEvent('s_fishing:rng')
                fishing()
            else
                ESX.ShowNotification('You have to decide, whether you want to swim or fish')
            end
        else
            ESX.ShowNotification('Why the fuck do you try to fish in vehicle')
        end
    else
        ESX.ShowNotification('I can´t fish here...')
    end
end)

--Anim & Prop & Triggering them fishy fishes
function fishing()
    RequestAnimDict('amb@world_human_stand_fishing@idle_a') 
        while not HasAnimDictLoaded('amb@world_human_stand_fishing@idle_a') do 
            Citizen.Wait(1) 
        end
    rod = AttachEntityToPed('prop_fishing_rod_01',60309, 0,0,0, 0,0,0)
    TaskPlayAnim(PlayerPedId(), 'amb@world_human_stand_fishing@idle_a', 'idle_b', 8.0, 8.0, -1, 1, 1, 0, 0, 0)
    drawtext()
end

--Drawing function, added as an extra spice inventory disabling.. Just to make sure players wont fuck anything up or exploit anything
function drawtext()
    local pedcoords = GetEntityCoords(PlayerPedId())
    while draw do
        w = 5
        DisableControlAction(0, 288, true) -- F1
        DisableControlAction(0, 289, true) -- F2
        Draw3DText(pedcoords.x - 1, pedcoords.y, pedcoords.z + 1,'Press [~r~X~s~] to stop fishing')
        if IsControlJustPressed(0, 73) then
            ESX.ShowNotification('Stopped fishing')
            DeleteEntity(rod)
            DeleteObject(rod)
            rng22 = false
            TriggerEvent('s_fishing:rng')
            cancel()
            ClearPedTasks(PlayerPedId())
            break
        end
        Citizen.Wait(w)
    end
    while not draw do
        break
    end
end

AddEventHandler('s_fishing:rng', function()
    while rng22 do
        Wait(math.random(13000, 32000))
        catchfish()
        ClearPedTasks(PlayerPedId())
        DeleteObject(rod)
        DeleteEntity(rod)
        break
    end
    while not rng22 do
        catchfish()
        break
    end
end)

function catchfish()
    if rng22 then
        TriggerEvent('s_fishing:minigame', function(success)
            if success then
                TriggerServerEvent('s_fishing:caught')
                cancel()
                Citizen.Wait(10)
                TriggerEvent('s_fishing:start')
            else
                rng22 = false
                cancel()
                ClearPedTasks(PlayerPedId())
                TriggerEvent('s_fishing:rng')
                ESX.ShowNotification("You didn't catch anything, try again")
            end
        end)
    end
end

function cancel()
    draw = false
    DeleteObject(rod)
    DeleteEntity(rod)
    drawtext()
    ClearPedTasks(PlayerPedId())
end

--Drawtext
function Draw3DText(x,y,z, text)
    local onScreen,_x,_y=World3dToScreen2d(x,y,z)
    local px,py,pz=table.unpack(GetGameplayCamCoords())
    
    SetTextScale(0.35, 0.35)
    SetTextFont(8)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(1)
    SetTextOutline()
    AddTextComponentString(text)
    DrawText(_x,_y)
end