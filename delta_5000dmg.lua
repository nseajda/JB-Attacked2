local Player = game:GetService("Players").LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()

-- Увеличение урона динозавра
local function boostDinosaur()
    while true do
        task.wait(0.1)
        if Character and Character:FindFirstChild("Humanoid") then
            -- Увеличение базового урона
            local humanoid = Character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                humanoid:SetAttribute("DamageMultiplier", 100) -- 100x урон
            end
            
            -- Модификация оружия (если есть)
            for _, tool in ipairs(Character:GetChildren()) do
                if tool:IsA("Tool") then
                    local damageValue = tool:FindFirstChild("Damage") or Instance.new("IntValue", tool)
                    damageValue.Name = "Damage"
                    damageValue.Value = 5000
                end
            end
        end
    end
end

-- GUI для управления
local ScreenGui = Instance.new("ScreenGui", game:GetService("CoreGui"))
local Frame = Instance.new("Frame", ScreenGui)
Frame.Size = UDim2.new(0, 150, 0, 50)
Frame.Position = UDim2.new(0.8, 0, 0.8, 0)
Frame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)

local TextLabel = Instance.new("TextLabel", Frame)
TextLabel.Size = UDim2.new(1, 0, 0.5, 0)
TextLabel.Text = "DINO BOOST: ON"
TextLabel.TextColor3 = Color3.fromRGB(0, 255, 0)

-- Запуск усиления
boostDinosaur()
