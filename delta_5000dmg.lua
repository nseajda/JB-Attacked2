-- Авто-телепорт к игроку после смерти
local Player = game:GetService("Players").LocalPlayer
local UIS = game:GetService("UserInputService")

-- Настройки
local TARGET_NAME = "BlackVoiseOne" -- Ник для авто-телепорта
local AUTO_RESPAWN_ENABLED = false -- Изначально выключено

-- Создаем интерфейс
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = game:GetService("CoreGui")

local MainWindow = Instance.new("Frame")
MainWindow.Name = "TeleportWindow"
MainWindow.Parent = ScreenGui
MainWindow.Size = UDim2.new(0, 220, 0, 150)
MainWindow.Position = UDim2.new(0.8, 0, 0.5, -75)
MainWindow.BackgroundColor3 = Color3.fromRGB(35, 35, 50)
MainWindow.Active = true
MainWindow.Draggable = true

-- Заголовок с кнопками управления
local TitleBar = Instance.new("Frame")
TitleBar.Name = "TitleBar"
TitleBar.Parent = MainWindow
TitleBar.Size = UDim2.new(1, 0, 0, 25)
TitleBar.BackgroundColor3 = Color3.fromRGB(50, 50, 70)

local Title = Instance.new("TextLabel")
Title.Name = "Title"
Title.Parent = TitleBar
Title.Size = UDim2.new(0.7, 0, 1, 0)
Title.Text = "AUTO TELEPORT"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.GothamBold

local MinimizeBtn = Instance.new("TextButton")
MinimizeBtn.Name = "MinimizeBtn"
MinimizeBtn.Parent = TitleBar
MinimizeBtn.Size = UDim2.new(0, 25, 0, 25)
MinimizeBtn.Position = UDim2.new(0.7, 0, 0, 0)
MinimizeBtn.Text = "_"
MinimizeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
MinimizeBtn.BackgroundColor3 = Color3.fromRGB(70, 70, 90)

local CloseBtn = Instance.new("TextButton")
CloseBtn.Name = "CloseBtn"
CloseBtn.Parent = TitleBar
CloseBtn.Size = UDim2.new(0, 25, 0, 25)
CloseBtn.Position = UDim2.new(0.85, 0, 0, 0)
CloseBtn.Text = "X"
CloseBtn.TextColor3 = Color3.fromRGB(255, 150, 150)
CloseBtn.BackgroundColor3 = Color3.fromRGB(70, 70, 90)

-- Основное содержимое
local Content = Instance.new("Frame")
Content.Name = "Content"
Content.Parent = MainWindow
Content.Size = UDim2.new(1, 0, 1, -25)
Content.Position = UDim2.new(0, 0, 0, 25)
Content.BackgroundTransparency = 1

-- Кнопки
local AutoRespawnBtn = Instance.new("TextButton")
AutoRespawnBtn.Name = "AutoRespawnBtn"
AutoRespawnBtn.Parent = Content
AutoRespawnBtn.Size = UDim2.new(0.9, 0, 0, 35)
AutoRespawnBtn.Position = UDim2.new(0.05, 0, 0.05, 0)
AutoRespawnBtn.Text = "AUTO RESPAWN: OFF"
AutoRespawnBtn.TextColor3 = Color3.fromRGB(255, 120, 120)
AutoRespawnBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 80)

local TeleportBtn = Instance.new("TextButton")
TeleportBtn.Name = "TeleportBtn"
TeleportBtn.Parent = Content
TeleportBtn.Size = UDim2.new(0.9, 0, 0, 35)
TeleportBtn.Position = UDim2.new(0.05, 0, 0.35, 0)
TeleportBtn.Text = "TELEPORT NOW"
TeleportBtn.TextColor3 = Color3.fromRGB(120, 255, 120)
TeleportBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 80)

-- Стилизация
local function applyStyles()
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0.1, 0)
    corner.Parent = MainWindow
    
    local elements = {AutoRespawnBtn, TeleportBtn, MinimizeBtn, CloseBtn}
    
    for _, element in pairs(elements) do
        local elementCorner = Instance.new("UICorner")
        elementCorner.CornerRadius = UDim.new(0.3, 0)
        elementCorner.Parent = element
        
        local stroke = Instance.new("UIStroke")
        stroke.Color = Color3.fromRGB(100, 100, 140)
        stroke.Thickness = 1
        stroke.Parent = element
    end
end
applyStyles()

-- Функция телепортации
local function teleportToPlayer()
    for _, target in ipairs(game.Players:GetPlayers()) do
        if target.Name == TARGET_NAME and target.Character then
            local hrp = target.Character:FindFirstChild("HumanoidRootPart")
            if hrp and Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") then
                Player.Character.HumanoidRootPart.CFrame = hrp.CFrame + Vector3.new(0, 3, 0)
                return true
            end
        end
    end
    return false
end

-- Обработка смерти
local function onCharacterAdded(character)
    if AUTO_RESPAWN_ENABLED then
        character:WaitForChild("Humanoid").Died:Connect(function()
            task.wait(1) -- Ждем респавна
            if teleportToPlayer() then
                print("Авто-телепорт к "..TARGET_NAME.." выполнен")
            else
                print("Игрок "..TARGET_NAME.." не найден")
            end
        end)
    end
end

Player.CharacterAdded:Connect(onCharacterAdded)

-- Обработчики кнопок
AutoRespawnBtn.MouseButton1Click:Connect(function()
    AUTO_RESPAWN_ENABLED = not AUTO_RESPAWN_ENABLED
    AutoRespawnBtn.Text = "AUTO RESPAWN: "..(AUTO_RESPAWN_ENABLED and "ON" or "OFF")
    AutoRespawnBtn.TextColor3 = AUTO_RESPAWN_ENABLED and Color3.fromRGB(120, 255, 120) or Color3.fromRGB(255, 120, 120)
end)

TeleportBtn.MouseButton1Click:Connect(function()
    if teleportToPlayer() then
        TeleportBtn.Text = "УСПЕШНО!"
        task.wait(1)
        TeleportBtn.Text = "TELEPORT NOW"
    else
        TeleportBtn.Text = "НЕ НАЙДЕН!"
        task.wait(1)
        TeleportBtn.Text = "TELEPORT NOW"
    end
end)

MinimizeBtn.MouseButton1Click:Connect(function()
    Content.Visible = not Content.Visible
    MainWindow.Size = UDim2.new(0, 220, 0, Content.Visible and 150 or 25)
    MinimizeBtn.Text = Content.Visible and "_" or "+"
end)

CloseBtn.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

-- Инициализация
if Player.Character then
    onCharacterAdded(Player.Character)
end

print("AutoTeleport loaded! Target: "..TARGET_NAME)
