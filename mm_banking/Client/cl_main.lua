ESX = exports["es_extended"]:getSharedObject()
ox_target = exports["ox_target"]

local Username
local CashValue

local isBankOpen = false

RegisterNetEvent("mm:notification", function (Message)
    Notification(Message)
end)

RegisterNuiCallback("errorint", function (data, cb)
    Notification("Raha määrä täytyy olla joku numero!")
end)

RegisterNuiCallback("withdrawClient", function (data, cb)
    local MoneyValue = tonumber(data.Value)

    if MoneyValue == nil or type(MoneyValue) ~= "number" then
        return
    end

    TriggerServerEvent("mm:bankwithdraw", MoneyValue)
end)

RegisterNuiCallback("depositClient", function (data, cb)
    local MoneyValue = tonumber(data.Value)

    if MoneyValue == nil or type(MoneyValue) ~= "number" then
        return
    end

    TriggerServerEvent("mm:bankdeposit", MoneyValue)
end)

RegisterNuiCallback("accountTransferClient", function (data, cb)
    local TargetId = tonumber(data.TargetID)
    local Value = tonumber(data.Value)
    
    if GetPlayerServerId(PlayerId()) == TargetId then
        Notification("Et voi tehdä itsellesi tilisiirtoa!")
        return
    end

    if TargetId == nil then
        Notification("Id on virheelinen!")
        return
    end

    if Value == nil then
        Notification("Raha määrä täytyy olla enemmän kun 0!")
        return
    end

    TriggerServerEvent("mm:accounttransfer", TargetId, Value)
end)

RegisterNuiCallback("requestStats", function (data, cb)
    TriggerServerEvent("mm:requestBankInfo")
    SendNUIMessage({
        action = "updatestats",
        name = Username,
        currency = CashValue
    })
end)

RegisterNuiCallback("logout", function ()
    OpenBankUi(1)
end)

RegisterNetEvent("mm:RetriveStats", function (name, value)
    Username = name
    CashValue = value
end)

function Notification(Message, Type, IconColor)
    if string.lower(Config["Notification"]) == "esx" then
        ESX.ShowNotification(Message, Type)
    elseif string.lower(Config["Notification"]) == "ox" then
        lib.notify({
            title=Message,
            icon=Type,
            iconColor=IconColor
        })
    elseif string.lower(Config["Notification"]) == "okok" then
        okok_notify:Alert(Message, nil, 1500, Type)
    elseif string.lower(Config["Notification"]) == "custom" then
        --Config["CustomNotify"](Message, Type, IconColor)
    else
        ESX.ShowNotification(Message, Type)
    end
end

function OpenBankUi(menu)
    if not isBankOpen then
        isBankOpen = true
        SendNUIMessage({
            action = "openbank",
            message = menu
        })
    else
        isBankOpen = false
        SendNUIMessage({
            action = "closebank",
            message = nil
        })
    end

    SetNuiFocus(isBankOpen, isBankOpen)

    TriggerServerEvent("mm:requestBankInfo")

    SendNUIMessage({
        action = "updatestats",
        name = Username,
        currency = CashValue
    })
end

function Thread()
    while true do
        if isBankOpen then
            DisableControlAction(0, 1, isBankOpen)  -- LookLeftRight
            DisableControlAction(0, 2, isBankOpen)  -- LookUpDown
            DisableControlAction(0, 24, isBankOpen) -- Attack
            DisableControlAction(0, 25, isBankOpen) -- Aim
            DisableControlAction(0, 30, isBankOpen) -- MoveLeftRight
            DisableControlAction(0, 31, isBankOpen) -- MoveUpDown
            DisableControlAction(0, 37, isBankOpen) -- SelectWeapon
            DisableControlAction(0, 44, isBankOpen) -- Cover
            DisableControlAction(0, 140, isBankOpen) -- MeleeAttackAlternate
            DisableControlAction(0, 141, isBankOpen) -- MeleeAttackHeavy
            DisableControlAction(0, 142, isBankOpen) -- MeleeAttackAlternate
            DisableControlAction(0, 143, isBankOpen) -- MeleeAttackHeavy
            DisableControlAction(0, 257, isBankOpen) -- Attack2
            DisableControlAction(0, 263, isBankOpen) -- MeleeAttack1
            DisableControlAction(0, 264, isBankOpen) -- MeleeAttack2
            DisableControlAction(0, 268, isBankOpen) -- MeleeAttack1
            DisableControlAction(0, 269, isBankOpen) -- MeleeAttack2
            DisableControlAction(0, 270, isBankOpen) -- MeleeAttack3
            DisableControlAction(0, 271, isBankOpen) -- MeleeAttack4
        end

        if IsControlPressed(0, 202) and isBankOpen then
            OpenMenu(1)
        end

        Citizen.Wait(0)
    end
end

RegisterNetEvent("esx:playerLoaded", function ()
    TriggerServerEvent("mm:requestBankInfo")

    SendNUIMessage({
        action = "updatestats",
        name = Username,
        currency = CashValue
    })
end)

ox_target:addModel({"prop_atm_03", "prop_atm_02", "prop_atm_01", "prop_fleeca_atm"}, {
    label = "Pankki",
    name = "mm:bank",
    icon="fa-solid fa-building-columns",
    distance = 1,
    onSelect = function ()
        OpenBankUi(1)
    end
})

ox_target:addBoxZone({
    coords = vector3(149.9446, -1040.8528, 29.3741),
    size = vector3(5, 5, 5),
    options = {
        {
            label = "Pankki",
            name = "mm:bank",
            icon = "fa-solid fa-building-columns",
            distance = 1.5, -- Adjusted distance for better interaction
            onSelect = function()
                OpenBankUi(1)
            end
        }
    }
})

Citizen.CreateThread(Thread)