-- [[ AUTO FRIEND 0.1 - FIX & PREMIUM ]] --

local REQUIRED_ID = 139217467707445 -- Твой ID плейса
local Players = game:GetService("Players")

-- Проверка на игру (если ID не совпадает, просто уведомляем, чтобы не ломать инжект)
if game.PlaceId ~= REQUIRED_ID and game.GameId ~= REQUIRED_ID then
    -- Если хочешь жесткий кик, раскомментируй строку ниже:
    -- Players.LocalPlayer:Kick("Dont game support! Please start place Trading Plaza Steal a Brainrot")
end

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local StarterGui = game:GetService("StarterGui")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- Конфиг
local config = {
    enabled = false,
    addedUsers = {},
    volume = 0.5,
    theme = "Black",
    menuVisible = true,
    running = true
}

local themes = {
    Black = {bg = Color3.fromRGB(15, 15, 15), accent = Color3.fromRGB(255, 255, 255), stroke = Color3.fromRGB(255, 0, 0)},
    White = {bg = Color3.fromRGB(245, 245, 245), accent = Color3.fromRGB(0, 0, 0), stroke = Color3.fromRGB(0, 120, 255)},
    Silver = {bg = Color3.fromRGB(180, 180, 180), accent = Color3.fromRGB(25, 25, 25), stroke = Color3.fromRGB(255, 255, 255)}
}

-- [[ ГЛАВНЫЙ ИНТЕРФЕЙС ]] --
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "AutoFriend_Final"
ScreenGui.IgnoreGuiInset = true
ScreenGui.Parent = PlayerGui

-- [[ ССЫЛКА НА ЭКРАНЕ (ЖИРНО) ]] --
local ScreenLink = Instance.new("TextLabel")
ScreenLink.Size = UDim2.new(0, 400, 0, 50)
ScreenLink.Position = UDim2.new(0.5, -200, 0.05, 0) -- Сверху по центру
ScreenLink.BackgroundTransparency = 1
ScreenLink.Text = "<b>discord.gg/EPr4H8HQFR</b>"
ScreenLink.RichText = true
ScreenLink.TextColor3 = Color3.new(1, 1, 1)
ScreenLink.Font = Enum.Font.GothamBold
ScreenLink.TextSize = 28 -- Очень жирно и видно
ScreenLink.Parent = ScreenGui

local LinkStroke = Instance.new("UIStroke", ScreenLink)
LinkStroke.Thickness = 2
LinkStroke.Color = Color3.new(0, 0, 0)

-- [[ МЕНЮ ]] --
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 300, 0, 380)
MainFrame.Position = UDim2.new(0.5, -150, 0.4, -190)
MainFrame.BackgroundColor3 = themes[config.theme].bg
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 12)

local MainStroke = Instance.new("UIStroke", MainFrame)
MainStroke.Thickness = 2
MainStroke.Color = themes[config.theme].stroke

-- Анимация обводки
task.spawn(function()
    while config.running do
        local t = tick()
        MainStroke.Color = Color3.fromHSV((t*0.1)%1, 0.8, 1)
        task.wait()
    end
end)

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 50)
Title.BackgroundTransparency = 1
Title.Text = "AUTO FRIEND 0.1"
Title.TextColor3 = themes[config.theme].accent
Title.Font = Enum.Font.GothamBold
Title.TextSize = 20
Title.Parent = MainFrame

-- [[ КНОПКИ И ПОЛЗУНОК ]] --
local function CreateButton(text, pos, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.9, 0, 0, 40)
    btn.Position = pos
    btn.BackgroundColor3 = themes[config.theme].accent
    btn.BackgroundTransparency = 0.85
    btn.Text = text
    btn.TextColor3 = themes[config.theme].accent
    btn.Font = Enum.Font.GothamMedium
    btn.Parent = MainFrame
    Instance.new("UICorner", btn)
    btn.MouseButton1Click:Connect(callback)
    return btn
end

local ToggleBtn = CreateButton("STATUS: OFF", UDim2.new(0.05, 0, 0.2, 0), function()
    config.enabled = not config.enabled
    ToggleBtn.Text = config.enabled and "STATUS: ON" or "STATUS: OFF"
    ToggleBtn.TextColor3 = config.enabled and Color3.new(0, 1, 0) or themes[config.theme].accent
end)

local ThemeBtn = CreateButton("THEME: BLACK", UDim2.new(0.05, 0, 0.35, 0), function()
    if config.theme == "Black" then config.theme = "White"
    elseif config.theme == "White" then config.theme = "Silver"
    else config.theme = "Black" end
    
    ThemeBtn.Text = "THEME: " .. config.theme:upper()
    MainFrame.BackgroundColor3 = themes[config.theme].bg
    Title.TextColor3 = themes[config.theme].accent
end)

-- РАБОЧИЙ ПОЛЗУНОК
local VolLabel = Instance.new("TextLabel")
VolLabel.Size = UDim2.new(1, 0, 0, 20)
VolLabel.Position = UDim2.new(0, 0, 0.48, 0)
VolLabel.Text = "VOLUME: 50%"
VolLabel.TextColor3 = themes[config.theme].accent
VolLabel.BackgroundTransparency = 1
VolLabel.Parent = MainFrame

local SliderBG = Instance.new("TextButton")
SliderBG.Size = UDim2.new(0.8, 0, 0, 8)
SliderBG.Position = UDim2.new(0.1, 0, 0.55, 0)
SliderBG.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
SliderBG.Text = ""
SliderBG.Parent = MainFrame
Instance.new("UICorner", SliderBG)

local SliderFill = Instance.new("Frame")
SliderFill.Size = UDim2.new(0.5, 0, 1, 0)
SliderFill.BackgroundColor3 = Color3.new(1, 0, 0)
SliderFill.BorderSizePixel = 0
SliderFill.Parent = SliderBG
Instance.new("UICorner", SliderFill)

local function UpdateSlider()
    local mousePos = UserInputService:GetMouseLocation().X
    local barPos = SliderBG.AbsolutePosition.X
    local barSize = SliderBG.AbsoluteSize.X
    local percent = math.clamp((mousePos - barPos) / barSize, 0, 1)
    SliderFill.Size = UDim2.new(percent, 0, 1, 0)
    config.volume = percent
    VolLabel.Text = "VOLUME: " .. math.floor(percent * 100) .. "%"
end

SliderBG.MouseButton1Down:Connect(function()
    local conn = RunService.RenderStepped:Connect(UpdateSlider)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then conn:Disconnect() end
    end)
end)

-- Титры внизу
local Credits = Instance.new("TextLabel")
Credits.Size = UDim2.new(1, 0, 0, 20)
Credits.Position = UDim2.new(0, 0, 0.8, 0)
Credits.Text = "codding by @! filz1yesss-F"
Credits.TextColor3 = themes[config.theme].accent
Credits.BackgroundTransparency = 1
Credits.Parent = MainFrame

local CloseBtn = CreateButton("DESTROY SCRIPT", UDim2.new(0.05, 0, 0.88, 0), function()
    config.running = false
    ScreenGui:Destroy()
end)

-- [[ УВЕДОМЛЕНИЯ ]] --
local function Notify(msg)
    local n = Instance.new("Frame")
    n.Size = UDim2.new(0, 180, 0, 35)
    n.Position = UDim2.new(-1, 0, 0.1, 0)
    n.BackgroundColor3 = themes[config.theme].bg
    n.Parent = ScreenGui
    Instance.new("UICorner", n)
    Instance.new("UIStroke", n).Color = themes[config.theme].accent
    
    local t = Instance.new("TextLabel")
    t.Size = UDim2.new(1, 0, 1, 0)
    t.Text = msg
    t.TextColor3 = themes[config.theme].accent
    t.Font = Enum.Font.GothamBold
    t.TextSize = 11
    t.BackgroundTransparency = 1
    t.Parent = n

    n:TweenPosition(UDim2.new(0, 20, 0.1, 0), "Out", "Back", 0.5)
    task.delay(2, function()
        n:TweenPosition(UDim2.new(-1, 0, 0.1, 0), "In", "Quad", 0.5, true, function() n:Destroy() end)
    end)
end

-- [[ ЛОГИКА ДОБАВЛЕНИЯ ]] --
RunService.Heartbeat:Connect(function()
    if not config.enabled or not config.running then return end
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
            local d = (LocalPlayer.Character.HumanoidRootPart.Position - p.Character.HumanoidRootPart.Position).Magnitude
            if d < 12 and not config.addedUsers[p.UserId] then
                config.addedUsers[p.UserId] = true
                StarterGui:SetCore("PromptSendFriendRequest", p)
                task.delay(1.2, function()
                    local v = workspace.CurrentCamera.ViewportSize
                    VirtualInputManager:SendMouseMoveEvent(v.X/2 - 65, v.Y/2 + 105, game)
                    VirtualInputManager:SendMouseButtonEvent(v.X/2 - 65, v.Y/2 + 105, 0, true, game, 0)
                    task.wait(0.1)
                    VirtualInputManager:SendMouseButtonEvent(v.X/2 - 65, v.Y/2 + 105, 0, false, game, 0)
                    Notify("USER ADDED")
                    local s = Instance.new("Sound", game:GetService("SoundService"))
                    s.SoundId = "rbxassetid://7145319532"; s.Volume = config.volume; s:Play()
                end)
            end
        end
    end
end)

-- Скрытие на U
UserInputService.InputBegan:Connect(function(input, gpe)
    if not gpe and input.KeyCode == Enum.KeyCode.U then
        config.menuVisible = not config.menuVisible
        local target = config.menuVisible and UDim2.new(0.5, -150, 0.4, -190) or UDim2.new(0.5, -150, -1, 0)
        TweenService:Create(MainFrame, TweenInfo.new(0.5, Enum.EasingStyle.Quart), {Position = target}):Play()
    end
end)

Notify("Script Loaded!")
