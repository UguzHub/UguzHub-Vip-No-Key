-- [[ UguzHub V2 Pro - Full Dynamic Localization & Custom Intro ]] --

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local Clipboard = setclipboard or toclipboard or syn and syn.clipboard

local LocalPlayer = Players.LocalPlayer

------------------------------------------------------------
-- 0) HESAP YAŞ KONTROLÜ (14 GÜN)
------------------------------------------------------------
if LocalPlayer.AccountAge < 14 then
    LocalPlayer:Kick("Your account is less than 14 days old.")
    return
end

local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local Camera = Workspace.CurrentCamera

------------------------------------------------------------
-- TEMA & AYARLAR
------------------------------------------------------------
local Theme = {
    Background   = Color3.fromRGB(16, 16, 22),
    Sidebar      = Color3.fromRGB(20, 20, 28),
    Card         = Color3.fromRGB(30, 30, 40),
    Accent       = Color3.fromRGB(138, 92, 255),
    AccentSoft   = Color3.fromRGB(90, 60, 180),
    Blue         = Color3.fromRGB(41, 121, 255),
    BlueSoft     = Color3.fromRGB(70, 150, 255),
    Text         = Color3.fromRGB(235, 235, 245),
    SubText      = Color3.fromRGB(165, 165, 180),
    Stroke       = Color3.fromRGB(55, 55, 70),
}

local CARD_TRANSPARENCY = 0.25
local RADIUS = 16

------------------------------------------------------------
-- DİL PAKETLERİ (EKSİKSİZ TAM ÇEVİRİ)
------------------------------------------------------------
local Lang = {
    TR = {
        loading = "Yükleniyor", subtitle = "Dilinizi Seçin", greeting = "Bugün nasılsın", sectionTitle = "Ayarlar", openBtn = "UguzHub", 
        warningText = "Lütfen Delta Ayarlarındaki Tüm Her Şeyi Kapattığınızdan Emin Olun. Oyun Deneyiminizi En Üst Seviyeye Çıkarmak İstiyoruz",
        discordBtn = "Discord Bağlantısını Kopyala", discordCopied = "Discord Bağlantısı Kopyalandı!",
        espAll = "ESP Herkesi Göster", espGun = "ESP Yerdeki Silah", autoGrab = "Oto Silah Al", tpGrab = "Işınlanıp Silahı Al",
        aimbot = "Aimbot Kilitle", autoKillMurd = "Oto Katili Öldür", killMurd = "Katili Öldür", killAll = "Herkesi Öldür (Katil)",
        autoFlingMurd = "Katili Savur (Fling)", autoFlingSheriff = "Şerifi Savur (Fling)", autoFlingAll = "Herkesi Savur (Fling)",
        tpLobby = "Lobiye Işınlan", tpMap = "Haritaya Işınlan", tpMurd = "Katile Işınlan", tpSheriff = "Şerife Işınlan",
        tabESP = "ESP", tabAimbot = "Aimbot", tabPlayers = "Oyuncular", tabTP = "Işınlanma", tabSettings = "Ayarlar"
    },
    EN = {
        loading = "Loading", subtitle = "Select your language", greeting = "How are you today", sectionTitle = "Settings", openBtn = "UguzHub", 
        warningText = "Please Make Sure To Turn Off Everything In Delta Settings. We Want To Maximize Your Gaming Experience",
        discordBtn = "Copy Discord Link", discordCopied = "Discord Link Copied!",
        espAll = "ESP All Players", espGun = "ESP Dropped Gun", autoGrab = "Auto Grab Gun", tpGrab = "TP Grab Gun",
        aimbot = "Aimbot Lock", autoKillMurd = "Auto Kill Murderer", killMurd = "Kill Murderer", killAll = "Kill All (As Murderer)",
        autoFlingMurd = "Auto Fling Murderer", autoFlingSheriff = "Auto Fling Sheriff", autoFlingAll = "Auto Fling All",
        tpLobby = "TP to Lobby", tpMap = "TP to Map", tpMurd = "TP to Murderer", tpSheriff = "TP to Sheriff",
        tabESP = "ESP", tabAimbot = "Aimbot", tabPlayers = "Players", tabTP = "Teleport", tabSettings = "Settings"
    },
    RU = {
        loading = "Загрузка", subtitle = "Выберите язык", greeting = "Как дела сегодня", sectionTitle = "Настройки", openBtn = "UguzHub", 
        warningText = "Пожалуйста, убедитесь, что вы отключили все в настройках Delta. Мы хотим максимизировать ваш игровой опыт",
        discordBtn = "Копировать ссылку Discord", discordCopied = "Ссылка скопирована!",
        espAll = "ESP Все Игроки", espGun = "ESP Оружие на полу", autoGrab = "Авто Подбор Оружия", tpGrab = "ТП Подбор Оружия",
        aimbot = "Аимбот Захват", autoKillMurd = "Авто Убийство Убийцы", killMurd = "Убить Убийцу", killAll = "Убить Всех (За Убийцу)",
        autoFlingMurd = "Авто Флинг Убийцы", autoFlingSheriff = "Авто Флинг Шерифа", autoFlingAll = "Авто Флинг Всех",
        tpLobby = "ТП в Лобби", tpMap = "ТП на Карту", tpMurd = "ТП к Убийце", tpSheriff = "ТП к Шерифу",
        tabESP = "ESP", tabAimbot = "Аимбот", tabPlayers = "Игроки", tabTP = "Телепорт", tabSettings = "Настройки"
    },
    DE = {
        loading = "Wird geladen", subtitle = "Wähle deine Sprache", greeting = "Wie geht es dir heute", sectionTitle = "Einstellungen", openBtn = "UguzHub", 
        warningText = "Bitte stelle sicher, dass du alles in den Delta-Einstellungen ausgeschaltet hast.",
        discordBtn = "Discord-Link kopieren", discordCopied = "Link kopiert!",
        espAll = "ESP Alle Spieler", espGun = "ESP Waffe am Boden", autoGrab = "Auto Waffe aufheben", tpGrab = "TP Waffe aufheben",
        aimbot = "Aimbot Sperre", autoKillMurd = "Auto Mörder töten", killMurd = "Mörder töten", killAll = "Alle töten (Als Mörder)",
        autoFlingMurd = "Auto Mörder Fling", autoFlingSheriff = "Auto Sheriff Fling", autoFlingAll = "Auto Alle Fling",
        tpLobby = "TP zur Lobby", tpMap = "TP zur Karte", tpMurd = "TP zum Mörder", tpSheriff = "TP zum Sheriff",
        tabESP = "ESP", tabAimbot = "Aimbot", tabPlayers = "Spieler", tabTP = "Teleport", tabSettings = "Einstellungen"
    },
    FR = {
        loading = "Chargement", subtitle = "Choisissez votre langue", greeting = "Comment vas-tu aujourd'hui", sectionTitle = "Paramètres", openBtn = "UguzHub", 
        warningText = "Veuillez vous assurer de tout désactiver dans les paramètres Delta.",
        discordBtn = "Copier le lien Discord", discordCopied = "Lien copié !",
        espAll = "ESP Tous les Joueurs", espGun = "ESP Arme au Sol", autoGrab = "Auto Ramasser Arme", tpGrab = "TP Ramasser Arme",
        aimbot = "Aimbot Verrouillage", autoKillMurd = "Auto Tuer Meurtrier", killMurd = "Tuer Meurtrier", killAll = "Tuer Tous (Meurtrier)",
        autoFlingMurd = "Auto Fling Meurtrier", autoFlingSheriff = "Auto Fling Shérif", autoFlingAll = "Auto Fling Tous",
        tpLobby = "TP au Lobby", tpMap = "TP à la Carte", tpMurd = "TP au Meurtrier", tpSheriff = "TP au Shérif",
        tabESP = "ESP", tabAimbot = "Aimbot", tabPlayers = "Joueurs", tabTP = "Téléportation", tabSettings = "Paramètres"
    },
    ES = {
        loading = "Cargando", subtitle = "Selecciona tu idioma", greeting = "¿Cómo estás hoy", sectionTitle = "Ajustes", openBtn = "UguzHub", 
        warningText = "Asegúrate de desactivar todo en la configuración de Delta.",
        discordBtn = "Copiar enlace de Discord", discordCopied = "¡Enlace copiado!",
        espAll = "ESP Todos los Jugadores", espGun = "ESP Arma en Suelo", autoGrab = "Auto Recoger Arma", tpGrab = "TP Recoger Arma",
        aimbot = "Aimbot Fijar", autoKillMurd = "Auto Matar Asesino", killMurd = "Matar Asesino", killAll = "Matar Todos (Asesino)",
        autoFlingMurd = "Auto Fling Asesino", autoFlingSheriff = "Auto Fling Alguacil", autoFlingAll = "Auto Fling Todos",
        tpLobby = "TP al Lobby", tpMap = "TP al Mapa", tpMurd = "TP al Asesino", tpSheriff = "TP al Alguacil",
        tabESP = "ESP", tabAimbot = "Aimbot", tabPlayers = "Jugadores", tabTP = "Teletransporte", tabSettings = "Ajustes"
    },
    AR = {
        loading = "جار التحميل", subtitle = "اختر لغتك", greeting = "كيف حالك اليوم", sectionTitle = "الإعدادات", openBtn = "UguzHub", 
        warningText = "يرجى التأكد من إيقاف تشغيل كل شيء في إعدادات ديلتا.",
        discordBtn = "نسخ رابط ديسكورد", discordCopied = "تم النسخ!",
        espAll = "رؤية الجميع ESP", espGun = "رؤية السلاح ESP", autoGrab = "التقاط السلاح تلقائياً", tpGrab = "الانتقال السريع للسلاح",
        aimbot = "التصويب التلقائي", autoKillMurd = "قتل القاتل تلقائياً", killMurd = "قتل القاتل", killAll = "قتل الجميع",
        autoFlingMurd = "رمي القاتل تلقائياً", autoFlingSheriff = "رمي الشريف تلقائياً", autoFlingAll = "رمي الجميع",
        tpLobby = "انتقال للانتظار", tpMap = "انتقال للخريطة", tpMurd = "انتقال للقاتل", tpSheriff = "انتقال للشريف",
        tabESP = "رؤية", tabAimbot = "تصويب", tabPlayers = "اللاعبون", tabTP = "الانتقال", tabSettings = "الإعدادات"
    },
    ZH = {
        loading = "加载中", subtitle = "选择你的语言", greeting = "你今天好吗", sectionTitle = "设置", openBtn = "UguzHub", 
        warningText = "请确保关闭 Delta 设置中的所有内容。",
        discordBtn = "复制 Discord 链接", discordCopied = "已复制链接！",
        espAll = "ESP 显示所有玩家", espGun = "ESP 显示地上枪械", autoGrab = "自动捡枪", tpGrab = "传送捡枪",
        aimbot = "自瞄锁定", autoKillMurd = "自动击杀杀手", killMurd = "击杀杀手", killAll = "全杀（仅限杀手）",
        autoFlingMurd = "自动甩飞杀手", autoFlingSheriff = "自动甩飞警官", autoFlingAll = "自动甩飞所有人",
        tpLobby = "传送到大厅", tpMap = "传送到地图", tpMurd = "传送到杀手", tpSheriff = "传送到警官",
        tabESP = "透视", tabAimbot = "自瞄", tabPlayers = "玩家", tabTP = "传送", tabSettings = "设置"
    }
}

local LanguageOptions = {
    { code = "TR", flag = "🇹🇷", name = "Türkçe" },
    { code = "EN", flag = "🇬🇧", name = "English" },
    { code = "RU", flag = "🇷🇺", name = "Русский" },
    { code = "DE", flag = "🇩🇪", name = "Deutsch" },
    { code = "FR", flag = "🇫🇷", name = "Français" },
    { code = "ES", flag = "🇪🇸", name = "Español" },
    { code = "AR", flag = "🇸🇦", name = "العربية" },
    { code = "ZH", flag = "🇨🇳", name = "中文" },
}

local CurrentLang = "EN"
local L = Lang[CurrentLang]

------------------------------------------------------------
-- HİLE DURUM BAYRAKLARI (FLAGS) & MOTORLAR
------------------------------------------------------------
local Flags = {
    ESPAll = false, ESPGun = false, AutoGrabGun = false,
    AimbotEnabled = false, AutoKillMurderer = false,
    AutoFlingMurderer = false, AutoFlingSheriff = false, AutoFlingAll = false
}

local RoleColors = {
    Murderer = Color3.fromRGB(239, 68, 68),
    Sheriff = Color3.fromRGB(59, 130, 246),
    Innocent = Color3.fromRGB(34, 197, 94),
    Gun = Color3.fromRGB(234, 179, 8)
}

local function getRole(player)
    if not player or not player.Character then return "Innocent" end
    if player.Backpack:FindFirstChild("Knife") or player.Character:FindFirstChild("Knife") then return "Murderer" end
    if player.Backpack:FindFirstChild("Gun") or player.Character:FindFirstChild("Gun") then return "Sheriff" end
    return "Innocent"
end

local function superFling(targetPlayer)
    if not targetPlayer or targetPlayer == LocalPlayer or not targetPlayer.Character then return end
    local myChar, targetChar = LocalPlayer.Character, targetPlayer.Character
    local myHrp = myChar and myChar:FindFirstChild("HumanoidRootPart")
    local targetHrp = targetChar and targetChar:FindFirstChild("HumanoidRootPart")
    if not myHrp or not targetHrp then return end

    local oldCFrame = myHrp.CFrame
    local bav = Instance.new("BodyAngularVelocity")
    bav.Name = "UltraFlingForce"
    bav.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
    bav.AngularVelocity = Vector3.new(0, 9999999, 0)
    bav.Parent = myHrp

    for i = 1, 15 do
        if not targetHrp or not targetHrp.Parent or not myHrp or not myHrp.Parent then break end
        for _, part in pairs(myChar:GetChildren()) do if part:IsA("BasePart") then part.CanCollide = false end end
        myHrp.AssemblyLinearVelocity = Vector3.new(999999, 999999, 999999)
        myHrp.AssemblyAngularVelocity = Vector3.new(999999, 999999, 999999)
        myHrp.CFrame = targetHrp.CFrame * CFrame.new(math.random(-1, 1), 0, math.random(-1, 1))
        task.wait(0.01)
    end

    bav:Destroy()
    myHrp.AssemblyLinearVelocity = Vector3.zero
    myHrp.AssemblyAngularVelocity = Vector3.zero
    myHrp.CFrame = oldCFrame
end

task.spawn(function()
    while task.wait(0.15) do
        if Flags.AutoFlingMurderer then
            for _, p in pairs(Players:GetPlayers()) do if p ~= LocalPlayer and getRole(p) == "Murderer" then superFling(p) end end
        end
        if Flags.AutoFlingSheriff then
            for _, p in pairs(Players:GetPlayers()) do if p ~= LocalPlayer and getRole(p) == "Sheriff" then superFling(p) end end
        end
        if Flags.AutoFlingAll then
            for _, p in pairs(Players:GetPlayers()) do if p ~= LocalPlayer then superFling(p) end end
        end
    end
end)

------------------------------------------------------------
-- ARAYÜZ YARDIMCILARI
------------------------------------------------------------
local function create(class, props, children)
    local inst = Instance.new(class)
    for prop, value in pairs(props or {}) do inst[prop] = value end
    for _, child in ipairs(children or {}) do child.Parent = inst end
    return inst
end

local function corner(radius) return create("UICorner", { CornerRadius = UDim.new(0, radius or RADIUS) }) end
local function stroke(color, thickness) return create("UIStroke", { Color = color or Theme.Stroke, Thickness = thickness or 1, Transparency = 0.4 }) end
local function tween(obj, props, duration, style, direction)
    local info = TweenInfo.new(duration or 0.3, style or Enum.EasingStyle.Quint, direction or Enum.EasingDirection.Out)
    local t = TweenService:Create(obj, info, props)
    t:Play()
    return t
end

------------------------------------------------------------
-- ANA GUI
------------------------------------------------------------
local ScreenGui = create("ScreenGui", { Name = "UguzHubV2Pro", ResetOnSpawn = false, ZIndexBehavior = Enum.ZIndexBehavior.Sibling, DisplayOrder = 999, IgnoreGuiInset = true })
ScreenGui.Parent = PlayerGui

------------------------------------------------------------
-- DİNAMİK AÇILIŞ ANIMASYONLU GİRİŞ EKRANI
------------------------------------------------------------
local IntroFrame = create("Frame", { Name = "Intro", Size = UDim2.fromScale(1, 1), Position = UDim2.fromScale(0, 0), BackgroundColor3 = Theme.Background, ZIndex = 10 })
IntroFrame.Parent = ScreenGui

local IntroContent = create("Frame", { Name = "IntroContent", AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.new(0.5, 0, 0.5, 0), Size = UDim2.new(0, 420, 0, 340), BackgroundTransparency = 1, ZIndex = 11 })
IntroContent.Parent = IntroFrame

local LogoLabel = create("TextLabel", { Text = "UguzHub", Font = Enum.Font.GothamBlack, TextSize = 44, TextColor3 = Theme.Text, BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 45), Position = UDim2.new(0, 0, 0, -130), TextTransparency = 1, ZIndex = 11, TextXAlignment = Enum.TextXAlignment.Center })
LogoLabel.Parent = IntroContent

local ProTag = create("TextLabel", { Text = "V2 PRO", Font = Enum.Font.GothamBold, TextSize = 16, TextColor3 = Theme.Accent, BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 20), Position = UDim2.new(0, 0, 0, -85), TextTransparency = 1, ZIndex = 11, TextXAlignment = Enum.TextXAlignment.Center })
ProTag.Parent = IntroContent

local LoadingLabel = create("TextLabel", { Text = L.loading, Font = Enum.Font.GothamMedium, TextSize = 15, TextColor3 = Theme.SubText, BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 24), Position = UDim2.new(0, 0, 0, -45), TextTransparency = 1, ZIndex = 11, TextXAlignment = Enum.TextXAlignment.Center })
LoadingLabel.Parent = IntroContent

local SubtitleLabel = create("TextLabel", { Text = L.subtitle, Font = Enum.Font.Gotham, TextSize = 14, TextColor3 = Theme.SubText, BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 22), Position = UDim2.new(0, 0, 0, -115), TextTransparency = 1, ZIndex = 11, Visible = false, TextXAlignment = Enum.TextXAlignment.Center })
SubtitleLabel.Parent = IntroContent

local LangHolder = create("Frame", { Name = "LangHolder", AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.new(0.5, 0, 0.5, 15), Size = UDim2.new(0, 400, 0, 180), BackgroundTransparency = 1, ZIndex = 11, Visible = false })
LangHolder.Parent = IntroContent

create("UIGridLayout", { CellSize = UDim2.new(0, 92, 0, 75), CellPadding = UDim2.new(0, 8, 0, 8), HorizontalAlignment = Enum.HorizontalAlignment.Center, VerticalAlignment = Enum.VerticalAlignment.Center }).Parent = LangHolder

------------------------------------------------------------
-- MİNİMİZE BUTON
------------------------------------------------------------
local MinimizedButton = create("TextButton", { Name = "MinimizedButton", Text = "🔵 " .. L.openBtn, Font = Enum.Font.GothamBold, TextSize = 15, TextColor3 = Theme.Text, BackgroundColor3 = Theme.Blue, Size = UDim2.new(0, 118, 0, 38), Position = UDim2.new(1, -134, 0, 16), AutoButtonColor = false, Visible = false, ZIndex = 8 })
corner(12).Parent = MinimizedButton
stroke(Color3.fromRGB(255, 255, 255), 1).Parent = MinimizedButton
MinimizedButton.Parent = ScreenGui

------------------------------------------------------------
-- UYARI EKRANI & ANA MENÜ SİSTEMİ
------------------------------------------------------------
local MainFrame, buildMainMenu, closeMenu, openMenu

local function showWarningScreen()
    local WarnFrame = create("Frame", { Name = "WarnFrame", Size = UDim2.fromScale(1, 1), Position = UDim2.fromScale(0, 0), BackgroundColor3 = Theme.Background, BackgroundTransparency = 1, ZIndex = 20 })
    WarnFrame.Parent = ScreenGui

    local WarnBox = create("Frame", { Size = UDim2.new(0, 400, 0, 190), Position = UDim2.fromScale(0.5, 0.5), AnchorPoint = Vector2.new(0.5, 0.5), BackgroundColor3 = Theme.Card, BackgroundTransparency = 1, ZIndex = 21 })
    corner(16).Parent = WarnBox
    stroke(Theme.Accent, 1.5).Parent = WarnBox
    WarnBox.Parent = WarnFrame

    local WarnText = create("TextLabel", { Text = "", Font = Enum.Font.GothamBold, TextSize = 14, TextColor3 = Theme.Text, TextWrapped = true, TextXAlignment = Enum.TextXAlignment.Center, TextYAlignment = Enum.TextYAlignment.Center, Size = UDim2.new(1, -40, 1, -40), Position = UDim2.fromScale(0.5, 0.5), AnchorPoint = Vector2.new(0.5, 0.5), BackgroundTransparency = 1, TextTransparency = 1, ZIndex = 22 })
    WarnText.Parent = WarnBox

    tween(WarnFrame, { BackgroundTransparency = 0.2 }, 0.4)
    tween(WarnBox, { BackgroundTransparency = CARD_TRANSPARENCY }, 0.4)
    tween(WarnText, { TextTransparency = 0 }, 0.4)

    task.spawn(function()
        for i = 4, 1, -1 do
            WarnText.Text = L.warningText .. " (" .. i .. ")"
            task.wait(1)
        end
        
        tween(WarnFrame, { BackgroundTransparency = 1 }, 0.5)
        tween(WarnBox, { BackgroundTransparency = 1 }, 0.5)
        tween(WarnText, { TextTransparency = 1 }, 0.5)
        task.wait(0.5)
        WarnFrame:Destroy()

        buildMainMenu()
        MinimizedButton.Text = "🔵 " .. L.openBtn
        MinimizedButton.Visible = true
        MinimizedButton.BackgroundTransparency = 1
        tween(MinimizedButton, { BackgroundTransparency = 0 }, 0.3)
    end)
end

------------------------------------------------------------
-- DİL SEÇİMİ VE TAM DİL DEĞİŞİMİ
------------------------------------------------------------
local langCards = {}

local function selectLanguage(code)
    CurrentLang = code
    L = Lang[CurrentLang]

    for _, card in ipairs(langCards) do
        local isSelected = card:GetAttribute("Code") == code
        tween(card, { BackgroundColor3 = isSelected and Theme.Accent or Theme.Card }, 0.2)
    end

    task.delay(0.2, function()
        tween(IntroFrame, { BackgroundTransparency = 1 }, 0.4)
        for _, obj in ipairs({ LogoLabel, ProTag, SubtitleLabel }) do tween(obj, { TextTransparency = 1 }, 0.3) end
        for _, card in ipairs(langCards) do tween(card, { BackgroundTransparency = 1 }, 0.25) end
        task.wait(0.4)
        IntroFrame.Visible = false

        showWarningScreen()
    end)
end

for i, opt in ipairs(LanguageOptions) do
    local card = create("TextButton", { Name = opt.code, Text = "", AutoButtonColor = false, BackgroundColor3 = Theme.Card, BackgroundTransparency = 1, LayoutOrder = i, ZIndex = 11 })
    corner(12).Parent = card
    stroke().Parent = card
    card:SetAttribute("Code", opt.code)

    create("TextLabel", { Text = opt.flag, Font = Enum.Font.GothamBold, TextSize = 22, BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 28), Position = UDim2.new(0, 0, 0, 10), TextXAlignment = Enum.TextXAlignment.Center, ZIndex = 12 }).Parent = card
    create("TextLabel", { Text = opt.name, Font = Enum.Font.GothamMedium, TextSize = 11, TextColor3 = Theme.Text, BackgroundTransparency = 1, Size = UDim2.new(1, -4, 0, 18), Position = UDim2.new(0, 2, 0, 42), TextXAlignment = Enum.TextXAlignment.Center, ZIndex = 12 }).Parent = card

    card.MouseButton1Click:Connect(function() selectLanguage(opt.code) end)
    card.Parent = LangHolder
    table.insert(langCards, card)
end

------------------------------------------------------------
-- 7 SANİYELİK ÖZEL AÇILIŞ ANIMASYONU
------------------------------------------------------------
task.defer(function()
    tween(LogoLabel, { TextTransparency = 0 }, 0.5)
    tween(ProTag, { TextTransparency = 0 }, 0.5)
    task.wait(0.2)
    tween(LoadingLabel, { TextTransparency = 0 }, 0.3)

    local dotsRunning = true
    task.spawn(function()
        local states = { L.loading, L.loading .. ".", L.loading .. "..", L.loading .. "..." }
        local i = 1
        while dotsRunning do
            LoadingLabel.Text = states[i]
            i = (i % #states) + 1
            task.wait(0.4)
        end
    end)

    task.wait(7.0) -- TAM 7 SANİYE YÜKLEME ANIMASYONU
    dotsRunning = false

    tween(LoadingLabel, { TextTransparency = 1 }, 0.3)
    task.wait(0.3)
    LoadingLabel.Visible = false

    SubtitleLabel.Text = L.subtitle
    SubtitleLabel.Visible = true
    LangHolder.Visible = true
    tween(SubtitleLabel, { TextTransparency = 0 }, 0.4)
    for i, card in ipairs(langCards) do
        card.BackgroundTransparency = 1
        task.delay(0.02 * i, function() tween(card, { BackgroundTransparency = 0 }, 0.25) end)
    end
end)

------------------------------------------------------------
-- DİNAMİK ANA MENÜ OLUŞTURMA (SEÇİLEN DİLE GÖRE)
------------------------------------------------------------
local MENU_W, MENU_H = 480, 280

function buildMainMenu()
    if MainFrame then MainFrame:Destroy() end

    MainFrame = create("Frame", { Name = "MainMenu", Size = UDim2.new(0, MENU_W, 0, MENU_H), Position = UDim2.new(0.5, 0, 0.5, 0), AnchorPoint = Vector2.new(0.5, 0.5), BackgroundColor3 = Theme.Background, ClipsDescendants = true, ZIndex = 5 })
    corner(RADIUS).Parent = MainFrame
    stroke(Theme.Accent, 1.5).Parent = MainFrame
    MainFrame.Parent = ScreenGui

    local BackgroundArt = create("ImageLabel", { Name = "BackgroundArt", Image = "rbxassetid://15732257423", Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1, ImageTransparency = 0.15, ScaleType = Enum.ScaleType.Crop, ZIndex = 1 })
    corner(RADIUS).Parent = BackgroundArt
    BackgroundArt.Parent = MainFrame

    local TopBar = create("Frame", { Size = UDim2.new(1, 0, 0, 36), BackgroundColor3 = Theme.Sidebar, BackgroundTransparency = CARD_TRANSPARENCY, ZIndex = 6, Active = true })
    corner(RADIUS).Parent = TopBar
    TopBar.Parent = MainFrame

    create("TextLabel", { Text = "UguzHub  •  V2 Pro", Font = Enum.Font.GothamBold, TextSize = 13, TextColor3 = Theme.Text, BackgroundTransparency = 1, Size = UDim2.new(1, -56, 1, 0), Position = UDim2.new(0, 12, 0, 0), TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 7 }).Parent = TopBar

    local MinimizeBtn = create("TextButton", { Text = "–", Font = Enum.Font.GothamBold, TextSize = 18, TextColor3 = Theme.SubText, BackgroundTransparency = 1, Size = UDim2.new(0, 32, 0, 32), Position = UDim2.new(1, -34, 0, 2), ZIndex = 7 })
    MinimizeBtn.Parent = TopBar
    MinimizeBtn.MouseButton1Click:Connect(function() closeMenu() end)

    local Sidebar = create("Frame", { Size = UDim2.new(0, 110, 1, -42), Position = UDim2.new(0, 6, 0, 40), BackgroundColor3 = Theme.Sidebar, BackgroundTransparency = CARD_TRANSPARENCY, ZIndex = 6 })
    corner(10).Parent = Sidebar
    Sidebar.Parent = MainFrame

    local TabContainer = create("Frame", { Size = UDim2.new(1, -128, 1, -42), Position = UDim2.new(0, 122, 0, 40), BackgroundTransparency = 1, ZIndex = 6 })
    TabContainer.Parent = MainFrame

    create("UIListLayout", { SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 4) }).Parent = Sidebar

    local pages = {}
    local tabBtns = {}

    local function addTab(name, icon)
        local btn = create("TextButton", { Size = UDim2.new(1, 0, 0, 30), BackgroundColor3 = Theme.Card, BackgroundTransparency = 0.5, Font = Enum.Font.GothamMedium, Text = icon .. " " .. name, TextColor3 = Theme.SubText, TextSize = 11, TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 7 })
        corner(8).Parent = btn
        btn.Parent = Sidebar

        local page = create("ScrollingFrame", { Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1, BorderSizePixel = 0, ScrollBarThickness = 2, Visible = false, ZIndex = 7 })
        page.Parent = TabContainer
        create("UIListLayout", { SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 6) }).Parent = page

        pages[name] = page
        tabBtns[name] = btn

        btn.MouseButton1Click:Connect(function()
            for _, p in pairs(pages) do p.Visible = false end
            for _, b in pairs(tabBtns) do b.BackgroundColor3 = Theme.Card; b.TextColor3 = Theme.SubText end
            page.Visible = true
            btn.BackgroundColor3 = Theme.Accent
            btn.TextColor3 = Theme.Text
        end)
        return page
    end

    local function createToggle(parent, labelText, flag)
        local frame = create("Frame", { Size = UDim2.new(1, -6, 0, 30), BackgroundColor3 = Theme.Card, BackgroundTransparency = CARD_TRANSPARENCY })
        corner(8).Parent = frame
        frame.Parent = parent

        create("TextLabel", { Text = labelText, Font = Enum.Font.Gotham, TextColor3 = Theme.Text, TextSize = 10, BackgroundTransparency = 1, Size = UDim2.new(0.7, 0, 1, 0), Position = UDim2.new(0, 8, 0, 0), TextXAlignment = Enum.TextXAlignment.Left }).Parent = frame

        local switch = create("Frame", { Size = UDim2.new(0, 28, 0, 14), Position = UDim2.new(1, -34, 0.5, -7), BackgroundColor3 = Color3.fromRGB(40, 40, 45) })
        corner(10).Parent = switch
        switch.Parent = frame

        local dot = create("Frame", { Size = UDim2.new(0, 10, 0, 10), Position = UDim2.new(0, 2, 0.5, -5), BackgroundColor3 = Color3.fromRGB(200, 200, 200) })
        corner(10).Parent = dot
        dot.Parent = switch

        local btn = create("TextButton", { Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1, Text = "" })
        btn.Parent = frame

        btn.MouseButton1Click:Connect(function()
            Flags[flag] = not Flags[flag]
            if Flags[flag] then
                switch.BackgroundColor3 = Theme.Accent
                dot.Position = UDim2.new(1, -12, 0.5, -5)
                dot.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            else
                switch.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
                dot.Position = UDim2.new(0, 2, 0.5, -5)
                dot.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
            end
        end)
    end

    local function createButton(parent, labelText, callback)
        local btn = create("TextButton", { Size = UDim2.new(1, -6, 0, 30), BackgroundColor3 = Theme.Card, Font = Enum.Font.GothamBold, Text = labelText, TextColor3 = Theme.Text, TextSize = 10 })
        corner(8).Parent = btn
        stroke(Theme.Accent, 1).Parent = btn
        btn.Parent = parent
        btn.MouseButton1Click:Connect(function() if callback then callback() end end)
    end

    -- TABLAR VE METİNLER SEÇİLEN DİLE GÖRE YÜKLENİR (L.tabESP, L.espAll vb.)
    local ESPTab = addTab(L.tabESP, "👁")
    local AimbotTab = addTab(L.tabAimbot, "🎯")
    local PlayersTab = addTab(L.tabPlayers, "👤")
    local TeleportTab = addTab(L.tabTP, "🌀")
    local SettingsTab = addTab(L.tabSettings, "⚙")

    -- ESP TAB
    createToggle(ESPTab, L.espAll, "ESPAll")
    createToggle(ESPTab, L.espGun, "ESPGun")
    createToggle(ESPTab, L.autoGrab, "AutoGrabGun")
    createButton(ESPTab, L.tpGrab, function()
        local gunDrop = Workspace:FindFirstChild("GunDrop") or Workspace:FindFirstChild("Gun")
        local myHrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if gunDrop and myHrp then
            local oldCFrame = myHrp.CFrame
            myHrp.CFrame = gunDrop.CFrame
            task.wait(0.15)
            if firetouchinterest then firetouchinterest(myHrp, gunDrop, 0); firetouchinterest(myHrp, gunDrop, 1) end
            task.wait(0.1)
            myHrp.CFrame = oldCFrame
        end
    end)

    -- AIMBOT TAB
    createToggle(AimbotTab, L.aimbot, "AimbotEnabled")

    -- PLAYERS TAB
    createToggle(PlayersTab, L.autoKillMurd, "AutoKillMurderer")
    createButton(PlayersTab, L.killMurd, function()
        local myChar = LocalPlayer.Character
        if myChar and myChar:FindFirstChild("HumanoidRootPart") then
            for _, p in pairs(Players:GetPlayers()) do
                if p ~= LocalPlayer and getRole(p) == "Murderer" and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                    myChar.HumanoidRootPart.CFrame = p.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, 3)
                end
            end
        end
    end)
    createButton(PlayersTab, L.killAll, function()
        if getRole(LocalPlayer) == "Murderer" then
            local myChar = LocalPlayer.Character
            if myChar and myChar:FindFirstChild("HumanoidRootPart") then
                for _, p in pairs(Players:GetPlayers()) do
                    if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                        p.Character.HumanoidRootPart.CFrame = myChar.HumanoidRootPart.CFrame
                    end
                end
            end
        end
    end)
    createToggle(PlayersTab, L.autoFlingMurd, "AutoFlingMurderer")
    createToggle(PlayersTab, L.autoFlingSheriff, "AutoFlingSheriff")
    createToggle(PlayersTab, L.autoFlingAll, "AutoFlingAll")

    -- TELEPORT TAB
    createButton(TeleportTab, L.tpLobby, function()
        local myHrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if myHrp then myHrp.CFrame = CFrame.new(-108, 140, 82) end
    end)
    createButton(TeleportTab, L.tpMap, function()
        local myHrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if not myHrp then return end
        for _, child in pairs(Workspace:GetChildren()) do
            if child:FindFirstChild("Spawns") or child:FindFirstChild("CoinContainer") then
                local spawnPart = child:FindFirstChild("Spawns") and child.Spawns:FindFirstChildWhichIsA("BasePart") or child:FindFirstChildWhichIsA("BasePart", true)
                if spawnPart then myHrp.CFrame = spawnPart.CFrame + Vector3.new(0, 3, 0); break end
            end
        end
    end)
    createButton(TeleportTab, L.tpMurd, function()
        local myHrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if not myHrp then return end
        for _, p in pairs(Players:GetPlayers()) do if p ~= LocalPlayer and getRole(p) == "Murderer" and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then myHrp.CFrame = p.Character.HumanoidRootPart.CFrame + Vector3.new(0, 2, 0); break end end
    end)
    createButton(TeleportTab, L.tpSheriff, function()
        local myHrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if not myHrp then return end
        for _, p in pairs(Players:GetPlayers()) do if p ~= LocalPlayer and getRole(p) == "Sheriff" and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then myHrp.CFrame = p.Character.HumanoidRootPart.CFrame + Vector3.new(0, 2, 0); break end end
    end)

    -- SETTINGS TAB
    create("TextLabel", { Text = L.sectionTitle, Font = Enum.Font.GothamBold, TextSize = 13, TextColor3 = Theme.SubText, BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 18), TextXAlignment = Enum.TextXAlignment.Left }).Parent = SettingsTab

    local AvatarFrame = create("Frame", { Size = UDim2.new(0, 44, 0, 44), Position = UDim2.new(0, 4, 0, 24), BackgroundColor3 = Theme.Card, BackgroundTransparency = CARD_TRANSPARENCY })
    corner(22).Parent = AvatarFrame
    stroke(Theme.Accent, 2).Parent = AvatarFrame
    AvatarFrame.Parent = SettingsTab

    local AvatarImage = create("ImageLabel", { Size = UDim2.new(1, -4, 1, -4), Position = UDim2.new(0, 2, 0, 2), BackgroundTransparency = 1, Image = "rbxthumb://type=AvatarHeadShot&id=" .. LocalPlayer.UserId .. "&w=150&h=150" })
    corner(22).Parent = AvatarImage
    AvatarImage.Parent = AvatarFrame

    create("TextLabel", { Text = LocalPlayer.DisplayName .. " (@" .. LocalPlayer.Name .. ")", Font = Enum.Font.GothamBold, TextSize = 11, TextColor3 = Theme.Text, BackgroundTransparency = 1, Size = UDim2.new(1, -58, 0, 18), Position = UDim2.new(0, 56, 0, 25), TextXAlignment = Enum.TextXAlignment.Left }).Parent = SettingsTab
    create("TextLabel", { Text = L.greeting .. ", " .. LocalPlayer.DisplayName .. "?", Font = Enum.Font.Gotham, TextSize = 10, TextColor3 = Theme.SubText, BackgroundTransparency = 1, Size = UDim2.new(1, -58, 0, 16), Position = UDim2.new(0, 56, 0, 43), TextXAlignment = Enum.TextXAlignment.Left }).Parent = SettingsTab

    local DiscordBtn = create("TextButton", { Size = UDim2.new(1, -6, 0, 30), Position = UDim2.new(0, 0, 0, 78), BackgroundColor3 = Theme.Card, Font = Enum.Font.GothamBold, Text = L.discordBtn, TextColor3 = Theme.Text, TextSize = 10 })
    corner(8).Parent = DiscordBtn
    stroke(Theme.Blue, 1).Parent = DiscordBtn
    DiscordBtn.Parent = SettingsTab

    DiscordBtn.MouseButton1Click:Connect(function()
        if Clipboard then Clipboard("https://discord.gg/uguzhub"); DiscordBtn.Text = L.discordCopied; task.wait(1.5); DiscordBtn.Text = L.discordBtn end
    end)

    pages[L.tabESP].Visible = true
    tabBtns[L.tabESP].BackgroundColor3 = Theme.Accent
    tabBtns[L.tabESP].TextColor3 = Theme.Text
end

function openMenu()
    MinimizedButton.Visible = false
    MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
    MainFrame.Visible = true
    MainFrame.Size = UDim2.new(0, MENU_W * 0.85, 0, MENU_H * 0.85)
    tween(MainFrame, { Size = UDim2.new(0, MENU_W, 0, MENU_H) }, 0.28, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
end

function closeMenu()
    tween(MainFrame, { Size = UDim2.new(0, MENU_W * 0.85, 0, MENU_H * 0.85) }, 0.2, Enum.EasingStyle.Quint, Enum.EasingDirection.In)
    task.wait(0.2)
    MainFrame.Visible = false
    MainFrame.Size = UDim2.new(0, MENU_W, 0, MENU_H)

    MinimizedButton.Visible = true
    MinimizedButton.BackgroundTransparency = 1
    tween(MinimizedButton, { BackgroundTransparency = 0 }, 0.25)
end

MinimizedButton.MouseButton1Click:Connect(function() if MainFrame then openMenu() end end)

------------------------------------------------------------
-- ARKA PLAN RENDER DÖNGÜSÜ (ESP & AIMBOT)
------------------------------------------------------------
RunService.RenderStepped:Connect(function()
    if Flags.ESPAll then
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character then
                local role = getRole(p)
                local hl = p.Character:FindFirstChild("UguzHighlight") or Instance.new("Highlight")
                hl.Name = "UguzHighlight"
                hl.FillColor = RoleColors[role]
                hl.OutlineColor = Color3.fromRGB(255, 255, 255)
                hl.FillTransparency = 0.4
                hl.Parent = p.Character
            end
        end
    else
        for _, p in pairs(Players:GetPlayers()) do
            if p.Character and p.Character:FindFirstChild("UguzHighlight") then p.Character.UguzHighlight:Destroy() end
        end
    end

    local gunDrop = Workspace:FindFirstChild("GunDrop") or Workspace:FindFirstChild("Gun")
    if gunDrop then
        if Flags.ESPGun then
            local hl = gunDrop:FindFirstChild("GunHighlight") or Instance.new("Highlight")
            hl.Name = "GunHighlight"
            hl.FillColor = RoleColors.Gun
            hl.OutlineColor = Color3.fromRGB(255, 255, 255)
            hl.Parent = gunDrop
        elseif gunDrop:FindFirstChild("GunHighlight") then
            gunDrop.GunHighlight:Destroy()
        end

        if Flags.AutoGrabGun and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            if firetouchinterest then
                firetouchinterest(LocalPlayer.Character.HumanoidRootPart, gunDrop, 0)
                firetouchinterest(LocalPlayer.Character.HumanoidRootPart, gunDrop, 1)
            else
                LocalPlayer.Character.HumanoidRootPart.CFrame = gunDrop.CFrame
            end
        end
    end

    if Flags.AimbotEnabled then
        local targetRole = (getRole(LocalPlayer) == "Murderer") and "Sheriff" or "Murderer"
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and getRole(p) == targetRole and p.Character and p.Character:FindFirstChild("Head") then
                Camera.CFrame = CFrame.new(Camera.CFrame.Position, p.Character.Head.Position)
                break
            end
        end
    end
end)
