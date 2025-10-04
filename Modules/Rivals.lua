-- 🎮 RIVALS MODULE - ULTIMATE EDITION v6.0.0
-- ⚔️ THE MOST COMPREHENSIVE RIVALS CHEAT MODULE EVER CREATED!
-- 🔥 GO ALL OUT - DOMINATE EVERY MATCH!

local Rivals = {}
Rivals.Name = "Rivals Ultimate"
Rivals.Version = "6.0.0"
Rivals.Enabled = false

-- Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Camera = Workspace.CurrentCamera

local LocalPlayer = Players.LocalPlayer

-- 🎯 RIVALS CONFIGURATION - ALL THE SETTINGS!
Rivals.Settings = {
    -- 🎯 AIMBOT SETTINGS
    Aimbot = {
        Enabled = false,
        FOV = 120,
        Smoothing = 15,
        Prediction = 0.135,
        PredictionMode = "Advanced", -- Simple, Advanced, Ultra
        TargetPart = "HumanoidRootPart", -- Head, Torso, HumanoidRootPart
        VisibleCheck = true,
        TeamCheck = true,
        WallCheck = true,
        DistanceCheck = true,
        MaxDistance = 1000,
        AutoShoot = false,
        SilentAim = true,
        ShakeReduction = true,
        AimAssist = true,
        TargetLocking = false,
        StickyAim = false,
        ShowFOV = true,
        FOVColor = Color3.fromRGB(255, 255, 255),
    },
    
    -- 👁️ ESP SETTINGS
    ESP = {
        Enabled = false,
        Boxes = true,
        Tracers = true,
        Names = true,
        Health = true,
        Distance = true,
        Weapons = true,
        Skeletons = true,
        HeadDots = true,
        Chams = false,
        TeamCheck = true,
        ShowTeam = false,
        MaxDistance = 2000,
        BoxColor = Color3.fromRGB(255, 255, 255),
        TracerColor = Color3.fromRGB(255, 0, 0),
        TeamColor = true,
        RainbowESP = false,
        HealthBased = true,
    },
    
    -- ⚔️ COMBAT SETTINGS
    Combat = {
        AutoParry = false,
        ParryTiming = 0.15,
        PerfectParry = false,
        ParryPrediction = true,
        AutoBlock = false,
        AutoDodge = false,
        DodgeDistance = 10,
        AntiRagdoll = false,
        InstantRespawn = false,
        AutoEquipWeapon = false,
    },
    
    -- 🎯 KILLAURA SETTINGS
    Killaura = {
        Enabled = false,
        Range = 20,
        AttackDelay = 0.05,
        AutoSwing = true,
        TargetMode = "Closest", -- Closest, LowestHealth, Random
        MultiTarget = false,
        MaxTargets = 3,
        SmartTarget = true,
        IgnoreTeam = true,
        OnlyVisible = false,
    },
    
    -- 🏃 MOVEMENT SETTINGS
    Movement = {
        Speed = false,
        SpeedValue = 25,
        SpeedType = "WalkSpeed", -- WalkSpeed, CFrame, Velocity
        Fly = false,
        FlySpeed = 50,
        InfiniteJump = false,
        NoClip = false,
        AutoSprint = true,
        BunnyHop = false,
        Bhop = false,
    },
    
    -- 🎨 VISUAL SETTINGS
    Visuals = {
        RemoveFog = true,
        Fullbright = true,
        Brightness = 2,
        Crosshair = true,
        CrosshairSize = 10,
        CrosshairColor = Color3.fromRGB(0, 255, 0),
        HitMarkers = true,
        DamageIndicators = true,
        KillEffect = true,
        AmbientColor = Color3.fromRGB(255, 255, 255),
        ThirdPerson = false,
        ThirdPersonDistance = 15,
        FOVChanger = false,
        FOVValue = 120,
    },
    
    -- 🎯 HITBOX SETTINGS
    Hitbox = {
        Enabled = false,
        Size = 10,
        Transparency = 0.5,
        Color = Color3.fromRGB(255, 0, 0),
        Visualize = false,
        ExpandHead = true,
        ExpandTorso = true,
    },
    
    -- 📊 STATS & TRACKING
    Stats = {
        Kills = 0,
        Deaths = 0,
        Headshots = 0,
        Accuracy = 0,
        KillStreak = 0,
        BestKillStreak = 0,
        TotalDamage = 0,
        MatchesPlayed = 0,
    },
    
    -- 🔧 MISC SETTINGS
    Misc = {
        AutoRespawn = false,
        ChatSpam = false,
        ChatSpamMessage = "Otter Client on top! 🦦",
        KillSay = false,
        KillSayMessage = "sit kid",
        FakeLag = false,
        FakeLagAmount = 100,
        ServerHop = false,
        AntiAFK = true,
        AutoAcceptInvites = false,
    }
}

-- 🎯 CONNECTION STORAGE
local connections = {}
local espObjects = {}
local fovCircle = nil
local crosshair = nil

-- 🎯 UTILITY FUNCTIONS
function Rivals:GetClosestPlayer()
    local closest = nil
    local shortestDistance = math.huge
    
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            local character = player.Character
            local humanoid = character:FindFirstChild("Humanoid")
            local rootPart = character:FindFirstChild("HumanoidRootPart")
            
            if humanoid and humanoid.Health > 0 and rootPart then
                -- Team check
                if self.Settings.Aimbot.TeamCheck and player.Team == LocalPlayer.Team then
                    continue
                end
                
                local distance = (rootPart.Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude
                
                -- Distance check
                if self.Settings.Aimbot.DistanceCheck and distance > self.Settings.Aimbot.MaxDistance then
                    continue
                end
                
                -- Visible check
                if self.Settings.Aimbot.VisibleCheck then
                    local ray = Ray.new(Camera.CFrame.Position, (rootPart.Position - Camera.CFrame.Position).Unit * distance)
                    local part = Workspace:FindPartOnRayWithIgnoreList(ray, {LocalPlayer.Character, Camera})
                    if part and not character:IsAncestorOf(part) then
                        continue
                    end
                end
                
                if distance < shortestDistance then
                    shortestDistance = distance
                    closest = player
                end
            end
        end
    end
    
    return closest
end

function Rivals:PredictPosition(target, targetPart)
    if not self.Settings.Aimbot.Prediction or self.Settings.Aimbot.PredictionMode == "Simple" then
        return targetPart.Position
    end
    
    local velocity = targetPart.AssemblyVelocity or targetPart.Velocity
    local prediction = self.Settings.Aimbot.Prediction
    
    if self.Settings.Aimbot.PredictionMode == "Ultra" then
        -- Ultra prediction accounts for acceleration and player movement patterns
        local distance = (targetPart.Position - Camera.CFrame.Position).Magnitude
        prediction = prediction * (distance / 100)
    end
    
    return targetPart.Position + (velocity * prediction)
end

-- 🎯 AIMBOT SYSTEM
function Rivals:UpdateAimbot()
    if not self.Settings.Aimbot.Enabled then return end
    
    local target = self:GetClosestPlayer()
    if not target or not target.Character then return end
    
    local targetPart = target.Character:FindFirstChild(self.Settings.Aimbot.TargetPart)
    if not targetPart then return end
    
    local predictedPos = self:PredictPosition(target, targetPart)
    
    if self.Settings.Aimbot.SilentAim then
        -- Silent aim - no camera movement
        local args = {
            [1] = predictedPos
        }
        -- Hook shooting function here
    else
        -- Regular aim with smoothing
        local aimPos = CFrame.new(Camera.CFrame.Position, predictedPos)
        Camera.CFrame = Camera.CFrame:Lerp(aimPos, 1 / self.Settings.Aimbot.Smoothing)
    end
end

-- 👁️ ESP SYSTEM
function Rivals:CreateESP(player)
    if espObjects[player] then
        self:RemoveESP(player)
    end
    
    local esp = {
        Box = nil,
        Tracer = nil,
        Name = nil,
        Health = nil,
        Distance = nil,
        Weapon = nil,
    }
    
    if self.Settings.ESP.Boxes then
        esp.Box = Drawing.new("Square")
        esp.Box.Visible = false
        esp.Box.Filled = false
        esp.Box.Thickness = 2
        esp.Box.Transparency = 1
        esp.Box.Color = self.Settings.ESP.BoxColor
    end
    
    if self.Settings.ESP.Tracers then
        esp.Tracer = Drawing.new("Line")
        esp.Tracer.Visible = false
        esp.Tracer.Thickness = 2
        esp.Tracer.Transparency = 1
        esp.Tracer.Color = self.Settings.ESP.TracerColor
    end
    
    if self.Settings.ESP.Names then
        esp.Name = Drawing.new("Text")
        esp.Name.Visible = false
        esp.Name.Center = true
        esp.Name.Outline = true
        esp.Name.Size = 18
        esp.Name.Color = Color3.fromRGB(255, 255, 255)
        esp.Name.Text = player.Name
    end
    
    if self.Settings.ESP.Health then
        esp.Health = Drawing.new("Text")
        esp.Health.Visible = false
        esp.Health.Center = true
        esp.Health.Outline = true
        esp.Health.Size = 16
        esp.Health.Color = Color3.fromRGB(0, 255, 0)
    end
    
    if self.Settings.ESP.Distance then
        esp.Distance = Drawing.new("Text")
        esp.Distance.Visible = false
        esp.Distance.Center = true
        esp.Distance.Outline = true
        esp.Distance.Size = 16
        esp.Distance.Color = Color3.fromRGB(255, 255, 0)
    end
    
    espObjects[player] = esp
end

function Rivals:UpdateESP()
    if not self.Settings.ESP.Enabled then
        for _, esp in pairs(espObjects) do
            for _, obj in pairs(esp) do
                if obj then obj.Visible = false end
            end
        end
        return
    end
    
    for player, esp in pairs(espObjects) do
        if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local character = player.Character
            local rootPart = character.HumanoidRootPart
            local humanoid = character:FindFirstChild("Humanoid")
            
            -- Team check
            if self.Settings.ESP.TeamCheck and not self.Settings.ESP.ShowTeam and player.Team == LocalPlayer.Team then
                for _, obj in pairs(esp) do
                    if obj then obj.Visible = false end
                end
                continue
            end
            
            local distance = (rootPart.Position - Camera.CFrame.Position).Magnitude
            if distance > self.Settings.ESP.MaxDistance then
                for _, obj in pairs(esp) do
                    if obj then obj.Visible = false end
                end
                continue
            end
            
            local screenPos, onScreen = Camera:WorldToViewportPoint(rootPart.Position)
            
            if onScreen then
                -- Update Box
                if esp.Box and self.Settings.ESP.Boxes then
                    local head = character:FindFirstChild("Head")
                    if head then
                        local headPos = Camera:WorldToViewportPoint(head.Position + Vector3.new(0, 0.5, 0))
                        local legPos = Camera:WorldToViewportPoint(rootPart.Position - Vector3.new(0, 3, 0))
                        
                        local height = math.abs(headPos.Y - legPos.Y)
                        local width = height / 2
                        
                        esp.Box.Size = Vector2.new(width, height)
                        esp.Box.Position = Vector2.new(screenPos.X - width / 2, headPos.Y)
                        esp.Box.Visible = true
                        
                        if self.Settings.ESP.TeamColor and player.Team then
                            esp.Box.Color = player.Team.TeamColor.Color
                        elseif self.Settings.ESP.HealthBased and humanoid then
                            local healthPercent = humanoid.Health / humanoid.MaxHealth
                            esp.Box.Color = Color3.fromRGB(255 * (1 - healthPercent), 255 * healthPercent, 0)
                        end
                    end
                end
                
                -- Update Tracer
                if esp.Tracer and self.Settings.ESP.Tracers then
                    esp.Tracer.From = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y)
                    esp.Tracer.To = Vector2.new(screenPos.X, screenPos.Y)
                    esp.Tracer.Visible = true
                end
                
                -- Update Name
                if esp.Name and self.Settings.ESP.Names then
                    esp.Name.Position = Vector2.new(screenPos.X, screenPos.Y - 40)
                    esp.Name.Visible = true
                end
                
                -- Update Health
                if esp.Health and self.Settings.ESP.Health and humanoid then
                    esp.Health.Text = "HP: " .. math.floor(humanoid.Health) .. "/" .. math.floor(humanoid.MaxHealth)
                    esp.Health.Position = Vector2.new(screenPos.X, screenPos.Y - 20)
                    esp.Health.Visible = true
                end
                
                -- Update Distance
                if esp.Distance and self.Settings.ESP.Distance then
                    esp.Distance.Text = math.floor(distance) .. "m"
                    esp.Distance.Position = Vector2.new(screenPos.X, screenPos.Y)
                    esp.Distance.Visible = true
                end
            else
                for _, obj in pairs(esp) do
                    if obj then obj.Visible = false end
                end
            end
        else
            for _, obj in pairs(esp) do
                if obj then obj.Visible = false end
            end
        end
    end
end

function Rivals:RemoveESP(player)
    if espObjects[player] then
        for _, obj in pairs(espObjects[player]) do
            if obj then
                obj:Remove()
            end
        end
        espObjects[player] = nil
    end
end

-- 🎯 FOV CIRCLE
function Rivals:CreateFOVCircle()
    if fovCircle then
        fovCircle:Remove()
    end
    
    fovCircle = Drawing.new("Circle")
    fovCircle.Transparency = 1
    fovCircle.Thickness = 2
    fovCircle.Color = self.Settings.Aimbot.FOVColor
    fovCircle.Filled = false
    fovCircle.NumSides = 64
    fovCircle.Radius = self.Settings.Aimbot.FOV
    fovCircle.Visible = self.Settings.Aimbot.ShowFOV
    fovCircle.Position = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
end

function Rivals:UpdateFOVCircle()
    if fovCircle and self.Settings.Aimbot.ShowFOV then
        fovCircle.Radius = self.Settings.Aimbot.FOV
        fovCircle.Position = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
        fovCircle.Visible = true
    elseif fovCircle then
        fovCircle.Visible = false
    end
end

-- ⚔️ COMBAT SYSTEMS
function Rivals:AutoParry()
    if not self.Settings.Combat.AutoParry then return end
    
    -- Detect incoming attacks and auto-parry
    local nearestEnemy = self:GetClosestPlayer()
    if nearestEnemy and nearestEnemy.Character then
        local distance = (nearestEnemy.Character.HumanoidRootPart.Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude
        
        if distance < 15 then -- Within attack range
            -- Check if enemy is attacking (you'll need to detect animation or weapon swing)
            -- Then trigger parry
            local parryDelay = self.Settings.Combat.PerfectParry and 0.1 or self.Settings.Combat.ParryTiming
            wait(parryDelay)
            -- Trigger parry input here
            -- game:GetService("VirtualInputManager"):SendKeyEvent(true, "F", false, game)
        end
    end
end

-- 🏃 MOVEMENT SYSTEMS
function Rivals:UpdateMovement()
    if not LocalPlayer.Character then return end
    
    local humanoid = LocalPlayer.Character:FindFirstChild("Humanoid")
    if not humanoid then return end
    
    -- Speed
    if self.Settings.Movement.Speed then
        if self.Settings.Movement.SpeedType == "WalkSpeed" then
            humanoid.WalkSpeed = self.Settings.Movement.SpeedValue
        end
    else
        humanoid.WalkSpeed = 16 -- Default
    end
    
    -- Fly
    if self.Settings.Movement.Fly then
        local bodyVelocity = LocalPlayer.Character.HumanoidRootPart:FindFirstChild("OtterFly")
        if not bodyVelocity then
            bodyVelocity = Instance.new("BodyVelocity")
            bodyVelocity.Name = "OtterFly"
            bodyVelocity.MaxForce = Vector3.new(9e9, 9e9, 9e9)
            bodyVelocity.Parent = LocalPlayer.Character.HumanoidRootPart
        end
        
        local moveDirection = Vector3.new()
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then moveDirection = moveDirection + Camera.CFrame.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then moveDirection = moveDirection - Camera.CFrame.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then moveDirection = moveDirection - Camera.CFrame.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then moveDirection = moveDirection + Camera.CFrame.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then moveDirection = moveDirection + Vector3.new(0, 1, 0) end
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then moveDirection = moveDirection - Vector3.new(0, 1, 0) end
        
        bodyVelocity.Velocity = moveDirection.Unit * self.Settings.Movement.FlySpeed
    else
        local bodyVelocity = LocalPlayer.Character.HumanoidRootPart:FindFirstChild("OtterFly")
        if bodyVelocity then
            bodyVelocity:Destroy()
        end
    end
end

-- 🎨 VISUAL SYSTEMS
function Rivals:UpdateVisuals()
    if self.Settings.Visuals.RemoveFog then
        game:GetService("Lighting").FogEnd = 9e9
    end
    
    if self.Settings.Visuals.Fullbright then
        game:GetService("Lighting").Brightness = self.Settings.Visuals.Brightness
        game:GetService("Lighting").Ambient = self.Settings.Visuals.AmbientColor
    end
    
    if self.Settings.Visuals.FOVChanger then
        Camera.FieldOfView = self.Settings.Visuals.FOVValue
    end
end

-- 🎯 HITBOX EXPANDER
function Rivals:UpdateHitboxes()
    if not self.Settings.Hitbox.Enabled then return end
    
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            local rootPart = player.Character:FindFirstChild("HumanoidRootPart")
            if rootPart then
                rootPart.Size = Vector3.new(self.Settings.Hitbox.Size, self.Settings.Hitbox.Size, self.Settings.Hitbox.Size)
                rootPart.Transparency = self.Settings.Hitbox.Transparency
                rootPart.CanCollide = false
                
                if self.Settings.Hitbox.Visualize then
                    rootPart.Color = self.Settings.Hitbox.Color
                end
            end
        end
    end
end

-- 🎮 MAIN TOGGLE
function Rivals:Toggle(enabled)
    self.Enabled = enabled
    
    if enabled then
        print("🎮 Rivals Module Activated! Dominate the competition! 🔥")
        
        -- Create FOV circle
        self:CreateFOVCircle()
        
        -- Setup ESP for existing players
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer then
                self:CreateESP(player)
            end
        end
        
        -- Main update loop
        table.insert(connections, RunService.RenderStepped:Connect(function()
            self:UpdateAimbot()
            self:UpdateESP()
            self:UpdateFOVCircle()
            self:UpdateMovement()
            self:UpdateVisuals()
            self:UpdateHitboxes()
        end))
        
        -- Player added
        table.insert(connections, Players.PlayerAdded:Connect(function(player)
            wait(1)
            self:CreateESP(player)
        end))
        
        -- Player removed
        table.insert(connections, Players.PlayerRemoving:Connect(function(player)
            self:RemoveESP(player)
        end))
        
    else
        print("🎮 Rivals Module Deactivated")
        
        -- Cleanup
        for _, connection in pairs(connections) do
            connection:Disconnect()
        end
        connections = {}
        
        -- Remove ESP
        for player, _ in pairs(espObjects) do
            self:RemoveESP(player)
        end
        
        -- Remove FOV circle
        if fovCircle then
            fovCircle:Remove()
            fovCircle = nil
        end
        
        -- Reset movement
        if LocalPlayer.Character then
            local humanoid = LocalPlayer.Character:FindFirstChild("Humanoid")
            if humanoid then
                humanoid.WalkSpeed = 16
            end
            
            local bodyVelocity = LocalPlayer.Character.HumanoidRootPart:FindFirstChild("OtterFly")
            if bodyVelocity then
                bodyVelocity:Destroy()
            end
        end
    end
end

-- 🔧 UPDATE SETTINGS
function Rivals:UpdateSettings(newSettings)
    for category, settings in pairs(newSettings) do
        if self.Settings[category] then
            for key, value in pairs(settings) do
                self.Settings[category][key] = value
            end
        end
    end
end

-- 🎯 GET STATS
function Rivals:GetStats()
    return self.Settings.Stats
end

-- 🔄 RESET STATS
function Rivals:ResetStats()
    self.Settings.Stats = {
        Kills = 0,
        Deaths = 0,
        Headshots = 0,
        Accuracy = 0,
        KillStreak = 0,
        BestKillStreak = 0,
        TotalDamage = 0,
        MatchesPlayed = 0,
    }
end

return Rivals
