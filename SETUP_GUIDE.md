# 🦦 Otter Client v9.0.0 - Setup Guide

## ⚠️ Getting Started - 3 Easy Methods

---

## 📋 METHOD 1: Direct Copy & Paste (EASIEST!)

### Steps:
1. **Open** `OtterClient.lua` in a text editor (Notepad, VS Code, etc.)
2. **Select All** (Ctrl+A or Cmd+A)
3. **Copy** (Ctrl+C or Cmd+C)
4. **Open your executor** (Xeno, Solara, KRNL, etc.)
5. **Paste** the code into the executor script box
6. **Execute!**
7. Enter key: `123`
8. Press `Right Shift` to toggle GUI

✅ **This works immediately - No upload needed!**

---

## 🔗 METHOD 2: Using Pastebin (RECOMMENDED!)

### Steps:
1. Go to [pastebin.com](https://pastebin.com)
2. Open `OtterClient.lua` and copy all the code
3. Paste into Pastebin
4. Set these options:
   - Paste Name: `Otter Client v9.0.0`
   - Syntax Highlighting: `Lua`
   - Paste Expiration: `Never`
   - Paste Exposure: `Unlisted` or `Public`
5. Click **"Create New Paste"**
6. Click the **"raw"** button at the top
7. Copy that URL (should look like: `https://pastebin.com/raw/AbCdEfGh`)

### In Executor:
```lua
loadstring(game:HttpGet("https://pastebin.com/raw/YOUR_PASTE_ID"))()
```

Replace `YOUR_PASTE_ID` with your actual Pastebin raw URL!

✅ **This gives you a short, easy-to-share link!**

---

## 📦 METHOD 3: GitHub Upload (FOR SHARING!)

### Steps:

#### A. Create GitHub Repository:
1. Go to [github.com](https://github.com)
2. Click **"New repository"**
3. Name it: `otter-client` (or anything you want)
4. Make it **Public**
5. Click **"Create repository"**

#### B. Upload Files:
1. Click **"uploading an existing file"**
2. Upload `OtterClient.lua`
3. Commit the file
4. **Optional:** Upload all other files too:
   - README.md
   - CHANGELOG.md
   - UPDATE_NOTES_v9.md
   - WHATS_NEW.md
   - LICENSE
   - etc.

#### C. Get Raw Link:
1. Click on `OtterClient.lua` in your repo
2. Click the **"Raw"** button
3. Copy that URL (looks like: `https://raw.githubusercontent.com/USERNAME/otter-client/main/OtterClient.lua`)

#### D. Use in Executor:
```lua
loadstring(game:HttpGet("https://raw.githubusercontent.com/USERNAME/otter-client/main/OtterClient.lua"))()
```

Replace `USERNAME` with your GitHub username!

✅ **This is the most professional option!**

---

## 🎯 Quick Reference

### All Files in v9.0.0:

| File | Purpose |
|------|---------|
| **OtterClient.lua** | Main script (THIS IS WHAT YOU EXECUTE) |
| README.md | Full documentation |
| CHANGELOG.md | Version history |
| UPDATE_NOTES_v9.md | v9 update details |
| WHATS_NEW.md | Feature showcase |
| V9_RELEASE_SUMMARY.txt | Quick reference |
| SETUP_GUIDE.md | This file! |
| Loadstring.lua | Helper script |
| package.json | Version info |

**You only NEED OtterClient.lua to run the script!**

---

## ⚙️ Executor-Specific Notes

### Xeno:
- ✅ Full support (NEW in v9!)
- Works perfectly with all features
- Use any method above

### Solara:
- ✅ Full support
- Recommended: Pastebin method
- All features work

### KRNL:
- ✅ Full support
- Use any method
- Stable and tested

### Synapse X:
- ✅ Full support
- Premium executor
- All methods work

### Wave:
- ✅ Supported
- Use Pastebin or direct paste
- Most features work

### Mobile Executors:
- ⚠️ Limited support
- Try direct paste method
- Some features may not work

---

## 🔑 Default Key

**Key:** `123`

This is hardcoded in the script. You can change it by editing line 663 in OtterClient.lua:

```lua
if box.Text == "123" then  -- Change "123" to your key
```

---

## 🎨 First Time Setup

Once the script loads:

1. **Enter Key:** `123`
2. **GUI Opens** - Press `Right Shift` to toggle
3. **Choose Theme:**
   - Go to Settings tab
   - Click any theme button
   - GUI reloads with new theme
4. **Configure Modules:**
   - Enable what you want
   - Adjust sliders
5. **Save Config:**
   - Go to Utility tab
   - Click "💾 Save Config"
6. **Done!** - Your settings will persist!

---

## 💡 Troubleshooting

### "HTTP Error Code: 404"
**Problem:** The URL doesn't exist

**Solutions:**
- Use Method 1 (Direct Copy & Paste)
- Upload to Pastebin (Method 2)
- Check your GitHub URL is correct

### "loadstring is not available"
**Problem:** Executor doesn't support loadstring

**Solution:**
- Use direct copy & paste method
- Try a different executor

### "Key is wrong"
**Problem:** Entered wrong key

**Solution:**
- The key is `123` (three numbers)
- Check for typos

### "Not whitelisted"
**Problem:** Your username isn't in the whitelist

**Solution:**
- Edit the whitelist in OtterClient.lua
- Find line 147-151 and add your username
- Or disable whitelist (line 144: `Enabled = false`)

### GUI doesn't show
**Problem:** CoreGui protection or parenting issue

**Solution:**
- Press `Right Shift` to toggle
- Check if your executor supports CoreGui
- Script falls back to PlayerGui automatically

### Settings don't save
**Problem:** Executor doesn't support file system

**Solutions:**
- Some executors don't have `writefile`/`readfile`
- Settings will reset on rejoin
- Use manual save in Utility tab when possible

---

## 🔧 Customization

### Change Whitelist:
Edit lines 144-150 in OtterClient.lua:

```lua
local WL = {
    Enabled = true,  -- Set to false to disable
    Users = {
        ["YourUsername"] = {premium = true, expires = nil},
        ["Friend1"] = {premium = false, expires = os.time() + 86400}
    },
    AdminKey = "YOUR_ADMIN_KEY"
}
```

### Change Key:
Edit line 663:

```lua
if box.Text == "123" then  -- Change to your key
```

### Change Default Theme:
Edit line 113:

```lua
local T = THEMES.Discord  -- Change to: Midnight, Sunset, Forest, Purple, Ocean
```

---

## 📞 Support

### Need Help?

1. **Read this guide** - Most questions answered here
2. **Check README.md** - Full documentation
3. **Read WHATS_NEW.md** - Feature explanations
4. **Check executor compatibility** - Some executors have limitations

### Report Bugs:

If you uploaded to GitHub:
- Go to your repo
- Click "Issues"
- Create new issue with details

---

## ✅ Checklist

Before running Otter Client:

- [ ] Have a working executor (Xeno, Solara, KRNL, etc.)
- [ ] Have OtterClient.lua file
- [ ] Chose a loading method (Direct, Pastebin, or GitHub)
- [ ] Know the key: `123`
- [ ] Know the toggle: `Right Shift`
- [ ] In Roblox Bedwars game

---

## 🎮 Quick Start Commands

### If using Pastebin:
```lua
loadstring(game:HttpGet("https://pastebin.com/raw/YOUR_ID"))()
```

### If using GitHub:
```lua
loadstring(game:HttpGet("https://raw.githubusercontent.com/USERNAME/REPO/main/OtterClient.lua"))()
```

### If using Local File:
Just copy-paste the entire OtterClient.lua and execute!

---

## 🎉 You're Ready!

Once loaded:
- Toggle GUI: `Right Shift`
- Key: `123`
- Enjoy 15 modules, 6 themes, and advanced anti-cheat bypass!

**Have fun dominating Bedwars! 🛏️⚔️**

---

<div align="center">

**🦦 Otter Client v9.0.0 - ULTIMATE EDITION**

*Made with 💙 for the Roblox Bedwars community*

[Back to README](README.md) | [See Changelog](CHANGELOG.md) | [What's New](WHATS_NEW.md)

</div>
