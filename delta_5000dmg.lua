local Player = game:GetService("Players").LocalPlayer
local UIS = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")

-- Настройки
local AUTO_RESPAWN = true
local AUTO_TELEPORT = true
local TARGET_PLAYER = "BlackVoiseOne"
local RESPAWN_DELAY = 15 -- 15 секунд задержки
local RESPAWN_BUTTON_POS = {x = 0.8, y = 0.35} -- Позиция кнопки респавна

-- Интерфейс
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "DeltaUltimateRespawn"
ScreenGui.Parent = CoreGui

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 300, 0, 200)
MainFrame.Position = UDim2.new(0.7, 0, 0.5, -100)
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

-- Заголовок
local TitleBar = Instance.new("Frame")
TitleBar.Size = UDim2.new(1, 0, 0, 30)
TitleBar.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
TitleBar.Parent = MainFrame

local Title = Instance.new("TextLabel")
Title.Text = "DELTA RESPAWN v3.0"
Title.Size = UDim2.new(0.7, 0, 1, 0)
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.GothamBold
Title.BackgroundTransparency = 1
Title.Parent = TitleBar

-- Кнопки управления
local MinimizeBtn = Instance.new("TextButton")
MinimizeBtn.Text = "_"
MinimizeBtn.Size = UDim2.new(0, 30, 0, 30)
MinimizeBtn.Position = UDim2.new(0.7, 0, 0, 0)
MinimizeBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
MinimizeBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
MinimizeBtn.Parent = TitleBar

local CloseBtn = Instance.new("TextButton")
CloseBtn.Text = "X"
CloseBtn.Size = UDim2.new(0, 30, 0, 30)
CloseBtn.Position = UDim2.new(0.85, 0, 0, 0)
CloseBtn.TextColor3 = Color3.fromRGB(255, 100, 100)
CloseBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
CloseBtn.Parent = TitleBar

-- Основные кнопки
local ContentFrame = Instance.new("Frame")
ContentFrame.Size = UDim2.new(1, 0, 1, -30)
ContentFrame.Position = UDim2.new(0, 0, 0, 30)
ContentFrame.BackgroundTransparency = 1
ContentFrame.Parent = MainFrame

local ToggleRespawnBtn = Instance.new("TextButton")
ToggleRespawnBtn.Text = "AUTO-RESPAWN: " .. (AUTO_RESPAWN and "ON" or "OFF")
ToggleRespawnBtn.Size = UDim2.new(0.9, 0, 0, 40)
ToggleRespawnBtn.Position = UDim2.new(0.05, 0, 0.1, 0)
ToggleRespawnBtn.TextColor3 = AUTO_RESPAWN and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
ToggleRespawnBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
ToggleRespawnBtn.Parent = ContentFrame

local ToggleTeleportBtn = Instance.new("TextButton")
ToggleTeleportBtn.Text = "AUTO-TELEPORT: " .. (AUTO_TELEPORT and "ON" or "OFF")
ToggleTeleportBtn.Size = UDim2.new(0.9, 0, 0, 40)
ToggleTeleportBtn.Position = UDim2.new(0.05, 0, 0.35, 0)
ToggleTeleportBtn.TextColor3 = AUTO_TELEPORT and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
ToggleTeleportBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
ToggleTeleportBtn.Parent = ContentFrame

local TeleportNowBtn = Instance.new("TextButton")
TeleportNowBtn.Text = "TELEPORT NOW"
TeleportNowBtn.Size = UDim2.new(0.9, 0, 0, 40)
TeleportNowBtn.Position = UDim2.new(0.05, 0, 0.6, 0)
TeleportNowBtn.TextColor3 = Color3.fromRGB(255, 255, 0)
TeleportNowBtn.BackgroundColor3 = Color3.fromRGB(70, 50, 90)
TeleportNowBtn.Parent = ContentFrame

-- Стилизация
local function AddRoundedCorners(obj)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0.2, 0)
    corner.Parent = obj
end

AddRoundedCorners(MainFrame)
AddRoundedCorners(TitleBar)
AddRoundedCorners(ToggleRespawnBtn)
AddRoundedCorners(ToggleTeleportBtn)
AddRoundedCorners(TeleportNowBtn)
AddRoundedCorners(MinimizeBtn)
AddRoundedCorners(CloseBtn)

-- Проверка смерти по HP
local function CheckDeath(humanoid)
    humanoid:GetPropertyChangedSignal("Health"):Connect(function()
        if humanoid.Health <= 0 and AUTO_RESPAWN then
            print("[Delta] Персонаж умер! Ждем " .. RESPAWN_DELAY .. " сек...")
            task.wait(RESPAWN_DELAY)
            
            -- Клик респавна
            local viewport = workspace.CurrentCamera.ViewportSize
            UIS:SetMouseLocation(Vector2.new(
                viewport.X * RESPAWN_BUTTON_POS.x,
                viewport.Y * RESPAWN_BUTTON_POS.y
            ))
            task.wait(0.1)
            mouse1click()
            print("[Delta] Клик респавна выполнен")
            
            -- Телепорт после возрождения
            if AUTO_TELEPORT then
                Player.CharacterAdded:Wait()
                task.wait(2) -- Дополнительная задержка
                
                local target = game.Players:FindFirstChild(TARGET_PLAYER)
                if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
                    Player.Character:MoveTo(target.Character.HumanoidRootPart.Position + Vector3.new(3, 0, 3))
                    print("[Delta] Телепорт к " .. TARGET_PLAYER)
                end
            end
        end
    end)
end

-- Инициализация
Player.CharacterAdded:Connect(function(character)
    local humanoid = character:WaitForChild("Humanoid")
    CheckDeath(humanoid)
end)

if Player.Character then
    CheckDeath(Player.Character:WaitForChild("Humanoid"))
end

-- Управление окном
MinimizeBtn.MouseButton1Click:Connect(function()
    ContentFrame.Visible = not ContentFrame.Visible
    MainFrame.Size = UDim2.new(0, 300, 0, ContentFrame.Visible and 200 or 30)
    MinimizeBtn.Text = ContentFrame.Visible and "_" or "+"
end)

CloseBtn.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

-- Управление функциями
ToggleRespawnBtn.MouseButton1Click:Connect(function()
    AUTO_RESPAWN = not AUTO_RESPAWN
    ToggleRespawnBtn.Text = "AUTO-RESPAWN: " .. (AUTO_RESPAWN and "ON" or "OFF")
    ToggleRespawnBtn.TextColor3 = AUTO_RESPAWN and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
end)

ToggleTeleportBtn.MouseButton1Click:Connect(function()
    AUTO_TELEPORT = not AUTO_TELEPORT
    ToggleTeleportBtn.Text = "AUTO-TELEPORT: " .. (AUTO_TELEPORT and "ON" or "OFF")
    ToggleTeleportBtn.TextColor3 = AUTO_TELEPORT and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
end)

TeleportNowBtn.MouseButton1Click:Connect(function()
    if Player.Character then
        local target = game.Players:FindFirstChild(TARGET_PLAYER)
        if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
            Player.Character:MoveTo(target.Character.HumanoidRootPart.Position + Vector3.new(3, 0, 3))
            print("[Delta] Ручной телепорт к " .. TARGET_PLAYER)
        end
    end
end)

print("[Delta] Скрипт запущен! Target:", TARGET_PLAYER)
