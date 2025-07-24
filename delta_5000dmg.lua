-- DELTA PC ULTIMATE (Кнопочная версия)
local Player = game:GetService("Players").LocalPlayer
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

-- Настройки
local ULTRA_MULTIPLIER = 100
local SPEED_OPTIONS = {1, 2, 5, 10}
local HITBOX_OPTIONS = {1, 2, 5, 10, 15, 20}

-- Создаем интерфейс
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = game:GetService("CoreGui")

local MainWindow = Instance.new("Frame")
MainWindow.Name = "DeltaWindow"
MainWindow.Parent = ScreenGui
MainWindow.Size = UDim2.new(0, 300, 0, 400)
MainWindow.Position = UDim2.new(0.7, 0, 0.5, -200)
MainWindow.BackgroundColor3 = Color3.fromRGB(35, 35, 50)
MainWindow.Active = true
MainWindow.Draggable = true

-- Заголовок
local TitleBar = Instance.new("Frame")
TitleBar.Name = "TitleBar"
TitleBar.Parent = MainWindow
TitleBar.Size = UDim2.new(1, 0, 0, 30)
TitleBar.BackgroundColor3 = Color3.fromRGB(50, 50, 70)

local Title = Instance.new("TextLabel")
Title.Name = "Title"
Title.Parent = TitleBar
Title.Size = UDim2.new(0.7, 0, 1, 0)
Title.Text = "DELTA PC ULTIMATE"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.GothamBold

local MinimizeBtn = Instance.new("TextButton")
MinimizeBtn.Name = "MinimizeBtn"
MinimizeBtn.Parent = TitleBar
MinimizeBtn.Size = UDim2.new(0, 30, 0, 30)
MinimizeBtn.Position = UDim2.new(0.7, 0, 0, 0)
MinimizeBtn.Text = "_"
MinimizeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
MinimizeBtn.BackgroundColor3 = Color3.fromRGB(70, 70, 90)

local CloseBtn = Instance.new("TextButton")
CloseBtn.Name = "CloseBtn"
CloseBtn.Parent = TitleBar
CloseBtn.Size = UDim2.new(0, 30, 0, 30)
CloseBtn.Position = UDim2.new(0.85, 0, 0, 0)
CloseBtn.Text = "X"
CloseBtn.TextColor3 = Color3.fromRGB(255, 150, 150)
CloseBtn.BackgroundColor3 = Color3.fromRGB(70, 70, 90)

-- Основное содержимое
local Content = Instance.new("Frame")
Content.Name = "Content"
Content.Parent = MainWindow
Content.Size = UDim2.new(1, 0, 1, -30)
Content.Position = UDim2.new(0, 0, 0, 30)
Content.BackgroundTransparency = 1

-- Кнопки режимов
local ToggleBtn = createButton("ULTRA MODE: OFF", Color3.fromRGB(255,120,120), UDim2.new(0.9,0,0,35), UDim2.new(0.05,0,0.02,0))
ToggleBtn.Parent = Content

local GodModeBtn = createButton("GOD MODE: OFF", Color3.fromRGB(120,120,255), UDim2.new(0.9,0,0,35), UDim2.new(0.05,0,0.1,0))
GodModeBtn.Parent = Content

local ShowHitboxesBtn = createButton("SHOW HITBOXES: OFF", Color3.fromRGB(120,255,120), UDim2.new(0.9,0,0,35), UDim2.new(0.05,0,0.18,0))
ShowHitboxesBtn.Parent = Content

-- Скорость персонажа
local SpeedLabel = createLabel("Скорость персонажа:", UDim2.new(0.9,0,0,20), UDim2.new(0.05,0,0.26,0))
SpeedLabel.Parent = Content

local SpeedButtons = {}
for i,speed in ipairs(SPEED_OPTIONS) do
    local btn = createButton(speed.."x", Color3.fromRGB(100,150,255), UDim2.new(0.27,0,0,30), UDim2.new(0.05+(i-1)*0.3,0,0.32,0))
    btn.Parent = Content
    table.insert(SpeedButtons, btn)
end

-- Хитбоксы врагов
local HitboxLabel = createLabel("Хитбоксы врагов:", UDim2.new(0.9,0,0,20), UDim2.new(0.05,0,0.4,0))
HitboxLabel.Parent = Content

local HitboxButtons = {}
for i,size in ipairs(HITBOX_OPTIONS) do
    local btn = createButton(size.."x", Color3.fromRGB(255,100,100), UDim2.new(0.16,0,0,30), UDim2.new(0.05+(i-1)*0.18,0,0.46,0))
    btn.Parent = Content
    table.insert(HitboxButtons, btn)
end

-- Стилизация
applyStyles(MainWindow, {ToggleBtn, GodModeBtn, ShowHitboxesBtn, MinimizeBtn, CloseBtn, unpack(SpeedButtons), unpack(HitboxButtons)})

-- Логика работы
local ultraActive = false
local godModeActive = false
local showHitboxesActive = false
local currentSpeed = 1
local currentHitboxSize = 1

-- Обработчики событий
ToggleBtn.MouseButton1Click:Connect(function()
    ultraActive = not ultraActive
    ToggleBtn.Text = "ULTRA MODE: "..(ultraActive and "ON" or "OFF")
    ToggleBtn.TextColor3 = ultraActive and Color3.fromRGB(120,255,120) or Color3.fromRGB(255,120,120)
end)

GodModeBtn.MouseButton1Click:Connect(function()
    godModeActive = not godModeActive
    GodModeBtn.Text = "GOD MODE: "..(godModeActive and "ON" or "OFF")
    GodModeBtn.TextColor3 = godModeActive and Color3.fromRGB(220,220,255) or Color3.fromRGB(120,120,255)
end)

ShowHitboxesBtn.MouseButton1Click:Connect(function()
    showHitboxesActive = not showHitboxesActive
    ShowHitboxesBtn.Text = "SHOW HITBOXES: "..(showHitboxesActive and "ON" or "OFF")
    ShowHitboxesBtn.TextColor3 = showHitboxesActive and Color3.fromRGB(220,255,220) or Color3.fromRGB(120,255,120)
end)

for i,btn in ipairs(SpeedButtons) do
    btn.MouseButton1Click:Connect(function()
        currentSpeed = SPEED_OPTIONS[i]
        updateButtonSelection(SpeedButtons, i, Color3.fromRGB(100,150,255))
    end)
end

for i,btn in ipairs(HitboxButtons) do
    btn.MouseButton1Click:Connect(function()
        currentHitboxSize = HITBOX_OPTIONS[i]
        updateButtonSelection(HitboxButtons, i, Color3.fromRGB(255,100,100))
    end)
end

MinimizeBtn.MouseButton1Click:Connect(function()
    Content.Visible = not Content.Visible
    MainWindow.Size = UDim2.new(0, 300, 0, Content.Visible and 400 or 30)
    MinimizeBtn.Text = Content.Visible and "_" or "+"
end)

CloseBtn.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

-- Вспомогательные функции
function createButton(text, color, size, position)
    local btn = Instance.new("TextButton")
    btn.Text = text
    btn.TextColor3 = color
    btn.Size = size
    btn.Position = position
    btn.BackgroundColor3 = Color3.fromRGB(60,60,80)
    btn.TextSize = 14
    btn.Font = Enum.Font.Gotham
    return btn
end

function createLabel(text, size, position)
    local label = Instance.new("TextLabel")
    label.Text = text
    label.TextColor3 = Color3.fromRGB(200,200,255)
    label.Size = size
    label.Position = position
    label.BackgroundTransparency = 1
    label.TextSize = 14
    label.Font = Enum.Font.Gotham
    label.TextXAlignment = Enum.TextXAlignment.Left
    return label
end

function applyStyles(mainWindow, elements)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0.2, 0)
    corner.Parent = mainWindow
    
    for _, element in pairs(elements) do
        local elementCorner = Instance.new("UICorner")
        elementCorner.CornerRadius = UDim.new(0.3, 0)
        elementCorner.Parent = element
        
        local stroke = Instance.new("UIStroke")
        stroke.Color = Color3.fromRGB(100,100,140)
        stroke.Thickness = 1
        stroke.Parent = element
    end
end

function updateButtonSelection(buttons, selectedIndex, selectedColor)
    for i,btn in ipairs(buttons) do
        if i == selectedIndex then
            btn.BackgroundColor3 = selectedColor
            btn.TextColor3 = Color3.fromRGB(255,255,255)
        else
            btn.BackgroundColor3 = Color3.fromRGB(60,60,80)
            btn.TextColor3 = selectedColor
        end
    end
end

-- Инициализация
updateButtonSelection(SpeedButtons, 1, Color3.fromRGB(100,150,255))
updateButtonSelection(HitboxButtons, 1, Color3.fromRGB(255,100,100))
print("Delta PC Ultimate loaded!")
