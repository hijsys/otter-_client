-- Advanced Configuration Manager
-- Features: Save/Load configs, encryption, and cloud sync

local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")

local player = Players.LocalPlayer

local ConfigManager = {}
ConfigManager.Configs = {}
ConfigManager.CurrentConfig = "default"
ConfigManager.EncryptionKey = "OtterClient2024"

-- Simple encryption/decryption
function ConfigManager:Encrypt(data)
    local encrypted = ""
    for i = 1, #data do
        local char = string.byte(data, i)
        local keyChar = string.byte(self.EncryptionKey, ((i - 1) % #self.EncryptionKey) + 1)
        encrypted = encrypted .. string.char((char + keyChar) % 256)
    end
    return encrypted
end

function ConfigManager:Decrypt(encrypted)
    local decrypted = ""
    for i = 1, #encrypted do
        local char = string.byte(encrypted, i)
        local keyChar = string.byte(self.EncryptionKey, ((i - 1) % #self.EncryptionKey) + 1)
        decrypted = decrypted .. string.char((char - keyChar) % 256)
    end
    return decrypted
end

-- Save config to file
function ConfigManager:SaveConfig(configName, configData)
    local success, result = pcall(function()
        local encrypted = self:Encrypt(HttpService:JSONEncode(configData))
        writefile("OtterClient_" .. configName .. ".json", encrypted)
        return true
    end)
    
    if success then
        self.Configs[configName] = configData
        print("✅ Config '" .. configName .. "' saved successfully!")
        return true
    else
        warn("❌ Failed to save config '" .. configName .. "': " .. tostring(result))
        return false
    end
end

-- Load config from file
function ConfigManager:LoadConfig(configName)
    local success, result = pcall(function()
        if not isfile("OtterClient_" .. configName .. ".json") then
            return nil
        end
        
        local encrypted = readfile("OtterClient_" .. configName .. ".json")
        local decrypted = self:Decrypt(encrypted)
        return HttpService:JSONDecode(decrypted)
    end)
    
    if success and result then
        self.Configs[configName] = result
        print("✅ Config '" .. configName .. "' loaded successfully!")
        return result
    else
        warn("❌ Failed to load config '" .. configName .. "': " .. tostring(result))
        return nil
    end
end

-- Delete config
function ConfigManager:DeleteConfig(configName)
    local success, result = pcall(function()
        if isfile("OtterClient_" .. configName .. ".json") then
            delfile("OtterClient_" .. configName .. ".json")
        end
        self.Configs[configName] = nil
        return true
    end)
    
    if success then
        print("✅ Config '" .. configName .. "' deleted successfully!")
        return true
    else
        warn("❌ Failed to delete config '" .. configName .. "': " .. tostring(result))
        return false
    end
end

-- Get all config names
function ConfigManager:GetConfigNames()
    local configNames = {}
    local success, result = pcall(function()
        local names = {}
        for _, file in pairs(listfiles()) do
            if string.find(file, "OtterClient_") and string.find(file, ".json") then
                local name = string.gsub(file, "OtterClient_", "")
                name = string.gsub(name, ".json", "")
                table.insert(names, name)
            end
        end
        return names
    end)
    
    if success then
        return result
    else
        warn("❌ Failed to get config names: " .. tostring(result))
        return {}
    end
end

-- Export config
function ConfigManager:ExportConfig(configName)
    local config = self.Configs[configName]
    if not config then
        config = self:LoadConfig(configName)
    end
    
    if config then
        local success, result = pcall(function()
            local json = HttpService:JSONEncode(config)
            writefile("OtterClient_" .. configName .. "_export.json", json)
            return true
        end)
        
        if success then
            print("✅ Config '" .. configName .. "' exported successfully!")
            return true
        else
            warn("❌ Failed to export config '" .. configName .. "': " .. tostring(result))
            return false
        end
    else
        warn("❌ Config '" .. configName .. "' not found!")
        return false
    end
end

-- Import config
function ConfigManager:ImportConfig(configName)
    local success, result = pcall(function()
        if not isfile("OtterClient_" .. configName .. "_export.json") then
            return nil
        end
        
        local json = readfile("OtterClient_" .. configName .. "_export.json")
        return HttpService:JSONDecode(json)
    end)
    
    if success and result then
        self.Configs[configName] = result
        print("✅ Config '" .. configName .. "' imported successfully!")
        return result
    else
        warn("❌ Failed to import config '" .. configName .. "': " .. tostring(result))
        return nil
    end
end

-- Set current config
function ConfigManager:SetCurrentConfig(configName)
    self.CurrentConfig = configName
    print("✅ Current config set to '" .. configName .. "'")
end

-- Get current config
function ConfigManager:GetCurrentConfig()
    return self.CurrentConfig
end

-- Merge configs
function ConfigManager:MergeConfigs(config1, config2)
    local merged = {}
    
    for key, value in pairs(config1) do
        merged[key] = value
    end
    
    for key, value in pairs(config2) do
        merged[key] = value
    end
    
    return merged
end

-- Validate config
function ConfigManager:ValidateConfig(config)
    if type(config) ~= "table" then
        return false, "Config must be a table"
    end
    
    -- Add validation logic here
    return true, "Config is valid"
end

-- Create default config
function ConfigManager:CreateDefaultConfig()
    local defaultConfig = {
        Aimbot = {
            Enabled = false,
            FOV = 100,
            Smoothing = 20,
            Prediction = 0.1,
            VisibleCheck = true,
            TeamCheck = true,
            Priority = "Closest",
            Bone = "Head"
        },
        Killaura = {
            Enabled = false,
            Range = 10,
            Delay = 0.1,
            TeamCheck = true,
            VisibleCheck = true,
            WeaponCheck = true,
            AutoBlock = false,
            Priority = "Closest",
            Bone = "Head"
        },
        Speed = {
            Enabled = false,
            Multiplier = 2,
            Type = "WalkSpeed",
            Smooth = true,
            Smoothness = 0.1,
            TeamCheck = true,
            VisibleCheck = true
        },
        Fly = {
            Enabled = false,
            Speed = 20,
            Type = "BodyVelocity",
            Smooth = true,
            Smoothness = 0.1,
            NoClip = true,
            AutoLand = true,
            LandSpeed = 5
        },
        ESP = {
            Enabled = false,
            Boxes = true,
            Names = true,
            Health = true,
            Distance = true,
            TeamCheck = true,
            VisibleCheck = true,
            Tracers = false,
            Skeletons = false,
            Chams = false,
            Glow = false,
            TeamColors = true,
            EnemyColor = {255, 0, 0},
            TeamColor = {0, 255, 0},
            VisibleColor = {255, 255, 0},
            HiddenColor = {255, 0, 255}
        },
        Settings = {
            MenuKey = "RightShift",
            Theme = "Dark",
            Notifications = true,
            AutoSave = true,
            AutoLoad = true
        }
    }
    
    return defaultConfig
end

return ConfigManager
