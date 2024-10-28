function notification(message, duration, color)
    local Position = Vector2.new(25, 50);
	local notification = {
        Container = nil, Objects = {}
    };

    local Notif_UI = cloneref(Instance.new("ScreenGui", gethui()))
    Notif_UI.Name = mysterium.functions:random_string(10)
    Notif_UI.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    Notif_UI.IgnoreGuiInset = true

	local NotifContainer = Instance.new('Frame', Notif_UI)
	NotifContainer.Name = "NotifContainer"
	NotifContainer.Position = UDim2.new(0,Position.X, 0, Position.Y)
	NotifContainer.AutomaticSize = Enum.AutomaticSize.X
	NotifContainer.Size = UDim2.new(0,0,0,16)
	NotifContainer.BACKGROUNDColor3 = Color3.new(1,1,1)
	NotifContainer.BACKGROUNDTransparency = 1
	NotifContainer.BorderSizePixel = 0
	NotifContainer.BorderColor3 = Color3.new(0,0,0)
	NotifContainer.ZIndex = 99999999
	notification.Container = NotifContainer

	local Outline = Instance.new("Frame")
	Outline.Name = "Outline"
	Outline.AutomaticSize = Enum.AutomaticSize.X
	Outline.BACKGROUNDColor3 = Color3.fromRGB(17,17,17)
	Outline.BorderColor3 = Color3.fromRGB(0, 0, 0)
	Outline.Position = UDim2.new(0.01, 0, 0.02, 0)
	Outline.Size = UDim2.new(0, 0, 0, 16)
	Outline.Parent = NotifContainer
	Outline.BACKGROUNDTransparency = 1
	table.insert(notification.Objects, Outline)

	local Inline = Instance.new("Frame")
	Inline.Name = "Inline"
	Inline.BACKGROUNDColor3 = Color3.fromRGB(5, 5, 5)
	Inline.BorderColor3 = Color3.fromRGB(0, 0, 0)
	Inline.BorderSizePixel = 0
	Inline.Position = UDim2.new(0, 1, 0, 1)
	Inline.Size = UDim2.new(1, -2, 1, -2)
	Inline.BACKGROUNDTransparency = 1
    Inline.Parent = Outline
	table.insert(notification.Objects, Inline)

	local Value = Instance.new("TextLabel")
	Value.Name = "Value"
	Value.FontFace = mysterium.menu.fonts.options.Graph_35
	Value.Text = message
	Value.TextColor3 = Color3.fromRGB(255, 255, 255)
	Value.TextSize = mysterium.menu.font_size
	Value.TextStrokeTransparency = 0
	Value.TextXAlignment = Enum.TextXAlignment.Left
	Value.AutomaticSize = Enum.AutomaticSize.X
	Value.BACKGROUNDColor3 = Color3.fromRGB(20, 20, 20)
	Value.BACKGROUNDTransparency = 1
	Value.Size = UDim2.new(0, 0, 1, 0)
	Value.TextTransparency = 1
    Value.Parent = Inline
	table.insert(notification.Objects, Value)

	local UIPadding = Instance.new("UIPadding")
	UIPadding.Name = "UIPadding"
	UIPadding.PaddingLeft = UDim.new(0, 5)
	UIPadding.PaddingRight = UDim.new(0, 5)
	UIPadding.PaddingTop = UDim.new(0, 1)
	UIPadding.Parent = Value

	local Accent = Instance.new("Frame")
	Accent.Name = "Accent"
	Accent.BACKGROUNDColor3 = color ~= nil and color or mysterium.menu.menu_colors.accent
	Accent.BorderColor3 = Color3.fromRGB(0, 0, 0)
	Accent.BorderSizePixel = 0
	Accent.Size = UDim2.new(1, 0, 0, 1)
	Accent.Parent = Outline
	Accent.BACKGROUNDTransparency = 1
	table.insert(notification.Objects, Accent)

	function notification:remove()
		table.remove(mysterium.menu.notifications, table.find(mysterium.menu.notifications, notification))
		mysterium.functions:notification_autosize(Position)
		task.wait(0.5)
		notification.Container:Destroy()
	end

	task.spawn(function()
		Outline.AnchorPoint = Vector2.new(1,0)
		for _, v in next, notification.Objects do
			if v:IsA("Frame") then
				enviorment.tween_service:Create(v, TweenInfo.new(1, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {BACKGROUNDTransparency = 0}):Play()
			elseif v:IsA("UIStroke") then
				enviorment.tween_service:Create(v, TweenInfo.new(1, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Transparency = 0.8}):Play()
			end
		end
		enviorment.tween_service:Create(Outline, TweenInfo.new(1, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {AnchorPoint = Vector2.new(0,0)}):Play()
		enviorment.tween_service:Create(Value, TweenInfo.new(1, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {TextTransparency = 0}):Play()
		task.wait(duration)
		enviorment.tween_service:Create(Outline, TweenInfo.new(1, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {AnchorPoint = Vector2.new(1,0)}):Play()
		for _, v in next, notification.Objects do
			if v:IsA("Frame") then
				enviorment.tween_service:Create(v, TweenInfo.new(1, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {BACKGROUNDTransparency = 1}):Play()
			elseif v:IsA("UIStroke") then
				enviorment.tween_service:Create(v, TweenInfo.new(1, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Transparency = 1}):Play()
			end
		end
		enviorment.tween_service:Create(Value, TweenInfo.new(1, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {TextTransparency = 1}):Play()
	end)

	task.delay(duration, function() notification:remove() end)
	table.insert(mysterium.menu.notifications, notification)
	NotifContainer.Position = UDim2.new(0,Position.X,0,Position.Y + (table.find(mysterium.menu.notifications, notification) * 25))
	mysterium.functions:notification_autosize(Position)

	return notification;
end

return addnotification
