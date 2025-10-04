-- 🎨 AUTHENTICATION GUI
-- Modern authentication interface with key system and trial
-- Version: 5.1.0 - Rivals Edition

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")

local AuthGUI = {}
AuthGUI.GUI = nil
AuthGUI.OnAuthenticated = nil
AuthGUI.OnCancelled = nil

-- 🎨 THEME
local Theme = {
    Primary = Color3.fromRGB(30, 30, 40),
    Secondary = Color3.fromRGB(40, 40, 50),
    Accent = Color3.fromRGB(100, 150, 255),
    Success = Color3.fromRGB(50, 200, 100),
    Error = Color3.fromRGB(255, 80, 80),
    Warning = Color3.fromRGB(255, 200, 50),
    Text = Color3.fromRGB(255, 255, 255),
    TextSecondary = Color3.fromRGB(200, 200, 200),
    Border = Color3.fromRGB(60, 60, 70)
}

-- 🎨 CREATE MAIN FRAME
function AuthGUI:CreateMainFrame()
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "OtterAuthGUI"
    screenGui.ResetOnSpawn = false
    screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    
    -- Background blur effect
    local blur = Instance.new("Frame")
    blur.Name = "Blur"
    blur.Size = UDim2.new(1, 0, 1, 0)
    blur.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    blur.BackgroundTransparency = 0.3
    blur.BorderSizePixel = 0
    blur.ZIndex = 1
    blur.Parent = screenGui
    
    -- Main container
    local mainFrame = Instance.new("Frame")
    mainFrame.Name = "MainFrame"
    mainFrame.Size = UDim2.new(0, 450, 0, 550)
    mainFrame.Position = UDim2.new(0.5, -225, 0.5, -275)
    mainFrame.BackgroundColor3 = Theme.Primary
    mainFrame.BorderSizePixel = 0
    mainFrame.ZIndex = 2
    mainFrame.Parent = screenGui
    
    local mainCorner = Instance.new("UICorner")
    mainCorner.CornerRadius = UDim.new(0, 12)
    mainCorner.Parent = mainFrame
    
    local mainBorder = Instance.new("UIStroke")
    mainBorder.Color = Theme.Accent
    mainBorder.Thickness = 2
    mainBorder.Transparency = 0.5
    mainBorder.Parent = mainFrame
    
    -- Shadow effect
    local shadow = Instance.new("ImageLabel")
    shadow.Name = "Shadow"
    shadow.Size = UDim2.new(1, 30, 1, 30)
    shadow.Position = UDim2.new(0, -15, 0, -15)
    shadow.BackgroundTransparency = 1
    shadow.Image = "rbxasset://textures/ui/GuiImagePlaceholder.png"
    shadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
    shadow.ImageTransparency = 0.7
    shadow.ZIndex = 1
    shadow.Parent = mainFrame
    
    -- Animate entrance
    mainFrame.Size = UDim2.new(0, 0, 0, 0)
    TweenService:Create(mainFrame, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Size = UDim2.new(0, 450, 0, 550)
    }):Play()
    
    return screenGui, mainFrame
end

-- 🎨 CREATE HEADER
function AuthGUI:CreateHeader(parent)
    local header = Instance.new("Frame")
    header.Name = "Header"
    header.Size = UDim2.new(1, 0, 0, 80)
    header.Position = UDim2.new(0, 0, 0, 0)
    header.BackgroundColor3 = Theme.Secondary
    header.BorderSizePixel = 0
    header.Parent = parent
    
    local headerCorner = Instance.new("UICorner")
    headerCorner.CornerRadius = UDim.new(0, 12)
    headerCorner.Parent = header
    
    -- Logo/Icon
    local icon = Instance.new("TextLabel")
    icon.Name = "Icon"
    icon.Size = UDim2.new(0, 60, 0, 60)
    icon.Position = UDim2.new(0, 15, 0, 10)
    icon.BackgroundTransparency = 1
    icon.Text = "🦦"
    icon.TextSize = 40
    icon.Font = Enum.Font.GothamBold
    icon.Parent = header
    
    -- Title
    local title = Instance.new("TextLabel")
    title.Name = "Title"
    title.Size = UDim2.new(1, -90, 0, 35)
    title.Position = UDim2.new(0, 80, 0, 10)
    title.BackgroundTransparency = 1
    title.Text = "Otter Client"
    title.TextColor3 = Theme.Text
    title.TextSize = 28
    title.Font = Enum.Font.GothamBold
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Parent = header
    
    -- Subtitle
    local subtitle = Instance.new("TextLabel")
    subtitle.Name = "Subtitle"
    subtitle.Size = UDim2.new(1, -90, 0, 25)
    subtitle.Position = UDim2.new(0, 80, 0, 45)
    subtitle.BackgroundTransparency = 1
    subtitle.Text = "Authentication Required"
    subtitle.TextColor3 = Theme.TextSecondary
    subtitle.TextSize = 16
    subtitle.Font = Enum.Font.Gotham
    subtitle.TextXAlignment = Enum.TextXAlignment.Left
    subtitle.Parent = header
    
    return header
end

-- 🎨 CREATE KEY INPUT
function AuthGUI:CreateKeyInput(parent)
    local container = Instance.new("Frame")
    container.Name = "KeyInputContainer"
    container.Size = UDim2.new(1, -40, 0, 100)
    container.Position = UDim2.new(0, 20, 0, 100)
    container.BackgroundTransparency = 1
    container.Parent = parent
    
    -- Label
    local label = Instance.new("TextLabel")
    label.Name = "Label"
    label.Size = UDim2.new(1, 0, 0, 25)
    label.Position = UDim2.new(0, 0, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = "Enter Your Key:"
    label.TextColor3 = Theme.Text
    label.TextSize = 18
    label.Font = Enum.Font.GothamBold
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = container
    
    -- Input box
    local inputBox = Instance.new("TextBox")
    inputBox.Name = "KeyInput"
    inputBox.Size = UDim2.new(1, 0, 0, 50)
    inputBox.Position = UDim2.new(0, 0, 0, 35)
    inputBox.BackgroundColor3 = Theme.Secondary
    inputBox.BorderSizePixel = 0
    inputBox.Text = ""
    inputBox.PlaceholderText = "Enter your key here..."
    inputBox.PlaceholderColor3 = Theme.TextSecondary
    inputBox.TextColor3 = Theme.Text
    inputBox.TextSize = 18
    inputBox.Font = Enum.Font.Gotham
    inputBox.ClearTextOnFocus = false
    inputBox.Parent = container
    
    local inputCorner = Instance.new("UICorner")
    inputCorner.CornerRadius = UDim.new(0, 8)
    inputCorner.Parent = inputBox
    
    local inputPadding = Instance.new("UIPadding")
    inputPadding.PaddingLeft = UDim.new(0, 15)
    inputPadding.PaddingRight = UDim.new(0, 15)
    inputPadding.Parent = inputBox
    
    return container, inputBox
end

-- 🎨 CREATE BUTTONS
function AuthGUI:CreateButtons(parent, inputBox)
    local buttonsContainer = Instance.new("Frame")
    buttonsContainer.Name = "ButtonsContainer"
    buttonsContainer.Size = UDim2.new(1, -40, 0, 120)
    buttonsContainer.Position = UDim2.new(0, 20, 0, 220)
    buttonsContainer.BackgroundTransparency = 1
    buttonsContainer.Parent = parent
    
    -- Submit button
    local submitButton = Instance.new("TextButton")
    submitButton.Name = "SubmitButton"
    submitButton.Size = UDim2.new(1, 0, 0, 50)
    submitButton.Position = UDim2.new(0, 0, 0, 0)
    submitButton.BackgroundColor3 = Theme.Accent
    submitButton.BorderSizePixel = 0
    submitButton.Text = "🔓 Authenticate"
    submitButton.TextColor3 = Theme.Text
    submitButton.TextSize = 20
    submitButton.Font = Enum.Font.GothamBold
    submitButton.AutoButtonColor = false
    submitButton.Parent = buttonsContainer
    
    local submitCorner = Instance.new("UICorner")
    submitCorner.CornerRadius = UDim.new(0, 8)
    submitCorner.Parent = submitButton
    
    -- Trial button
    local trialButton = Instance.new("TextButton")
    trialButton.Name = "TrialButton"
    trialButton.Size = UDim2.new(1, 0, 0, 50)
    trialButton.Position = UDim2.new(0, 0, 0, 60)
    trialButton.BackgroundColor3 = Theme.Warning
    trialButton.BorderSizePixel = 0
    trialButton.Text = "🆓 Start Free Trial (1 Hour)"
    trialButton.TextColor3 = Theme.Text
    trialButton.TextSize = 18
    trialButton.Font = Enum.Font.GothamBold
    trialButton.AutoButtonColor = false
    trialButton.Parent = buttonsContainer
    
    local trialCorner = Instance.new("UICorner")
    trialCorner.CornerRadius = UDim.new(0, 8)
    trialCorner.Parent = trialButton
    
    -- Button hover effects
    submitButton.MouseEnter:Connect(function()
        TweenService:Create(submitButton, TweenInfo.new(0.2), {
            BackgroundColor3 = Color3.fromRGB(120, 170, 255)
        }):Play()
    end)
    
    submitButton.MouseLeave:Connect(function()
        TweenService:Create(submitButton, TweenInfo.new(0.2), {
            BackgroundColor3 = Theme.Accent
        }):Play()
    end)
    
    trialButton.MouseEnter:Connect(function()
        TweenService:Create(trialButton, TweenInfo.new(0.2), {
            BackgroundColor3 = Color3.fromRGB(255, 220, 70)
        }):Play()
    end)
    
    trialButton.MouseLeave:Connect(function()
        TweenService:Create(trialButton, TweenInfo.new(0.2), {
            BackgroundColor3 = Theme.Warning
        }):Play()
    end)
    
    return buttonsContainer, submitButton, trialButton
end

-- 🎨 CREATE INFO SECTION
function AuthGUI:CreateInfoSection(parent)
    local infoContainer = Instance.new("Frame")
    infoContainer.Name = "InfoContainer"
    infoContainer.Size = UDim2.new(1, -40, 0, 150)
    infoContainer.Position = UDim2.new(0, 20, 0, 360)
    infoContainer.BackgroundColor3 = Theme.Secondary
    infoContainer.BorderSizePixel = 0
    infoContainer.Parent = parent
    
    local infoCorner = Instance.new("UICorner")
    infoCorner.CornerRadius = UDim.new(0, 8)
    infoCorner.Parent = infoContainer
    
    -- Info text
    local infoText = Instance.new("TextLabel")
    infoText.Name = "InfoText"
    infoText.Size = UDim2.new(1, -20, 1, -20)
    infoText.Position = UDim2.new(0, 10, 0, 10)
    infoText.BackgroundTransparency = 1
    infoText.Text = [[
📝 Available Keys:
• "123" - Free Access
• "PREMIUM2024" - Premium Features
• "RIVALS_PRO" - Full Rivals Support
• "LIFETIME_VIP" - All Features + VIP

🆓 Or start a free 1-hour trial!
]]
    infoText.TextColor3 = Theme.TextSecondary
    infoText.TextSize = 14
    infoText.Font = Enum.Font.Gotham
    infoText.TextXAlignment = Enum.TextXAlignment.Left
    infoText.TextYAlignment = Enum.TextYAlignment.Top
    infoText.TextWrapped = true
    infoText.Parent = infoContainer
    
    return infoContainer
end

-- 🎨 CREATE STATUS MESSAGE
function AuthGUI:CreateStatusMessage(parent)
    local statusLabel = Instance.new("TextLabel")
    statusLabel.Name = "StatusLabel"
    statusLabel.Size = UDim2.new(1, -40, 0, 30)
    statusLabel.Position = UDim2.new(0, 20, 1, -40)
    statusLabel.BackgroundTransparency = 1
    statusLabel.Text = ""
    statusLabel.TextColor3 = Theme.TextSecondary
    statusLabel.TextSize = 14
    statusLabel.Font = Enum.Font.Gotham
    statusLabel.TextWrapped = true
    statusLabel.Visible = false
    statusLabel.Parent = parent
    
    return statusLabel
end

-- ✅ SHOW MESSAGE
function AuthGUI:ShowMessage(statusLabel, message, messageType)
    statusLabel.Visible = true
    statusLabel.Text = message
    
    if messageType == "success" then
        statusLabel.TextColor3 = Theme.Success
    elseif messageType == "error" then
        statusLabel.TextColor3 = Theme.Error
    elseif messageType == "warning" then
        statusLabel.TextColor3 = Theme.Warning
    else
        statusLabel.TextColor3 = Theme.TextSecondary
    end
    
    -- Flash animation
    statusLabel.TextTransparency = 1
    TweenService:Create(statusLabel, TweenInfo.new(0.3), {TextTransparency = 0}):Play()
end

-- 🚀 CREATE GUI
function AuthGUI:Create(authSystem)
    -- Clean up existing GUI
    if self.GUI then
        self.GUI:Destroy()
    end
    
    -- Create main GUI
    local screenGui, mainFrame = self:CreateMainFrame()
    self.GUI = screenGui
    
    -- Create header
    self:CreateHeader(mainFrame)
    
    -- Create key input
    local keyContainer, inputBox = self:CreateKeyInput(mainFrame)
    
    -- Create status message
    local statusLabel = self:CreateStatusMessage(mainFrame)
    
    -- Create buttons
    local buttonsContainer, submitButton, trialButton = self:CreateButtons(mainFrame, inputBox)
    
    -- Create info section
    self:CreateInfoSection(mainFrame)
    
    -- Submit button click
    submitButton.MouseButton1Click:Connect(function()
        local key = inputBox.Text
        
        if key == "" then
            self:ShowMessage(statusLabel, "❌ Please enter a key", "error")
            return
        end
        
        submitButton.Text = "⏳ Authenticating..."
        submitButton.BackgroundColor3 = Theme.TextSecondary
        
        task.wait(0.5)
        
        local success, message, keyData = authSystem:Authenticate(key)
        
        if success then
            self:ShowMessage(statusLabel, "✅ " .. message, "success")
            submitButton.Text = "✅ Authenticated!"
            submitButton.BackgroundColor3 = Theme.Success
            
            task.wait(1)
            
            -- Close GUI and call callback
            self:Close()
            if self.OnAuthenticated then
                self.OnAuthenticated(keyData)
            end
        else
            self:ShowMessage(statusLabel, "❌ " .. message, "error")
            submitButton.Text = "🔓 Authenticate"
            submitButton.BackgroundColor3 = Theme.Accent
        end
    end)
    
    -- Trial button click
    trialButton.MouseButton1Click:Connect(function()
        trialButton.Text = "⏳ Starting Trial..."
        trialButton.BackgroundColor3 = Theme.TextSecondary
        
        task.wait(0.5)
        
        local success, message = authSystem:StartTrial()
        
        if success then
            self:ShowMessage(statusLabel, "✅ " .. message, "success")
            trialButton.Text = "✅ Trial Started!"
            trialButton.BackgroundColor3 = Theme.Success
            
            authSystem.Authenticated = true
            
            task.wait(1)
            
            -- Close GUI and call callback
            self:Close()
            if self.OnAuthenticated then
                self.OnAuthenticated({tier = "trial", features = authSystem.Config.TrialFeatures})
            end
        else
            self:ShowMessage(statusLabel, "❌ " .. message, "error")
            trialButton.Text = "🆓 Start Free Trial (1 Hour)"
            trialButton.BackgroundColor3 = Theme.Warning
        end
    end)
    
    -- Enter key to submit
    inputBox.FocusLost:Connect(function(enterPressed)
        if enterPressed then
            submitButton.MouseButton1Click:Fire()
        end
    end)
    
    -- Parent to CoreGui
    screenGui.Parent = CoreGui
    
    return screenGui
end

-- 🔒 CLOSE GUI
function AuthGUI:Close()
    if self.GUI then
        local mainFrame = self.GUI:FindFirstChild("MainFrame")
        if mainFrame then
            TweenService:Create(mainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
                Size = UDim2.new(0, 0, 0, 0)
            }):Play()
            
            task.wait(0.3)
        end
        
        self.GUI:Destroy()
        self.GUI = nil
    end
end

-- 🎨 SHOW GUI
function AuthGUI:Show(authSystem, onAuthenticated, onCancelled)
    self.OnAuthenticated = onAuthenticated
    self.OnCancelled = onCancelled
    
    return self:Create(authSystem)
end

return AuthGUI
