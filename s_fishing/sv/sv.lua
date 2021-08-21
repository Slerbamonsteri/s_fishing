ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

ESX.RegisterUsableItem('rod', function(source)
	TriggerClientEvent('s_fishing:start', source)
end)

AddEventHandler('esx:playerLoaded', function(source)
    print('playerloaded')
	TriggerEvent('pkrp_license:getLicenses', source, function(licenses)
		TriggerClientEvent('s_fishing:loadLicenses', source, licenses)
	end)
end)


--Fishing stuff
RegisterServerEvent('s_fishing:caught')
AddEventHandler('s_fishing:caught', function()
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    local RBrackets = math.random(1, #Config.fishes)
    local name = GetPlayerName(source)
    if xPlayer ~=nil then 
        for k,v in pairs(Config.fishes[RBrackets]) do 
            if v.type == 'item' then
                xPlayer.addInventoryItem(v.itemName, v.howmany)
                sendToDiscord(66666, "Fishing", name .. " Caught: " ..v.itemName.. 'x ' ..v.howmany..'.', "s_fishingLOG")
            elseif v.type == 'weapon' then
                for i=1, v.howmany, 1 do
                    xPlayer.addWeapon(v.itemName, v.ammo)
                    sendToDiscord(66666, "Fishing", name .. " Caught: " ..v.itemName.. 'x ' ..v.ammo..'.', "s_fishingLOG")
                end
            elseif v.type == 'money' then
                xPlayer.addMoney(v.howmany)
                sendToDiscord(66666, "Fishing", name .. " Caught some money: "..v.howmany..'.', "s_fishingLOG")
            end
        end
    end
end)

--Selling stuff
RegisterServerEvent('s_fishing:sell')
AddEventHandler('s_fishing:sell', function()
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    local name = GetPlayerName(_source)
    for q,p in pairs(Config.sellitemprices) do 
        local item = xPlayer.getInventoryItem(q)
        if item.count >= 1 then
            xPlayer.addMoney(item.count * p)
            xPlayer.removeInventoryItem(q, item.count)
            xPlayer.showNotification('Sold fish ~b~' ..item.label..  '~s~ for ~g~'..item.count * p ..'$')
            sendToDiscord2(56222, 'Fish market', '**'..name.. '** | **Sold:** [*' ..item.label.. '*]** for:** [' ..item.count * p.. '$]', 's_fishingLOG')
        end
    end
end)

--Purcahse fishing rod
RegisterServerEvent("s_fishing:buyrod")
AddEventHandler("s_fishing:buyrod", function()
local xPlayer = ESX.GetPlayerFromId(source)
	if xPlayer.getAccount('bank').money >= 200 then
		xPlayer.removeAccountMoney('bank', 200)
		xPlayer.addInventoryItem('rod', 1)
	else
		xPlayer.showNotification('Not enough money (200$)')
	end
end)

--License stuff
ESX.RegisterServerCallback('s_fishing:buyLicense', function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)

	if xPlayer.getAccount('bank').money >= 250 then
		xPlayer.removeAccountMoney('bank', 250)

		TriggerEvent('pkrp_license:addLicense', source, 'fishing', function()
		xPlayer.showNotification('You now own fishing permits')
			cb(true)
		end)
	else
		xPlayer.showNotification('Not enough money')
		cb(false)
	end
end)

function sendToDiscord(color, name, message, footer)
  local embed = {
        {
            ["color"] = color,
            ["title"] = "**".. name .."**",
            ["description"] = message,
            ["footer"] = {
                ["text"] = footer,
            },
        }
    }
  PerformHttpRequest(Config.fishwebhook, function(err, text, headers) end, 'POST', json.encode({username = name, embeds = embed}), { ['Content-Type'] = 'application/json' })
end

function sendToDiscord2(color, name, message, footer)
    local embed = {
          {
              ["color"] = color,
              ["title"] = "**".. name .."**",
              ["description"] = message,
              ["footer"] = {
                  ["text"] = footer,
              },
          }
      }
    PerformHttpRequest(Config.sellwebhook, function(err, text, headers) end, 'POST', json.encode({username = name, embeds = embed}), { ['Content-Type'] = 'application/json' })
end

