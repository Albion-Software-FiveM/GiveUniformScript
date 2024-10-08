-- KA1N3D Software - Standalone Uniform Exchange Script

local OutstandingRequest = nil

-- Command to Give Uniform
RegisterCommand("giveUniform", function(source, args, rawCommand)
    if #args < 1 then
        TriggerEvent('chatMessage', "Give Uniform", {226, 0, 57}, 'You must provide a player ID to send your uniform to.')
        print("[GiveUniform] No player was specified.")
        return
    end

    if tonumber(args[1]) == nil then
        TriggerEvent('chatMessage', "Give Uniform", {226, 0, 57}, 'You must provide a valid player ID.')
        print("[GiveUniform] Invalid player was specified.")
        return
    end

    local targetPlayerId = tonumber(args[1])
    local playerName = GetPlayerName(targetPlayerId) -- Changed from state.displayName

    if playerName == nil then
        TriggerEvent('chatMessage', "Give Uniform", {226, 0, 57}, 'The player you tried to give your uniform to does not exist.')
        print("[GiveUniform] Invalid player was specified.")
        return
    end

    local SentData = {
        Clothing = {},
        Props = {}
    }

    local ownPed = PlayerPedId()

    -- Gather Clothing Data
    for index = 0, 11 do
        if index ~= 0 and index ~= 2 then
            local drawable = GetPedDrawableVariation(ownPed, index)
            local texture = GetPedTextureVariation(ownPed, index)
            table.insert(SentData.Clothing, {
                component = index,
                drawable = drawable,
                texture = texture
            })
        end
    end

    -- Gather Prop Data (hats, glasses, etc.)
    for index = 0, 2 do
        local drawable = GetPedPropIndex(ownPed, index)
        local texture = GetPedPropTextureIndex(ownPed, index)
        table.insert(SentData.Props, {
            component = index,
            drawable = drawable,
            texture = texture
        })
    end

    -- Notify the sender
    TriggerEvent('chatMessage', "Give Uniform", {226, 0, 57}, 'You have sent ' .. playerName .. ' your uniform.')

    -- Send uniform to server
    TriggerServerEvent("ka1n3dSoftware:sendUniform", targetPlayerId, SentData)
end)

-- Event triggered when the uniform is sent
RegisterNetEvent("ka1n3dSoftware:receiveUniform")
AddEventHandler("ka1n3dSoftware:receiveUniform", function(fromPlayer, clothingData)
    OutstandingRequest = clothingData

    -- Notify the receiving player
    local senderName = GetPlayerName(tonumber(fromPlayer)) -- Changed from state.displayName
    TriggerEvent('chatMessage', "Give Uniform", {226, 0, 57}, senderName .. ' has sent you their uniform. Type /acceptUniform to accept or /denyUniform to reject.')
end)

-- Command to Deny Uniform
RegisterCommand("denyUniform", function(source, args, rawCommand)
    OutstandingRequest = nil

    -- Notify the player
    TriggerEvent('chatMessage', "Give Uniform", {226, 0, 57}, 'You have rejected the uniform request.')
end)

-- Command to Accept Uniform
RegisterCommand("acceptUniform", function(source, args, rawCommand)
    if OutstandingRequest == nil then
        TriggerEvent('chatMessage', "Give Uniform", {226, 0, 57}, 'There is no uniform request to accept.')
        return
    end

    local ownPed = PlayerPedId()

    -- Apply the received uniform
    for _, data in pairs(OutstandingRequest.Clothing) do
        SetPedComponentVariation(ownPed, data.component, data.drawable, data.texture, 0)
    end

    for _, data in pairs(OutstandingRequest.Props) do
        SetPedPropIndex(ownPed, data.component, data.drawable, data.texture, 0)
    end

    -- Clear the request and notify the player
    OutstandingRequest = nil
    TriggerEvent('chatMessage', "Give Uniform", {226, 0, 57}, 'You have accepted the uniform request.')
end)
