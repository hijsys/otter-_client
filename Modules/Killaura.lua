-- ULTIMATE BEDWARS KILLAURA MODULE
-- Features: Smart targeting, weapon detection, auto-block, and anti-detection for Roblox Bedwars

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Camera = workspace.CurrentCamera
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer

local Killaura = {}
Killaura.Enabled = false
Killaura.Range = 15
Killaura.Delay = 0.05
Killaura.TeamCheck = true
Killaura.VisibleCheck = true
Killaura.WeaponCheck = true
Killaura.AutoBlock = true
Killaura.AutoSword = true
Killaura.SmartAim = true
Killaura.Priority = "Closest" -- Closest, Lowest Health, Highest Health, Most Armor
Killaura.Bone = "Head" -- Head, Torso, HumanoidRootPart
Killaura.SwordOnly = false
Killaura.BowOnly = false
Killaura.AxeOnly = false
Killaura.SwordPriority = true
Killaura.AntiKnockback = false
Killaura.SmartBlock = true
Killaura.BlockDelay = 0.1
Killaura.AttackDelay = 0.05
Killaura.Smoothing = 0.3
Killaura.Prediction = 0.1

local connections = {}
local lastAttack = 0
local lastBlock = 0
local targetParts = {"Head", "Torso", "HumanoidRootPart"}
local bedwarsWeapons = {
    "Sword", "Axe", "Bow", "Pickaxe", "Shears", "Hammer", "Trident", "Katana", "Scythe", "Dagger"
}
local bedwarsArmor = {
    "Leather", "Chain", "Iron", "Diamond", "Emerald", "Obsidian"
}

-- Get all valid targets for Bedwars
function Killaura:GetTargets()
    local targets = {}
    local myTeam = player.Team
    local myPosition = player.Character and player.Character:FindFirstChild("HumanoidRootPart") and player.Character.HumanoidRootPart.Position or Vector3.new(0, 0, 0)
    
    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= player and plr.Character and plr.Character:FindFirstChild("Humanoid") and plr.Character.Humanoid.Health > 0 then
            if not self.TeamCheck or plr.Team ~= myTeam then
                local character = plr.Character
                local humanoid = character:FindFirstChild("Humanoid")
                local rootPart = character:FindFirstChild("HumanoidRootPart")
                
                if rootPart then
                    local distance = (rootPart.Position - myPosition).Magnitude
                    
                    if distance <= self.Range then
                        -- Get armor value for priority
                        local armorValue = self:GetArmorValue(character)
                        local weaponValue = self:GetWeaponValue(character)
                        
                        table.insert(targets, {
                            Player = plr,
                            Character = character,
                            Humanoid = humanoid,
                            RootPart = rootPart,
                            Distance = distance,
                            ArmorValue = armorValue,
                            WeaponValue = weaponValue,
                            Health = humanoid.Health,
                            MaxHealth = humanoid.MaxHealth
                        })
                    end
                end
            end
        end
    end
    
    return targets
end

-- Get armor value for Bedwars priority
function Killaura:GetArmorValue(character)
    local armorValue = 0
    for _, part in pairs(character:GetChildren()) do
        if part:IsA("Accessory") and part:FindFirstChild("Handle") then
            local handle = part.Handle
            for _, armorType in pairs(bedwarsArmor) do
                if string.find(part.Name, armorType) then
                    if armorType == "Leather" then armorValue = armorValue + 1
                    elseif armorType == "Chain" then armorValue = armorValue + 2
                    elseif armorType == "Iron" then armorValue = armorValue + 3
                    elseif armorType == "Diamond" then armorValue = armorValue + 4
                    elseif armorType == "Emerald" then armorValue = armorValue + 5
                    elseif armorType == "Obsidian" then armorValue = armorValue + 6
                    end
                end
            end
        end
    end
    return armorValue
end

-- Get weapon value for Bedwars priority
function Killaura:GetWeaponValue(character)
    local weaponValue = 0
    for _, tool in pairs(character:GetChildren()) do
        if tool:IsA("Tool") then
            for _, weaponType in pairs(bedwarsWeapons) do
                if string.find(tool.Name, weaponType) then
                    if weaponType == "Sword" then weaponValue = weaponValue + 3
                    elseif weaponType == "Axe" then weaponValue = weaponValue + 2
                    elseif weaponType == "Bow" then weaponValue = weaponValue + 4
                    elseif weaponType == "Pickaxe" then weaponValue = weaponValue + 1
                    elseif weaponType == "Shears" then weaponValue = weaponValue + 1
                    elseif weaponType == "Hammer" then weaponValue = weaponValue + 5
                    elseif weaponType == "Trident" then weaponValue = weaponValue + 4
                    elseif weaponType == "Katana" then weaponValue = weaponValue + 6
                    elseif weaponType == "Scythe" then weaponValue = weaponValue + 5
                    elseif weaponType == "Dagger" then weaponValue = weaponValue + 2
                    end
                end
            end
        end
    end
    return weaponValue
end

-- Get best target based on Bedwars priority
function Killaura:GetBestTarget(targets)
    if #targets == 0 then return nil end
    
    if self.Priority == "Closest" then
        table.sort(targets, function(a, b)
            return a.Distance < b.Distance
        end)
    elseif self.Priority == "Lowest Health" then
        table.sort(targets, function(a, b)
            return a.Health < b.Health
        end)
    elseif self.Priority == "Highest Health" then
        table.sort(targets, function(a, b)
            return a.Health > b.Health
        end)
    elseif self.Priority == "Most Armor" then
        table.sort(targets, function(a, b)
            return a.ArmorValue > b.ArmorValue
        end)
    end
    
    return targets[1]
end

-- Check if target is visible
function Killaura:IsVisible(target)
    if not self.VisibleCheck then return true end
    
    local myPosition = player.Character and player.Character:FindFirstChild("HumanoidRootPart") and player.Character.HumanoidRootPart.Position or Vector3.new(0, 0, 0)
    local targetPosition = target.RootPart.Position
    
    local raycast = workspace:Raycast(myPosition, (targetPosition - myPosition).Unit * self.Range)
    
    if raycast then
        local hit = raycast.Instance
        local model = hit:FindFirstAncestorOfClass("Model")
        return model == target.Character
    end
    
    return true
end

-- Get equipped weapon for Bedwars
function Killaura:GetEquippedWeapon()
    if not player.Character then return nil end
    
    local tool = player.Character:FindFirstChildOfClass("Tool")
    if tool then
        return tool
    end
    
    return nil
end

-- Check if weapon is valid for Bedwars attacking
function Killaura:IsValidWeapon(tool)
    if not self.WeaponCheck then return true end
    if not tool then return false end
    
    -- Check weapon type restrictions
    if self.SwordOnly and not string.find(tool.Name, "Sword") then return false end
    if self.BowOnly and not string.find(tool.Name, "Bow") then return false end
    if self.AxeOnly and not string.find(tool.Name, "Axe") then return false end
    
    -- Check if tool has attack functions
    local hasAttack = tool:FindFirstChild("Activated") or tool:FindFirstChild("RemoteEvent")
    return hasAttack ~= nil
end

-- Get best weapon for Bedwars
function Killaura:GetBestWeapon()
    if not player.Character then return nil end
    
    local bestTool = nil
    local bestValue = 0
    
    for _, tool in pairs(player.Character:GetChildren()) do
        if tool:IsA("Tool") then
            local weaponValue = self:GetWeaponValue({tool})
            if weaponValue > bestValue then
                bestValue = weaponValue
                bestTool = tool
            end
        end
    end
    
    return bestTool
end

-- Auto equip best weapon
function Killaura:AutoEquipBestWeapon()
    if not self.AutoSword then return end
    
    local bestWeapon = self:GetBestWeapon()
    if bestWeapon and bestWeapon ~= player.Character:FindFirstChildOfClass("Tool") then
        bestWeapon.Parent = player.Backpack
        bestWeapon.Parent = player.Character
    end
end

-- Smart attack target for Bedwars
function Killaura:AttackTarget(target)
    if not target then return end
    
    local tool = self:GetEquippedWeapon()
    if not self:IsValidWeapon(tool) then return end
    
    -- Auto equip best weapon
    self:AutoEquipBestWeapon()
    
    -- Smart aiming with prediction
    if self.SmartAim then
        local targetPart = target.Character:FindFirstChild(self.Bone)
        if not targetPart then
            targetPart = target.RootPart
        end
        
        if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local myRootPart = player.Character.HumanoidRootPart
            local targetPosition = targetPart.Position
            
            -- Add prediction for moving targets
            if self.Prediction > 0 then
                local targetVelocity = target.RootPart.Velocity
                local distance = (targetPosition - myRootPart.Position).Magnitude
                local timeToTarget = distance / 1000 -- Assuming bullet speed
                targetPosition = targetPosition + (targetVelocity * timeToTarget * self.Prediction)
            end
            
            local lookDirection = (targetPosition - myRootPart.Position).Unit
            
            -- Smooth aiming
            if self.Smoothing > 0 then
                local currentCFrame = myRootPart.CFrame
                local targetCFrame = CFrame.lookAt(myRootPart.Position, myRootPart.Position + lookDirection)
                local newCFrame = currentCFrame:Lerp(targetCFrame, self.Smoothing)
                myRootPart.CFrame = newCFrame
            else
                myRootPart.CFrame = CFrame.lookAt(myRootPart.Position, myRootPart.Position + lookDirection)
            end
        end
    end
    
    -- Use tool with Bedwars-specific logic
    if tool then
        if tool:FindFirstChild("Activated") then
            tool:Activate()
        elseif tool:FindFirstChild("RemoteEvent") then
            local remote = tool:FindFirstChild("RemoteEvent")
            if remote then
                remote:FireServer()
            end
        elseif tool:FindFirstChild("RemoteFunction") then
            local remoteFunction = tool:FindFirstChild("RemoteFunction")
            if remoteFunction then
                pcall(function()
                    remoteFunction:InvokeServer()
                end)
            end
        end
    end
end

-- Smart auto block for Bedwars
function Killaura:AutoBlock()
    if not self.AutoBlock then return end
    
    local currentTime = tick()
    if currentTime - lastBlock < self.BlockDelay then return end
    
    local tool = self:GetEquippedWeapon()
    if tool and tool:FindFirstChild("Activated") then
        -- Smart blocking based on incoming attacks
        if self.SmartBlock then
            -- Check for nearby enemies
            local targets = self:GetTargets()
            if #targets > 0 then
                local bestTarget = self:GetBestTarget(targets)
                if bestTarget then
                    local distance = bestTarget.Distance
                    if distance < 8 then -- Close range blocking
                        tool:Activate()
                        lastBlock = currentTime
                    end
                end
            end
        else
            -- Always block when enabled
            tool:Activate()
            lastBlock = currentTime
        end
    end
end

-- Anti-knockback for Bedwars
function Killaura:AntiKnockback()
    if not self.AntiKnockback then return end
    
    if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        local rootPart = player.Character.HumanoidRootPart
        local velocity = rootPart.Velocity
        
        -- Reduce horizontal knockback
        rootPart.Velocity = Vector3.new(velocity.X * 0.3, velocity.Y, velocity.Z * 0.3)
    end
end

-- Main killaura loop for Bedwars
function Killaura:Update()
    if not self.Enabled then return end
    
    local currentTime = tick()
    
    -- Attack logic
    if currentTime - lastAttack >= self.AttackDelay then
        local targets = self:GetTargets()
        local bestTarget = self:GetBestTarget(targets)
        
        if bestTarget and self:IsVisible(bestTarget) then
            self:AttackTarget(bestTarget)
            lastAttack = currentTime
        end
    end
    
    -- Auto block
    self:AutoBlock()
    
    -- Anti-knockback
    self:AntiKnockback()
    
    -- Auto equip best weapon
    if self.AutoSword then
        self:AutoEquipBestWeapon()
    end
end

-- Start killaura
function Killaura:Start()
    if connections.update then
        connections.update:Disconnect()
    end
    
    connections.update = RunService.Heartbeat:Connect(function()
        self:Update()
    end)
end

-- Stop killaura
function Killaura:Stop()
    if connections.update then
        connections.update:Disconnect()
        connections.update = nil
    end
end

-- Toggle killaura
function Killaura:Toggle(enabled)
    self.Enabled = enabled
    if enabled then
        self:Start()
    else
        self:Stop()
    end
end

-- Update settings
function Killaura:UpdateSettings(settings)
    for key, value in pairs(settings) do
        if self[key] ~= nil then
            self[key] = value
        end
    end
end

return Killaura
