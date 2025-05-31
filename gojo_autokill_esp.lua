-- 📦 GUI Library (Kavo UI)
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
local Window = Library.CreateLib("Gojo AutoKill & ESP", "Ocean")

-- 🟥 Главная вкладка
local Tab = Window:NewTab("Main")
local Section = Tab:NewSection("Features")

-- ⚙️ Переменные
getgenv().AutoKill = false
getgenv().ESPEnabled = false
getgenv().GodMode = false

-- 🔫 AutoKill Logic
function AutoKillEnemies()
    while getgenv().AutoKill do
        task.wait(0.1)
        for _, enemy in pairs(game.Players:GetPlayers()) do
            if enemy ~= game.Players.LocalPlayer and enemy.Character and enemy.Character:FindFirstChild("HumanoidRootPart") then
                local tool = game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChildOfClass("Tool")
                if tool then
                    tool:Activate()
                    enemy.Character:BreakJoints()
                end
            end
        end
    end
end

-- 👁️ ESP функция
function CreateESP(player)
    if player.Character and player.Character:FindFirstChild("Head") and not player.Character.Head:FindFirstChild("ESP") then
        local bill = Instance.new("BillboardGui", player.Character.Head)
        bill.Name = "ESP"
        bill.Size = UDim2.new(0, 100, 0, 40)
        bill.Adornee = player.Character.Head
        bill.AlwaysOnTop = true

        local text = Instance.new("TextLabel", bill)
        text.Size = UDim2.new(1, 0, 1, 0)
        text.BackgroundTransparency = 1
        text.Text = player.Name
        text.TextColor3 = Color3.fromRGB(0, 255, 255)
        text.TextStrokeTransparency = 0.2
    end
end

-- ☠️ Gojo Mode: God, Teleport, Aura
function StartGojoMode()
    local plr = game.Players.LocalPlayer
    local char = plr.Character or plr.CharacterAdded:Wait()
    local humanoid = char:FindFirstChild("Humanoid")
    local rootPart = char:FindFirstChild("HumanoidRootPart")

    while getgenv().GodMode do
        if humanoid then
            humanoid.MaxHealth = math.huge
            humanoid.Health = math.huge
        end
        for _, target in pairs(game.Players:GetPlayers()) do
            if target ~= plr and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
                local dist = (target.Character.HumanoidRootPart.Position - rootPart.Position).Magnitude
                if dist < 60 then
                    rootPart.CFrame = target.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, -3)
                end
            end
        end
        task.wait(1)
    end
end

-- ✅ Включатели
Section:NewToggle("AutoKill", "Автоматически убивает врагов", function(v)
    getgenv().AutoKill = v
    if v then
        AutoKillEnemies()
    end
end)

Section:NewToggle("ESP", "Показывает игроков", function(v)
    getgenv().ESPEnabled = v
    if v then
        for _, plr in pairs(game.Players:GetPlayers()) do
            if plr ~= game.Players.LocalPlayer then
                CreateESP(plr)
            end
        end
    else
        for _, plr in pairs(game.Players:GetPlayers()) do
            if plr.Character and plr.Character:FindFirstChild("Head") then
                local esp = plr.Character.Head:FindFirstChild("ESP")
                if esp then esp:Destroy() end
            end
        end
    end
end)

Section:NewToggle("Gojo AI Mode", "Бессмертие и телепорт к врагу", function(v)
    getgenv().GodMode = v
    if v then
        StartGojoMode()
    end
end)

-- 🔄 Авто-ESP при новых игроках
game.Players.PlayerAdded:Connect(function(plr)
    plr.CharacterAdded:Connect(function()
        if getgenv().ESPEnabled then
            wait(1)
            CreateESP(plr)
        end
    end)
end)

-- 🔔 Уведомление
game.StarterGui:SetCore("SendNotification", {
    Title = "✅ Loaded",
    Text = "Gojo GUI скрипт активирован!",
    Duration = 5
})
