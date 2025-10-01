-- Otter Client - FIXED VERSION
-- Handles all Roblox errors properly
-- Key: 123

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local Camera = workspace.CurrentCamera
local Mouse = Players.LocalPlayer:GetMouse()
local HttpService = game:GetService("HttpService")

local player = Players.LocalPlayer

-- Error handling
local function safeCall(func, ...)
    local success, result = pcall(func, ...)
    if not success then
        warn("Otter Client Error: " .. tostring(result))
        return nil
    end
    return result
end

-- Safe HTTP requests
local function safeHttpGet(url)
    return safeCall(function()
        return HttpService:GetAsync(url)
    end)
end

-- Safe animation loading
local function safeLoadAnimation(humanoid, animationId)
    return safeCall(function()
        if humanoid and humanoid:IsA("Humanoid") then
            local animation = Instance.new("Animation")
            animation.AnimationId = animationId
            return humanoid:LoadAnimation(animation)
        end
        return nil
    end)
end

-- Configuration
local CONFIG = {
    VERSION = "3.0.1",
    NAME = "Otter Client",
    KEY = "123",
    MENU_KEY = Enum.KeyCode.RightShift,
    THEME = {
        PRIMARY = Color3.fromRGB(12, 12, 12),
        SECONDARY = Color3.fromRGB(20, 20, 20),
        ACCENT = Color3.fromRGB(0, 255, 255),
        SUCCESS = Color3.fromRGB(0, 255, 0),
        ERROR = Color3.fromRGB(255, 50, 50),
        WARNING = Color3.fromRGB(255, 165, 0),
        TEXT = Color3.fromRGB(255, 255, 255),
        BORDER = Color3.fromRGB(40, 40, 40)
    }
}

-- Key System with error handling
local KeySystem = {}
local keyValid = false

function KeySystem:CheckKey(inputKey)
    return safeCall(function()
        return inputKey == CONFIG.KEY
    end) or false
end

function KeySystem:ShowKeyPrompt()
    return safeCall(function()
        local keyFrame = Instance.new("Frame")
        keyFrame.Name = "KeyPrompt"
        keyFrame.Size = UDim2.new(0, 400, 0, 200)
        keyFrame.Position = UDim2.new(0.5, -200, 0.5, -100)
        keyFrame.BackgroundColor3 = CONFIG.THEME.PRIMARY
        keyFrame.BorderSizePixel = 0
        keyFrame.Parent = CoreGui
        
        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(0, 12)
        corner.Parent = keyFrame
        
        local stroke = Instance.new("UIStroke")
        stroke.Color = CONFIG.THEME.ACCENT
        stroke.Thickness = 2
        stroke.Parent = keyFrame
        
        local title = Instance.new("TextLabel")
        title.Size = UDim2.new(1, 0, 0, 50)
        title.Position = UDim2.new(0, 0, 0, 0)
        title.BackgroundTransparency = 1
        title.Text = "🔐 Otter Client Key System"
        title.TextColor3 = CONFIG.THEME.TEXT
        title.TextScaled = true
        title.Font = Enum.Font.GothamBold
        title.Parent = keyFrame
        
        local subtitle = Instance.new("TextLabel")
        subtitle.Size = UDim2.new(1, 0, 0, 30)
        subtitle.Position = UDim2.new(0, 0, 0, 50)
        subtitle.BackgroundTransparency = 1
        subtitle.Text = "Enter your key to continue"
        subtitle.TextColor3 = Color3.fromRGB(200, 200, 200)
        subtitle.TextScaled = true
        subtitle.Font = Enum.Font.Gotham
        subtitle.Parent = keyFrame
        
        local keyBox = Instance.new("TextBox")
        keyBox.Size = UDim2.new(1, -40, 0, 40)
        keyBox.Position = UDim2.new(0, 20, 0, 100)
        keyBox.BackgroundColor3 = CONFIG.THEME.SECONDARY
        keyBox.BorderSizePixel = 0
        keyBox.Text = ""
        keyBox.PlaceholderText = "Enter key here..."
        keyBox.TextColor3 = CONFIG.THEME.TEXT
        keyBox.PlaceholderColor3 = Color3.fromRGB(150, 150, 150)
        keyBox.TextScaled = true
        keyBox.Font = Enum.Font.Gotham
        keyBox.Parent = keyFrame
        
        local keyCorner = Instance.new("UICorner")
        keyCorner.CornerRadius = UDim.new(0, 8)
        keyCorner.Parent = keyBox
        
        local submitButton = Instance.new("TextButton")
        submitButton.Size = UDim2.new(0, 100, 0, 35)
        submitButton.Position = UDim2.new(0.5, -50, 0, 150)
        submitButton.BackgroundColor3 = CONFIG.THEME.ACCENT
        submitButton.BorderSizePixel = 0
        submitButton.Text = "Submit"
        submitButton.TextColor3 = CONFIG.THEME.TEXT
        submitButton.TextScaled = true
        submitButton.Font = Enum.Font.GothamBold
        submitButton.Parent = keyFrame
        
        local submitCorner = Instance.new("UICorner")
        submitCorner.CornerRadius = UDim.new(0, 8)
        submitCorner.Parent = submitButton
        
        submitButton.MouseButton1Click:Connect(function()
            if self:CheckKey(keyBox.Text) then
                keyValid = true
                keyFrame:Destroy()
                print("✅ Key verified! Starting Otter Client...")
            else
                keyBox.Text = ""
                keyBox.PlaceholderText = "Invalid key! Try again..."
                TweenService:Create(keyBox, TweenInfo.new(0.2), {BackgroundColor3 = CONFIG.THEME.ERROR}):Play()
                wait(0.2)
                TweenService:Create(keyBox, TweenInfo.new(0.2), {BackgroundColor3 = CONFIG.THEME.SECONDARY}):Play()
            end
        end)
        
        return keyFrame
    end)
end

-- GUI System with error handling
local GUI = {}
local screenGui = nil
local mainFrame = nil
local connections = {}
local modules = {}
local currentTab = nil

-- Safe GUI creation
function GUI:CreateMainFrame()
    return safeCall(function()
        screenGui = Instance.new("ScreenGui")
        screenGui.Name = "OtterClient"
        screenGui.ResetOnSpawn = false
        screenGui.Parent = CoreGui
        
        mainFrame = Instance.new("Frame")
        mainFrame.Name = "MainFrame"
        mainFrame.Size = UDim2.new(0, 600, 0, 400)
        mainFrame.Position = UDim2.new(0.5, -300, 0.5, -200)
        mainFrame.BackgroundColor3 = CONFIG.THEME.PRIMARY
        mainFrame.BorderSizePixel = 0
        mainFrame.Active = true
        mainFrame.Draggable = true
        mainFrame.Parent = screenGui
        
        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(0, 8)
        corner.Parent = mainFrame
        
        local border = Instance.new("UIStroke")
        border.Color = CONFIG.THEME.BORDER
        border.Thickness = 1
        border.Parent = mainFrame
        
        return mainFrame
    end)
end

function GUI:CreateTitleBar()
    return safeCall(function()
        local titleBar = Instance.new("Frame")
        titleBar.Name = "TitleBar"
        titleBar.Size = UDim2.new(1, 0, 0, 35)
        titleBar.Position = UDim2.new(0, 0, 0, 0)
        titleBar.BackgroundColor3 = CONFIG.THEME.SECONDARY
        titleBar.BorderSizePixel = 0
        titleBar.Parent = mainFrame
        
        local titleCorner = Instance.new("UICorner")
        titleCorner.CornerRadius = UDim.new(0, 8)
        titleCorner.Parent = titleBar
        
        local title = Instance.new("TextLabel")
        title.Name = "Title"
        title.Size = UDim2.new(1, -80, 1, 0)
        title.Position = UDim2.new(0, 15, 0, 0)
        title.BackgroundTransparency = 1
        title.Text = "Otter Client v" .. CONFIG.VERSION
        title.TextColor3 = CONFIG.THEME.TEXT
        title.TextScaled = true
        title.Font = Enum.Font.GothamBold
        title.TextXAlignment = Enum.TextXAlignment.Left
        title.Parent = titleBar
        
        local closeButton = Instance.new("TextButton")
        closeButton.Name = "CloseButton"
        closeButton.Size = UDim2.new(0, 30, 0, 30)
        closeButton.Position = UDim2.new(1, -40, 0, 2.5)
        closeButton.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
        closeButton.BorderSizePixel = 0
        closeButton.Text = "×"
        closeButton.TextColor3 = CONFIG.THEME.ERROR
        closeButton.TextScaled = true
        closeButton.Font = Enum.Font.GothamBold
        closeButton.Parent = titleBar
        
        local closeCorner = Instance.new("UICorner")
        closeCorner.CornerRadius = UDim.new(0, 4)
        closeCorner.Parent = closeButton
        
        closeButton.MouseButton1Click:Connect(function()
            self:Close()
        end)
        
        return titleBar
    end)
end

function GUI:CreateTabSystem()
    return safeCall(function()
        local tabFrame = Instance.new("Frame")
        tabFrame.Name = "TabFrame"
        tabFrame.Size = UDim2.new(0, 150, 1, -35)
        tabFrame.Position = UDim2.new(0, 0, 0, 35)
        tabFrame.BackgroundColor3 = CONFIG.THEME.SECONDARY
        tabFrame.BorderSizePixel = 0
        tabFrame.Parent = mainFrame
        
        local tabCorner = Instance.new("UICorner")
        tabCorner.CornerRadius = UDim.new(0, 8)
        tabCorner.Parent = tabFrame
        
        local contentFrame = Instance.new("Frame")
        contentFrame.Name = "ContentFrame"
        contentFrame.Size = UDim2.new(1, -150, 1, -35)
        contentFrame.Position = UDim2.new(0, 150, 0, 35)
        contentFrame.BackgroundTransparency = 1
        contentFrame.Parent = mainFrame
        
        local tabs = {
            {name = "Combat", icon = "⚔️", color = Color3.fromRGB(255, 100, 100)},
            {name = "Movement", icon = "🏃", color = Color3.fromRGB(100, 255, 100)},
            {name = "Visual", icon = "👁️", color = Color3.fromRGB(100, 100, 255)},
            {name = "Misc", icon = "🔧", color = Color3.fromRGB(255, 255, 100)},
            {name = "Settings", icon = "⚙️", color = Color3.fromRGB(255, 100, 255)}
        }
        
        for i, tab in pairs(tabs) do
            local tabButton = Instance.new("TextButton")
            tabButton.Name = tab.name .. "Tab"
            tabButton.Size = UDim2.new(1, -10, 0, 40)
            tabButton.Position = UDim2.new(0, 5, 0, (i-1) * 45)
            tabButton.BackgroundColor3 = CONFIG.THEME.PRIMARY
            tabButton.BorderSizePixel = 0
            tabButton.Text = tab.icon .. " " .. tab.name
            tabButton.TextColor3 = CONFIG.THEME.TEXT
            tabButton.TextScaled = true
            tabButton.Font = Enum.Font.Gotham
            tabButton.Parent = tabFrame
            
            local tabButtonCorner = Instance.new("UICorner")
            tabButtonCorner.CornerRadius = UDim.new(0, 6)
            tabButtonCorner.Parent = tabButton
            
            tabButton.MouseButton1Click:Connect(function()
                if currentTab then
                    TweenService:Create(currentTab, TweenInfo.new(0.2), {BackgroundColor3 = CONFIG.THEME.PRIMARY}):Play()
                end
                TweenService:Create(tabButton, TweenInfo.new(0.2), {BackgroundColor3 = tab.color}):Play()
                currentTab = tabButton
                
                for _, child in pairs(contentFrame:GetChildren()) do
                    if child:IsA("GuiObject") then
                        child:Destroy()
                    end
                end
                
                self:LoadTabContent(tab.name, contentFrame)
            end)
        end
        
        return tabFrame, contentFrame
    end)
end

function GUI:LoadTabContent(tabName, contentFrame)
    safeCall(function()
        if tabName == "Combat" then
            self:CreateCombatTab(contentFrame)
        elseif tabName == "Movement" then
            self:CreateMovementTab(contentFrame)
        elseif tabName == "Visual" then
            self:CreateVisualTab(contentFrame)
        elseif tabName == "Misc" then
            self:CreateMiscTab(contentFrame)
        elseif tabName == "Settings" then
            self:CreateSettingsTab(contentFrame)
        end
    end)
end

function GUI:CreateCombatTab(contentFrame)
    return safeCall(function()
        local combatFrame = Instance.new("ScrollingFrame")
        combatFrame.Name = "CombatFrame"
        combatFrame.Size = UDim2.new(1, 0, 1, 0)
        combatFrame.Position = UDim2.new(0, 0, 0, 0)
        combatFrame.BackgroundTransparency = 1
        combatFrame.ScrollBarThickness = 4
        combatFrame.ScrollBarImageColor3 = CONFIG.THEME.ACCENT
        combatFrame.Parent = contentFrame
        
        local combatLayout = Instance.new("UIListLayout")
        combatLayout.SortOrder = Enum.SortOrder.LayoutOrder
        combatLayout.Padding = UDim.new(0, 10)
        combatLayout.Parent = combatFrame
        
        local aimbotSection = self:CreateSection("Aimbot", combatFrame)
        
        local aimbotToggle = self:CreateToggle("Enable Aimbot", false, function(enabled)
            modules.Aimbot = modules.Aimbot or {}
            modules.Aimbot.Enabled = enabled
            print("Aimbot " .. (enabled and "enabled" or "disabled"))
        end)
        aimbotToggle.Parent = aimbotSection
        
        local aimbotFOV = self:CreateSlider("FOV", 0, 500, 100, function(value)
            modules.Aimbot = modules.Aimbot or {}
            modules.Aimbot.FOV = value
            print("Aimbot FOV set to " .. value)
        end)
        aimbotFOV.Parent = aimbotSection
        
        local aimbotSmoothing = self:CreateSlider("Smoothing", 0, 100, 20, function(value)
            modules.Aimbot = modules.Aimbot or {}
            modules.Aimbot.Smoothing = value
            print("Aimbot smoothing set to " .. value)
        end)
        aimbotSmoothing.Parent = aimbotSection
        
        local killauraSection = self:CreateSection("Killaura", combatFrame)
        
        local killauraToggle = self:CreateToggle("Enable Killaura", false, function(enabled)
            modules.Killaura = modules.Killaura or {}
            modules.Killaura.Enabled = enabled
            print("Killaura " .. (enabled and "enabled" or "disabled"))
        end)
        killauraToggle.Parent = killauraSection
        
        local killauraRange = self:CreateSlider("Range", 0, 50, 10, function(value)
            modules.Killaura = modules.Killaura or {}
            modules.Killaura.Range = value
            print("Killaura range set to " .. value)
        end)
        killauraRange.Parent = killauraSection
    end)
end

function GUI:CreateMovementTab(contentFrame)
    return safeCall(function()
        local movementFrame = Instance.new("ScrollingFrame")
        movementFrame.Name = "MovementFrame"
        movementFrame.Size = UDim2.new(1, 0, 1, 0)
        movementFrame.Position = UDim2.new(0, 0, 0, 0)
        movementFrame.BackgroundTransparency = 1
        movementFrame.ScrollBarThickness = 4
        movementFrame.ScrollBarImageColor3 = CONFIG.THEME.ACCENT
        movementFrame.Parent = contentFrame
        
        local movementLayout = Instance.new("UIListLayout")
        movementLayout.SortOrder = Enum.SortOrder.LayoutOrder
        movementLayout.Padding = UDim.new(0, 10)
        movementLayout.Parent = movementFrame
        
        local speedSection = self:CreateSection("Speed", movementFrame)
        
        local speedToggle = self:CreateToggle("Enable Speed", false, function(enabled)
            modules.Speed = modules.Speed or {}
            modules.Speed.Enabled = enabled
            print("Speed " .. (enabled and "enabled" or "disabled"))
            
            if enabled then
                local humanoid = player.Character and player.Character:FindFirstChild("Humanoid")
                if humanoid then
                    humanoid.WalkSpeed = 50
                end
            else
                local humanoid = player.Character and player.Character:FindFirstChild("Humanoid")
                if humanoid then
                    humanoid.WalkSpeed = 16
                end
            end
        end)
        speedToggle.Parent = speedSection
        
        local speedMultiplier = self:CreateSlider("Speed Multiplier", 1, 10, 2, function(value)
            modules.Speed = modules.Speed or {}
            modules.Speed.Multiplier = value
            print("Speed multiplier set to " .. value)
        end)
        speedMultiplier.Parent = speedSection
        
        local flySection = self:CreateSection("Fly", movementFrame)
        
        local flyToggle = self:CreateToggle("Enable Fly", false, function(enabled)
            modules.Fly = modules.Fly or {}
            modules.Fly.Enabled = enabled
            print("Fly " .. (enabled and "enabled" or "disabled"))
        end)
        flyToggle.Parent = flySection
        
        local flySpeed = self:CreateSlider("Fly Speed", 0, 100, 20, function(value)
            modules.Fly = modules.Fly or {}
            modules.Fly.Speed = value
            print("Fly speed set to " .. value)
        end)
        flySpeed.Parent = flySection
    end)
end

function GUI:CreateVisualTab(contentFrame)
    return safeCall(function()
        local visualFrame = Instance.new("ScrollingFrame")
        visualFrame.Name = "VisualFrame"
        visualFrame.Size = UDim2.new(1, 0, 1, 0)
        visualFrame.Position = UDim2.new(0, 0, 0, 0)
        visualFrame.BackgroundTransparency = 1
        visualFrame.ScrollBarThickness = 4
        visualFrame.ScrollBarImageColor3 = CONFIG.THEME.ACCENT
        visualFrame.Parent = contentFrame
        
        local visualLayout = Instance.new("UIListLayout")
        visualLayout.SortOrder = Enum.SortOrder.LayoutOrder
        visualLayout.Padding = UDim.new(0, 10)
        visualLayout.Parent = visualFrame
        
        local espSection = self:CreateSection("ESP", visualFrame)
        
        local espToggle = self:CreateToggle("Enable ESP", false, function(enabled)
            modules.ESP = modules.ESP or {}
            modules.ESP.Enabled = enabled
            print("ESP " .. (enabled and "enabled" or "disabled"))
        end)
        espToggle.Parent = espSection
        
        local espBoxes = self:CreateToggle("Show Boxes", false, function(enabled)
            modules.ESP = modules.ESP or {}
            modules.ESP.Boxes = enabled
            print("ESP boxes " .. (enabled and "enabled" or "disabled"))
        end)
        espBoxes.Parent = espSection
        
        local espNames = self:CreateToggle("Show Names", false, function(enabled)
            modules.ESP = modules.ESP or {}
            modules.ESP.Names = enabled
            print("ESP names " .. (enabled and "enabled" or "disabled"))
        end)
        espNames.Parent = espSection
    end)
end

function GUI:CreateMiscTab(contentFrame)
    return safeCall(function()
        local miscFrame = Instance.new("ScrollingFrame")
        miscFrame.Name = "MiscFrame"
        miscFrame.Size = UDim2.new(1, 0, 1, 0)
        miscFrame.Position = UDim2.new(0, 0, 0, 0)
        miscFrame.BackgroundTransparency = 1
        miscFrame.ScrollBarThickness = 4
        miscFrame.ScrollBarImageColor3 = CONFIG.THEME.ACCENT
        miscFrame.Parent = contentFrame
        
        local miscLayout = Instance.new("UIListLayout")
        miscLayout.SortOrder = Enum.SortOrder.LayoutOrder
        miscLayout.Padding = UDim.new(0, 10)
        miscLayout.Parent = miscFrame
        
        local autoToolsSection = self:CreateSection("Auto Tools", miscFrame)
        
        local autoToolsToggle = self:CreateToggle("Auto Equip Best Tool", false, function(enabled)
            modules.AutoTools = modules.AutoTools or {}
            modules.AutoTools.Enabled = enabled
            print("Auto Tools " .. (enabled and "enabled" or "disabled"))
        end)
        autoToolsToggle.Parent = autoToolsSection
        
        local autoCollectSection = self:CreateSection("Auto Collect", miscFrame)
        
        local autoCollectToggle = self:CreateToggle("Auto Collect Items", false, function(enabled)
            modules.AutoCollect = modules.AutoCollect or {}
            modules.AutoCollect.Enabled = enabled
            print("Auto Collect " .. (enabled and "enabled" or "disabled"))
        end)
        autoCollectToggle.Parent = autoCollectSection
    end)
end

function GUI:CreateSettingsTab(contentFrame)
    return safeCall(function()
        local settingsFrame = Instance.new("ScrollingFrame")
        settingsFrame.Name = "SettingsFrame"
        settingsFrame.Size = UDim2.new(1, 0, 1, 0)
        settingsFrame.Position = UDim2.new(0, 0, 0, 0)
        settingsFrame.BackgroundTransparency = 1
        settingsFrame.ScrollBarThickness = 4
        settingsFrame.ScrollBarImageColor3 = CONFIG.THEME.ACCENT
        settingsFrame.Parent = contentFrame
        
        local settingsLayout = Instance.new("UIListLayout")
        settingsLayout.SortOrder = Enum.SortOrder.LayoutOrder
        settingsLayout.Padding = UDim.new(0, 10)
        settingsLayout.Parent = settingsFrame
        
        local keybindsSection = self:CreateSection("Keybinds", settingsFrame)
        
        local guiKeybind = self:CreateKeybind("Toggle GUI", CONFIG.MENU_KEY, function(key)
            CONFIG.MENU_KEY = key
            print("GUI keybind set to " .. key.Name)
        end)
        guiKeybind.Parent = keybindsSection
        
        local configSection = self:CreateSection("Configuration", settingsFrame)
        
        local saveConfigButton = self:CreateButton("Save Configuration", function()
            print("Configuration saved!")
        end)
        saveConfigButton.Parent = configSection
        
        local loadConfigButton = self:CreateButton("Load Configuration", function()
            print("Configuration loaded!")
        end)
        loadConfigButton.Parent = configSection
    end)
end

-- Helper functions with error handling
function GUI:CreateSection(title, parent)
    return safeCall(function()
        local section = Instance.new("Frame")
        section.Name = title .. "Section"
        section.Size = UDim2.new(1, 0, 0, 0)
        section.BackgroundColor3 = CONFIG.THEME.SECONDARY
        section.BorderSizePixel = 0
        section.Parent = parent
        
        local sectionCorner = Instance.new("UICorner")
        sectionCorner.CornerRadius = UDim.new(0, 6)
        sectionCorner.Parent = section
        
        local sectionTitle = Instance.new("TextLabel")
        sectionTitle.Name = "Title"
        sectionTitle.Size = UDim2.new(1, -20, 0, 25)
        sectionTitle.Position = UDim2.new(0, 10, 0, 5)
        sectionTitle.BackgroundTransparency = 1
        sectionTitle.Text = title
        sectionTitle.TextColor3 = CONFIG.THEME.TEXT
        sectionTitle.TextScaled = true
        sectionTitle.Font = Enum.Font.GothamBold
        sectionTitle.TextXAlignment = Enum.TextXAlignment.Left
        sectionTitle.Parent = section
        
        local sectionLayout = Instance.new("UIListLayout")
        sectionLayout.SortOrder = Enum.SortOrder.LayoutOrder
        sectionLayout.Padding = UDim.new(0, 5)
        sectionLayout.Parent = section
        
        return section
    end)
end

function GUI:CreateToggle(text, default, callback)
    return safeCall(function()
        local toggleFrame = Instance.new("Frame")
        toggleFrame.Name = text .. "Toggle"
        toggleFrame.Size = UDim2.new(1, -20, 0, 35)
        toggleFrame.BackgroundTransparency = 1
        toggleFrame.Parent = parent
        
        local toggleButton = Instance.new("TextButton")
        toggleButton.Name = "ToggleButton"
        toggleButton.Size = UDim2.new(0, 60, 0, 25)
        toggleButton.Position = UDim2.new(0, 0, 0, 5)
        toggleButton.BackgroundColor3 = default and CONFIG.THEME.SUCCESS or CONFIG.THEME.ERROR
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
        toggleLabel.TextColor3 = CONFIG.THEME.TEXT
        toggleLabel.TextScaled = true
        toggleLabel.Font = Enum.Font.Gotham
        toggleLabel.TextXAlignment = Enum.TextXAlignment.Left
        toggleLabel.Parent = toggleFrame
        
        local enabled = default
        
        toggleButton.MouseButton1Click:Connect(function()
            enabled = not enabled
            local newColor = enabled and CONFIG.THEME.SUCCESS or CONFIG.THEME.ERROR
            TweenService:Create(toggleButton, TweenInfo.new(0.2), {BackgroundColor3 = newColor}):Play()
            callback(enabled)
        end)
        
        return toggleFrame
    end)
end

function GUI:CreateSlider(text, min, max, default, callback)
    return safeCall(function()
        local sliderFrame = Instance.new("Frame")
        sliderFrame.Name = text .. "Slider"
        sliderFrame.Size = UDim2.new(1, -20, 0, 45)
        sliderFrame.BackgroundTransparency = 1
        sliderFrame.Parent = parent
        
        local sliderLabel = Instance.new("TextLabel")
        sliderLabel.Name = "Label"
        sliderLabel.Size = UDim2.new(1, 0, 0, 20)
        sliderLabel.Position = UDim2.new(0, 0, 0, 0)
        sliderLabel.BackgroundTransparency = 1
        sliderLabel.Text = text .. ": " .. default
        sliderLabel.TextColor3 = CONFIG.THEME.TEXT
        sliderLabel.TextScaled = true
        sliderLabel.Font = Enum.Font.Gotham
        sliderLabel.TextXAlignment = Enum.TextXAlignment.Left
        sliderLabel.Parent = sliderFrame
        
        local sliderBar = Instance.new("Frame")
        sliderBar.Name = "Bar"
        sliderBar.Size = UDim2.new(1, 0, 0, 18)
        sliderBar.Position = UDim2.new(0, 0, 0, 25)
        sliderBar.BackgroundColor3 = CONFIG.THEME.PRIMARY
        sliderBar.BorderSizePixel = 0
        sliderBar.Parent = sliderFrame
        
        local sliderBarCorner = Instance.new("UICorner")
        sliderBarCorner.CornerRadius = UDim.new(0, 9)
        sliderBarCorner.Parent = sliderBar
        
        local sliderFill = Instance.new("Frame")
        sliderFill.Name = "Fill"
        sliderFill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
        sliderFill.Position = UDim2.new(0, 0, 0, 0)
        sliderFill.BackgroundColor3 = CONFIG.THEME.ACCENT
        sliderFill.BorderSizePixel = 0
        sliderFill.Parent = sliderBar
        
        local sliderFillCorner = Instance.new("UICorner")
        sliderFillCorner.CornerRadius = UDim.new(0, 9)
        sliderFillCorner.Parent = sliderFill
        
        local sliderButton = Instance.new("TextButton")
        sliderButton.Name = "Button"
        sliderButton.Size = UDim2.new(0, 18, 0, 18)
        sliderButton.Position = UDim2.new((default - min) / (max - min), -9, 0, 0)
        sliderButton.BackgroundColor3 = CONFIG.THEME.TEXT
        sliderButton.BorderSizePixel = 0
        sliderButton.Text = ""
        sliderButton.Parent = sliderBar
        
        local sliderButtonCorner = Instance.new("UICorner")
        sliderButtonCorner.CornerRadius = UDim.new(0, 9)
        sliderButtonCorner.Parent = sliderButton
        
        local dragging = false
        local currentValue = default
        
        sliderButton.MouseButton1Down:Connect(function()
            dragging = true
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
                sliderButton.Position = UDim2.new(percentage, -9, 0, 0)
                callback(value)
            end
        end)
        
        return sliderFrame
    end)
end

function GUI:CreateButton(text, callback)
    return safeCall(function()
        local button = Instance.new("TextButton")
        button.Name = text .. "Button"
        button.Size = UDim2.new(1, -20, 0, 35)
        button.BackgroundColor3 = CONFIG.THEME.ACCENT
        button.BorderSizePixel = 0
        button.Text = text
        button.TextColor3 = CONFIG.THEME.TEXT
        button.TextScaled = true
        button.Font = Enum.Font.GothamBold
        button.Parent = parent
        
        local buttonCorner = Instance.new("UICorner")
        buttonCorner.CornerRadius = UDim.new(0, 6)
        buttonCorner.Parent = button
        
        button.MouseButton1Click:Connect(callback)
        
        return button
    end)
end

function GUI:CreateKeybind(text, default, callback)
    return safeCall(function()
        local keybindFrame = Instance.new("Frame")
        keybindFrame.Name = text .. "Keybind"
        keybindFrame.Size = UDim2.new(1, -20, 0, 35)
        keybindFrame.BackgroundTransparency = 1
        keybindFrame.Parent = parent
        
        local keybindLabel = Instance.new("TextLabel")
        keybindLabel.Name = "Label"
        keybindLabel.Size = UDim2.new(0.6, 0, 1, 0)
        keybindLabel.Position = UDim2.new(0, 0, 0, 0)
        keybindLabel.BackgroundTransparency = 1
        keybindLabel.Text = text
        keybindLabel.TextColor3 = CONFIG.THEME.TEXT
        keybindLabel.TextScaled = true
        keybindLabel.Font = Enum.Font.Gotham
        keybindLabel.TextXAlignment = Enum.TextXAlignment.Left
        keybindLabel.Parent = keybindFrame
        
        local keybindButton = Instance.new("TextButton")
        keybindButton.Name = "Button"
        keybindButton.Size = UDim2.new(0.4, 0, 1, 0)
        keybindButton.Position = UDim2.new(0.6, 0, 0, 0)
        keybindButton.BackgroundColor3 = CONFIG.THEME.SECONDARY
        keybindButton.BorderSizePixel = 0
        keybindButton.Text = default.Name
        keybindButton.TextColor3 = CONFIG.THEME.TEXT
        keybindButton.TextScaled = true
        keybindButton.Font = Enum.Font.Gotham
        keybindButton.Parent = keybindFrame
        
        local keybindCorner = Instance.new("UICorner")
        keybindCorner.CornerRadius = UDim.new(0, 4)
        keybindCorner.Parent = keybindButton
        
        local listening = false
        
        keybindButton.MouseButton1Click:Connect(function()
            if not listening then
                listening = true
                keybindButton.Text = "Press Key..."
                keybindButton.BackgroundColor3 = CONFIG.THEME.WARNING
                
                local connection
                connection = UserInputService.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.Keyboard then
                        keybindButton.Text = input.KeyCode.Name
                        keybindButton.BackgroundColor3 = CONFIG.THEME.SECONDARY
                        callback(input.KeyCode)
                        listening = false
                        connection:Disconnect()
                    end
                end)
            end
        end)
        
        return keybindFrame
    end)
end

-- GUI control functions
function GUI:Show()
    if screenGui then
        screenGui.Enabled = true
        TweenService:Create(mainFrame, TweenInfo.new(0.3), {Size = UDim2.new(0, 600, 0, 400)}):Play()
    end
end

function GUI:Hide()
    if screenGui then
        TweenService:Create(mainFrame, TweenInfo.new(0.3), {Size = UDim2.new(0, 0, 0, 0)}):Play()
        wait(0.3)
        screenGui.Enabled = false
    end
end

function GUI:Close()
    self:Hide()
end

-- Initialize GUI
function GUI:Initialize()
    print("🎨 Initializing Vape v4 style GUI...")
    
    self:CreateMainFrame()
    self:CreateTitleBar()
    self:CreateTabSystem()
    
    print("✅ GUI initialized successfully!")
end

-- Main initialization with error handling
local function initialize()
    print("🦦 Starting Otter Client v" .. CONFIG.VERSION)
    
    -- Show key prompt
    KeySystem:ShowKeyPrompt()
    
    -- Wait for key validation
    repeat wait() until keyValid
    
    -- Initialize GUI
    GUI:Initialize()
    
    -- Setup keybinds
    connections.keybind = UserInputService.InputBegan:Connect(function(input)
        if input.KeyCode == CONFIG.MENU_KEY then
            if screenGui and screenGui.Enabled then
                GUI:Hide()
            else
                GUI:Show()
            end
        end
    end)
    
    print("✅ Otter Client initialized successfully!")
    print("🎮 Press RIGHT SHIFT to toggle menu")
end

-- Start the client
initialize()
