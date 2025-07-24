-- Авто-клик по кнопке возрождения после смерти
local Player = game:GetService("Players").LocalPlayer
local UIS = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")

-- Настройки
local AUTO_RESPAWN_ENABLED = false
local CLICK_POSITION = {
    x = 0.75, -- 75% ширины экрана (правая половина)
    y = 0.25  -- 25% высоты экрана (середина верхней половины)
}

-- Создаем интерфейс
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = CoreGui

local MainWindow = Instance.new("Frame")
MainWindow.Name = "RespawnClicker"
MainWindow.Parent = ScreenGui
MainWindow.Size = UDim2.new(0, 250, 0, 100)
MainWindow.Position = UDim2.new(0.7, 0, 0.5, -50)
MainWindow.BackgroundColor3 = Color3.fromRGB(35, 35, 50)
MainWindow.Active = true
MainWindow.Draggable = true

-- Заголовок
local TitleBar = Instance.new("Frame")
TitleBar.Name = "TitleBar"
TitleBar.Parent = MainWindow
TitleBar.Size = UDim2.new(1, 0, 0, 25)
TitleBar.BackgroundColor3 = Color3.fromRGB(50, 50, 70)

local Title = Instance.new("TextLabel")
Title.Name = "Title"
Title.Parent = TitleBar
Title.Size = UDim2.new(0.7, 0, 1, 0)
Title.Text = "AUTO RESPAWN CLICKER"
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

-- Кнопка включения
local ToggleBtn = Instance.new("TextButton")
ToggleBtn.Name = "ToggleBtn"
ToggleBtn.Parent = Content
ToggleBtn.Size = UDim2.new(0.9, 0, 0, 40)
ToggleBtn.Position = UDim2.new(0.05, 0, 0.1, 0)
ToggleBtn.Text = "AUTO RESPAWN: OFF"
ToggleBtn.TextColor3 = Color3.fromRGB(255, 120, 120)
ToggleBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 80)

-- Информация
local InfoLabel = Instance.new("TextLabel")
InfoLabel.Name = "InfoLabel"
InfoLabel.Parent = Content
InfoLabel.Size = UDim2.new(0.9, 0, 0, 30)
InfoLabel.Position = UDim2.new(0.05, 0, 0.6, 0)
InfoLabel.Text = "Клик в позиции: X-"..CLICK_POSITION.x.." Y-"..CLICK_POSITION.y
InfoLabel.TextColor3 = Color3.fromRGB(200, 200, 255)
InfoLabel.BackgroundTransparency = 1

-- Стилизация
local function applyStyles()
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0.1, 0)
    corner.Parent = MainWindow
    
    local elements = {ToggleBtn, MinimizeBtn, CloseBtn}
    
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

-- Функция клика
local function clickRespawnButton()
    local viewportSize = workspace.CurrentCamera.ViewportSize
    local clickX = viewportSize.X * CLICK_POSITION.x
    local clickY = viewportSize.Y * CLICK_POSITION.y
    
    -- Имитируем клик мышью
    UIS:SetMouseLocation(Vector2.new(clickX, clickY))
    task.wait(0.1)
    mouse1click()
    print("Авто-клик в позиции:", clickX, clickY)
end

-- Обработка смерти
local function onCharacterAdded(character)
    if AUTO_RESPAWN_ENABLED then
        character:WaitForChild("Humanoid").Died:Connect(function()
            task.wait(2) -- Ждем появления экрана смерти
            clickRespawnButton()
            
            -- Дополнительный клик через 3 секунды на всякий случай
            task.wait(3)
            if not Player.Character then
                clickRespawnButton()
            end
        end)
    end
end

-- Обработчики событий
ToggleBtn.MouseButton1Click:Connect(function()
    AUTO_RESPAWN_ENABLED = not AUTO_RESPAWN_ENABLED
    ToggleBtn.Text = "AUTO RESPAWN: "..(AUTO_RESPAWN_ENABLED and "ON" or "OFF")
    ToggleBtn.TextColor3 = AUTO_RESPAWN_ENABLED and Color3.fromRGB(120, 255, 120) or Color3.fromRGB(255, 120, 120)
    
    if AUTO_RESPAWN_ENABLED and Player.Character then
        onCharacterAdded(Player.Character)
    end
end)

MinimizeBtn.MouseButton1Click:Connect(function()
    Content.Visible = not Content.Visible
    MainWindow.Size = UDim2.new(0, 250, 0, Content.Visible and 100 or 25)
    MinimizeBtn.Text = Content.Visible and "_" or "+"
end)

CloseBtn.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

-- Инициализация
Player.CharacterAdded:Connect(onCharacterAdded)
if Player.Character then
    onCharacterAdded(Player.Character)
end

print("RespawnClicker loaded! Click position:", CLICK_POSITION.x, CLICK_POSITION.y)
