local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local UIS = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")

-- Создаем интерфейс
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "PlayerTeleporterUI"
ScreenGui.Parent = CoreGui

local MainWindow = Instance.new("Frame")
MainWindow.Name = "MainWindow"
MainWindow.Parent = ScreenGui
MainWindow.Size = UDim2.new(0, 300, 0, 150)
MainWindow.Position = UDim2.new(0.7, 0, 0.5, -75)
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
Title.Text = "PLAYER TELEPORTER"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.GothamBold

local CloseBtn = Instance.new("TextButton")
CloseBtn.Name = "CloseBtn"
CloseBtn.Parent = TitleBar
CloseBtn.Size = UDim2.new(0, 25, 0, 25)
CloseBtn.Position = UDim2.new(0.9, 0, 0, 0)
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

-- Поле ввода
local PlayerNameInput = Instance.new("TextBox")
PlayerNameInput.Name = "PlayerNameInput"
PlayerNameInput.Parent = Content
PlayerNameInput.Size = UDim2.new(0.9, 0, 0, 30)
PlayerNameInput.Position = UDim2.new(0.05, 0, 0.1, 0)
PlayerNameInput.PlaceholderText = "Введите ник игрока"
PlayerNameInput.Text = ""
PlayerNameInput.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
PlayerNameInput.TextColor3 = Color3.fromRGB(255, 255, 255)
PlayerNameInput.ClearTextOnFocus = false

-- Кнопка добавления
local AddButton = Instance.new("TextButton")
AddButton.Name = "AddButton"
AddButton.Parent = Content
AddButton.Size = UDim2.new(0.9, 0, 0, 30)
AddButton.Position = UDim2.new(0.05, 0, 0.4, 0)
AddButton.Text = "Добавить кнопку телепортации"
AddButton.TextColor3 = Color3.fromRGB(255, 255, 255)
AddButton.BackgroundColor3 = Color3.fromRGB(70, 120, 70)

-- Кнопка для BlackVoiseOne
local BlackVoiseButton = Instance.new("TextButton")
BlackVoiseButton.Name = "BlackVoiseButton"
BlackVoiseButton.Parent = Content
BlackVoiseButton.Size = UDim2.new(0.9, 0, 0, 30)
BlackVoiseButton.Position = UDim2.new(0.05, 0, 0.7, 0)
BlackVoiseButton.Text = "Телепорт к @BlackVoiseOne"
BlackVoiseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
BlackVoiseButton.BackgroundColor3 = Color3.fromRGB(80, 80, 120)

-- Список созданных кнопок
local createdButtons = {}

-- Стилизация
local function applyStyles()
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0.1, 0)
    corner.Parent = MainWindow
    
    local elements = {PlayerNameInput, AddButton, BlackVoiseButton, CloseBtn}
    
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
local function teleportToPlayer(playerName)
    local targetPlayer = nil
    
    -- Ищем игрока среди онлайн
    for _, player in ipairs(Players:GetPlayers()) do
        if string.lower(player.Name) == string.lower(playerName) or 
           string.lower(player.DisplayName) == string.lower(playerName) then
            targetPlayer = player
            break
        end
    end
    
    if not targetPlayer then
        warn("Игрок " .. playerName .. " не найден в игре!")
        return
    end
    
    local character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
    
    local targetCharacter = targetPlayer.Character
    if not targetCharacter then
        warn("У игрока " .. playerName .. " нет персонажа!")
        return
    end
    
    local targetRootPart = targetCharacter:FindFirstChild("HumanoidRootPart")
    if not targetRootPart then
        warn("Не удалось найти HumanoidRootPart у игрока " .. playerName)
        return
    end
    
    -- Плавная телепортация
    local tweenInfo = TweenInfo.new(
        0.5, -- Время
        Enum.EasingStyle.Quad, -- Стиль
        Enum.EasingDirection.Out, -- Направление
        0, -- Повторения
        false, -- Обратно
        0 -- Задержка
    )
    
    local tween = TweenService:Create(
        humanoidRootPart,
        tweenInfo,
        {CFrame = targetRootPart.CFrame * CFrame.new(0, 0, 3)}
    )
    
    tween:Play()
    print("Телепортация к " .. playerName .. " выполнена!")
end

-- Функция создания новой кнопки
local function createTeleportButton(playerName)
    -- Проверяем, есть ли уже кнопка для этого игрока
    for _, buttonInfo in pairs(createdButtons) do
        if buttonInfo.playerName == playerName then
            warn("Кнопка для игрока " .. playerName .. " уже существует!")
            return
        end
    end
    
    -- Создаем новую кнопку
    local newButton = Instance.new("TextButton")
    newButton.Name = "TeleportTo_" .. playerName
    newButton.Parent = Content
    newButton.Size = UDim2.new(0.9, 0, 0, 30)
    newButton.Text = "Телепорт к " .. playerName
    newButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    newButton.BackgroundColor3 = Color3.fromRGB(80, 80, 150)
    
    -- Кнопка удаления
    local deleteButton = Instance.new("TextButton")
    deleteButton.Name = "DeleteButton"
    deleteButton.Parent = newButton
    deleteButton.Size = UDim2.new(0.2, 0, 1, 0)
    deleteButton.Position = UDim2.new(0.8, 0, 0, 0)
    deleteButton.Text = "X"
    deleteButton.TextColor3 = Color3.fromRGB(255, 150, 150)
    deleteButton.BackgroundColor3 = Color3.fromRGB(100, 60, 60)
    
    -- Применяем стили
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0.3, 0)
    corner.Parent = newButton
    
    local deleteCorner = Instance.new("UICorner")
    deleteCorner.CornerRadius = UDim.new(0.3, 0)
    deleteCorner.Parent = deleteButton
    
    -- Сохраняем информацию о кнопке
    local buttonInfo = {
        button = newButton,
        deleteButton = deleteButton,
        playerName = playerName
    }
    table.insert(createdButtons, buttonInfo)
    
    -- Обработчики событий
    newButton.MouseButton1Click:Connect(function()
        teleportToPlayer(playerName)
    end)
    
    deleteButton.MouseButton1Click:Connect(function()
        newButton:Destroy()
        for i, info in ipairs(createdButtons) do
            if info.button == newButton then
                table.remove(createdButtons, i)
                break
            end
        end
        updateButtonPositions()
    end)
    
    -- Обновляем позиции всех кнопок
    updateButtonPositions()
end

-- Функция обновления позиций кнопок
local function updateButtonPositions()
    local startY = 0.7
    local buttonHeight = 0.3
    local spacing = 0.05
    
    -- Позиция кнопки BlackVoiseOne
    BlackVoiseButton.Position = UDim2.new(0.05, 0, startY, 0)
    startY = startY + buttonHeight + spacing
    
    -- Позиции созданных кнопок
    for i, buttonInfo in ipairs(createdButtons) do
        buttonInfo.button.Position = UDim2.new(0.05, 0, startY, 0)
        startY = startY + buttonHeight + spacing
    end
    
    -- Обновляем размер окна
    local totalHeight = 25 + 70 + (startY * 100) -- 25 - заголовок, 70 - фиксированные элементы
    MainWindow.Size = UDim2.new(0, 300, 0, math.max(150, totalHeight))
end

-- Обработчики событий
AddButton.MouseButton1Click:Connect(function()
    local playerName = PlayerNameInput.Text
    if playerName and playerName ~= "" then
        createTeleportButton(playerName)
        PlayerNameInput.Text = ""
    else
        warn("Введите ник игрока!")
    end
end)

BlackVoiseButton.MouseButton1Click:Connect(function()
    teleportToPlayer("BlackVoiseOne")
end)

CloseBtn.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

PlayerNameInput.FocusLost:Connect(function(enterPressed)
    if enterPressed then
        AddButton:Activate()
    end
end)

print("Player Teleporter loaded! Use the UI to teleport to players.")
