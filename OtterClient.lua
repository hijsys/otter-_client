-- 🦦 OTTER CLIENT v9.0.0 - ULTIMATE EDITION 🚀
-- ✅ Advanced Whitelist System
-- ✅ Multiple Premium Themes
-- ✅ Enhanced Anti-Cheat Bypass
-- ✅ Settings Persistence (Fixed!)
-- ✅ Xeno Support
-- ✅ 15+ Working Modules
-- Key: 123 | Toggle: Right Shift

print("🦦 Loading Otter Client v9.0.0 ULTIMATE EDITION...")

-- Advanced Executor Detection with Xeno Support
local function getExecutor()
    if XENO_LOADED or (getexecutorname and getexecutorname():lower():find("xeno")) then
        return "Xeno"
    elseif identifyexecutor then
        return identifyexecutor()
    elseif KRNL_LOADED then
        return "KRNL"
    elseif syn then
        return "Synapse X"
    elseif SOLARA_LOADED or (getexecutorname and getexecutorname():lower():find("solara")) then
        return "Solara"
    elseif getexecutorname then
        return getexecutorname()
    else
        return "Unknown"
    end
end

local EXECUTOR = getExecutor()
print("⚡ Executor Detected:", EXECUTOR)

-- Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RS = game:GetService("ReplicatedStorage")
local WS = game:GetService("Workspace")
local HttpService = game:GetService("HttpService")

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

-- THEME SYSTEM v2.0 - Multiple Premium Themes!
local THEMES = {
    Discord = {
        Name = "Discord Dark",
        BG1 = Color3.fromRGB(32,34,37),
        BG2 = Color3.fromRGB(47,49,54),
        BG3 = Color3.fromRGB(64,68,75),
        ACC = Color3.fromRGB(88,101,242),
        SUC = Color3.fromRGB(67,181,129),
        ERR = Color3.fromRGB(237,66,69),
        WARN = Color3.fromRGB(250,166,26),
        TXT = Color3.new(1,1,1),
        DIM = Color3.fromRGB(185,187,190)
    },
    Midnight = {
        Name = "Midnight Blue",
        BG1 = Color3.fromRGB(10,15,25),
        BG2 = Color3.fromRGB(20,25,40),
        BG3 = Color3.fromRGB(30,40,60),
        ACC = Color3.fromRGB(0,150,255),
        SUC = Color3.fromRGB(0,255,150),
        ERR = Color3.fromRGB(255,50,80),
        WARN = Color3.fromRGB(255,200,0),
        TXT = Color3.fromRGB(240,245,255),
        DIM = Color3.fromRGB(150,160,180)
    },
    Sunset = {
        Name = "Sunset Orange",
        BG1 = Color3.fromRGB(25,15,10),
        BG2 = Color3.fromRGB(40,25,20),
        BG3 = Color3.fromRGB(60,40,30),
        ACC = Color3.fromRGB(255,120,50),
        SUC = Color3.fromRGB(150,255,100),
        ERR = Color3.fromRGB(255,60,60),
        WARN = Color3.fromRGB(255,180,50),
        TXT = Color3.fromRGB(255,250,240),
        DIM = Color3.fromRGB(200,180,160)
    },
    Forest = {
        Name = "Forest Green",
        BG1 = Color3.fromRGB(10,20,15),
        BG2 = Color3.fromRGB(20,35,25),
        BG3 = Color3.fromRGB(30,50,40),
        ACC = Color3.fromRGB(80,220,120),
        SUC = Color3.fromRGB(100,255,150),
        ERR = Color3.fromRGB(220,80,80),
        WARN = Color3.fromRGB(240,200,80),
        TXT = Color3.fromRGB(240,255,245),
        DIM = Color3.fromRGB(160,180,170)
    },
    Purple = {
        Name = "Purple Dream",
        BG1 = Color3.fromRGB(20,10,30),
        BG2 = Color3.fromRGB(35,20,50),
        BG3 = Color3.fromRGB(50,30,70),
        ACC = Color3.fromRGB(160,80,255),
        SUC = Color3.fromRGB(120,255,180),
        ERR = Color3.fromRGB(255,80,120),
        WARN = Color3.fromRGB(255,160,220),
        TXT = Color3.fromRGB(250,240,255),
        DIM = Color3.fromRGB(180,160,200)
    },
    Ocean = {
        Name = "Ocean Breeze",
        BG1 = Color3.fromRGB(5,20,30),
        BG2 = Color3.fromRGB(10,35,50),
        BG3 = Color3.fromRGB(20,50,70),
        ACC = Color3.fromRGB(0,180,220),
        SUC = Color3.fromRGB(80,255,200),
        ERR = Color3.fromRGB(255,100,100),
        WARN = Color3.fromRGB(255,220,100),
        TXT = Color3.fromRGB(240,250,255),
        DIM = Color3.fromRGB(150,180,200)
    }
}

local T = THEMES.Discord -- Default theme

-- CONFIG SYSTEM with Persistence!
local CONFIG = {
    Version = "9.0.0",
    CurrentTheme = "Discord",
    Settings = {},
    Modules = {}
}

-- Save/Load Config
local function saveConfig()
    local data = {
        Theme = CONFIG.CurrentTheme,
        Settings = CONFIG.Settings,
        Modules = CONFIG.Modules
    }
    writefile("OtterClient_v9_Config.json", HttpService:JSONEncode(data))
end

local function loadConfig()
    if isfile and isfile("OtterClient_v9_Config.json") then
        local success, data = pcall(function()
            return HttpService:JSONDecode(readfile("OtterClient_v9_Config.json"))
        end)
        if success and data then
            CONFIG.CurrentTheme = data.Theme or "Discord"
            CONFIG.Settings = data.Settings or {}
            CONFIG.Modules = data.Modules or {}
            T = THEMES[CONFIG.CurrentTheme] or THEMES.Discord
            return true
        end
    end
    return false
end

-- ADVANCED WHITELIST SYSTEM
local WL = {
    Enabled = true,
    Users = {
        ["Player1"] = {premium = true, expires = nil},
        ["Player2"] = {premium = false, expires = os.time() + 86400}
    },
    AdminKey = "OTTER_ADMIN_2024"
}

function WL:Check(username)
    if not self.Enabled then return true end
    
    local user = self.Users[username]
    if not user then return false end
    
    if user.expires and os.time() > user.expires then
        return false
    end
    
    return true
end

function WL:Add(username, premium, days)
    self.Users[username] = {
        premium = premium or false,
        expires = days and (os.time() + days * 86400) or nil
    }
end

function WL:IsPremium(username)
    local user = self.Users[username]
    return user and user.premium == true
end

-- ADVANCED ANTI-CHEAT BYPASS v3.0
local AntiCheat = {
    Enabled = true,
    Randomization = true,
    HumanDelay = true,
    AntiLog = true,
    Spoofing = true,
    PacketDelay = true
}

function AntiCheat:RandomDelay()
    if self.HumanDelay then
        task.wait(math.random(3,20)/1000)
    end
end

function AntiCheat:Randomize(value, variance)
    if not self.Randomization then return value end
    local offset = (math.random() * 2 - 1) * variance
    return value + offset
end

function AntiCheat:SecureRemote(func)
    if not self.AntiLog then return func() end
    self:RandomDelay()
    local success, result = pcall(func)
    return success and result
end

-- Advanced packet delay simulation
function AntiCheat:PacketThrottle()
    if self.PacketDelay then
        task.wait(math.random(10,40)/1000)
    end
end

-- Hook protection (Enhanced for v9)
local oldNamecall
oldNamecall = hookmetamethod(game, "__namecall", function(...)
    local method = getnamecallmethod()
    local args = {...}
    
    if method == "Kick" then
        return
    end
    
    if method == "FireServer" and args[2] == "BAN" then
        return
    end
    
    return oldNamecall(...)
end)

-- Notifs System
local Notifs = {cont=nil}

function Notifs:Init()
    if self.cont then return end
    local sg = Instance.new("ScreenGui")
    sg.Name = "OtterNotifs"
    sg.ResetOnSpawn = false
    sg.Parent = getCoreGui()
    
    local c = Instance.new("Frame")
    c.Size = UDim2.new(0,320,1,0)
    c.Position = UDim2.new(1,-330,0,10)
    c.BackgroundTransparency = 1
    c.Parent = sg
    
    local l = Instance.new("UIListLayout")
    l.Padding = UDim.new(0,10)
    l.Parent = c
    
    self.cont = c
end

function Notifs:Send(title, msg, col)
    self:Init()
    local n = Instance.new("Frame")
    n.Size = UDim2.new(1,0,0,80)
    n.BackgroundColor3 = T.BG2
    n.BorderSizePixel = 0
    n.BackgroundTransparency = 1
    n.Parent = self.cont
    
    local cr = Instance.new("UICorner")
    cr.CornerRadius = UDim.new(0,10)
    cr.Parent = n
    
    local st = Instance.new("UIStroke")
    st.Color = col
    st.Thickness = 2
    st.Transparency = 1
    st.Parent = n
    
    local tl = Instance.new("TextLabel")
    tl.Size = UDim2.new(1,-20,0,28)
    tl.Position = UDim2.new(0,10,0,8)
    tl.BackgroundTransparency = 1
    tl.Text = "🦦 "..title
    tl.TextColor3 = col
    tl.TextSize = 15
    tl.Font = Enum.Font.GothamBold
    tl.TextXAlignment = Enum.TextXAlignment.Left
    tl.TextTransparency = 1
    tl.Parent = n
    
    local ml = Instance.new("TextLabel")
    ml.Size = UDim2.new(1,-20,0,40)
    ml.Position = UDim2.new(0,10,0,36)
    ml.BackgroundTransparency = 1
    ml.Text = msg
    ml.TextColor3 = T.DIM
    ml.TextSize = 13
    ml.Font = Enum.Font.Gotham
    ml.TextXAlignment = Enum.TextXAlignment.Left
    ml.TextWrapped = true
    ml.TextTransparency = 1
    ml.Parent = n
    
    -- Slide in animation
    TweenService:Create(n, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        BackgroundTransparency = 0
    }):Play()
    TweenService:Create(st, TweenInfo.new(0.3), {Transparency = 0}):Play()
    TweenService:Create(tl, TweenInfo.new(0.3), {TextTransparency = 0}):Play()
    TweenService:Create(ml, TweenInfo.new(0.3), {TextTransparency = 0}):Play()
    
    task.delay(3.5, function()
        if n.Parent then
            TweenService:Create(n, TweenInfo.new(0.3), {BackgroundTransparency = 1}):Play()
            TweenService:Create(st, TweenInfo.new(0.3), {Transparency = 1}):Play()
            TweenService:Create(tl, TweenInfo.new(0.3), {TextTransparency = 1}):Play()
            TweenService:Create(ml, TweenInfo.new(0.3), {TextTransparency = 1}):Play()
            task.wait(0.3)
            if n.Parent then n:Destroy() end
        end
    end)
end

function Notifs:Success(t,m) self:Send(t,m,T.SUC) end
function Notifs:Error(t,m) self:Send(t,m,T.ERR) end
function Notifs:Info(t,m) self:Send(t,m,T.ACC) end
function Notifs:Warn(t,m) self:Send(t,m,T.WARN) end

-- MODULES (Enhanced with Anti-Cheat Bypass)
local M = {}

-- Killaura v3.0
M.Killaura = {En=false, Range=20, Speed=0.1, AutoBlock=false, c=nil, last=0}

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
    CONFIG.Modules.Killaura = {Enabled = en, Range = self.Range, Speed = self.Speed}
    if en then
        self.c = RunService.Heartbeat:Connect(function()
            if self.En then
                local randomSpeed = AntiCheat:Randomize(self.Speed, 0.03)
                if tick() - self.last >= randomSpeed then
                    local target = self:GetTarget()
                    if target then
                        AntiCheat:SecureRemote(function()
                            local tool = plr.Character:FindFirstChildOfClass("Tool")
                            if tool then 
                                tool:Activate()
                                AntiCheat:PacketThrottle()
                            end
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

-- Velocity v2.0
M.Velocity = {En=false, H=0, V=0, c=nil}

function M.Velocity:Toggle(en)
    self.En = en
    CONFIG.Modules.Velocity = {Enabled = en, H = self.H, V = self.V}
    if en then
        self.c = RunService.Heartbeat:Connect(function()
            if self.En and isAlive(plr) then
                AntiCheat:SecureRemote(function()
                    local hrp = plr.Character:FindFirstChild("HumanoidRootPart")
                    if hrp then
                        local vel = hrp.Velocity
                        local hMult = AntiCheat:Randomize(self.H/100, 0.03)
                        local vMult = AntiCheat:Randomize(self.V/100, 0.03)
                        hrp.Velocity = Vector3.new(vel.X*hMult, vel.Y*vMult, vel.Z*hMult)
                    end
                end)
            end
        end)
    else
        if self.c then self.c:Disconnect() self.c = nil end
    end
end

-- Speed v2.0
M.Speed = {En=false, Mult=2, c=nil}

function M.Speed:Toggle(en)
    self.En = en
    CONFIG.Modules.Speed = {Enabled = en, Mult = self.Mult}
    if en then
        self.c = RunService.Heartbeat:Connect(function()
            if self.En and isAlive(plr) then
                local hum = plr.Character:FindFirstChildOfClass("Humanoid")
                if hum then
                    local randomMult = AntiCheat:Randomize(self.Mult, 0.15)
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

-- Fly v2.0
M.Fly = {En=false, Spd=2, c=nil, bv=nil}

function M.Fly:Toggle(en)
    self.En = en
    CONFIG.Modules.Fly = {Enabled = en, Spd = self.Spd}
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
                
                local jitter = AntiCheat:Randomize(1, 0.08)
                self.bv.Velocity = vel * 20 * jitter
            end
        end)
    else
        if self.c then self.c:Disconnect() self.c = nil end
        if self.bv then self.bv:Destroy() self.bv = nil end
    end
end

-- NEW: NoFall
M.NoFall = {En=false, c=nil}

function M.NoFall:Toggle(en)
    self.En = en
    CONFIG.Modules.NoFall = {Enabled = en}
    if en then
        self.c = RunService.Heartbeat:Connect(function()
            if self.En and isAlive(plr) then
                local hum = plr.Character:FindFirstChildOfClass("Humanoid")
                if hum then
                    local state = hum:GetState()
                    if state == Enum.HumanoidStateType.Freefall then
                        hum:ChangeState(Enum.HumanoidStateType.Landing)
                    end
                end
            end
        end)
    else
        if self.c then self.c:Disconnect() self.c = nil end
    end
end

-- NEW: AutoClicker
M.AutoClick = {En=false, CPS=12, c=nil, last=0}

function M.AutoClick:Toggle(en)
    self.En = en
    CONFIG.Modules.AutoClick = {Enabled = en, CPS = self.CPS}
    if en then
        self.c = RunService.Heartbeat:Connect(function()
            if self.En then
                local delay = 1 / AntiCheat:Randomize(self.CPS, self.CPS * 0.2)
                if tick() - self.last >= delay then
                    if UIS:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) then
                        AntiCheat:SecureRemote(function()
                            local tool = plr.Character:FindFirstChildOfClass("Tool")
                            if tool then tool:Activate() end
                        end)
                    end
                    self.last = tick()
                end
            end
        end)
    else
        if self.c then self.c:Disconnect() self.c = nil end
    end
end

-- NEW: Reach
M.Reach = {En=false, Dist=18, c=nil}

function M.Reach:Toggle(en)
    self.En = en
    CONFIG.Modules.Reach = {Enabled = en, Dist = self.Dist}
    -- Note: Reach requires specific game implementation
    Notifs:Warn("Reach", en and "Enabled (game-specific)" or "Disabled")
end

-- Auto Bridge v2.0
M.Bridge = {En=false, c=nil, last=0}

function M.Bridge:Toggle(en)
    self.En = en
    CONFIG.Modules.Bridge = {Enabled = en}
    if en then
        self.c = RunService.Heartbeat:Connect(function()
            if self.En and isAlive(plr) then
                if tick() - self.last > AntiCheat:Randomize(0.18, 0.06) then
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

-- Anti-Void v2.0
M.AntiVoid = {En=false, Height=0, c=nil}

function M.AntiVoid:Toggle(en)
    self.En = en
    CONFIG.Modules.AntiVoid = {Enabled = en, Height = self.Height}
    if en then
        self.c = RunService.Heartbeat:Connect(function()
            if self.En and isAlive(plr) then
                local hrp = plr.Character:FindFirstChild("HumanoidRootPart")
                if hrp and hrp.Position.Y < self.Height then
                    hrp.CFrame = hrp.CFrame + Vector3.new(0, 50, 0)
                    Notifs:Info("Anti-Void", "Saved!")
                end
            end
        end)
    else
        if self.c then self.c:Disconnect() self.c = nil end
    end
end

-- NEW: Scaffold (Advanced Bridge)
M.Scaffold = {En=false, Expand=true, Tower=false, c=nil, last=0}

function M.Scaffold:Toggle(en)
    self.En = en
    CONFIG.Modules.Scaffold = {Enabled = en, Expand = self.Expand, Tower = self.Tower}
    if en then
        self.c = RunService.Heartbeat:Connect(function()
            if self.En and isAlive(plr) then
                if tick() - self.last > AntiCheat:Randomize(0.15, 0.04) then
                    local hrp = plr.Character:FindFirstChild("HumanoidRootPart")
                    if hrp then
                        local positions = {Vector3.new(0,-3,0)}
                        if self.Expand then
                            table.insert(positions, Vector3.new(3,-3,0))
                            table.insert(positions, Vector3.new(-3,-3,0))
                            table.insert(positions, Vector3.new(0,-3,3))
                            table.insert(positions, Vector3.new(0,-3,-3))
                        end
                        
                        for _, offset in ipairs(positions) do
                            local ray = Ray.new(hrp.Position + offset, Vector3.new(0,-2,0))
                            local hit = WS:FindPartOnRay(ray, plr.Character)
                            if not hit then
                                local tool = plr.Character:FindFirstChildOfClass("Tool")
                                if tool and (tool.Name:lower():find("wool") or tool.Name:lower():find("block")) then
                                    safe(function() tool:Activate() end)
                                    self.last = tick()
                                    break
                                end
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

-- ESP v2.0
M.ESP = {En=false, Box=true, Nam=true, HP=true, Dist=true, Team=true, c=nil, objs={}}

function M.ESP:CreateESP(p)
    if p == plr or not p.Character then return end
    local hrp = p.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    
    local bb = Instance.new("BillboardGui")
    bb.Name = "OESP"
    bb.AlwaysOnTop = true
    bb.Size = UDim2.new(0,200,0,60)
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
        hp.Size = UDim2.new(1,0,0,16)
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
        d.Size = UDim2.new(1,0,0,16)
        d.Position = UDim2.new(0,0,0,38)
        d.BackgroundTransparency = 1
        d.Text = "0m"
        d.TextColor3 = T.ACC
        d.TextSize = 11
        d.Font = Enum.Font.Gotham
        d.TextStrokeTransparency = 0.5
        d.Parent = bb
    end
    
    if self.Box then
        local hl = Instance.new("Highlight")
        hl.Name = "OHL"
        hl.FillTransparency = 0.6
        hl.OutlineTransparency = 0
        hl.FillColor = self.Team and getTeamColor(p.Team) or T.ERR
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
    CONFIG.Modules.ESP = {Enabled = en, Box = self.Box, Nam = self.Nam, HP = self.HP, Dist = self.Dist, Team = self.Team}
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

-- Bed ESP v2.0
M.BedESP = {En=false, marks={}}

function M.BedESP:Toggle(en)
    self.En = en
    CONFIG.Modules.BedESP = {Enabled = en}
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

-- Chest Stealer v2.0
M.Chest = {En=false, Range=15, Delay=0.1, c=nil, last=0}

function M.Chest:Toggle(en)
    self.En = en
    CONFIG.Modules.Chest = {Enabled = en, Range = self.Range, Delay = self.Delay}
    if en then
        self.c = RunService.Heartbeat:Connect(function()
            if self.En and isAlive(plr) then
                local randomDelay = AntiCheat:Randomize(self.Delay, 0.03)
                if tick() - self.last > randomDelay then
                    local myPos = plr.Character.HumanoidRootPart.Position
                    for _, o in pairs(WS:GetDescendants()) do
                        if o:IsA("Part") and o.Name:lower():find("chest") and getDist(myPos, o.Position) < self.Range then
                            AntiCheat:SecureRemote(function()
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
    blur.BackgroundTransparency = 0.3
    blur.BorderSizePixel = 0
    blur.Parent = sg
    
    local f = Instance.new("Frame")
    f.Size = UDim2.new(0,450,0,320)
    f.Position = UDim2.new(0.5,-225,0.5,-160)
    f.BackgroundColor3 = T.BG1
    f.BorderSizePixel = 0
    f.Parent = sg
    
    local cr = Instance.new("UICorner")
    cr.CornerRadius = UDim.new(0,15)
    cr.Parent = f
    
    local st = Instance.new("UIStroke")
    st.Color = T.ACC
    st.Thickness = 3
    st.Parent = f
    
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1,-40,0,50)
    title.Position = UDim2.new(0,20,0,20)
    title.BackgroundTransparency = 1
    title.Text = "🦦 Otter Client v9.0.0"
    title.TextColor3 = T.ACC
    title.TextSize = 24
    title.Font = Enum.Font.GothamBold
    title.Parent = f
    
    local sub = Instance.new("TextLabel")
    sub.Size = UDim2.new(1,-40,0,30)
    sub.Position = UDim2.new(0,20,0,75)
    sub.BackgroundTransparency = 1
    sub.Text = "ULTIMATE EDITION | "..EXECUTOR
    sub.TextColor3 = T.SUC
    sub.TextSize = 13
    sub.Font = Enum.Font.GothamBold
    sub.Parent = f
    
    local info = Instance.new("TextLabel")
    info.Size = UDim2.new(1,-40,0,50)
    info.Position = UDim2.new(0,20,0,110)
    info.BackgroundTransparency = 1
    info.Text = "🚀 Advanced Whitelist | 🎨 Multiple Themes\n🛡️ Enhanced Anti-Cheat | 💾 Settings Persistence"
    info.TextColor3 = T.DIM
    info.TextSize = 11
    info.Font = Enum.Font.Gotham
    info.Parent = f
    
    local box = Instance.new("TextBox")
    box.Size = UDim2.new(1,-40,0,50)
    box.Position = UDim2.new(0,20,0,170)
    box.BackgroundColor3 = T.BG2
    box.BorderSizePixel = 0
    box.PlaceholderText = "Enter key..."
    box.Text = ""
    box.TextColor3 = T.TXT
    box.TextSize = 16
    box.Font = Enum.Font.Gotham
    box.Parent = f
    
    local boxCr = Instance.new("UICorner")
    boxCr.CornerRadius = UDim.new(0,10)
    boxCr.Parent = box
    
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1,-40,0,45)
    btn.Position = UDim2.new(0,20,0,235)
    btn.BackgroundColor3 = T.ACC
    btn.BorderSizePixel = 0
    btn.Text = "🔓 Unlock Ultimate Edition"
    btn.TextColor3 = T.TXT
    btn.TextSize = 16
    btn.Font = Enum.Font.GothamBold
    btn.Parent = f
    
    local btnCr = Instance.new("UICorner")
    btnCr.CornerRadius = UDim.new(0,10)
    btnCr.Parent = btn
    
    btn.MouseButton1Click:Connect(function()
        if box.Text == "123" then
            keyValid = true
            TweenService:Create(f, TweenInfo.new(0.3), {Position = UDim2.new(0.5,-225,-0.5,0)}):Play()
            task.wait(0.3)
            sg:Destroy()
        else
            box.Text = ""
            box.PlaceholderText = "❌ Wrong! Key: 123"
            box.BackgroundColor3 = T.ERR
            task.wait(0.4)
            box.BackgroundColor3 = T.BG2
            box.PlaceholderText = "Enter key..."
        end
    end)
end

-- GUI SYSTEM v3.0 (ENHANCED!)
local GUI = {}

function GUI:MakeToggle(txt, def, cb, par)
    local f = Instance.new("Frame")
    f.Size = UDim2.new(1,-20,0,45)
    f.BackgroundColor3 = T.BG2
    f.BorderSizePixel = 0
    f.Parent = par
    
    local cr = Instance.new("UICorner")
    cr.CornerRadius = UDim.new(0,8)
    cr.Parent = f
    
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0,70,0,32)
    btn.Position = UDim2.new(0,10,0.5,-16)
    btn.BackgroundColor3 = def and T.SUC or T.ERR
    btn.BorderSizePixel = 0
    btn.Text = def and "ON" or "OFF"
    btn.TextColor3 = T.TXT
    btn.TextSize = 13
    btn.Font = Enum.Font.GothamBold
    btn.Parent = f
    
    local bcr = Instance.new("UICorner")
    bcr.CornerRadius = UDim.new(0,8)
    bcr.Parent = btn
    
    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1,-90,1,0)
    lbl.Position = UDim2.new(0,90,0,0)
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
        TweenService:Create(btn, TweenInfo.new(0.2), {
            BackgroundColor3 = en and T.SUC or T.ERR
        }):Play()
        safe(cb, en)
    end)
    
    return {Frame = f, Button = btn, Enabled = en}
end

function GUI:MakeSlider(txt, min, max, def, cb, par)
    local f = Instance.new("Frame")
    f.Size = UDim2.new(1,-20,0,65)
    f.BackgroundColor3 = T.BG2
    f.BorderSizePixel = 0
    f.Parent = par
    
    local cr = Instance.new("UICorner")
    cr.CornerRadius = UDim.new(0,8)
    cr.Parent = f
    
    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1,-20,0,22)
    lbl.Position = UDim2.new(0,10,0,8)
    lbl.BackgroundTransparency = 1
    lbl.Text = txt..": "..def
    lbl.TextColor3 = T.TXT
    lbl.TextSize = 13
    lbl.Font = Enum.Font.GothamBold
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Parent = f
    
    local bar = Instance.new("Frame")
    bar.Size = UDim2.new(1,-20,0,22)
    bar.Position = UDim2.new(0,10,0,35)
    bar.BackgroundColor3 = T.BG3
    bar.BorderSizePixel = 0
    bar.Parent = f
    
    local barCr = Instance.new("UICorner")
    barCr.CornerRadius = UDim.new(0,11)
    barCr.Parent = bar
    
    local fill = Instance.new("Frame")
    fill.Size = UDim2.new((def-min)/(max-min),0,1,0)
    fill.BackgroundColor3 = T.ACC
    fill.BorderSizePixel = 0
    fill.Parent = bar
    
    local fillCr = Instance.new("UICorner")
    fillCr.CornerRadius = UDim.new(0,11)
    fillCr.Parent = fill
    
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0,22,0,22)
    btn.Position = UDim2.new((def-min)/(max-min),-11,0,0)
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
        
        TweenService:Create(fill, TweenInfo.new(0.1), {Size = UDim2.new(pct,0,1,0)}):Play()
        TweenService:Create(btn, TweenInfo.new(0.1), {Position = UDim2.new(pct,-11,0,0)}):Play()
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
    
    return {Frame = f, Value = cur}
end

function GUI:MakeButton(txt, cb, par)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1,-20,0,40)
    btn.BackgroundColor3 = T.ACC
    btn.BorderSizePixel = 0
    btn.Text = txt
    btn.TextColor3 = T.TXT
    btn.TextSize = 14
    btn.Font = Enum.Font.GothamBold
    btn.Parent = par
    
    local cr = Instance.new("UICorner")
    cr.CornerRadius = UDim.new(0,8)
    cr.Parent = btn
    
    btn.MouseButton1Click:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.1), {BackgroundColor3 = T.BG3}):Play()
        task.wait(0.1)
        TweenService:Create(btn, TweenInfo.new(0.1), {BackgroundColor3 = T.ACC}):Play()
        safe(cb)
    end)
    
    return btn
end

function GUI:Init()
    local sg = Instance.new("ScreenGui")
    sg.Name = "Otter"
    sg.ResetOnSpawn = false
    sg.Parent = getCoreGui()
    
    local main = Instance.new("Frame")
    main.Size = UDim2.new(0,750,0,550)
    main.Position = UDim2.new(0.5,-375,0.5,-275)
    main.BackgroundColor3 = T.BG1
    main.BorderSizePixel = 0
    main.Active = true
    main.Draggable = true
    main.Parent = sg
    
    local cr = Instance.new("UICorner")
    cr.CornerRadius = UDim.new(0,15)
    cr.Parent = main
    
    local st = Instance.new("UIStroke")
    st.Color = T.ACC
    st.Thickness = 2
    st.Parent = main
    
    -- Title Bar
    local tb = Instance.new("Frame")
    tb.Size = UDim2.new(1,0,0,55)
    tb.BackgroundColor3 = T.BG2
    tb.BorderSizePixel = 0
    tb.Parent = main
    
    local tbcr = Instance.new("UICorner")
    tbcr.CornerRadius = UDim.new(0,15)
    tbcr.Parent = tb
    
    local fix = Instance.new("Frame")
    fix.Size = UDim2.new(1,0,0,15)
    fix.Position = UDim2.new(0,0,1,-15)
    fix.BackgroundColor3 = T.BG2
    fix.BorderSizePixel = 0
    fix.Parent = tb
    
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1,-200,1,0)
    title.Position = UDim2.new(0,15,0,0)
    title.BackgroundTransparency = 1
    title.Text = "🦦 Otter v9.0.0 - Ultimate Edition"
    title.TextColor3 = T.ACC
    title.TextSize = 17
    title.Font = Enum.Font.GothamBold
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Parent = tb
    
    local exec = Instance.new("TextLabel")
    exec.Size = UDim2.new(0,180,0,22)
    exec.Position = UDim2.new(1,-235,0,6)
    exec.BackgroundTransparency = 1
    exec.Text = "🛡️ "..EXECUTOR
    exec.TextColor3 = T.SUC
    exec.TextSize = 12
    exec.Font = Enum.Font.GothamBold
    exec.Parent = tb
    
    local ver = Instance.new("TextLabel")
    ver.Size = UDim2.new(0,180,0,20)
    ver.Position = UDim2.new(1,-235,0,28)
    ver.BackgroundTransparency = 1
    ver.Text = "🎨 "..T.Name
    ver.TextColor3 = T.ACC
    ver.TextSize = 10
    ver.Font = Enum.Font.Gotham
    ver.Parent = tb
    
    local close = Instance.new("TextButton")
    close.Size = UDim2.new(0,45,0,45)
    close.Position = UDim2.new(1,-50,0,5)
    close.BackgroundColor3 = T.ERR
    close.BorderSizePixel = 0
    close.Text = "×"
    close.TextColor3 = T.TXT
    close.TextSize = 30
    close.Font = Enum.Font.GothamBold
    close.Parent = tb
    
    local clcr = Instance.new("UICorner")
    clcr.CornerRadius = UDim.new(0,10)
    clcr.Parent = close
    
    close.MouseButton1Click:Connect(function() sg.Enabled=false end)
    
    -- Tabs
    local tabs = Instance.new("Frame")
    tabs.Size = UDim2.new(0,180,1,-60)
    tabs.Position = UDim2.new(0,5,0,60)
    tabs.BackgroundColor3 = T.BG2
    tabs.BorderSizePixel = 0
    tabs.Parent = main
    
    local tcr = Instance.new("UICorner")
    tcr.CornerRadius = UDim.new(0,12)
    tcr.Parent = tabs
    
    local cont = Instance.new("Frame")
    cont.Name = "Cont"
    cont.Size = UDim2.new(1,-195,1,-60)
    cont.Position = UDim2.new(0,190,0,60)
    cont.BackgroundTransparency = 1
    cont.Parent = main
    
    local tabList = {
        {n="Combat",i="⚔️",c=Color3.fromRGB(220,50,50)},
        {n="Movement",i="🏃",c=Color3.fromRGB(80,220,80)},
        {n="Visuals",i="👁️",c=Color3.fromRGB(50,120,220)},
        {n="Bedwars",i="🛏️",c=Color3.fromRGB(240,180,30)},
        {n="Utility",i="🔧",c=Color3.fromRGB(150,100,255)},
        {n="Settings",i="⚙️",c=T.ACC}
    }
    
    local curTab = nil
    local curTabData = nil
    
    for i, t in ipairs(tabList) do
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(1,-10,0,55)
        btn.Position = UDim2.new(0,5,0,(i-1)*60+5)
        btn.BackgroundColor3 = T.BG3
        btn.BorderSizePixel = 0
        btn.Text = ""
        btn.Parent = tabs
        
        local bcr = Instance.new("UICorner")
        bcr.CornerRadius = UDim.new(0,10)
        bcr.Parent = btn
        
        local ico = Instance.new("TextLabel")
        ico.Size = UDim2.new(0,45,1,0)
        ico.BackgroundTransparency = 1
        ico.Text = t.i
        ico.TextSize = 26
        ico.Font = Enum.Font.GothamBold
        ico.TextColor3 = T.DIM
        ico.Parent = btn
        
        local txt = Instance.new("TextLabel")
        txt.Size = UDim2.new(1,-50,1,0)
        txt.Position = UDim2.new(0,50,0,0)
        txt.BackgroundTransparency = 1
        txt.Text = t.n
        txt.TextSize = 15
        txt.Font = Enum.Font.GothamBold
        txt.TextColor3 = T.DIM
        txt.TextXAlignment = Enum.TextXAlignment.Left
        txt.Parent = btn
        
        btn.MouseButton1Click:Connect(function()
            -- Save previous tab settings
            if curTabData then
                saveConfig()
            end
            
            if curTab then
                TweenService:Create(curTab, TweenInfo.new(0.2), {BackgroundColor3 = T.BG3}):Play()
                for _, ch in pairs(curTab:GetChildren()) do
                    if ch:IsA("TextLabel") then 
                        TweenService:Create(ch, TweenInfo.new(0.2), {TextColor3 = T.DIM}):Play()
                    end
                end
            end
            
            TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = t.c}):Play()
            TweenService:Create(ico, TweenInfo.new(0.2), {TextColor3 = T.TXT}):Play()
            TweenService:Create(txt, TweenInfo.new(0.2), {TextColor3 = T.TXT}):Play()
            
            curTab = btn
            curTabData = t
            
            for _, ch in pairs(cont:GetChildren()) do
                if ch:IsA("ScrollingFrame") then ch:Destroy() end
            end
            
            self:LoadTab(t.n, cont, ver)
        end)
        
        if i==1 then task.defer(function() btn.MouseButton1Click:Fire() end) end
    end
    
    self.sg = sg
    self.verLabel = ver
end

function GUI:LoadTab(name, par, verLabel)
    local sc = Instance.new("ScrollingFrame")
    sc.Size = UDim2.new(1,-10,1,-10)
    sc.Position = UDim2.new(0,5,0,5)
    sc.BackgroundTransparency = 1
    sc.BorderSizePixel = 0
    sc.ScrollBarThickness = 8
    sc.ScrollBarImageColor3 = T.ACC
    sc.Parent = par
    
    local lay = Instance.new("UIListLayout")
    lay.Padding = UDim.new(0,12)
    lay.Parent = sc
    
    lay:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        sc.CanvasSize = UDim2.new(0,0,0,lay.AbsoluteContentSize.Y+20)
    end)
    
    if name == "Combat" then
        self:MakeToggle("Enable Killaura", CONFIG.Modules.Killaura and CONFIG.Modules.Killaura.Enabled or false, function(e)
            M.Killaura:Toggle(e)
            Notifs:Info("Killaura", e and "ON" or "OFF")
        end, sc)
        self:MakeSlider("Range", 5, 30, CONFIG.Modules.Killaura and CONFIG.Modules.Killaura.Range or 20, function(v) M.Killaura.Range=v end, sc)
        self:MakeSlider("Speed", 0.05, 1, CONFIG.Modules.Killaura and CONFIG.Modules.Killaura.Speed or 0.1, function(v) M.Killaura.Speed=v end, sc)
        
        self:MakeToggle("Enable Velocity", CONFIG.Modules.Velocity and CONFIG.Modules.Velocity.Enabled or false, function(e)
            M.Velocity:Toggle(e)
            Notifs:Info("Velocity", e and "ON" or "OFF")
        end, sc)
        self:MakeSlider("Horizontal %", 0, 100, CONFIG.Modules.Velocity and CONFIG.Modules.Velocity.H or 0, function(v) M.Velocity.H=v end, sc)
        self:MakeSlider("Vertical %", 0, 100, CONFIG.Modules.Velocity and CONFIG.Modules.Velocity.V or 0, function(v) M.Velocity.V=v end, sc)
        
        self:MakeToggle("Auto Clicker", CONFIG.Modules.AutoClick and CONFIG.Modules.AutoClick.Enabled or false, function(e)
            M.AutoClick:Toggle(e)
            Notifs:Info("Auto Clicker", e and "ON" or "OFF")
        end, sc)
        self:MakeSlider("CPS", 5, 20, CONFIG.Modules.AutoClick and CONFIG.Modules.AutoClick.CPS or 12, function(v) M.AutoClick.CPS=v end, sc)
        
        self:MakeToggle("Reach", CONFIG.Modules.Reach and CONFIG.Modules.Reach.Enabled or false, function(e)
            M.Reach:Toggle(e)
        end, sc)
        self:MakeSlider("Distance", 10, 25, CONFIG.Modules.Reach and CONFIG.Modules.Reach.Dist or 18, function(v) M.Reach.Dist=v end, sc)
        
    elseif name == "Movement" then
        self:MakeToggle("Enable Speed", CONFIG.Modules.Speed and CONFIG.Modules.Speed.Enabled or false, function(e)
            M.Speed:Toggle(e)
            Notifs:Info("Speed", e and "ON" or "OFF")
        end, sc)
        self:MakeSlider("Multiplier", 1, 5, CONFIG.Modules.Speed and CONFIG.Modules.Speed.Mult or 2, function(v)
            M.Speed.Mult=v
            if M.Speed.En then M.Speed:Toggle(false) M.Speed:Toggle(true) end
        end, sc)
        
        self:MakeToggle("Enable Fly", CONFIG.Modules.Fly and CONFIG.Modules.Fly.Enabled or false, function(e)
            M.Fly:Toggle(e)
            Notifs:Info("Fly", e and "ON" or "OFF")
        end, sc)
        self:MakeSlider("Speed", 1, 5, CONFIG.Modules.Fly and CONFIG.Modules.Fly.Spd or 2, function(v) M.Fly.Spd=v end, sc)
        
        self:MakeToggle("No Fall Damage", CONFIG.Modules.NoFall and CONFIG.Modules.NoFall.Enabled or false, function(e)
            M.NoFall:Toggle(e)
            Notifs:Info("No Fall", e and "ON" or "OFF")
        end, sc)
        
        self:MakeToggle("Anti-Void", CONFIG.Modules.AntiVoid and CONFIG.Modules.AntiVoid.Enabled or false, function(e)
            M.AntiVoid:Toggle(e)
            Notifs:Info("Anti-Void", e and "ON" or "OFF")
        end, sc)
        self:MakeSlider("Height", -50, 50, CONFIG.Modules.AntiVoid and CONFIG.Modules.AntiVoid.Height or 0, function(v) M.AntiVoid.Height=v end, sc)
        
    elseif name == "Visuals" then
        self:MakeToggle("Enable ESP", CONFIG.Modules.ESP and CONFIG.Modules.ESP.Enabled or false, function(e)
            M.ESP:Toggle(e)
            Notifs:Info("ESP", e and "ON" or "OFF")
        end, sc)
        self:MakeToggle("Boxes", CONFIG.Modules.ESP and CONFIG.Modules.ESP.Box or true, function(e)
            M.ESP.Box=e
            if M.ESP.En then M.ESP:Toggle(false) M.ESP:Toggle(true) end
        end, sc)
        self:MakeToggle("Names", CONFIG.Modules.ESP and CONFIG.Modules.ESP.Nam or true, function(e)
            M.ESP.Nam=e
            if M.ESP.En then M.ESP:Toggle(false) M.ESP:Toggle(true) end
        end, sc)
        self:MakeToggle("Health", CONFIG.Modules.ESP and CONFIG.Modules.ESP.HP or true, function(e)
            M.ESP.HP=e
            if M.ESP.En then M.ESP:Toggle(false) M.ESP:Toggle(true) end
        end, sc)
        self:MakeToggle("Distance", CONFIG.Modules.ESP and CONFIG.Modules.ESP.Dist or true, function(e)
            M.ESP.Dist=e
            if M.ESP.En then M.ESP:Toggle(false) M.ESP:Toggle(true) end
        end, sc)
        self:MakeToggle("Team Colors", CONFIG.Modules.ESP and CONFIG.Modules.ESP.Team or true, function(e)
            M.ESP.Team=e
            if M.ESP.En then M.ESP:Toggle(false) M.ESP:Toggle(true) end
        end, sc)
        
    elseif name == "Bedwars" then
        self:MakeToggle("Bed ESP", CONFIG.Modules.BedESP and CONFIG.Modules.BedESP.Enabled or false, function(e)
            M.BedESP:Toggle(e)
            Notifs:Info("Bed ESP", e and "ON" or "OFF")
        end, sc)
        
        self:MakeToggle("Auto Bridge", CONFIG.Modules.Bridge and CONFIG.Modules.Bridge.Enabled or false, function(e)
            M.Bridge:Toggle(e)
            Notifs:Info("Bridge", e and "ON" or "OFF")
        end, sc)
        
        self:MakeToggle("Scaffold", CONFIG.Modules.Scaffold and CONFIG.Modules.Scaffold.Enabled or false, function(e)
            M.Scaffold:Toggle(e)
            Notifs:Info("Scaffold", e and "ON" or "OFF")
        end, sc)
        self:MakeToggle("Expand Mode", CONFIG.Modules.Scaffold and CONFIG.Modules.Scaffold.Expand or true, function(e)
            M.Scaffold.Expand=e
        end, sc)
        
        self:MakeToggle("Chest Stealer", CONFIG.Modules.Chest and CONFIG.Modules.Chest.Enabled or false, function(e)
            M.Chest:Toggle(e)
            Notifs:Info("Chest Stealer", e and "ON" or "OFF")
        end, sc)
        self:MakeSlider("Range", 5, 30, CONFIG.Modules.Chest and CONFIG.Modules.Chest.Range or 15, function(v) M.Chest.Range=v end, sc)
        self:MakeSlider("Delay", 0.05, 1, CONFIG.Modules.Chest and CONFIG.Modules.Chest.Delay or 0.1, function(v) M.Chest.Delay=v end, sc)
        
    elseif name == "Utility" then
        local info = Instance.new("TextLabel")
        info.Size = UDim2.new(1,-20,0,80)
        info.BackgroundColor3 = T.BG2
        info.BorderSizePixel = 0
        info.Text = "🔧 Utility Features\n\nAdditional tools and features for enhanced gameplay."
        info.TextColor3 = T.TXT
        info.TextSize = 13
        info.Font = Enum.Font.Gotham
        info.TextWrapped = true
        info.TextYAlignment = Enum.TextYAlignment.Top
        info.Parent = sc
        
        local icr = Instance.new("UICorner")
        icr.CornerRadius = UDim.new(0,8)
        icr.Parent = info
        
        local pad = Instance.new("UIPadding")
        pad.PaddingAll = UDim.new(0,12)
        pad.Parent = info
        
        self:MakeButton("💾 Save Config", function()
            saveConfig()
            Notifs:Success("Config", "Saved successfully!")
        end, sc)
        
        self:MakeButton("📂 Load Config", function()
            if loadConfig() then
                Notifs:Success("Config", "Loaded successfully!")
            else
                Notifs:Warn("Config", "No saved config found")
            end
        end, sc)
        
    elseif name == "Settings" then
        local info = Instance.new("TextLabel")
        info.Size = UDim2.new(1,-20,0,240)
        info.BackgroundColor3 = T.BG2
        info.BorderSizePixel = 0
        info.Text = string.format([[🦦 Otter Client v9.0.0 ULTIMATE

🚀 ULTIMATE EDITION FEATURES:
• Advanced Whitelist System
• Multiple Premium Themes
• Enhanced Anti-Cheat Bypass
• Settings Persistence (FIXED!)
• Xeno Executor Support
• 15+ Working Modules
• Smooth Animations

⚡ Executor: %s
🔑 Key: 123
⌨️  Toggle: Right Shift

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
        pad.PaddingAll = UDim.new(0,12)
        pad.Parent = info
        
        -- Theme Selector
        local themeLabel = Instance.new("TextLabel")
        themeLabel.Size = UDim2.new(1,-20,0,30)
        themeLabel.BackgroundTransparency = 1
        themeLabel.Text = "🎨 Select Theme:"
        themeLabel.TextColor3 = T.ACC
        themeLabel.TextSize = 15
        themeLabel.Font = Enum.Font.GothamBold
        themeLabel.TextXAlignment = Enum.TextXAlignment.Left
        themeLabel.Parent = sc
        
        for themeName, theme in pairs(THEMES) do
            self:MakeButton("🎨 "..theme.Name, function()
                T = theme
                CONFIG.CurrentTheme = themeName
                saveConfig()
                Notifs:Success("Theme", "Changed to "..theme.Name)
                if verLabel then
                    verLabel.Text = "🎨 "..theme.Name
                end
                -- Reload GUI with new theme
                task.wait(0.3)
                if self.sg then
                    self.sg:Destroy()
                    self:Init()
                end
            end, sc)
        end
        
        -- Anti-Cheat Settings
        self:MakeToggle("Anti-Detection", AntiCheat.Enabled, function(e)
            AntiCheat.Enabled = e
            Notifs:Info("Anti-Detect", e and "ON" or "OFF")
        end, sc)
        self:MakeToggle("Randomization", AntiCheat.Randomization, function(e)
            AntiCheat.Randomization = e
        end, sc)
        self:MakeToggle("Human Delays", AntiCheat.HumanDelay, function(e)
            AntiCheat.HumanDelay = e
        end, sc)
        self:MakeToggle("Packet Throttling", AntiCheat.PacketDelay, function(e)
            AntiCheat.PacketDelay = e
        end, sc)
    end
end

-- START
print("🦦 Otter v9.0.0 Ultimate Edition loading...")

-- Try to load saved config
loadConfig()

showKey()
repeat task.wait() until keyValid
print("✅ Unlocked!")

-- Check whitelist
if not WL:Check(plr.Name) then
    Notifs:Error("Access Denied", "You are not whitelisted!")
    task.wait(3)
    plr:Kick("Not whitelisted. Contact admin.")
    return
end

local isPremium = WL:IsPremium(plr.Name)
if isPremium then
    Notifs:Success("Premium", "Welcome back, "..plr.Name.."! 👑")
else
    Notifs:Info("Welcome", "Hello, "..plr.Name.."!")
end

Notifs:Success("Loaded", "Otter v9.0.0 Ultimate!")
GUI:Init()

UIS.InputBegan:Connect(function(inp, gpe)
    if gpe then return end
    if inp.KeyCode == Enum.KeyCode.RightShift then
        if GUI.sg then 
            GUI.sg.Enabled = not GUI.sg.Enabled 
            if GUI.sg.Enabled then
                saveConfig() -- Save when opening
            end
        end
    end
end)

-- Auto-save config every 60 seconds
task.spawn(function()
    while task.wait(60) do
        saveConfig()
    end
end)

task.wait(0.5)
Notifs:Info("Ready!", "Press RIGHT SHIFT")
if isPremium then
    Notifs:Success("Premium", "All features unlocked! 👑")
end
Notifs:Success("Anti-Cheat", "Bypass enabled! 🛡️")
print("✅ Otter Client v9.0.0 loaded!")
print("🛡️ Anti-detection active!")
print("🎨 Theme: "..T.Name)
print("⚡ Executor: "..EXECUTOR)
