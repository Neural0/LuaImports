local uitools = {}
local connections = {}

local UserInputService = cloneref(game:GetService("UserInputService")) or game:GetService("UserInputService")
local TweenService = cloneref(game:GetService("TweenService")) or game:GetService("TweenService")

function uitools:tween(object, goal, callback)
	local tween = TweenService:Create(object, tweenInfo, goal)
	tween.Completed:Connect(callback or function() end)
	tween:Play()
end
function uitools:mouseEvents(GUIOBJECT: Instance, onEnter, onLeave, onClick, clickignore: boolean)
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
function uitools:stroke(GUIOBJECT: Instance, Inner: boolean, Padding: number, Element: boolean, Thickness: number, _ZIndex: number)
    if not Thickness then Thickness = 1 end
    if not _ZIndex then _ZIndex = 1 end
    local stroke, Color, Mode
    if Element then Color = Colors.ElementBorder Mode = Enum.LineJoinMode.Round else Color = Colors.BorderColor Mode = Enum.LineJoinMode.Miter end
    if Inner and Padding then
        local strokeholder = Utility:Create("Frame", {
            Parent = GUIOBJECT,
            BackgroundTransparency = 1,
            Size = UDim2.new(1,-Padding,1,-Padding),
            AnchorPoint = Vector2.new(0.5,0.5),
            Position = UDim2.new(0.5,0,0.5,0),
            ZIndex = _ZIndex
        })
        stroke = Utility:Create("UIStroke", {
            Parent = strokeholder,
            Color = Color,
            Thickness = Thickness,
            ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
            LineJoinMode = Mode
        })
    else
        stroke = Utility:Create("UIStroke", {
            Parent = GUIOBJECT,
            Color = Color,
            Thickness = Thickness,
            ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
            LineJoinMode = Mode
        })
    end
    return stroke
end
function uitools:relight(color3: Color3, intensity: number)
    if not intensity then intensity = 0.5 end
    return Color3.fromRGB(math.clamp(color3.r * 255 * intensity, 0, 255), math.clamp(color3.g * 255 * intensity, 0, 255), math.clamp(color3.b * 255 * intensity, 0, 255))
end
function uitools:draggable(object: Instance, ignored: Instance)
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

return uitools, connections
