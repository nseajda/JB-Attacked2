-- Минималистичный GUI для Delta Roblox Jurassic Blocky
local Player = game:GetService("Players").LocalPlayer
local CoreGui = game:GetService("CoreGui")

-- Создаем интерфейс
local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local ToggleBtn = Instance.new("TextButton")

ScreenGui.Name = "CompactDamageGUI"
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

-- Кнопка включения/выключения
ToggleBtn.Name = "ToggleBtn"
ToggleBtn.Parent = MainFrame
ToggleBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
ToggleBtn.Size = UDim2.new(0.9, 0, 0.8, 0)
ToggleBtn.Position = UDim2.new(0.05, 0, 0.1, 0)
ToggleBtn.Text = "ВЫКЛ"
ToggleBtn.TextColor3 = Color3.fromRGB(255, 100, 100)
ToggleBtn.TextSize = 14
ToggleBtn.Font = Enum.Font.SourceSansBold

-- Логика скрипта
local isActive = false

local function dealDamage(target)
    if target and target:FindFirstChild("Humanoid") then
        target.Humanoid:TakeDamage(5000)
    end
end

local function onAttack()
    if not Player.Character then return end
    
    local root = Player.Character:FindFirstChild("HumanoidRootPart")
    if not root then return end

    for _, v in ipairs(game:GetService("Players"):GetPlayers()) do
        if v ~= Player and v.Character then
            local target = v.Character:FindFirstChild("HumanoidRootPart")
            if target and (root.Position - target.Position).Magnitude <= 20 then
                dealDamage(v.Character)
            end
        end
    end
end

ToggleBtn.MouseButton1Click:Connect(function()
    isActive = not isActive
    
    if isActive then
        ToggleBtn.Text = "ВКЛ"
        ToggleBtn.TextColor3 = Color3.fromRGB(100, 255, 100)
        ToggleBtn.BackgroundColor3 = Color3.fromRGB(80, 80, 100)
        
        while isActive do
            onAttack()
            task.wait(0.2)
        end
    else
        ToggleBtn.Text = "ВЫКЛ"
        ToggleBtn.TextColor3 = Color3.fromRGB(255, 100, 100)
        ToggleBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
    end
end)

-- Закрытие при нажатии ESC
game:GetService("UserInputService").InputBegan:Connect(function(input, gameProcessed)
    if input.KeyCode == Enum.KeyCode.Escape then
        ScreenGui:Destroy()
    end
end)

print("Compact Damage GUI loaded!")
