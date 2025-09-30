-- Advanced Notification System
-- Features: Multiple notification types, animations, and sound effects

local TweenService = game:GetService("TweenService")
local SoundService = game:GetService("SoundService")
local CoreGui = game:GetService("CoreGui")

local NotificationSystem = {}
NotificationSystem.Notifications = {}
NotificationSystem.MaxNotifications = 5
NotificationSystem.DefaultDuration = 3
NotificationSystem.SoundEnabled = true

-- Create notification
function NotificationSystem:CreateNotification(title, message, notificationType, duration)
    notificationType = notificationType or "Info"
    duration = duration or self.DefaultDuration
    
    local notification = Instance.new("Frame")
    notification.Name = "Notification_" .. tick()
    notification.Size = UDim2.new(0, 300, 0, 80)
    notification.Position = UDim2.new(1, -320, 0, 10)
    notification.BackgroundColor3 = self:GetNotificationColor(notificationType)
    notification.BorderSizePixel = 0
    notification.Parent = CoreGui
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = notification
    
    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(255, 255, 255)
    stroke.Thickness = 1
    stroke.Parent = notification
    
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Name = "Title"
    titleLabel.Size = UDim2.new(1, -40, 0, 25)
    titleLabel.Position = UDim2.new(0, 10, 0, 5)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = title
    titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    titleLabel.TextScaled = true
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.Parent = notification
    
    local messageLabel = Instance.new("TextLabel")
    messageLabel.Name = "Message"
    messageLabel.Size = UDim2.new(1, -40, 0, 40)
    messageLabel.Position = UDim2.new(0, 10, 0, 30)
    messageLabel.BackgroundTransparency = 1
    messageLabel.Text = message
    messageLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    messageLabel.TextScaled = true
    messageLabel.Font = Enum.Font.Gotham
    messageLabel.TextXAlignment = Enum.TextXAlignment.Left
    messageLabel.TextYAlignment = Enum.TextYAlignment.Top
    messageLabel.Parent = notification
    
    local closeButton = Instance.new("TextButton")
    closeButton.Name = "CloseButton"
    closeButton.Size = UDim2.new(0, 20, 0, 20)
    closeButton.Position = UDim2.new(1, -30, 0, 5)
    closeButton.BackgroundTransparency = 1
    closeButton.Text = "×"
    closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    closeButton.TextScaled = true
    closeButton.Font = Enum.Font.GothamBold
    closeButton.Parent = notification
    
    local icon = Instance.new("TextLabel")
    icon.Name = "Icon"
    icon.Size = UDim2.new(0, 20, 0, 20)
    icon.Position = UDim2.new(0, 10, 0, 5)
    icon.BackgroundTransparency = 1
    icon.Text = self:GetNotificationIcon(notificationType)
    icon.TextColor3 = Color3.fromRGB(255, 255, 255)
    icon.TextScaled = true
    icon.Font = Enum.Font.GothamBold
    icon.Parent = notification
    
    -- Position notification
    self:PositionNotification(notification)
    
    -- Animate in
    local animateIn = TweenService:Create(notification, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Position = UDim2.new(1, -310, 0, notification.Position.Y.Offset)
    })
    animateIn:Play()
    
    -- Auto remove after duration
    task.spawn(function()
        wait(duration)
        self:RemoveNotification(notification)
    end)
    
    -- Close button
    closeButton.MouseButton1Click:Connect(function()
        self:RemoveNotification(notification)
    end)
    
    -- Play sound
    if self.SoundEnabled then
        self:PlayNotificationSound(notificationType)
    end
    
    table.insert(self.Notifications, notification)
    return notification
end

-- Get notification color based on type
function NotificationSystem:GetNotificationColor(notificationType)
    if notificationType == "Success" then
        return Color3.fromRGB(0, 255, 0)
    elseif notificationType == "Error" then
        return Color3.fromRGB(255, 0, 0)
    elseif notificationType == "Warning" then
        return Color3.fromRGB(255, 165, 0)
    elseif notificationType == "Info" then
        return Color3.fromRGB(0, 150, 255)
    else
        return Color3.fromRGB(100, 100, 100)
    end
end

-- Get notification icon based on type
function NotificationSystem:GetNotificationIcon(notificationType)
    if notificationType == "Success" then
        return "✅"
    elseif notificationType == "Error" then
        return "❌"
    elseif notificationType == "Warning" then
        return "⚠️"
    elseif notificationType == "Info" then
        return "ℹ️"
    else
        return "📢"
    end
end

-- Position notification
function NotificationSystem:PositionNotification(notification)
    local yOffset = 10
    for i, notif in pairs(self.Notifications) do
        if notif ~= notification then
            yOffset = yOffset + 90
        end
    end
    notification.Position = UDim2.new(1, -320, 0, yOffset)
end

-- Remove notification
function NotificationSystem:RemoveNotification(notification)
    if notification and notification.Parent then
        local animateOut = TweenService:Create(notification, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
            Position = UDim2.new(1, 0, 0, notification.Position.Y.Offset)
        })
        animateOut:Play()
        
        animateOut.Completed:Connect(function()
            notification:Destroy()
        end)
        
        -- Remove from table
        for i, notif in pairs(self.Notifications) do
            if notif == notification then
                table.remove(self.Notifications, i)
                break
            end
        end
        
        -- Reposition remaining notifications
        self:RepositionNotifications()
    end
end

-- Reposition all notifications
function NotificationSystem:RepositionNotifications()
    local yOffset = 10
    for _, notification in pairs(self.Notifications) do
        if notification and notification.Parent then
            local animate = TweenService:Create(notification, TweenInfo.new(0.3), {
                Position = UDim2.new(1, -310, 0, yOffset)
            })
            animate:Play()
            yOffset = yOffset + 90
        end
    end
end

-- Play notification sound
function NotificationSystem:PlayNotificationSound(notificationType)
    local sound = Instance.new("Sound")
    sound.SoundId = "rbxasset://sounds/electronicpingshort.wav"
    sound.Volume = 0.5
    sound.Parent = SoundService
    
    sound:Play()
    sound.Ended:Connect(function()
        sound:Destroy()
    end)
end

-- Show success notification
function NotificationSystem:ShowSuccess(title, message, duration)
    return self:CreateNotification(title, message, "Success", duration)
end

-- Show error notification
function NotificationSystem:ShowError(title, message, duration)
    return self:CreateNotification(title, message, "Error", duration)
end

-- Show warning notification
function NotificationSystem:ShowWarning(title, message, duration)
    return self:CreateNotification(title, message, "Warning", duration)
end

-- Show info notification
function NotificationSystem:ShowInfo(title, message, duration)
    return self:CreateNotification(title, message, "Info", duration)
end

-- Clear all notifications
function NotificationSystem:ClearAll()
    for _, notification in pairs(self.Notifications) do
        if notification and notification.Parent then
            notification:Destroy()
        end
    end
    self.Notifications = {}
end

-- Set sound enabled
function NotificationSystem:SetSoundEnabled(enabled)
    self.SoundEnabled = enabled
end

-- Set max notifications
function NotificationSystem:SetMaxNotifications(max)
    self.MaxNotifications = max
end

-- Set default duration
function NotificationSystem:SetDefaultDuration(duration)
    self.DefaultDuration = duration
end

return NotificationSystem
