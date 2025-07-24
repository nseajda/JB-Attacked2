-- Delta Auto-Respawn + Teleport to BlackVoiseOne (FIXED)
local Player = game:GetService("Players").LocalPlayer
local UIS = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Настройки
local AUTO_RESPAWN = true -- Авто-респавн по умолчанию ВКЛ
local AUTO_TELEPORT = true -- Авто-телепорт по умолчанию ВКЛ
local TARGET_PLAYER = "BlackVoiseOne" -- Игрок для телепорта
local RESPAWN_DELAY = 3 -- Задержка перед кликом на респавн (сек)

-- UI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "DeltaRespawnGUI"
ScreenGui.Parent = CoreGui

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 300, 0, 180)
MainFrame.Position = UDim2.new(0.7, 0, 0.5, -90)
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

-- Заголовок
local Title = Instance.new("TextLabel")
Title.Text = "DELTA AUTO-RESPAWN"
Title.Size = UDim2.new(1, 0, 0, 30)
Title.Position = UDim2.new(0, 0, 0, 0)
Title.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.GothamBold
Title.Parent = MainFrame

-- Кнопки
local ToggleRespawnBtn = Instance.new("TextButton")
ToggleRespawnBtn.Text = "AUTO-RESPAWN: " .. (AUTO_RESPAWN and "ON" or "OFF")
ToggleRespawnBtn.Size = UDim2.new(0.9, 0, 0, 35)
ToggleRespawnBtn.Position = UDim2.new(0.05, 0, 0.2, 0)
ToggleRespawnBtn.TextColor3 = AUTO_RESPAWN and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
ToggleRespawnBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
ToggleRespawnBtn.Parent = MainFrame

local ToggleTeleportBtn = Instance.new("TextButton")
ToggleTeleportBtn.Text = "TELEPORT: " .. (AUTO_TELEPORT and "ON" or "OFF")
ToggleTeleportBtn.Size = UDim2.new(0.9, 0, 0, 35)
ToggleTeleportBtn.Position = UDim2.new(0.05, 0, 0.45, 0)
ToggleTeleportBtn.TextColor3 = AUTO_TELEPORT and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
ToggleTeleportBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
ToggleTeleportBtn.Parent = MainFrame

local TeleportNowBtn = Instance.new("TextButton")
TeleportNowBtn.Text = "TELEPORT NOW"
TeleportNowBtn.Size = UDim2.new(0.9, 0, 0, 35)
TeleportNowBtn.Position = UDim2.new(0.05, 0, 0.7, 0)
TeleportNowBtn.TextColor3 = Color3.fromRGB(255, 255, 0)
TeleportNowBtn.BackgroundColor3 = Color3.fromRGB(60, 50, 80)
TeleportNowBtn.Parent = MainFrame

-- Стиль кнопок
local function AddRoundedCorners(obj)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0.2, 0)
    corner.Parent = obj
end

AddRoundedCorners(MainFrame)
AddRoundedCorners(Title)
AddRoundedCorners(ToggleRespawnBtn)
AddRoundedCorners(ToggleTeleportBtn)
AddRoundedCorners(TeleportNowBtn)

-- Функция поиска кнопки респавна в интерфейсе
local function FindRespawnButton()
    local gui = Player.PlayerGui:FindFirstChild("ScreenGui") -- Имя GUI может отличаться!
    if gui then
        for _, v in pairs(gui:GetDescendants()) do
            if v:IsA("TextButton") and (v.Text:lower():find("respawn") or v.Text:lower():find("возродиться")) then
                return v
            end
        end
    end
    return nil
end

-- Клик по кнопке респавна (если не нашли - кликаем по координатам)
local function ClickRespawn()
    local button = FindRespawnButton()
    if button then
        button:Activate()
        print("[Delta] Найдена кнопка респавна, кликаем!")
    else
        -- Если кнопку не нашли - кликаем по стандартным координатам (правая часть экрана)
        local viewport = workspace.CurrentCamera.ViewportSize
        local clickX, clickY = viewport.X * 0.8, viewport.Y * 0.3
        UIS:SetMouseLocation(Vector2.new(clickX, clickY))
        task.wait(0.1)
        mouse1click()
        print("[Delta] Клик по координатам:", clickX, clickY)
    end
end

-- Телепорт к BlackVoiseOne (с проверкой расстояния)
local function TeleportToTarget()
    local target = game.Players:FindFirstChild(TARGET_PLAYER)
    if not target then
        warn("[Delta] Игрок " .. TARGET_PLAYER .. " не найден!")
        return
    end

    if target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
        local humanoid = Player.Character and Player.Character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            -- Если далеко - телепортируемся через MoveTo
            local distance = (target.Character.HumanoidRootPart.Position - Player.Character.HumanoidRootPart.Position).Magnitude
            if distance > 50 then
                Player.Character:MoveTo(target.Character.HumanoidRootPart.Position + Vector3.new(2, 0, 2))
                print("[Delta] Телепорт к " .. TARGET_PLAYER .. " (расстояние: " .. math.floor(distance) .. ")")
            else
                print("[Delta] Уже рядом с " .. TARGET_PLAYER)
            end
        end
    end
end

-- Обработчик смерти
local function OnDeath()
    if AUTO_RESPAWN then
        task.wait(RESPAWN_DELAY) -- Ждем появления экрана смерти
        ClickRespawn() -- Кликаем респавн

        if AUTO_TELEPORT then
            -- Ждем возрождения и телепортируемся
            Player.CharacterAdded:Wait()
            task.wait(1) -- Даем время на загрузку
            TeleportToTarget()
        end
    end
end

-- Подключаем обработчики
Player.CharacterAdded:Connect(function(character)
    local humanoid = character:WaitForChild("Humanoid")
    humanoid.Died:Connect(OnDeath)
end)

-- Кнопки интерфейса
ToggleRespawnBtn.MouseButton1Click:Connect(function()
    AUTO_RESPAWN = not AUTO_RESPAWN
    ToggleRespawnBtn.Text = "AUTO-RESPAWN: " .. (AUTO_RESPAWN and "ON" or "OFF")
    ToggleRespawnBtn.TextColor3 = AUTO_RESPAWN and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
end)

ToggleTeleportBtn.MouseButton1Click:Connect(function()
    AUTO_TELEPORT = not AUTO_TELEPORT
    ToggleTeleportBtn.Text = "TELEPORT: " .. (AUTO_TELEPORT and "ON" or "OFF")
    ToggleTeleportBtn.TextColor3 = AUTO_TELEPORT and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
end)

TeleportNowBtn.MouseButton1Click:Connect(function()
    if Player.Character then
        TeleportToTarget()
    else
        warn("[Delta] Нет персонажа!")
    end
end)

-- Если персонаж уже есть
if Player.Character then
    Player.Character:WaitForChild("Humanoid").Died:Connect(OnDeath)
end

print("[Delta] Скрипт активирован! Target: " .. TARGET_PLAYER)
