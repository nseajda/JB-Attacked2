-- Авто-респавн + телепорт к BlackVoiseOne для Delta (Jurassic Blocky)
local Player = game:GetService("Players").LocalPlayer
local UIS = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local TPService = game:GetService("TeleportService")

-- Настройки
local AUTO_RESPAWN = false
local AUTO_TELEPORT = false
local TARGET_PLAYER = "BlackVoiseOne" -- Игрок, к которому телепортируемся
local RESPAWN_BUTTON_POS = {
    x = 0.8, -- 80% ширины экрана (кнопка респавна обычно справа)
    y = 0.3  -- 30% высоты экрана
}

-- UI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "DeltaAutoRespawn"
ScreenGui.Parent = CoreGui

local MainFrame = Instance.new("Frame")
MainFrame.Name = "Main"
MainFrame.Parent = ScreenGui
MainFrame.Size = UDim2.new(0, 300, 0, 180)
MainFrame.Position = UDim2.new(0.7, 0, 0.5, -90)
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
MainFrame.Active = true
MainFrame.Draggable = true

-- Заголовок
local TitleBar = Instance.new("Frame")
TitleBar.Name = "TitleBar"
TitleBar.Parent = MainFrame
TitleBar.Size = UDim2.new(1, 0, 0, 30)
TitleBar.BackgroundColor3 = Color3.fromRGB(50, 50, 70)

local Title = Instance.new("TextLabel")
Title.Name = "Title"
Title.Parent = TitleBar
Title.Size = UDim2.new(0.7, 0, 1, 0)
Title.Text = "DELTA AUTO-RESPAWN"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.GothamBold

local CloseBtn = Instance.new("TextButton")
CloseBtn.Name = "CloseBtn"
CloseBtn.Parent = TitleBar
CloseBtn.Size = UDim2.new(0, 30, 0, 30)
CloseBtn.Position = UDim2.new(0.9, 0, 0, 0)
CloseBtn.Text = "X"
CloseBtn.TextColor3 = Color3.fromRGB(255, 100, 100)
CloseBtn.BackgroundColor3 = Color3.fromRGB(70, 70, 90)

-- Основные кнопки
local ToggleRespawnBtn = Instance.new("TextButton")
ToggleRespawnBtn.Name = "ToggleRespawn"
ToggleRespawnBtn.Parent = MainFrame
ToggleRespawnBtn.Size = UDim2.new(0.9, 0, 0, 35)
ToggleRespawnBtn.Position = UDim2.new(0.05, 0, 0.2, 0)
ToggleRespawnBtn.Text = "AUTO-RESPAWN: OFF"
ToggleRespawnBtn.TextColor3 = Color3.fromRGB(255, 120, 120)
ToggleRespawnBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 80)

local ToggleTeleportBtn = Instance.new("TextButton")
ToggleTeleportBtn.Name = "ToggleTeleport"
ToggleTeleportBtn.Parent = MainFrame
ToggleTeleportBtn.Size = UDim2.new(0.9, 0, 0, 35)
ToggleTeleportBtn.Position = UDim2.new(0.05, 0, 0.45, 0)
ToggleTeleportBtn.Text = "TELEPORT TO "..TARGET_PLAYER..": OFF"
ToggleTeleportBtn.TextColor3 = Color3.fromRGB(255, 120, 120)
ToggleTeleportBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 80)

local TeleportNowBtn = Instance.new("TextButton")
TeleportNowBtn.Name = "TeleportNow"
TeleportNowBtn.Parent = MainFrame
TeleportNowBtn.Size = UDim2.new(0.9, 0, 0, 35)
TeleportNowBtn.Position = UDim2.new(0.05, 0, 0.7, 0)
TeleportNowBtn.Text = "TELEPORT NOW"
TeleportNowBtn.TextColor3 = Color3.fromRGB(200, 200, 255)
TeleportNowBtn.BackgroundColor3 = Color3.fromRGB(80, 60, 80)

-- Стилизация
local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0.1, 0)
UICorner.Parent = MainFrame

for _, btn in pairs({ToggleRespawnBtn, ToggleTeleportBtn, TeleportNowBtn, CloseBtn}) do
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0.3, 0)
    btnCorner.Parent = btn
    
    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(100, 100, 140)
    stroke.Thickness = 1.5
    stroke.Parent = btn
end

-- Функция клика по кнопке респавна
local function clickRespawnButton()
    local viewport = workspace.CurrentCamera.ViewportSize
    local clickX = viewport.X * RESPAWN_BUTTON_POS.x
    local clickY = viewport.Y * RESPAWN_BUTTON_POS.y
    
    UIS:SetMouseLocation(Vector2.new(clickX, clickY))
    task.wait(0.1)
    mouse1click()
    print("[Delta] Авто-клик респавна")
end

-- Телепорт к игроку
local function teleportToTarget()
    local target = nil
    for _, player in ipairs(game.Players:GetPlayers()) do
        if player.Name == TARGET_PLAYER then
            target = player
            break
        end
    end

    if not target then
        warn("[Delta] Игрок "..TARGET_PLAYER.." не найден!")
        return
    end

    if target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
        local humanoid = Player.Character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
            task.wait(0.2)
            Player.Character:MoveTo(target.Character.HumanoidRootPart.Position + Vector3.new(3, 0, 3))
            print("[Delta] Телепортирован к "..TARGET_PLAYER)
        end
    else
        warn("[Delta] Целевой игрок не имеет персонажа!")
    end
end

-- Обработчик смерти
local function onCharacterAdded(character)
    if AUTO_RESPAWN then
        character:WaitForChild("Humanoid").Died:Connect(function()
            task.wait(2.5) -- Ждем появления экрана смерти в Delta
            
            -- Кликаем респавн
            for _ = 1, 2 do -- Двойной клик для надежности
                clickRespawnButton()
                task.wait(0.5)
            end

            -- Если включена телепортация - ждем возрождения и телепортируемся
            if AUTO_TELEPORT then
                Player.CharacterAdded:Wait()
                task.wait(1.5) -- Даем время на загрузку
                teleportToTarget()
            end
        end)
    end
end

-- Обработчики кнопок
ToggleRespawnBtn.MouseButton1Click:Connect(function()
    AUTO_RESPAWN = not AUTO_RESPAWN
    ToggleRespawnBtn.Text = "AUTO-RESPAWN: " .. (AUTO_RESPAWN and "ON" or "OFF")
    ToggleRespawnBtn.TextColor3 = AUTO_RESPAWN and Color3.fromRGB(120, 255, 120) or Color3.fromRGB(255, 120, 120)
    
    if AUTO_RESPAWN and Player.Character then
        onCharacterAdded(Player.Character)
    end
end)

ToggleTeleportBtn.MouseButton1Click:Connect(function()
    AUTO_TELEPORT = not AUTO_TELEPORT
    ToggleTeleportBtn.Text = "TELEPORT TO "..TARGET_PLAYER..": " .. (AUTO_TELEPORT and "ON" or "OFF")
    ToggleTeleportBtn.TextColor3 = AUTO_TELEPORT and Color3.fromRGB(120, 255, 120) or Color3.fromRGB(255, 120, 120)
end)

TeleportNowBtn.MouseButton1Click:Connect(function()
    if Player.Character then
        teleportToTarget()
    else
        warn("[Delta] Нет персонажа для телепортации!")
    end
end)

CloseBtn.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

-- Инициализация
Player.CharacterAdded:Connect(onCharacterAdded)
if Player.Character then
    onCharacterAdded(Player.Character)
end

print("[Delta] Auto-Respawn loaded | Target: "..TARGET_PLAYER)
