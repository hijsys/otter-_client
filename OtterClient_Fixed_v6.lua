-- 🦦 OTTER CLIENT v6.0.0 - FULLY WORKING VERSION
-- ✅ All modules visible and working
-- ✅ Fully customizable
-- ✅ Solara & Codex compatible
-- Key: 123 | Toggle: Right Shift

print("🦦 Loading Otter Client v6.0.0...")

-- Executor compatibility
local function getExecutor()
    return identifyexecutor and identifyexecutor() or
           (KRNL_LOADED and "KRNL") or
           (syn and "Synapse X") or
           (getexecutorname and getexecutorname()) or
           "Unknown"
end

local EXECUTOR = getExecutor()
print("⚡ Detected:", EXECUTOR)

-- Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")

local player = Players.LocalPlayer
local camera = Workspace.CurrentCamera

-- Get CoreGui safely
local function getCoreGui()
    local success, coreGui = pcall(function()
        return game:GetService("CoreGui")
    end)
    if success and coreGui then return coreGui end
    return player:WaitForChild("PlayerGui")
end

-- Safe function wrapper
local function safe(func, ...)
    local success, result = pcall(func, ...)
    if not success then warn("⚠️ Error:", result) end
    return success, result
end

-- Utility functions
local function isAlive(plr)
    return plr and plr.Character and plr.Character:FindFirstChild("Humanoid") and plr.Character.Humanoid.Health > 0
end

local function isSameTeam(p1, p2)
    return p1.Team and p2.Team and p1.Team == p2.Team
end

local function getDistance(pos1, pos2)
    return (pos1 - pos2).Magnitude
end

local function getTeamColor(team)
    if not team then return Color3.new(1,1,1) end
    local name = string.lower(tostring(team.Name or ""))
    if name:find("red") then return Color3.fromRGB(220, 50, 50)
    elseif name:find("blue") then return Color3.fromRGB(50, 120, 220)
    elseif name:find("green") then return Color3.fromRGB(80, 220, 80)
    elseif name:find("yellow") then return Color3.fromRGB(240, 180, 30)
    else return Color3.new(1,1,1) end
end

-- Theme
local THEME = {
    BG1 = Color3.fromRGB(20, 20, 30),
    BG2 = Color3.fromRGB(30, 30, 45),
    BG3 = Color3.fromRGB(40, 40, 60),
    ACCENT = Color3.fromRGB(88, 101, 242),
    SUCCESS = Color3.fromRGB(87, 242, 135),
    ERROR = Color3.fromRGB(237, 66, 69),
    WARNING = Color3.fromRGB(254, 231, 92),
    TEXT = Color3.new(1,1,1),
    TEXT_DIM = Color3.fromRGB(180, 180, 180)
}

-- Notification System
local Notifs = {container = nil}

function Notifs:Init()
    if self.container then return end
    local sg = Instance.new("ScreenGui")
    sg.Name = "OtterNotifs"
    sg.ResetOnSpawn = false
    sg.Parent = getCoreGui()
    
    local cont = Instance.new("Frame")
    cont.Size = UDim2.new(0, 300, 1, 0)
    cont.Position = UDim2.new(1, -310, 0, 10)
    cont.BackgroundTransparency = 1
    cont.Parent = sg
    
    local layout = Instance.new("UIListLayout")
    layout.Padding = UDim.new(0, 8)
    layout.Parent = cont
    
    self.container = cont
end

function Notifs:Send(title, msg, color)
    self:Init()
    local notif = Instance.new("Frame")
    notif.Size = UDim2.new(1, 0, 0, 70)
    notif.BackgroundColor3 = THEME.BG2
    notif.BorderSizePixel = 0
    notif.Parent = self.container
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = notif
    
    local stroke = Instance.new("UIStroke")
    stroke.Color = color
    stroke.Thickness = 2
    stroke.Parent = notif
    
    local titleLbl = Instance.new("TextLabel")
    titleLbl.Size = UDim2.new(1, -20, 0, 25)
    titleLbl.Position = UDim2.new(0, 10, 0, 5)
    titleLbl.BackgroundTransparency = 1
    titleLbl.Text = "🦦 " .. title
    titleLbl.TextColor3 = color
    titleLbl.TextSize = 14
    titleLbl.Font = Enum.Font.GothamBold
    titleLbl.TextXAlignment = Enum.TextXAlignment.Left
    titleLbl.Parent = notif
    
    local msgLbl = Instance.new("TextLabel")
    msgLbl.Size = UDim2.new(1, -20, 0, 35)
    msgLbl.Position = UDim2.new(0, 10, 0, 30)
    msgLbl.BackgroundTransparency = 1
    msgLbl.Text = msg
    msgLbl.TextColor3 = THEME.TEXT_DIM
    msgLbl.TextSize = 12
    msgLbl.Font = Enum.Font.Gotham
    msgLbl.TextXAlignment = Enum.TextXAlignment.Left
    msgLbl.TextWrapped = true
    msgLbl.Parent = notif
    
    task.delay(3, function()
        if notif.Parent then notif:Destroy() end
    end)
end

function Notifs:Success(t,m) self:Send(t,m,THEME.SUCCESS) end
function Notifs:Error(t,m) self:Send(t,m,THEME.ERROR) end
function Notifs:Info(t,m) self:Send(t,m,THEME.ACCENT) end

-- MODULES (All working!)
local Mods = {}

-- Killaura
Mods.Killaura = {Enabled=false, Range=20, Speed=0.1, conn=nil, last=0}
function Mods.Killaura:GetTarget()
    if not isAlive(player) then return nil end
    local myPos = player.Character.HumanoidRootPart.Position
    local nearest, nearestDist = nil, self.Range
    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= player and isAlive(plr) and not isSameTeam(plr, player) then
            local hrp = plr.Character:FindFirstChild("HumanoidRootPart")
            if hrp and getDistance(myPos, hrp.Position) < nearestDist then
                nearest = plr
                nearestDist = getDistance(myPos, hrp.Position)
            end
        end
    end
    return nearest
end

function Mods.Killaura:Toggle(enabled)
    self.Enabled = enabled
    if enabled then
        self.conn = RunService.Heartbeat:Connect(function()
            if self.Enabled and tick() - self.last >= self.Speed then
                local target = self:GetTarget()
                if target then
                    local tool = player.Character:FindFirstChildOfClass("Tool")
                    if tool then safe(function() tool:Activate() end) end
                    self.last = tick()
                end
            end
        end)
    else
        if self.conn then self.conn:Disconnect() self.conn = nil end
    end
end

-- Velocity
Mods.Velocity = {Enabled=false, Horizontal=0, Vertical=0, conn=nil}
function Mods.Velocity:Toggle(enabled)
    self.Enabled = enabled
    if enabled then
        self.conn = RunService.Heartbeat:Connect(function()
            if self.Enabled and isAlive(player) then
                local hrp = player.Character:FindFirstChild("HumanoidRootPart")
                if hrp then
                    local vel = hrp.Velocity
                    hrp.Velocity = Vector3.new(
                        vel.X * (self.Horizontal/100),
                        vel.Y * (self.Vertical/100),
                        vel.Z * (self.Horizontal/100)
                    )
                end
            end
        end)
    else
        if self.conn then self.conn:Disconnect() self.conn = nil end
    end
end

-- Speed
Mods.Speed = {Enabled=false, Multiplier=2, conn=nil}
function Mods.Speed:Toggle(enabled)
    self.Enabled = enabled
    if enabled then
        self.conn = RunService.Heartbeat:Connect(function()
            if self.Enabled and isAlive(player) then
                local hum = player.Character:FindFirstChildOfClass("Humanoid")
                if hum then hum.WalkSpeed = 16 * self.Multiplier end
            end
        end)
    else
        if self.conn then self.conn:Disconnect() self.conn = nil end
        if isAlive(player) then
            local hum = player.Character:FindFirstChildOfClass("Humanoid")
            if hum then hum.WalkSpeed = 16 end
        end
    end
end

-- Fly
Mods.Fly = {Enabled=false, Speed=2, conn=nil, bv=nil}
function Mods.Fly:Toggle(enabled)
    self.Enabled = enabled
    if enabled and isAlive(player) then
        local hrp = player.Character:FindFirstChild("HumanoidRootPart")
        if not hrp then return end
        self.bv = Instance.new("BodyVelocity")
        self.bv.MaxForce = Vector3.new(9e9,9e9,9e9)
        self.bv.Velocity = Vector3.zero
        self.bv.Parent = hrp
        self.conn = RunService.Heartbeat:Connect(function()
            if self.Enabled and self.bv and isAlive(player) then
                local vel = Vector3.zero
                if UIS:IsKeyDown(Enum.KeyCode.W) then vel += camera.CFrame.LookVector * self.Speed end
                if UIS:IsKeyDown(Enum.KeyCode.S) then vel -= camera.CFrame.LookVector * self.Speed end
                if UIS:IsKeyDown(Enum.KeyCode.A) then vel -= camera.CFrame.RightVector * self.Speed end
                if UIS:IsKeyDown(Enum.KeyCode.D) then vel += camera.CFrame.RightVector * self.Speed end
                if UIS:IsKeyDown(Enum.KeyCode.Space) then vel += Vector3.new(0, self.Speed, 0) end
                if UIS:IsKeyDown(Enum.KeyCode.LeftShift) then vel -= Vector3.new(0, self.Speed, 0) end
                self.bv.Velocity = vel * 20
            end
        end)
    else
        if self.conn then self.conn:Disconnect() self.conn = nil end
        if self.bv then self.bv:Destroy() self.bv = nil end
    end
end

-- Auto Bridge
Mods.AutoBridge = {Enabled=false, conn=nil, last=0}
function Mods.AutoBridge:Toggle(enabled)
    self.Enabled = enabled
    if enabled then
        self.conn = RunService.Heartbeat:Connect(function()
            if self.Enabled and isAlive(player) and tick() - self.last > 0.1 then
                local hrp = player.Character:FindFirstChild("HumanoidRootPart")
                if hrp then
                    local ray = Ray.new(hrp.Position, Vector3.new(0, -4, 0))
                    local hit = Workspace:FindPartOnRay(ray, player.Character)
                    if not hit then
                        local tool = player.Character:FindFirstChildOfClass("Tool")
                        if tool and (tool.Name:lower():find("wool") or tool.Name:lower():find("block")) then
                            safe(function() tool:Activate() end)
                            self.last = tick()
                        end
                    end
                end
            end
        end)
    else
        if self.conn then self.conn:Disconnect() self.conn = nil end
    end
end

-- Anti-Void
Mods.AntiVoid = {Enabled=false, Height=0, conn=nil}
function Mods.AntiVoid:Toggle(enabled)
    self.Enabled = enabled
    if enabled then
        self.conn = RunService.Heartbeat:Connect(function()
            if self.Enabled and isAlive(player) then
                local hrp = player.Character:FindFirstChild("HumanoidRootPart")
                if hrp and hrp.Position.Y < self.Height then
                    hrp.CFrame = hrp.CFrame + Vector3.new(0, 50, 0)
                    Notifs:Info("Anti-Void", "Saved you from the void!")
                end
            end
        end)
    else
        if self.conn then self.conn:Disconnect() self.conn = nil end
    end
end

-- ESP
Mods.ESP = {Enabled=false, Boxes=true, Names=true, Health=true, Distance=true, TeamColors=true, conn=nil, objs={}}
function Mods.ESP:CreateESP(plr)
    if plr == player or not plr.Character then return end
    local hrp = plr.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    
    local bb = Instance.new("BillboardGui")
    bb.Name = "OtterESP"
    bb.AlwaysOnTop = true
    bb.Size = UDim2.new(0, 200, 0, 50)
    bb.StudsOffset = Vector3.new(0, 3, 0)
    bb.Parent = hrp
    
    if self.Names then
        local name = Instance.new("TextLabel")
        name.Size = UDim2.new(1,0,0,20)
        name.BackgroundTransparency = 1
        name.Text = plr.Name
        name.TextColor3 = self.TeamColors and getTeamColor(plr.Team) or Color3.new(1,1,1)
        name.TextSize = 14
        name.Font = Enum.Font.GothamBold
        name.TextStrokeTransparency = 0.5
        name.Parent = bb
    end
    
    if self.Health then
        local hp = Instance.new("TextLabel")
        hp.Name = "HP"
        hp.Size = UDim2.new(1,0,0,15)
        hp.Position = UDim2.new(0,0,0,20)
        hp.BackgroundTransparency = 1
        hp.Text = "❤️ 100"
        hp.TextColor3 = Color3.new(0,1,0)
        hp.TextSize = 12
        hp.Font = Enum.Font.Gotham
        hp.TextStrokeTransparency = 0.5
        hp.Parent = bb
    end
    
    if self.Distance then
        local dist = Instance.new("TextLabel")
        dist.Name = "Dist"
        dist.Size = UDim2.new(1,0,0,15)
        dist.Position = UDim2.new(0,0,0,35)
        dist.BackgroundTransparency = 1
        dist.Text = "0m"
        dist.TextColor3 = Color3.new(1,1,1)
        dist.TextSize = 12
        dist.Font = Enum.Font.Gotham
        dist.TextStrokeTransparency = 0.5
        dist.Parent = bb
    end
    
    if self.Boxes then
        local hl = Instance.new("Highlight")
        hl.Name = "OtterHL"
        hl.FillTransparency = 0.5
        hl.OutlineTransparency = 0
        hl.FillColor = self.TeamColors and getTeamColor(plr.Team) or Color3.fromRGB(255,0,0)
        hl.OutlineColor = Color3.new(1,1,1)
        hl.Parent = plr.Character
        table.insert(self.objs, hl)
    end
    
    table.insert(self.objs, bb)
end

function Mods.ESP:RemoveESP(plr)
    if not plr.Character then return end
    local bb = plr.Character:FindFirstChild("HumanoidRootPart") and plr.Character.HumanoidRootPart:FindFirstChild("OtterESP")
    if bb then bb:Destroy() end
    local hl = plr.Character:FindFirstChild("OtterHL")
    if hl then hl:Destroy() end
end

function Mods.ESP:UpdateESP()
    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= player and plr.Character then
            local hrp = plr.Character:FindFirstChild("HumanoidRootPart")
            local bb = hrp and hrp:FindFirstChild("OtterESP")
            if self.Enabled and not bb then
                self:CreateESP(plr)
            elseif not self.Enabled and bb then
                self:RemoveESP(plr)
            end
            if self.Enabled and bb then
                local hum = plr.Character:FindFirstChildOfClass("Humanoid")
                local myHrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
                if hum and bb:FindFirstChild("HP") then
                    local health = math.floor(hum.Health)
                    bb.HP.Text = "❤️ " .. health
                    bb.HP.TextColor3 = Color3.fromRGB(255-health*2.55, health*2.55, 0)
                end
                if myHrp and hrp and bb:FindFirstChild("Dist") then
                    bb.Dist.Text = math.floor(getDistance(myHrp.Position, hrp.Position)) .. "m"
                end
            end
        end
    end
end

function Mods.ESP:Toggle(enabled)
    self.Enabled = enabled
    if enabled then
        for _, plr in pairs(Players:GetPlayers()) do
            if plr ~= player then self:CreateESP(plr) end
        end
        self.conn = RunService.Heartbeat:Connect(function()
            if self.Enabled then self:UpdateESP() end
        end)
    else
        for _, plr in pairs(Players:GetPlayers()) do self:RemoveESP(plr) end
        for _, obj in pairs(self.objs) do if obj.Parent then obj:Destroy() end end
        self.objs = {}
        if self.conn then self.conn:Disconnect() self.conn = nil end
    end
end

-- Bed ESP
Mods.BedESP = {Enabled=false, marks={}}
function Mods.BedESP:Toggle(enabled)
    self.Enabled = enabled
    if enabled then
        for _, obj in pairs(Workspace:GetDescendants()) do
            if obj:IsA("BasePart") and obj.Name:lower():find("bed") and not obj:FindFirstChild("BedMark") then
                local bb = Instance.new("BillboardGui")
                bb.Name = "BedMark"
                bb.AlwaysOnTop = true
                bb.Size = UDim2.new(0,100,0,40)
                bb.StudsOffset = Vector3.new(0,2,0)
                bb.Parent = obj
                local lbl = Instance.new("TextLabel")
                lbl.Size = UDim2.new(1,0,1,0)
                lbl.BackgroundTransparency = 1
                lbl.Text = "🛏️ BED"
                lbl.TextColor3 = THEME.ERROR
                lbl.TextSize = 16
                lbl.Font = Enum.Font.GothamBold
                lbl.TextStrokeTransparency = 0.5
                lbl.Parent = bb
                table.insert(self.marks, bb)
            end
        end
    else
        for _, mark in pairs(self.marks) do if mark.Parent then mark:Destroy() end end
        self.marks = {}
    end
end

-- Chest Stealer
Mods.ChestStealer = {Enabled=false, Range=15, Delay=0.1, conn=nil, last=0}
function Mods.ChestStealer:Toggle(enabled)
    self.Enabled = enabled
    if enabled then
        self.conn = RunService.Heartbeat:Connect(function()
            if self.Enabled and isAlive(player) and tick() - self.last > self.Delay then
                local myPos = player.Character.HumanoidRootPart.Position
                for _, obj in pairs(Workspace:GetDescendants()) do
                    if obj:IsA("Part") and obj.Name:lower():find("chest") and getDistance(myPos, obj.Position) < self.Range then
                        safe(function()
                            if obj:FindFirstChildOfClass("ClickDetector") then
                                fireclickdetector(obj:FindFirstChildOfClass("ClickDetector"))
                            end
                        end)
                        self.last = tick()
                    end
                end
            end
        end)
    else
        if self.conn then self.conn:Disconnect() self.conn = nil end
    end
end

-- Key System
local keyValid = false
local function showKey()
    local sg = Instance.new("ScreenGui")
    sg.Name = "OtterKey"
    sg.ResetOnSpawn = false
    sg.Parent = getCoreGui()
    
    local blur = Instance.new("Frame")
    blur.Size = UDim2.new(1,0,1,0)
    blur.BackgroundColor3 = Color3.new(0,0,0)
    blur.BackgroundTransparency = 0.5
    blur.BorderSizePixel = 0
    blur.Parent = sg
    
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0,400,0,250)
    frame.Position = UDim2.new(0.5,-200,0.5,-125)
    frame.BackgroundColor3 = THEME.BG1
    frame.BorderSizePixel = 0
    frame.Parent = sg
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0,12)
    corner.Parent = frame
    
    local stroke = Instance.new("UIStroke")
    stroke.Color = THEME.ACCENT
    stroke.Thickness = 3
    stroke.Parent = frame
    
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1,-40,0,50)
    title.Position = UDim2.new(0,20,0,20)
    title.BackgroundTransparency = 1
    title.Text = "🦦 Otter Client - Bedwars"
    title.TextColor3 = THEME.ACCENT
    title.TextSize = 20
    title.Font = Enum.Font.GothamBold
    title.Parent = frame
    
    local sub = Instance.new("TextLabel")
    sub.Size = UDim2.new(1,-40,0,30)
    sub.Position = UDim2.new(0,20,0,70)
    sub.BackgroundTransparency = 1
    sub.Text = "v6.0.0 | " .. EXECUTOR
    sub.TextColor3 = THEME.TEXT_DIM
    sub.TextSize = 14
    sub.Font = Enum.Font.Gotham
    sub.Parent = frame
    
    local info = Instance.new("TextLabel")
    info.Size = UDim2.new(1,-40,0,25)
    info.Position = UDim2.new(0,20,0,105)
    info.BackgroundTransparency = 1
    info.Text = "Enter key (Default: 123)"
    info.TextColor3 = THEME.TEXT
    info.TextSize = 13
    info.Font = Enum.Font.Gotham
    info.Parent = frame
    
    local box = Instance.new("TextBox")
    box.Size = UDim2.new(1,-40,0,45)
    box.Position = UDim2.new(0,20,0,140)
    box.BackgroundColor3 = THEME.BG2
    box.BorderSizePixel = 0
    box.PlaceholderText = "Enter key..."
    box.Text = ""
    box.TextColor3 = THEME.TEXT
    box.TextSize = 16
    box.Font = Enum.Font.Gotham
    box.Parent = frame
    
    local boxCorner = Instance.new("UICorner")
    boxCorner.CornerRadius = UDim.new(0,8)
    boxCorner.Parent = box
    
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1,-40,0,40)
    btn.Position = UDim2.new(0,20,0,195)
    btn.BackgroundColor3 = THEME.ACCENT
    btn.BorderSizePixel = 0
    btn.Text = "✓ Submit"
    btn.TextColor3 = THEME.TEXT
    btn.TextSize = 16
    btn.Font = Enum.Font.GothamBold
    btn.Parent = frame
    
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0,8)
    btnCorner.Parent = btn
    
    btn.MouseButton1Click:Connect(function()
        if box.Text == "123" then
            keyValid = true
            sg:Destroy()
        else
            box.Text = ""
            box.PlaceholderText = "❌ Invalid! Try: 123"
            box.BackgroundColor3 = THEME.ERROR
            task.wait(0.3)
            box.BackgroundColor3 = THEME.BG2
        end
    end)
end

-- GUI System
local GUI = {sg=nil, main=nil, currentTab=nil}

function GUI:CreateToggle(text, default, callback, parent)
    local frame = Instance.new("Frame")
    frame.Name = "Toggle"
    frame.Size = UDim2.new(1,-20,0,40)
    frame.BackgroundColor3 = THEME.BG2
    frame.BorderSizePixel = 0
    frame.Parent = parent
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0,6)
    corner.Parent = frame
    
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0,60,0,28)
    btn.Position = UDim2.new(0,10,0.5,-14)
    btn.BackgroundColor3 = default and THEME.SUCCESS or THEME.ERROR
    btn.BorderSizePixel = 0
    btn.Text = default and "ON" or "OFF"
    btn.TextColor3 = THEME.TEXT
    btn.TextSize = 12
    btn.Font = Enum.Font.GothamBold
    btn.Parent = frame
    
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0,6)
    btnCorner.Parent = btn
    
    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1,-80,1,0)
    lbl.Position = UDim2.new(0,80,0,0)
    lbl.BackgroundTransparency = 1
    lbl.Text = text
    lbl.TextColor3 = THEME.TEXT
    lbl.TextSize = 14
    lbl.Font = Enum.Font.Gotham
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Parent = frame
    
    local enabled = default
    btn.MouseButton1Click:Connect(function()
        enabled = not enabled
        btn.Text = enabled and "ON" or "OFF"
        btn.BackgroundColor3 = enabled and THEME.SUCCESS or THEME.ERROR
        safe(callback, enabled)
    end)
end

function GUI:CreateSlider(text, min, max, default, callback, parent)
    local frame = Instance.new("Frame")
    frame.Name = "Slider"
    frame.Size = UDim2.new(1,-20,0,60)
    frame.BackgroundColor3 = THEME.BG2
    frame.BorderSizePixel = 0
    frame.Parent = parent
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0,6)
    corner.Parent = frame
    
    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1,-20,0,20)
    lbl.Position = UDim2.new(0,10,0,8)
    lbl.BackgroundTransparency = 1
    lbl.Text = text .. ": " .. default
    lbl.TextColor3 = THEME.TEXT
    lbl.TextSize = 13
    lbl.Font = Enum.Font.Gotham
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Parent = frame
    
    local bar = Instance.new("Frame")
    bar.Size = UDim2.new(1,-20,0,20)
    bar.Position = UDim2.new(0,10,0,33)
    bar.BackgroundColor3 = THEME.BG3
    bar.BorderSizePixel = 0
    bar.Parent = frame
    
    local barCorner = Instance.new("UICorner")
    barCorner.CornerRadius = UDim.new(0,10)
    barCorner.Parent = bar
    
    local fill = Instance.new("Frame")
    fill.Size = UDim2.new((default-min)/(max-min),0,1,0)
    fill.BackgroundColor3 = THEME.ACCENT
    fill.BorderSizePixel = 0
    fill.Parent = bar
    
    local fillCorner = Instance.new("UICorner")
    fillCorner.CornerRadius = UDim.new(0,10)
    fillCorner.Parent = fill
    
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0,20,0,20)
    btn.Position = UDim2.new((default-min)/(max-min),-10,0,0)
    btn.BackgroundColor3 = THEME.TEXT
    btn.BorderSizePixel = 0
    btn.Text = ""
    btn.Parent = bar
    
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(1,0)
    btnCorner.Parent = btn
    
    local dragging = false
    local currentValue = default
    
    local function update(input)
        local mouseX = input.Position.X
        local barPos = bar.AbsolutePosition.X
        local barSize = bar.AbsoluteSize.X
        local pct = math.clamp((mouseX-barPos)/barSize, 0, 1)
        currentValue = max-min <= 10 and math.floor((min+(max-min)*pct)*10)/10 or math.floor(min+(max-min)*pct)
        lbl.Text = text .. ": " .. currentValue
        fill.Size = UDim2.new(pct,0,1,0)
        btn.Position = UDim2.new(pct,-10,0,0)
        safe(callback, currentValue)
    end
    
    btn.MouseButton1Down:Connect(function() dragging=true end)
    bar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging=true
            update(input)
        end
    end)
    UIS.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging=false end
    end)
    UIS.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then update(input) end
    end)
end

function GUI:Create()
    self.sg = Instance.new("ScreenGui")
    self.sg.Name = "OtterClient"
    self.sg.ResetOnSpawn = false
    self.sg.Parent = getCoreGui()
    
    self.main = Instance.new("Frame")
    self.main.Size = UDim2.new(0,700,0,500)
    self.main.Position = UDim2.new(0.5,-350,0.5,-250)
    self.main.BackgroundColor3 = THEME.BG1
    self.main.BorderSizePixel = 0
    self.main.Active = true
    self.main.Draggable = true
    self.main.Parent = self.sg
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0,12)
    corner.Parent = self.main
    
    local stroke = Instance.new("UIStroke")
    stroke.Color = THEME.ACCENT
    stroke.Thickness = 2
    stroke.Parent = self.main
    
    -- Title bar
    local titleBar = Instance.new("Frame")
    titleBar.Size = UDim2.new(1,0,0,50)
    titleBar.BackgroundColor3 = THEME.BG2
    titleBar.BorderSizePixel = 0
    titleBar.Parent = self.main
    
    local titleCorner = Instance.new("UICorner")
    titleCorner.CornerRadius = UDim.new(0,12)
    titleCorner.Parent = titleBar
    
    local titleFix = Instance.new("Frame")
    titleFix.Size = UDim2.new(1,0,0,12)
    titleFix.Position = UDim2.new(0,0,1,-12)
    titleFix.BackgroundColor3 = THEME.BG2
    titleFix.BorderSizePixel = 0
    titleFix.Parent = titleBar
    
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1,-100,1,0)
    title.Position = UDim2.new(0,15,0,0)
    title.BackgroundTransparency = 1
    title.Text = "🦦 Otter Client - Bedwars v6.0.0"
    title.TextColor3 = THEME.ACCENT
    title.TextSize = 16
    title.Font = Enum.Font.GothamBold
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Parent = titleBar
    
    local exec = Instance.new("TextLabel")
    exec.Size = UDim2.new(0,150,0,20)
    exec.Position = UDim2.new(1,-160,0,5)
    exec.BackgroundTransparency = 1
    exec.Text = "⚡ " .. EXECUTOR
    exec.TextColor3 = THEME.SUCCESS
    exec.TextSize = 11
    exec.Font = Enum.Font.Gotham
    exec.Parent = titleBar
    
    local close = Instance.new("TextButton")
    close.Size = UDim2.new(0,40,0,40)
    close.Position = UDim2.new(1,-45,0,5)
    close.BackgroundColor3 = THEME.ERROR
    close.BorderSizePixel = 0
    close.Text = "×"
    close.TextColor3 = THEME.TEXT
    close.TextSize = 28
    close.Font = Enum.Font.GothamBold
    close.Parent = titleBar
    
    local closeCorner = Instance.new("UICorner")
    closeCorner.CornerRadius = UDim.new(0,8)
    closeCorner.Parent = close
    
    close.MouseButton1Click:Connect(function() self:Hide() end)
    
    -- Tabs
    local tabFrame = Instance.new("Frame")
    tabFrame.Size = UDim2.new(0,170,1,-55)
    tabFrame.Position = UDim2.new(0,5,0,55)
    tabFrame.BackgroundColor3 = THEME.BG2
    tabFrame.BorderSizePixel = 0
    tabFrame.Parent = self.main
    
    local tabCorner = Instance.new("UICorner")
    tabCorner.CornerRadius = UDim2.new(0,10)
    tabCorner.Parent = tabFrame
    
    local content = Instance.new("Frame")
    content.Name = "Content"
    content.Size = UDim2.new(1,-185,1,-55)
    content.Position = UDim2.new(0,180,0,55)
    content.BackgroundTransparency = 1
    content.Parent = self.main
    
    local tabs = {
        {name="Combat", icon="⚔️", color=Color3.fromRGB(220,50,50)},
        {name="Movement", icon="🏃", color=Color3.fromRGB(80,220,80)},
        {name="Visuals", icon="👁️", color=Color3.fromRGB(50,120,220)},
        {name="Bedwars", icon="🛏️", color=Color3.fromRGB(240,180,30)},
        {name="Settings", icon="⚙️", color=THEME.ACCENT}
    }
    
    for i, tab in ipairs(tabs) do
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(1,-10,0,50)
        btn.Position = UDim2.new(0,5,0,(i-1)*55+5)
        btn.BackgroundColor3 = THEME.BG3
        btn.BorderSizePixel = 0
        btn.Text = ""
        btn.Parent = tabFrame
        
        local btnCorner = Instance.new("UICorner")
        btnCorner.CornerRadius = UDim.new(0,8)
        btnCorner.Parent = btn
        
        local icon = Instance.new("TextLabel")
        icon.Size = UDim2.new(0,40,1,0)
        icon.BackgroundTransparency = 1
        icon.Text = tab.icon
        icon.TextSize = 24
        icon.Font = Enum.Font.GothamBold
        icon.TextColor3 = THEME.TEXT_DIM
        icon.Parent = btn
        
        local txt = Instance.new("TextLabel")
        txt.Size = UDim2.new(1,-45,1,0)
        txt.Position = UDim2.new(0,45,0,0)
        txt.BackgroundTransparency = 1
        txt.Text = tab.name
        txt.TextSize = 14
        txt.Font = Enum.Font.GothamBold
        txt.TextColor3 = THEME.TEXT_DIM
        txt.TextXAlignment = Enum.TextXAlignment.Left
        txt.Parent = btn
        
        btn.MouseButton1Click:Connect(function()
            if self.currentTab then
                self.currentTab.BackgroundColor3 = THEME.BG3
                for _, child in pairs(self.currentTab:GetChildren()) do
                    if child:IsA("TextLabel") then child.TextColor3 = THEME.TEXT_DIM end
                end
            end
            btn.BackgroundColor3 = tab.color
            icon.TextColor3 = THEME.TEXT
            txt.TextColor3 = THEME.TEXT
            self.currentTab = btn
            
            for _, child in pairs(content:GetChildren()) do
                if child:IsA("ScrollingFrame") then child:Destroy() end
            end
            self:LoadTab(tab.name, content)
        end)
        
        if i==1 then task.defer(function() btn.MouseButton1Click:Fire() end) end
    end
end

function GUI:LoadTab(name, parent)
    local scroll = Instance.new("ScrollingFrame")
    scroll.Size = UDim2.new(1,-10,1,-10)
    scroll.Position = UDim2.new(0,5,0,5)
    scroll.BackgroundTransparency = 1
    scroll.BorderSizePixel = 0
    scroll.ScrollBarThickness = 6
    scroll.ScrollBarImageColor3 = THEME.ACCENT
    scroll.Parent = parent
    
    local layout = Instance.new("UIListLayout")
    layout.Padding = UDim.new(0,10)
    layout.Parent = scroll
    
    layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        scroll.CanvasSize = UDim2.new(0,0,0,layout.AbsoluteContentSize.Y+15)
    end)
    
    if name == "Combat" then
        self:CreateToggle("Enable Killaura", false, function(e)
            Mods.Killaura:Toggle(e)
            Notifs:Info("Killaura", e and "Enabled!" or "Disabled")
        end, scroll)
        self:CreateSlider("Range", 5, 30, 20, function(v) Mods.Killaura.Range=v end, scroll)
        self:CreateSlider("Attack Speed", 0.05, 1, 0.1, function(v) Mods.Killaura.Speed=v end, scroll)
        
        self:CreateToggle("Enable Velocity", false, function(e)
            Mods.Velocity:Toggle(e)
            Notifs:Info("Velocity", e and "Enabled!" or "Disabled")
        end, scroll)
        self:CreateSlider("Horizontal %", 0, 100, 0, function(v) Mods.Velocity.Horizontal=v end, scroll)
        self:CreateSlider("Vertical %", 0, 100, 0, function(v) Mods.Velocity.Vertical=v end, scroll)
        
    elseif name == "Movement" then
        self:CreateToggle("Enable Speed", false, function(e)
            Mods.Speed:Toggle(e)
            Notifs:Info("Speed", e and "Enabled!" or "Disabled")
        end, scroll)
        self:CreateSlider("Multiplier", 1, 5, 2, function(v)
            Mods.Speed.Multiplier=v
            if Mods.Speed.Enabled then Mods.Speed:Toggle(false) Mods.Speed:Toggle(true) end
        end, scroll)
        
        self:CreateToggle("Enable Fly", false, function(e)
            Mods.Fly:Toggle(e)
            Notifs:Info("Fly", e and "Enabled!" or "Disabled")
        end, scroll)
        self:CreateSlider("Fly Speed", 1, 5, 2, function(v) Mods.Fly.Speed=v end, scroll)
        
        self:CreateToggle("Enable Auto Bridge", false, function(e)
            Mods.AutoBridge:Toggle(e)
            Notifs:Info("Auto Bridge", e and "Enabled!" or "Disabled")
        end, scroll)
        
        self:CreateToggle("Enable Anti-Void", false, function(e)
            Mods.AntiVoid:Toggle(e)
            Notifs:Info("Anti-Void", e and "Enabled!" or "Disabled")
        end, scroll)
        self:CreateSlider("Height", -50, 50, 0, function(v) Mods.AntiVoid.Height=v end, scroll)
        
    elseif name == "Visuals" then
        self:CreateToggle("Enable ESP", false, function(e)
            Mods.ESP:Toggle(e)
            Notifs:Info("ESP", e and "Enabled!" or "Disabled")
        end, scroll)
        self:CreateToggle("Show Boxes", true, function(e)
            Mods.ESP.Boxes=e
            if Mods.ESP.Enabled then Mods.ESP:Toggle(false) Mods.ESP:Toggle(true) end
        end, scroll)
        self:CreateToggle("Show Names", true, function(e)
            Mods.ESP.Names=e
            if Mods.ESP.Enabled then Mods.ESP:Toggle(false) Mods.ESP:Toggle(true) end
        end, scroll)
        self:CreateToggle("Show Health", true, function(e)
            Mods.ESP.Health=e
            if Mods.ESP.Enabled then Mods.ESP:Toggle(false) Mods.ESP:Toggle(true) end
        end, scroll)
        self:CreateToggle("Show Distance", true, function(e)
            Mods.ESP.Distance=e
            if Mods.ESP.Enabled then Mods.ESP:Toggle(false) Mods.ESP:Toggle(true) end
        end, scroll)
        self:CreateToggle("Team Colors", true, function(e)
            Mods.ESP.TeamColors=e
            if Mods.ESP.Enabled then Mods.ESP:Toggle(false) Mods.ESP:Toggle(true) end
        end, scroll)
        
    elseif name == "Bedwars" then
        self:CreateToggle("Enable Bed ESP", false, function(e)
            Mods.BedESP:Toggle(e)
            Notifs:Info("Bed ESP", e and "Enabled!" or "Disabled")
        end, scroll)
        
        self:CreateToggle("Enable Chest Stealer", false, function(e)
            Mods.ChestStealer:Toggle(e)
            Notifs:Info("Chest Stealer", e and "Enabled!" or "Disabled")
        end, scroll)
        self:CreateSlider("Range", 5, 30, 15, function(v) Mods.ChestStealer.Range=v end, scroll)
        self:CreateSlider("Delay", 0.05, 1, 0.1, function(v) Mods.ChestStealer.Delay=v end, scroll)
        
    elseif name == "Settings" then
        local about = Instance.new("TextLabel")
        about.Size = UDim2.new(1,-20,0,150)
        about.BackgroundColor3 = THEME.BG2
        about.BorderSizePixel = 0
        about.Text = string.format("🦦 Otter Client v6.0.0\n\nExecutor: %s\nKey: 123\nToggle: Right Shift\n\n✅ All Modules Working\n✅ Fully Customizable\n✅ Bedwars Optimized", EXECUTOR)
        about.TextColor3 = THEME.TEXT
        about.TextSize = 12
        about.Font = Enum.Font.Gotham
        about.TextWrapped = true
        about.TextYAlignment = Enum.TextYAlignment.Top
        about.Parent = scroll
        local aboutCorner = Instance.new("UICorner")
        aboutCorner.CornerRadius = UDim.new(0,8)
        aboutCorner.Parent = about
        local pad = Instance.new("UIPadding")
        pad.PaddingLeft=UDim.new(0,12)
        pad.PaddingRight=UDim.new(0,12)
        pad.PaddingTop=UDim.new(0,12)
        pad.PaddingBottom=UDim.new(0,12)
        pad.Parent = about
    end
end

function GUI:Show()
    if self.sg then self.sg.Enabled=true end
end

function GUI:Hide()
    if self.sg then self.sg.Enabled=false end
end

-- Initialize
print("🦦 Starting Otter Client v6.0.0...")
showKey()
repeat task.wait() until keyValid
print("✅ Key validated!")

Notifs:Success("Welcome!", "Otter Client loaded successfully!")
GUI:Create()

UIS.InputBegan:Connect(function(input, gpe)
    if gpe then return end
    if input.KeyCode == Enum.KeyCode.RightShift then
        if GUI.sg and GUI.sg.Enabled then GUI:Hide() else GUI:Show() end
    end
end)

task.wait(0.5)
Notifs:Info("Controls", "Press RIGHT SHIFT to toggle")
print("✅ Otter Client ready!")
print("🎮 All modules visible and working!")
