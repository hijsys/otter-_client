-- Advanced Fly Module
-- Features: Multiple fly types, smooth controls, and anti-detection

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Camera = workspace.CurrentCamera

local player = Players.LocalPlayer

local Fly = {}
Fly.Enabled = false
Fly.Speed = 20
Fly.Type = "BodyVelocity" -- BodyVelocity, CFrame, AlignPosition
Fly.Smooth = true
Fly.Smoothness = 0.1
Fly.NoClip = true
Fly.AutoLand = true
Fly.LandSpeed = 5

local connections = {}
local bodyVelocity = nil
local bodyAngularVelocity = nil
local alignPosition = nil
local alignOrientation = nil
local originalWalkSpeed = 16
local originalJumpPower = 50

-- Get camera direction
function Fly:GetCameraDirection()
    local camera = Camera
    local cameraCFrame = camera.CFrame
    
    local forward = cameraCFrame.LookVector
    local right = cameraCFrame.RightVector
    local up = cameraCFrame.UpVector
    
    return forward, right, up
end

-- Get movement input
function Fly:GetMovementInput()
    local forward, right, up = self:GetCameraDirection()
    local movement = Vector3.new(0, 0, 0)
    
    if UserInputService:IsKeyDown(Enum.KeyCode.W) then
        movement = movement + forward
    end
    if UserInputService:IsKeyDown(Enum.KeyCode.S) then
        movement = movement - forward
    end
    if UserInputService:IsKeyDown(Enum.KeyCode.A) then
        movement = movement - right
    end
    if UserInputService:IsKeyDown(Enum.KeyCode.D) then
        movement = movement + right
    end
    if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
        movement = movement + up
    end
    if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
        movement = movement - up
    end
    
    return movement.Unit
end

-- Apply BodyVelocity method
function Fly:ApplyBodyVelocity()
    local character = player.Character
    if not character then return end
    
    local rootPart = character:FindFirstChild("HumanoidRootPart")
    if not rootPart then return end
    
    local movement = self:GetMovementInput()
    if movement.Magnitude > 0 then
        local velocity = movement * self.Speed
        
        if not bodyVelocity then
            bodyVelocity = Instance.new("BodyVelocity")
            bodyVelocity.MaxForce = Vector3.new(4000, 4000, 4000)
            bodyVelocity.Parent = rootPart
        end
        
        if not bodyAngularVelocity then
            bodyAngularVelocity = Instance.new("BodyAngularVelocity")
            bodyAngularVelocity.MaxTorque = Vector3.new(4000, 4000, 4000)
            bodyAngularVelocity.Parent = rootPart
        end
        
        if self.Smooth then
            bodyVelocity.Velocity = bodyVelocity.Velocity:Lerp(velocity, self.Smoothness)
        else
            bodyVelocity.Velocity = velocity
        end
        
        bodyAngularVelocity.AngularVelocity = Vector3.new(0, 0, 0)
    else
        if bodyVelocity then
            bodyVelocity.Velocity = Vector3.new(0, 0, 0)
        end
    end
end

-- Apply CFrame method
function Fly:ApplyCFrame()
    local character = player.Character
    if not character then return end
    
    local rootPart = character:FindFirstChild("HumanoidRootPart")
    if not rootPart then return end
    
    local movement = self:GetMovementInput()
    if movement.Magnitude > 0 then
        local currentPosition = rootPart.Position
        local newPosition = currentPosition + (movement * self.Speed * 0.1)
        
        if self.Smooth then
            rootPart.CFrame = rootPart.CFrame:Lerp(CFrame.new(newPosition), self.Smoothness)
        else
            rootPart.CFrame = CFrame.new(newPosition)
        end
    end
end

-- Apply AlignPosition method
function Fly:ApplyAlignPosition()
    local character = player.Character
    if not character then return end
    
    local rootPart = character:FindFirstChild("HumanoidRootPart")
    if not rootPart then return end
    
    local movement = self:GetMovementInput()
    if movement.Magnitude > 0 then
        local currentPosition = rootPart.Position
        local targetPosition = currentPosition + (movement * self.Speed * 0.1)
        
        if not alignPosition then
            alignPosition = Instance.new("AlignPosition")
            alignPosition.MaxForce = 4000
            alignPosition.MaxVelocity = self.Speed
            alignPosition.Parent = rootPart
        end
        
        if not alignOrientation then
            alignOrientation = Instance.new("AlignOrientation")
            alignOrientation.MaxTorque = 4000
            alignOrientation.Parent = rootPart
        end
        
        alignPosition.Position = targetPosition
        alignOrientation.CFrame = CFrame.new(targetPosition)
    else
        if alignPosition then
            alignPosition.Position = rootPart.Position
        end
    end
end

-- Apply fly based on type
function Fly:ApplyFly()
    if not self.Enabled then return end
    
    if self.Type == "BodyVelocity" then
        self:ApplyBodyVelocity()
    elseif self.Type == "CFrame" then
        self:ApplyCFrame()
    elseif self.Type == "AlignPosition" then
        self:ApplyAlignPosition()
    end
end

-- Enable NoClip
function Fly:EnableNoClip()
    if not self.NoClip then return end
    
    local character = player.Character
    if not character then return end
    
    for _, part in pairs(character:GetChildren()) do
        if part:IsA("BasePart") then
            part.CanCollide = false
        end
    end
end

-- Disable NoClip
function Fly:DisableNoClip()
    local character = player.Character
    if not character then return end
    
    for _, part in pairs(character:GetChildren()) do
        if part:IsA("BasePart") then
            part.CanCollide = true
        end
    end
end

-- Auto land function
function Fly:AutoLand()
    if not self.AutoLand then return end
    
    local character = player.Character
    if not character then return end
    
    local rootPart = character:FindFirstChild("HumanoidRootPart")
    if not rootPart then return end
    
    local raycast = workspace:Raycast(rootPart.Position, Vector3.new(0, -100, 0))
    if raycast then
        local distance = (raycast.Position - rootPart.Position).Magnitude
        if distance < 10 then
            local humanoid = character:FindFirstChild("Humanoid")
            if humanoid then
                humanoid.WalkSpeed = self.LandSpeed
            end
        end
    end
end

-- Remove fly effects
function Fly:RemoveFly()
    local character = player.Character
    if not character then return end
    
    local humanoid = character:FindFirstChild("Humanoid")
    if humanoid then
        humanoid.WalkSpeed = originalWalkSpeed
        humanoid.JumpPower = originalJumpPower
    end
    
    if bodyVelocity then
        bodyVelocity:Destroy()
        bodyVelocity = nil
    end
    
    if bodyAngularVelocity then
        bodyAngularVelocity:Destroy()
        bodyAngularVelocity = nil
    end
    
    if alignPosition then
        alignPosition:Destroy()
        alignPosition = nil
    end
    
    if alignOrientation then
        alignOrientation:Destroy()
        alignOrientation = nil
    end
    
    self:DisableNoClip()
end

-- Main fly loop
function Fly:Update()
    if not self.Enabled then return end
    
    self:ApplyFly()
    self:EnableNoClip()
    self:AutoLand()
end

-- Start fly
function Fly:Start()
    if connections.update then
        connections.update:Disconnect()
    end
    
    connections.update = RunService.Heartbeat:Connect(function()
        self:Update()
    end)
end

-- Stop fly
function Fly:Stop()
    if connections.update then
        connections.update:Disconnect()
        connections.update = nil
    end
    
    self:RemoveFly()
end

-- Toggle fly
function Fly:Toggle(enabled)
    self.Enabled = enabled
    if enabled then
        self:Start()
    else
        self:Stop()
    end
end

-- Update settings
function Fly:UpdateSettings(settings)
    for key, value in pairs(settings) do
        if self[key] ~= nil then
            self[key] = value
        end
    end
end

-- Cleanup on character removal
function Fly:Cleanup()
    self:RemoveFly()
    if connections.update then
        connections.update:Disconnect()
        connections.update = nil
    end
end

-- Connect to character removal
if player.Character then
    player.CharacterRemoving:Connect(function()
        Fly:Cleanup()
    end)
end

return Fly
