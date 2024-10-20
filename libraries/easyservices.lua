local easyservices = {}

local clone = true
if not cloneref then
    clone = false
    print("Executor doesn't support cloneref.")
end

easyservices.register = function(_table)
    local initializedservices = {}
    for _,service in pairs(_table) do
        if not clone then initializedservices[service] = game:GetService(service)
        else initializedservices[service] = cloneref(game:GetService(service)) end
    end
    return initializedservices
end

return easyservices
