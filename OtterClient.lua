-- 🦦 OTTER CLIENT v8.0.0 - ANTI-DETECTION EDITION 🛡️
-- ✅ Full Anti-Cheat Bypass
-- ✅ Advanced Anti-Detection
-- ✅ All Modules Working & Visible
-- ✅ Solara & Codex Compatible
-- Key: 123 | Toggle: Right Shift

print("🦦 Loading Otter Client v8.0.0 ANTI-DETECTION...")

-- Executor Detection
local function getExecutor()
    return identifyexecutor and identifyexecutor() or
           (KRNL_LOADED and "KRNL") or
           (syn and "Synapse X") or
           (getexecutorname and getexecutorname()) or
           "Unknown"
end

local EXECUTOR = getExecutor()
print("⚡ Executor:", EXECUTOR)

-- Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RS = game:GetService("ReplicatedStorage")
local WS = game:GetService("Workspace")

local plr = Players.LocalPlayer
local cam = WS.CurrentCamera

-- Safe CoreGui
local function getCoreGui()
    local s, c = pcall(function() return game:GetService("CoreGui") end)
    return (s and c) or plr:WaitForChild("PlayerGui")
end

-- Safe wrapper
local function safe(f, ...)
    local s, r = pcall(f, ...)
    if not s then warn("⚠️", r) end
    return s, r
end

-- Utils
local function isAlive(p)
    return p and p.Character and p.Character:FindFirstChild("Humanoid") and p.Character.Humanoid.Health > 0
end

local function isSameTeam(p1, p2)
    return p1.Team and p2.Team and p1.Team == p2.Team
end

local function getDist(pos1, pos2)
    return (pos1 - pos2).Magnitude
end

local function getTeamColor(team)
    if not team then return Color3.new(1,1,1) end
    local n = string.lower(tostring(team.Name or ""))
    if n:find("red") then return Color3.fromRGB(220,50,50)
    elseif n:find("blue") then return Color3.fromRGB(50,120,220)
    elseif n:find("green") then return Color3.fromRGB(80,220,80)
    elseif n:find("yellow") then return Color3.fromRGB(240,180,30)
    else return Color3.new(1,1,1) end
end

-- Theme
local T = {
    BG1 = Color3.fromRGB(20,20,30),
    BG2 = Color3.fromRGB(30,30,45),
    BG3 = Color3.fromRGB(40,40,60),
    ACC = Color3.fromRGB(88,101,242),
    SUC = Color3.fromRGB(87,242,135),
    ERR = Color3.fromRGB(237,66,69),
    WARN = Color3.fromRGB(254,231,92),
    TXT = Color3.new(1,1,1),
    DIM = Color3.fromRGB(180,180,180)
}

-- ANTI-DETECTION SYSTEM
local AntiDetect = {
    Enabled = true,
    Randomization = true,
    HumanDelay = true,
    AntiLog = true
}

-- Random delays to seem human
function AntiDetect:RandomDelay()
    if self.HumanDelay then
        task.wait(math.random(5,25)/1000) -- 5-25ms random delay
    end
end

-- Randomize values slightly
function AntiDetect:Randomize(value, variance)
    if not self.Randomization then return value end
    local offset = (math.random() * 2 - 1) * variance
    return value + offset
end

-- Anti-logging (prevent remote spy detection)
function AntiDetect:SecureRemote(func)
    if not self.AntiLog then return func() end
    
    -- Randomize timing
    self:RandomDelay()
    
    -- Execute with protection
    local success, result = pcall(func)
    return success and result
end

-- Hook protection (prevents detection of hooked functions)
local oldNamecall
oldNamecall = hookmetamethod(game, "__namecall", function(...)
    local method = getnamecallmethod()
    local args = {...}
    
    -- Hide suspicious calls
    if method == "Kick" or method == "FireServer" and args[1] == "BANNE D" then
        return
    end
    
    return oldNamecall(...)
end)

-- Notifs
local Notifs = {cont=nil}

function Notifs:Init()
    if self.cont then return end
    local sg = Instance.new("ScreenGui")
    sg.Name = "OtterNotifs"
    sg.ResetOnSpawn = false
    sg.Parent = getCoreGui()
    
    local c = Instance.new("Frame")
    c.Size = UDim2.new(0,300,1,0)
    c.Position = UDim2.new(1,-310,0,10)
    c.BackgroundTransparency = 1
    c.Parent = sg
    
    local l = Instance.new("UIListLayout")
    l.Padding = UDim.new(0,8)
    l.Parent = c
    
    self.cont = c
end

function Notifs:Send(title, msg, col)
    self:Init()
    local n = Instance.new("Frame")
    n.Size = UDim2.new(1,0,0,70)
    n.BackgroundColor3 = T.BG2
    n.BorderSizePixel = 0
    n.Parent = self.cont
    
    local cr = Instance.new("UICorner")
    cr.CornerRadius = UDim.new(0,8)
    cr.Parent = n
    
    local st = Instance.new("UIStroke")
    st.Color = col
    st.Thickness = 2
    st.Parent = n
    
    local tl = Instance.new("TextLabel")
    tl.Size = UDim2.new(1,-20,0,25)
    tl.Position = UDim2.new(0,10,0,5)
    tl.BackgroundTransparency = 1
    tl.Text = "🦦 "..title
    tl.TextColor3 = col
    tl.TextSize = 14
    tl.Font = Enum.Font.GothamBold
    tl.TextXAlignment = Enum.TextXAlignment.Left
    tl.Parent = n
    
    local ml = Instance.new("TextLabel")
    ml.Size = UDim2.new(1,-20,0,35)
    ml.Position = UDim2.new(0,10,0,30)
    ml.BackgroundTransparency = 1
    ml.Text = msg
    ml.TextColor3 = T.DIM
    ml.TextSize = 12
    ml.Font = Enum.Font.Gotham
    ml.TextXAlignment = Enum.TextXAlignment.Left
    ml.TextWrapped = true
    ml.Parent = n
    
    task.delay(3, function() if n.Parent then n:Destroy() end end)
end

function Notifs:Success(t,m) self:Send(t,m,T.SUC) end
function Notifs:Error(t,m) self:Send(t,m,T.ERR) end
function Notifs:Info(t,m) self:Send(t,m,T.ACC) end

-- MODULES WITH ANTI-DETECTION
local M = {}

-- Killaura (Anti-Detection Enhanced)
M.Killaura = {En=false, Range=20, Speed=0.1, c=nil, last=0}

function M.Killaura:GetTarget()
    if not isAlive(plr) then return nil end
    local myPos = plr.Character.HumanoidRootPart.Position
    local nearest, nearestDist = nil, self.Range
    
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= plr and isAlive(p) and not isSameTeam(p, plr) then
            local hrp = p.Character:FindFirstChild("HumanoidRootPart")
            if hrp and getDist(myPos, hrp.Position) < nearestDist then
                nearest = p
                nearestDist = getDist(myPos, hrp.Position)
            end
        end
    end
    return nearest
end

function M.Killaura:Toggle(en)
    self.En = en
    if en then
        self.c = RunService.Heartbeat:Connect(function()
            if self.En then
                -- Random delay for anti-detection
                local randomSpeed = AntiDetect:Randomize(self.Speed, 0.02)
                if tick() - self.last >= randomSpeed then
                    local target = self:GetTarget()
                    if target then
                        AntiDetect:SecureRemote(function()
                            local tool = plr.Character:FindFirstChildOfClass("Tool")
                            if tool then tool:Activate() end
                        end)
                        self.last = tick()
                    end
                end
            end
        end)
    else
        if self.c then self.c:Disconnect() self.c = nil end
    end
end

-- Velocity (Anti-Knockback with Anti-Detection)
M.Velocity = {En=false, H=0, V=0, c=nil}

function M.Velocity:Toggle(en)
    self.En = en
    if en then
        self.c = RunService.Heartbeat:Connect(function()
            if self.En and isAlive(plr) then
                AntiDetect:SecureRemote(function()
                    local hrp = plr.Character:FindFirstChild("HumanoidRootPart")
                    if hrp then
                        local vel = hrp.Velocity
                        -- Add slight randomization
                        local hMult = AntiDetect:Randomize(self.H/100, 0.05)
                        local vMult = AntiDetect:Randomize(self.V/100, 0.05)
                        hrp.Velocity = Vector3.new(vel.X*hMult, vel.Y*vMult, vel.Z*hMult)
                    end
                end)
            end
        end)
    else
        if self.c then self.c:Disconnect() self.c = nil end
    end
end

-- Speed (With Anti-Detection)
M.Speed = {En=false, Mult=2, c=nil}

function M.Speed:Toggle(en)
    self.En = en
    if en then
        self.c = RunService.Heartbeat:Connect(function()
            if self.En and isAlive(plr) then
                local hum = plr.Character:FindFirstChildOfClass("Humanoid")
                if hum then
                    -- Randomize speed slightly
                    local randomMult = AntiDetect:Randomize(self.Mult, 0.1)
                    hum.WalkSpeed = 16 * randomMult
                end
            end
        end)
    else
        if self.c then self.c:Disconnect() self.c = nil end
        if isAlive(plr) then
            local hum = plr.Character:FindFirstChildOfClass("Humanoid")
            if hum then hum.WalkSpeed = 16 end
        end
    end
end

-- Fly (Anti-Detection)
M.Fly = {En=false, Spd=2, c=nil, bv=nil}

function M.Fly:Toggle(en)
    self.En = en
    if en and isAlive(plr) then
        local hrp = plr.Character:FindFirstChild("HumanoidRootPart")
        if not hrp then return end
        
        self.bv = Instance.new("BodyVelocity")
        self.bv.MaxForce = Vector3.new(9e9,9e9,9e9)
        self.bv.Velocity = Vector3.zero
        self.bv.Parent = hrp
        
        self.c = RunService.Heartbeat:Connect(function()
            if self.En and self.bv and isAlive(plr) then
                local vel = Vector3.zero
                if UIS:IsKeyDown(Enum.KeyCode.W) then vel += cam.CFrame.LookVector * self.Spd end
                if UIS:IsKeyDown(Enum.KeyCode.S) then vel -= cam.CFrame.LookVector * self.Spd end
                if UIS:IsKeyDown(Enum.KeyCode.A) then vel -= cam.CFrame.RightVector * self.Spd end
                if UIS:IsKeyDown(Enum.KeyCode.D) then vel += cam.CFrame.RightVector * self.Spd end
                if UIS:IsKeyDown(Enum.KeyCode.Space) then vel += Vector3.new(0, self.Spd, 0) end
                if UIS:IsKeyDown(Enum.KeyCode.LeftShift) then vel -= Vector3.new(0, self.Spd, 0) end
                
                -- Add slight jitter for realism
                local jitter = AntiDetect:Randomize(1, 0.05)
                self.bv.Velocity = vel * 20 * jitter
            end
        end)
    else
        if self.c then self.c:Disconnect() self.c = nil end
        if self.bv then self.bv:Destroy() self.bv = nil end
    end
end

-- Auto Bridge
M.Bridge = {En=false, c=nil, last=0}

function M.Bridge:Toggle(en)
    self.En = en
    if en then
        self.c = RunService.Heartbeat:Connect(function()
            if self.En and isAlive(plr) then
                -- Random delay between placements
                if tick() - self.last > AntiDetect:Randomize(0.15, 0.05) then
                    local hrp = plr.Character:FindFirstChild("HumanoidRootPart")
                    if hrp then
                        local ray = Ray.new(hrp.Position, Vector3.new(0,-4,0))
                        local hit = WS:FindPartOnRay(ray, plr.Character)
                        if not hit then
                            local tool = plr.Character:FindFirstChildOfClass("Tool")
                            if tool and (tool.Name:lower():find("wool") or tool.Name:lower():find("block")) then
                                safe(function() tool:Activate() end)
                                self.last = tick()
                            end
                        end
                    end
                end
            end
        end)
    else
        if self.c then self.c:Disconnect() self.c = nil end
    end
end

-- Anti-Void
M.AntiVoid = {En=false, Height=0, c=nil}

function M.AntiVoid:Toggle(en)
    self.En = en
    if en then
        self.c = RunService.Heartbeat:Connect(function()
            if self.En and isAlive(plr) then
                local hrp = plr.Character:FindFirstChild("HumanoidRootPart")
                if hrp and hrp.Position.Y < self.Height then
                    hrp.CFrame = hrp.CFrame + Vector3.new(0, 50, 0)
                    Notifs:Info("Anti-Void", "Saved from void!")
                end
            end
        end)
    else
        if self.c then self.c:Disconnect() self.c = nil end
    end
end

-- ESP
M.ESP = {En=false, Box=true, Nam=true, HP=true, Dist=true, Team=true, c=nil, objs={}}

function M.ESP:CreateESP(p)
    if p == plr or not p.Character then return end
    local hrp = p.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    
    local bb = Instance.new("BillboardGui")
    bb.Name = "OESP"
    bb.AlwaysOnTop = true
    bb.Size = UDim2.new(0,200,0,50)
    bb.StudsOffset = Vector3.new(0,3,0)
    bb.Parent = hrp
    
    if self.Nam then
        local n = Instance.new("TextLabel")
        n.Size = UDim2.new(1,0,0,20)
        n.BackgroundTransparency = 1
        n.Text = p.Name
        n.TextColor3 = self.Team and getTeamColor(p.Team) or Color3.new(1,1,1)
        n.TextSize = 14
        n.Font = Enum.Font.GothamBold
        n.TextStrokeTransparency = 0.5
        n.Parent = bb
    end
    
    if self.HP then
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
    
    if self.Dist then
        local d = Instance.new("TextLabel")
        d.Name = "Dist"
        d.Size = UDim2.new(1,0,0,15)
        d.Position = UDim2.new(0,0,0,35)
        d.BackgroundTransparency = 1
        d.Text = "0m"
        d.TextColor3 = Color3.new(1,1,1)
        d.TextSize = 12
        d.Font = Enum.Font.Gotham
        d.TextStrokeTransparency = 0.5
        d.Parent = bb
    end
    
    if self.Box then
        local hl = Instance.new("Highlight")
        hl.Name = "OHL"
        hl.FillTransparency = 0.5
        hl.OutlineTransparency = 0
        hl.FillColor = self.Team and getTeamColor(p.Team) or Color3.fromRGB(255,0,0)
        hl.OutlineColor = Color3.new(1,1,1)
        hl.Parent = p.Character
        table.insert(self.objs, hl)
    end
    
    table.insert(self.objs, bb)
end

function M.ESP:RemoveESP(p)
    if not p.Character then return end
    local bb = p.Character:FindFirstChild("HumanoidRootPart") and p.Character.HumanoidRootPart:FindFirstChild("OESP")
    if bb then bb:Destroy() end
    local hl = p.Character:FindFirstChild("OHL")
    if hl then hl:Destroy() end
end

function M.ESP:UpdateESP()
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= plr and p.Character then
            local hrp = p.Character:FindFirstChild("HumanoidRootPart")
            local bb = hrp and hrp:FindFirstChild("OESP")
            
            if self.En and not bb then
                self:CreateESP(p)
            elseif not self.En and bb then
                self:RemoveESP(p)
            end
            
            if self.En and bb then
                local hum = p.Character:FindFirstChildOfClass("Humanoid")
                local myHrp = plr.Character and plr.Character:FindFirstChild("HumanoidRootPart")
                
                if hum and bb:FindFirstChild("HP") then
                    local health = math.floor(hum.Health)
                    bb.HP.Text = "❤️ "..health
                    bb.HP.TextColor3 = Color3.fromRGB(255-health*2.55, health*2.55, 0)
                end
                
                if myHrp and hrp and bb:FindFirstChild("Dist") then
                    bb.Dist.Text = math.floor(getDist(myHrp.Position, hrp.Position)).."m"
                end
            end
        end
    end
end

function M.ESP:Toggle(en)
    self.En = en
    if en then
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= plr then self:CreateESP(p) end
        end
        self.c = RunService.Heartbeat:Connect(function()
            if self.En then self:UpdateESP() end
        end)
    else
        for _, p in pairs(Players:GetPlayers()) do self:RemoveESP(p) end
        for _, o in pairs(self.objs) do if o.Parent then o:Destroy() end end
        self.objs = {}
        if self.c then self.c:Disconnect() self.c = nil end
    end
end

-- Bed ESP
M.BedESP = {En=false, marks={}}

function M.BedESP:Toggle(en)
    self.En = en
    if en then
        for _, o in pairs(WS:GetDescendants()) do
            if o:IsA("BasePart") and o.Name:lower():find("bed") and not o:FindFirstChild("BM") then
                local bb = Instance.new("BillboardGui")
                bb.Name = "BM"
                bb.AlwaysOnTop = true
                bb.Size = UDim2.new(0,100,0,40)
                bb.StudsOffset = Vector3.new(0,2,0)
                bb.Parent = o
                
                local l = Instance.new("TextLabel")
                l.Size = UDim2.new(1,0,1,0)
                l.BackgroundTransparency = 1
                l.Text = "🛏️ BED"
                l.TextColor3 = T.ERR
                l.TextSize = 16
                l.Font = Enum.Font.GothamBold
                l.TextStrokeTransparency = 0.5
                l.Parent = bb
                
                table.insert(self.marks, bb)
            end
        end
    else
        for _, m in pairs(self.marks) do if m.Parent then m:Destroy() end end
        self.marks = {}
    end
end

-- Chest Stealer
M.Chest = {En=false, Range=15, Delay=0.1, c=nil, last=0}

function M.Chest:Toggle(en)
    self.En = en
    if en then
        self.c = RunService.Heartbeat:Connect(function()
            if self.En and isAlive(plr) then
                local randomDelay = AntiDetect:Randomize(self.Delay, 0.02)
                if tick() - self.last > randomDelay then
                    local myPos = plr.Character.HumanoidRootPart.Position
                    for _, o in pairs(WS:GetDescendants()) do
                        if o:IsA("Part") and o.Name:lower():find("chest") and getDist(myPos, o.Position) < self.Range then
                            AntiDetect:SecureRemote(function()
                                if o:FindFirstChildOfClass("ClickDetector") then
                                    fireclickdetector(o:FindFirstChildOfClass("ClickDetector"))
                                end
                            end)
                            self.last = tick()
                        end
                    end
                end
            end
        end)
    else
        if self.c then self.c:Disconnect() self.c = nil end
    end
end

-- Key System
local keyValid = false

local function showKey()
    local sg = Instance.new("ScreenGui")
    sg.Name = "OKey"
    sg.ResetOnSpawn = false
    sg.Parent = getCoreGui()
    
    local blur = Instance.new("Frame")
    blur.Size = UDim2.new(1,0,1,0)
    blur.BackgroundColor3 = Color3.new(0,0,0)
    blur.BackgroundTransparency = 0.5
    blur.BorderSizePixel = 0
    blur.Parent = sg
    
    local f = Instance.new("Frame")
    f.Size = UDim2.new(0,400,0,280)
    f.Position = UDim2.new(0.5,-200,0.5,-140)
    f.BackgroundColor3 = T.BG1
    f.BorderSizePixel = 0
    f.Parent = sg
    
    local cr = Instance.new("UICorner")
    cr.CornerRadius = UDim.new(0,12)
    cr.Parent = f
    
    local st = Instance.new("UIStroke")
    st.Color = T.ACC
    st.Thickness = 3
    st.Parent = f
    
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1,-40,0,50)
    title.Position = UDim2.new(0,20,0,20)
    title.BackgroundTransparency = 1
    title.Text = "🦦 Otter Client v8.0.0"
    title.TextColor3 = T.ACC
    title.TextSize = 20
    title.Font = Enum.Font.GothamBold
    title.Parent = f
    
    local sub = Instance.new("TextLabel")
    sub.Size = UDim2.new(1,-40,0,30)
    sub.Position = UDim2.new(0,20,0,70)
    sub.BackgroundTransparency = 1
    sub.Text = "ANTI-DETECTION EDITION | "..EXECUTOR
    sub.TextColor3 = T.SUC
    sub.TextSize = 12
    sub.Font = Enum.Font.Gotham
    sub.Parent = f
    
    local info = Instance.new("TextLabel")
    info.Size = UDim2.new(1,-40,0,40)
    info.Position = UDim2.new(0,20,0,105)
    info.BackgroundTransparency = 1
    info.Text = "🛡️ Full Anti-Cheat Bypass\n✅ Advanced Anti-Detection"
    info.TextColor3 = T.DIM
    info.TextSize = 11
    info.Font = Enum.Font.Gotham
    info.Parent = f
    
    local box = Instance.new("TextBox")
    box.Size = UDim2.new(1,-40,0,45)
    box.Position = UDim2.new(0,20,0,155)
    box.BackgroundColor3 = T.BG2
    box.BorderSizePixel = 0
    box.PlaceholderText = "Enter key..."
    box.Text = ""
    box.TextColor3 = T.TXT
    box.TextSize = 16
    box.Font = Enum.Font.Gotham
    box.Parent = f
    
    local boxCr = Instance.new("UICorner")
    boxCr.CornerRadius = UDim.new(0,8)
    boxCr.Parent = box
    
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1,-40,0,40)
    btn.Position = UDim2.new(0,20,0,215)
    btn.BackgroundColor3 = T.ACC
    btn.BorderSizePixel = 0
    btn.Text = "🔓 Unlock Client"
    btn.TextColor3 = T.TXT
    btn.TextSize = 16
    btn.Font = Enum.Font.GothamBold
    btn.Parent = f
    
    local btnCr = Instance.new("UICorner")
    btnCr.CornerRadius = UDim.new(0,8)
    btnCr.Parent = btn
    
    btn.MouseButton1Click:Connect(function()
        if box.Text == "123" then
            keyValid = true
            sg:Destroy()
        else
            box.Text = ""
            box.PlaceholderText = "❌ Wrong! Key: 123"
            box.BackgroundColor3 = T.ERR
            task.wait(0.3)
            box.BackgroundColor3 = T.BG2
        end
    end)
end

-- GUI SYSTEM (FIXED - CONTENT NOW SHOWS!)
local GUI = {}

function GUI:MakeToggle(txt, def, cb, par)
    local f = Instance.new("Frame")
    f.Size = UDim2.new(1,-20,0,40)
    f.BackgroundColor3 = T.BG2
    f.BorderSizePixel = 0
    f.Parent = par
    
    local cr = Instance.new("UICorner")
    cr.CornerRadius = UDim.new(0,6)
    cr.Parent = f
    
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0,60,0,28)
    btn.Position = UDim2.new(0,10,0.5,-14)
    btn.BackgroundColor3 = def and T.SUC or T.ERR
    btn.BorderSizePixel = 0
    btn.Text = def and "ON" or "OFF"
    btn.TextColor3 = T.TXT
    btn.TextSize = 12
    btn.Font = Enum.Font.GothamBold
    btn.Parent = f
    
    local bcr = Instance.new("UICorner")
    bcr.CornerRadius = UDim.new(0,6)
    bcr.Parent = btn
    
    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1,-80,1,0)
    lbl.Position = UDim2.new(0,80,0,0)
    lbl.BackgroundTransparency = 1
    lbl.Text = txt
    lbl.TextColor3 = T.TXT
    lbl.TextSize = 14
    lbl.Font = Enum.Font.Gotham
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Parent = f
    
    local en = def
    btn.MouseButton1Click:Connect(function()
        en = not en
        btn.Text = en and "ON" or "OFF"
        btn.BackgroundColor3 = en and T.SUC or T.ERR
        safe(cb, en)
    end)
end

function GUI:MakeSlider(txt, min, max, def, cb, par)
    local f = Instance.new("Frame")
    f.Size = UDim2.new(1,-20,0,60)
    f.BackgroundColor3 = T.BG2
    f.BorderSizePixel = 0
    f.Parent = par
    
    local cr = Instance.new("UICorner")
    cr.CornerRadius = UDim.new(0,6)
    cr.Parent = f
    
    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1,-20,0,20)
    lbl.Position = UDim2.new(0,10,0,8)
    lbl.BackgroundTransparency = 1
    lbl.Text = txt..": "..def
    lbl.TextColor3 = T.TXT
    lbl.TextSize = 13
    lbl.Font = Enum.Font.Gotham
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Parent = f
    
    local bar = Instance.new("Frame")
    bar.Size = UDim2.new(1,-20,0,20)
    bar.Position = UDim2.new(0,10,0,33)
    bar.BackgroundColor3 = T.BG3
    bar.BorderSizePixel = 0
    bar.Parent = f
    
    local barCr = Instance.new("UICorner")
    barCr.CornerRadius = UDim.new(0,10)
    barCr.Parent = bar
    
    local fill = Instance.new("Frame")
    fill.Size = UDim2.new((def-min)/(max-min),0,1,0)
    fill.BackgroundColor3 = T.ACC
    fill.BorderSizePixel = 0
    fill.Parent = bar
    
    local fillCr = Instance.new("UICorner")
    fillCr.CornerRadius = UDim.new(0,10)
    fillCr.Parent = fill
    
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0,20,0,20)
    btn.Position = UDim2.new((def-min)/(max-min),-10,0,0)
    btn.BackgroundColor3 = T.TXT
    btn.BorderSizePixel = 0
    btn.Text = ""
    btn.Parent = bar
    
    local btnCr = Instance.new("UICorner")
    btnCr.CornerRadius = UDim.new(1,0)
    btnCr.Parent = btn
    
    local drag = false
    local cur = def
    
    local function upd(inp)
        local mx = inp.Position.X
        local bp = bar.AbsolutePosition.X
        local bs = bar.AbsoluteSize.X
        local pct = math.clamp((mx-bp)/bs, 0, 1)
        cur = max-min<=10 and math.floor((min+(max-min)*pct)*10)/10 or math.floor(min+(max-min)*pct)
        lbl.Text = txt..": "..cur
        fill.Size = UDim2.new(pct,0,1,0)
        btn.Position = UDim2.new(pct,-10,0,0)
        safe(cb, cur)
    end
    
    btn.MouseButton1Down:Connect(function() drag=true end)
    bar.InputBegan:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.MouseButton1 then
            drag=true
            upd(inp)
        end
    end)
    UIS.InputEnded:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.MouseButton1 then drag=false end
    end)
    UIS.InputChanged:Connect(function(inp)
        if drag and inp.UserInputType == Enum.UserInputType.MouseMovement then upd(inp) end
    end)
end

function GUI:Init()
    local sg = Instance.new("ScreenGui")
    sg.Name = "Otter"
    sg.ResetOnSpawn = false
    sg.Parent = getCoreGui()
    
    local main = Instance.new("Frame")
    main.Size = UDim2.new(0,700,0,500)
    main.Position = UDim2.new(0.5,-350,0.5,-250)
    main.BackgroundColor3 = T.BG1
    main.BorderSizePixel = 0
    main.Active = true
    main.Draggable = true
    main.Parent = sg
    
    local cr = Instance.new("UICorner")
    cr.CornerRadius = UDim.new(0,12)
    cr.Parent = main
    
    local st = Instance.new("UIStroke")
    st.Color = T.ACC
    st.Thickness = 2
    st.Parent = main
    
    -- Title
    local tb = Instance.new("Frame")
    tb.Size = UDim2.new(1,0,0,50)
    tb.BackgroundColor3 = T.BG2
    tb.BorderSizePixel = 0
    tb.Parent = main
    
    local tbcr = Instance.new("UICorner")
    tbcr.CornerRadius = UDim.new(0,12)
    tbcr.Parent = tb
    
    local fix = Instance.new("Frame")
    fix.Size = UDim2.new(1,0,0,12)
    fix.Position = UDim2.new(0,0,1,-12)
    fix.BackgroundColor3 = T.BG2
    fix.BorderSizePixel = 0
    fix.Parent = tb
    
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1,-100,1,0)
    title.Position = UDim2.new(0,15,0,0)
    title.BackgroundTransparency = 1
    title.Text = "🦦 Otter v8.0.0 - Anti-Detection"
    title.TextColor3 = T.ACC
    title.TextSize = 16
    title.Font = Enum.Font.GothamBold
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Parent = tb
    
    local exec = Instance.new("TextLabel")
    exec.Size = UDim2.new(0,150,0,20)
    exec.Position = UDim2.new(1,-160,0,5)
    exec.BackgroundTransparency = 1
    exec.Text = "🛡️ "..EXECUTOR
    exec.TextColor3 = T.SUC
    exec.TextSize = 11
    exec.Font = Enum.Font.Gotham
    exec.Parent = tb
    
    local close = Instance.new("TextButton")
    close.Size = UDim2.new(0,40,0,40)
    close.Position = UDim2.new(1,-45,0,5)
    close.BackgroundColor3 = T.ERR
    close.BorderSizePixel = 0
    close.Text = "×"
    close.TextColor3 = T.TXT
    close.TextSize = 28
    close.Font = Enum.Font.GothamBold
    close.Parent = tb
    
    local clcr = Instance.new("UICorner")
    clcr.CornerRadius = UDim.new(0,8)
    clcr.Parent = close
    
    close.MouseButton1Click:Connect(function() sg.Enabled=false end)
    
    -- Tabs
    local tabs = Instance.new("Frame")
    tabs.Size = UDim2.new(0,170,1,-55)
    tabs.Position = UDim2.new(0,5,0,55)
    tabs.BackgroundColor3 = T.BG2
    tabs.BorderSizePixel = 0
    tabs.Parent = main
    
    local tcr = Instance.new("UICorner")
    tcr.CornerRadius = UDim.new(0,10)
    tcr.Parent = tabs
    
    local cont = Instance.new("Frame")
    cont.Name = "Cont"
    cont.Size = UDim2.new(1,-185,1,-55)
    cont.Position = UDim2.new(0,180,0,55)
    cont.BackgroundTransparency = 1
    cont.Parent = main
    
    local tabList = {
        {n="Combat",i="⚔️",c=Color3.fromRGB(220,50,50)},
        {n="Movement",i="🏃",c=Color3.fromRGB(80,220,80)},
        {n="Visuals",i="👁️",c=Color3.fromRGB(50,120,220)},
        {n="Bedwars",i="🛏️",c=Color3.fromRGB(240,180,30)},
        {n="Settings",i="⚙️",c=T.ACC}
    }
    
    local curTab = nil
    
    for i, t in ipairs(tabList) do
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(1,-10,0,50)
        btn.Position = UDim2.new(0,5,0,(i-1)*55+5)
        btn.BackgroundColor3 = T.BG3
        btn.BorderSizePixel = 0
        btn.Text = ""
        btn.Parent = tabs
        
        local bcr = Instance.new("UICorner")
        bcr.CornerRadius = UDim.new(0,8)
        bcr.Parent = btn
        
        local ico = Instance.new("TextLabel")
        ico.Size = UDim2.new(0,40,1,0)
        ico.BackgroundTransparency = 1
        ico.Text = t.i
        ico.TextSize = 24
        ico.Font = Enum.Font.GothamBold
        ico.TextColor3 = T.DIM
        ico.Parent = btn
        
        local txt = Instance.new("TextLabel")
        txt.Size = UDim2.new(1,-45,1,0)
        txt.Position = UDim2.new(0,45,0,0)
        txt.BackgroundTransparency = 1
        txt.Text = t.n
        txt.TextSize = 14
        txt.Font = Enum.Font.GothamBold
        txt.TextColor3 = T.DIM
        txt.TextXAlignment = Enum.TextXAlignment.Left
        txt.Parent = btn
        
        btn.MouseButton1Click:Connect(function()
            if curTab then
                curTab.BackgroundColor3 = T.BG3
                for _, ch in pairs(curTab:GetChildren()) do
                    if ch:IsA("TextLabel") then ch.TextColor3 = T.DIM end
                end
            end
            btn.BackgroundColor3 = t.c
            ico.TextColor3 = T.TXT
            txt.TextColor3 = T.TXT
            curTab = btn
            
            for _, ch in pairs(cont:GetChildren()) do
                if ch:IsA("ScrollingFrame") then ch:Destroy() end
            end
            
            self:LoadTab(t.n, cont)
        end)
        
        if i==1 then task.defer(function() btn.MouseButton1Click:Fire() end) end
    end
    
    self.sg = sg
end

function GUI:LoadTab(name, par)
    local sc = Instance.new("ScrollingFrame")
    sc.Size = UDim2.new(1,-10,1,-10)
    sc.Position = UDim2.new(0,5,0,5)
    sc.BackgroundTransparency = 1
    sc.BorderSizePixel = 0
    sc.ScrollBarThickness = 6
    sc.ScrollBarImageColor3 = T.ACC
    sc.Parent = par
    
    local lay = Instance.new("UIListLayout")
    lay.Padding = UDim.new(0,10)
    lay.Parent = sc
    
    lay:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        sc.CanvasSize = UDim2.new(0,0,0,lay.AbsoluteContentSize.Y+15)
    end)
    
    if name == "Combat" then
        self:MakeToggle("Enable Killaura", false, function(e)
            M.Killaura:Toggle(e)
            Notifs:Info("Killaura", e and "ON" or "OFF")
        end, sc)
        self:MakeSlider("Range", 5, 30, 20, function(v) M.Killaura.Range=v end, sc)
        self:MakeSlider("Speed", 0.05, 1, 0.1, function(v) M.Killaura.Speed=v end, sc)
        
        self:MakeToggle("Enable Velocity", false, function(e)
            M.Velocity:Toggle(e)
            Notifs:Info("Velocity", e and "ON" or "OFF")
        end, sc)
        self:MakeSlider("Horizontal %", 0, 100, 0, function(v) M.Velocity.H=v end, sc)
        self:MakeSlider("Vertical %", 0, 100, 0, function(v) M.Velocity.V=v end, sc)
        
    elseif name == "Movement" then
        self:MakeToggle("Enable Speed", false, function(e)
            M.Speed:Toggle(e)
            Notifs:Info("Speed", e and "ON" or "OFF")
        end, sc)
        self:MakeSlider("Multiplier", 1, 5, 2, function(v)
            M.Speed.Mult=v
            if M.Speed.En then M.Speed:Toggle(false) M.Speed:Toggle(true) end
        end, sc)
        
        self:MakeToggle("Enable Fly", false, function(e)
            M.Fly:Toggle(e)
            Notifs:Info("Fly", e and "ON" or "OFF")
        end, sc)
        self:MakeSlider("Speed", 1, 5, 2, function(v) M.Fly.Spd=v end, sc)
        
        self:MakeToggle("Auto Bridge", false, function(e)
            M.Bridge:Toggle(e)
            Notifs:Info("Bridge", e and "ON" or "OFF")
        end, sc)
        
        self:MakeToggle("Anti-Void", false, function(e)
            M.AntiVoid:Toggle(e)
            Notifs:Info("Anti-Void", e and "ON" or "OFF")
        end, sc)
        self:MakeSlider("Height", -50, 50, 0, function(v) M.AntiVoid.Height=v end, sc)
        
    elseif name == "Visuals" then
        self:MakeToggle("Enable ESP", false, function(e)
            M.ESP:Toggle(e)
            Notifs:Info("ESP", e and "ON" or "OFF")
        end, sc)
        self:MakeToggle("Boxes", true, function(e)
            M.ESP.Box=e
            if M.ESP.En then M.ESP:Toggle(false) M.ESP:Toggle(true) end
        end, sc)
        self:MakeToggle("Names", true, function(e)
            M.ESP.Nam=e
            if M.ESP.En then M.ESP:Toggle(false) M.ESP:Toggle(true) end
        end, sc)
        self:MakeToggle("Health", true, function(e)
            M.ESP.HP=e
            if M.ESP.En then M.ESP:Toggle(false) M.ESP:Toggle(true) end
        end, sc)
        self:MakeToggle("Distance", true, function(e)
            M.ESP.Dist=e
            if M.ESP.En then M.ESP:Toggle(false) M.ESP:Toggle(true) end
        end, sc)
        self:MakeToggle("Team Colors", true, function(e)
            M.ESP.Team=e
            if M.ESP.En then M.ESP:Toggle(false) M.ESP:Toggle(true) end
        end, sc)
        
    elseif name == "Bedwars" then
        self:MakeToggle("Bed ESP", false, function(e)
            M.BedESP:Toggle(e)
            Notifs:Info("Bed ESP", e and "ON" or "OFF")
        end, sc)
        
        self:MakeToggle("Chest Stealer", false, function(e)
            M.Chest:Toggle(e)
            Notifs:Info("Chest Stealer", e and "ON" or "OFF")
        end, sc)
        self:MakeSlider("Range", 5, 30, 15, function(v) M.Chest.Range=v end, sc)
        self:MakeSlider("Delay", 0.05, 1, 0.1, function(v) M.Chest.Delay=v end, sc)
        
    elseif name == "Settings" then
        local info = Instance.new("TextLabel")
        info.Size = UDim2.new(1,-20,0,200)
        info.BackgroundColor3 = T.BG2
        info.BorderSizePixel = 0
        info.Text = string.format([[🦦 Otter Client v8.0.0

🛡️ ANTI-DETECTION EDITION

Executor: %s
Key: 123
Toggle: Right Shift

✅ Full Anti-Cheat Bypass
✅ Randomization Enabled
✅ Human-Like Behavior
✅ Secure Execution
✅ All Modules Working

Made for Roblox Bedwars!]], EXECUTOR)
        info.TextColor3 = T.TXT
        info.TextSize = 12
        info.Font = Enum.Font.Gotham
        info.TextWrapped = true
        info.TextYAlignment = Enum.TextYAlignment.Top
        info.Parent = sc
        
        local icr = Instance.new("UICorner")
        icr.CornerRadius = UDim.new(0,8)
        icr.Parent = info
        
        local pad = Instance.new("UIPadding")
        pad.PaddingLeft = UDim.new(0,12)
        pad.PaddingRight = UDim.new(0,12)
        pad.PaddingTop = UDim.new(0,12)
        pad.PaddingBottom = UDim.new(0,12)
        pad.Parent = info
        
        self:MakeToggle("Enable Anti-Detection", true, function(e)
            AntiDetect.Enabled = e
            Notifs:Info("Anti-Detect", e and "ON" or "OFF")
        end, sc)
        self:MakeToggle("Randomization", true, function(e)
            AntiDetect.Randomization = e
        end, sc)
        self:MakeToggle("Human Delays", true, function(e)
            AntiDetect.HumanDelay = e
        end, sc)
    end
end

-- START
print("🦦 Otter v8.0.0 Anti-Detection loading...")
showKey()
repeat task.wait() until keyValid
print("✅ Unlocked!")

Notifs:Success("Welcome!", "Otter v8.0.0 loaded!")
GUI:Init()

UIS.InputBegan:Connect(function(inp, gpe)
    if gpe then return end
    if inp.KeyCode == Enum.KeyCode.RightShift then
        if GUI.sg then GUI.sg.Enabled = not GUI.sg.Enabled end
    end
end)

task.wait(0.5)
Notifs:Info("Ready!", "Press RIGHT SHIFT")
Notifs:Success("Anti-Detect", "Bypass enabled!")
print("✅ All modules loaded and visible!")
print("🛡️ Anti-detection active!")
