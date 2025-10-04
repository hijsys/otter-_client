-- 🛏️ BEDWARS MODULE - ULTIMATE EDITION v6.0.0
-- 🏆 DOMINATE EVERY BEDWARS MATCH!
-- 🔥 ADVANCED FEATURES FOR COMPETITIVE PLAY

local Bedwars = {}
Bedwars.Name = "Bedwars Ultimate"
Bedwars.Version = "6.0.0"
Bedwars.Enabled = false

-- Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local Camera = Workspace.CurrentCamera

local LocalPlayer = Players.LocalPlayer

-- 🛏️ BEDWARS CONFIGURATION
Bedwars.Settings = {
    -- 🛏️ BED ESP
    BedESP = {
        Enabled = false,
        ShowOwn = false,
        ShowDistance = true,
        ShowHealth = true,
        BoxColor = Color3.fromRGB(255, 0, 0),
        TeamColor = true,
    },
    
    -- 🌉 AUTO BRIDGE
    AutoBridge = {
        Enabled = false,
        Speed = 5,
        BlockType = "Wool",
        SafeMode = true,
        DownwardPlace = true,
        AutoSprint = true,
    },
    
    -- 💎 RESOURCE ESP
    ResourceESP = {
        Enabled = false,
        Diamonds = true,
        Emeralds = true,
        Iron = true,
        Gold = true,
        ShowDistance = true,
        MaxDistance = 500,
    },
    
    -- ⚒️ AUTO MINING
    AutoMine = {
        Enabled = false,
        AutoFarm = true,
        FarmDiamonds = true,
        FarmEmeralds = true,
        FarmIron = true,
        FarmGold = true,
    },
    
    -- 🛡️ AUTO DEFENSE
    AutoDefense = {
        Enabled = false,
        AutoPlace = true,
        PlaceDistance = 3,
        DefenseBlocks = "Wool",
        AlertOnEnemyNear = true,
        AlertDistance = 20,
    },
    
    -- 🎯 GENERATORS
    GeneratorESP = {
        Enabled = false,
        ShowDiamond = true,
        ShowEmerald = true,
        ShowUpgrades = true,
        ShowTimers = true,
    },
    
    -- 🏃 SPEED BRIDGING
    SpeedBridge = {
        Enabled = false,
        Mode = "Ninja", -- Normal, Ninja, God
        AutoJump = true,
        SafeMode = true,
    },
    
    -- 🎒 INVENTORY MANAGEMENT
    Inventory = {
        AutoSort = false,
        AutoEquipArmor = true,
        AutoEquipSword = true,
        DropJunk = false,
        QuickBuy = false,
    },
    
    -- 🚨 ALERTS
    Alerts = {
        BedDestroyed = true,
        EnemyNear = true,
        LowHealth = true,
        ResourcesFull = true,
    }
}

-- 🎯 CONNECTION STORAGE
local connections = {}
local espObjects = {}

-- 🛏️ BED ESP SYSTEM
function Bedwars:FindBeds()
    local beds = {}
    for _, obj in pairs(Workspace:GetDescendants()) do
        if obj.Name:lower():find("bed") and obj:IsA("Model") then
            table.insert(beds, obj)
        end
    end
    return beds
end

function Bedwars:CreateBedESP(bed)
    if espObjects[bed] then return end
    
    local esp = {
        Box = Drawing.new("Square"),
        Text = Drawing.new("Text"),
        Distance = Drawing.new("Text"),
    }
    
    esp.Box.Visible = false
    esp.Box.Filled = false
    esp.Box.Thickness = 2
    esp.Box.Transparency = 1
    esp.Box.Color = self.Settings.BedESP.BoxColor
    
    esp.Text.Visible = false
    esp.Text.Center = true
    esp.Text.Outline = true
    esp.Text.Size = 18
    esp.Text.Color = Color3.fromRGB(255, 255, 255)
    esp.Text.Text = "BED"
    
    esp.Distance.Visible = false
    esp.Distance.Center = true
    esp.Distance.Outline = true
    esp.Distance.Size = 16
    esp.Distance.Color = Color3.fromRGB(255, 255, 0)
    
    espObjects[bed] = esp
end

function Bedwars:UpdateBedESP()
    if not self.Settings.BedESP.Enabled then
        for _, esp in pairs(espObjects) do
            for _, obj in pairs(esp) do
                if obj then obj.Visible = false end
            end
        end
        return
    end
    
    local beds = self:FindBeds()
    
    for _, bed in pairs(beds) do
        if not espObjects[bed] then
            self:CreateBedESP(bed)
        end
        
        local esp = espObjects[bed]
        if bed.PrimaryPart then
            local screenPos, onScreen = Camera:WorldToViewportPoint(bed.PrimaryPart.Position)
            
            if onScreen then
                local distance = (bed.PrimaryPart.Position - Camera.CFrame.Position).Magnitude
                
                esp.Box.Size = Vector2.new(50, 30)
                esp.Box.Position = Vector2.new(screenPos.X - 25, screenPos.Y - 15)
                esp.Box.Visible = true
                
                esp.Text.Position = Vector2.new(screenPos.X, screenPos.Y - 30)
                esp.Text.Visible = true
                
                if self.Settings.BedESP.ShowDistance then
                    esp.Distance.Text = math.floor(distance) .. "m"
                    esp.Distance.Position = Vector2.new(screenPos.X, screenPos.Y + 20)
                    esp.Distance.Visible = true
                end
            else
                for _, obj in pairs(esp) do
                    if obj then obj.Visible = false end
                end
            end
        end
    end
end

-- 🌉 AUTO BRIDGE SYSTEM
function Bedwars:AutoBridge()
    if not self.Settings.AutoBridge.Enabled then return end
    if not LocalPlayer.Character then return end
    
    local humanoidRootPart = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not humanoidRootPart then return end
    
    -- Check if player is at the edge
    local rayOrigin = humanoidRootPart.Position
    local rayDirection = humanoidRootPart.CFrame.LookVector * 3
    local ray = Ray.new(rayOrigin, rayDirection)
    local hit = Workspace:FindPartOnRay(ray, LocalPlayer.Character)
    
    if not hit and self.Settings.AutoBridge.DownwardPlace then
        -- Place block below player
        -- You'll need to implement the actual block placing logic here
        -- This depends on the game's remotes
        print("Placing block...")
    end
end

-- 💎 RESOURCE ESP SYSTEM
function Bedwars:FindResources()
    local resources = {}
    for _, obj in pairs(Workspace:GetDescendants()) do
        local name = obj.Name:lower()
        if (name:find("diamond") and self.Settings.ResourceESP.Diamonds) or
           (name:find("emerald") and self.Settings.ResourceESP.Emeralds) or
           (name:find("iron") and self.Settings.ResourceESP.Iron) or
           (name:find("gold") and self.Settings.ResourceESP.Gold) then
            if obj:IsA("Part") or obj:IsA("Model") then
                table.insert(resources, obj)
            end
        end
    end
    return resources
end

function Bedwars:UpdateResourceESP()
    if not self.Settings.ResourceESP.Enabled then return end
    
    local resources = self:FindResources()
    
    for _, resource in pairs(resources) do
        local position = resource:IsA("Model") and resource.PrimaryPart and resource.PrimaryPart.Position or resource.Position
        if position then
            local screenPos, onScreen = Camera:WorldToViewportPoint(position)
            local distance = (position - Camera.CFrame.Position).Magnitude
            
            if onScreen and distance <= self.Settings.ResourceESP.MaxDistance then
                -- Draw ESP for resource
                -- Implementation here
            end
        end
    end
end

-- 🎯 GENERATOR ESP
function Bedwars:FindGenerators()
    local generators = {}
    for _, obj in pairs(Workspace:GetDescendants()) do
        if obj.Name:lower():find("generator") then
            table.insert(generators, obj)
        end
    end
    return generators
end

function Bedwars:UpdateGeneratorESP()
    if not self.Settings.GeneratorESP.Enabled then return end
    
    local generators = self:FindGenerators()
    
    for _, gen in pairs(generators) do
        -- Draw ESP for generators
        -- Show upgrade level and spawn timers
    end
end

-- 🛡️ AUTO DEFENSE
function Bedwars:AutoDefense()
    if not self.Settings.AutoDefense.Enabled then return end
    if not LocalPlayer.Character then return end
    
    -- Find enemies near bed
    local nearbyEnemies = {}
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Team ~= LocalPlayer.Team and player.Character then
            local distance = (player.Character.HumanoidRootPart.Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude
            if distance <= self.Settings.AutoDefense.AlertDistance then
                table.insert(nearbyEnemies, player)
            end
        end
    end
    
    if #nearbyEnemies > 0 and self.Settings.AutoDefense.AlertOnEnemyNear then
        print("🚨 ENEMY NEAR BED! " .. #nearbyEnemies .. " enemy/enemies detected!")
    end
end

-- 🎒 INVENTORY MANAGEMENT
function Bedwars:ManageInventory()
    if not LocalPlayer.Character then return end
    
    if self.Settings.Inventory.AutoEquipArmor then
        -- Auto equip best armor
    end
    
    if self.Settings.Inventory.AutoEquipSword then
        -- Auto equip best sword
    end
    
    if self.Settings.Inventory.DropJunk then
        -- Drop unnecessary items
    end
end

-- 🎮 MAIN TOGGLE
function Bedwars:Toggle(enabled)
    self.Enabled = enabled
    
    if enabled then
        print("🛏️ Bedwars Module Activated! Time to dominate! 🏆")
        
        -- Main update loop
        table.insert(connections, RunService.RenderStepped:Connect(function()
            self:UpdateBedESP()
            self:UpdateResourceESP()
            self:UpdateGeneratorESP()
            self:AutoBridge()
            self:AutoDefense()
            self:ManageInventory()
        end))
        
    else
        print("🛏️ Bedwars Module Deactivated")
        
        -- Cleanup
        for _, connection in pairs(connections) do
            connection:Disconnect()
        end
        connections = {}
        
        -- Remove ESP
        for _, esp in pairs(espObjects) do
            for _, obj in pairs(esp) do
                if obj then obj:Remove() end
            end
        end
        espObjects = {}
    end
end

-- 🔧 UPDATE SETTINGS
function Bedwars:UpdateSettings(newSettings)
    for category, settings in pairs(newSettings) do
        if self.Settings[category] then
            for key, value in pairs(settings) do
                self.Settings[category][key] = value
            end
        end
    end
end

return Bedwars
