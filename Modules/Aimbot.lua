-- Advanced Aimbot Module
-- Features: Smart targeting, prediction, smoothing, and anti-detection

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Camera = workspace.CurrentCamera

local player = Players.LocalPlayer
local mouse = player:GetMouse()

local Aimbot = {}
Aimbot.Enabled = false
Aimbot.Target = nil
Aimbot.FOV = 100
Aimbot.Smoothing = 20
Aimbot.Prediction = 0.1
Aimbot.VisibleCheck = true
Aimbot.TeamCheck = true
Aimbot.WallCheck = true
Aimbot.Priority = "Closest" -- Closest, Lowest Health, Highest Health
Aimbot.Bone = "Head" -- Head, Torso, HumanoidRootPart

local connections = {}
local targetParts = {"Head", "Torso", "HumanoidRootPart"}

-- Get all valid targets
function Aimbot:GetTargets()
    local targets = {}
    local myTeam = player.Team
    
    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= player and plr.Character and plr.Character:FindFirstChild("Humanoid") and plr.Character.Humanoid.Health > 0 then
            if not self.TeamCheck or plr.Team ~= myTeam then
                local character = plr.Character
                local humanoid = character:FindFirstChild("Humanoid")
                local rootPart = character:FindFirstChild("HumanoidRootPart")
                
                if rootPart then
                    local distance = (rootPart.Position - Camera.CFrame.Position).Magnitude
                    local screenPoint, onScreen = Camera:WorldToViewportPoint(rootPart.Position)
                    
                    if onScreen then
                        local screenDistance = (Vector2.new(screenPoint.X, screenPoint.Y) - Vector2.new(mouse.X, mouse.Y)).Magnitude
                        
                        if screenDistance <= self.FOV then
                            table.insert(targets, {
                                Player = plr,
                                Character = character,
                                Humanoid = humanoid,
                                RootPart = rootPart,
                                Distance = distance,
                                ScreenDistance = screenDistance
                            })
                        end
                    end
                end
            end
        end
    end
    
    return targets
end

-- Get best target based on priority
function Aimbot:GetBestTarget(targets)
    if #targets == 0 then return nil end
    
    if self.Priority == "Closest" then
        table.sort(targets, function(a, b)
            return a.ScreenDistance < b.ScreenDistance
        end)
    elseif self.Priority == "Lowest Health" then
        table.sort(targets, function(a, b)
            return a.Humanoid.Health < b.Humanoid.Health
        end)
    elseif self.Priority == "Highest Health" then
        table.sort(targets, function(a, b)
            return a.Humanoid.Health > b.Humanoid.Health
        end)
    end
    
    return targets[1]
end

-- Check if target is visible
function Aimbot:IsVisible(target)
    if not self.VisibleCheck then return true end
    
    local cameraPos = Camera.CFrame.Position
    local targetPos = target.RootPart.Position
    
    local raycast = workspace:Raycast(cameraPos, (targetPos - cameraPos).Unit * 1000)
    
    if raycast then
        local hit = raycast.Instance
        local model = hit:FindFirstAncestorOfClass("Model")
        return model == target.Character
    end
    
    return true
end

-- Calculate prediction
function Aimbot:CalculatePrediction(target)
    if not self.Prediction or self.Prediction <= 0 then
        return target.RootPart.Position
    end
    
    local velocity = target.RootPart.Velocity
    local distance = (target.RootPart.Position - Camera.CFrame.Position).Magnitude
    local timeToTarget = distance / 1000 -- Assuming bullet speed of 1000 studs/sec
    
    return target.RootPart.Position + (velocity * timeToTarget * self.Prediction)
end

-- Smooth aim to target
function Aimbot:AimToTarget(target)
    if not target then return end
    
    local targetPart = target.Character:FindFirstChild(self.Bone)
    if not targetPart then
        targetPart = target.RootPart
    end
    
    local predictedPosition = self:CalculatePrediction(target)
    local targetPosition = targetPart.Position
    
    local camera = Camera
    local currentCFrame = camera.CFrame
    local targetCFrame = CFrame.lookAt(camera.CFrame.Position, predictedPosition)
    
    local smoothing = math.max(0.1, self.Smoothing / 100)
    local newCFrame = currentCFrame:Lerp(targetCFrame, smoothing)
    
    camera.CFrame = newCFrame
end

-- Main aimbot loop
function Aimbot:Update()
    if not self.Enabled then return end
    
    local targets = self:GetTargets()
    local bestTarget = self:GetBestTarget(targets)
    
    if bestTarget and self:IsVisible(bestTarget) then
        self.Target = bestTarget
        self:AimToTarget(bestTarget)
    else
        self.Target = nil
    end
end

-- Start aimbot
function Aimbot:Start()
    if connections.update then
        connections.update:Disconnect()
    end
    
    connections.update = RunService.Heartbeat:Connect(function()
        self:Update()
    end)
end

-- Stop aimbot
function Aimbot:Stop()
    if connections.update then
        connections.update:Disconnect()
        connections.update = nil
    end
    self.Target = nil
end

-- Toggle aimbot
function Aimbot:Toggle(enabled)
    self.Enabled = enabled
    if enabled then
        self:Start()
    else
        self:Stop()
    end
end

-- Update settings
function Aimbot:UpdateSettings(settings)
    for key, value in pairs(settings) do
        if self[key] ~= nil then
            self[key] = value
        end
    end
end

return Aimbot
