-- Advanced Theme Manager
-- Features: Multiple themes, custom colors, and dynamic switching

local TweenService = game:GetService("TweenService")

local ThemeManager = {}
ThemeManager.CurrentTheme = "Dark"
ThemeManager.Themes = {}

-- Define built-in themes
ThemeManager.Themes.Dark = {
    Name = "Dark",
    Primary = Color3.fromRGB(12, 12, 12),
    Secondary = Color3.fromRGB(20, 20, 20),
    Accent = Color3.fromRGB(0, 255, 255),
    Success = Color3.fromRGB(0, 255, 0),
    Error = Color3.fromRGB(255, 50, 50),
    Warning = Color3.fromRGB(255, 165, 0),
    Text = Color3.fromRGB(255, 255, 255),
    Border = Color3.fromRGB(40, 40, 40),
    Background = Color3.fromRGB(8, 8, 8),
    Surface = Color3.fromRGB(16, 16, 16)
}

ThemeManager.Themes.Light = {
    Name = "Light",
    Primary = Color3.fromRGB(255, 255, 255),
    Secondary = Color3.fromRGB(240, 240, 240),
    Accent = Color3.fromRGB(0, 150, 255),
    Success = Color3.fromRGB(0, 200, 0),
    Error = Color3.fromRGB(255, 0, 0),
    Warning = Color3.fromRGB(255, 140, 0),
    Text = Color3.fromRGB(0, 0, 0),
    Border = Color3.fromRGB(200, 200, 200),
    Background = Color3.fromRGB(250, 250, 250),
    Surface = Color3.fromRGB(245, 245, 245)
}

ThemeManager.Themes.Neon = {
    Name = "Neon",
    Primary = Color3.fromRGB(0, 0, 0),
    Secondary = Color3.fromRGB(20, 0, 20),
    Accent = Color3.fromRGB(255, 0, 255),
    Success = Color3.fromRGB(0, 255, 0),
    Error = Color3.fromRGB(255, 0, 0),
    Warning = Color3.fromRGB(255, 255, 0),
    Text = Color3.fromRGB(255, 255, 255),
    Border = Color3.fromRGB(255, 0, 255),
    Background = Color3.fromRGB(0, 0, 0),
    Surface = Color3.fromRGB(10, 0, 10)
}

ThemeManager.Themes.Ocean = {
    Name = "Ocean",
    Primary = Color3.fromRGB(0, 50, 100),
    Secondary = Color3.fromRGB(0, 80, 120),
    Accent = Color3.fromRGB(0, 200, 255),
    Success = Color3.fromRGB(0, 255, 150),
    Error = Color3.fromRGB(255, 100, 100),
    Warning = Color3.fromRGB(255, 200, 0),
    Text = Color3.fromRGB(255, 255, 255),
    Border = Color3.fromRGB(0, 150, 200),
    Background = Color3.fromRGB(0, 30, 60),
    Surface = Color3.fromRGB(0, 40, 80)
}

ThemeManager.Themes.Fire = {
    Name = "Fire",
    Primary = Color3.fromRGB(50, 0, 0),
    Secondary = Color3.fromRGB(80, 0, 0),
    Accent = Color3.fromRGB(255, 100, 0),
    Success = Color3.fromRGB(0, 255, 0),
    Error = Color3.fromRGB(255, 0, 0),
    Warning = Color3.fromRGB(255, 150, 0),
    Text = Color3.fromRGB(255, 255, 255),
    Border = Color3.fromRGB(255, 100, 0),
    Background = Color3.fromRGB(30, 0, 0),
    Surface = Color3.fromRGB(40, 0, 0)
}

-- Get current theme
function ThemeManager:GetCurrentTheme()
    return self.Themes[self.CurrentTheme]
end

-- Set theme
function ThemeManager:SetTheme(themeName)
    if self.Themes[themeName] then
        self.CurrentTheme = themeName
        print("✅ Theme changed to: " .. themeName)
        return true
    else
        warn("❌ Theme '" .. themeName .. "' not found!")
        return false
    end
end

-- Get theme color
function ThemeManager:GetColor(colorName)
    local theme = self:GetCurrentTheme()
    return theme[colorName] or Color3.fromRGB(255, 255, 255)
end

-- Create custom theme
function ThemeManager:CreateCustomTheme(name, colors)
    if type(colors) ~= "table" then
        warn("❌ Colors must be a table!")
        return false
    end
    
    local theme = {
        Name = name,
        Primary = colors.Primary or Color3.fromRGB(12, 12, 12),
        Secondary = colors.Secondary or Color3.fromRGB(20, 20, 20),
        Accent = colors.Accent or Color3.fromRGB(0, 255, 255),
        Success = colors.Success or Color3.fromRGB(0, 255, 0),
        Error = colors.Error or Color3.fromRGB(255, 50, 50),
        Warning = colors.Warning or Color3.fromRGB(255, 165, 0),
        Text = colors.Text or Color3.fromRGB(255, 255, 255),
        Border = colors.Border or Color3.fromRGB(40, 40, 40),
        Background = colors.Background or Color3.fromRGB(8, 8, 8),
        Surface = colors.Surface or Color3.fromRGB(16, 16, 16)
    }
    
    self.Themes[name] = theme
    print("✅ Custom theme '" .. name .. "' created!")
    return true
end

-- Delete custom theme
function ThemeManager:DeleteCustomTheme(name)
    if self.Themes[name] and name ~= "Dark" and name ~= "Light" then
        self.Themes[name] = nil
        print("✅ Custom theme '" .. name .. "' deleted!")
        return true
    else
        warn("❌ Cannot delete built-in theme or theme not found!")
        return false
    end
end

-- Get all theme names
function ThemeManager:GetThemeNames()
    local names = {}
    for name, _ in pairs(self.Themes) do
        table.insert(names, name)
    end
    return names
end

-- Apply theme to GUI object
function ThemeManager:ApplyThemeToObject(object, themeType)
    local theme = self:GetCurrentTheme()
    
    if themeType == "Primary" then
        object.BackgroundColor3 = theme.Primary
    elseif themeType == "Secondary" then
        object.BackgroundColor3 = theme.Secondary
    elseif themeType == "Accent" then
        object.BackgroundColor3 = theme.Accent
    elseif themeType == "Text" then
        object.TextColor3 = theme.Text
    elseif themeType == "Border" then
        if object:FindFirstChild("UIStroke") then
            object.UIStroke.Color = theme.Border
        end
    end
end

-- Animate theme change
function ThemeManager:AnimateThemeChange(object, themeType, duration)
    duration = duration or 0.5
    local theme = self:GetCurrentTheme()
    
    local tweenInfo = TweenInfo.new(duration, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    
    if themeType == "Primary" then
        local tween = TweenService:Create(object, tweenInfo, {BackgroundColor3 = theme.Primary})
        tween:Play()
    elseif themeType == "Secondary" then
        local tween = TweenService:Create(object, tweenInfo, {BackgroundColor3 = theme.Secondary})
        tween:Play()
    elseif themeType == "Accent" then
        local tween = TweenService:Create(object, tweenInfo, {BackgroundColor3 = theme.Accent})
        tween:Play()
    elseif themeType == "Text" then
        local tween = TweenService:Create(object, tweenInfo, {TextColor3 = theme.Text})
        tween:Play()
    elseif themeType == "Border" then
        if object:FindFirstChild("UIStroke") then
            local tween = TweenService:Create(object.UIStroke, tweenInfo, {Color = theme.Border})
            tween:Play()
        end
    end
end

-- Get theme preview
function ThemeManager:GetThemePreview(themeName)
    local theme = self.Themes[themeName]
    if not theme then return nil end
    
    return {
        Primary = theme.Primary,
        Secondary = theme.Secondary,
        Accent = theme.Accent,
        Success = theme.Success,
        Error = theme.Error,
        Warning = theme.Warning,
        Text = theme.Text,
        Border = theme.Border
    }
end

-- Export theme
function ThemeManager:ExportTheme(themeName)
    local theme = self.Themes[themeName]
    if not theme then return nil end
    
    local export = {}
    for key, value in pairs(theme) do
        if key ~= "Name" then
            export[key] = {value.R, value.G, value.B}
        end
    end
    
    return export
end

-- Import theme
function ThemeManager:ImportTheme(name, themeData)
    local colors = {}
    for key, value in pairs(themeData) do
        if type(value) == "table" and #value == 3 then
            colors[key] = Color3.fromRGB(value[1] * 255, value[2] * 255, value[3] * 255)
        end
    end
    
    return self:CreateCustomTheme(name, colors)
end

-- Random theme generator
function ThemeManager:GenerateRandomTheme(name)
    local colors = {
        Primary = Color3.fromRGB(math.random(0, 50), math.random(0, 50), math.random(0, 50)),
        Secondary = Color3.fromRGB(math.random(50, 100), math.random(50, 100), math.random(50, 100)),
        Accent = Color3.fromRGB(math.random(100, 255), math.random(100, 255), math.random(100, 255)),
        Success = Color3.fromRGB(math.random(0, 100), math.random(200, 255), math.random(0, 100)),
        Error = Color3.fromRGB(math.random(200, 255), math.random(0, 100), math.random(0, 100)),
        Warning = Color3.fromRGB(math.random(200, 255), math.random(150, 255), math.random(0, 100)),
        Text = Color3.fromRGB(math.random(200, 255), math.random(200, 255), math.random(200, 255)),
        Border = Color3.fromRGB(math.random(100, 200), math.random(100, 200), math.random(100, 200)),
        Background = Color3.fromRGB(math.random(0, 30), math.random(0, 30), math.random(0, 30)),
        Surface = Color3.fromRGB(math.random(20, 50), math.random(20, 50), math.random(20, 50))
    }
    
    return self:CreateCustomTheme(name, colors)
end

return ThemeManager
