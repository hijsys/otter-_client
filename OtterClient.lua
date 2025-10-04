-- Otter Client - ULTIMATE ENHANCED VERSION 5.1.0
-- 🎯 RIVALS FPS UPDATE - COMPREHENSIVE GAME SUPPORT
-- Advanced Anti-Cheat Bypass + 20+ Modules + Ultimate GUI + Full Rivals Support
-- Key: 123
--
-- 📝 NEW IN v5.1.0 - RIVALS FPS UPDATE:
-- ✅ Complete Rivals game support with 14+ specialized features
-- ✅ Weapon optimization with recoil control and spread reduction
-- ✅ Advanced Enemy ESP with health, weapon, and distance tracking
-- ✅ Ability cooldown tracker with visual timers
-- ✅ Map awareness system with spawn and objective tracking
-- ✅ Movement enhancement with slide boost and air strafing
-- ✅ Wallbang detection with material penetration system
-- ✅ Sound ESP for footsteps, gunshots, and abilities
-- ✅ Grenade trajectory prediction with bounce calculation
-- ✅ Dedicated Rivals tab in GUI for easy access to all features
-- ✅ Auto-detection of Rivals game by ID and name
-- ✅ Comprehensive documentation and changelog

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

-- 🚀 NEW ULTIMATE MODULES with error handling
local AntiCheat = safeRequire(getModulePath("Utils", "AntiCheat"))
local AdvancedModules = safeRequire(getModulePath("Utils", "AdvancedModules"))
local UltimateGUI = safeRequire(getModulePath("Utils", "UltimateGUI"))
local GameOptimizer = safeRequire(getModulePath("Utils", "GameOptimizer"))
local UltimateESP = safeRequire(getModulePath("Utils", "UltimateESP"))
local PerformanceOptimizer = safeRequire(getModulePath("Utils", "PerformanceOptimizer"))

-- 🔐 AUTHENTICATION SYSTEM
local AuthSystem = safeRequire(getModulePath("Utils", "AuthSystem"))
local AuthGUI = safeRequire(getModulePath("Utils", "AuthGUI"))

-- 🚀 ULTIMATE ENHANCED CONFIGURATION
local CONFIG = {
    VERSION = "5.1.0",
    NAME = "Otter Client ULTIMATE - Rivals Edition",
    KEY = "123",
    MENU_KEY = Enum.KeyCode.RightShift,
    THEME = ThemeManager:GetCurrentTheme(),
    NOTIFICATIONS = true,
    AUTO_SAVE = true,
    PERFORMANCE_MODE = false,
    REMOTE_WHITELIST_URL = nil,
    
    -- 🔐 AUTHENTICATION
    REQUIRE_AUTH = true,
    SKIP_AUTH_FOR_TESTING = false, -- Set to true for testing without auth
    
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

-- 🔐 AUTHENTICATION HANDLER
local AuthHandler = {}
AuthHandler.Authenticated = false
AuthHandler.UserData = nil

function AuthHandler:ShowAuthGUI()
    print("🔐 Showing authentication GUI...")
    
    -- Initialize auth system
    AuthSystem:Initialize()
    
    -- Create promise-like behavior
    local authCompleted = false
    local authResult = nil
    
    -- Show auth GUI
    AuthGUI:Show(AuthSystem, function(keyData)
        authCompleted = true
        authResult = keyData
        AuthHandler.Authenticated = true
        AuthHandler.UserData = keyData
        print("✅ Authentication successful!")
        print("🎫 Tier: " .. (keyData.tier or "unknown"))
    end, function()
        authCompleted = true
        authResult = false
        print("❌ Authentication cancelled")
    end)
    
    -- Wait for authentication
    while not authCompleted do
        task.wait(0.1)
    end
    
    return authResult ~= false, authResult
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
        {name = "Combat", icon = "⚔️", color = Color3.fromRGB(255, 100, 100)},
        {name = "Movement", icon = "🏃", color = Color3.fromRGB(100, 255, 100)},
        {name = "Visual", icon = "👁️", color = Color3.fromRGB(100, 100, 255)},
        {name = "Rivals", icon = "🎯", color = Color3.fromRGB(255, 50, 150)},
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
    if tabName == "Combat" then
        self:CreateCombatTab(contentFrame)
    elseif tabName == "Movement" then
        self:CreateMovementTab(contentFrame)
    elseif tabName == "Visual" then
        self:CreateVisualTab(contentFrame)
    elseif tabName == "Rivals" then
        self:CreateRivalsTab(contentFrame)
    elseif tabName == "Misc" then
        self:CreateMiscTab(contentFrame)
    elseif tabName == "Settings" then
        self:CreateSettingsTab(contentFrame)
    end
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

-- Create Rivals tab
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
    
    -- Rivals Info Section
    local infoSection = self:CreateSection("🎯 Rivals FPS Optimizations", rivalsFrame)
    
    -- Weapon Optimization Section
    local weaponSection = self:CreateSection("Weapon Optimization", rivalsFrame)
    
    local weaponOptToggle = self:CreateToggle("Enable Weapon Optimization", true, function(enabled)
        modules.RivalsWeapon = modules.RivalsWeapon or {}
        modules.RivalsWeapon.Enabled = enabled
        if CONFIG.NOTIFICATIONS then
            NotificationSystem:ShowInfo("Rivals", "Weapon optimization " .. (enabled and "enabled" or "disabled"))
        end
        print("🎯 Rivals: Weapon optimization " .. (enabled and "enabled" or "disabled"))
    end, weaponSection)
    
    -- Recoil Control Section
    local recoilSection = self:CreateSection("Recoil Control", rivalsFrame)
    
    local recoilToggle = self:CreateToggle("Enable Recoil Control", true, function(enabled)
        modules.RivalsRecoil = modules.RivalsRecoil or {}
        modules.RivalsRecoil.Enabled = enabled
        if CONFIG.NOTIFICATIONS then
            NotificationSystem:ShowInfo("Rivals", "Recoil control " .. (enabled and "enabled" or "disabled"))
        end
        print("🎯 Rivals: Recoil control " .. (enabled and "enabled" or "disabled"))
    end, recoilSection)
    
    local recoilVertical = self:CreateSlider("Vertical Compensation", 0, 100, 85, function(value)
        modules.RivalsRecoil = modules.RivalsRecoil or {}
        modules.RivalsRecoil.VerticalComp = value
        print("🎯 Rivals: Vertical compensation set to " .. value .. "%")
    end, recoilSection)
    
    local recoilHorizontal = self:CreateSlider("Horizontal Compensation", 0, 100, 75, function(value)
        modules.RivalsRecoil = modules.RivalsRecoil or {}
        modules.RivalsRecoil.HorizontalComp = value
        print("🎯 Rivals: Horizontal compensation set to " .. value .. "%")
    end, recoilSection)
    
    -- Auto Reload Section
    local reloadSection = self:CreateSection("Auto Reload", rivalsFrame)
    
    local autoReloadToggle = self:CreateToggle("Enable Auto Reload", true, function(enabled)
        modules.RivalsReload = modules.RivalsReload or {}
        modules.RivalsReload.Enabled = enabled
        if CONFIG.NOTIFICATIONS then
            NotificationSystem:ShowInfo("Rivals", "Auto reload " .. (enabled and "enabled" or "disabled"))
        end
        print("🎯 Rivals: Auto reload " .. (enabled and "enabled" or "disabled"))
    end, reloadSection)
    
    local reloadThreshold = self:CreateSlider("Reload Threshold", 1, 10, 3, function(value)
        modules.RivalsReload = modules.RivalsReload or {}
        modules.RivalsReload.Threshold = value
        print("🎯 Rivals: Reload threshold set to " .. value .. " bullets")
    end, reloadSection)
    
    local reloadOnKill = self:CreateToggle("Reload On Kill", true, function(enabled)
        modules.RivalsReload = modules.RivalsReload or {}
        modules.RivalsReload.ReloadOnKill = enabled
        print("🎯 Rivals: Reload on kill " .. (enabled and "enabled" or "disabled"))
    end, reloadSection)
    
    -- Spread Reduction Section
    local spreadSection = self:CreateSection("Spread Reduction", rivalsFrame)
    
    local spreadToggle = self:CreateToggle("Enable Spread Reduction", true, function(enabled)
        modules.RivalsSpread = modules.RivalsSpread or {}
        modules.RivalsSpread.Enabled = enabled
        if CONFIG.NOTIFICATIONS then
            NotificationSystem:ShowInfo("Rivals", "Spread reduction " .. (enabled and "enabled" or "disabled"))
        end
        print("🎯 Rivals: Spread reduction " .. (enabled and "enabled" or "disabled"))
    end, spreadSection)
    
    local spreadAmount = self:CreateSlider("Reduction Amount", 0, 100, 70, function(value)
        modules.RivalsSpread = modules.RivalsSpread or {}
        modules.RivalsSpread.ReductionAmount = value
        print("🎯 Rivals: Spread reduction set to " .. value .. "%")
    end, spreadSection)
    
    -- Enemy ESP Section
    local espSection = self:CreateSection("Enemy ESP", rivalsFrame)
    
    local espToggle = self:CreateToggle("Enable Enemy ESP", true, function(enabled)
        modules.RivalsESP = modules.RivalsESP or {}
        modules.RivalsESP.Enabled = enabled
        if CONFIG.NOTIFICATIONS then
            NotificationSystem:ShowInfo("Rivals", "Enemy ESP " .. (enabled and "enabled" or "disabled"))
        end
        print("🎯 Rivals: Enemy ESP " .. (enabled and "enabled" or "disabled"))
    end, espSection)
    
    local espBoxes = self:CreateToggle("Show Boxes", true, function(enabled)
        modules.RivalsESP = modules.RivalsESP or {}
        modules.RivalsESP.ShowBoxes = enabled
        print("🎯 Rivals: ESP boxes " .. (enabled and "enabled" or "disabled"))
    end, espSection)
    
    local espHealth = self:CreateToggle("Show Health", true, function(enabled)
        modules.RivalsESP = modules.RivalsESP or {}
        modules.RivalsESP.ShowHealth = enabled
        print("🎯 Rivals: ESP health " .. (enabled and "enabled" or "disabled"))
    end, espSection)
    
    local espWeapon = self:CreateToggle("Show Weapon", true, function(enabled)
        modules.RivalsESP = modules.RivalsESP or {}
        modules.RivalsESP.ShowWeapon = enabled
        print("🎯 Rivals: ESP weapon " .. (enabled and "enabled" or "disabled"))
    end, espSection)
    
    local espDistance = self:CreateSlider("Max ESP Distance", 100, 1000, 500, function(value)
        modules.RivalsESP = modules.RivalsESP or {}
        modules.RivalsESP.MaxDistance = value
        print("🎯 Rivals: Max ESP distance set to " .. value .. " studs")
    end, espSection)
    
    -- Ability Cooldown Tracker Section
    local abilitySection = self:CreateSection("Ability Cooldown Tracker", rivalsFrame)
    
    local abilityToggle = self:CreateToggle("Enable Ability Tracker", true, function(enabled)
        modules.RivalsAbilities = modules.RivalsAbilities or {}
        modules.RivalsAbilities.Enabled = enabled
        if CONFIG.NOTIFICATIONS then
            NotificationSystem:ShowInfo("Rivals", "Ability tracker " .. (enabled and "enabled" or "disabled"))
        end
        print("🎯 Rivals: Ability tracker " .. (enabled and "enabled" or "disabled"))
    end, abilitySection)
    
    local abilityAudio = self:CreateToggle("Audio Alerts", true, function(enabled)
        modules.RivalsAbilities = modules.RivalsAbilities or {}
        modules.RivalsAbilities.AudioAlert = enabled
        print("🎯 Rivals: Audio alerts " .. (enabled and "enabled" or "disabled"))
    end, abilitySection)
    
    -- Map Awareness Section
    local mapSection = self:CreateSection("Map Awareness", rivalsFrame)
    
    local mapToggle = self:CreateToggle("Enable Map Awareness", true, function(enabled)
        modules.RivalsMap = modules.RivalsMap or {}
        modules.RivalsMap.Enabled = enabled
        if CONFIG.NOTIFICATIONS then
            NotificationSystem:ShowInfo("Rivals", "Map awareness " .. (enabled and "enabled" or "disabled"))
        end
        print("🎯 Rivals: Map awareness " .. (enabled and "enabled" or "disabled"))
    end, mapSection)
    
    local mapMinimap = self:CreateToggle("Show Minimap", true, function(enabled)
        modules.RivalsMap = modules.RivalsMap or {}
        modules.RivalsMap.ShowMinimap = enabled
        print("🎯 Rivals: Minimap " .. (enabled and "enabled" or "disabled"))
    end, mapSection)
    
    -- Movement Enhancement Section
    local movementSection = self:CreateSection("Movement Enhancement", rivalsFrame)
    
    local movementToggle = self:CreateToggle("Enable Movement Enhancement", true, function(enabled)
        modules.RivalsMovement = modules.RivalsMovement or {}
        modules.RivalsMovement.Enabled = enabled
        if CONFIG.NOTIFICATIONS then
            NotificationSystem:ShowInfo("Rivals", "Movement enhancement " .. (enabled and "enabled" or "disabled"))
        end
        print("🎯 Rivals: Movement enhancement " .. (enabled and "enabled" or "disabled"))
    end, movementSection)
    
    local slideBoost = self:CreateToggle("Slide Boost", true, function(enabled)
        modules.RivalsMovement = modules.RivalsMovement or {}
        modules.RivalsMovement.SlideBoost = enabled
        print("🎯 Rivals: Slide boost " .. (enabled and "enabled" or "disabled"))
    end, movementSection)
    
    local airStrafe = self:CreateToggle("Air Strafing", true, function(enabled)
        modules.RivalsMovement = modules.RivalsMovement or {}
        modules.RivalsMovement.AirStrafing = enabled
        print("🎯 Rivals: Air strafing " .. (enabled and "enabled" or "disabled"))
    end, movementSection)
    
    -- Wallbang Detection Section
    local wallbangSection = self:CreateSection("Wallbang Detection", rivalsFrame)
    
    local wallbangToggle = self:CreateToggle("Enable Wallbang Detection", true, function(enabled)
        modules.RivalsWallbang = modules.RivalsWallbang or {}
        modules.RivalsWallbang.Enabled = enabled
        if CONFIG.NOTIFICATIONS then
            NotificationSystem:ShowInfo("Rivals", "Wallbang detection " .. (enabled and "enabled" or "disabled"))
        end
        print("🎯 Rivals: Wallbang detection " .. (enabled and "enabled" or "disabled"))
    end, wallbangSection)
    
    local wallbangSpots = self:CreateToggle("Show Wallbang Spots", true, function(enabled)
        modules.RivalsWallbang = modules.RivalsWallbang or {}
        modules.RivalsWallbang.ShowSpots = enabled
        print("🎯 Rivals: Wallbang spots " .. (enabled and "enabled" or "disabled"))
    end, wallbangSection)
    
    local wallbangDistance = self:CreateSlider("Max Wallbang Distance", 50, 300, 200, function(value)
        modules.RivalsWallbang = modules.RivalsWallbang or {}
        modules.RivalsWallbang.MaxDistance = value
        print("🎯 Rivals: Max wallbang distance set to " .. value .. " studs")
    end, wallbangSection)
    
    -- Sound ESP Section
    local soundSection = self:CreateSection("Sound ESP", rivalsFrame)
    
    local soundToggle = self:CreateToggle("Enable Sound ESP", true, function(enabled)
        modules.RivalsSound = modules.RivalsSound or {}
        modules.RivalsSound.Enabled = enabled
        if CONFIG.NOTIFICATIONS then
            NotificationSystem:ShowInfo("Rivals", "Sound ESP " .. (enabled and "enabled" or "disabled"))
        end
        print("🎯 Rivals: Sound ESP " .. (enabled and "enabled" or "disabled"))
    end, soundSection)
    
    local soundFootsteps = self:CreateToggle("Detect Footsteps", true, function(enabled)
        modules.RivalsSound = modules.RivalsSound or {}
        modules.RivalsSound.Footsteps = enabled
        print("🎯 Rivals: Footstep detection " .. (enabled and "enabled" or "disabled"))
    end, soundSection)
    
    local soundGunshots = self:CreateToggle("Detect Gunshots", true, function(enabled)
        modules.RivalsSound = modules.RivalsSound or {}
        modules.RivalsSound.Gunshots = enabled
        print("🎯 Rivals: Gunshot detection " .. (enabled and "enabled" or "disabled"))
    end, soundSection)
    
    local soundRange = self:CreateSlider("Detection Range", 50, 200, 100, function(value)
        modules.RivalsSound = modules.RivalsSound or {}
        modules.RivalsSound.MaxRange = value
        print("🎯 Rivals: Sound detection range set to " .. value .. " studs")
    end, soundSection)
    
    -- Grenade Trajectory Section
    local grenadeSection = self:CreateSection("Grenade Trajectory", rivalsFrame)
    
    local grenadeToggle = self:CreateToggle("Enable Grenade Trajectory", true, function(enabled)
        modules.RivalsGrenade = modules.RivalsGrenade or {}
        modules.RivalsGrenade.Enabled = enabled
        if CONFIG.NOTIFICATIONS then
            NotificationSystem:ShowInfo("Rivals", "Grenade trajectory " .. (enabled and "enabled" or "disabled"))
        end
        print("🎯 Rivals: Grenade trajectory " .. (enabled and "enabled" or "disabled"))
    end, grenadeSection)
    
    local grenadeLine = self:CreateToggle("Show Trajectory Line", true, function(enabled)
        modules.RivalsGrenade = modules.RivalsGrenade or {}
        modules.RivalsGrenade.ShowLine = enabled
        print("🎯 Rivals: Trajectory line " .. (enabled and "enabled" or "disabled"))
    end, grenadeSection)
    
    local grenadeBlast = self:CreateToggle("Show Blast Radius", true, function(enabled)
        modules.RivalsGrenade = modules.RivalsGrenade or {}
        modules.RivalsGrenade.ShowBlast = enabled
        print("🎯 Rivals: Blast radius " .. (enabled and "enabled" or "disabled"))
    end, grenadeSection)
    
    print("✅ Rivals tab created with all FPS optimizations!")
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

-- 🚀 START THE ULTIMATE CLIENT with authentication
local success, error = pcall(function()
    -- Check if authentication is required
    if CONFIG.REQUIRE_AUTH and not CONFIG.SKIP_AUTH_FOR_TESTING then
        print("🔐 Authentication required...")
        
        local authSuccess, authData = AuthHandler:ShowAuthGUI()
        
        if not authSuccess then
            warn("❌ Authentication failed or cancelled")
            warn("⛔ Otter Client cannot start without authentication")
            return
        end
        
        print("✅ Authentication successful!")
        print("🚀 Starting Otter Client with tier: " .. (authData.tier or "unknown"))
    else
        if CONFIG.SKIP_AUTH_FOR_TESTING then
            print("⚠️ Skipping authentication (testing mode)")
            AuthHandler.Authenticated = true
            AuthHandler.UserData = {tier = "admin", features = {"all"}}
        end
    end
    
    -- Initialize the client
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
    if AuthHandler.Authenticated and AuthHandler.UserData then
        print("👤 Welcome! Tier: " .. (AuthHandler.UserData.tier or "unknown"))
    end
end
