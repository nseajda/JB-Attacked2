-- Простой телепорт к игрокам с возможностью сворачивания
local Player = game:GetService("Players").LocalPlayer

-- Список игроков для телепорта
local TARGETS = {
    ["BlackVoiseOne"] = Color3.fromRGB(0, 0, 0),      -- Чёрный
    ["VasilekVasilek81037"] = Color3.fromRGB(0, 100, 255), -- Синий
    ["Balenciagi090999"] = Color3.fromRGB(255, 50, 150)  -- Розовый
}

-- Создаем интерфейс
local screenGui = Instance.new("ScreenGui")
screenGui.Parent = game:GetService("CoreGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 200, 0, 40) -- Начальный размер (только заголовок)
frame.Position = UDim2.new(0.8, 0, 0.5, -20)
frame.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
frame.Active = true
frame.Draggable = true
frame.Parent = screenGui

-- Добавляем скругление углов
local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 5)
corner.Parent = frame

-- Заголовок с кнопками управления
local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1, 0, 0, 30)
titleBar.Position = UDim2.new(0, 0, 0, 0)
titleBar.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
titleBar.Parent = frame

local title = Instance.new("TextLabel")
title.Text = "ТЕЛЕПОРТ К ИГРОКАМ"
title.Size = UDim2.new(0.6, 0, 1, 0)
title.Position = UDim2.new(0.05, 0, 0, 0)
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.BackgroundTransparency = 1
title.Font = Enum.Font.GothamBold
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = titleBar

-- Кнопка сворачивания
local minimizeBtn = Instance.new("TextButton")
minimizeBtn.Text = "_"
minimizeBtn.Size = UDim2.new(0, 25, 0, 25)
minimizeBtn.Position = UDim2.new(0.7, 0, 0.5, -12)
minimizeBtn.BackgroundColor3 = Color3.fromRGB(70, 70, 90)
minimizeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
minimizeBtn.Parent = titleBar

-- Кнопка закрытия
local closeBtn = Instance.new("TextButton")
closeBtn.Text = "X"
closeBtn.Size = UDim2.new(0, 25, 0, 25)
closeBtn.Position = UDim2.new(0.85, 0, 0.5, -12)
closeBtn.BackgroundColor3 = Color3.fromRGB(70, 70, 90)
closeBtn.TextColor3 = Color3.fromRGB(255, 150, 150)
closeBtn.Parent = titleBar

-- Контейнер для кнопок телепортации
local buttonsContainer = Instance.new("Frame")
buttonsContainer.Size = UDim2.new(1, 0, 0, 35 * #TARGETS)
buttonsContainer.Position = UDim2.new(0, 0, 0, 35)
buttonsContainer.BackgroundTransparency = 1
buttonsContainer.Visible = false -- Изначально скрыт
buttonsContainer.Parent = frame

-- Функция телепортации
local function teleportTo(playerName)
    for _, target in ipairs(game.Players:GetPlayers()) do
        if target.Name == playerName and target.Character then
            local hrp = target.Character:FindFirstChild("HumanoidRootPart")
            if hrp and Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") then
                Player.Character.HumanoidRootPart.CFrame = hrp.CFrame + Vector3.new(0, 3, 0)
                return true
            end
        end
    end
    return false
end

-- Создаем кнопки телепортации
local buttonY = 5
for name, color in pairs(TARGETS) do
    local button = Instance.new("TextButton")
    button.Text = "К "..name
    button.Size = UDim2.new(0.9, 0, 0, 30)
    button.Position = UDim2.new(0.05, 0, 0, buttonY)
    button.BackgroundColor3 = color
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.Parent = buttonsContainer
    
    -- Добавляем скругление кнопкам
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 5)
    btnCorner.Parent = button
    
    button.MouseButton1Click:Connect(function()
        if teleportTo(name) then
            button.Text = "Успешно!"
            task.wait(1)
            button.Text = "К "..name
        else
            button.Text = "Не найден!"
            task.wait(1)
            button.Text = "К "..name
        end
    end)
    
    buttonY = buttonY + 35
end

-- Обработчики кнопок управления
minimizeBtn.MouseButton1Click:Connect(function()
    buttonsContainer.Visible = not buttonsContainer.Visible
    frame.Size = UDim2.new(0, 200, 0, buttonsContainer.Visible and (40 + 35 * #TARGETS) or 40)
    minimizeBtn.Text = buttonsContainer.Visible and "_" or "+"
end)

closeBtn.MouseButton1Click:Connect(function()
    screenGui:Destroy()
end)

print("MultiPlayerTeleport loaded for: "..table.concat(table.keys(TARGETS), ", "))
