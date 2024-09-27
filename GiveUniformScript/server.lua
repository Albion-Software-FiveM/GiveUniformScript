-- KA1N3D Software - Server-Side Uniform Transfer Handling

RegisterNetEvent("ka1n3dSoftware:sendUniform")
AddEventHandler("ka1n3dSoftware:sendUniform", function(playerId, clothingData)
    TriggerClientEvent("ka1n3dSoftware:receiveUniform", playerId, source, clothingData)
end)
