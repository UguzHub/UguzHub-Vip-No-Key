-- =================================================================
-- UGUZHUB V2 PRO - FULL MM2 SCRIPT (RAYFIELD & CUSTOM AVATAR BG)
-- =================================================================
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local Workspace = game:GetService("Workspace")
local UserInputService = game:GetService("UserInputService")

-- Dil Sözlüğü
local Translations = {
    TR = {
        Title = "UguzHub V2 Pro | MM2",
        Greeting = "Bugün nasılsın, ",
        EspToggle = "Role ESP (Katil / Şerif / Masum)",
        AutoFarmToggle = "Oto Sikke Topla (Auto Farm)",
        SilentAimToggle = "Silent Aim (Rastgele Atış Hedefe Gider)",
        LockSheriff = "Katilken Şerife Kilitlen",
        LockMurderer = "Şerifken Katile Kilitlen",
        WalkSpeed = "Yürüme Hızı (WalkSpeed)",
        FlyToggle = "Uçma Modu (Fly)",
        FlingToggle = "Görünmez Fling (Visible Fling)",
        C4Item = "Şaka Bombası (C4) Ver",
        FreeEmotes = "Tüm Emoteleri Aç",
        SettingsLabel = "Oyuncu Profili"
    },
    EN = {
        Title = "UguzHub V2 Pro | MM2",
        Greeting = "How are you today, ",
        EspToggle = "Role ESP (Murderer / Sheriff / Innocent)",
        AutoFarmToggle = "Auto Farm Coins",
        SilentAimToggle = "Silent Aim (Auto Hit Target)",
        LockSheriff = "Lock to Sheriff (as Murderer)",
        LockMurderer = "Lock to Murderer (as Sheriff)",
        WalkSpeed = "WalkSpeed",
        FlyToggle = "Fly Mode",
        FlingToggle = "Invisible Fling",
        C4Item = "Get Prank Bomb (C4)",
        FreeEmotes = "Unlock All Emotes",
        SettingsLabel = "Player Profile"
    },
    RU = {
        Title = "UguzHub V2 Pro | MM2",
        Greeting = "Как ты сегодня, ",
        EspToggle = "ESP (Убийца / Шериф / Невинный)",
        AutoFarmToggle = "Авто-сбор монет",
        SilentAimToggle = "Silent Aim (Авто-попадание)",
        LockSheriff = "Захват Шерифа (за Убийцу)",
        LockMurderer = "Захват Убийцы (за Шерифа)",
        WalkSpeed = "Скорость ходьбы",
        FlyToggle = "Режим полета",
        FlingToggle = "Invisible Fling",
        C4Item = "Получить бомбу (C4)",
        FreeEmotes = "Разблокировать все эмоции",
        SettingsLabel = "Профиль игрока"
    }
}

local CurrentLang = Translations.TR

-- Durum Değişkenleri
local Flags = {
    ESP = false,
    AutoFarm = false,
    SilentAim = false,
    LockSheriff = false,
    LockMurderer = false,
    Fly = false,
    Fling = false,
    WalkSpeed = 16
}

-- =================================================================
-- 1. RAYFIELD PENCERESİ VE AVATAR ARKA PLANI
-- =================================================================
local Window = Rayfield:CreateWindow({
    Name = CurrentLang.Title,
    LoadingTitle = "UguzHub V2 Pro Yükleniyor...",
    LoadingSubtitle = "by Uguz",
    ConfigurationSaving = { Enabled = false },
    Discord = { Enabled = false },
    KeySystem = false
})

-- İlk fotoğraftaki gibi kullanıcının Roblox karakterini arka plana alma
task.spawn(function()
    task.wait(0.5)
    local coreGui = game:GetService("CoreGui")
    local rayfieldGui = coreGui:FindFirstChild("Rayfield") or coreGui:FindFirstChild("RayfieldGui")
    if rayfieldGui then
        local mainFrame = rayfieldGui:FindFirstChild("Main", true)
        if mainFrame then
            -- Karakter Görseli (Fotoğraftaki arka plan tarzı)
            local charBg = Instance.new("ImageLabel")
            charBg.Name = "UguzCharacterBG"
            charBg.Size = UDim2.new(1, 0, 1, 0)
            charBg.Position = UDim2.new(0, 0, 0, 0)
            charBg.BackgroundTransparency = 1
            charBg.ImageTransparency = 0.65 -- Yazıların net okunması için şeffaflık
            charBg.ScaleType = Enum.ScaleType.Fit
            charBg.ZIndex = 0
            
            pcall(function()
                charBg.Image = Players:GetUserThumbnailAsync(
                    LocalPlayer.UserId, 
                    Enum.ThumbnailType.AvatarBust, 
                    Enum.ThumbnailSize.Size420x420
                )
            end)
            
            charBg.Parent = mainFrame
        end
    end
end)

-- =================================================================
-- 2. MENÜ SEKMELERİ
-- =================================================================

-- MAIN TAB
local MainTab = Window:CreateTab("Main", 4483362458)
MainTab:CreateToggle({
    Name = CurrentLang.EspToggle,
    CurrentValue = false,
    Callback = function(v) Flags.ESP = v end,
})

-- AUTO FARM TAB
local FarmTab = Window:CreateTab("Auto Farm", 4483362458)
FarmTab:CreateToggle({
    Name = CurrentLang.AutoFarmToggle,
    CurrentValue = false,
    Callback = function(v) Flags.AutoFarm = v end,
})

-- COMBAT & AIM TAB
local CombatTab = Window:CreateTab("Combat & Aim", 4483362458)
CombatTab:CreateToggle({
    Name = CurrentLang.SilentAimToggle,
    CurrentValue = false,
    Callback = function(v) Flags.SilentAim = v end,
})
CombatTab:CreateToggle({
    Name = CurrentLang.LockSheriff,
    CurrentValue = false,
    Callback = function(v) Flags.LockSheriff = v end,
})
CombatTab:CreateToggle({
    Name = CurrentLang.LockMurderer,
    CurrentValue = false,
    Callback = function(v) Flags.LockMurderer = v end,
})

-- TROLL & MOVEMENT TAB
local TrollTab = Window:CreateTab("Troll & Speed", 4483362458)
TrollTab:CreateSlider({
    Name = CurrentLang.WalkSpeed,
    Range = {16, 200},
    Increment = 1,
    CurrentValue = 16,
    Callback = function(v)
        Flags.WalkSpeed = v
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            LocalPlayer.Character.Humanoid.WalkSpeed = v
        end
    end,
})
TrollTab:CreateToggle({
    Name = CurrentLang.FlyToggle,
    CurrentValue = false,
    Callback = function(v) Flags.Fly = v end,
})
TrollTab:CreateToggle({
    Name = CurrentLang.FlingToggle,
    CurrentValue = false,
    Callback = function(v) Flags.Fling = v end,
})

-- EXTRA TAB (C4 & EMOTES)
local ExtraTab = Window:CreateTab("Emotes & Items", 4483362458)
ExtraTab:CreateButton({
    Name = CurrentLang.C4Item,
    Callback = function()
        pcall(function()
            local c4 = Instance.new("Tool")
            c4.Name = "Şaka Bombası (C4)"
            c4.RequiresHandle = true
            local handle = Instance.new("Part", c4)
            handle.Name = "Handle"
            handle.Size = Vector3.new(1, 1, 1)
            c4.Parent = LocalPlayer.Backpack
        end)
        Rayfield:Notify({Title = "UguzHub", Content = "C4 Envanterinize Eklendi!", Duration = 3})
    end,
})
ExtraTab:CreateButton({
    Name = CurrentLang.FreeEmotes,
    Callback = function()
        pcall(function()
            local emoteModule = require(game:GetService("ReplicatedStorage").Modules.EmoteModule)
            if emoteModule and emoteModule.Emotes then
                for emoteName, _ in pairs(emoteModule.Emotes) do
                    emoteModule.Emotes[emoteName].Unlocked = true
                end
            end
        end)
        Rayfield:Notify({Title = "UguzHub", Content = "Tüm Emoteler Kullanıma Açıldı!", Duration = 3})
    end,
})

-- SETTINGS TAB (PROFİL VEYA BİLGİLER)
local SettingsTab = Window:CreateTab("Settings", 4483362458)
SettingsTab:CreateLabel("👤 " .. CurrentLang.SettingsLabel .. ": " .. LocalPlayer.Name)
SettingsTab:CreateLabel("✨ " .. CurrentLang.Greeting .. LocalPlayer.DisplayName .. "! 👋")

-- =================================================================
-- 3. HATASIZ ÇALIŞAN ARKA PLAN MOTORLARI (CORE LOGIC)
-- =================================================================

-- 1. ESP Motoru
RunService.RenderStepped:Connect(function()
    if Flags.ESP then
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                local hl = p.Character:FindFirstChild("UguzESP") or Instance.new("Highlight", p.Character)
                hl.Name = "UguzESP"
                hl.Enabled = true
                
                local isMurderer = p.Backpack:FindFirstChild("Knife") or p.Character:FindFirstChild("Knife")
                local isSheriff = p.Backpack:FindFirstChild("Gun") or p.Character:FindFirstChild("Gun")

                if isMurderer then
                    hl.FillColor = Color3.fromRGB(255, 0, 50)
                elseif isSheriff then
                    hl.FillColor = Color3.fromRGB(0, 150, 255)
                else
                    hl.FillColor = Color3.fromRGB(50, 255, 100)
                end
            end
        end
    else
        for _, p in pairs(Players:GetPlayers()) do
            if p.Character and p.Character:FindFirstChild("UguzESP") then
                p.Character.UguzESP.Enabled = false
            end
        end
    end
end)

-- 2. Düzeltilmiş Auto Farm (Tween)
task.spawn(function()
    while task.wait(0.15) do
        if Flags.AutoFarm and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            local coinContainer = Workspace:FindFirstChild("NormalExtra") or Workspace:FindFirstChild("CoinContainer")
            if coinContainer then
                for _, coin in pairs(coinContainer:GetChildren()) do
                    if Flags.AutoFarm and (coin:IsA("BasePart") or coin:FindFirstChild("Coin")) then
                        local targetPart = coin:IsA("BasePart") and coin or coin:FindFirstChild("Coin")
                        if targetPart and targetPart.Transparency < 0.9 then
                            local hrp = LocalPlayer.Character.HumanoidRootPart
                            local dist = (hrp.Position - targetPart.Position).Magnitude
                            local tween = TweenService:Create(hrp, TweenInfo.new(dist / 35, Enum.EasingStyle.Linear), {CFrame = targetPart.CFrame})
                            tween:Play()
                            tween.Completed:Wait()
                        end
                    end
                end
            end
        end
    end
end)

-- 3. Düzeltilmiş Silent Aim & Lock Mechanics
local function GetTargetPlayer()
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
            local isMurderer = p.Backpack:FindFirstChild("Knife") or p.Character:FindFirstChild("Knife")
            local isSheriff = p.Backpack:FindFirstChild("Gun") or p.Character:FindFirstChild("Gun")

            if Flags.LockSheriff and isSheriff then
                return p.Character.HumanoidRootPart
            elseif Flags.LockMurderer and isMurderer then
                return p.Character.HumanoidRootPart
            elseif Flags.SilentAim and (isMurderer or isSheriff) then
                return p.Character.HumanoidRootPart
            end
        end
    end
    return nil
end

-- Mermi & Kamera Yönlendirme (Silent Aim)
RunService.RenderStepped:Connect(function()
    if (Flags.SilentAim or Flags.LockSheriff or Flags.LockMurderer) and LocalPlayer.Character then
        local target = GetTargetPlayer()
        if target then
            Workspace.CurrentCamera.CFrame = CFrame.new(Workspace.CurrentCamera.CFrame.Position, target.Position)
        end
    end
    
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        if Flags.WalkSpeed > 16 then
            LocalPlayer.Character.Humanoid.WalkSpeed = Flags.WalkSpeed
        end
    end
end)

-- 4. Fling Motoru
RunService.Heartbeat:Connect(function()
    if Flags.Fling and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local hrp = LocalPlayer.Character.HumanoidRootPart
        local vel = hrp.Velocity
        hrp.Velocity = Vector3.new(0, 9999, 0)
        RunService.RenderStepped:Wait()
        hrp.Velocity = vel
    end
end)

Rayfield:Notify({
    Title = "UguzHub V2 Pro",
    Content = "Sistem başarıyla aktif edildi!",
    Duration = 4,
    Image = 4483362458
})
