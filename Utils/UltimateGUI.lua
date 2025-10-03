-- 🎨 ULTIMATE GUI SYSTEM - ADVANCED ANIMATIONS & EFFECTS
-- Professional UI with smooth animations and visual effects
-- Version: 5.0.0 - Ultimate GUI

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")
local SoundService = game:GetService("SoundService")

local UltimateGUI = {}
UltimateGUI.Effects = {}
UltimateGUI.Animations = {}
UltimateGUI.Sounds = {}
UltimateGUI.Themes = {}

-- 🎨 VISUAL EFFECTS
UltimateGUI.Effects.Particles = {
    Name = "Particle System",
    Description = "Advanced particle effects",
    Features = {
        "Rainbow Particles",
        "Glow Effects",
        "Trail Effects",
        "Explosion Effects"
    }
}

UltimateGUI.Effects.Animations = {
    Name = "Animation System",
    Description = "Smooth UI animations",
    Features = {
        "Slide Animations",
        "Fade Animations",
        "Scale Animations",
        "Rotation Animations"
    }
}

UltimateGUI.Effects.Shadows = {
    Name = "Shadow System",
    Description = "Advanced shadow effects",
    Features = {
        "Drop Shadows",
        "Inner Shadows",
        "Glow Shadows",
        "Blur Effects"
    }
}

-- 🎵 SOUND SYSTEM
UltimateGUI.Sounds.UI = {
    Click = "rbxasset://sounds/button.wav",
    Hover = "rbxasset://sounds/hover.wav",
    Success = "rbxasset://sounds/victory.wav",
    Error = "rbxasset://sounds/error.wav",
    Notification = "rbxasset://sounds/notification.wav"
}

-- 🎨 THEME SYSTEM
UltimateGUI.Themes.Dark = {
    Name = "Dark Theme",
    Primary = Color3.fromRGB(12, 12, 12),
    Secondary = Color3.fromRGB(20, 20, 20),
    Accent = Color3.fromRGB(0, 255, 255),
    Success = Color3.fromRGB(0, 255, 0),
    Error = Color3.fromRGB(255, 50, 50),
    Warning = Color3.fromRGB(255, 165, 0),
    Text = Color3.fromRGB(255, 255, 255),
    Border = Color3.fromRGB(40, 40, 40)
}

UltimateGUI.Themes.Light = {
    Name = "Light Theme",
    Primary = Color3.fromRGB(255, 255, 255),
    Secondary = Color3.fromRGB(240, 240, 240),
    Accent = Color3.fromRGB(0, 150, 255),
    Success = Color3.fromRGB(0, 200, 0),
    Error = Color3.fromRGB(255, 0, 0),
    Warning = Color3.fromRGB(255, 140, 0),
    Text = Color3.fromRGB(0, 0, 0),
    Border = Color3.fromRGB(200, 200, 200)
}

UltimateGUI.Themes.Neon = {
    Name = "Neon Theme",
    Primary = Color3.fromRGB(0, 0, 0),
    Secondary = Color3.fromRGB(20, 0, 20),
    Accent = Color3.fromRGB(255, 0, 255),
    Success = Color3.fromRGB(0, 255, 0),
    Error = Color3.fromRGB(255, 0, 0),
    Warning = Color3.fromRGB(255, 255, 0),
    Text = Color3.fromRGB(255, 255, 255),
    Border = Color3.fromRGB(255, 0, 255)
}

UltimateGUI.Themes.Ocean = {
    Name = "Ocean Theme",
    Primary = Color3.fromRGB(0, 50, 100),
    Secondary = Color3.fromRGB(0, 80, 120),
    Accent = Color3.fromRGB(0, 200, 255),
    Success = Color3.fromRGB(0, 255, 150),
    Error = Color3.fromRGB(255, 100, 100),
    Warning = Color3.fromRGB(255, 200, 0),
    Text = Color3.fromRGB(255, 255, 255),
    Border = Color3.fromRGB(0, 150, 200)
}

UltimateGUI.Themes.Fire = {
    Name = "Fire Theme",
    Primary = Color3.fromRGB(50, 0, 0),
    Secondary = Color3.fromRGB(80, 0, 0),
    Accent = Color3.fromRGB(255, 100, 0),
    Success = Color3.fromRGB(0, 255, 0),
    Error = Color3.fromRGB(255, 0, 0),
    Warning = Color3.fromRGB(255, 150, 0),
    Text = Color3.fromRGB(255, 255, 255),
    Border = Color3.fromRGB(255, 100, 0)
}

UltimateGUI.Themes.Rainbow = {
    Name = "Rainbow Theme",
    Primary = Color3.fromRGB(255, 0, 0),
    Secondary = Color3.fromRGB(0, 255, 0),
    Accent = Color3.fromRGB(0, 0, 255),
    Success = Color3.fromRGB(255, 255, 0),
    Error = Color3.fromRGB(255, 0, 255),
    Warning = Color3.fromRGB(0, 255, 255),
    Text = Color3.fromRGB(255, 255, 255),
    Border = Color3.fromRGB(255, 255, 255)
}

-- 🎨 ANIMATION FUNCTIONS
function UltimateGUI:CreateSlideAnimation(object, direction, duration)
    duration = duration or 0.3
    local startPosition = object.Position
    local endPosition = startPosition
    
    if direction == "Left" then
        endPosition = UDim2.new(startPosition.X.Scale, startPosition.X.Offset - object.AbsoluteSize.X, startPosition.Y.Scale, startPosition.Y.Offset)
    elseif direction == "Right" then
        endPosition = UDim2.new(startPosition.X.Scale, startPosition.X.Offset + object.AbsoluteSize.X, startPosition.Y.Scale, startPosition.Y.Offset)
    elseif direction == "Up" then
        endPosition = UDim2.new(startPosition.X.Scale, startPosition.X.Offset, startPosition.Y.Scale, startPosition.Y.Offset - object.AbsoluteSize.Y)
    elseif direction == "Down" then
        endPosition = UDim2.new(startPosition.X.Scale, startPosition.X.Offset, startPosition.Y.Scale, startPosition.Y.Offset + object.AbsoluteSize.Y)
    end
    
    local tweenInfo = TweenInfo.new(duration, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    local tween = TweenService:Create(object, tweenInfo, {Position = endPosition})
    
    return tween
end

function UltimateGUI:CreateFadeAnimation(object, targetTransparency, duration)
    duration = duration or 0.3
    local tweenInfo = TweenInfo.new(duration, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    local tween = TweenService:Create(object, tweenInfo, {BackgroundTransparency = targetTransparency})
    
    return tween
end

function UltimateGUI:CreateScaleAnimation(object, targetScale, duration)
    duration = duration or 0.3
    local tweenInfo = TweenInfo.new(duration, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
    local tween = TweenService:Create(object, tweenInfo, {Size = UDim2.new(targetScale, 0, targetScale, 0)})
    
    return tween
end

function UltimateGUI:CreateRotationAnimation(object, targetRotation, duration)
    duration = duration or 0.3
    local tweenInfo = TweenInfo.new(duration, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    local tween = TweenService:Create(object, tweenInfo, {Rotation = targetRotation})
    
    return tween
end

-- 🎨 PARTICLE EFFECTS
function UltimateGUI:CreateParticleEffect(parent, effectType)
    local particleFrame = Instance.new("Frame")
    particleFrame.Name = "ParticleEffect"
    particleFrame.Size = UDim2.new(1, 0, 1, 0)
    particleFrame.BackgroundTransparency = 1
    particleFrame.Parent = parent
    
    if effectType == "Rainbow" then
        task.spawn(function()
            while particleFrame.Parent do
                wait(0.1)
                local particle = Instance.new("Frame")
                particle.Size = UDim2.new(0, 2, 0, 2)
                particle.Position = UDim2.new(math.random(), 0, math.random(), 0)
                particle.BackgroundColor3 = Color3.fromHSV(math.random(), 1, 1)
                particle.BorderSizePixel = 0
                particle.Parent = particleFrame
                
                local corner = Instance.new("UICorner")
                corner.CornerRadius = UDim.new(1, 0)
                corner.Parent = particle
                
                local tween = TweenService:Create(particle, TweenInfo.new(2), {
                    Position = UDim2.new(math.random(), 0, math.random(), 0),
                    BackgroundTransparency = 1
                })
                tween:Play()
                
                tween.Completed:Connect(function()
                    particle:Destroy()
                end)
            end
        end)
    elseif effectType == "Glow" then
        task.spawn(function()
            while particleFrame.Parent do
                wait(0.05)
                local glow = Instance.new("Frame")
                glow.Size = UDim2.new(0, math.random(10, 30), 0, math.random(10, 30))
                glow.Position = UDim2.new(math.random(), 0, math.random(), 0)
                glow.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                glow.BackgroundTransparency = 0.5
                glow.BorderSizePixel = 0
                glow.Parent = particleFrame
                
                local corner = Instance.new("UICorner")
                corner.CornerRadius = UDim.new(1, 0)
                corner.Parent = glow
                
                local tween = TweenService:Create(glow, TweenInfo.new(1), {
                    Size = UDim2.new(0, 0, 0, 0),
                    BackgroundTransparency = 1
                })
                tween:Play()
                
                tween.Completed:Connect(function()
                    glow:Destroy()
                end)
            end
        end)
    end
    
    return particleFrame
end

-- 🎨 SHADOW EFFECTS
function UltimateGUI:CreateShadowEffect(object, shadowType)
    local shadow = Instance.new("Frame")
    shadow.Name = "Shadow"
    shadow.Size = UDim2.new(1, 4, 1, 4)
    shadow.Position = UDim2.new(0, -2, 0, -2)
    shadow.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    shadow.BackgroundTransparency = 0.5
    shadow.BorderSizePixel = 0
    shadow.ZIndex = object.ZIndex - 1
    shadow.Parent = object.Parent
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = shadow
    
    if shadowType == "Blur" then
        shadow.BackgroundTransparency = 0.7
    elseif shadowType == "Glow" then
        shadow.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        shadow.BackgroundTransparency = 0.3
    end
    
    return shadow
end

-- 🎵 SOUND EFFECTS
function UltimateGUI:PlaySound(soundType, volume)
    volume = volume or 0.5
    local sound = Instance.new("Sound")
    sound.SoundId = self.Sounds.UI[soundType]
    sound.Volume = volume
    sound.Parent = SoundService
    
    sound:Play()
    sound.Ended:Connect(function()
        sound:Destroy()
    end)
end

-- 🎨 ADVANCED BUTTON CREATION
function UltimateGUI:CreateAdvancedButton(text, callback, parent)
    local buttonFrame = Instance.new("Frame")
    buttonFrame.Name = text .. "Button"
    buttonFrame.Size = UDim2.new(1, -20, 0, 40)
    buttonFrame.BackgroundColor3 = self.Themes.Dark.Accent
    buttonFrame.BorderSizePixel = 0
    buttonFrame.Parent = parent
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = buttonFrame
    
    local stroke = Instance.new("UIStroke")
    stroke.Color = self.Themes.Dark.Border
    stroke.Thickness = 2
    stroke.Parent = buttonFrame
    
    local buttonLabel = Instance.new("TextLabel")
    buttonLabel.Name = "Label"
    buttonLabel.Size = UDim2.new(1, 0, 1, 0)
    buttonLabel.BackgroundTransparency = 1
    buttonLabel.Text = text
    buttonLabel.TextColor3 = self.Themes.Dark.Text
    buttonLabel.TextScaled = true
    buttonLabel.Font = Enum.Font.GothamBold
    buttonLabel.Parent = buttonFrame
    
    -- Hover effects
    buttonFrame.MouseEnter:Connect(function()
        self:PlaySound("Hover", 0.3)
        local hoverTween = TweenService:Create(buttonFrame, TweenInfo.new(0.2), {
            BackgroundColor3 = self.Themes.Dark.Success,
            Size = UDim2.new(1, -15, 0, 45)
        })
        hoverTween:Play()
    end)
    
    buttonFrame.MouseLeave:Connect(function()
        local leaveTween = TweenService:Create(buttonFrame, TweenInfo.new(0.2), {
            BackgroundColor3 = self.Themes.Dark.Accent,
            Size = UDim2.new(1, -20, 0, 40)
        })
        leaveTween:Play()
    end)
    
    buttonFrame.MouseButton1Click:Connect(function()
        self:PlaySound("Click", 0.5)
        local clickTween = TweenService:Create(buttonFrame, TweenInfo.new(0.1), {
            Size = UDim2.new(1, -25, 0, 35)
        })
        clickTween:Play()
        
        clickTween.Completed:Connect(function()
            local releaseTween = TweenService:Create(buttonFrame, TweenInfo.new(0.1), {
                Size = UDim2.new(1, -20, 0, 40)
            })
            releaseTween:Play()
        end)
        
        callback()
    end)
    
    return buttonFrame
end

-- 🎨 ADVANCED TOGGLE CREATION
function UltimateGUI:CreateAdvancedToggle(text, default, callback, parent)
    local toggleFrame = Instance.new("Frame")
    toggleFrame.Name = text .. "Toggle"
    toggleFrame.Size = UDim2.new(1, -20, 0, 35)
    toggleFrame.BackgroundTransparency = 1
    toggleFrame.Parent = parent
    
    local toggleButton = Instance.new("TextButton")
    toggleButton.Name = "ToggleButton"
    toggleButton.Size = UDim2.new(0, 60, 0, 25)
    toggleButton.Position = UDim2.new(0, 0, 0, 5)
    toggleButton.BackgroundColor3 = default and self.Themes.Dark.Success or self.Themes.Dark.Error
    toggleButton.BorderSizePixel = 0
    toggleButton.Text = ""
    toggleButton.Parent = toggleFrame
    
    local toggleCorner = Instance.new("UICorner")
    toggleCorner.CornerRadius = UDim.new(0, 4)
    toggleCorner.Parent = toggleButton
    
    local toggleLabel = Instance.new("TextLabel")
    toggleLabel.Name = "Label"
    toggleLabel.Size = UDim2.new(1, -70, 1, 0)
    toggleLabel.Position = UDim2.new(0, 65, 0, 0)
    toggleLabel.BackgroundTransparency = 1
    toggleLabel.Text = text
    toggleLabel.TextColor3 = self.Themes.Dark.Text
    toggleLabel.TextScaled = true
    toggleLabel.Font = Enum.Font.Gotham
    toggleLabel.TextXAlignment = Enum.TextXAlignment.Left
    toggleLabel.Parent = toggleFrame
    
    local enabled = default
    
    toggleButton.MouseButton1Click:Connect(function()
        enabled = not enabled
        self:PlaySound("Click", 0.4)
        
        local newColor = enabled and self.Themes.Dark.Success or self.Themes.Dark.Error
        local colorTween = TweenService:Create(toggleButton, TweenInfo.new(0.2), {BackgroundColor3 = newColor})
        colorTween:Play()
        
        callback(enabled)
    end)
    
    return toggleFrame
end

-- 🎨 ADVANCED SLIDER CREATION
function UltimateGUI:CreateAdvancedSlider(text, min, max, default, callback, parent)
    local sliderFrame = Instance.new("Frame")
    sliderFrame.Name = text .. "Slider"
    sliderFrame.Size = UDim2.new(1, -20, 0, 50)
    sliderFrame.BackgroundTransparency = 1
    sliderFrame.Parent = parent
    
    local sliderLabel = Instance.new("TextLabel")
    sliderLabel.Name = "Label"
    sliderLabel.Size = UDim2.new(1, 0, 0, 20)
    sliderLabel.Position = UDim2.new(0, 0, 0, 0)
    sliderLabel.BackgroundTransparency = 1
    sliderLabel.Text = text .. ": " .. default
    sliderLabel.TextColor3 = self.Themes.Dark.Text
    sliderLabel.TextScaled = true
    sliderLabel.Font = Enum.Font.Gotham
    sliderLabel.TextXAlignment = Enum.TextXAlignment.Left
    sliderLabel.Parent = sliderFrame
    
    local sliderBar = Instance.new("Frame")
    sliderBar.Name = "Bar"
    sliderBar.Size = UDim2.new(1, 0, 0, 20)
    sliderBar.Position = UDim2.new(0, 0, 0, 25)
    sliderBar.BackgroundColor3 = self.Themes.Dark.Secondary
    sliderBar.BorderSizePixel = 0
    sliderBar.Parent = sliderFrame
    
    local sliderBarCorner = Instance.new("UICorner")
    sliderBarCorner.CornerRadius = UDim.new(0, 10)
    sliderBarCorner.Parent = sliderBar
    
    local sliderFill = Instance.new("Frame")
    sliderFill.Name = "Fill"
    sliderFill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
    sliderFill.Position = UDim2.new(0, 0, 0, 0)
    sliderFill.BackgroundColor3 = self.Themes.Dark.Accent
    sliderFill.BorderSizePixel = 0
    sliderFill.Parent = sliderBar
    
    local sliderFillCorner = Instance.new("UICorner")
    sliderFillCorner.CornerRadius = UDim.new(0, 10)
    sliderFillCorner.Parent = sliderFill
    
    local sliderButton = Instance.new("TextButton")
    sliderButton.Name = "Button"
    sliderButton.Size = UDim2.new(0, 20, 0, 20)
    sliderButton.Position = UDim2.new((default - min) / (max - min), -10, 0, 0)
    sliderButton.BackgroundColor3 = self.Themes.Dark.Text
    sliderButton.BorderSizePixel = 0
    sliderButton.Text = ""
    sliderButton.Parent = sliderBar
    
    local sliderButtonCorner = Instance.new("UICorner")
    sliderButtonCorner.CornerRadius = UDim.new(0, 10)
    sliderButtonCorner.Parent = sliderButton
    
    local dragging = false
    local currentValue = default
    
    sliderButton.MouseButton1Down:Connect(function()
        dragging = true
        self:PlaySound("Click", 0.3)
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local mouseX = input.Position.X
            local sliderX = sliderBar.AbsolutePosition.X
            local sliderWidth = sliderBar.AbsoluteSize.X
            local percentage = math.clamp((mouseX - sliderX) / sliderWidth, 0, 1)
            local value = math.floor(min + (max - min) * percentage)
            
            currentValue = value
            sliderLabel.Text = text .. ": " .. value
            sliderFill.Size = UDim2.new(percentage, 0, 1, 0)
            sliderButton.Position = UDim2.new(percentage, -10, 0, 0)
            callback(value)
        end
    end)
    
    return sliderFrame
end

-- 🎨 THEME MANAGEMENT
function UltimateGUI:SetTheme(themeName)
    local theme = self.Themes[themeName]
    if theme then
        self.CurrentTheme = theme
        print("✅ Theme changed to: " .. themeName)
        return true
    else
        warn("❌ Theme '" .. themeName .. "' not found!")
        return false
    end
end

function UltimateGUI:GetCurrentTheme()
    return self.CurrentTheme or self.Themes.Dark
end

function UltimateGUI:GetAvailableThemes()
    local themes = {}
    for name, theme in pairs(self.Themes) do
        table.insert(themes, {Name = name, Theme = theme})
    end
    return themes
end

-- 🎨 GUI INITIALIZATION
function UltimateGUI:Initialize()
    print("🎨 Initializing Ultimate GUI System...")
    
    self.CurrentTheme = self.Themes.Dark
    
    print("✅ Ultimate GUI System initialized!")
    print("🎨 Available Themes: Dark, Light, Neon, Ocean, Fire, Rainbow")
    print("🎵 Sound Effects: Click, Hover, Success, Error, Notification")
    print("✨ Visual Effects: Particles, Animations, Shadows")
    
    return true
end

return UltimateGUI
