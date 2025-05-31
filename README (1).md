--[[
  Скрипт для игры "Убийца против Шерифа"
  Автор: Aibek100
  Github: https://github.com/Aibek100
  Описание: Автоубийство + ESP + GUI
--]]

-- Подключаем библиотеку GUI (Kavo UI Library)
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
local Window = Library.CreateLib("XVision Duel AI by Aibek100", "Ocean")

-- Создаем вкладку и секцию
local Tab = Window:NewTab("Main")
local Section = Tab:NewSection("Auto Features")

-- Переменные состояния
getgenv().AutoKill = false
getgenv().ESPEnabled = false

-- Функция автоубийства
function autoKill()
    while getgenv().AutoKill do
        task.wait(0.1)
        for _, player in pairs(game.Players:GetPlayers()) do
            if player ~= game.Players.LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                local tool = game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChildOfClass("Tool")
                if tool and tool:FindFirstChild("Handle") then
                    tool:Activate()
                    local mouse = game.Players.LocalPlayer:GetMouse()
                    mouse.TargetFilter = player.Character
                    mouse.Hit = player.Character.HumanoidRootPart.CFrame
                end
            end
        end
    end
end

-- Включатель AutoKill
Section:NewToggle("Auto Kill", "Автоматически убивать врагов", function(state)
    getgenv().AutoKill = state
    if state then
        autoKill()
    end
end)

-- Функция создания ESP
function createESP(player)
    if player.Character and player.Character:FindFirstChild("Head") and not player.Character.Head:FindFirstChild("ESP") then
        local Billboard = Instance.new("BillboardGui", player.Character.Head)
        Billboard.Name = "ESP"
        Billboard.Size = UDim2.new(0, 100, 0, 40)
        Billboard.Adornee = player.Character.Head
        Billboard.AlwaysOnTop = true

        local Text = Instance.new("TextLabel", Billboard)
        Text.Size = UDim2.new(1, 0, 1, 0)
        Text.BackgroundTransparency = 1
        Text.Text = player.Name
        Text.TextColor3 = Color3.fromRGB(255, 0, 0)
        Text.TextStrokeTransparency = 0.5
        Text.TextScaled = true
    end
end

-- Включатель ESP
Section:NewToggle("ESP", "Показывает игроков", function(state)
    getgenv().ESPEnabled = state
    if state then
        for _, player in pairs(game.Players:GetPlayers()) do
            if player ~= game.Players.LocalPlayer then
                createESP(player)
            end
        end
    else
        for _, player in pairs(game.Players:GetPlayers()) do
            if player.Character and player.Character:FindFirstChild("Head") then
                local esp = player.Character.Head:FindFirstChild("ESP")
                if esp then
                    esp:Destroy()
                end
            end
        end
    end
end)

-- Автообновление ESP при появлении новых игроков
game.Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(function()
        if getgenv().ESPEnabled then
            wait(1)
            createESP(player)
        end
    end)
end)

-- Уведомление об успешной загрузке
game.StarterGui:SetCore("SendNotification", {
    Title = "XVision Loaded",
    Text = "GUI успешно загружено! Автор: Aibek100",
    Duration = 5
})
