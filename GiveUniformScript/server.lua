-- Server-side script to handle sending the uniform data
RegisterNetEvent("ka1n3dSoftware:sendUniform")
AddEventHandler("ka1n3dSoftware:sendUniform", function(targetPlayerId, uniformData)
    local sourcePlayer = source
    TriggerClientEvent("ka1n3dSoftware:receiveUniform", targetPlayerId, sourcePlayer, uniformData)
end)
