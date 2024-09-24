-- client.lua

local receivedUniforms = {}

-- Handle the accept uniform prompt
RegisterNetEvent('ka1n3d:promptAcceptUniform')
AddEventHandler('ka1n3d:promptAcceptUniform', function(sourcePlayerId, eupComponents)
    receivedUniforms[sourcePlayerId] = eupComponents
    TriggerEvent('chat:addMessage', {
        color = {255, 255, 0},
        multiline = true,
        args = {"System", "Player ID: " .. sourcePlayerId .. " wants to give you their uniform. Type /acceptuniform " .. sourcePlayerId .. " to accept."}
    })
end)

-- Function to apply EUP components to a player
function applyEUPToPlayer(player, eupComponents)
    for componentId, drawable in pairs(eupComponents) do
        SetPedComponentVariation(player, componentId, drawable, 0, 0)
    end
end

-- Registering the /acceptuniform command
RegisterCommand('acceptuniform', function(source, args)
    local requestingPlayerId = tonumber(args[1])
    if requestingPlayerId and receivedUniforms[requestingPlayerId] then
        local eupComponents = receivedUniforms[requestingPlayerId]
        applyEUPToPlayer(PlayerPedId(), eupComponents)

        -- Notify both players that the uniform was successfully applied
        TriggerServerEvent('ka1n3d:notifyUniformAccepted', requestingPlayerId)
        TriggerEvent('chat:addMessage', {
            color = {0, 255, 0},
            multiline = true,
            args = {"System", "You have accepted the uniform from Player ID: " .. requestingPlayerId}
        })

        receivedUniforms[requestingPlayerId] = nil
    else
        TriggerEvent('chat:addMessage', {
            color = {255, 0, 0},
            multiline = true,
            args = {"System", "No uniform request found from Player ID: " .. (requestingPlayerId or "unknown")}
        })
    end
end)

