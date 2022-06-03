ESX = nil

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(200)
        EYES.Functions.CreateBlips()
    end
end)

local display = false

RegisterNUICallback("exit", function(data)
    SetDisplay(false)
end)

function SetDisplay(bool)
    display = bool
    SetNuiFocus(bool, bool)
    SendNUIMessage({
        type = "ui",
        status = bool,
    })
end

RegisterNUICallback('transfer', function(data, cb)
    local source = GetPlayerServerId(PlayerId())
    TriggerServerEvent('bank:transfer', tonumber(data.player),tonumber(data.amount),tonumber(source))
    cb('ok')
  end)

  RegisterNUICallback('withdraw', function(data, cb)
	TriggerServerEvent('bank:withdraw', tonumber(data.value))
    cb('ok')
end)


RegisterNUICallback('deposit', function(data)
	TriggerServerEvent('bank:deposit', tonumber(data.deposit))
end)

RegisterNetEvent("nui:info")
AddEventHandler("nui:info",function(a,b)
    SendNUIMessage({
        type = "info",
        player = a,
        cash = b,
        cardsilver = Config.Card["Silver Card"],
        cardgold = Config.Card["Gold Card"],
        carddiamond = Config.Card["Diamond Card"]
    })
end)

RegisterNetEvent("nui:billing")
AddEventHandler("nui:billing",function(label,amount)
    print(label,amount)
    SendNUIMessage({
        type = "info"
    })
end)

RegisterNetEvent("transfer:info")
AddEventHandler("transfer:info",function(a,sex) 
    SendNUIMessage({
        type = "transfer",
        target = a,
        targetid = sex,
    })
end)

RegisterNetEvent("avatar")
AddEventHandler("avatar",function(img) 
    SendNUIMessage({
        type = "info",
        avatar = img
    })
end)

RegisterNUICallback('Billing:Sorgu', function(data, cb)
    ESX.TriggerServerCallback("Billing:Sorgu", function(result)
        cb(result)
    end)
end)

RegisterNUICallback('Billing:SaveInvoice', function(data,cb)
    ESX.TriggerServerCallback("SaveInvoice",function(result)
        if result then
            cb(true)
        else
            cb(false)
        end
    end, data)
end)

Citizen.CreateThread(function()
    while true do 
        Citizen.Wait(2000)
        ESX.TriggerServerCallback("bank:info",function(result)
            SendNUIMessage({
                type = "info",
                player = a,
                cash = b
            })
      end)
    end
end)

Citizen.CreateThread(function()
    while true do 
        Citizen.Wait(0)
        local getPed = PlayerPedId()
        local entity = GetEntityCoords(getPed)
        for key,value in pairs(Config.Locations) do
            local dist = #(entity - value)
            if dist < 10 then
                if dist < 3 then
                    DrawText3D(value.x, value.y, value.z + 0.2, '[E] Bank')
                    if IsControlJustPressed(0,38) then
                        SetDisplay(true)
                            ESX.TriggerServerCallback("bank:info",function(result)
                                cb(result)
                            end)
                        end
                    break
                  else 
                end
            end
        end
    end
end)

  DrawText3D = function(x, y, z, text)
    SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(true)
    AddTextComponentString(text)
    SetDrawOrigin(x,y,z, 0)
    DrawText(0.0, 0.0)
    local factor = (string.len(text)) / 370
    DrawRect(0.0, 0.0+0.0125, 0.017+ factor, 0.03, 0, 0, 0, 75)
    ClearDrawOrigin()
end