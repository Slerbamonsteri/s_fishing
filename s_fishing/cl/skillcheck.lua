
--skillcheck stuff

local display = false
local notComplete = false
local failure = false
local Callback = {}


RegisterNUICallback("exit", function(data)
    chat("Failed!", {0,255,0})
    SetDisplay(false)
end)


RegisterNUICallback("error", function(data)
    if data.error == 'Complete!' then
        SetDisplay(false)
        notComplete = false
    else
        SetDisplay(false)
        notComplete = false 
        failure = true
    end
end)

function SetDisplay(bool)
    SetNuiFocus(bool, false)
    SendNUIMessage({
        type = "ui",
        status = bool,
    })
end

RegisterNetEvent('s_fishing:minigame')
AddEventHandler('s_fishing:minigame', function(func)
    Callback = func
    SetDisplay(not display)
    notComplete = true
    failure = false
    while notComplete do
        Citizen.Wait(100)
    end
    if failure then
        Callback(false)
    else
        Callback(true)
    end 
end)

Citizen.CreateThread(function()
    while display do
        Citizen.Wait(0)
        -- https://runtime.fivem.net/doc/natives/#_0xFE99B66D079CF6BC
        --[[ 
            inputGroup -- integer , 
	        control --integer , 
            disable -- boolean 
        ]]
        DisableControlAction(0, 1, display) -- LookLeftRight
        DisableControlAction(0, 2, display) -- LookUpDown
        DisableControlAction(0, 142, display) -- MeleeAttackAlternate
        DisableControlAction(0, 18, display) -- Enter
        DisableControlAction(0, 322, display) -- ESC
        DisableControlAction(0, 106, display) -- VehicleMouseControlOverride
    end
end)

function chat(str, color)
    TriggerEvent(
        'chat:addMessage',
        {
            color = color,
            multiline = true,
            args = {str}
        }
    )
end