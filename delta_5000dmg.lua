-- Простой телепорт к игрокам
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
frame.Size = UDim2.new(0, 200, 0, 40 + 35 * #TARGETS)
frame.Position = UDim2.new(0.8, 0, 0.5, -frame.Size.Y.Offset/2)
frame.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
frame.Active = true
frame.Draggable = true
frame.Parent = screenGui

local title = Instance.new("TextLabel")
title.Text = "ТЕЛЕПОРТ К ИГРОКАМ"
title.Size = UDim2.new(1, 0, 0, 30)
title.Position = UDim2.new(0, 0, 0, 5)
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.BackgroundTransparency = 1
title.Font = Enum.Font.GothamBold
title.Parent = frame

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

-- Создаем кнопки
local buttonY = 35
for name, color in pairs(TARGETS) do
    local button = Instance.new("TextButton")
    button.Text = "К "..name
    button.Size = UDim2.new(0.9, 0, 0, 30)
    button.Position = UDim2.new(0.05, 0, 0, buttonY)
    button.BackgroundColor3 = color
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.Parent = frame
    
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

print("SimpleTeleport loaded for: "..table.concat(table.keys(TARGETS), ", "))
