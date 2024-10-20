local signalmanager = {}
local storedsignals = {}

signalmanager.create = function(signal: RBXScriptSignal, callback)
    local connection = signal:Connect(callback)
    table.insert(storedsignals, connection)
    return connection
end
signalmanager.terminate = function()
    for _,v in next, storedsignals do v:Disconnect() end
end

return signalmanager
