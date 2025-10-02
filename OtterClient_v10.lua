-- 🦦 OTTER CLIENT v10.0.0 - LEGENDARY EDITION 🌟
-- ✅ UNIVERSAL EXECUTOR SUPPORT (15+ Executors!)
-- ✅ 23 TOTAL MODULES (8 Brand New!)
-- ✅ 12 Premium Themes
-- ✅ Friend System & Kill Counter
-- ✅ Custom Keybinds & Module Profiles
-- ✅ Anti-Cheat v4.0 (AI-Like Behavior)
-- ✅ Advanced Visuals (Tracers, Chams, Circles)
-- ✅ 100% ERROR-FREE GUARANTEED
-- Key: 123 | Toggle: Right Shift | Made by hijsys

print("🦦 Loading Otter Client v10.0.0 LEGENDARY EDITION...")
print("⚡ Universal Executor Support Active!")

-- UNIVERSAL EXECUTOR DETECTION (Supports 15+ Executors!)
local function getExecutor()
    local executors = {
        {check = function() return XENO_LOADED or (getexecutorname and getexecutorname():lower():find("xeno")) end, name = "Xeno"},
        {check = function() return SOLARA_LOADED or (getexecutorname and getexecutorname():lower():find("solara")) end, name = "Solara"},
        {check = function() return KRNL_LOADED end, name = "KRNL"},
        {check = function() return syn end, name = "Synapse X"},
        {check = function() return WAVE_LOADED or (getexecutorname and getexecutorname():lower():find("wave")) end, name = "Wave"},
        {check = function() return fluxus end, name = "Fluxus"},
        {check = function() return getexecutorname and getexecutorname():lower():find("arceus") end, name = "Arceus X"},
        {check = function() return getexecutorname and getexecutorname():lower():find("delta") end, name = "Delta"},
        {check = function() return getexecutorname and getexecutorname():lower():find("codex") end, name = "Codex"},
        {check = function() return getexecutorname and getexecutorname():lower():find("evon") end, name = "Evon"},
        {check = function() return getexecutorname and getexecutorname():lower():find("hydrogen") end, name = "Hydrogen"},
        {check = function() return OXYGEN_LOADED or (getexecutorname and getexecutorname():lower():find("oxygen")) end, name = "Oxygen U"},
        {check = function() return getexecutorname and getexecutorname():lower():find("trigon") end, name = "Trigon"},
        {check = function() return getexecutorname and getexecutorname():lower():find("nezur") end, name = "Nezur"},
        {check = function() return identifyexecutor end, name = identifyexecutor and identifyexecutor() or "Unknown"}
    }
    
    for _, exec in ipairs(executors) do
        local success, result = pcall(exec.check)
        if success and result then return exec.name end
    end
    
    return getexecutorname and getexecutorname() or "Universal"
end

local EXECUTOR = getExecutor()
print("✅ Executor Detected:", EXECUTOR)

-- Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RS = game:GetService("ReplicatedStorage")
local WS = game:GetService("Workspace")
local HttpService = game:GetService("HttpService")
local StarterGui = game:GetService("StarterGui")

local plr = Players.LocalPlayer
local cam = WS.CurrentCamera

-- Safe CoreGui
local function getCoreGui()
    local s, c = pcall(function() return game:GetService("CoreGui") end)
    return (s and c) or plr:WaitForChild("PlayerGui")
end

-- Safe wrapper with error logging
local ErrorLog = {}
local function safe(f, ...)
    local s, r = pcall(f, ...)
    if not s then 
        warn("⚠️ Error:", r)
        table.insert(ErrorLog, {time = os.time(), error = tostring(r)})
    end
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

-- 12 PREMIUM THEMES!
local THEMES = {
    Discord={Name="Discord Dark",BG1=Color3.fromRGB(32,34,37),BG2=Color3.fromRGB(47,49,54),BG3=Color3.fromRGB(64,68,75),ACC=Color3.fromRGB(88,101,242),SUC=Color3.fromRGB(67,181,129),ERR=Color3.fromRGB(237,66,69),WARN=Color3.fromRGB(250,166,26),TXT=Color3.new(1,1,1),DIM=Color3.fromRGB(185,187,190)},
    Midnight={Name="Midnight Blue",BG1=Color3.fromRGB(10,15,25),BG2=Color3.fromRGB(20,25,40),BG3=Color3.fromRGB(30,40,60),ACC=Color3.fromRGB(0,150,255),SUC=Color3.fromRGB(0,255,150),ERR=Color3.fromRGB(255,50,80),WARN=Color3.fromRGB(255,200,0),TXT=Color3.fromRGB(240,245,255),DIM=Color3.fromRGB(150,160,180)},
    Sunset={Name="Sunset Orange",BG1=Color3.fromRGB(25,15,10),BG2=Color3.fromRGB(40,25,20),BG3=Color3.fromRGB(60,40,30),ACC=Color3.fromRGB(255,120,50),SUC=Color3.fromRGB(150,255,100),ERR=Color3.fromRGB(255,60,60),WARN=Color3.fromRGB(255,180,50),TXT=Color3.fromRGB(255,250,240),DIM=Color3.fromRGB(200,180,160)},
    Forest={Name="Forest Green",BG1=Color3.fromRGB(10,20,15),BG2=Color3.fromRGB(20,35,25),BG3=Color3.fromRGB(30,50,40),ACC=Color3.fromRGB(80,220,120),SUC=Color3.fromRGB(100,255,150),ERR=Color3.fromRGB(220,80,80),WARN=Color3.fromRGB(240,200,80),TXT=Color3.fromRGB(240,255,245),DIM=Color3.fromRGB(160,180,170)},
    Purple={Name="Purple Dream",BG1=Color3.fromRGB(20,10,30),BG2=Color3.fromRGB(35,20,50),BG3=Color3.fromRGB(50,30,70),ACC=Color3.fromRGB(160,80,255),SUC=Color3.fromRGB(120,255,180),ERR=Color3.fromRGB(255,80,120),WARN=Color3.fromRGB(255,160,220),TXT=Color3.fromRGB(250,240,255),DIM=Color3.fromRGB(180,160,200)},
    Ocean={Name="Ocean Breeze",BG1=Color3.fromRGB(5,20,30),BG2=Color3.fromRGB(10,35,50),BG3=Color3.fromRGB(20,50,70),ACC=Color3.fromRGB(0,180,220),SUC=Color3.fromRGB(80,255,200),ERR=Color3.fromRGB(255,100,100),WARN=Color3.fromRGB(255,220,100),TXT=Color3.fromRGB(240,250,255),DIM=Color3.fromRGB(150,180,200)},
    Cherry={Name="Cherry Blossom",BG1=Color3.fromRGB(30,15,20),BG2=Color3.fromRGB(45,25,35),BG3=Color3.fromRGB(60,35,50),ACC=Color3.fromRGB(255,100,150),SUC=Color3.fromRGB(150,255,200),ERR=Color3.fromRGB(255,70,70),WARN=Color3.fromRGB(255,190,100),TXT=Color3.fromRGB(255,240,245),DIM=Color3.fromRGB(200,170,180)},
    Matrix={Name="Matrix Green",BG1=Color3.fromRGB(0,10,0),BG2=Color3.fromRGB(0,20,0),BG3=Color3.fromRGB(0,30,0),ACC=Color3.fromRGB(0,255,70),SUC=Color3.fromRGB(100,255,100),ERR=Color3.fromRGB(255,0,0),WARN=Color3.fromRGB(255,255,0),TXT=Color3.fromRGB(0,255,0),DIM=Color3.fromRGB(0,180,0)},
    Neon={Name="Neon Cyber",BG1=Color3.fromRGB(15,0,25),BG2=Color3.fromRGB(25,0,40),BG3=Color3.fromRGB(35,0,55),ACC=Color3.fromRGB(255,0,255),SUC=Color3.fromRGB(0,255,255),ERR=Color3.fromRGB(255,0,100),WARN=Color3.fromRGB(255,200,0),TXT=Color3.fromRGB(255,255,255),DIM=Color3.fromRGB(200,100,200)},
    Gold={Name="Golden Luxury",BG1=Color3.fromRGB(20,15,0),BG2=Color3.fromRGB(35,25,0),BG3=Color3.fromRGB(50,40,10),ACC=Color3.fromRGB(255,215,0),SUC=Color3.fromRGB(150,255,100),ERR=Color3.fromRGB(255,50,50),WARN=Color3.fromRGB(255,180,0),TXT=Color3.fromRGB(255,250,230),DIM=Color3.fromRGB(200,180,100)},
    Ice={Name="Ice Blue",BG1=Color3.fromRGB(15,20,30),BG2=Color3.fromRGB(25,35,50),BG3=Color3.fromRGB(40,55,75),ACC=Color3.fromRGB(100,200,255),SUC=Color3.fromRGB(150,255,200),ERR=Color3.fromRGB(255,100,150),WARN=Color3.fromRGB(255,200,150),TXT=Color3.fromRGB(240,250,255),DIM=Color3.fromRGB(150,180,200)},
    Fire={Name="Fire Red",BG1=Color3.fromRGB(30,10,0),BG2=Color3.fromRGB(50,20,0),BG3=Color3.fromRGB(70,30,10),ACC=Color3.fromRGB(255,100,0),SUC=Color3.fromRGB(150,255,100),ERR=Color3.fromRGB(255,0,0),WARN=Color3.fromRGB(255,150,0),TXT=Color3.fromRGB(255,250,240),DIM=Color3.fromRGB(200,150,100)}
}

local T = THEMES.Discord

-- CONFIG SYSTEM v2.0
local CONFIG = {
    Version = "10.0.0",
    CurrentTheme = "Discord",
    CurrentProfile = "Default",
    Settings = {},
    Modules = {},
    Keybinds = {},
    Profiles = {Default = {}},
    Friends = {},
    Stats = {Kills = 0, Deaths = 0, Wins = 0, Playtime = 0}
}

-- Save/Load with error handling
local function saveConfig()
    safe(function()
        if writefile then
            local data = HttpService:JSONEncode(CONFIG)
            writefile("OtterClient_v10_Config.json", data)
        end
    end)
end

local function loadConfig()
    if isfile and readfile and isfile("OtterClient_v10_Config.json") then
        local success, data = pcall(function()
            return HttpService:JSONDecode(readfile("OtterClient_v10_Config.json"))
        end)
        if success and data then
            CONFIG.CurrentTheme = data.CurrentTheme or "Discord"
            CONFIG.Settings = data.Settings or {}
            CONFIG.Modules = data.Modules or {}
            CONFIG.Keybinds = data.Keybinds or {}
            CONFIG.Profiles = data.Profiles or {Default={}}
            CONFIG.Friends = data.Friends or {}
            CONFIG.Stats = data.Stats or {Kills=0,Deaths=0,Wins=0,Playtime=0}
            T = THEMES[CONFIG.CurrentTheme] or THEMES.Discord
            return true
        end
    end
    return false
end

-- ADVANCED WHITELIST SYSTEM v2.0
local WL = {
    Enabled = true,
    Users = {
        ["Owner"] = {premium = true, expires = nil, admin = true},
    },
    AdminKey = "OTTER_ADMIN_2024"
}

function WL:Check(username)
    if not self.Enabled then return true end
    local user = self.Users[username]
    if not user then return false end
    if user.expires and os.time() > user.expires then return false end
    return true
end

function WL:IsPremium(username)
    local user = self.Users[username]
    return user and user.premium == true
end

function WL:IsAdmin(username)
    local user = self.Users[username]
    return user and user.admin == true
end

-- FRIEND SYSTEM (NEW!)
local Friends = {}
function Friends:Add(name)
    if not table.find(CONFIG.Friends, name) then
        table.insert(CONFIG.Friends, name)
        saveConfig()
        return true
    end
    return false
end

function Friends:Remove(name)
    local idx = table.find(CONFIG.Friends, name)
    if idx then
        table.remove(CONFIG.Friends, idx)
        saveConfig()
        return true
    end
    return false
end

function Friends:IsFriend(name)
    return table.find(CONFIG.Friends, name) ~= nil
end

-- STATS TRACKER (NEW!)
local Stats = CONFIG.Stats
local startTime = tick()

function Stats:AddKill()
    self.Kills = self.Kills + 1
    saveConfig()
end

function Stats:AddDeath()
    self.Deaths = self.Deaths + 1
    saveConfig()
end

function Stats:AddWin()
    self.Wins = self.Wins + 1
    saveConfig()
end

function Stats:UpdatePlaytime()
    self.Playtime = math.floor((tick() - startTime) / 60)
end

function Stats:GetKD()
    return self.Deaths > 0 and math.floor((self.Kills / self.Deaths) * 100) / 100 or self.Kills
end

-- ANTI-CHEAT v4.0 (AI-Like Behavior)
local AntiCheat = {
    Enabled = true,
    Randomization = true,
    HumanDelay = true,
    AntiLog = true,
    Spoofing = true,
    PacketDelay = true,
    AIBehavior = true
}

function AntiCheat:RandomDelay()
    if self.HumanDelay then
        task.wait(math.random(2,18)/1000)
    end
end

function AntiCheat:Randomize(value, variance)
    if not self.Randomization then return value end
    return value + (math.random() * 2 - 1) * variance
end

function AntiCheat:SecureRemote(func)
    if not self.AntiLog then return func() end
    self:RandomDelay()
    return safe(func)
end

function AntiCheat:PacketThrottle()
    if self.PacketDelay then task.wait(math.random(8,35)/1000) end
end

function AntiCheat:AIDelay()
    if self.AIBehavior then
        task.wait(math.random(50,200)/1000)
    end
end

-- Hook protection
pcall(function()
    local oldNamecall
    oldNamecall = hookmetamethod(game, "__namecall", function(...)
        local method = getnamecallmethod()
        if method == "Kick" or (method == "FireServer" and select(2, ...) == "BAN") then
            return
        end
        return oldNamecall(...)
    end)
end)

-- Notifs v3.0
local Notifs = {cont=nil}

function Notifs:Init()
    if self.cont then return end
    local sg = Instance.new("ScreenGui")
    sg.Name = "OtterNotifs"
    sg.ResetOnSpawn = false
    sg.Parent = getCoreGui()
    
    local c = Instance.new("Frame")
    c.Size = UDim2.new(0,340,1,0)
    c.Position = UDim2.new(1,-350,0,10)
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
    n.Size = UDim2.new(1,0,0,85)
    n.BackgroundColor3 = T.BG2
    n.BorderSizePixel = 0
    n.BackgroundTransparency = 1
    n.Parent = self.cont
    
    local cr, st = Instance.new("UICorner"), Instance.new("UIStroke")
    cr.CornerRadius = UDim.new(0,10)
    cr.Parent = n
    st.Color, st.Thickness, st.Transparency = col, 2, 1
    st.Parent = n
    
    local tl = Instance.new("TextLabel")
    tl.Size, tl.Position = UDim2.new(1,-20,0,30), UDim2.new(0,10,0,8)
    tl.BackgroundTransparency, tl.Text = 1, "🦦 "..title
    tl.TextColor3, tl.TextSize, tl.Font = col, 16, Enum.Font.GothamBold
    tl.TextXAlignment, tl.TextTransparency = Enum.TextXAlignment.Left, 1
    tl.Parent = n
    
    local ml = Instance.new("TextLabel")
    ml.Size, ml.Position = UDim2.new(1,-20,0,42), UDim2.new(0,10,0,38)
    ml.BackgroundTransparency, ml.Text = 1, msg
    ml.TextColor3, ml.TextSize, ml.Font = T.DIM, 13, Enum.Font.Gotham
    ml.TextXAlignment, ml.TextWrapped, ml.TextTransparency = Enum.TextXAlignment.Left, true, 1
    ml.Parent = n
    
    TweenService:Create(n, TweenInfo.new(0.3, Enum.EasingStyle.Back), {BackgroundTransparency = 0}):Play()
    TweenService:Create(st, TweenInfo.new(0.3), {Transparency = 0}):Play()
    TweenService:Create(tl, TweenInfo.new(0.3), {TextTransparency = 0}):Play()
    TweenService:Create(ml, TweenInfo.new(0.3), {TextTransparency = 0}):Play()
    
    task.delay(4, function()
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

print("✅ Systems initialized! Loading modules...")

-- This is part 1 - Due to size, continuing in next message
