-- 🔐 AUTHENTICATION SYSTEM
-- Advanced authentication with key system, HWID verification, and whitelist
-- Version: 5.1.0 - Rivals Edition

local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local MarketplaceService = game:GetService("MarketplaceService")

local AuthSystem = {}
AuthSystem.Authenticated = false
AuthSystem.Username = nil
AuthSystem.HWID = nil
AuthSystem.UserData = {}

-- 🔑 CONFIGURATION
AuthSystem.Config = {
    -- Key System
    EnableKeySystem = true,
    ValidKeys = {
        ["123"] = {tier = "free", expiry = nil, features = {"all"}},
        ["PREMIUM2024"] = {tier = "premium", expiry = nil, features = {"all", "premium"}},
        ["RIVALS_PRO"] = {tier = "rivals", expiry = nil, features = {"all", "rivals", "premium"}},
        ["LIFETIME_VIP"] = {tier = "lifetime", expiry = nil, features = {"all", "rivals", "premium", "vip"}}
    },
    
    -- HWID System
    EnableHWIDCheck = false,
    AllowMultipleDevices = true,
    MaxDevicesPerKey = 3,
    
    -- Whitelist System
    EnableWhitelist = false,
    WhitelistedUsers = {
        -- Add Roblox UserIDs here
        -- [123456789] = {tier = "admin", features = {"all"}},
    },
    
    -- Blacklist System
    EnableBlacklist = true,
    BlacklistedUsers = {
        -- Add banned Roblox UserIDs here
        -- [987654321] = {reason = "Abuse", date = "2025-10-04"},
    },
    
    -- Remote Authentication (Optional)
    EnableRemoteAuth = false,
    AuthURL = "https://your-auth-server.com/api/verify",
    
    -- Trial System
    EnableTrial = true,
    TrialDuration = 3600, -- 1 hour in seconds
    TrialFeatures = {"combat", "movement", "visual"},
    
    -- Session Management
    SessionTimeout = 7200, -- 2 hours in seconds
    AllowSessionResume = true,
}

-- 🔐 HWID GENERATION
function AuthSystem:GenerateHWID()
    local player = Players.LocalPlayer
    
    -- Generate unique HWID based on multiple factors
    local components = {
        tostring(player.UserId),
        player.Name,
        tostring(game.JobId),
        tostring(game.PlaceId),
        -- Add more entropy
        tostring(tick()),
        tostring(math.random(1000000, 9999999))
    }
    
    local combined = table.concat(components, "-")
    
    -- Simple hash function (in production, use better hashing)
    local hash = 0
    for i = 1, #combined do
        hash = (hash * 31 + string.byte(combined, i)) % 2147483647
    end
    
    local hwid = string.format("%X", hash)
    self.HWID = hwid
    
    return hwid
end

-- 🔍 KEY VALIDATION
function AuthSystem:ValidateKey(key)
    if not key or key == "" then
        return false, "Key cannot be empty"
    end
    
    -- Check if key exists in valid keys
    local keyData = self.Config.ValidKeys[key]
    if not keyData then
        return false, "Invalid key"
    end
    
    -- Check expiry
    if keyData.expiry and os.time() > keyData.expiry then
        return false, "Key has expired"
    end
    
    -- Check HWID if enabled
    if self.Config.EnableHWIDCheck then
        local hwid = self:GenerateHWID()
        if keyData.hwid and keyData.hwid ~= hwid then
            if not self.Config.AllowMultipleDevices then
                return false, "Key is bound to another device"
            end
        end
    end
    
    return true, "Key validated", keyData
end

-- 👤 USER VALIDATION
function AuthSystem:ValidateUser()
    local player = Players.LocalPlayer
    local userId = player.UserId
    
    -- Check blacklist first
    if self.Config.EnableBlacklist and self.Config.BlacklistedUsers[userId] then
        local banData = self.Config.BlacklistedUsers[userId]
        return false, "You have been banned. Reason: " .. (banData.reason or "Unknown")
    end
    
    -- Check whitelist if enabled
    if self.Config.EnableWhitelist then
        if self.Config.WhitelistedUsers[userId] then
            local userData = self.Config.WhitelistedUsers[userId]
            return true, "Whitelisted user", userData
        else
            return false, "You are not whitelisted"
        end
    end
    
    return true, "User validated"
end

-- 🌐 REMOTE AUTHENTICATION
function AuthSystem:RemoteAuth(key)
    if not self.Config.EnableRemoteAuth then
        return false, "Remote auth disabled"
    end
    
    local success, result = pcall(function()
        local player = Players.LocalPlayer
        local hwid = self:GenerateHWID()
        
        local data = {
            key = key,
            userId = player.UserId,
            username = player.Name,
            hwid = hwid,
            gameId = game.PlaceId,
            timestamp = os.time()
        }
        
        -- In production, use HttpService:RequestAsync
        -- This is a placeholder
        warn("Remote auth not implemented - would send to: " .. self.Config.AuthURL)
        
        return {
            success = true,
            tier = "free",
            features = {"all"}
        }
    end)
    
    if success and result then
        return true, "Remote auth successful", result
    else
        return false, "Remote auth failed: " .. tostring(result)
    end
end

-- ⏱️ TRIAL SYSTEM
function AuthSystem:StartTrial()
    if not self.Config.EnableTrial then
        return false, "Trial system disabled"
    end
    
    local player = Players.LocalPlayer
    local userId = player.UserId
    
    -- Check if trial already used
    local trialKey = "OtterClient_Trial_" .. userId
    
    -- In production, save this to datastore
    if _G[trialKey] then
        return false, "Trial already used"
    end
    
    _G[trialKey] = {
        startTime = os.time(),
        duration = self.Config.TrialDuration,
        features = self.Config.TrialFeatures
    }
    
    self.UserData = {
        tier = "trial",
        features = self.Config.TrialFeatures,
        expiry = os.time() + self.Config.TrialDuration
    }
    
    return true, "Trial started - " .. math.floor(self.Config.TrialDuration / 60) .. " minutes remaining"
end

-- 🎫 SESSION MANAGEMENT
function AuthSystem:CreateSession(keyData)
    local player = Players.LocalPlayer
    
    local session = {
        userId = player.UserId,
        username = player.Name,
        hwid = self.HWID,
        tier = keyData.tier,
        features = keyData.features,
        startTime = os.time(),
        expiryTime = os.time() + self.Config.SessionTimeout,
        active = true
    }
    
    self.UserData = session
    _G.OtterClientSession = session
    
    return session
end

function AuthSystem:ValidateSession()
    if not self.Config.AllowSessionResume then
        return false
    end
    
    local session = _G.OtterClientSession
    if not session then
        return false
    end
    
    -- Check if session expired
    if os.time() > session.expiryTime then
        return false
    end
    
    -- Check if still active
    if not session.active then
        return false
    end
    
    return true
end

-- 🔓 MAIN AUTHENTICATION FUNCTION
function AuthSystem:Authenticate(key)
    print("🔐 Starting authentication...")
    
    -- Step 1: Validate user
    local userValid, userMsg, userData = self:ValidateUser()
    if not userValid then
        warn("❌ User validation failed: " .. userMsg)
        return false, userMsg
    end
    
    -- Step 2: Check for existing valid session
    if self:ValidateSession() then
        print("✅ Resuming existing session")
        self.Authenticated = true
        self.UserData = _G.OtterClientSession
        return true, "Session resumed"
    end
    
    -- Step 3: Validate key
    local keyValid, keyMsg, keyData = self:ValidateKey(key)
    if not keyValid then
        warn("❌ Key validation failed: " .. keyMsg)
        return false, keyMsg
    end
    
    -- Step 4: Remote auth (if enabled)
    if self.Config.EnableRemoteAuth then
        local remoteValid, remoteMsg, remoteData = self:RemoteAuth(key)
        if not remoteValid then
            warn("❌ Remote auth failed: " .. remoteMsg)
            return false, remoteMsg
        end
        keyData = remoteData
    end
    
    -- Step 5: Generate HWID
    self:GenerateHWID()
    
    -- Step 6: Create session
    self:CreateSession(keyData)
    
    -- Step 7: Set authenticated
    self.Authenticated = true
    self.Username = Players.LocalPlayer.Name
    
    print("✅ Authentication successful!")
    print("👤 User: " .. self.Username)
    print("🎫 Tier: " .. keyData.tier)
    print("🔑 HWID: " .. self.HWID)
    
    return true, "Authentication successful", keyData
end

-- 🆓 FREE ACCESS (NO KEY)
function AuthSystem:FreeAccess()
    print("🆓 Starting free access mode...")
    
    -- Validate user first
    local userValid, userMsg = self:ValidateUser()
    if not userValid then
        return false, userMsg
    end
    
    -- Generate HWID
    self:GenerateHWID()
    
    -- Create limited session
    local freeData = {
        tier = "free",
        features = {"combat", "movement", "visual"}
    }
    
    self:CreateSession(freeData)
    self.Authenticated = true
    self.Username = Players.LocalPlayer.Name
    
    print("✅ Free access granted with limited features")
    return true, "Free access granted"
end

-- 🔓 LOGOUT
function AuthSystem:Logout()
    self.Authenticated = false
    self.UserData = {}
    if _G.OtterClientSession then
        _G.OtterClientSession.active = false
    end
    print("👋 Logged out successfully")
end

-- ✅ FEATURE CHECK
function AuthSystem:HasFeature(feature)
    if not self.Authenticated then
        return false
    end
    
    if not self.UserData.features then
        return false
    end
    
    -- Check if user has "all" features
    for _, f in ipairs(self.UserData.features) do
        if f == "all" then
            return true
        end
        if f == feature then
            return true
        end
    end
    
    return false
end

-- 📊 GET USER INFO
function AuthSystem:GetUserInfo()
    return {
        authenticated = self.Authenticated,
        username = self.Username,
        hwid = self.HWID,
        tier = self.UserData.tier or "none",
        features = self.UserData.features or {},
        expiry = self.UserData.expiryTime
    }
end

-- 🎁 REDEEM KEY
function AuthSystem:RedeemKey(key)
    if self.Authenticated then
        return false, "Already authenticated"
    end
    
    return self:Authenticate(key)
end

-- 🔧 ADMIN FUNCTIONS
function AuthSystem:AddKey(key, tier, expiry, features)
    self.Config.ValidKeys[key] = {
        tier = tier or "free",
        expiry = expiry,
        features = features or {"all"}
    }
    print("✅ Key added: " .. key .. " (Tier: " .. tier .. ")")
    return true
end

function AuthSystem:RemoveKey(key)
    if self.Config.ValidKeys[key] then
        self.Config.ValidKeys[key] = nil
        print("✅ Key removed: " .. key)
        return true
    end
    return false, "Key not found"
end

function AuthSystem:AddToWhitelist(userId, tier, features)
    self.Config.WhitelistedUsers[userId] = {
        tier = tier or "premium",
        features = features or {"all"}
    }
    print("✅ User " .. userId .. " added to whitelist")
    return true
end

function AuthSystem:RemoveFromWhitelist(userId)
    if self.Config.WhitelistedUsers[userId] then
        self.Config.WhitelistedUsers[userId] = nil
        print("✅ User " .. userId .. " removed from whitelist")
        return true
    end
    return false, "User not in whitelist"
end

function AuthSystem:BanUser(userId, reason)
    self.Config.BlacklistedUsers[userId] = {
        reason = reason or "Banned by admin",
        date = os.date("%Y-%m-%d")
    }
    print("✅ User " .. userId .. " banned")
    return true
end

function AuthSystem:UnbanUser(userId)
    if self.Config.BlacklistedUsers[userId] then
        self.Config.BlacklistedUsers[userId] = nil
        print("✅ User " .. userId .. " unbanned")
        return true
    end
    return false, "User not banned"
end

-- 📈 STATISTICS
function AuthSystem:GetStats()
    return {
        totalKeys = #self.Config.ValidKeys,
        whitelistedUsers = #self.Config.WhitelistedUsers,
        bannedUsers = #self.Config.BlacklistedUsers,
        authenticated = self.Authenticated,
        currentUser = self.Username
    }
end

-- 🚀 INITIALIZE
function AuthSystem:Initialize()
    print("🔐 Initializing Authentication System...")
    print("⚙️ Key System: " .. (self.Config.EnableKeySystem and "Enabled" or "Disabled"))
    print("🔒 HWID Check: " .. (self.Config.EnableHWIDCheck and "Enabled" or "Disabled"))
    print("📋 Whitelist: " .. (self.Config.EnableWhitelist and "Enabled" or "Disabled"))
    print("🚫 Blacklist: " .. (self.Config.EnableBlacklist and "Enabled" or "Disabled"))
    print("🆓 Trial: " .. (self.Config.EnableTrial and "Enabled" or "Disabled"))
    print("✅ Authentication System initialized!")
    return true
end

return AuthSystem
