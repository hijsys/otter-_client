-- Advanced ESP Module
-- Features: Multiple ESP types, team colors, health bars, and performance optimization

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Camera = workspace.CurrentCamera

local player = Players.LocalPlayer

local ESP = {}
ESP.Enabled = false
ESP.Boxes = true
ESP.Names = true
ESP.Health = true
ESP.Distance = true
ESP.TeamCheck = true
ESP.VisibleCheck = true
ESP.Tracers = false
ESP.Skeletons = false
ESP.Chams = false
ESP.Glow = false
ESP.TeamColors = true
ESP.EnemyColor = Color3.fromRGB(255, 0, 0)
ESP.TeamColor = Color3.fromRGB(0, 255, 0)
ESP.VisibleColor = Color3.fromRGB(255, 255, 0)
ESP.HiddenColor = Color3.fromRGB(255, 0, 255)

local connections = {}
local espObjects = {}
local characterConnections = {}

-- Create ESP object for player
function ESP:CreateESPObject(targetPlayer)
    local character = targetPlayer.Character
    if not character then return nil end
    
    local humanoid = character:FindFirstChild("Humanoid")
    local rootPart = character:FindFirstChild("HumanoidRootPart")
    if not humanoid or not rootPart then return nil end
    
    local espObject = {
        Player = targetPlayer,
        Character = character,
        Humanoid = humanoid,
        RootPart = rootPart,
        GuiObjects = {},
        Connections = {}
    }
    
    -- Create GUI
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "ESP_" .. targetPlayer.Name
    screenGui.ResetOnSpawn = false
    screenGui.Parent = Camera
    espObject.ScreenGui = screenGui
    
    -- Create box
    if self.Boxes then
        local box = Instance.new("Frame")
        box.Name = "Box"
        box.BackgroundTransparency = 1
        box.BorderSizePixel = 2
        box.Parent = screenGui
        table.insert(espObject.GuiObjects, box)
    end
    
    -- Create name
    if self.Names then
        local nameLabel = Instance.new("TextLabel")
        nameLabel.Name = "Name"
        nameLabel.BackgroundTransparency = 1
        nameLabel.Text = targetPlayer.Name
        nameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        nameLabel.TextStrokeTransparency = 0
        nameLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
        nameLabel.TextSize = 14
        nameLabel.Font = Enum.Font.GothamBold
        nameLabel.Parent = screenGui
        table.insert(espObject.GuiObjects, nameLabel)
    end
    
    -- Create health bar
    if self.Health then
        local healthBar = Instance.new("Frame")
        healthBar.Name = "HealthBar"
        healthBar.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
        healthBar.BorderSizePixel = 1
        healthBar.BorderColor3 = Color3.fromRGB(255, 255, 255)
        healthBar.Parent = screenGui
        
        local healthFill = Instance.new("Frame")
        healthFill.Name = "HealthFill"
        healthFill.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
        healthFill.BorderSizePixel = 0
        healthFill.Parent = healthBar
        table.insert(espObject.GuiObjects, healthBar)
    end
    
    -- Create distance
    if self.Distance then
        local distanceLabel = Instance.new("TextLabel")
        distanceLabel.Name = "Distance"
        distanceLabel.BackgroundTransparency = 1
        distanceLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        distanceLabel.TextStrokeTransparency = 0
        distanceLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
        distanceLabel.TextSize = 12
        distanceLabel.Font = Enum.Font.Gotham
        distanceLabel.Parent = screenGui
        table.insert(espObject.GuiObjects, distanceLabel)
    end
    
    -- Create tracer
    if self.Tracers then
        local tracer = Instance.new("Frame")
        tracer.Name = "Tracer"
        tracer.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        tracer.BorderSizePixel = 0
        tracer.Parent = screenGui
        table.insert(espObject.GuiObjects, tracer)
    end
    
    -- Create skeleton
    if self.Skeletons then
        local skeleton = Instance.new("Frame")
        skeleton.Name = "Skeleton"
        skeleton.BackgroundTransparency = 1
        skeleton.BorderSizePixel = 0
        skeleton.Parent = screenGui
        table.insert(espObject.GuiObjects, skeleton)
    end
    
    espObjects[targetPlayer] = espObject
    return espObject
end

-- Update ESP object
function ESP:UpdateESPObject(espObject)
    if not espObject then return end
    
    local character = espObject.Character
    local rootPart = espObject.RootPart
    local humanoid = espObject.Humanoid
    
    if not character or not rootPart or not humanoid then return end
    
    local screenPoint, onScreen = Camera:WorldToViewportPoint(rootPart.Position)
    if not onScreen then
        for _, guiObject in pairs(espObject.GuiObjects) do
            guiObject.Visible = false
        end
        return
    end
    
    local screenPosition = Vector2.new(screenPoint.X, screenPoint.Y)
    local distance = (rootPart.Position - Camera.CFrame.Position).Magnitude
    local scale = math.max(0.5, math.min(2, 100 / distance))
    
    -- Get color based on team and visibility
    local color = self:GetPlayerColor(espObject.Player, character)
    
    -- Update box
    if self.Boxes and espObject.GuiObjects[1] then
        local box = espObject.GuiObjects[1]
        local size = Vector2.new(50 * scale, 80 * scale)
        box.Size = UDim2.new(0, size.X, 0, size.Y)
        box.Position = UDim2.new(0, screenPosition.X - size.X/2, 0, screenPosition.Y - size.Y)
        box.BorderColor3 = color
        box.Visible = true
    end
    
    -- Update name
    if self.Names and espObject.GuiObjects[2] then
        local nameLabel = espObject.GuiObjects[2]
        nameLabel.Position = UDim2.new(0, screenPosition.X, 0, screenPosition.Y - 20 * scale)
        nameLabel.TextColor3 = color
        nameLabel.TextSize = 14 * scale
        nameLabel.Visible = true
    end
    
    -- Update health bar
    if self.Health and espObject.GuiObjects[3] then
        local healthBar = espObject.GuiObjects[3]
        local healthFill = healthBar:FindFirstChild("HealthFill")
        if healthFill then
            local healthPercent = humanoid.Health / humanoid.MaxHealth
            local barSize = Vector2.new(50 * scale, 4 * scale)
            
            healthBar.Size = UDim2.new(0, barSize.X, 0, barSize.Y)
            healthBar.Position = UDim2.new(0, screenPosition.X - barSize.X/2, 0, screenPosition.Y + 40 * scale)
            
            healthFill.Size = UDim2.new(healthPercent, 0, 1, 0)
            healthFill.BackgroundColor3 = Color3.fromRGB(255 * (1 - healthPercent), 255 * healthPercent, 0)
            
            healthBar.Visible = true
        end
    end
    
    -- Update distance
    if self.Distance and espObject.GuiObjects[4] then
        local distanceLabel = espObject.GuiObjects[4]
        distanceLabel.Position = UDim2.new(0, screenPosition.X, 0, screenPosition.Y + 50 * scale)
        distanceLabel.Text = math.floor(distance) .. " studs"
        distanceLabel.TextColor3 = color
        distanceLabel.TextSize = 12 * scale
        distanceLabel.Visible = true
    end
    
    -- Update tracer
    if self.Tracers and espObject.GuiObjects[5] then
        local tracer = espObject.GuiObjects[5]
        local screenCenter = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y)
        local tracerEnd = screenPosition
        
        local distance = (tracerEnd - screenCenter).Magnitude
        local angle = math.atan2(tracerEnd.Y - screenCenter.Y, tracerEnd.X - screenCenter.X)
        
        tracer.Size = UDim2.new(0, distance, 0, 1)
        tracer.Position = UDim2.new(0, screenCenter.X, 0, screenCenter.Y)
        tracer.Rotation = math.deg(angle)
        tracer.BackgroundColor3 = color
        tracer.Visible = true
    end
end

-- Get player color
function ESP:GetPlayerColor(targetPlayer, character)
    if self.TeamCheck and targetPlayer.Team == player.Team then
        return self.TeamColor
    end
    
    if self.VisibleCheck then
        local raycast = workspace:Raycast(Camera.CFrame.Position, (character:FindFirstChild("HumanoidRootPart").Position - Camera.CFrame.Position).Unit * 1000)
        if raycast then
            local hit = raycast.Instance
            local model = hit:FindFirstAncestorOfClass("Model")
            if model == character then
                return self.VisibleColor
            else
                return self.HiddenColor
            end
        end
    end
    
    return self.EnemyColor
end

-- Update all ESP objects
function ESP:UpdateAll()
    if not self.Enabled then return end
    
    for _, targetPlayer in pairs(Players:GetPlayers()) do
        if targetPlayer ~= player then
            local espObject = espObjects[targetPlayer]
            if not espObject then
                espObject = self:CreateESPObject(targetPlayer)
            end
            
            if espObject then
                self:UpdateESPObject(espObject)
            end
        end
    end
end

-- Remove ESP object
function ESP:RemoveESPObject(targetPlayer)
    local espObject = espObjects[targetPlayer]
    if espObject then
        if espObject.ScreenGui then
            espObject.ScreenGui:Destroy()
        end
        
        for _, connection in pairs(espObject.Connections) do
            connection:Disconnect()
        end
        
        espObjects[targetPlayer] = nil
    end
end

-- Remove all ESP objects
function ESP:RemoveAll()
    for targetPlayer, _ in pairs(espObjects) do
        self:RemoveESPObject(targetPlayer)
    end
end

-- Start ESP
function ESP:Start()
    if connections.update then
        connections.update:Disconnect()
    end
    
    connections.update = RunService.Heartbeat:Connect(function()
        self:UpdateAll()
    end)
    
    -- Connect to player added/removed
    connections.playerAdded = Players.PlayerAdded:Connect(function(targetPlayer)
        targetPlayer.CharacterAdded:Connect(function(character)
            wait(1) -- Wait for character to load
            self:CreateESPObject(targetPlayer)
        end)
    end)
    
    connections.playerRemoving = Players.PlayerRemoving:Connect(function(targetPlayer)
        self:RemoveESPObject(targetPlayer)
    end)
end

-- Stop ESP
function ESP:Stop()
    if connections.update then
        connections.update:Disconnect()
        connections.update = nil
    end
    
    if connections.playerAdded then
        connections.playerAdded:Disconnect()
        connections.playerAdded = nil
    end
    
    if connections.playerRemoving then
        connections.playerRemoving:Disconnect()
        connections.playerRemoving = nil
    end
    
    self:RemoveAll()
end

-- Toggle ESP
function ESP:Toggle(enabled)
    self.Enabled = enabled
    if enabled then
        self:Start()
    else
        self:Stop()
    end
end

-- Update settings
function ESP:UpdateSettings(settings)
    for key, value in pairs(settings) do
        if self[key] ~= nil then
            self[key] = value
        end
    end
end

return ESP
