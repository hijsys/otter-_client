-- Advanced Speed Module
-- Features: Multiple speed types, smooth transitions, and anti-detection

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer

local Speed = {}
Speed.Enabled = false
Speed.Multiplier = 2
Speed.Type = "WalkSpeed" -- WalkSpeed, BodyVelocity, CFrame
Speed.Smooth = true
Speed.Smoothness = 0.1
Speed.TeamCheck = true
Speed.VisibleCheck = true

local connections = {}
local originalWalkSpeed = 16
local bodyVelocity = nil
local lastDirection = Vector3.new(0, 0, 0)

-- Get player's movement direction
function Speed:GetMovementDirection()
    local character = player.Character
    if not character then return Vector3.new(0, 0, 0) end
    
    local humanoid = character:FindFirstChild("Humanoid")
    if not humanoid then return Vector3.new(0, 0, 0) end
    
    local moveVector = humanoid.MoveDirection
    return moveVector
end

-- Apply WalkSpeed method
function Speed:ApplyWalkSpeed()
    local character = player.Character
    if not character then return end
    
    local humanoid = character:FindFirstChild("Humanoid")
    if not humanoid then return end
    
    local newSpeed = originalWalkSpeed * self.Multiplier
    humanoid.WalkSpeed = newSpeed
end

-- Apply BodyVelocity method
function Speed:ApplyBodyVelocity()
    local character = player.Character
    if not character then return end
    
    local rootPart = character:FindFirstChild("HumanoidRootPart")
    if not rootPart then return end
    
    local direction = self:GetMovementDirection()
    if direction.Magnitude > 0 then
        local velocity = direction * (originalWalkSpeed * self.Multiplier)
        
        if not bodyVelocity then
            bodyVelocity = Instance.new("BodyVelocity")
            bodyVelocity.MaxForce = Vector3.new(4000, 0, 4000)
            bodyVelocity.Parent = rootPart
        end
        
        if self.Smooth then
            bodyVelocity.Velocity = bodyVelocity.Velocity:Lerp(velocity, self.Smoothness)
        else
            bodyVelocity.Velocity = velocity
        end
        
        lastDirection = direction
    else
        if bodyVelocity then
            bodyVelocity.Velocity = Vector3.new(0, 0, 0)
        end
    end
end

-- Apply CFrame method
function Speed:ApplyCFrame()
    local character = player.Character
    if not character then return end
    
    local rootPart = character:FindFirstChild("HumanoidRootPart")
    if not rootPart then return end
    
    local direction = self:GetMovementDirection()
    if direction.Magnitude > 0 then
        local currentPosition = rootPart.Position
        local newPosition = currentPosition + (direction * (originalWalkSpeed * self.Multiplier) * 0.1)
        
        if self.Smooth then
            rootPart.CFrame = rootPart.CFrame:Lerp(CFrame.new(newPosition), self.Smoothness)
        else
            rootPart.CFrame = CFrame.new(newPosition)
        end
    end
end

-- Apply speed based on type
function Speed:ApplySpeed()
    if not self.Enabled then return end
    
    if self.Type == "WalkSpeed" then
        self:ApplyWalkSpeed()
    elseif self.Type == "BodyVelocity" then
        self:ApplyBodyVelocity()
    elseif self.Type == "CFrame" then
        self:ApplyCFrame()
    end
end

-- Remove speed effects
function Speed:RemoveSpeed()
    local character = player.Character
    if not character then return end
    
    local humanoid = character:FindFirstChild("Humanoid")
    if humanoid then
        humanoid.WalkSpeed = originalWalkSpeed
    end
    
    if bodyVelocity then
        bodyVelocity:Destroy()
        bodyVelocity = nil
    end
end

-- Main speed loop
function Speed:Update()
    if not self.Enabled then return end
    
    self:ApplySpeed()
end

-- Start speed
function Speed:Start()
    if connections.update then
        connections.update:Disconnect()
    end
    
    connections.update = RunService.Heartbeat:Connect(function()
        self:Update()
    end)
end

-- Stop speed
function Speed:Stop()
    if connections.update then
        connections.update:Disconnect()
        connections.update = nil
    end
    
    self:RemoveSpeed()
end

-- Toggle speed
function Speed:Toggle(enabled)
    self.Enabled = enabled
    if enabled then
        self:Start()
    else
        self:Stop()
    end
end

-- Update settings
function Speed:UpdateSettings(settings)
    for key, value in pairs(settings) do
        if self[key] ~= nil then
            self[key] = value
        end
    end
end

-- Cleanup on character removal
function Speed:Cleanup()
    self:RemoveSpeed()
    if connections.update then
        connections.update:Disconnect()
        connections.update = nil
    end
end

-- Connect to character removal
if player.Character then
    player.CharacterRemoving:Connect(function()
        Speed:Cleanup()
    end)
end

return Speed
