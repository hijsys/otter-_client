# 🦦 Otter Client - Bedwars Edition 🛏️

**The Ultimate Roblox Bedwars Client - Completely Rewritten & Debugged!**

Version 5.0.0 - Now 100% Bedwars Optimized!

---

## 🎯 What's New in v5.0.0?

### ✅ **COMPLETELY DEBUGGED!**
- ❌ **Removed** all broken `require()` calls
- ✅ **Fixed** all GUI parenting issues
- ✅ **Fixed** module system - everything is self-contained
- ✅ **Fixed** notification system
- ✅ **Added** proper error handling everywhere
- ✅ **No more bugs!** Everything actually works now!

### 🛏️ **Bedwars-Specific Design**
- **Team Colors**: Red, Blue, Green, Yellow team theming
- **Bed ESP**: Find and track enemy beds
- **Team-Aware ESP**: Shows player team colors
- **Bedwars UI**: Clean, modern interface designed for Bedwars
- **No More Minecraft References**: Pure Roblox Bedwars!

### ⚔️ **Working Combat Modules**
- **Killaura**: Auto-attack nearby enemies
  - Adjustable range (5-30 studs)
  - Customizable attack speed
  - Smart target detection
  - Team filtering
- **All modules actually work now!**

### 🏃 **Movement Modules**
- **Speed**: Adjustable speed multiplier (1x-5x)
  - Smooth transitions
  - Proper cleanup
- **Fly**: Full directional control
  - WASD for horizontal movement
  - Space/Shift for vertical
  - Adjustable speed (1-5)

### 👁️ **Visual Modules**
- **Player ESP**:
  - Highlight boxes with team colors
  - Player names
  - Health bars with color coding
  - Distance display
  - Toggle each feature individually
- **Bed ESP**: Locate enemy beds instantly

### 🎨 **Beautiful UI**
- **Discord-Inspired Theme**: Modern purple accent colors
- **Bedwars Team Colors**: Red, Blue, Green, Yellow
- **Smooth Animations**: Polished transitions
- **Draggable Window**: Move it anywhere
- **Tab System**: Organized categories

---

## 🚀 How to Use

### **Installation**
```lua
-- Copy the loadstring from Loadstring.lua
-- Paste into your executor
-- Enter key: 123
```

### **Controls**
- **Menu Toggle**: `Right Shift`
- **Fly Controls** (when enabled):
  - `W/A/S/D` - Horizontal movement
  - `Space` - Fly up
  - `Left Shift` - Fly down

### **Key System**
- **Key**: `123`
- Simple and fast!

---

## 📋 Features

### **Combat Tab** ⚔️
| Feature | Description | Settings |
|---------|-------------|----------|
| Killaura | Auto-attack nearby enemies | Range: 5-30<br>Speed: 0.05-1.0 |

### **Movement Tab** 🏃
| Feature | Description | Settings |
|---------|-------------|----------|
| Speed | Increase walk speed | Multiplier: 1x-5x |
| Fly | Fly around the map | Speed: 1-5 |

### **Visuals Tab** 👁️
| Feature | Description | Options |
|---------|-------------|---------|
| Player ESP | See players through walls | Boxes, Names, Health, Distance, Team Colors |

### **Bedwars Tab** 🛏️
| Feature | Description | Status |
|---------|-------------|--------|
| Bed ESP | Locate enemy beds | ✅ Working |
| Auto Bridge | Auto-build bridges | 🔜 Coming Soon |
| Chest Stealer | Auto-loot chests | 🔜 Coming Soon |
| Forge Alerts | Resource notifications | 🔜 Coming Soon |

### **Settings Tab** ⚙️
- View version info
- Check keybinds
- About information

---

## 🔧 Technical Improvements

### **What Was Fixed:**

1. **Module System**
   - ❌ Old: Broken `require()` calls to non-existent modules
   - ✅ New: All modules are self-contained and work independently

2. **GUI System**
   - ❌ Old: Parenting issues causing elements to break
   - ✅ New: Proper parent hierarchy with safe fallbacks

3. **Error Handling**
   - ❌ Old: Scripts crashed on any error
   - ✅ New: `safe()` wrapper catches and logs all errors

4. **Notifications**
   - ❌ Old: Broken notification system
   - ✅ New: Working notification system with animations

5. **Theme**
   - ❌ Old: Generic/Minecraft-like colors
   - ✅ New: Bedwars-specific team colors and Discord-inspired accent

6. **Code Quality**
   - ❌ Old: 900+ lines of spaghetti code
   - ✅ New: Clean, modular, well-commented code

---

## 🎨 UI Preview

```
┌─────────────────────────────────────────────────┐
│  🦦 Otter Client - Bedwars 5.0.0 BEDWARS      × │
├─────────────────────────────────────────────────┤
│ ┌──────────┐ ┌─────────────────────────────┐   │
│ │ ⚔️ Combat│ │  ⚔️ Killaura                 │   │
│ │ 🏃 Movement │  ┌─────┐                      │   │
│ │ 👁️ Visuals│ │  │ ON  │ Enable Killaura    │   │
│ │ 🛏️ Bedwars│ │  └─────┘                     │   │
│ │ ⚙️ Settings│ │  Range: ▬▬▬▬●▬▬▬▬ 20      │   │
│ └──────────┘ │  Attack Speed: ●▬▬▬▬ 0.1   │   │
│              └─────────────────────────────┘   │
└─────────────────────────────────────────────────┘
```

---

## 🛡️ Safety Features

- **Safe Execution**: All functions wrapped in `pcall()`
- **Smart Cleanup**: Modules properly disconnect when disabled
- **Team Checking**: Won't attack teammates
- **Performance Optimized**: Efficient update loops
- **Anti-Detection**: Randomized behaviors (coming soon)

---

## 🔮 Planned Features (v6.0.0)

- 🔨 **Auto Bridge** - Automatically build bridges
- 💎 **Resource Tracker** - Track diamonds/emeralds/iron
- 📦 **Chest Stealer** - Auto-loot nearby chests
- 🔔 **Forge Alerts** - Notifications when forge items are ready
- 🛒 **Shop Auto-Buy** - Quick-buy presets
- 📊 **Stats Tracker** - Track your performance
- 🎯 **Target Priority** - Smart target selection
- 🛡️ **Auto Armor** - Automatically equip best armor

---

## ❓ FAQ

**Q: The key doesn't work!**
A: Make sure you're typing exactly `123` (no spaces)

**Q: Modules aren't working!**
A: Make sure you're in a Bedwars game. Some modules require the game to be loaded.

**Q: Can I get banned?**
A: Use at your own risk. We recommend using an alt account.

**Q: How do I update?**
A: Just run the loadstring again to get the latest version!

**Q: Why did you rewrite everything?**
A: The old version had tons of bugs including:
- Broken require() calls
- GUI parenting issues  
- Non-functional modules
- Minecraft theming instead of Bedwars

**Q: Is this really bug-free?**
A: Yes! Every module has been tested and works properly now.

---

## 🤝 Contributing

Found a bug? Want a feature? Open an issue!

### **How to Report Bugs:**
1. Describe what you were doing
2. What happened vs what should happen
3. Include any error messages
4. Mention your executor

---

## 📄 License

MIT License - See LICENSE file

---

## ⚠️ Disclaimer

This is for **educational purposes only**. Use responsibly and at your own risk. 

We are not responsible for:
- Bans or account actions
- Lost progress
- Any consequences from using this script

---

## 📞 Support

- **Issues**: Use GitHub Issues
- **Updates**: Check CHANGELOG.md
- **Setup Help**: See GITHUB_SETUP.md

---

## 🎉 Credits

**Otter Client Team**
- Original concept & design
- Complete v5.0.0 rewrite
- Bedwars optimization
- Bug fixes and improvements

**Special Thanks:**
- The Roblox community
- Bedwars developers
- All users and testers

---

## 📊 Changelog

### v5.0.0 - The Great Rewrite (Current)
- ✅ Completely rewrote entire codebase
- ✅ Removed all broken require() calls
- ✅ Fixed all GUI bugs
- ✅ Made Bedwars-specific
- ✅ Added proper error handling
- ✅ Improved performance
- ✅ New notification system
- ✅ Better UI design

### v4.0.0 - Enhanced Version
- Added advanced modules (broken)
- Theme system (broken)
- Config manager (broken)

### v3.0.1 - Fixed Version  
- Basic error handling
- Some bug fixes

---

**Made with ❤️ for the Roblox Bedwars community**

🦦 **Otter Client - Bedwars Edition v5.0.0** 🛏️

*Now Actually Working!*
