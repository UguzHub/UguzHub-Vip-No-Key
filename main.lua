-- UguzHub V2 Pro - Roblox MM2 Script
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- Dil Sözlüğü (Translations)
local Translations = {
    TR = {
        Title = "UguzHub V2 Pro | MM2",
        Welcome = "Giriş Başarılı! Hoş Geldiniz.",
        MainTab = "Ana Sayfa",
        FarmTab = "Oto Farm",
        CombatTab = "Savaş & Silent Aim",
        TrollTab = "Troll & Hareket",
        EmotesTab = "Emoteler & Eşyalar",
        SettingsTab = "Ayarlar",
        Greeting = "Bugün nasılsın, ",
        EspToggle = "ESP Göster (Katil/Şerif)",
        AutoFarmToggle = "Sınırsız Sikke Topla (Auto Farm)",
        SilentAimToggle = "Silent Aim (Rastgele Atış Katile/Şerife Gider)",
        LockSheriff = "Katilken Şerife Kilitlen",
        LockMurderer = "Şerifken Katile Kilitlen",
        WalkSpeed = "Yürüme Hızı",
        FlyToggle = "Uçma Modu (Fly)",
        FlingToggle = "Görünmez Fling",
        C4Item = "Şaka Bombası (C4) Al",
        FreeEmotes = "Tüm Emoteleri Aç"
    },
    EN = {
        Title = "UguzHub V2 Pro | MM2",
        Welcome = "Login Successful! Welcome.",
        MainTab = "Main",
        FarmTab = "Auto Farm",
        CombatTab = "Combat & Silent Aim",
        TrollTab = "Troll & Movement",
        EmotesTab = "Emotes & Items",
        SettingsTab = "Settings",
        Greeting = "How are you today, ",
        EspToggle = "ESP (Murderer/Sheriff)",
        AutoFarmToggle = "Auto Farm Coins",
        SilentAimToggle = "Silent Aim (Target Murderer/Sheriff)",
        LockSheriff = "Lock to Sheriff (as Murderer)",
        LockMurderer = "Lock to Murderer (as Sheriff)",
        WalkSpeed = "WalkSpeed",
        FlyToggle = "Fly Mode",
        FlingToggle = "Invisible Fling",
        C4Item = "Get Prank Bomb (C4)",
        FreeEmotes = "Unlock All Emotes"
    },
    RU = {
        Title = "UguzHub V2 Pro | MM2",
        Welcome = "Вход выполнен! Добро пожаловать.",
        MainTab = "Главная",
        FarmTab = "Авто Фарм",
        CombatTab = "Бей & АимBot",
        TrollTab = "Тролль & Движение",
        EmotesTab = "Эмоции & Предметы",
        SettingsTab = "Настройки",
        Greeting = "Как ты сегодня, ",
        EspToggle = "ESP (Убийца/Шериф)",
        AutoFarmToggle = "Авто-сбор монет",
        SilentAimToggle = "Silent Aim (Авто-попадание)",
        LockSheriff = "Захват Шерифа (за Убийцу)",
        LockMurderer = "Захват Убийцы (за Шерифа)",
        WalkSpeed = "Скорость ходьбы",
        FlyToggle = "Режим полета",
        FlingToggle = "Невидимый Fling",
        C4Item = "Получить бомбу (C4)",
        FreeEmotes = "Разблокировать все эмоции"
    }
}

local SelectedLang = Translations.TR -- Varsayılan dil

-- Animasyonlu Giriş & Dil Seçim Arayüzü (GUI)
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 420, 0, 260)
MainFrame.Position = UDim2.new(0.5, -210, 0.5, -130)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
MainFrame.BorderSizePixel = 0
MainFrame.ClipsDescendants = true

local UICorner = Instance.new("UICorner", MainFrame)
UICorner.CornerRadius = UDim.new(0, 12)

-- Başlık & Alt Çizgi Animasyonu
local Title = Instance.new("TextLabel", MainFrame)
Title.Size = UDim2.new(1, 0, 0, 40)
Title.Text = "✨ UGUZHUB V2 PRO ✨"
Title.TextColor3 = Color3.fromRGB(255, 215, 0)
Title.TextSize = 22
Title.Font = Enum.Font.Garamond
Title.BackgroundTransparency = 1

local Underline = Instance.new("Frame", MainFrame)
Underline.Size = UDim2.new(0, 0, 0, 3)
Underline.Position = UDim2.new(0.1, 0, 0.18, 0)
Underline.BackgroundColor3 = Color3.fromRGB(255, 215, 0)
Underline.BorderSizePixel = 0
Underline:TweenSize(UDim2.new(0.8, 0, 0, 3), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 1, true)

-- Dil Butonları Oluşturma Fonksiyonu
local function CreateLangButton(text, pos, langTable)
    local btn = Instance.new("TextButton", MainFrame)
    btn.Size = UDim2.new(0.8, 0, 0, 40)
    btn.Position = pos
    btn.Text = text
    btn.TextSize = 16
    btn.Font = Enum.Font.SourceSansBold
    btn.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    
    local btnCorner = Instance.new("UICorner", btn)
    btnCorner.CornerRadius = UDim.new(0, 8)
    
    btn.MouseButton1Click:Connect(function()
        SelectedLang = langTable
        ScreenGui:Destroy()
        LoadMainHub()
    end)
end

CreateLangButton("🇹🇷 Türkçe", UDim2.new(0.1, 0, 0.3, 0), Translations.TR)
CreateLangButton("🇬🇧 English", UDim2.new(0.1, 0, 0.5, 0), Translations.EN)
CreateLangButton("🇷🇺 Русский", UDim2.new(0.1, 0, 0.7, 0), Translations.RU)

-- Ana Menü Yükleyici
function LoadMainHub()
    local Window = Rayfield:CreateWindow({
        Name = SelectedLang.Title,
        LoadingTitle = "UguzHub V2 Pro",
        LoadingSubtitle = "by Uguz",
        ConfigurationSaving = { Enabled = false }
    })

    Rayfield:Notify({
        Title = "UguzHub V2 Pro",
        Content = SelectedLang.Welcome,
        Duration = 4,
        Image = 4483362458
    })

    -- 1. MAIN TAB
    local MainTab = Window:CreateTab(SelectedLang.MainTab, 4483362458)
    MainTab:CreateLabel("UguzHub V2 Pro - Murder Mystery 2")
    MainTab:CreateToggle({
        Name = SelectedLang.EspToggle,
        CurrentValue = false,
        Callback = function(Value)
            -- ESP Kodu Mantığı
        end,
    })

    -- 2. AUTO FARM TAB
    local FarmTab = Window:CreateTab(SelectedLang.FarmTab, 4483362458)
    FarmTab:CreateToggle({
        Name = SelectedLang.AutoFarmToggle,
        CurrentValue = false,
        Callback = function(Value)
            -- Auto Farm Sikke Toplama Mantığı
        end,
    })

    -- 3. COMBAT & SILENT AIM TAB
    local CombatTab = Window:CreateTab(SelectedLang.CombatTab, 4483362458)
    CombatTab:CreateToggle({
        Name = SelectedLang.SilentAimToggle,
        CurrentValue = false,
        Callback = function(Value)
            -- Rastgele atışlarda mermiyi katile/şerife yönlendirme mantığı
        end,
    })
    CombatTab:CreateButton({
        Name = SelectedLang.LockSheriff,
        Callback = function()
            -- Katilken Şerife Kilitlenme
        end,
    })
    CombatTab:CreateButton({
        Name = SelectedLang.LockMurderer,
        Callback = function()
            -- Şerifken Katile Kilitlenme
        end,
    })

    -- 4. TROLL & MOVEMENT TAB
    local TrollTab = Window:CreateTab(SelectedLang.TrollTab, 4483362458)
    TrollTab:CreateSlider({
        Name = SelectedLang.WalkSpeed,
        Range = {16, 200},
        Increment = 1,
        CurrentValue = 16,
        Callback = function(Value)
            game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = Value
        end,
    })
    TrollTab:CreateToggle({
        Name = SelectedLang.FlyToggle,
        CurrentValue = false,
        Callback = function(Value)
            -- Fly Mantığı
        end,
    })
    TrollTab:CreateToggle({
        Name = SelectedLang.FlingToggle,
        CurrentValue = false,
        Callback = function(Value)
            -- Visible Fling Mantığı
        end,
    })

    -- 5. EMOTES & ITEMS TAB
    local EmotesTab = Window:CreateTab(SelectedLang.EmotesTab, 4483362458)
    EmotesTab:CreateButton({
        Name = SelectedLang.FreeEmotes,
        Callback = function()
            -- MM2 Ücretsiz Emote Kullanımı
        end,
    })
    EmotesTab:CreateButton({
        Name = SelectedLang.C4Item,
        Callback = function()
            -- Şaka Bombası (C4) Verici Mantık
        end,
    })

    -- 6. SETTINGS TAB (Profil Bilgileri ile)
    local SettingsTab = Window:CreateTab(SelectedLang.SettingsTab, 4483362458)
    local Player = game.Players.LocalPlayer
    
    SettingsTab:CreateLabel("👤 Oyuncu Profil:")
    SettingsTab:CreateLabel("Kullanıcı Adı: " .. Player.Name)
    SettingsTab:CreateLabel(SelectedLang.Greeting .. Player.DisplayName .. "! 👋")
end
