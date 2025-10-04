# 🔐 Otter Client Authentication Guide

## Quick Start

When you run Otter Client for the first time, you'll see a beautiful authentication screen with two options:

### Option 1: Use a Key
Enter one of these keys:
- **`123`** - Free tier (all basic features)
- **`PREMIUM2024`** - Premium tier (advanced features)
- **`RIVALS_PRO`** - Rivals tier (full Rivals support)
- **`LIFETIME_VIP`** - VIP tier (everything + VIP perks)

### Option 2: Start Free Trial
Click the **"🆓 Start Free Trial"** button to get 1 hour of access with:
- Combat modules (Aimbot, Killaura)
- Movement modules (Speed, Fly)
- Visual modules (ESP)

---

## 📋 Tier Comparison

| Feature | Free | Premium | Rivals | VIP |
|---------|:----:|:-------:|:------:|:---:|
| **Combat Modules** | ✅ | ✅ | ✅ | ✅ |
| **Movement Modules** | ✅ | ✅ | ✅ | ✅ |
| **Visual Modules** | ✅ | ✅ | ✅ | ✅ |
| **Misc Modules** | ✅ | ✅ | ✅ | ✅ |
| **Rivals FPS Features** | ❌ | ✅ | ✅ | ✅ |
| **Premium Modules** | ❌ | ✅ | ✅ | ✅ |
| **VIP Perks** | ❌ | ❌ | ❌ | ✅ |
| **Priority Support** | ❌ | ✅ | ✅ | ✅ |
| **No Ads** | ❌ | ✅ | ✅ | ✅ |
| **Custom Configs** | ❌ | ✅ | ✅ | ✅ |

---

## 🔧 For Developers

### Bypassing Auth for Testing

In `OtterClient.lua`, set:
```lua
CONFIG.SKIP_AUTH_FOR_TESTING = true
```

This will:
- Skip the authentication GUI
- Give you admin-level access
- Allow testing all features

**⚠️ Remember to set it back to `false` before production!**

### Disabling Auth Completely

In `OtterClient.lua`, set:
```lua
CONFIG.REQUIRE_AUTH = false
```

This will allow the client to run without any authentication.

---

## 🔑 Admin Functions

### Adding a New Key
```lua
AuthSystem:AddKey("YOUR_KEY_HERE", "premium", nil, {"all", "premium"})
-- Parameters: key, tier, expiry (nil = never), features
```

### Removing a Key
```lua
AuthSystem:RemoveKey("YOUR_KEY_HERE")
```

### Whitelist a User
```lua
AuthSystem:AddToWhitelist(123456789, "vip", {"all", "vip"})
-- Parameters: Roblox UserID, tier, features
```

### Ban a User
```lua
AuthSystem:BanUser(987654321, "Exploiting/Abuse")
-- Parameters: Roblox UserID, reason
```

### Unban a User
```lua
AuthSystem:UnbanUser(987654321)
```

### View Statistics
```lua
local stats = AuthSystem:GetStats()
print("Total keys:", stats.totalKeys)
print("Current user:", stats.currentUser)
```

---

## ⚙️ Configuration

### In `Utils/AuthSystem.lua`:

```lua
AuthSystem.Config = {
    EnableKeySystem = true,        -- Enable key validation
    EnableHWIDCheck = false,       -- Enable hardware ID binding
    AllowMultipleDevices = true,   -- Allow same key on multiple devices
    MaxDevicesPerKey = 3,          -- Max devices per key
    
    EnableWhitelist = false,       -- Require user to be whitelisted
    EnableBlacklist = true,        -- Check blacklist before auth
    
    EnableTrial = true,            -- Allow free trials
    TrialDuration = 3600,          -- 1 hour in seconds
    
    SessionTimeout = 7200,         -- 2 hours in seconds
    AllowSessionResume = true,     -- Remember authenticated sessions
    
    EnableRemoteAuth = false,      -- Use remote server for auth
    AuthURL = "https://your-server.com/api/verify"
}
```

---

## 🛡️ Security Features

### HWID Protection
When enabled, each key is bound to a hardware ID:
```lua
EnableHWIDCheck = true
AllowMultipleDevices = true
MaxDevicesPerKey = 3
```

This prevents key sharing while allowing the same user to use multiple devices.

### Whitelist Mode
Force only whitelisted users to access:
```lua
EnableWhitelist = true
```

Add users to whitelist:
```lua
WhitelistedUsers = {
    [123456789] = {tier = "admin", features = {"all"}},
    [987654321] = {tier = "vip", features = {"all", "vip"}},
}
```

### Blacklist
Ban specific users:
```lua
BlacklistedUsers = {
    [111111111] = {reason = "Terms violation", date = "2025-10-04"},
}
```

---

## 🌐 Remote Authentication

### Setup Remote Auth Server

1. Set up your auth server endpoint
2. Configure the URL:
```lua
EnableRemoteAuth = true
AuthURL = "https://your-domain.com/api/verify"
```

3. Your server should accept POST requests with:
```json
{
  "key": "user_key",
  "userId": 123456789,
  "username": "PlayerName",
  "hwid": "ABC123...",
  "gameId": 123456789,
  "timestamp": 1234567890
}
```

4. Return response:
```json
{
  "success": true,
  "tier": "premium",
  "features": ["all", "premium"],
  "expiry": null
}
```

---

## 📊 Session Management

### How Sessions Work

1. User authenticates with key
2. Session is created with 2-hour expiry
3. Session data stored in `_G.OtterClientSession`
4. On next script run, session is checked
5. If valid, user auto-authenticates
6. If expired, auth required again

### Manual Session Control

```lua
-- Get current session
local session = AuthSystem:GetUserInfo()

-- Logout
AuthSystem:Logout()

-- Check if authenticated
if AuthSystem.Authenticated then
    print("User is authenticated!")
end

-- Check if user has specific feature
if AuthSystem:HasFeature("rivals") then
    print("User has Rivals access!")
end
```

---

## 🎨 Customizing the GUI

The auth GUI is in `Utils/AuthGUI.lua`. You can customize:

### Colors (Theme object):
```lua
local Theme = {
    Primary = Color3.fromRGB(30, 30, 40),
    Secondary = Color3.fromRGB(40, 40, 50),
    Accent = Color3.fromRGB(100, 150, 255),
    Success = Color3.fromRGB(50, 200, 100),
    Error = Color3.fromRGB(255, 80, 80),
    -- ... more colors
}
```

### GUI Size:
```lua
mainFrame.Size = UDim2.new(0, 450, 0, 550)
```

### Animation Speed:
```lua
TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
```

---

## 🐛 Troubleshooting

### "Authentication failed or cancelled"
- Make sure you entered a valid key
- Check if you're blacklisted
- Verify whitelist isn't enabled (unless you're whitelisted)

### "Trial already used"
- Each user can only use the trial once
- Use a valid key for continued access

### "Key has expired"
- The key you entered has expired
- Contact admin for a new key

### Auth GUI not showing
- Check if `CONFIG.REQUIRE_AUTH` is `true`
- Verify auth modules loaded correctly
- Check console for errors

### Client starts without auth
- `CONFIG.SKIP_AUTH_FOR_TESTING` might be `true`
- `CONFIG.REQUIRE_AUTH` might be `false`
- Check your configuration

---

## 💡 Tips

1. **For Testing**: Use `SKIP_AUTH_FOR_TESTING = true` during development
2. **For Production**: Always enable authentication with `REQUIRE_AUTH = true`
3. **For Monetization**: Use different tiers (Free, Premium, VIP) with different features
4. **For Security**: Enable HWID checking to prevent key sharing
5. **For Growth**: Enable free trial to let users try before buying

---

## 📞 Support

If you have issues with authentication:
1. Check this guide
2. Review your configuration
3. Check console for error messages
4. Verify your key is valid
5. Contact support if issues persist

---

**Made with ❤️ by the Otter Client Team**
