-- 🦦 OTTER CLIENT - RIVALS & BEDWARS EDITION v6.0.0
-- 🎮 THE ULTIMATE UPDATE - RIVALS DOMINATION + BEDWARS MASTERY!
-- ⚔️ COMPLETE RIVALS MODULE + ENHANCED BEDWARS
-- Copy and paste this into your executor (Codex, Synapse, KRNL, etc.)
-- Key: 123

-- 🔥 MAIN LOADSTRING - READY TO USE!
local success, error = pcall(function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/hijsys/otter-_client/main/OtterClient_Standalone.lua"))()
end)

if not success then
    warn("❌ Failed to load Otter Client Ultimate: " .. tostring(error))
    print("🔧 Trying alternative loadstring...")
    
    -- Alternative loadstring
    local altSuccess, altError = pcall(function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/hijsys/otter-_client/main/OtterClient_Standalone.lua?raw=true"))()
    end)
    
    if not altSuccess then
        warn("❌ Alternative loadstring also failed: " .. tostring(altError))
        print("🔧 Trying local file...")
        
        -- Local file fallback
        local localSuccess, localError = pcall(function()
            if isfile and readfile then
                loadstring(readfile("OtterClient_Standalone.lua"))()
            else
                error("Local file functions not available")
            end
        end)
        
        if not localSuccess then
            warn("❌ Local file load failed: " .. tostring(localError))
            print("🚨 All loadstring methods failed!")
            print("📞 Please check your internet connection and try again.")
        else
            print("✅ Otter Client Ultimate loaded from local file!")
        end
    else
        print("✅ Otter Client Ultimate loaded with alternative method!")
    end
else
    print("✅ Otter Client Ultimate loaded successfully!")
end

-- 🚀 ALTERNATIVE LOADSTRINGS (Choose one if main fails):

-- Option 1: Direct GitHub (Recommended)
-- loadstring(game:HttpGet("https://raw.githubusercontent.com/hijsys/otter-_client/main/OtterClient_Standalone.lua"))()

-- Option 2: Raw GitHub (Alternative)
-- loadstring(game:HttpGet("https://raw.githubusercontent.com/hijsys/otter-_client/main/OtterClient_Standalone.lua?raw=true"))()

-- Option 3: GitHub with version tag
-- loadstring(game:HttpGet("https://raw.githubusercontent.com/hijsys/otter-_client/v5.0.2/OtterClient_Standalone.lua"))()

-- Option 4: Local file (for testing)
-- loadstring(readfile("OtterClient_Standalone.lua"))()

-- 🎯 SETUP INSTRUCTIONS:
-- 1. ✅ GitHub username: hijsys (DONE!)
-- 2. Create repository: otter-client-enhanced (on GitHub.com)
-- 3. Copy and paste into your executor
-- 4. Enter key: 123
-- 5. Enjoy the ULTIMATE experience!

-- 🔧 TROUBLESHOOTING:
-- - Make sure your executor supports HttpService
-- - Check your internet connection
-- - Verify the GitHub URL is correct
-- - Try the alternative loadstrings if one doesn't work
-- - Check if your executor has proper permissions

-- 🚀 ULTIMATE FEATURES v6.0.0 - RIVALS & BEDWARS EDITION:

-- 🎮 RIVALS MODULE (THE STAR OF THE SHOW!):
-- ⚔️ Advanced Aimbot with 3 Prediction Modes
-- 👁️ Full ESP System (Boxes, Tracers, Names, Health, Distance)
-- 🎯 Auto-Parry with Perfect Timing
-- 💫 Kill Aura with Smart Targeting
-- 🎯 Hitbox Expander + Visualization
-- 👻 Silent Aim & Aim Assist
-- 🏃 Movement (Speed, Fly, Infinite Jump, No Clip)
-- 🎨 Visuals (Fullbright, FOV Changer, Crosshair)
-- 📊 Stats Tracking (Kills, Deaths, K/D, Accuracy)
-- 🔥 Combat (Auto-Dodge, Anti-Ragdoll, Instant Respawn)

-- 🛏️ BEDWARS MODULE (COMPLETE DOMINANCE!):
-- 🛏️ Bed ESP with Team Colors
-- 🌉 Auto-Bridge System
-- 💎 Resource ESP (Diamonds, Emeralds, Iron, Gold)
-- ⚒️ Generator ESP with Timers
-- 🛡️ Auto-Defense System
-- 🎒 Smart Inventory Management
-- 🏃 Speed Bridging (Normal, Ninja, God modes)
-- 💰 Auto-Mining for Resources
-- 🚨 Smart Alert System

-- ✨ CORE FEATURES:
-- 🎨 Beautiful Ultimate GUI
-- 🛡️ Advanced Anti-Cheat Bypass
-- 🎯 20+ Combat Modules
-- 🚀 Performance Optimized
-- 💾 Smart Memory Management
-- 🔧 Comprehensive Error Handling
-- ✅ COMPLETELY STANDALONE

-- 🎮 SUPPORTED GAMES:
-- 🎮 RIVALS (Full support - GO ALL OUT!)
-- 🛏️ Bedwars (Enhanced support)
-- 🔫 Arsenal
-- 🚔 Jailbreak  
-- 🏰 Adopt Me
-- 🎯 And many more!

-- 🎯 COMBAT MODULES:
-- 🎯 Advanced Aimbot (Silent aim, prediction)
-- ⚔️ Ultimate Killaura (Smart targeting, auto block)
-- 🖱️ Auto Clicker (CPS control, humanization)
-- 🛡️ Auto Block (Smart blocking, timing)
-- 🚫 Anti Knockback (Advanced protection)

-- 🏃 MOVEMENT MODULES:
-- 🏃 Advanced Speed (Multiple types, anti-detection)
-- 🚁 Ultimate Fly (BodyVelocity, CFrame, Tween)
-- 🚀 Jetpack (Fuel system, thrust control)
-- 👻 NoClip (Smart noclip, collision detection)
-- 📍 Teleport (Player/Location teleport, safety)

-- 👁️ VISUAL MODULES:
-- 👁️ Ultimate ESP (3D boxes, tracers, skeletons)
-- 💡 Fullbright (Brightness control, smooth transitions)
-- 🔍 X-Ray (Wall transparency, object filtering)
-- 🎨 Chams (Player/Object chams, material control)
-- ✨ Glow Effects (Advanced glow system)

-- 🛠️ UTILITY MODULES:
-- 🔧 Auto Tools (Auto equip, tool priority)
-- 📦 Auto Collect (Item detection, range control)
-- 🌾 Auto Farm (Crop detection, auto plant/harvest)
-- 💰 Auto Sell (Price optimization, bulk selling)
-- 📋 Inventory Manager (Auto sort, space optimization)

-- 🎮 GAME-SPECIFIC FEATURES:
-- 🛏️ Bedwars: Bed detection, diamond/emerald generators, auto bridge
-- 🔫 Arsenal: Weapon detection, map awareness, killstreak tracking
-- 🚔 Jailbreak: Cop detection, criminal tracking, escape routes
-- 🏰 Adopt Me: Pet detection, house optimization, trading enhancement
-- 🎯 Tower Defense: Tower placement, enemy tracking, path optimization

-- 🛡️ ANTI-CHEAT BYPASSES:
-- 🧠 Memory Protection (Randomization, encryption, anti-scan)
-- ⚡ Execution Protection (Anti-debugger, randomization, injection)
-- 🌐 Network Protection (Traffic encryption, packet randomization)
-- 🤖 Behavior Protection (Humanized input, randomized timing)
-- 🔍 Detection Evasion (Process hiding, registry cleaning)

-- 🔧 BUG FIXES v5.0.2:
-- ✅ Fixed module loading errors (script.Parent issues)
-- ✅ Added comprehensive error handling
-- ✅ Fixed animation loading failures
-- ✅ Added fallback initialization system
-- ✅ Improved compatibility with all executors
-- ✅ Enhanced error messages and debugging
-- ✅ Added safe module loading system
-- ✅ COMPLETELY STANDALONE - NO EXTERNAL DEPENDENCIES

-- 📱 SUPPORTED EXECUTORS:
-- ✅ Codex
-- ✅ Synapse X
-- ✅ Script-Ware
-- ✅ KRNL
-- ✅ Fluxus
-- ✅ JJSploit
-- ✅ And more!

-- 🔒 SECURITY FEATURES:
-- 🛡️ Advanced Anti-Detection
-- 🔐 Encrypted Configs
-- 🚫 Safe Execution
-- 🔄 Memory Management
-- ⚡ Performance Optimized
-- 🎯 Game-Specific Bypasses
-- 🔒 Multi-Layer Protection

-- 📚 DOCUMENTATION:
-- 📖 Complete README
-- 🎯 Setup Instructions
-- 🔧 Module Documentation
-- 🤝 Contributing Guidelines
-- 📝 Changelog
-- 🎮 Game-Specific Guides

-- 🌟 ENJOY THE ULTIMATE ROBLOX EXPERIENCE! 🌟
-- 🚀 400% MORE FEATURES THAN BEFORE!
-- 🎯 PROFESSIONAL GRADE CHEAT CLIENT!
-- 🛡️ MAXIMUM PROTECTION & BYPASSES!
-- 🎨 BEAUTIFUL UI WITH ANIMATIONS!
-- 🎮 GAME-SPECIFIC OPTIMIZATIONS!
-- 🔧 COMPREHENSIVE BUG FIXES!
-- ✅ COMPLETELY STANDALONE!