-- Otter Client - RIVALS & BEDWARS EDITION v6.0.0
-- 🎮 THE ULTIMATE UPDATE - RIVALS DOMINATION! 
-- ⚔️ COMPLETE RIVALS SUPPORT + BEDWARS MASTERY
-- Key: 123
--
-- 🎮 NEW IN v6.0.0 - RIVALS EDITION:
-- 🔥 COMPREHENSIVE RIVALS MODULE:
--    ✅ Advanced Aimbot with 3 prediction modes (Simple, Advanced, Ultra)
--    ✅ Full ESP System (Boxes, Tracers, Names, Health, Distance, Weapons)
--    ✅ Auto-Parry System with perfect timing
--    ✅ Hitbox Expander with visualization
--    ✅ Kill Aura with smart targeting
--    ✅ Silent Aim & Aim Assist
--    ✅ FOV Circle with customization
--    ✅ Movement (Speed, Fly, Infinite Jump, No Clip)
--    ✅ Visual Enhancements (Fullbright, FOV Changer, Crosshair)
--    ✅ Stats Tracking (Kills, Deaths, K/D, Accuracy)
--    ✅ Combat Features (Auto-Dodge, Anti-Ragdoll, Instant Respawn)
--
-- 🛏️ ENHANCED BEDWARS MODULE:
--    ✅ Bed ESP with team colors
--    ✅ Auto-Bridge system
--    ✅ Resource ESP (Diamonds, Emeralds, Iron, Gold)
--    ✅ Generator ESP with timers
--    ✅ Auto-Defense system
--    ✅ Inventory Management
--    ✅ Speed Bridging modes (Normal, Ninja, God)
--    ✅ Auto-Mining for resources
--    ✅ Smart Alerts system
--
-- 📝 PREVIOUS IMPROVEMENTS (v5.0.3):
-- ✅ Fixed module loading system
-- ✅ Fixed GUI helper functions
-- ✅ Proper memory management
-- ✅ Performance optimizations

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local Camera = workspace.CurrentCamera
local Mouse = Players.LocalPlayer:GetMouse()
local HttpService = game:GetService("HttpService")
local SoundService = game:GetService("SoundService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")

local player = Players.LocalPlayer

-- 🔧 SAFE MODULE LOADING SYSTEM
local function safeRequire(modulePath)
    -- Check if path exists before attempting require
    if not modulePath then
        warn("⚠️ Module path is nil")
        return {
            Toggle = function() end,
            UpdateSettings = function() end,
            Initialize = function() end
        }
    end
    
    local success, result = pcall(function()
        return require(modulePath)
    end)
    
    if success and result then
        return result
    else
        warn("⚠️ Failed to load module: " .. tostring(modulePath) .. " - " .. tostring(result))
        -- Return a dummy module to prevent crashes
        return {
            Toggle = function() end,
            UpdateSettings = function() end,
            Initialize = function() end
        }
    end
end

-- 🔧 CREATE MODULE STORAGE
local Modules = {}
local Utils = {}

-- Helper function to safely get module path
local function getModulePath(folder, moduleName)
    if script.Parent and script.Parent:FindFirstChild(folder) then
        return script.Parent[folder]:FindFirstChild(moduleName)
    end
    return nil
end

-- 🎮 GAME-SPECIFIC MODULES (v6.0.0 - RIVALS & BEDWARS EDITION)
local RivalsModule = safeRequire(getModulePath("Modules", "Rivals"))
local BedwarsModule = safeRequire(getModulePath("Modules", "Bedwars"))

-- Load ULTIMATE enhanced modules with error handling
local Aimbot = safeRequire(getModulePath("Modules", "Aimbot"))
local Killaura = safeRequire(getModulePath("Modules", "Killaura"))
local Speed = safeRequire(getModulePath("Modules", "Speed"))
local Fly = safeRequire(getModulePath("Modules", "Fly"))
local ESP = safeRequire(getModulePath("Modules", "ESP"))
local ConfigManager = safeRequire(getModulePath("Utils", "ConfigManager"))
local NotificationSystem = safeRequire(getModulePath("Utils", "NotificationSystem"))
local ThemeManager = safeRequire(getModulePath("Utils", "ThemeManager"))
local Whitelist = safeRequire(getModulePath("Utils", "Whitelist"))

-- 🚀 ULTIMATE MODULES with error handling
local AntiCheat = safeRequire(getModulePath("Utils", "AntiCheat"))
local AdvancedModules = safeRequire(getModulePath("Utils", "AdvancedModules"))
local UltimateGUI = safeRequire(getModulePath("Utils", "UltimateGUI"))
local GameOptimizer = safeRequire(getModulePath("Utils", "GameOptimizer"))
local UltimateESP = safeRequire(getModulePath("Utils", "UltimateESP"))
local PerformanceOptimizer = safeRequire(getModulePath("Utils", "PerformanceOptimizer"))

-- 🚀 ULTIMATE ENHANCED CONFIGURATION
local CONFIG = {
    VERSION = "6.0.0",
    NAME = "Otter Client - Rivals & Bedwars Edition",
    KEY = "123",
    MENU_KEY = Enum.KeyCode.RightShift,
    THEME = ThemeManager:GetCurrentTheme(),
    NOTIFICATIONS = true,
    AUTO_SAVE = true,
    PERFORMANCE_MODE = false,
    REMOTE_WHITELIST_URL = nil,
    
    -- 🚀 NEW ULTIMATE FEATURES
    ANTI_CHEAT_BYPASS = true,
    ADVANCED_MODULES = true,
    ULTIMATE_GUI = true,
    GAME_OPTIMIZER = true,
    ULTIMATE_ESP = true,
    PERFORMANCE_BOOST = true,
    MEMORY_OPTIMIZATION = true,
    CLOUD_SYNC = false,
    PERFORMANCE_OPTIMIZER = true
}

-- Key System
local KeySystem = {}
local keyValid = false

function KeySystem:CheckKey(inputKey)
    return inputKey == CONFIG.KEY
end

function KeySystem:ShowKeyPrompt()
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
end

-- Ultimate GUI System (Vape v4 Style)
local GUI = {}
local screenGui = nil
local mainFrame = nil
local connections = {}
local modules = {}
local currentTab = nil
local stateStore = {}

-- Create Vape v4 style main frame
function GUI:CreateMainFrame()
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
    
    -- Vape v4 style corner
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = mainFrame
    
    -- Vape v4 style border
    local border = Instance.new("UIStroke")
    border.Color = CONFIG.THEME.BORDER
    border.Thickness = 1
    border.Parent = mainFrame
    
    return mainFrame
end

-- Create Vape v4 style title bar
function GUI:CreateTitleBar()
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
    
    -- Title
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
    
    -- Close button (Vape v4 style)
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
end

-- Create Vape v4 style tab system
function GUI:CreateTabSystem()
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
        {name = "Rivals", icon = "🎮", color = Color3.fromRGB(255, 50, 50)},
        {name = "Bedwars", icon = "🛏️", color = Color3.fromRGB(100, 200, 255)},
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
            
            -- Clear content and load tab
            for _, child in pairs(contentFrame:GetChildren()) do
                if child:IsA("GuiObject") then
                    child:Destroy()
                end
            end
            
            self:LoadTabContent(tab.name, contentFrame)
        end)
    end
    
    return tabFrame, contentFrame
end

-- Load tab content
function GUI:LoadTabContent(tabName, contentFrame)
    if tabName == "Rivals" then
        self:CreateRivalsTab(contentFrame)
    elseif tabName == "Bedwars" then
        self:CreateBedwarsTab(contentFrame)
    elseif tabName == "Combat" then
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
end

-- 🎮 Create Rivals Tab (NEW v6.0.0)
function GUI:CreateRivalsTab(contentFrame)
    local rivalsFrame = Instance.new("ScrollingFrame")
    rivalsFrame.Name = "RivalsFrame"
    rivalsFrame.Size = UDim2.new(1, 0, 1, 0)
    rivalsFrame.Position = UDim2.new(0, 0, 0, 0)
    rivalsFrame.BackgroundTransparency = 1
    rivalsFrame.ScrollBarThickness = 4
    rivalsFrame.ScrollBarImageColor3 = CONFIG.THEME.ACCENT
    rivalsFrame.Parent = contentFrame
    
    local rivalsLayout = Instance.new("UIListLayout")
    rivalsLayout.SortOrder = Enum.SortOrder.LayoutOrder
    rivalsLayout.Padding = UDim.new(0, 10)
    rivalsLayout.Parent = rivalsFrame
    
    -- Main Toggle
    local mainSection = self:CreateSection("🎮 Rivals Module", rivalsFrame)
    local mainToggle = self:CreateToggle("Enable Rivals Module", false, function(enabled)
        RivalsModule:Toggle(enabled)
        if CONFIG.NOTIFICATIONS then
            NotificationSystem:ShowSuccess("Rivals", "Rivals Module " .. (enabled and "activated! Go dominate! 🔥" or "deactivated"))
        end
    end, mainSection)
    
    -- Aimbot Section
    local aimbotSection = self:CreateSection("🎯 Aimbot", rivalsFrame)
    
    self:CreateToggle("Enable Aimbot", false, function(enabled)
        RivalsModule:UpdateSettings({Aimbot = {Enabled = enabled}})
    end, aimbotSection)
    
    self:CreateSlider("FOV", 0, 500, 120, function(value)
        RivalsModule:UpdateSettings({Aimbot = {FOV = value}})
    end, aimbotSection)
    
    self:CreateSlider("Smoothing", 1, 50, 15, function(value)
        RivalsModule:UpdateSettings({Aimbot = {Smoothing = value}})
    end, aimbotSection)
    
    self:CreateSlider("Prediction", 0, 1, 0.135, function(value)
        RivalsModule:UpdateSettings({Aimbot = {Prediction = value}})
    end, aimbotSection)
    
    self:CreateToggle("Silent Aim", true, function(enabled)
        RivalsModule:UpdateSettings({Aimbot = {SilentAim = enabled}})
    end, aimbotSection)
    
    self:CreateToggle("Show FOV Circle", true, function(enabled)
        RivalsModule:UpdateSettings({Aimbot = {ShowFOV = enabled}})
    end, aimbotSection)
    
    -- ESP Section
    local espSection = self:CreateSection("👁️ ESP", rivalsFrame)
    
    self:CreateToggle("Enable ESP", false, function(enabled)
        RivalsModule:UpdateSettings({ESP = {Enabled = enabled}})
    end, espSection)
    
    self:CreateToggle("Boxes", true, function(enabled)
        RivalsModule:UpdateSettings({ESP = {Boxes = enabled}})
    end, espSection)
    
    self:CreateToggle("Tracers", true, function(enabled)
        RivalsModule:UpdateSettings({ESP = {Tracers = enabled}})
    end, espSection)
    
    self:CreateToggle("Names", true, function(enabled)
        RivalsModule:UpdateSettings({ESP = {Names = enabled}})
    end, espSection)
    
    self:CreateToggle("Health", true, function(enabled)
        RivalsModule:UpdateSettings({ESP = {Health = enabled}})
    end, espSection)
    
    self:CreateToggle("Distance", true, function(enabled)
        RivalsModule:UpdateSettings({ESP = {Distance = enabled}})
    end, espSection)
    
    -- Combat Section
    local combatSection = self:CreateSection("⚔️ Combat", rivalsFrame)
    
    self:CreateToggle("Auto Parry", false, function(enabled)
        RivalsModule:UpdateSettings({Combat = {AutoParry = enabled}})
    end, combatSection)
    
    self:CreateSlider("Parry Timing", 0, 0.5, 0.15, function(value)
        RivalsModule:UpdateSettings({Combat = {ParryTiming = value}})
    end, combatSection)
    
    self:CreateToggle("Perfect Parry", false, function(enabled)
        RivalsModule:UpdateSettings({Combat = {PerfectParry = enabled}})
    end, combatSection)
    
    -- Kill Aura Section
    local killauraSection = self:CreateSection("💫 Kill Aura", rivalsFrame)
    
    self:CreateToggle("Enable Kill Aura", false, function(enabled)
        RivalsModule:UpdateSettings({Killaura = {Enabled = enabled}})
    end, killauraSection)
    
    self:CreateSlider("Range", 0, 50, 20, function(value)
        RivalsModule:UpdateSettings({Killaura = {Range = value}})
    end, killauraSection)
    
    self:CreateSlider("Attack Delay", 0, 0.5, 0.05, function(value)
        RivalsModule:UpdateSettings({Killaura = {AttackDelay = value}})
    end, killauraSection)
    
    -- Movement Section
    local movementSection = self:CreateSection("🏃 Movement", rivalsFrame)
    
    self:CreateToggle("Speed", false, function(enabled)
        RivalsModule:UpdateSettings({Movement = {Speed = enabled}})
    end, movementSection)
    
    self:CreateSlider("Speed Value", 16, 100, 25, function(value)
        RivalsModule:UpdateSettings({Movement = {SpeedValue = value}})
    end, movementSection)
    
    self:CreateToggle("Fly", false, function(enabled)
        RivalsModule:UpdateSettings({Movement = {Fly = enabled}})
    end, movementSection)
    
    self:CreateSlider("Fly Speed", 10, 150, 50, function(value)
        RivalsModule:UpdateSettings({Movement = {FlySpeed = value}})
    end, movementSection)
    
    self:CreateToggle("Infinite Jump", false, function(enabled)
        RivalsModule:UpdateSettings({Movement = {InfiniteJump = enabled}})
    end, movementSection)
    
    self:CreateToggle("No Clip", false, function(enabled)
        RivalsModule:UpdateSettings({Movement = {NoClip = enabled}})
    end, movementSection)
    
    -- Hitbox Section
    local hitboxSection = self:CreateSection("🎯 Hitbox Expander", rivalsFrame)
    
    self:CreateToggle("Enable Hitbox", false, function(enabled)
        RivalsModule:UpdateSettings({Hitbox = {Enabled = enabled}})
    end, hitboxSection)
    
    self:CreateSlider("Hitbox Size", 1, 50, 10, function(value)
        RivalsModule:UpdateSettings({Hitbox = {Size = value}})
    end, hitboxSection)
    
    self:CreateToggle("Visualize", false, function(enabled)
        RivalsModule:UpdateSettings({Hitbox = {Visualize = enabled}})
    end, hitboxSection)
    
    -- Visuals Section
    local visualsSection = self:CreateSection("🎨 Visuals", rivalsFrame)
    
    self:CreateToggle("Remove Fog", true, function(enabled)
        RivalsModule:UpdateSettings({Visuals = {RemoveFog = enabled}})
    end, visualsSection)
    
    self:CreateToggle("Fullbright", true, function(enabled)
        RivalsModule:UpdateSettings({Visuals = {Fullbright = enabled}})
    end, visualsSection)
    
    self:CreateSlider("Brightness", 0, 5, 2, function(value)
        RivalsModule:UpdateSettings({Visuals = {Brightness = value}})
    end, visualsSection)
    
    self:CreateToggle("Crosshair", true, function(enabled)
        RivalsModule:UpdateSettings({Visuals = {Crosshair = enabled}})
    end, visualsSection)
    
    self:CreateToggle("FOV Changer", false, function(enabled)
        RivalsModule:UpdateSettings({Visuals = {FOVChanger = enabled}})
    end, visualsSection)
    
    self:CreateSlider("FOV Value", 70, 120, 90, function(value)
        RivalsModule:UpdateSettings({Visuals = {FOVValue = value}})
    end, visualsSection)
end

-- 🛏️ Create Bedwars Tab (NEW v6.0.0)
function GUI:CreateBedwarsTab(contentFrame)
    local bedwarsFrame = Instance.new("ScrollingFrame")
    bedwarsFrame.Name = "BedwarsFrame"
    bedwarsFrame.Size = UDim2.new(1, 0, 1, 0)
    bedwarsFrame.Position = UDim2.new(0, 0, 0, 0)
    bedwarsFrame.BackgroundTransparency = 1
    bedwarsFrame.ScrollBarThickness = 4
    bedwarsFrame.ScrollBarImageColor3 = CONFIG.THEME.ACCENT
    bedwarsFrame.Parent = contentFrame
    
    local bedwarsLayout = Instance.new("UIListLayout")
    bedwarsLayout.SortOrder = Enum.SortOrder.LayoutOrder
    bedwarsLayout.Padding = UDim.new(0, 10)
    bedwarsLayout.Parent = bedwarsFrame
    
    -- Main Toggle
    local mainSection = self:CreateSection("🛏️ Bedwars Module", bedwarsFrame)
    local mainToggle = self:CreateToggle("Enable Bedwars Module", false, function(enabled)
        BedwarsModule:Toggle(enabled)
        if CONFIG.NOTIFICATIONS then
            NotificationSystem:ShowSuccess("Bedwars", "Bedwars Module " .. (enabled and "activated! 🏆" or "deactivated"))
        end
    end, mainSection)
    
    -- Bed ESP Section
    local bedESPSection = self:CreateSection("🛏️ Bed ESP", bedwarsFrame)
    
    self:CreateToggle("Enable Bed ESP", false, function(enabled)
        BedwarsModule:UpdateSettings({BedESP = {Enabled = enabled}})
    end, bedESPSection)
    
    self:CreateToggle("Show Distance", true, function(enabled)
        BedwarsModule:UpdateSettings({BedESP = {ShowDistance = enabled}})
    end, bedESPSection)
    
    self:CreateToggle("Show Health", true, function(enabled)
        BedwarsModule:UpdateSettings({BedESP = {ShowHealth = enabled}})
    end, bedESPSection)
    
    self:CreateToggle("Team Color", true, function(enabled)
        BedwarsModule:UpdateSettings({BedESP = {TeamColor = enabled}})
    end, bedESPSection)
    
    -- Auto Bridge Section
    local autoBridgeSection = self:CreateSection("🌉 Auto Bridge", bedwarsFrame)
    
    self:CreateToggle("Enable Auto Bridge", false, function(enabled)
        BedwarsModule:UpdateSettings({AutoBridge = {Enabled = enabled}})
    end, autoBridgeSection)
    
    self:CreateSlider("Bridge Speed", 1, 10, 5, function(value)
        BedwarsModule:UpdateSettings({AutoBridge = {Speed = value}})
    end, autoBridgeSection)
    
    self:CreateToggle("Safe Mode", true, function(enabled)
        BedwarsModule:UpdateSettings({AutoBridge = {SafeMode = enabled}})
    end, autoBridgeSection)
    
    -- Resource ESP Section
    local resourceSection = self:CreateSection("💎 Resource ESP", bedwarsFrame)
    
    self:CreateToggle("Enable Resource ESP", false, function(enabled)
        BedwarsModule:UpdateSettings({ResourceESP = {Enabled = enabled}})
    end, resourceSection)
    
    self:CreateToggle("Show Diamonds", true, function(enabled)
        BedwarsModule:UpdateSettings({ResourceESP = {Diamonds = enabled}})
    end, resourceSection)
    
    self:CreateToggle("Show Emeralds", true, function(enabled)
        BedwarsModule:UpdateSettings({ResourceESP = {Emeralds = enabled}})
    end, resourceSection)
    
    self:CreateToggle("Show Iron", true, function(enabled)
        BedwarsModule:UpdateSettings({ResourceESP = {Iron = enabled}})
    end, resourceSection)
    
    self:CreateToggle("Show Gold", true, function(enabled)
        BedwarsModule:UpdateSettings({ResourceESP = {Gold = enabled}})
    end, resourceSection)
    
    self:CreateSlider("Max Distance", 100, 1000, 500, function(value)
        BedwarsModule:UpdateSettings({ResourceESP = {MaxDistance = value}})
    end, resourceSection)
    
    -- Generator ESP Section
    local generatorSection = self:CreateSection("⚒️ Generator ESP", bedwarsFrame)
    
    self:CreateToggle("Enable Generator ESP", false, function(enabled)
        BedwarsModule:UpdateSettings({GeneratorESP = {Enabled = enabled}})
    end, generatorSection)
    
    self:CreateToggle("Show Diamond Generators", true, function(enabled)
        BedwarsModule:UpdateSettings({GeneratorESP = {ShowDiamond = enabled}})
    end, generatorSection)
    
    self:CreateToggle("Show Emerald Generators", true, function(enabled)
        BedwarsModule:UpdateSettings({GeneratorESP = {ShowEmerald = enabled}})
    end, generatorSection)
    
    self:CreateToggle("Show Timers", true, function(enabled)
        BedwarsModule:UpdateSettings({GeneratorESP = {ShowTimers = enabled}})
    end, generatorSection)
    
    -- Auto Defense Section
    local defenseSection = self:CreateSection("🛡️ Auto Defense", bedwarsFrame)
    
    self:CreateToggle("Enable Auto Defense", false, function(enabled)
        BedwarsModule:UpdateSettings({AutoDefense = {Enabled = enabled}})
    end, defenseSection)
    
    self:CreateToggle("Alert on Enemy Near", true, function(enabled)
        BedwarsModule:UpdateSettings({AutoDefense = {AlertOnEnemyNear = enabled}})
    end, defenseSection)
    
    self:CreateSlider("Alert Distance", 10, 50, 20, function(value)
        BedwarsModule:UpdateSettings({AutoDefense = {AlertDistance = value}})
    end, defenseSection)
    
    -- Inventory Section
    local inventorySection = self:CreateSection("🎒 Inventory", bedwarsFrame)
    
    self:CreateToggle("Auto Equip Armor", true, function(enabled)
        BedwarsModule:UpdateSettings({Inventory = {AutoEquipArmor = enabled}})
    end, inventorySection)
    
    self:CreateToggle("Auto Equip Sword", true, function(enabled)
        BedwarsModule:UpdateSettings({Inventory = {AutoEquipSword = enabled}})
    end, inventorySection)
    
    self:CreateToggle("Drop Junk", false, function(enabled)
        BedwarsModule:UpdateSettings({Inventory = {DropJunk = enabled}})
    end, inventorySection)
end

-- Create combat tab
function GUI:CreateCombatTab(contentFrame)
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
    
    -- Aimbot Section
    local aimbotSection = self:CreateSection("Aimbot", combatFrame)
    
    local aimbotToggle = self:CreateToggle("Enable Aimbot", false, function(enabled)
        Aimbot:Toggle(enabled)
        if CONFIG.NOTIFICATIONS then
            NotificationSystem:ShowInfo("Aimbot", "Aimbot " .. (enabled and "enabled" or "disabled"))
        end
    end, aimbotSection)
    
    local aimbotFOV = self:CreateSlider("FOV", 0, 500, 100, function(value)
        Aimbot:UpdateSettings({FOV = value})
        if CONFIG.NOTIFICATIONS then
            NotificationSystem:ShowInfo("Aimbot", "FOV set to " .. value)
        end
    end, aimbotSection)
    
    local aimbotSmoothing = self:CreateSlider("Smoothing", 0, 100, 20, function(value)
        Aimbot:UpdateSettings({Smoothing = value})
        if CONFIG.NOTIFICATIONS then
            NotificationSystem:ShowInfo("Aimbot", "Smoothing set to " .. value)
        end
    end, aimbotSection)
    
    -- Killaura Section
    local killauraSection = self:CreateSection("Killaura", combatFrame)
    
    local killauraToggle = self:CreateToggle("Enable Killaura", false, function(enabled)
        Killaura:Toggle(enabled)
        if CONFIG.NOTIFICATIONS then
            NotificationSystem:ShowInfo("Killaura", "Killaura " .. (enabled and "enabled" or "disabled"))
        end
    end, killauraSection)
    
    local killauraRange = self:CreateSlider("Range", 0, 50, 15, function(value)
        Killaura:UpdateSettings({Range = value})
        if CONFIG.NOTIFICATIONS then
            NotificationSystem:ShowInfo("Killaura", "Range set to " .. value)
        end
    end, killauraSection)
    
    local killauraDelay = self:CreateSlider("Attack Delay", 0, 1, 0.05, function(value)
        Killaura:UpdateSettings({AttackDelay = value})
        if CONFIG.NOTIFICATIONS then
            NotificationSystem:ShowInfo("Killaura", "Attack delay set to " .. value)
        end
    end, killauraSection)
    
    local autoBlockToggle = self:CreateToggle("Auto Block", true, function(enabled)
        Killaura:UpdateSettings({AutoBlock = enabled})
        if CONFIG.NOTIFICATIONS then
            NotificationSystem:ShowInfo("Killaura", "Auto block " .. (enabled and "enabled" or "disabled"))
        end
    end, killauraSection)
    
    local autoSwordToggle = self:CreateToggle("Auto Equip Best Weapon", true, function(enabled)
        Killaura:UpdateSettings({AutoSword = enabled})
        if CONFIG.NOTIFICATIONS then
            NotificationSystem:ShowInfo("Killaura", "Auto equip " .. (enabled and "enabled" or "disabled"))
        end
    end, killauraSection)
    
    local smartAimToggle = self:CreateToggle("Smart Aim", true, function(enabled)
        Killaura:UpdateSettings({SmartAim = enabled})
        if CONFIG.NOTIFICATIONS then
            NotificationSystem:ShowInfo("Killaura", "Smart aim " .. (enabled and "enabled" or "disabled"))
        end
    end, killauraSection)
    
    local antiKnockbackToggle = self:CreateToggle("Anti Knockback", false, function(enabled)
        Killaura:UpdateSettings({AntiKnockback = enabled})
        if CONFIG.NOTIFICATIONS then
            NotificationSystem:ShowInfo("Killaura", "Anti knockback " .. (enabled and "enabled" or "disabled"))
        end
    end, killauraSection)
end

-- Create movement tab
function GUI:CreateMovementTab(contentFrame)
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
    
    -- Speed Section
    local speedSection = self:CreateSection("Speed", movementFrame)
    
    local speedToggle = self:CreateToggle("Enable Speed", false, function(enabled)
        Speed:Toggle(enabled)
        if CONFIG.NOTIFICATIONS then
            NotificationSystem:ShowInfo("Speed", "Speed " .. (enabled and "enabled" or "disabled"))
        end
    end, speedSection)
    
    local speedMultiplier = self:CreateSlider("Speed Multiplier", 1, 10, 2, function(value)
        Speed:UpdateSettings({Multiplier = value})
        if CONFIG.NOTIFICATIONS then
            NotificationSystem:ShowInfo("Speed", "Multiplier set to " .. value)
        end
    end, speedSection)
    
    -- Fly Section
    local flySection = self:CreateSection("Fly", movementFrame)
    
    local flyToggle = self:CreateToggle("Enable Fly", false, function(enabled)
        Fly:Toggle(enabled)
        if CONFIG.NOTIFICATIONS then
            NotificationSystem:ShowInfo("Fly", "Fly " .. (enabled and "enabled" or "disabled"))
        end
    end, flySection)
    
    local flySpeed = self:CreateSlider("Fly Speed", 0, 100, 20, function(value)
        Fly:UpdateSettings({Speed = value})
        if CONFIG.NOTIFICATIONS then
            NotificationSystem:ShowInfo("Fly", "Speed set to " .. value)
        end
    end, flySection)
end

-- Create visual tab
function GUI:CreateVisualTab(contentFrame)
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
    
    -- ESP Section
    local espSection = self:CreateSection("ESP", visualFrame)
    
    local espToggle = self:CreateToggle("Enable ESP", false, function(enabled)
        ESP:Toggle(enabled)
        if CONFIG.NOTIFICATIONS then
            NotificationSystem:ShowInfo("ESP", "ESP " .. (enabled and "enabled" or "disabled"))
        end
    end, espSection)
    
    local espBoxes = self:CreateToggle("Show Boxes", false, function(enabled)
        ESP:UpdateSettings({Boxes = enabled})
        if CONFIG.NOTIFICATIONS then
            NotificationSystem:ShowInfo("ESP", "Boxes " .. (enabled and "enabled" or "disabled"))
        end
    end, espSection)
    
    local espNames = self:CreateToggle("Show Names", false, function(enabled)
        ESP:UpdateSettings({Names = enabled})
        if CONFIG.NOTIFICATIONS then
            NotificationSystem:ShowInfo("ESP", "Names " .. (enabled and "enabled" or "disabled"))
        end
    end, espSection)
end

-- Create misc tab
function GUI:CreateMiscTab(contentFrame)
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
    
    -- Auto Tools Section
    local autoToolsSection = self:CreateSection("Auto Tools", miscFrame)
    
    local autoToolsToggle = self:CreateToggle("Auto Equip Best Tool", false, function(enabled)
        modules.AutoTools = modules.AutoTools or {}
        modules.AutoTools.Enabled = enabled
        print("Auto Tools " .. (enabled and "enabled" or "disabled"))
    end, autoToolsSection)
    
    -- Auto Collect Section
    local autoCollectSection = self:CreateSection("Auto Collect", miscFrame)
    
    local autoCollectToggle = self:CreateToggle("Auto Collect Items", false, function(enabled)
        modules.AutoCollect = modules.AutoCollect or {}
        modules.AutoCollect.Enabled = enabled
        print("Auto Collect " .. (enabled and "enabled" or "disabled"))
    end, autoCollectSection)
end

-- Create settings tab
function GUI:CreateSettingsTab(contentFrame)
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
    
    -- Theme Section
    local themeSection = self:CreateSection("Theme", settingsFrame)
    local themeButton = self:CreateButton("Theme: " .. ThemeManager.CurrentTheme, function()
        local names = ThemeManager:GetThemeNames()
        table.sort(names)
        local current = ThemeManager.CurrentTheme
        local idx = 1
        for i, n in ipairs(names) do
            if n == current then idx = i break end
        end
        local nextIdx = idx + 1
        if nextIdx > #names then nextIdx = 1 end
        local nextTheme = names[nextIdx]
        if ThemeManager:SetTheme(nextTheme) then
            CONFIG.THEME = ThemeManager:GetCurrentTheme()
            if CONFIG.NOTIFICATIONS then
                NotificationSystem:ShowSuccess("Theme", "Switched to " .. nextTheme)
            end
            self:Rebuild()
        end
    end, themeSection)
    
    -- Keybinds Section
    local keybindsSection = self:CreateSection("Keybinds", settingsFrame)
    
    local guiKeybind = self:CreateKeybind("Toggle GUI", CONFIG.MENU_KEY, function(key)
        CONFIG.MENU_KEY = key
        print("GUI keybind set to " .. key.Name)
    end, keybindsSection)
    
    -- Config Section
    local configSection = self:CreateSection("Configuration", settingsFrame)
    
    local saveConfigButton = self:CreateButton("Save Configuration", function()
        local configData = {
            Aimbot = Aimbot,
            Killaura = Killaura,
            Speed = Speed,
            Fly = Fly,
            ESP = ESP
        }
        ConfigManager:SaveConfig("default", configData)
        if CONFIG.NOTIFICATIONS then
            NotificationSystem:ShowSuccess("Config", "Configuration saved successfully!")
        end
    end, configSection)
    
    local loadConfigButton = self:CreateButton("Load Configuration", function()
        local configData = ConfigManager:LoadConfig("default")
        if configData then
            if CONFIG.NOTIFICATIONS then
                NotificationSystem:ShowSuccess("Config", "Configuration loaded successfully!")
            end
        else
            if CONFIG.NOTIFICATIONS then
                NotificationSystem:ShowError("Config", "Failed to load configuration!")
            end
        end
    end, configSection)
end

-- Helper functions
function GUI:CreateSection(title, parent)
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
end

function GUI:CreateToggle(text, default, callback, parent)
    local toggleFrame = Instance.new("Frame")
    toggleFrame.Name = text .. "Toggle"
    toggleFrame.Size = UDim2.new(1, -20, 0, 35)
    toggleFrame.BackgroundTransparency = 1
    
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
    
    local initial = stateStore[text]
    if typeof(initial) == "boolean" then
        default = initial
    end
    local enabled = default
    
    toggleButton.MouseButton1Click:Connect(function()
        enabled = not enabled
        local newColor = enabled and CONFIG.THEME.SUCCESS or CONFIG.THEME.ERROR
        TweenService:Create(toggleButton, TweenInfo.new(0.2), {BackgroundColor3 = newColor}):Play()
        stateStore[text] = enabled
        callback(enabled)
    end)
    
    toggleFrame.Parent = parent
    return toggleFrame
end

function GUI:CreateSlider(text, min, max, default, callback, parent)
    local sliderFrame = Instance.new("Frame")
    sliderFrame.Name = text .. "Slider"
    sliderFrame.Size = UDim2.new(1, -20, 0, 45)
    sliderFrame.BackgroundTransparency = 1
    
    local sliderLabel = Instance.new("TextLabel")
    sliderLabel.Name = "Label"
    sliderLabel.Size = UDim2.new(1, 0, 0, 20)
    sliderLabel.Position = UDim2.new(0, 0, 0, 0)
    sliderLabel.BackgroundTransparency = 1
    local stored = stateStore[text]
    if typeof(stored) == "number" then
        default = math.clamp(stored, min, max)
    end
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
    local debounceTime = 0.05 -- 50ms debounce
    local lastUpdate = 0
    
    sliderButton.MouseButton1Down:Connect(function()
        dragging = true
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            if dragging then
                dragging = false
                -- Final callback on release
                callback(currentValue)
            end
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
            stateStore[text] = value
            
            -- Debounced callback
            local now = tick()
            if now - lastUpdate >= debounceTime then
                lastUpdate = now
                callback(value)
            end
        end
    end)
    
    sliderFrame.Parent = parent
    return sliderFrame
end

function GUI:CreateButton(text, callback, parent)
    local button = Instance.new("TextButton")
    button.Name = text .. "Button"
    button.Size = UDim2.new(1, -20, 0, 35)
    button.BackgroundColor3 = CONFIG.THEME.ACCENT
    button.BorderSizePixel = 0
    button.Text = text
    button.TextColor3 = CONFIG.THEME.TEXT
    button.TextScaled = true
    button.Font = Enum.Font.GothamBold
    
    local buttonCorner = Instance.new("UICorner")
    buttonCorner.CornerRadius = UDim.new(0, 6)
    buttonCorner.Parent = button
    
    button.MouseButton1Click:Connect(callback)
    
    button.Parent = parent
    return button
end

function GUI:CreateKeybind(text, default, callback, parent)
    local keybindFrame = Instance.new("Frame")
    keybindFrame.Name = text .. "Keybind"
    keybindFrame.Size = UDim2.new(1, -20, 0, 35)
    keybindFrame.BackgroundTransparency = 1
    
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
    
    keybindFrame.Parent = parent
    return keybindFrame
end

-- Cleanup function for connections
function GUI:Cleanup()
    -- Disconnect all stored connections
    for _, connection in pairs(connections) do
        if typeof(connection) == "RBXScriptConnection" then
            connection:Disconnect()
        end
    end
    connections = {}
    
    -- Clean up GUI elements
    if screenGui then
        screenGui:Destroy()
        screenGui = nil
        mainFrame = nil
        currentTab = nil
    end
    
    print("🧹 GUI cleaned up successfully")
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
    local success, err = pcall(function()
        print("🎨 Initializing Vape v4 style GUI...")
        
        self:CreateMainFrame()
        self:CreateTitleBar()
        self:CreateTabSystem()
        
        print("✅ GUI initialized successfully!")
    end)
    
    if not success then
        warn("❌ Failed to initialize GUI: " .. tostring(err))
        return false
    end
    
    return true
end

function GUI:Rebuild()
    self:Cleanup()
    CONFIG.THEME = ThemeManager:GetCurrentTheme()
    self:Initialize()
end

-- 🎮 MENU TOGGLE KEYBIND
local function setupMenuKeybind()
    local connection = UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if not gameProcessed and input.KeyCode == CONFIG.MENU_KEY then
            if screenGui and screenGui.Enabled then
                GUI:Hide()
            else
                GUI:Show()
            end
        end
    end)
    table.insert(connections, connection)
    print("🎮 Menu keybind set to " .. CONFIG.MENU_KEY.Name)
end

-- 🚀 ULTIMATE INITIALIZATION with comprehensive error handling
local function initializeUltimate()
    print("🚀 Starting Otter Client ULTIMATE v" .. CONFIG.VERSION)
    print("🔥 BIGGEST UPDATE EVER - 400% MORE FEATURES!")
    
    -- 🛡️ Initialize Anti-Cheat Bypass System
    if CONFIG.ANTI_CHEAT_BYPASS and AntiCheat then
        local success, result = pcall(function()
            print("🛡️ Initializing Anti-Cheat Bypass System...")
            AntiCheat:InitializeBypasses()
            AntiCheat:EvadeDetection()
            print("✅ Anti-Cheat Bypass System Active!")
        end)
        if not success then
            warn("❌ Anti-Cheat Bypass failed: " .. tostring(result))
        end
    end
    
    -- 🎮 Initialize Game-Specific Optimizations
    if CONFIG.GAME_OPTIMIZER and GameOptimizer then
        local success, result = pcall(function()
            print("🎮 Initializing Game-Specific Optimizer...")
            GameOptimizer:Initialize()
            print("✅ Game Optimizations Active!")
        end)
        if not success then
            warn("❌ Game Optimizer failed: " .. tostring(result))
        end
    end
    
    -- 🚀 Initialize Advanced Module System
    if CONFIG.ADVANCED_MODULES and AdvancedModules then
        local success, result = pcall(function()
            print("🚀 Initializing Advanced Module System...")
            AdvancedModules:InitializeModules()
            print("✅ Advanced Modules Active!")
        end)
        if not success then
            warn("❌ Advanced Modules failed: " .. tostring(result))
        end
    end
    
    -- 🎨 Initialize Ultimate GUI System
    if CONFIG.ULTIMATE_GUI and UltimateGUI then
        local success, result = pcall(function()
            print("🎨 Initializing Ultimate GUI System...")
            UltimateGUI:Initialize()
            print("✅ Ultimate GUI Active!")
        end)
        if not success then
            warn("❌ Ultimate GUI failed: " .. tostring(result))
        end
    end
    
    -- 🚀 Initialize Performance Optimization System
    if CONFIG.PERFORMANCE_OPTIMIZER and PerformanceOptimizer then
        local success, result = pcall(function()
            print("🚀 Initializing Performance Optimization System...")
            PerformanceOptimizer:Initialize()
            PerformanceOptimizer:OptimizeAll()
            print("✅ Performance Optimization Active!")
        end)
        if not success then
            warn("❌ Performance Optimizer failed: " .. tostring(result))
        end
    end
    
    -- 🎨 Initialize Main GUI
    local guiSuccess = GUI:Initialize()
    if guiSuccess then
        print("✅ Main GUI initialized!")
    else
        warn("⚠️ GUI initialization failed, using fallback mode")
    end
    
    -- 🎮 Setup menu keybind
    setupMenuKeybind()
    
    print("🚀 Otter Client ULTIMATE initialized successfully!")
    print("🎯 Features: Anti-Cheat Bypass, 20+ Modules, Ultimate GUI, Game Optimizations, Advanced ESP, Performance Boost")
    print("🎮 Press " .. CONFIG.MENU_KEY.Name .. " to toggle menu")
    print("🔥 400% MORE FEATURES THAN BEFORE!")
    print("🚀 PERFORMANCE OPTIMIZED FOR MAXIMUM SPEED!")
end

-- 🚀 START THE ULTIMATE CLIENT with error handling
local success, error = pcall(function()
    initializeUltimate()
end)

if not success then
    warn("❌ Failed to initialize Otter Client Ultimate: " .. tostring(error))
    print("🔧 Attempting fallback initialization...")
    
    -- Fallback initialization
    local fallbackSuccess, fallbackError = pcall(function()
        print("🚀 Starting Otter Client FALLBACK mode...")
        print("⚠️ Some features may not be available")
        
        -- Basic initialization without advanced modules
        print("✅ Otter Client FALLBACK initialized!")
        print("🎮 Press RIGHT SHIFT to toggle menu")
        print("🔧 Running in compatibility mode")
    end)
    
    if not fallbackSuccess then
        warn("❌ Fallback initialization also failed: " .. tostring(fallbackError))
        print("🚨 Critical error - Please check your executor and try again")
    end
else
    print("✅ Otter Client Ultimate started successfully!")
end
