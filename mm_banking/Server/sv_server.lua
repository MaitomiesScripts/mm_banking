ESX = exports["es_extended"]:getSharedObject()

RegisterNetEvent("mm:bankwithdraw", function(Value)
    local xPlayer = ESX.GetPlayerFromId(source)

    if xPlayer.getAccount("bank").money >= Value then
        xPlayer.removeAccountMoney("bank", Value)
        xPlayer.addMoney(Value)
        TriggerClientEvent("mm:notification", source, "Nostit "..tostring(Value).."€ pankista.")
    else
        TriggerClientEvent("mm:notification", source, "Sinulla ei ole näin paljoa rahaa pankissa!")
    end
end)

RegisterNetEvent("mm:bankdeposit", function(Value)
    local xPlayer = ESX.GetPlayerFromId(source)

    if xPlayer.getMoney() >= Value then
        xPlayer.addAccountMoney("bank", Value)
        xPlayer.removeMoney(Value)
        TriggerClientEvent("mm:notification", source, "Talletit "..tostring(Value).."€ pankkiin.")
    else
        TriggerClientEvent("mm:notification", source, "Sinulla ei ole näin paljoa käteistä!")
    end
end)


RegisterNetEvent("mm:accounttransfer", function (TargetID, Value)
    local xPlayer = ESX.GetPlayerFromId(source)
    local xTarget

    if DoesEntityExist(GetPlayerPed(TargetID)) then
        xTarget = ESX.GetPlayerFromId(TargetID)
    else
        TriggerClientEvent("mm:notification", source, "Kyseistä pelajaa ei löydy serveriltä!")
        return
    end

    if xPlayer.getAccount("bank").money >= Value then
        xPlayer.removeAccountMoney("bank", Value)
        xTarget.addAccountMoney("bank", Value)
    end

    TriggerClientEvent("mm:notification", source, "Teit onnistuneen tilisiiron!")
    TriggerClientEvent("mm:notification", TargetID, "Sinulle tehtiin tilisiirto!")
end)


RegisterNetEvent("mm:requestBankInfo", function ()
    local xPlayer = ESX.GetPlayerFromId(source)

    TriggerClientEvent("mm:RetriveStats", source, xPlayer.getName(), tostring(xPlayer.getAccount("bank").money))
end)