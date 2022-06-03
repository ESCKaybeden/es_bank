ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)


RegisterServerEvent('bank:transfer')
AddEventHandler('bank:transfer', function(target, amount, source)
  local xPlayer = ESX.GetPlayerFromId(source)
  local zPlayer = ESX.GetPlayerFromId(target)
 if(zPlayer == nil or zPlayer == -1) then
    TriggerClientEvent("esx:showNotification", xPlayer.source,"The person you want to send is not in the game! IBAN:"..target.."")
     return
 else
  if xPlayer.getAccount('bank').money >= tonumber(amount) then 
    zPlayer.addAccountMoney('bank', tonumber(amount))
    xPlayer.removeAccountMoney('bank', tonumber(amount))
    sendToDiscord(source,"> **Player:**"..GetPlayerName(source),"\n> The transfer made.\n> Transfer Amount:```"..amount.."```\n > Transfer id:```"..target.."```\n\n > ID:"..source.."")
    TriggerClientEvent("esx:showNotification", xPlayer.source,"The transfer was successful IBAN:"..target.."")
    TriggerClientEvent("transfer:info",source,GetPlayerName(target),target)
    else
    TriggerClientEvent("esx:showNotification", xPlayer.source,"There is not enough money in your account!")
    end
    end 
end)

RegisterServerEvent('bank:deposit')
AddEventHandler('bank:deposit', function(amount)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
    print(xPlayer.getAccount('bank').money)
	if amount == nil or amount <= 0 or amount > xPlayer.getMoney() then
        TriggerClientEvent("esx:showNotification",_source,"You do not have enough money on it or you did not enter an amount.")
	else
		xPlayer.removeMoney(amount)
		xPlayer.addAccountMoney('bank', tonumber(amount))
    sendToDiscord(source,"> **Player:**"..GetPlayerName(source),"\n> She deposited money in the bank.\n> Deposit Amount:```"..amount.."```\n\n > ID:"..source.."")
        TriggerClientEvent("esx:showNotification",_source,"You have withdrawn money from your account:"..tonumber(amount))
	end
end)

RegisterServerEvent('bank:withdraw')
AddEventHandler('bank:withdraw', function(amount)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local base = 0
	amount = tonumber(amount)
	base = xPlayer.getAccount('bank').money
	if amount == nil or amount <= 0 or amount > base then
        TriggerClientEvent("esx:showNotification",_source,"You do not have enough money on it or you did not enter an amount.")
	else
		xPlayer.removeAccountMoney('bank', amount)
		xPlayer.addMoney(amount)
    sendToDiscord(source,"> **Player:**"..GetPlayerName(source),"\n> Withdrawn money from the bank.\n> Withdrawn Amount.```"..amount.."```\n\n > ID:"..source.."")
        TriggerClientEvent("esx:showNotification",_source,"You have withdrawn money from your account >"..tonumber(amount))
	end
end)


ESX.RegisterServerCallback("bank:info",function(source,cb,value)
    local src = source
    local player = ESX.GetPlayerFromId(src)
    info = player.getAccount('bank').money
    GetDiscordAvatar(source)
    TriggerClientEvent("nui:info",source,GetPlayerName(src),info)
  end)



function sendToDiscord(source,description,title,tumbnail)
  local xPlayer = ESX.GetPlayerFromId(source)
  local src = source
  local DISCORD_NAME = GetPlayerName(src)
  local steamid, license, xbl, playerip, discord, liveid = getidentifiers(src)
  local avatar = GetDiscordAvatar(source)
  local EYES_IMG =  Config.Discord["Bot Logo"]
  local embed = {{
  ["author"] = {
  ["name"] = "💳 EYES BANKING",
  ["url"] = "https://discord.gg/EkwWvFS"
  },
  ["thumbnail"] = {
  ["url"] = avatar
  },
  ["fields"] = {
  {
  ["name"] = title,
  ["value"] = description,
  ["inline"] = false,
  },
  {
  ["name"] = "🍂",
  ["value"] = "┌──── Extra Details: ────┐\n> "..steamid.."\n> "..license.."\n> "..playerip.."\n> "..liveid.."\n> "..discord.."",
  ["inline"] = true
  },
  },
  ['timestamp'] = os.date('!%Y-%m-%dT%H:%M:%SZ')
  }}
  Citizen.Wait(tonumber(1000))
  PerformHttpRequest(Config.Discord["Log"], function(err, text, headers) end, 'POST', json.encode({username = DISCORD_NAME, embeds  = embed, avatar_url = EYES_IMG}), { ['Content-Type'] = 'application/json' })
end


getidentifiers = function(player)
local steamid = "Not Linked"
local license = "Not Linked"
local discord = "Not Linked"
local xbl = "Not Linked"
local liveid = "Not Linked"
local ip = "Not Linked"

for k, v in pairs(GetPlayerIdentifiers(player)) do
if string.sub(v, 1, string.len("steam:")) == "steam:" then
steamid = v
elseif string.sub(v, 1, string.len("license:")) == "license:" then
license = v
elseif string.sub(v, 1, string.len("xbl:")) == "xbl:" then
xbl = v
elseif string.sub(v, 1, string.len("ip:")) == "ip:" then
ip = string.sub(v, 4)
elseif string.sub(v, 1, string.len("discord:")) == "discord:" then
discordid = string.sub(v, 9)
discord = "<@" .. discordid .. ">"
elseif string.sub(v, 1, string.len("live:")) == "live:" then
liveid = v
end
end

return steamid, license, xbl, ip, discord, liveid
end


ESX.RegisterServerCallback("Billing:Sorgu", function(source, cb)
    local player = ESX.GetPlayerFromId(source)
    local steamid = getidentifiers(source)
    exports.ghmattimysql:execute('SELECT * FROM billing WHERE identifier = @identifier', {
        ['identifier'] = steamid
    }, function(results)
        cb(results)
    end)
end)

ESX.RegisterServerCallback("SaveInvoice",function(source,cb, value)
  local src = source
  local xPlayer = ESX.GetPlayerFromId(src)
  exports.ghmattimysql:execute("SELECT * FROM billing WHERE id = "..value.data, function(result)
      if result[1] then
          if xPlayer.getAccount('bank').money >= result[1].amount then
            xPlayer.removeAccountMoney('bank', result[1].amount)
              exports.ghmattimysql:execute("DELETE FROM billing WHERE id = @id", {
                  ['@id'] = value.data
              }) 
              TriggerClientEvent("esx:showNotification",src,"You Pay the Bill. >"..result[1].label)
              cb(true)
          else
            TriggerClientEvent("esx:showNotification",src,"You couldn't pay the bill! >"..result[1].label)
              cb(false)
          end
      end
  end)
end)


    local Caches = {
        Avatars = {}
          }
          local FormattedToken = Config.Discord["Token"]
          function DiscordRequest(method, endpoint, jsondata)
        local data = nil
        PerformHttpRequest("https://discordapp.com/api/"..endpoint, function(errorCode, resultData, resultHeaders)
            data = {data=resultData, code=errorCode, headers=resultHeaders}
        end, method, #jsondata > 0 and json.encode(jsondata) or "", {["Content-Type"] = "application/json", ["Authorization"] = FormattedToken})
          
        while data == nil do
            Citizen.Wait(0)
        end
        
        return data
          end
          
        function GetDiscordAvatar(user) 
        local discordId = nil
        local imgURL = nil;
        for _, id in ipairs(GetPlayerIdentifiers(user)) do
            if string.match(id, "discord:") then
                discordId = string.gsub(id, "discord:", "")
                break
            end
        end
        if discordId then 
            if Caches.Avatars[discordId] == nil then 
                local endpoint = ("users/%s"):format(discordId)
                local member = DiscordRequest("GET", endpoint, {})
                print(endpoint)
                if member.code == 200 then
              local data = json.decode(member.data)
              if data ~= nil and data.avatar ~= nil then 
                  if (data.avatar:sub(1, 1) and data.avatar:sub(2, 2) == "_") then 
                imgURL = "https://cdn.discordapp.com/avatars/" .. discordId .. "/" .. data.avatar .. ".gif";
                  else 
                imgURL = "https://cdn.discordapp.com/avatars/" .. discordId .. "/" .. data.avatar .. ".png"
                  end
                  TriggerClientEvent("avatar",user,imgURL)
                end
                else 
              print("Plesa contact eyes customer's : https://discord.gg/EkwWvFS ")
                end
                Caches.Avatars[discordId] = imgURL;
            else 
                imgURL = Caches.Avatars[discordId];
            end 
        else 
            -- print("[EYES] ERROR: Discord ID was not found...")
        end
        return imgURL;
          end
          

          