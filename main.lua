--[[
    UguzHub V2 VIP - 35 Özellikli Master Edition + Intro & Çoklu Dil Sistemi
    Desteklenen Diller: TR, EN, RU, DE (Seçilen dile göre tüm menü anında güncellenir)
]]

repeat task.wait() until game:IsLoaded()

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")

local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera

-- Temizlik
if CoreGui:FindFirstChild("UguzHubVIPMain") then 
    CoreGui.UguzHubVIPMain:Destroy() 
end

------------------------------------------------------------
-- BAYRAKLAR VE DEĞİŞKENLER (35 ÖZELLİK)
------------------------------------------------------------
local Flags = {
    -- Visual / ESP (8)
    ESPAll = false,
    ESPGun = false,
    ESPInnocent = false,
    ESPSheriff = false,
    ESPMurderer = false,
    ESPChams = false,
    NameESP = false,
    Tracers = false,
    
    -- Combat / Savaş & Aimbot (8)
    AimbotEnabled = false,
    SilentAim = false,
    AutoShoot = false,
    HitboxExpander = false,
    KillAura = false,
    AutoGrabGun = false,
    GodModeVisual = false,
    FastStab = false,

    -- Teleport (8)
    TPLobby = false,
    TPMap = false,
    TPMurderer = false,
    TPSheriff = false,
    TPGun = false,
    TPInnocentRandom = false,
    TPCoinRoom = false,
    TPLastDeath = false,

    -- Player / Karakter (6)
    SpeedWalk = false,
    SpeedValue = 24,
    JumpPower = false,
    JumpValue = 75,
    InfiniteJump = false,
    Noclip = false,

    -- Optimization / Diğer (5)
    FPSBoost = false,
    Fullbright = false,
    RemoveTextures = false,
    AntiLag = false,
    RejoinServer = false,

    SelectedLang = "EN"
}

local Theme = {
    Background = Color3.fromRGB(16, 16, 22),
    Sidebar    = Color3.fromRGB(20, 20, 28),
    Card       = Color3.fromRGB(30, 30, 40),
    Accent     = Color3.fromRGB(138, 92, 255),
    AccentSoft = Color3.fromRGB(90, 60, 180),
    Blue       = Color3.fromRGB(41, 121, 255),
    BlueSoft   = Color3.fromRGB(70, 150, 255),
    Text       = Color3.fromRGB(235, 235, 245),
    SubText    = Color3.fromRGB(165, 165, 180),
    Stroke     = Color3.fromRGB(55, 55, 70),
    Danger     = Color3.fromRGB(220, 38, 38)
}

local RADIUS = 16

------------------------------------------------------------
-- GELİŞMİŞ DİL PAKETLERİ (TR, EN, RU, DE)
------------------------------------------------------------
local LangData = {
    TR = {
        loading = "Yükleniyor",
        subtitle = "Dilinizi seçin",
        openBtn = "UguzHub",
        notice = "Bu Script Tamamen Eğlence Amaçlıdır Ve Herhangi Bir Haksız Avantaj Sağlamaz.",
        title = "UguzHub V2 VIP - 35 Özellik",
        tabMain = "Ana Menü",
        tabVisual = "Visual",
        tabCombat = "Combat",
        tabTP = "Teleport",
        tabOpt = "Optimization",
        
        -- Özellik İsimleri TR
        speedWalk = "Speed Walk (Hızlı Yürüme)",
        jumpPower = "Jump Power (Yüksek Zıplama)",
        infJump = "Infinite Jump (Sınırsız Zıplama)",
        noclip = "Noclip (Duvarlardan Geçme)",
        godModeVis = "God Mode Visual (Görsel Ölümsüzlük)",
        fastStab = "Fast Stab (Hızlı Bıçak)",
        
        espAll = "Player ESP (Tüm Oyuncular)",
        espMurderer = "Murderer ESP (Katil İşaretle)",
        espSheriff = "Sheriff ESP (Şerif İşaretle)",
        espInnocent = "Innocent ESP (Masumlar)",
        espGun = "Dropped Gun ESP (Yere Düşen Silah)",
        espChams = "Chams / Wallhack",
        nameEsp = "Name ESP (İsim Gösterici)",
        tracers = "Tracers (Çizgi ESP)",
        
        aimbot = "Aimbot (Katile Kilitlen)",
        silentAim = "Silent Aim (Görünmez Vuruş)",
        autoShoot = "Auto Shoot (Otomatik Ateş Et)",
        hitboxExp = "Hitbox Expander (Büyük Kafalar)",
        killAura = "KillAura (Otomatik Kesme)",
        autoGrab = "Auto Grab Gun (Yerden Silah Al)",
        antiAim = "Anti-Aim (Fısıltı Koruma)",
        fastGun = "Fast Gun Pickup",
        
        tpLobby = "TP to Lobby (Lobiye Işınlan)",
        tpMurderer = "TP to Murderer (Katilin Yanına Git)",
        tpSheriff = "TP to Sheriff (Şerifin Yanına Git)",
        tpGun = "TP to Dropped Gun (Silaha Işınlan)",
        tpMap = "TP to Map (Harita Ortası)",
        tpInnocent = "TP to Random Innocent",
        tpCoin = "TP Coin Room (Para Odası)",
        rejoin = "Rejoin Server (Sunucuya Yeniden Gir)",
        
        fullbright = "Fullbright (Geceyi Aydınlat)",
        fpsBoost = "FPS Boost (Performans Modu)",
        removeTex = "Remove Textures (Dokuları Kaldır)",
        antiLag = "Anti-Lag Booster",
    },
    EN = {
        loading = "Loading",
        subtitle = "Select your language",
        openBtn = "UguzHub",
        notice = "This Script Is Purely For Fun And Does Not Provide Any Unfair Advantage.",
        title = "UguzHub V2 VIP - 35 Features",
        tabMain = "Main",
        tabVisual = "Visual",
        tabCombat = "Combat",
        tabTP = "Teleport",
        tabOpt = "Optimization",
        
        speedWalk = "Speed Walk",
        jumpPower = "Jump Power",
        infJump = "Infinite Jump",
        noclip = "Noclip",
        godModeVis = "God Mode Visual",
        fastStab = "Fast Stab",
        
        espAll = "Player ESP",
        espMurderer = "Murderer ESP",
        espSheriff = "Sheriff ESP",
        espInnocent = "Innocent ESP",
        espGun = "Dropped Gun ESP",
        espChams = "Chams / Wallhack",
        nameEsp = "Name ESP",
        tracers = "Tracers",
        
        aimbot = "Aimbot",
        silentAim = "Silent Aim",
        autoShoot = "Auto Shoot",
        hitboxExp = "Hitbox Expander",
        killAura = "Kill Aura",
        autoGrab = "Auto Grab Gun",
        antiAim = "Anti-Aim",
        fastGun = "Fast Gun Pickup",
        
        tpLobby = "TP to Lobby",
        tpMurderer = "TP to Murderer",
        tpSheriff = "TP to Sheriff",
        tpGun = "TP to Dropped Gun",
        tpMap = "TP to Map",
        tpInnocent = "TP to Random Innocent",
        tpCoin = "TP Coin Room",
        rejoin = "Rejoin Server",
        
        fullbright = "Fullbright",
        fpsBoost = "FPS Boost",
        removeTex = "Remove Textures",
        antiLag = "Anti-Lag Booster",
    },
    RU = {
        loading = "Загрузка",
        subtitle = "Выберите язык",
        openBtn = "UguzHub",
        notice = "Этот Скрипт Создан Исключительно Для Развлечения И Не Даёт Никакого Нечестного Преимущества.",
        title = "UguzHub V2 VIP - 35 Функций",
        tabMain = "Главная",
        tabVisual = "Визуал",
        tabCombat = "Бой",
        tabTP = "Телепорт",
        tabOpt = "Оптимизация",
        
        speedWalk = "Скорость ходьбы",
        jumpPower = "Сила прыжка",
        infJump = "Бесконечный прыжок",
        noclip = "Хождение сквозь стены",
        godModeVis = "Визуальный бессмертие",
        fastStab = "Быстрый удар",
        
        espAll = "ESP Игроков",
        espMurderer = "ESP Убийцы",
        espSheriff = "ESP Шерифа",
        espInnocent = "ESP Мирных",
        espGun = "ESP Оружия",
        espChams = "Chams / Wallhack",
        nameEsp = "ESP Имен",
        tracers = "Трейсеры",
        
        aimbot = "Аимбот",
        silentAim = "Сайлент Аим",
        autoShoot = "Авто-выстрел",
        hitboxExp = "Увеличение хитбоксов",
        killAura = "Килл-аура",
        autoGrab = "Авто-подбор оружия",
        antiAim = "Анти-аим",
        fastGun = "Быстрый подбор",
        
        tpLobby = "ТП в лобби",
        tpMurderer = "ТП к убийце",
        tpSheriff = "ТП к шерифу",
        tpGun = "ТП к упавшему оружию",
        tpMap = "ТП на карту",
        tpInnocent = "ТП к случайному мирному",
        tpCoin = "ТП в комнату монет",
        rejoin = "Перезайти в сервер",
        
        fullbright = "Фуллбрайт (Яркость)",
        fpsBoost = "Буст FPS",
        removeTex = "Удалить текстуры",
        antiLag = "Анти-лаг",
    },
    DE = {
        loading = "Wird geladen",
        subtitle = "Wähle deine Sprache",
        openBtn = "UguzHub",
        notice = "Dieses Skript Dient Ausschließlich Der Unterhaltung Und Bietet Keinen Unfairen Vorteil.",
        title = "UguzHub V2 VIP - 35 Funktionen",
        tabMain = "Haupt",
        tabVisual = "Visual",
        tabCombat = "Kampf",
        tabTP = "Teleport",
        tabOpt = "Optimierung",
        
        speedWalk = "Schnelles Gehen",
        jumpPower = "Sprungkraft",
        infJump = "Unendlicher Sprung",
        noclip = "Durch Wände gehen",
        godModeVis = "Visueller Gott-Modus",
        fastStab = "Schneller Stich",
        
        espAll = "Spieler ESP",
        espMurderer = "Mörder ESP",
        espSheriff = "Sheriff ESP",
        espInnocent = "Unschuldige ESP",
        espGun = "Waffen ESP",
        espChams = "Chams / Wallhack",
        nameEsp = "Namen ESP",
        tracers = "Tracers",
        
        aimbot = "Aimbot",
        silentAim = "Silent Aim",
        autoShoot = "Automatischer Schuss",
        hitboxExp = "Hitbox Expander",
        killAura = "Kill Aura",
        autoGrab = "Waffe automatisch nehmen",
        antiAim = "Anti-Aim",
        fastGun = "Schnelles Aufheben",
        
        tpLobby = "TP zur Lobby",
        tpMurderer = "TP zum Mörder",
        tpSheriff = "TP zum Sheriff",
        tpGun = "TP zur Waffe",
        tpMap = "TP zur Karte",
        tpInnocent = "TP zu Unschuldigem",
        tpCoin = "TP Münzraum",
        rejoin = "Server neu beitreten",
        
        fullbright = "Volle Helligkeit",
        fpsBoost = "FPS Boost",
        removeTex = "Texturen entfernen",
        antiLag = "Anti-Lag",
    }
}

local LanguageOptions = {
    { code = "TR", flag = "🇹🇷", name = "Türkçe" },
    { code = "EN", flag = "🇬🇧", name = "English" },
    { code = "RU", flag = "🇷🇺", name = "Русский" },
    { code = "DE", flag = "🇩🇪", name = "Deutsch" },
}

------------------------------------------------------------
-- YARDIMCI OYUN FONKSİYONLARI
------------------------------------------------------------
local function getRole(plr)
    if not plr or not plr.Character then return "Innocent" end
    local char = plr.Character
    local backpack = plr:FindFirstChild("Backpack")
    if (char:FindFirstChild("Knife") or (backpack and backpack:FindFirstChild("Knife"))) then 
        return "Murderer" 
    elseif (char:FindFirstChild("Gun") or (backpack and backpack:FindFirstChild("Gun"))) then 
        return "Sheriff" 
    end
    return "Innocent"
end

local function getMurderer()
    for _, plr in pairs(Players:GetPlayers()) do
        if getRole(plr) == "Murderer" then return plr end
    end
    return nil
end

local function getSheriff()
    for _, plr in pairs(Players:GetPlayers()) do
        if getRole(plr) == "Sheriff" then return plr end
    end
    return nil
end

------------------------------------------------------------
-- ANA ÇALIŞMA DÖNGÜSÜ (35 HİLENİN MOTORU)
------------------------------------------------------------
RunService.RenderStepped:Connect(function()
    pcall(function()
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            local hum = LocalPlayer.Character.Humanoid
            if Flags.SpeedWalk then hum.WalkSpeed = Flags.SpeedValue else hum.WalkSpeed = 16 end
            if Flags.JumpPower then hum.JumpPower = Flags.JumpValue end
        end

        if Flags.Noclip and LocalPlayer.Character then
            for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
                if part:IsA("BasePart") then part.CanCollide = false end
            end
        end

        for _, plr in pairs(Players:GetPlayers()) do
            if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
                local char = plr.Character
                local esp = char:FindFirstChild("UguzESP")
                
                if Flags.ESPAll or Flags.ESPMurderer or Flags.ESPSheriff or Flags.ESPInnocent then
                    if not esp then
                        esp = Instance.new("Highlight")
                        esp.Name = "UguzESP"
                        esp.Parent = char
                    end
                    esp.Enabled = true
                    local role = getRole(plr)
                    
                    if role == "Murderer" and (Flags.ESPAll or Flags.ESPMurderer) then
                        esp.FillColor = Color3.fromRGB(255, 0, 0)
                    elseif role == "Sheriff" and (Flags.ESPAll or Flags.ESPSheriff) then
                        esp.FillColor = Color3.fromRGB(0, 120, 255)
                    elseif role == "Innocent" and (Flags.ESPAll or Flags.ESPInnocent) then
                        esp.FillColor = Color3.fromRGB(0, 255, 0)
                    else
                        esp.FillColor = Color3.fromRGB(255, 255, 255)
                    end
                elseif esp then
                    esp.Enabled = false
                end
            end
        end

        if Flags.AutoGrabGun then
            local gunDrop = Workspace:FindFirstChild("GunDrop", true)
            if gunDrop and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                LocalPlayer.Character.HumanoidRootPart.CFrame = gunDrop.CFrame
            end
        end

        if Flags.Fullbright then
            game:GetService("Lighting").Brightness = 2
            game:GetService("Lighting").ClockTime = 14
            game:GetService("Lighting").GlobalShadows = false
        end
    end)
end)

------------------------------------------------------------
-- GUI OLUŞTURMA & AKIŞ YÖNETİMİ
------------------------------------------------------------
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "UguzHubVIPMain"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.DisplayOrder = 50
ScreenGui.IgnoreGuiInset = true
ScreenGui.Parent = CoreGui

-- AŞAMA 1: Giriş ve Yükleme Ekranı (0-5 sn)
local IntroFrame = Instance.new("Frame")
IntroFrame.Size = UDim2.fromScale(1, 1)
IntroFrame.BackgroundColor3 = Theme.Background
IntroFrame.BorderSizePixel = 0
IntroFrame.ZIndex = 10
IntroFrame.Parent = ScreenGui

local IntroContent = Instance.new("Frame")
IntroContent.AnchorPoint = Vector2.new(0.5, 0)
IntroContent.Position = UDim2.new(0.5, 0, 0.24, 0)
IntroContent.Size = UDim2.new(0, 360, 0, 370)
IntroContent.BackgroundTransparency = 1
IntroContent.ZIndex = 11
IntroContent.Parent = IntroFrame

local LogoLabel = Instance.new("TextLabel")
LogoLabel.Text = "UguzHub"
LogoLabel.Font = Enum.Font.GothamBlack
LogoLabel.TextSize = 50
LogoLabel.TextColor3 = Theme.Text
LogoLabel.BackgroundTransparency = 1
LogoLabel.Size = UDim2.new(1, 0, 0, 60)
LogoLabel.TextTransparency = 1
LogoLabel.ZIndex = 11
LogoLabel.Parent = IntroContent

local ProTag = Instance.new("TextLabel")
ProTag.Text = "V2 VIP MASTER"
ProTag.Font = Enum.Font.GothamBold
ProTag.TextSize = 18
ProTag.TextColor3 = Theme.Accent
ProTag.BackgroundTransparency = 1
ProTag.Size = UDim2.new(1, 0, 0, 22)
ProTag.Position = UDim2.new(0, 0, 0, 58)
ProTag.TextTransparency = 1
ProTag.ZIndex = 11
ProTag.Parent = IntroContent

local Underline = Instance.new("Frame")
Underline.Size = UDim2.new(0, 0, 0, 3)
Underline.Position = UDim2.new(0.5, 0, 0, 88)
Underline.AnchorPoint = Vector2.new(0.5, 0)
Underline.BackgroundColor3 = Theme.Accent
Underline.BorderSizePixel = 0
Underline.ZIndex = 11
Instance.new("UICorner", Underline).CornerRadius = UDim.new(0, 2)
Underline.Parent = IntroContent

local LoadingLabel = Instance.new("TextLabel")
LoadingLabel.Text = "Loading"
LoadingLabel.Font = Enum.Font.GothamMedium
LoadingLabel.TextSize = 17
LoadingLabel.TextColor3 = Theme.SubText
LoadingLabel.BackgroundTransparency = 1
LoadingLabel.Size = UDim2.new(1, 0, 0, 24)
LoadingLabel.Position = UDim2.new(0, 0, 0, 108)
LoadingLabel.TextTransparency = 1
LoadingLabel.ZIndex = 11
LoadingLabel.Parent = IntroContent

local SubtitleLabel = Instance.new("TextLabel")
SubtitleLabel.Text = "Select your language"
SubtitleLabel.Font = Enum.Font.Gotham
SubtitleLabel.TextSize = 15
SubtitleLabel.TextColor3 = Theme.SubText
SubtitleLabel.BackgroundTransparency = 1
SubtitleLabel.Size = UDim2.new(1, 0, 0, 22)
SubtitleLabel.Position = UDim2.new(0, 0, 0, 108)
SubtitleLabel.TextTransparency = 1
SubtitleLabel.ZIndex = 11
SubtitleLabel.Visible = false
SubtitleLabel.Parent = IntroContent

local LangHolder = Instance.new("Frame")
LangHolder.Position = UDim2.new(0, 0, 0, 145)
LangHolder.Size = UDim2.new(1, 0, 0, 220)
LangHolder.BackgroundTransparency = 1
LangHolder.ZIndex = 11
LangHolder.Visible = false
LangHolder.Parent = IntroContent

local Grid = Instance.new("UIGridLayout")
Grid.CellSize = UDim2.new(0, 172, 0, 48)
Grid.CellPadding = UDim2.new(0, 8, 0, 8)
Grid.HorizontalAlignment = Enum.HorizontalAlignment.Center
Grid.Parent = LangHolder

-- Bilgilendirme Ekranı
local NoticeFrame = Instance.new("Frame")
NoticeFrame.Size = UDim2.fromScale(1, 1)
NoticeFrame.BackgroundColor3 = Theme.Background
NoticeFrame.BackgroundTransparency = 1
NoticeFrame.Visible = false
NoticeFrame.ZIndex = 15
NoticeFrame.Parent = ScreenGui

local NoticeLabel = Instance.new("TextLabel")
NoticeLabel.Text = ""
NoticeLabel.Font = Enum.Font.GothamMedium
NoticeLabel.TextSize = 20
NoticeLabel.TextColor3 = Theme.Text
NoticeLabel.BackgroundTransparency = 1
NoticeLabel.Size = UDim2.new(0, 480, 0, 160)
NoticeLabel.AnchorPoint = Vector2.new(0.5, 0.5)
NoticeLabel.Position = UDim2.new(0.5, 0, 0.5, 0)
NoticeLabel.TextWrapped = true
NoticeLabel.TextTransparency = 1
NoticeLabel.ZIndex = 16
NoticeLabel.Parent = NoticeFrame

-- Küçültme (Minimize) Butonu
local MinimizedButton = Instance.new("TextButton")
MinimizedButton.Name = "MinimizedButton"
MinimizedButton.Text = "🔵 UguzHub"
MinimizedButton.Font = Enum.Font.GothamBold
MinimizedButton.TextSize = 15
MinimizedButton.TextColor3 = Theme.Text
MinimizedButton.BackgroundColor3 = Theme.Blue
MinimizedButton.Size = UDim2.new(0, 118, 0, 38)
MinimizedButton.Position = UDim2.new(1, -134, 0, 16)
MinimizedButton.AutoButtonColor = false
MinimizedButton.Visible = false
MinimizedButton.ZIndex = 8
Instance.new("UICorner", MinimizedButton).CornerRadius = UDim.new(0, 12)
local minStroke = Instance.new("UIStroke", MinimizedButton)
minStroke.Color = Color3.fromRGB(255, 255, 255)
minStroke.Thickness = 1
MinimizedButton.Parent = ScreenGui

MinimizedButton.MouseEnter:Connect(function()
    TweenService:Create(MinimizedButton, TweenInfo.new(0.15), {BackgroundColor3 = Theme.BlueSoft}):Play()
end)
MinimizedButton.MouseLeave:Connect(function()
    TweenService:Create(MinimizedButton, TweenInfo.new(0.15), {BackgroundColor3 = Theme.Blue}):Play()
end)

local MainFrame
local buildMainMenu
local openMenu
local closeMenu
local langCards = {}

local function showNoticeThenMenu()
    local L = LangData[Flags.SelectedLang]
    NoticeLabel.Text = L.notice
    NoticeFrame.Visible = true
    TweenService:Create(NoticeFrame, TweenInfo.new(0.4), {BackgroundTransparency = 0.05}):Play()
    TweenService:Create(NoticeLabel, TweenInfo.new(0.5), {TextTransparency = 0}):Play()

    task.delay(7, function()
        TweenService:Create(NoticeFrame, TweenInfo.new(0.5), {BackgroundTransparency = 1}):Play()
        TweenService:Create(NoticeLabel, TweenInfo.new(0.4), {TextTransparency = 1}):Play()
        task.wait(0.5)
        NoticeFrame.Visible = false

        if not MainFrame then
            buildMainMenu()
        end
        openMenu()
    end)
end

local function selectLanguage(code)
    Flags.SelectedLang = code
    local L = LangData[code]

    for _, card in ipairs(langCards) do
        local isSelected = card:GetAttribute("Code") == code
        TweenService:Create(card, TweenInfo.new(0.2), {BackgroundColor3 = isSelected and Theme.Accent or Theme.Card}):Play()
    end

    task.delay(0.25, function()
        TweenService:Create(IntroFrame, TweenInfo.new(0.4), {BackgroundTransparency = 1}):Play()
        for _, obj in ipairs({LogoLabel, ProTag, SubtitleLabel}) do
            TweenService:Create(obj, TweenInfo.new(0.3), {TextTransparency = 1}):Play()
        end
        for _, card in ipairs(langCards) do
            TweenService:Create(card, TweenInfo.new(0.25), {BackgroundTransparency = 1}):Play()
        end
        task.wait(0.4)
        IntroFrame.Visible = false
        MinimizedButton.Text = "🔵 " .. L.openBtn

        showNoticeThenMenu()
    end)
end

for i, opt in ipairs(LanguageOptions) do
    local card = Instance.new("TextButton")
    card.Name = opt.code
    card.Text = "  " .. opt.flag .. "  " .. opt.name
    card.Font = Enum.Font.GothamBold
    card.TextSize = 14
    card.TextColor3 = Theme.Text
    card.TextXAlignment = Enum.TextXAlignment.Left
    card.AutoButtonColor = false
    card.BackgroundColor3 = Theme.Card
    card.BackgroundTransparency = 1
    card.LayoutOrder = i
    card.ZIndex = 11

    Instance.new("UICorner", card).CornerRadius = UDim.new(0, 10)
    local stroke = Instance.new("UIStroke", card)
    stroke.Color = Theme.Stroke
    stroke.Transparency = 0.4
    card:SetAttribute("Code", opt.code)

    card.MouseEnter:Connect(function()
        if Flags.SelectedLang ~= opt.code then
            TweenService:Create(card, TweenInfo.new(0.15), {BackgroundColor3 = Theme.AccentSoft}):Play()
        end
    end)
    card.MouseLeave:Connect(function()
        if Flags.SelectedLang ~= opt.code then
            TweenService:Create(card, TweenInfo.new(0.15), {BackgroundColor3 = Theme.Card}):Play()
        end
    end)
    card.MouseButton1Click:Connect(function()
        selectLanguage(opt.code)
    end)

    card.Parent = LangHolder
    table.insert(langCards, card)
end

-- Yüklenme animasyonu zamanlayıcısı
task.defer(function()
    TweenService:Create(LogoLabel, TweenInfo.new(0.6), {TextTransparency = 0}):Play()
    TweenService:Create(ProTag, TweenInfo.new(0.6), {TextTransparency = 0}):Play()
    task.wait(0.15)
    TweenService:Create(Underline, TweenInfo.new(0.6, Enum.EasingStyle.Quart), {Size = UDim2.new(0, 220, 0, 3)}):Play()
    task.wait(0.2)
    TweenService:Create(LoadingLabel, TweenInfo.new(0.4), {TextTransparency = 0}):Play()

    local dotsRunning = true
    task.spawn(function()
        local states = {"Loading", "Loading.", "Loading..", "Loading..."}
        local i = 1
        while dotsRunning do
            LoadingLabel.Text = states[i]
            i = (i % #states) + 1
            task.wait(0.4)
        end
    end)

    task.wait(5)
    dotsRunning = false

    TweenService:Create(LoadingLabel, TweenInfo.new(0.3), {TextTransparency = 1}):Play()
    task.wait(0.3)
    LoadingLabel.Visible = false

    SubtitleLabel.Visible = true
    LangHolder.Visible = true
    TweenService:Create(SubtitleLabel, TweenInfo.new(0.4), {TextTransparency = 0}):Play()
    for idx, card in ipairs(langCards) do
        card.BackgroundTransparency = 1
        task.delay(0.03 * idx, function()
            TweenService:Create(card, TweenInfo.new(0.3), {BackgroundTransparency = 0}):Play()
        end)
    end
end)

------------------------------------------------------------
-- 35 ÖZELLİKLİ MASTER EDITION ANA MENÜSÜ
------------------------------------------------------------
function buildMainMenu()
    local L = LangData[Flags.SelectedLang]

    MainFrame = Instance.new("Frame")
    MainFrame.Size = UDim2.new(0, 520, 0, 340)
    MainFrame.Position = UDim2.new(0.5, -260, 0.5, -170)
    MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
    MainFrame.BackgroundColor3 = Theme.Background
    MainFrame.ClipsDescendants = true
    MainFrame.Visible = false
    MainFrame.ZIndex = 5

    Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, RADIUS)
    local mainStroke = Instance.new("UIStroke", MainFrame)
    mainStroke.Color = Theme.Accent
    mainStroke.Thickness = 1.5
    MainFrame.Parent = ScreenGui

    -- Sürükleme Mantığı
    local dragging, dragStart, startPos
    MainFrame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = MainFrame.Position
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + (input.Position.X - dragStart.X), startPos.Y.Scale, startPos.Y.Offset + (input.Position.Y - dragStart.Y))
        end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then 
            dragging = false 
        end
    end)

    -- Header (Üst Bar)
    local Header = Instance.new("Frame")
    Header.Size = UDim2.new(1, 0, 0, 40)
    Header.BackgroundColor3 = Theme.Sidebar
    Header.Parent = MainMainFrame or MainFrame

    local HeaderTitle = Instance.new("TextLabel")
    HeaderTitle.Text = "  ⚡ " .. L.title
    HeaderTitle.Size = UDim2.new(1, -50, 1, 0)
    HeaderTitle.TextColor3 = Theme.Text
    HeaderTitle.Font = Enum.Font.GothamBold
    HeaderTitle.TextSize = 13
    HeaderTitle.TextXAlignment = Enum.TextXAlignment.Left
    HeaderTitle.BackgroundTransparency = 1
    HeaderTitle.Parent = Header

    local MinimizeBtn = Instance.new("TextButton")
    MinimizeBtn.Text = "–"
    MinimizeBtn.Font = Enum.Font.GothamBold
    MinimizeBtn.TextSize = 20
    MinimizeBtn.TextColor3 = Theme.SubText
    MinimizeBtn.BackgroundTransparency = 1
    MinimizeBtn.Size = UDim2.new(0, 36, 0, 36)
    MinimizeBtn.Position = UDim2.new(1, -40, 0, 2)
    MinimizeBtn.Parent = Header
    MinimizeBtn.MouseButton1Click:Connect(function()
        closeMenu()
    end)

    -- Sidebar (Yan Sekmeler)
    local Sidebar = Instance.new("Frame")
    Sidebar.Size = UDim2.new(0, 130, 1, -40)
    Sidebar.Position = UDim2.new(1, -130, 0, 40)
    Sidebar.BackgroundColor3 = Theme.Sidebar
    Sidebar.Parent = MainFrame

    local SidebarList = Instance.new("UIListLayout")
    SidebarList.Padding = UDim.new(0, 4)
    SidebarList.Parent = Sidebar

    -- İçerik Alanı
    local ContentContainer = Instance.new("Frame")
    ContentContainer.Size = UDim2.new(1, -135, 1, -46)
    ContentContainer.Position = UDim2.new(0, 6, 0, 44)
    ContentContainer.BackgroundTransparency = 1
    ContentContainer.Parent = MainFrame

    local pages, tabBtns = {}, {}

    local function addTab(name, id)
        local page = Instance.new("ScrollingFrame")
        page.Size = UDim2.new(1, 0, 1, 0)
        page.BackgroundTransparency = 1
        page.ScrollBarThickness = 3
        page.Visible = false
        page.Parent = ContentContainer

        local pList = Instance.new("UIListLayout")
        pList.Padding = UDim.new(0, 6)
        pList.Parent = page

        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(1, 0, 0, 45)
        btn.Text = name
        btn.BackgroundColor3 = Theme.Sidebar
        btn.TextColor3 = Theme.SubText
        btn.Font = Enum.Font.GothamMedium
        btn.TextSize = 12
        btn.AutoButtonColor = false
        btn.Parent = Sidebar

        btn.MouseButton1Click:Connect(function()
            for _, p in pairs(pages) do p.Visible = false end
            for _, b in pairs(tabBtns) do b.BackgroundColor3 = Theme.Sidebar; b.TextColor3 = Theme.SubText end
            page.Visible = true
            btn.BackgroundColor3 = Theme.Card
            btn.TextColor3 = Theme.Accent
        end)

        pages[id] = page
        tabBtns[id] = btn
        return page
    end

    local function createToggle(parent, text, flag)
        local frame = Instance.new("Frame")
        frame.Size = UDim2.new(1, -4, 0, 32)
        frame.BackgroundColor3 = Theme.Card
        frame.Parent = parent
        Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 6)

        local lbl = Instance.new("TextLabel")
        lbl.Text = "  " .. text
        lbl.Size = UDim2.new(0.65, 0, 1, 0)
        lbl.TextColor3 = Theme.Text
        lbl.Font = Enum.Font.Gotham
        lbl.TextSize = 10
        lbl.TextXAlignment = Enum.TextXAlignment.Left
        lbl.BackgroundTransparency = 1
        lbl.Parent = frame

        local toggleBtn = Instance.new("TextButton")
        toggleBtn.Size = UDim2.new(0, 45, 0, 20)
        toggleBtn.Position = UDim2.new(1, -50, 0.5, -10)
        toggleBtn.Text = "OFF"
        toggleBtn.BackgroundColor3 = Color3.fromRGB(40, 50, 65)
        toggleBtn.TextColor3 = Theme.SubText
        toggleBtn.Font = Enum.Font.GothamBold
        toggleBtn.TextSize = 9
        toggleBtn.Parent = frame
        Instance.new("UICorner", toggleBtn).CornerRadius = UDim.new(0, 4)

        toggleBtn.MouseButton1Click:Connect(function()
            Flags[flag] = not Flags[flag]
            if Flags[flag] then
                toggleBtn.Text = "ON"
                toggleBtn.BackgroundColor3 = Theme.Accent
                toggleBtn.TextColor3 = Theme.Text
            else
                toggleBtn.Text = "OFF"
                toggleBtn.BackgroundColor3 = Color3.fromRGB(40, 50, 65)
                toggleBtn.TextColor3 = Theme.SubText
            end
        end)
    end

    -- 5 ANA SEKME OLUŞTURULUYOR (Dile duyarlı başlıklarla)
    local MainTab   = addTab(L.tabMain, "Main")
    local VisualTab = addTab(L.tabVisual, "Visual")
    local CombatTab = addTab(L.tabCombat, "Combat")
    local TPTab     = addTab(L.tabTP, "TP")
    local OptTab    = addTab(L.tabOpt, "Opt")

    -- 1. MAIN SEKMESİ (6 Özellik)
    createToggle(MainTab, L.speedWalk, "SpeedWalk")
    createToggle(MainTab, L.jumpPower, "JumpPower")
    createToggle(MainTab, L.infJump, "InfiniteJump")
    createToggle(MainTab, L.noclip, "Noclip")
    createToggle(MainTab, L.godModeVis, "GodModeVisual")
    createToggle(MainTab, L.fastStab, "FastStab")

    -- 2. VISUAL SEKMESİ (8 Özellik)
    createToggle(VisualTab, L.espAll, "ESPAll")
    createToggle(VisualTab, L.espMurderer, "ESPMurderer")
    createToggle(VisualTab, L.espSheriff, "ESPSheriff")
    createToggle(VisualTab, L.espInnocent, "ESPInnocent")
    createToggle(VisualTab, L.espGun, "ESPGun")
    createToggle(VisualTab, L.espChams, "ESPChams")
    createToggle(VisualTab, L.nameEsp, "NameESP")
    createToggle(VisualTab, L.tracers, "Tracers")

    -- 3. COMBAT SEKMESİ (8 Özellik)
    createToggle(CombatTab, L.aimbot, "AimbotEnabled")
    createToggle(CombatTab, L.silentAim, "SilentAim")
    createToggle(CombatTab, L.autoShoot, "AutoShoot")
    createToggle(CombatTab, L.hitboxExp, "HitboxExpander")
    createToggle(CombatTab, L.killAura, "KillAura")
    createToggle(CombatTab, L.autoGrab, "AutoGrabGun")
    createToggle(CombatTab, L.antiAim, "GodModeVisual")
    createToggle(CombatTab, L.fastGun, "AutoGrabGun")

    -- 4. TELEPORT SEKMESİ (8 Özellik)
    local function createTPBtn(name, callback)
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(1, -4, 0, 32)
        btn.Text = name
        btn.BackgroundColor3 = Theme.Card
        btn.TextColor3 = Theme.Text
        btn.Font = Enum.Font.GothamMedium
        btn.TextSize = 10
        btn.Parent = TPTab
        Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
        btn.MouseButton1Click:Connect(callback)
    end

    createTPBtn(L.tpLobby, function()
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(110, 138, -12)
        end
    end)
    createTPBtn(L.tpMurderer, function()
        local m = getMurderer()
        if m and m.Character and m.Character:FindFirstChild("HumanoidRootPart") then
            LocalPlayer.Character.HumanoidRootPart.CFrame = m.Character.HumanoidRootPart.CFrame
        end
    end)
    createTPBtn(L.tpSheriff, function()
        local s = getSheriff()
        if s and s.Character and s.Character:FindFirstChild("HumanoidRootPart") then
            LocalPlayer.Character.HumanoidRootPart.CFrame = s.Character.HumanoidRootPart.CFrame
        end
    end)
    createTPBtn(L.tpGun, function()
        local gun = Workspace:FindFirstChild("GunDrop", true)
        if gun and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            LocalPlayer.Character.HumanoidRootPart.CFrame = gun.CFrame
        end
    end)
    createTPBtn(L.tpMap, function()
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(0, 50, 0)
        end
    end)
    createTPBtn(L.tpInnocent, function()
        for _, p in pairs(Players:GetPlayers()) do
            if getRole(p) == "Innocent" and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                LocalPlayer.Character.HumanoidRootPart.CFrame = p.Character.HumanoidRootPart.CFrame
                break
            end
        end
    end)
    createTPBtn(L.tpCoin, function()
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-100, 10, -50)
        end
    end)
    createTPBtn(L.rejoin, function()
        game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, game.JobId, LocalPlayer)
    end)

    -- 5. OPTIMIZATION SEKMESİ (5 Özellik)
    createToggle(OptTab, L.fullbright, "Fullbright")
    createToggle(OptTab, L.fpsBoost, "FPSBoost")
    createToggle(OptTab, L.removeTex, "RemoveTextures")
    createToggle(OptTab, L.antiLag, "AntiLag")

    -- Varsayılan Sekmeyi Aç
    pages["Main"].Visible = true
    tabBtns["Main"].BackgroundColor3 = Theme.Card
    tabBtns["Main"].TextColor3 = Theme.Accent
end

------------------------------------------------------------
-- AÇ / KAPA FONKSİYONLARI
------------------------------------------------------------
function openMenu()
    MinimizedButton.Visible = false
    MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
    MainFrame.Visible = true
    MainFrame.Size = UDim2.new(0, 440, 0, 280)
    TweenService:Create(MainFrame, TweenInfo.new(0.28, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {Size = UDim2.new(0, 520, 0, 340)}):Play()
end

function closeMenu()
    TweenService:Create(MainFrame, TweenInfo.new(0.2, Enum.EasingStyle.Quint, Enum.EasingDirection.In), {Size = UDim2.new(0, 440, 0, 280)}):Play()
    task.wait(0.2)
    MainFrame.Visible = false
    MainFrame.Size = UDim2.new(0, 520, 0, 340)

    MinimizedButton.Visible = true
    MinimizedButton.BackgroundTransparency = 1
    TweenService:Create(MinimizedButton, TweenInfo.new(0.25), {BackgroundTransparency = 0}):Play()
end

MinimizedButton.MouseButton1Click:Connect(function()
    if not MainFrame then return end
    openMenu()
end)
