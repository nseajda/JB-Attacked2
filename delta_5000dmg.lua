-- Delta Roblox Jurassic Blocky - 5000 Damage GUI
-- Автор: YourName (адаптация под GUI)

local Player = game:GetService("Players").LocalPlayer
local UIS = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")

-- Создаем интерфейс
local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local ToggleButton = Instance.new("TextButton")
local ExpandButton = Instance.new("TextButton")
local Title = Instance.new("TextLabel")
local StatusLabel = Instance.new("TextLabel")
local ToggleScript = Instance.new("TextButton")

ScreenGui.Parent = CoreGui
ScreenGui.Name = "Delta5000DMG"

-- Основной фрейм (развернутый вид)
MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
MainFrame.BorderSizePixel = 0
MainFrame.Position = UDim2.new(0.8, 0, 0.5, 0)
MainFrame.Size = UDim2.new(0, 200, 0, 150)
MainFrame.Visible = false
MainFrame.Active = true
MainFrame.Draggable = true

-- Кнопка свернуть/развернуть (круглая мини-версия)
ExpandButton.Name = "ExpandButton"
ExpandButton.Parent = ScreenGui
ExpandButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
ExpandButton.Size = UDim2.new(0, 30, 0, 30)
ExpandButton.Position = UDim2.new(0.95, 0, 0.9, 0)
ExpandButton.Text = "⚡"
ExpandButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ExpandButton.TextSize = 16
ExpandButton.Font = Enum.Font.SourceSansBold
ExpandButton.BorderSizePixel = 0

-- Заголовок
Title.Name = "Title"
Title.Parent = MainFrame
Title.Text = "Delta 5000 DMG"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Position = UDim2.new(0, 10, 0, 10)
Title.Size = UDim2.new(0, 180, 0, 20)
Title.Font = Enum.Font.SourceSansBold

-- Статус
StatusLabel.Name = "StatusLabel"
StatusLabel.Parent = MainFrame
StatusLabel.Text = "❌ Выключен"
StatusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
StatusLabel.Position = UDim2.new(0, 10, 0, 40)
StatusLabel.Size = UDim2.new(0, 180, 0, 20)

-- Кнопка включения
ToggleScript.Name = "ToggleScript"
ToggleScript.Parent = MainFrame
ToggleScript.Text = "Включить"
ToggleScript.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleScript.Position = UDim2.new(0.1, 0, 0.6, 0)
ToggleScript.Size = UDim2.new(0, 160, 0, 40)
ToggleScript.BackgroundColor3 = Color3.fromRGB(80, 80, 120)

-- Логика сворачивания/разворачивания
local isExpanded = false

ExpandButton.MouseButton1Click:Connect(function()
    isExpanded = not isExpanded
    MainFrame.Visible = isExpanded
    ExpandButton.Text = isExpanded and "×" or "⚡"
end)

-- Логика скрипта
local isActive = false

local function dealDamage(target)
    if not target or not target:FindFirstChild("Humanoid") then return end
    target.Humanoid:TakeDamage(5000)
end

local function onAttack()
    if not Player.Character then return end
    local root = Player.Character:FindFirstChild("HumanoidRootPart")
    if not root then return end

    for _, v in ipairs(game.Players:GetPlayers()) do
        if v ~= Player and v.Character then
            local target = v.Character:FindFirstChild("HumanoidRootPart")
            if target and (root.Position - target.Position).Magnitude <= 20 then
                dealDamage(v.Character)
            end
        end
    end
end

ToggleScript.MouseButton1Click:Connect(function()
    isActive = not isActive
    StatusLabel.Text = isActive and "✅ Включен" or "❌ Выключен"
    ToggleScript.Text = isActive and "Выключить" : "Включить"
    ToggleScript.BackgroundColor3 = isActive and Color3.fromRGB(120, 50, 50) or Color3.fromRGB(80, 80, 120)

    while isActive do
        onAttack()
        task.wait(0.2)
    end
end)
