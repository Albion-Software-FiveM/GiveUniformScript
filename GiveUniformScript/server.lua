-- server.lua

-- Store EUP data for players temporarily
local eupDataStore = {}

-- Registering the /giveuniform command
RegisterCommand('giveuniform', function(source, args)
    local targetPlayerId = tonumber(args[1])

    -- Check if the target player ID is valid
    if targetPlayerId and GetPlayerName(targetPlayerId) then
        -- Get the source player's EUP components
        local sourcePlayer = GetPlayerPed(source)
        local eupComponents = getPlayerEUPComponents(sourcePlayer)

        -- Trigger client event for target player to accept uniform
        TriggerClientEvent('ka1n3d:promptAcceptUniform', targetPlayerId, source, eupComponents)
        TriggerClientEvent('chat:addMessage', source, {
            color = {255, 0, 0},
            multiline = true,
            args = {"System", "You have sent a uniform request to Player ID: " .. targetPlayerId}
        })

        -- Store the uniform in the server so it can be accepted
        eupDataStore[targetPlayerId] = eupComponents
    else
        TriggerClientEvent('chat:addMessage', source, {
            color = {255, 0, 0},
            multiline = true,
            args = {"System", "Invalid Player ID."}
        })
    end
end)

-- Function to get a player's EUP components
function getPlayerEUPComponents(player)
    local eupComponents = {}

    eupComponents[1] = GetPedDrawableVariation(player, 1) -- Mask
    eupComponents[3] = GetPedDrawableVariation(player, 3) -- Torso
    eupComponents[4] = GetPedDrawableVariation(player, 4) -- Legs
    eupComponents[6] = GetPedDrawableVariation(player, 6) -- Shoes
    eupComponents[8] = GetPedDrawableVariation(player, 8) -- Undershirt
    eupComponents[11] = GetPedDrawableVariation(player, 11) -- Top
    eupComponents[9] = GetPedDrawableVariation(player, 9) -- Kevlar Vest
    eupComponents[10] = GetPedDrawableVariation(player, 10) -- Decal

    return eupComponents
end

-- Notify both players when the uniform has been accepted
RegisterNetEvent('ka1n3d:notifyUniformAccepted')
AddEventHandler('ka1n3d:notifyUniformAccepted', function(requestingPlayerId)
    local receiverId = source
    if eupDataStore[receiverId] then
        eupDataStore[receiverId] = nil
        TriggerClientEvent('chat:addMessage', requestingPlayerId, {
            color = {0, 255, 0},
            multiline = true,
            args = {"System", "Player ID: " .. receiverId .. " has accepted the uniform."}
        })
    end
end)

