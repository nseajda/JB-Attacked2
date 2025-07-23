local Player = game:GetService("Players").LocalPlayer
local CoreGui = game:GetService("CoreGui")

-- Интерфейс
local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local ToggleBtn = Instance.new("TextButton")

ScreenGui.Name = "DamageGUI_PC"
ScreenGui.Parent = CoreGui

-- Основной фрейм
MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
MainFrame.BorderSizePixel = 0
MainFrame.Position = UDim2.new(0.85, 0, 0.5, -25)
MainFrame.Size = UDim2.new(0, 100, 0, 50)
MainFrame.Active = true
MainFrame.Draggable = true

-- Кнопка
ToggleBtn.Name = "ToggleBtn"
ToggleBtn.Parent = MainFrame
ToggleBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
ToggleBtn.Size = UDim2.new(0.9, 0, 0.8, 0)
ToggleBtn.Position = UDim2.new(0.05, 0, 0.1, 0)
ToggleBtn.Text = "OFF"
ToggleBtn.TextColor3 = Color3.fromRGB(255, 100, 100)
ToggleBtn.TextSize = 14

-- Логика урона
local isActive = false
local remotePath = "Path.To.Game.Remote" -- Замените на реальный путь

local function dealRealDamage(target)
    if target and target:FindFirstChild("Humanoid") then
        -- Метод 1: Через RemoteEvent (надежнее)
        local remote = game:GetService("ReplicatedStorage"):FindFirstChild("DamageEvent")
        if remote then
            remote:FireServer(target, 5000)
        else
            -- Метод 2: Прямое изменение (если сервер не проверяет)
            target.Humanoid.Health = target.Humanoid.Health - 5000
        end
    end
end

ToggleBtn.MouseButton1Click:Connect(function()
    isActive = not isActive
    ToggleBtn.Text = isActive and "ON" or "OFF"
    ToggleBtn.TextColor3 = isActive and Color3.fromRGB(100, 255, 100) or Color3.fromRGB(255, 100, 100)
end)

-- Главный цикл
game:GetService("RunService").Heartbeat:Connect(function()
    if isActive and Player.Character then
        for _, v in ipairs(game.Players:GetPlayers()) do
            if v ~= Player and v.Character then
                dealRealDamage(v.Character)
            end
        end
    end
end)
