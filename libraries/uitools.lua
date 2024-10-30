local uitools = {}

local UserInputService = cloneref(game:GetService("UserInputService")) or game:GetService("UserInputService")
local TweenService = cloneref(game:GetService("TweenService")) or game:GetService("TweenService")
-- Helper function to add connections

local connections, objects
function uitools.configure(extconnections, extobjects)
    connections, objects = extconnections, extobjects
end

local function addConnection(connection)  table.insert(connections, connection) return connection end

function uitools.create(Class: Instance, Properties: PhysicalProperties)
    local _Instance = type(Class) == 'string' and Instance.new(Class) or Class
    for Property, Value in next, Properties do
        _Instance[Property] = Value
    end
    table.insert(objects, _Instance)
    return _Instance
end

function uitools.addInstances(instances: { {Class: string, Properties: PhysicalProperties} })
    for _, instanceData in ipairs(instances) do
        local className = instanceData.Class
        local properties = instanceData.Properties or {}
        uitools.create(className, properties)
    end
end

function uitools.tween(object, goal, callback)
    local tween = TweenService:Create(object, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.In), goal)
    addConnection(tween.Completed:Connect(callback or function() end))
    tween:Play()
end

function uitools.mouseEvents(GUIOBJECT: Instance, onEnter, onLeave, onClick, clickignore: boolean)
    addConnection(GUIOBJECT.MouseEnter:Connect(function()
        if onEnter then onEnter() end
        
        local input
        input = addConnection(UserInputService.InputBegan:Connect(function(userInput)
            if userInput.UserInputType == Enum.UserInputType.MouseButton1 then
                if onClick and not clickignore then onClick() end
            end
        end))

        local leave
        leave = addConnection(GUIOBJECT.MouseLeave:Connect(function()
            if input then input:Disconnect() end
            leave:Disconnect()
            if onLeave then onLeave() end
        end))
    end))
end

function uitools.stroke(parameters)
    local props = {
        GUIOBJECT   = parameters.GUIOBJECT or nil,
        Inner       = parameters.Inner or false,
        Padding     = parameters.Padding or 0,
        Element     = parameters.Element or false,
        Thickness   = parameters.Thickness or 1,
        _ZIndex     = parameters._ZIndex or 1,
        Color       = parameters.Color or Color3.new(1, 1, 1),
        JoinMode    = parameters.JoinMode or Enum.LineJoinMode.Miter,
        StrokeMode  = parameters.StrokeMode or Enum.ApplyStrokeMode.Border
    }
    local stroke
    if props.Inner and props.Padding then
        local strokeholder = uitools.create("Frame", {
            Parent = props.GUIOBJECT,
            BackgroundTransparency = 1,
            Size = UDim2.new(1, -props.Padding, 1, -props.Padding),
            AnchorPoint = Vector2.new(0.5, 0.5),
            Position = UDim2.new(0.5, 0, 0.5, 0),
            ZIndex = props._ZIndex
        })
        stroke = uitools.create("UIStroke", {
            Parent = strokeholder,
            Color = props.Color,
            Thickness = props.Thickness,
            ApplyStrokeMode = props.StrokeMode,
            LineJoinMode = props.Mode
        })
    else
        stroke = uitools.create("UIStroke", {
            Parent = props.GUIOBJECT,
            Color = props.Color,
            Thickness = props.Thickness,
            ApplyStrokeMode = props.StrokeMode,
            LineJoinMode = props.JoinMode
        })
    end
    return stroke
end

function uitools.relight(color3: Color3, intensity: number)
    if not intensity then intensity = 0.5 end
    return Color3.fromRGB(math.clamp(color3.r * 255 * intensity, 0, 255),
                          math.clamp(color3.g * 255 * intensity, 0, 255),
                          math.clamp(color3.b * 255 * intensity, 0, 255))
end

function uitools.draggable(object: Instance, ignored: Instance)
    local hover = false
    if ignored then
        addConnection(ignored.MouseEnter:Connect(function() hover = true end))
        addConnection(ignored.MouseLeave:Connect(function() hover = false end))
    end

    local dragStart, startPos, dragging
    addConnection(object.InputBegan:Connect(function(input)
        if ignored and hover ~= true or not ignored then
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                dragging = true
                dragStart = input.Position
                startPos = object.Position
            end
        end
    end))

    addConnection(UserInputService.InputChanged:Connect(function(input)
        if not hover then
            if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                local delta = input.Position - dragStart
                local newX = startPos.X.Offset + delta.X
                local newY = startPos.Y.Offset + delta.Y

                object.Position = UDim2.new(startPos.X.Scale, newX, startPos.Y.Scale, newY)
            end
        end
    end))

    addConnection(UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end))
end

function uitools.resizable(background: Instance, object: Instance)
    local dragging, currentsize
    local presetsize = background.Size
   addConnection(object.MouseButton1Down:Connect(function(input)
        dragging = true
    end))
    addConnection(game:GetService("Players").LocalPlayer:GetMouse().Move:Connect(function(input)
        if dragging then
            local MouseLocation = game:GetService("UserInputService"):GetMouseLocation()
            local X = math.clamp(MouseLocation.X - background.AbsolutePosition.X, presetsize.X.Offset, 9999)
            local Y = math.clamp((MouseLocation.Y - 36) - background.AbsolutePosition.Y, presetsize.Y.Offset, 9999)
            currentsize = UDim2.new(0, X, 0, Y)
            background.Size = currentsize
        end
    end))
    addConnection(game:GetService("UserInputService").InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end))
end

return uitools
