-- Авто-клик по кнопке возрождения после смерти + фиксированный телепорт + полет
local Player = game:GetService("Players").LocalPlayer
local UIS = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local TS = game:GetService("TeleportService")

-- Настройки
local AUTO_RESPAWN_ENABLED = false
local FLY_ENABLED = false
local CLICK_POSITION = {
    x = 0.75, -- 75% ширины экрана (правая половина)
    y = 0.25  -- 25% высоты экрана (середина верхней половины)
}
local TARGET_PLAYER = "BlackVoiseOne" -- Фиксированный игрок для телепорта

-- Создаем интерфейс
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = CoreGui

local MainWindow = Instance.new("Frame")
MainWindow.Name = "DeltaTools"
MainWindow.Parent = ScreenGui
MainWindow.Size = UDim2.new(0, 300, 0, 180)
MainWindow.Position = UDim2.new(0.7, 0, 0.5, -90)
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
Title.Text = "DELTA ROBLOX TOOLS"
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

-- Кнопка включения авто-респавна
local ToggleBtn = Instance.new("TextButton")
ToggleBtn.Name = "ToggleBtn"
ToggleBtn.Parent = Content
ToggleBtn.Size = UDim2.new(0.9, 0, 0, 30)
ToggleBtn.Position = UDim2.new(0.05, 0, 0.1, 0)
ToggleBtn.Text = "AUTO RESPAWN: OFF"
ToggleBtn.TextColor3 = Color3.fromRGB(255, 120, 120)
ToggleBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 80)

-- Кнопка телепорта к BlackVoiseOne
local TeleportBtn = Instance.new("TextButton")
TeleportBtn.Name = "TeleportBtn"
TeleportBtn.Parent = Content
TeleportBtn.Size = UDim2.new(0.9, 0, 0, 30)
TeleportBtn.Position = UDim2.new(0.05, 0, 0.35, 0)
TeleportBtn.Text = "TP TO @BlackVoiseOne"
TeleportBtn.TextColor3 = Color3.fromRGB(120, 200, 255)
TeleportBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 80)

-- Кнопка включения полета
local FlyBtn = Instance.new("TextButton")
FlyBtn.Name = "FlyBtn"
FlyBtn.Parent = Content
FlyBtn.Size = UDim2.new(0.9, 0, 0, 30)
FlyBtn.Position = UDim2.new(0.05, 0, 0.6, 0)
FlyBtn.Text = "FLY: OFF"
FlyBtn.TextColor3 = Color3.fromRGB(200, 120, 255)
FlyBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 80)

-- Информация
local InfoLabel = Instance.new("TextLabel")
InfoLabel.Name = "InfoLabel"
InfoLabel.Parent = Content
InfoLabel.Size = UDim2.new(0.9, 0, 0, 20)
InfoLabel.Position = UDim2.new(0.05, 0, 0.85, 0)
InfoLabel.Text = "Respawn: X-"..CLICK_POSITION.x.." Y-"..CLICK_POSITION.y
InfoLabel.TextColor3 = Color3.fromRGB(200, 200, 255)
InfoLabel.BackgroundTransparency = 1
InfoLabel.TextSize = 14

-- Стилизация
local function applyStyles()
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0.1, 0)
    corner.Parent = MainWindow
    
    local elements = {ToggleBtn, TeleportBtn, FlyBtn, MinimizeBtn, CloseBtn}
    
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

-- Функция для поиска игрока по нику
local function findPlayerByNickname(nick)
    for _, player in ipairs(game:GetService("Players"):GetPlayers()) do
        if player.Name:lower() == nick:lower() or 
           (player.DisplayName and player.DisplayName:lower() == nick:lower()) then
            return player
        end
    end
    return nil
end

-- Функция телепорта к BlackVoiseOne
local function teleportToTarget()
    local targetPlayer = findPlayerByNickname(TARGET_PLAYER)
    if not targetPlayer then
        InfoLabel.Text = TARGET_PLAYER.." не в игре!"
        task.wait(2)
        InfoLabel.Text = "Respawn: X-"..CLICK_POSITION.x.." Y-"..CLICK_POSITION.y
        return
    end
    
    local targetCharacter = targetPlayer.Character
    if not targetCharacter then
        InfoLabel.Text = "Персонаж не загружен!"
        task.wait(2)
        InfoLabel.Text = "Respawn: X-"..CLICK_POSITION.x.." Y-"..CLICK_POSITION.y
        return
    end
    
    local targetRoot = targetCharacter:FindFirstChild("HumanoidRootPart")
    if not targetRoot then
        InfoLabel.Text = "Не найдена корневая часть!"
        task.wait(2)
        InfoLabel.Text = "Respawn: X-"..CLICK_POSITION.x.." Y-"..CLICK_POSITION.y
        return
    end
    
    -- Для Delta Roblox используем NetworkAccess
    local myCharacter = Player.Character
    if myCharacter then
        local networkAccess = myCharacter:FindFirstChildWhichIsA("NetworkAccess")
        if networkAccess then
            networkAccess:FireServer("TeleportPlayer", Player, targetRoot.Position)
            InfoLabel.Text = "Телепорт к @"..TARGET_PLAYER.."!"
            task.wait(2)
            InfoLabel.Text = "Respawn: X-"..CLICK_POSITION.x.." Y-"..CLICK_POSITION.y
        else
            InfoLabel.Text = "Не найден NetworkAccess!"
            task.wait(2)
            InfoLabel.Text = "Respawn: X-"..CLICK_POSITION.x.." Y-"..CLICK_POSITION.y
        end
    else
        InfoLabel.Text = "Ваш персонаж не загружен!"
        task.wait(2)
        InfoLabel.Text = "Respawn: X-"..CLICK_POSITION.x.." Y-"..CLICK_POSITION.y
    end
end

-- Функция полета
local flyConnection
local function toggleFly()
    FLY_ENABLED = not FLY_ENABLED
    FlyBtn.Text = "FLY: "..(FLY_ENABLED and "ON" or "OFF")
    FlyBtn.TextColor3 = FLY_ENABLED and Color3.fromRGB(120, 255, 120) or Color3.fromRGB(200, 120, 255)
    
    local character = Player.Character
    if not character then return end
    
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if not humanoid then return end
    
    if FLY_ENABLED then
        -- Включаем полет
        humanoid.PlatformStand = true
        
        local bodyVelocity = Instance.new("BodyVelocity")
        bodyVelocity.Velocity = Vector3.new(0, 0, 0)
        bodyVelocity.MaxForce = Vector3.new(0, 0, 0)
        bodyVelocity.Parent = character:FindFirstChild("HumanoidRootPart")
        
        flyConnection = UIS.InputBegan:Connect(function(input, gameProcessed)
            if gameProcessed then return end
            
            local root = character:FindFirstChild("HumanoidRootPart")
            if not root then return end
            
            if input.KeyCode == Enum.KeyCode.Space then
                bodyVelocity.Velocity = Vector3.new(0, 50, 0)
            elseif input.KeyCode == Enum.KeyCode.LeftShift then
                bodyVelocity.Velocity = Vector3.new(0, -50, 0)
            end
        end)
        
        InfoLabel.Text = "Полет включен (Пробел/Шифт)"
        task.wait(2)
        InfoLabel.Text = "Respawn: X-"..CLICK_POSITION.x.." Y-"..CLICK_POSITION.y
    else
        -- Выключаем полет
        humanoid.PlatformStand = false
        if flyConnection then
            flyConnection:Disconnect()
            flyConnection = nil
        end
        
        local root = character:FindFirstChild("HumanoidRootPart")
        if root then
            for _, v in ipairs(root:GetChildren()) do
                if v:IsA("BodyVelocity") then
                    v:Destroy()
                end
            end
        end
        
        InfoLabel.Text = "Полет выключен"
        task.wait(2)
        InfoLabel.Text = "Respawn: X-"..CLICK_POSITION.x.." Y-"..CLICK_POSITION.y
    end
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
    
    -- При появлении нового персонажа обновляем полет
    if FLY_ENABLED then
        task.wait(1) -- Ждем загрузки персонажа
        toggleFly()
        toggleFly() -- Двойной вызов для правильного обновления
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

TeleportBtn.MouseButton1Click:Connect(function()
    teleportToTarget()
end)

FlyBtn.MouseButton1Click:Connect(function()
    toggleFly()
end)

MinimizeBtn.MouseButton1Click:Connect(function()
    Content.Visible = not Content.Visible
    MainWindow.Size = UDim2.new(0, 300, 0, Content.Visible and 180 or 25)
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

print("Delta Roblox Tools loaded!")
