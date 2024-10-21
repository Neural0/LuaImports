local uitools = {}
local connections = {}
local objects = {}

local UserInputService = cloneref(game:GetService("UserInputService")) or game:GetService("UserInputService")
local TweenService = cloneref(game:GetService("TweenService")) or game:GetService("TweenService")

function uitools.create(Class: Instance, Properties: PhysicalProperties)
    local _Instance = type(Class) == 'string' and Instance.new(Class) or Class
    for Property, Value in next, Properties do
        _Instance[Property] = Value
    end
    table.insert(objects, _Instance)
    return _Instance
end
function uitools.tween(object, goal, callback)
	local tween = TweenService:Create(object, tweenInfo, goal)
	tween.Completed:Connect(callback or function() end)
	tween:Play()
end
function uitools.mouseEvents(GUIOBJECT: Instance, onEnter, onLeave, onClick, clickignore: boolean)
    table.insert(connections,GUIOBJECT.MouseEnter:Connect(function()
        if onEnter then onEnter() end
        table.insert(connections,UserInputService.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                if onClick and not clickignore then onClick() end
            end
        end))
        local leave
        leave = table.insert(connections,GUIOBJECT.MouseLeave:Connect(function()
            input:Disconnect()
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
        Mode        = parameters.Mode or Enum.LineJoinMode.Miter
    }
    local stroke, Mode
    if props.Inner and props.Padding then
        local strokeholder = uitools.create("Frame", {
            Parent = props.GUIOBJECT,
            BackgroundTransparency = 1,
            Size = UDim2.new(1,-Padding,1,-Padding),
            AnchorPoint = Vector2.new(0.5,0.5),
            Position = UDim2.new(0.5,0,0.5,0),
            ZIndex = props._ZIndex
        })
        stroke = uitools.create("UIStroke", {
            Parent = strokeholder,
            Color = props.Color,
            Thickness = props.Thickness,
            ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
            LineJoinMode = props.Mode
        })
    else
        stroke = uitools.create("UIStroke", {
            Parent = props.GUIOBJECT,
            Color =props. Color,
            Thickness = props.Thickness,
            ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
            LineJoinMode = props.Mode
        })
    end
    return stroke
end
function uitools.relight(color3: Color3, intensity: number)
    if not intensity then intensity = 0.5 end
    return Color3.fromRGB(math.clamp(color3.r * 255 * intensity, 0, 255), math.clamp(color3.g * 255 * intensity, 0, 255), math.clamp(color3.b * 255 * intensity, 0, 255))
end
function uitools.draggable(object: Instance, ignored: Instance)
    local hover = false
    if ignored then
        table.insert(connections,ignored.MouseEnter:Connect(function() hover = true end))
        table.insert(connections,ignored.MouseLeave:Connect(function() hover = false end))
    end
    local dragStart, startPos, dragging
    table.insert(connections,object.InputBegan:Connect(function(input)
        if ignored and hover ~= true then
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                dragging = true
                dragStart = input.Position
                startPos = object.Position
            end
        else
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                dragging = true
                dragStart = input.Position
                startPos = object.Position
            end
        end
    end))
    table.insert(connections,UserInputService.InputChanged:Connect(function(input)
        if hover ~= true then
            if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                local delta = input.Position - dragStart
                local newX = startPos.X.Offset + delta.X
                local newY = startPos.Y.Offset + delta.Y

                object.Position = UDim2.new(startPos.X.Scale, newX, startPos.Y.Scale, newY)
            end
        end
    end))
    table.insert(connections,UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end))

    return connections
end

return uitools, connections, objects
