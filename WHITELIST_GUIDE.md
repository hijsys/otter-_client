# 🔐 Otter Client v9.0.0 - Whitelist Guide for Owner

## 👑 How to Whitelist Yourself as Owner

### Step 1: Find Your Roblox Username

Your **exact** Roblox username (case-sensitive!)

Example: If your Roblox username is `CoolPlayer123`, use exactly that.

---

### Step 2: Edit OtterClient.lua

Open `OtterClient.lua` and find **line 200** (around line 195-203):

**BEFORE:**
```lua
local WL = {
    Enabled = true,
    Users = {
        ["Owner"] = {premium = true, expires = nil},  -- Replace "Owner" with YOUR Roblox username
    },
    AdminKey = "OTTER_ADMIN_2024"
}
```

**AFTER (Replace "Owner" with YOUR Roblox username):**
```lua
local WL = {
    Enabled = true,
    Users = {
        ["YourRobloxUsername"] = {premium = true, expires = nil},  -- Your actual username
    },
    AdminKey = "OTTER_ADMIN_2024"
}
```

---

### Step 3: Example - If your Roblox username is "hijsys"

```lua
local WL = {
    Enabled = true,
    Users = {
        ["hijsys"] = {premium = true, expires = nil},  -- Owner with premium
    },
    AdminKey = "OTTER_ADMIN_2024"
}
```

---

## 👥 How to Add More Users

### Add Premium Users (Full access, no expiration):

```lua
local WL = {
    Enabled = true,
    Users = {
        ["hijsys"] = {premium = true, expires = nil},  -- Owner
        ["Friend1"] = {premium = true, expires = nil},  -- Premium friend
        ["Friend2"] = {premium = true, expires = nil},  -- Premium friend
    },
    AdminKey = "OTTER_ADMIN_2024"
}
```

### Add Free Users (Limited access, with expiration):

```lua
local WL = {
    Enabled = true,
    Users = {
        ["hijsys"] = {premium = true, expires = nil},  -- Owner
        ["TestUser"] = {premium = false, expires = os.time() + 86400},  -- 1 day access
        ["TestUser2"] = {premium = false, expires = os.time() + 604800},  -- 7 days access
    },
    AdminKey = "OTTER_ADMIN_2024"
}
```

**Time calculations:**
- 1 day = `86400` seconds
- 7 days = `604800` seconds
- 30 days = `2592000` seconds
- No expiration = `nil`

---

## 🔧 Advanced Whitelist Options

### Option 1: Disable Whitelist (Allow Everyone)

Change `Enabled = true` to `Enabled = false`:

```lua
local WL = {
    Enabled = false,  -- Everyone can use it now!
    Users = {
        ["hijsys"] = {premium = true, expires = nil},
    },
    AdminKey = "OTTER_ADMIN_2024"
}
```

### Option 2: Premium vs Free Differences

**Premium users get:**
- 👑 Special welcome message
- ✅ All features unlocked
- ⭐ Premium badge in notifications
- ♾️ Never expires

**Free users get:**
- ✅ All features (same as premium)
- ⏰ Access expires after set time
- 📝 Standard welcome message

*(You can customize this in the code if you want different features for each tier)*

---

## 📝 Complete Example Setup

Here's a full example with multiple users:

```lua
local WL = {
    Enabled = true,
    Users = {
        -- OWNER (You)
        ["hijsys"] = {premium = true, expires = nil},
        
        -- PREMIUM FRIENDS
        ["BestFriend"] = {premium = true, expires = nil},
        ["TrustedPlayer"] = {premium = true, expires = nil},
        
        -- FREE TRIAL USERS (7 days)
        ["NewUser1"] = {premium = false, expires = os.time() + 604800},
        ["NewUser2"] = {premium = false, expires = os.time() + 604800},
        
        -- VIP ACCESS (30 days)
        ["VIPPlayer"] = {premium = false, expires = os.time() + 2592000},
    },
    AdminKey = "OTTER_ADMIN_2024"
}
```

---

## 🎯 Quick Reference

### Add Yourself (Owner):
**Line 200** - Replace `"Owner"` with your Roblox username

### Add Premium Friend:
```lua
["FriendName"] = {premium = true, expires = nil},
```

### Add Trial User (7 days):
```lua
["Username"] = {premium = false, expires = os.time() + 604800},
```

### Disable Whitelist:
**Line 196** - Change to `Enabled = false,`

---

## ⚠️ Important Notes

### Case Sensitivity
- Roblox usernames are **case-sensitive**!
- `"Player"` ≠ `"player"` ≠ `"PLAYER"`
- Use the **exact** username as it appears in Roblox

### Testing
1. Add your username to the whitelist
2. Save the file
3. Execute the script
4. You should see: "Welcome back, [YourName]! 👑" (if premium)

### Common Mistakes
❌ Wrong: `["owner"]` - lowercase when Roblox username is "Owner"
❌ Wrong: Forgetting the comma after each entry
❌ Wrong: Using display name instead of username

✅ Correct: `["Owner"] = {premium = true, expires = nil},`

---

## 🔐 Admin Key (Optional)

The admin key is currently set to: `"OTTER_ADMIN_2024"`

You can change it on **line 202**:

```lua
AdminKey = "YOUR_SECRET_KEY_HERE"
```

*(This can be used for future admin commands if you add them)*

---

## 🎮 In-Game Behavior

### When Whitelisted:
1. Enter key: `123`
2. See: "✅ Unlocked!"
3. Premium users see: "👑 Welcome back, [Name]! Premium user!"
4. Free users see: "Welcome, [Name]!"
5. GUI opens normally

### When NOT Whitelisted:
1. Enter key: `123`
2. See: "❌ Access Denied - Not whitelisted"
3. Kicked from game after 3 seconds
4. Message: "Not whitelisted. Contact admin."

---

## 💡 Pro Tips

### Keep a Master List
Create a text file with all whitelisted users and their expiration dates.

### Regular Updates
Remove expired free users periodically to keep the list clean.

### Backup
Keep a backup of your whitelist before making changes.

### Security
Don't share your edited OtterClient.lua file - it contains your whitelist!

---

## 📋 Checklist

Before uploading to GitHub:

- [ ] Added your Roblox username to the whitelist
- [ ] Set yourself as premium (`premium = true`)
- [ ] Set no expiration (`expires = nil`)
- [ ] Tested the script with your username
- [ ] Added any friends you want to whitelist
- [ ] Saved the file
- [ ] Ready to upload!

---

## 🚀 Next Steps

1. **Edit whitelist** - Add your username (line 200)
2. **Save file** - Save OtterClient.lua
3. **Upload to GitHub** - Upload to your `hijsys/otter-client` repo
4. **Test it** - Use the loadstring in your executor
5. **Share** - Give friends the loadstring!

**Your loadstring:**
```lua
loadstring(game:HttpGet("https://raw.githubusercontent.com/hijsys/otter-client/main/OtterClient.lua"))()
```

---

<div align="center">

**🔐 Otter Client v9.0.0 - Whitelist System**

*Secure, Flexible, Easy to Manage*

Made with 💙 by the Otter Client Team

[Back to README](README.md) | [Setup Guide](SETUP_GUIDE.md)

</div>
