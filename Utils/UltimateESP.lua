-- 👁️ ULTIMATE ESP SYSTEM - 3D BOXES & TRACERS
-- Advanced ESP with professional features
-- Version: 5.0.0 - Ultimate ESP

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Camera = workspace.CurrentCamera
local TweenService = game:GetService("TweenService")

local UltimateESP = {}
UltimateESP.Objects = {}
UltimateESP.Settings = {}
UltimateESP.Connections = {}
UltimateESP.Enabled = false

-- 🎨 ESP SETTINGS
UltimateESP.Settings = {
    Enabled = false,
    Boxes = true,
    Tracers = true,
    Names = true,
    Health = true,
    Distance = true,
    Skeletons = false,
    Chams = false,
    Glow = false,
    TeamCheck = true,
    VisibleCheck = true,
    TeamColors = true,
    EnemyColor = Color3.fromRGB(255, 0, 0),
    TeamColor = Color3.fromRGB(0, 255, 0),
    VisibleColor = Color3.fromRGB(255, 255, 0),
    HiddenColor = Color3.fromRGB(255, 0, 255),
    BoxThickness = 2,
    TracerThickness = 2,
    TextSize = 14,
    TextFont = Enum.Font.GothamBold
}

-- 🎯 ESP OBJECT CREATION
function UltimateESP:CreateESPObject(player)
    local espObject = {
        Player = player,
        Box = nil,
        Tracer = nil,
        NameLabel = nil,
        HealthLabel = nil,
        DistanceLabel = nil,
        Skeleton = nil,
        Cham = nil,
        Glow = nil,
        Connections = {}
    }
    
    return espObject
end

-- 📦 3D BOX CREATION
function UltimateESP:Create3DBox(espObject)
    local player = espObject.Player
    local character = player.Character
    
    if not character or not character:FindFirstChild("HumanoidRootPart") then
        return
    end
    
    local humanoidRootPart = character.HumanoidRootPart
    local humanoid = character:FindFirstChild("Humanoid")
    
    if not humanoid then
        return
    end
    
    -- Create 3D box
    local box = Instance.new("BoxHandleAdornment")
    box.Name = "ESPBox"
    box.Adornee = humanoidRootPart
    box.AlwaysOnTop = true
    box.ZIndex = 10
    box.Size = Vector3.new(4, humanoid.HipHeight + 2, 2)
    box.Color3 = self:GetPlayerColor(player)
    box.Transparency = 0.3
    box.Parent = Camera
    
    espObject.Box = box
    
    -- Add corner details
    local corners = {}
    for i = 1, 8 do
        local corner = Instance.new("BoxHandleAdornment")
        corner.Name = "ESPCorner"
        corner.Adornee = humanoidRootPart
        corner.AlwaysOnTop = true
        corner.ZIndex = 11
        corner.Size = Vector3.new(0.2, 0.2, 0.2)
        corner.Color3 = self:GetPlayerColor(player)
        corner.Transparency = 0
        corner.Parent = Camera
        table.insert(corners, corner)
    end
    
    espObject.Corners = corners
end

-- 📏 TRACER CREATION
function UltimateESP:CreateTracer(espObject)
    local player = espObject.Player
    local character = player.Character
    
    if not character or not character:FindFirstChild("HumanoidRootPart") then
        return
    end
    
    local humanoidRootPart = character.HumanoidRootPart
    
    -- Create tracer
    local tracer = Instance.new("LineHandleAdornment")
    tracer.Name = "ESPTracer"
    tracer.Adornee = humanoidRootPart
    tracer.AlwaysOnTop = true
    tracer.ZIndex = 5
    tracer.Color3 = self:GetPlayerColor(player)
    tracer.Transparency = 0.5
    tracer.Thickness = self.Settings.TracerThickness
    tracer.Parent = Camera
    
    -- Set tracer points
    local screenPosition = Camera:WorldToViewportPoint(humanoidRootPart.Position)
    tracer.PointA = Vector2.new(screenPosition.X, screenPosition.Y)
    tracer.PointB = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y)
    
    espObject.Tracer = tracer
end

-- 🏷️ NAME LABEL CREATION
function UltimateESP:CreateNameLabel(espObject)
    local player = espObject.Player
    local character = player.Character
    
    if not character or not character:FindFirstChild("HumanoidRootPart") then
        return
    end
    
    local humanoidRootPart = character.HumanoidRootPart
    
    -- Create name label
    local nameLabel = Instance.new("TextLabel")
    nameLabel.Name = "ESPName"
    nameLabel.Size = UDim2.new(0, 200, 0, 20)
    nameLabel.BackgroundTransparency = 1
    nameLabel.Text = player.Name
    nameLabel.TextColor3 = self:GetPlayerColor(player)
    nameLabel.TextSize = self.Settings.TextSize
    nameLabel.TextFont = self.Settings.TextFont
    nameLabel.TextStrokeTransparency = 0
    nameLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    nameLabel.Parent = Camera
    
    espObject.NameLabel = nameLabel
end

-- ❤️ HEALTH LABEL CREATION
function UltimateESP:CreateHealthLabel(espObject)
    local player = espObject.Player
    local character = player.Character
    
    if not character or not character:FindFirstChild("HumanoidRootPart") then
        return
    end
    
    local humanoidRootPart = character.HumanoidRootPart
    local humanoid = character:FindFirstChild("Humanoid")
    
    if not humanoid then
        return
    end
    
    -- Create health label
    local healthLabel = Instance.new("TextLabel")
    healthLabel.Name = "ESPHealth"
    healthLabel.Size = UDim2.new(0, 100, 0, 20)
    healthLabel.BackgroundTransparency = 1
    healthLabel.Text = "❤️ " .. math.floor(humanoid.Health) .. "/" .. math.floor(humanoid.MaxHealth)
    healthLabel.TextColor3 = self:GetHealthColor(humanoid.Health, humanoid.MaxHealth)
    healthLabel.TextSize = self.Settings.TextSize
    healthLabel.TextFont = self.Settings.TextFont
    healthLabel.TextStrokeTransparency = 0
    healthLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    healthLabel.Parent = Camera
    
    espObject.HealthLabel = healthLabel
end

-- 📏 DISTANCE LABEL CREATION
function UltimateESP:CreateDistanceLabel(espObject)
    local player = espObject.Player
    local character = player.Character
    
    if not character or not character:FindFirstChild("HumanoidRootPart") then
        return
    end
    
    local humanoidRootPart = character.HumanoidRootPart
    
    -- Create distance label
    local distanceLabel = Instance.new("TextLabel")
    distanceLabel.Name = "ESPDistance"
    distanceLabel.Size = UDim2.new(0, 100, 0, 20)
    distanceLabel.BackgroundTransparency = 1
    distanceLabel.Text = "📏 " .. math.floor((humanoidRootPart.Position - Camera.CFrame.Position).Magnitude) .. "m"
    distanceLabel.TextColor3 = self:GetPlayerColor(player)
    distanceLabel.TextSize = self.Settings.TextSize
    distanceLabel.TextFont = self.Settings.TextFont
    distanceLabel.TextStrokeTransparency = 0
    distanceLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    distanceLabel.Parent = Camera
    
    espObject.DistanceLabel = distanceLabel
end

-- 🦴 SKELETON CREATION
function UltimateESP:CreateSkeleton(espObject)
    local player = espObject.Player
    local character = player.Character
    
    if not character then
        return
    end
    
    local skeleton = {}
    
    -- Create skeleton connections
    local connections = {
        {"Head", "Neck"},
        {"Neck", "Torso"},
        {"Torso", "Left Shoulder"},
        {"Torso", "Right Shoulder"},
        {"Torso", "Left Hip"},
        {"Torso", "Right Hip"},
        {"Left Shoulder", "Left Arm"},
        {"Right Shoulder", "Right Arm"},
        {"Left Hip", "Left Leg"},
        {"Right Hip", "Right Leg"}
    }
    
    for _, connection in pairs(connections) do
        local part1 = character:FindFirstChild(connection[1])
        local part2 = character:FindFirstChild(connection[2])
        
        if part1 and part2 then
            local line = Instance.new("LineHandleAdornment")
            line.Name = "ESPSkeleton"
            line.Adornee = part1
            line.AlwaysOnTop = true
            line.ZIndex = 8
            line.Color3 = self:GetPlayerColor(player)
            line.Transparency = 0.3
            line.Thickness = 1
            line.Parent = Camera
            
            table.insert(skeleton, line)
        end
    end
    
    espObject.Skeleton = skeleton
end

-- 🎨 CHAMS CREATION
function UltimateESP:CreateChams(espObject)
    local player = espObject.Player
    local character = player.Character
    
    if not character then
        return
    end
    
    local chams = {}
    
    for _, part in pairs(character:GetChildren()) do
        if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
            local cham = Instance.new("BoxHandleAdornment")
            cham.Name = "ESPCham"
            cham.Adornee = part
            cham.AlwaysOnTop = true
            cham.ZIndex = 5
            cham.Size = part.Size
            cham.Color3 = self:GetPlayerColor(player)
            cham.Transparency = 0.5
            cham.Parent = Camera
            
            table.insert(chams, cham)
        end
    end
    
    espObject.Chams = chams
end

-- ✨ GLOW CREATION
function UltimateESP:CreateGlow(espObject)
    local player = espObject.Player
    local character = player.Character
    
    if not character then
        return
    end
    
    local glow = {}
    
    for _, part in pairs(character:GetChildren()) do
        if part:IsA("BasePart") then
            local glowEffect = Instance.new("SelectionBox")
            glowEffect.Name = "ESPGlow"
            glowEffect.Adornee = part
            glowEffect.Color3 = self:GetPlayerColor(player)
            glowEffect.Transparency = 0.3
            glowEffect.LineThickness = 0.1
            glowEffect.Parent = Camera
            
            table.insert(glow, glowEffect)
        end
    end
    
    espObject.Glow = glow
end

-- 🎨 COLOR FUNCTIONS
function UltimateESP:GetPlayerColor(player)
    if self.Settings.TeamCheck and player.Team then
        if player.Team == Players.LocalPlayer.Team then
            return self.Settings.TeamColor
        else
            return self.Settings.EnemyColor
        end
    else
        return self.Settings.EnemyColor
    end
end

function UltimateESP:GetHealthColor(health, maxHealth)
    local percentage = health / maxHealth
    
    if percentage > 0.7 then
        return Color3.fromRGB(0, 255, 0) -- Green
    elseif percentage > 0.3 then
        return Color3.fromRGB(255, 255, 0) -- Yellow
    else
        return Color3.fromRGB(255, 0, 0) -- Red
    end
end

-- 🔄 UPDATE FUNCTIONS
function UltimateESP:UpdateESPObject(espObject)
    local player = espObject.Player
    local character = player.Character
    
    if not character or not character:FindFirstChild("HumanoidRootPart") then
        return
    end
    
    local humanoidRootPart = character.HumanoidRootPart
    local humanoid = character:FindFirstChild("Humanoid")
    
    if not humanoid then
        return
    end
    
    -- Update 3D box
    if espObject.Box then
        espObject.Box.Size = Vector3.new(4, humanoid.HipHeight + 2, 2)
        espObject.Box.Color3 = self:GetPlayerColor(player)
    end
    
    -- Update corners
    if espObject.Corners then
        for _, corner in pairs(espObject.Corners) do
            corner.Color3 = self:GetPlayerColor(player)
        end
    end
    
    -- Update tracer
    if espObject.Tracer then
        local screenPosition = Camera:WorldToViewportPoint(humanoidRootPart.Position)
        espObject.Tracer.PointA = Vector2.new(screenPosition.X, screenPosition.Y)
        espObject.Tracer.Color3 = self:GetPlayerColor(player)
    end
    
    -- Update name label
    if espObject.NameLabel then
        local screenPosition = Camera:WorldToViewportPoint(humanoidRootPart.Position + Vector3.new(0, 3, 0))
        espObject.NameLabel.Position = UDim2.new(0, screenPosition.X - 100, 0, screenPosition.Y)
        espObject.NameLabel.TextColor3 = self:GetPlayerColor(player)
    end
    
    -- Update health label
    if espObject.HealthLabel then
        local screenPosition = Camera:WorldToViewportPoint(humanoidRootPart.Position + Vector3.new(0, 2.5, 0))
        espObject.HealthLabel.Position = UDim2.new(0, screenPosition.X - 50, 0, screenPosition.Y)
        espObject.HealthLabel.Text = "❤️ " .. math.floor(humanoid.Health) .. "/" .. math.floor(humanoid.MaxHealth)
        espObject.HealthLabel.TextColor3 = self:GetHealthColor(humanoid.Health, humanoid.MaxHealth)
    end
    
    -- Update distance label
    if espObject.DistanceLabel then
        local screenPosition = Camera:WorldToViewportPoint(humanoidRootPart.Position + Vector3.new(0, 2, 0))
        espObject.DistanceLabel.Position = UDim2.new(0, screenPosition.X - 50, 0, screenPosition.Y)
        espObject.DistanceLabel.Text = "📏 " .. math.floor((humanoidRootPart.Position - Camera.CFrame.Position).Magnitude) .. "m"
        espObject.DistanceLabel.TextColor3 = self:GetPlayerColor(player)
    end
end

-- 🗑️ CLEANUP FUNCTIONS
function UltimateESP:RemoveESPObject(espObject)
    if espObject.Box then
        espObject.Box:Destroy()
    end
    
    if espObject.Corners then
        for _, corner in pairs(espObject.Corners) do
            corner:Destroy()
        end
    end
    
    if espObject.Tracer then
        espObject.Tracer:Destroy()
    end
    
    if espObject.NameLabel then
        espObject.NameLabel:Destroy()
    end
    
    if espObject.HealthLabel then
        espObject.HealthLabel:Destroy()
    end
    
    if espObject.DistanceLabel then
        espObject.DistanceLabel:Destroy()
    end
    
    if espObject.Skeleton then
        for _, bone in pairs(espObject.Skeleton) do
            bone:Destroy()
        end
    end
    
    if espObject.Chams then
        for _, cham in pairs(espObject.Chams) do
            cham:Destroy()
        end
    end
    
    if espObject.Glow then
        for _, glow in pairs(espObject.Glow) do
            glow:Destroy()
        end
    end
    
    if espObject.Connections then
        for _, connection in pairs(espObject.Connections) do
            connection:Disconnect()
        end
    end
end

-- 🚀 MAIN ESP FUNCTIONS
function UltimateESP:Enable()
    if self.Enabled then
        return
    end
    
    self.Enabled = true
    print("👁️ Ultimate ESP enabled")
    
    -- Create ESP for all players
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= Players.LocalPlayer then
            self:AddPlayer(player)
        end
    end
    
    -- Connect to player added
    self.Connections.PlayerAdded = Players.PlayerAdded:Connect(function(player)
        self:AddPlayer(player)
    end)
    
    -- Connect to player removing
    self.Connections.PlayerRemoving = Players.PlayerRemoving:Connect(function(player)
        self:RemovePlayer(player)
    end)
    
    -- Connect to update loop
    self.Connections.UpdateLoop = RunService.Heartbeat:Connect(function()
        self:UpdateAllESP()
    end)
end

function UltimateESP:Disable()
    if not self.Enabled then
        return
    end
    
    self.Enabled = false
    print("❌ Ultimate ESP disabled")
    
    -- Disconnect all connections
    for _, connection in pairs(self.Connections) do
        connection:Disconnect()
    end
    
    -- Remove all ESP objects
    for _, espObject in pairs(self.Objects) do
        self:RemoveESPObject(espObject)
    end
    
    self.Objects = {}
    self.Connections = {}
end

function UltimateESP:AddPlayer(player)
    local espObject = self:CreateESPObject(player)
    
    if self.Settings.Boxes then
        self:Create3DBox(espObject)
    end
    
    if self.Settings.Tracers then
        self:CreateTracer(espObject)
    end
    
    if self.Settings.Names then
        self:CreateNameLabel(espObject)
    end
    
    if self.Settings.Health then
        self:CreateHealthLabel(espObject)
    end
    
    if self.Settings.Distance then
        self:CreateDistanceLabel(espObject)
    end
    
    if self.Settings.Skeletons then
        self:CreateSkeleton(espObject)
    end
    
    if self.Settings.Chams then
        self:CreateChams(espObject)
    end
    
    if self.Settings.Glow then
        self:CreateGlow(espObject)
    end
    
    self.Objects[player] = espObject
end

function UltimateESP:RemovePlayer(player)
    local espObject = self.Objects[player]
    if espObject then
        self:RemoveESPObject(espObject)
        self.Objects[player] = nil
    end
end

function UltimateESP:UpdateAllESP()
    for _, espObject in pairs(self.Objects) do
        self:UpdateESPObject(espObject)
    end
end

-- ⚙️ SETTINGS FUNCTIONS
function UltimateESP:UpdateSettings(newSettings)
    for key, value in pairs(newSettings) do
        if self.Settings[key] ~= nil then
            self.Settings[key] = value
        end
    end
    
    print("✅ ESP settings updated")
end

function UltimateESP:GetSettings()
    return self.Settings
end

-- 🚀 INITIALIZATION
function UltimateESP:Initialize()
    print("👁️ Initializing Ultimate ESP System...")
    
    print("✅ Ultimate ESP System initialized!")
    print("🎨 Features: 3D Boxes, Tracers, Names, Health, Distance, Skeletons, Chams, Glow")
    
    return true
end

return UltimateESP
