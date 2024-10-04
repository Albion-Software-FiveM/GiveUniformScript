-- KA1N3D Software - Standalone Uniform Exchange Script

local pendingRequest = nil

-- Function to collect player outfit data
local function collectOutfitData(ped)
    local outfitData = {clothes = {}, props = {}}

    -- Collect clothing data (excluding some components)
    for compIndex = 1, 11 do
        if compIndex ~= 0 and compIndex ~= 2 then
            table.insert(outfitData.clothes, {
                component = compIndex,
                drawable = GetPedDrawableVariation(ped, compIndex),
                texture = GetPedTextureVariation(ped, compIndex)
            })
        end
    end

    -- Collect prop data (like hats and glasses)
    for propIndex = 0, 2 do
        table.insert(outfitData.props, {
            component = propIndex,
            drawable = GetPedPropIndex(ped, propIndex),
            texture = GetPedPropTextureIndex(ped, propIndex)
        })
    end

    return outfitData
end

-- Command to give outfit
RegisterCommand("giveuniform", function(source, args)
    if #args < 1 then
        TriggerEvent('chatMessage', "uniform", {255, 0, 0}, "Please specify a valid player ID.")
        return
    end

    local targetId = tonumber(args[1])
    if not targetId or GetPlayerName(targetId) == nil then
        TriggerEvent('chatMessage', "uniform", {255, 0, 0}, "Invalid player ID provided.")
        return
    end

    local playerName = GetPlayerName(targetId)
    local uniformData = collectOutfitData(PlayerPedId())

    -- Notify the player and send uniform data to the server
    TriggerEvent('chatMessage', "uniform", {0, 255, 0}, "You have sent your uniform to " .. playerName .. ".")
    TriggerServerEvent("ka1n3d:sendUniformData", targetId, uniformData)
end)

-- Event to receive uniform data
RegisterNetEvent("ka1n3d:receiveUniformData")
AddEventHandler("ka1n3d:receiveUniformData", function(senderId, uniformData)
    local senderName = GetPlayerName(senderId)

    -- Store pending request and notify the player
    pendingRequest = uniformData
    TriggerEvent('chatMessage', "uniform", {0, 255, 0}, senderName .. " has sent you a uniform. Use /acceptuniform or /denyuniform.")
end)

-- Command to reject a uniform request
RegisterCommand("denyuniform", function(source, args)
    if not pendingRequest then
        TriggerEvent('chatMessage', "uniform", {255, 0, 0}, "No uniform request to deny.")
        return
    end

    pendingRequest = nil
    TriggerEvent('chatMessage', "uniform", {255, 0, 0}, "You have rejected the uniform request.")
end)

-- Command to accept a uniform request
RegisterCommand("acceptuniform", function(source, args)
    if not pendingRequest then
        TriggerEvent('chatMessage', "uniform", {255, 0, 0}, "No uniform request to accept.")
        return
    end

    local ped = PlayerPedId()

    -- Apply the received uniform
    for _, item in pairs(pendingRequest.clothes) do
        SetPedComponentVariation(ped, item.component, item.drawable, item.texture, 0)
    end

    for _, item in pairs(pendingRequest.props) do
        SetPedPropIndex(ped, item.component, item.drawable, item.texture, true)
    end

    pendingRequest = nil
    TriggerEvent('chatMessage', "uniform", {0, 255, 0}, "You have accepted the uniform request.")
end)
