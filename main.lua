-- [[ UguzHub V2 VIP - Fixed Full Working Logic ]] --

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local CoreGui = game:GetService("CoreGui")
local Clipboard = setclipboard or toclipboard or syn and syn.clipboard

local LocalPlayer = Players.LocalPlayer

if LocalPlayer.AccountAge < 14 then
    LocalPlayer:Kick("Your account is less than 14 days old.")
    return
end

local Camera = Workspace.CurrentCamera

------------------------------------------------------------
-- TEMA & RENKLER
------------------------------------------------------------
local Theme = {
    Background   = Color3.fromRGB(13, 13, 18),
    Sidebar      = Color3.fromRGB(18, 18, 26),
    Card         = Color3.fromRGB(24, 24, 35),
    Accent       = Color3.fromRGB(147, 51, 234),
    Blue         = Color3.fromRGB(59, 130, 246),
    Text         = Color3.fromRGB(243, 244, 246),
    SubText      = Color3.fromRGB(156, 163, 175),
    Stroke       = Color3.fromRGB(45, 45, 65),
}

local CARD_TRANSPARENCY = 0.15
local RADIUS = 14

------------------------------------------------------------
-- DİL PAKETLERİ
------------------------------------------------------------
local Lang = {
    TR = {
        title = "Dil Seçimi", openBtn = "UguzHub", 
        warningText = "Lütfen Delta Ayarlarındaki Tüm Her Şeyi Kapattığınızdan Emin Olun. Oyun Deneyiminizi En Üst Seviyeye Çıkarmak İstiyoruz",
        discordBtn = "Discord Sunucusuna Katıl", discordCopied = "Bağlantı Kopyalandı!",
        espAll = "Oyuncu ESP", espGun = "Yerdeki Silah ESP", autoGrab = "Otomatik Silah Topla",
        aimbot = "Aimbot Kilitlenme", aimMurdClose = "Katilken En Yakındakine Kilitlen",
        shootMurd = "Katili Vur (Şerif/Kahraman)", autoKillMurd = "Oto Katili Avla", killAll = "Herkesi Katlet (Katil)",
        autoFarm = "Smooth Auto Farm (Anti-Kick)",
        autoFlingMurd = "Katili Savur (Fling)", autoFlingSheriff = "Şerifi Savur (Fling)", autoFlingAll = "Herkesi Savur (Fling)",
        tpLobby = "Lobiye Dön", tpMap = "Haritaya Geç", tpMurd = "Katile Işınlan", tpSheriff = "Şerife Işınlan",
        tabESP = "Görüş (ESP)", tabAimbot = "Hedef (Aimbot)", tabPlayers = "Oto Farm & Oyuncu", tabTP = "Işınlanma", tabSettings = "Ayarlar"
    },
    TL = { title = "Pumili ng Wika", openBtn = "UguzHub", warningText = "Siguraduhing Naka-off Ang Lahat Sa Delta Settings.", discordBtn = "Discord Server", discordCopied = "Na-copy!", espAll = "Player ESP", espGun = "Gun ESP", autoGrab = "Auto Grab Gun", aimbot = "Aimbot", aimMurdClose = "Lock Nearest (Murderer)", shootMurd = "Shoot Murderer", autoKillMurd = "Auto Kill Murderer", killAll = "Kill All", autoFarm = "Auto Farm", autoFlingMurd = "Fling Murderer", autoFlingSheriff = "Fling Sheriff", autoFlingAll = "Fling All", tpLobby = "TP Lobby", tpMap = "TP Map", tpMurd = "TP Murderer", tpSheriff = "TP Sheriff", tabESP = "ESP", tabAimbot = "Aimbot", tabPlayers = "Farm & Players", tabTP = "Teleport", tabSettings = "Settings" },
    EN = { title = "Language Selection", openBtn = "UguzHub", warningText = "Please Turn Off Everything In Delta Settings.", discordBtn = "Join Discord", discordCopied = "Copied!", espAll = "Player ESP", espGun = "Dropped Gun ESP", autoGrab = "Auto Grab Gun", aimbot = "Aimbot", aimMurdClose = "Lock Nearest (As Murderer)", shootMurd = "Shoot Murderer (Sheriff)", autoKillMurd = "Auto Kill Murderer", killAll = "Kill All", autoFarm = "Auto Farm", autoFlingMurd = "Fling Murderer", autoFlingSheriff = "Fling Sheriff", autoFlingAll = "Fling All", tpLobby = "TP Lobby", tpMap = "TP Map", tpMurd = "TP Murderer", tpSheriff = "TP Sheriff", tabESP = "ESP Visuals", tabAimbot = "Aimbot", tabPlayers = "Farm & Players", tabTP = "Teleport", tabSettings = "Settings" },
    ES = { title = "Selección de Idioma", openBtn = "UguzHub", warningText = "Desactiva Delta Settings.", discordBtn = "Discord", discordCopied = "¡Copiado!", espAll = "ESP Jugadores", espGun = "ESP Arma", autoGrab = "Auto Tomar Arma", aimbot = "Aimbot", aimMurdClose = "Fijar Cercano (Asesino)", shootMurd = "Disparar Asesino", autoKillMurd = "Auto Matar Asesino", killAll = "Matar Todos", autoFarm = "Auto Farm", autoFlingMurd = "Lanzar Asesino", autoFlingSheriff = "Lanzar Alguacil", autoFlingAll = "Lanzar Todos", tpLobby = "TP Lobby", tpMap = "TP Mapa", tpMurd = "TP Asesino", tpSheriff = "TP Alguacil", tabESP = "ESP", tabAimbot = "Aimbot", tabPlayers = "Jugadores", tabTP = "Teleport", tabSettings = "Ajustes" },
    DE = { title = "Sprachauswahl", openBtn = "UguzHub", warningText = "Delta Einstellungen ausschalten.", discordBtn = "Discord", discordCopied = "Kopiert!", espAll = "Spieler ESP", espGun = "Waffen ESP", autoGrab = "Auto Waffe", aimbot = "Aimbot", aimMurdClose = "Mörder: Nächsten Fokus", shootMurd = "Mörder Erschießen", autoKillMurd = "Auto Mörder Töten", killAll = "Alle Töten", autoFarm = "Auto Farm", autoFlingMurd = "Mörder Schleudern", autoFlingSheriff = "Sheriff Schleudern", autoFlingAll = "Alle Schleudern", tpLobby = "TP Lobby", tpMap = "TP Karte", tpMurd = "TP Mörder", tpSheriff = "TP Sheriff", tabESP = "ESP", tabAimbot = "Aimbot", tabPlayers = "Spieler", tabTP = "Teleport", tabSettings = "Einstellungen" },
    FR = { title = "Choix de la Langue", openBtn = "UguzHub", warningText = "Désactiver Delta Settings.", discordBtn = "Discord", discordCopied = "Copié!", espAll = "ESP Joueurs", espGun = "ESP Arme", autoGrab = "Auto Arme", aimbot = "Aimbot", aimMurdClose = "Proche (Meurtrier)", shootMurd = "Tirer Meurtrier", autoKillMurd = "Auto Tuer Meurtrier", killAll = "Tuer Tous", autoFarm = "Auto Farm", autoFlingMurd = "Propulser Meurtrier", autoFlingSheriff = "Propulser Sheriff", autoFlingAll = "Propulser Tous", tpLobby = "TP Lobby", tpMap = "TP Carte", tpMurd = "TP Meurtrier", tpSheriff = "TP Sheriff", tabESP = "ESP", tabAimbot = "Aimbot", tabPlayers = "Joueurs", tabTP = "Téléport", tabSettings = "Options" },
    RU = { title = "Выбор Языка", openBtn = "UguzHub", warningText = "Выключите настройки Delta.", discordBtn = "Discord", discordCopied = "Скопировано!", espAll = "ESP Игроков", espGun = "ESP Оружия", autoGrab = "Авто Подбор", aimbot = "Аимбот", aimMurdClose = "Убийца: Аим на ближайшего", shootMurd = "Застрелить Убийцу", autoKillMurd = "Авто Убийство Убийцы", killAll = "Убить Всех", autoFarm = "Auto Farm", autoFlingMurd = "Флинг Убийцы", autoFlingSheriff = "Флинг Шерифа", autoFlingAll = "Флинг Всех", tpLobby = "ТП Лобби", tpMap = "ТП Карта", tpMurd = "ТП Убийца", tpSheriff = "ТП Шериф", tabESP = "ESP", tabAimbot = "Аимбот", tabPlayers = "Игроки", tabTP = "Телепорт", tabSettings = "Настройки" },
    AR = { title = "اختيار اللغة", openBtn = "UguzHub", warningText = "إيقاف إعدادات Delta.", discordBtn = "Discord", discordCopied = "تم النسخ!", espAll = "كشف اللاعبين", espGun = "كشف السلاح", autoGrab = "التقاط السلاح", aimbot = "التصويب", aimMurdClose = "القاتل: الأقرب", shootMurd = "إطلاق النار على القاتل", autoKillMurd = "قتل القاتل", killAll = "قتل الجميع", autoFarm = "تجميع تلقائي", autoFlingMurd = "طرد القاتل", autoFlingSheriff = "طرد الشريف", autoFlingAll = "طرد الجميع", tpLobby = "الانتقال للوبي", tpMap = "الانتقال للخريطة", tpMurd = "الانتقال للقاتل", tpSheriff = "الانتقال للشريف", tabESP = "ESP", tabAimbot = "التصويب", tabPlayers = "اللاعبين", tabTP = "الانتقال", tabSettings = "الإعدادات" }
}

local LanguageList = {
    { code = "TR", flag = "🇹🇷", name = "Türkçe" },
    { code = "TL", flag = "🇵🇭", name = "Tagalog / Filipince" },
    { code = "EN", flag = "🇬🇧", name = "English" },
    { code = "ES", flag = "🇪🇸", name = "Español" },
    { code = "DE", flag = "🇩🇪", name = "Deutsch" },
    { code = "FR", flag = "🇫🇷", name = "Français" },
    { code = "RU", flag = "🇷🇺", name = "Русский" },
    { code = "AR", flag = "🇸🇦", name = "العربية" }
}

local CurrentLang = "TR"
local L = Lang[CurrentLang]

------------------------------------------------------------
-- HİLE BAYRAKLARI
------------------------------------------------------------
local Flags = {
    ESPAll = false, ESPGun = false, AutoGrabGun = false,
    AimbotEnabled = false, AimbotMurdNearest = false, ShootMurderer = false,
    AutoKillMurderer = false, AutoFarm = false,
    AutoFlingMurderer = false, AutoFlingSheriff = false, AutoFlingAll = false
}

------------------------------------------------------------
-- OYUN İÇİ ROL VE NESNE TESPİTLERİ
------------------------------------------------------------
local function getRole(player)
    if not player or not player.Character then return "Innocent" end
    local backpack = player:FindFirstChild("Backpack")
    local character = player.Character
    if (backpack and backpack:FindFirstChild("Knife")) or character:FindFirstChild("Knife") then
        return "Murderer"
    elseif (backpack and backpack:FindFirstChild("Gun")) or character:FindFirstChild("Gun") then
        return "Sheriff"
    end
    return "Innocent"
end

local function getPlayerByRole(roleName)
    for _, plr in ipairs(Players:GetPlayers()) do
        if getRole(plr) == roleName then
            return plr
        end
    end
    return nil
end

local function getNearestPlayerToLocal()
    local nearestPlayer = nil
    local shortestDistance = math.huge
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local myPos = LocalPlayer.Character.HumanoidRootPart.Position
        for _, plr in ipairs(Players:GetPlayers()) do
            if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") and plr.Character:FindFirstChild("Humanoid") and plr.Character.Humanoid.Health > 0 then
                local dist = (plr.Character.HumanoidRootPart.Position - myPos).Magnitude
                if dist < shortestDistance then
                    shortestDistance = dist
                    nearestPlayer = plr
                end
            end
        end
    end
    return nearestPlayer
end

------------------------------------------------------------
-- ESP SİSTEMİ (HIGHLIGHT)
------------------------------------------------------------
local function applyESP(player)
    if not player.Character then return end
    local role = getRole(player)
    local hl = player.Character:FindFirstChild("UguzESP")
    
    if Flags.ESPAll and player ~= LocalPlayer then
        if not hl then
            hl = Instance.new("Highlight")
            hl.Name = "UguzESP"
            hl.Parent = player.Character
        end
        hl.Enabled = true
        if role == "Murderer" then
            hl.FillColor = Color3.fromRGB(255, 0, 0)
        elseif role == "Sheriff" then
            hl.FillColor = Color3.fromRGB(0, 120, 255)
        else
            hl.FillColor = Color3.fromRGB(0, 255, 120)
        end
    else
        if hl then hl.Enabled = false end
    end
end

------------------------------------------------------------
-- DÖNGÜ (RENDERSTEPPED): AIMBOT, ESP & SHOOT MURDERER
------------------------------------------------------------
RunService.RenderStepped:Connect(function()
    -- ESP Güncelleme
    for _, plr in ipairs(Players:GetPlayers()) do
        applyESP(plr)
    end

    -- KATİL İÇİN EN YAKINA KİLİTLENME AIMBOT
    if Flags.AimbotMurdNearest and getRole(LocalPlayer) == "Murderer" then
        local target = getNearestPlayerToLocal()
        if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
            Camera.CFrame = CFrame.new(Camera.CFrame.Position, target.Character.HumanoidRootPart.Position)
        end
    end

    -- ŞERİF / KAHRAMAN İÇİN KATİLİ VURMA AIMBOT (SHOOT MURDERER)
    if (Flags.ShootMurderer or Flags.AimbotEnabled) and getRole(LocalPlayer) == "Sheriff" then
        local murderer = getPlayerByRole("Murderer")
        if murderer and murderer.Character and murderer.Character:FindFirstChild("HumanoidRootPart") then
            Camera.CFrame = CFrame.new(Camera.CFrame.Position, murderer.Character.HumanoidRootPart.Position)
        end
    end

    -- YERDEKİ SİLAHI OTOMATİK TOPLAMA
    if Flags.AutoGrabGun then
        local gunDrop = Workspace:FindFirstChild("GunDrop", true)
        if gunDrop and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            LocalPlayer.Character.HumanoidRootPart.CFrame = gunDrop.CFrame
        end
    end
end)

------------------------------------------------------------
-- YARDIMCI ARAYÜZ FONKSİYONLARI
------------------------------------------------------------
local function create(class, props, children)
    local inst = Instance.new(class)
    for prop, value in pairs(props or {}) do inst[prop] = value end
    for _, child in ipairs(children or {}) do child.Parent = inst end
    return inst
end

local function corner(radius) return create("UICorner", { CornerRadius = UDim.new(0, radius or RADIUS) }) end
local function stroke(color, thickness) return create("UIStroke", { Color = color or Theme.Stroke, Thickness = thickness or 1, Transparency = 0.3 }) end
local function tween(obj, props, duration, style, direction)
    local info = TweenInfo.new(duration or 0.3, style or Enum.EasingStyle.Quint, direction or Enum.EasingDirection.Out)
    local t = TweenService:Create(obj, info, props)
    t:Play()
    return t
end

------------------------------------------------------------
-- GUI CONTAINER
------------------------------------------------------------
local ScreenGui = create("ScreenGui", { Name = "UguzHubVIPMain", ResetOnSpawn = false, ZIndexBehavior = Enum.ZIndexBehavior.Sibling, DisplayOrder = 999, IgnoreGuiInset = true })
ScreenGui.Parent = CoreGui

local MinimizedButton = create("TextButton", { Name = "MinimizedButton", Text = "⚡ UguzHub", Font = Enum.Font.GothamBold, TextSize = 13, TextColor3 = Theme.Text, BackgroundColor3 = Theme.Accent, Size = UDim2.new(0, 110, 0, 36), Position = UDim2.new(1, -126, 0, 18), AutoButtonColor = false, Visible = false, ZIndex = 40 })
corner(10).Parent = MinimizedButton
stroke(Color3.fromRGB(255, 255, 255), 1).Parent = MinimizedButton
MinimizedButton.Parent = ScreenGui

local buildMainMenu, showLanguageMenu, showWarningScreen

------------------------------------------------------------
-- 2) DİL SEÇİM MENÜSÜ (EKRANI TAM KAPLAYAN VE SCROLLABLE)
------------------------------------------------------------
function showLanguageMenu()
    local LangFrame = create("Frame", { Name = "LangMenu", Size = UDim2.fromScale(1, 1), Position = UDim2.fromScale(0, 0), BackgroundColor3 = Theme.Background, ZIndex = 60 })
    LangFrame.Parent = ScreenGui

    local CenterBox = create("Frame", { Size = UDim2.new(0, 380, 0, 340), Position = UDim2.fromScale(0.5, 0.5), AnchorPoint = Vector2.new(0.5, 0.5), BackgroundColor3 = Theme.Card, ZIndex = 61 })
    corner(16).Parent = CenterBox
    stroke(Theme.Accent, 1.5).Parent = CenterBox
    CenterBox.Parent = LangFrame

    local Title = create("TextLabel", { Text = "Select Language / Dil Seçin", Font = Enum.Font.GothamBlack, TextSize = 16, TextColor3 = Theme.Text, BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 45), Position = UDim2.new(0, 0, 0, 5), ZIndex = 62 })
    Title.Parent = CenterBox

    local ScrollList = create("ScrollingFrame", { Size = UDim2.new(1, -24, 1, -60), Position = UDim2.new(0, 12, 0, 50), BackgroundTransparency = 1, BorderSizePixel = 0, ScrollBarThickness = 4, ScrollBarImageColor3 = Theme.Accent, ZIndex = 62 })
    ScrollList.Parent = CenterBox

    local ListLayout = create("UIListLayout", { SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 8) })
    ListLayout.Parent = ScrollList

    ListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        ScrollList.CanvasSize = UDim2.new(0, 0, 0, ListLayout.AbsoluteContentSize.Y + 10)
    end)

    for i, opt in ipairs(LanguageList) do
        local card = create("TextButton", { Name = opt.code, Text = "", Size = UDim2.new(1, -8, 0, 42), BackgroundColor3 = Theme.Sidebar, AutoButtonColor = false, LayoutOrder = i, ZIndex = 63 })
        corner(10).Parent = card
        stroke(Theme.Stroke, 1).Parent = card
        card.Parent = ScrollList

        create("TextLabel", { Text = opt.flag, Font = Enum.Font.GothamBold, TextSize = 22, BackgroundTransparency = 1, Size = UDim2.new(0, 40, 1, 0), Position = UDim2.new(0, 8, 0, 0), TextXAlignment = Enum.TextXAlignment.Center, ZIndex = 64 }).Parent = card
        create("TextLabel", { Text = opt.name, Font = Enum.Font.GothamBold, TextSize = 13, TextColor3 = Theme.Text, BackgroundTransparency = 1, Size = UDim2.new(1, -60, 1, 0), Position = UDim2.new(0, 52, 0, 0), TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 64 }).Parent = card

        card.MouseButton1Click:Connect(function()
            CurrentLang = opt.code
            L = Lang[CurrentLang] or Lang.EN

            tween(LangFrame, { BackgroundTransparency = 1 }, 0.3)
            tween(CenterBox, { Size = UDim2.new(0, 0, 0, 0) }, 0.3)
            task.wait(0.3)
            LangFrame:Destroy()

            showWarningScreen()
        end)
    end
end

------------------------------------------------------------
-- 3) UYARI EKRANI
------------------------------------------------------------
function showWarningScreen()
    local WarnFrame = create("Frame", { Name = "WarnFrame", Size = UDim2.fromScale(1, 1), Position = UDim2.fromScale(0, 0), BackgroundColor3 = Theme.Background, BackgroundTransparency = 0.2, ZIndex = 70 })
    WarnFrame.Parent = ScreenGui

    local WarnBox = create("Frame", { Size = UDim2.new(0, 420, 0, 180), Position = UDim2.fromScale(0.5, 0.5), AnchorPoint = Vector2.new(0.5, 0.5), BackgroundColor3 = Theme.Card, BackgroundTransparency = CARD_TRANSPARENCY, ZIndex = 71 })
    corner(16).Parent = WarnBox
    stroke(Theme.Accent, 1.5).Parent = WarnBox
    WarnBox.Parent = WarnFrame

    local WarnText = create("TextLabel", { Text = "", Font = Enum.Font.GothamBold, TextSize = 13, TextColor3 = Theme.Text, TextWrapped = true, TextXAlignment = Enum.TextXAlignment.Center, Size = UDim2.new(1, -40, 1, -40), Position = UDim2.fromScale(0.5, 0.5), AnchorPoint = Vector2.new(0.5, 0.5), BackgroundTransparency = 1, ZIndex = 72 })
    WarnText.Parent = WarnBox

    task.spawn(function()
        for i = 3, 1, -1 do
            WarnText.Text = L.warningText .. " (" .. i .. ")"
            task.wait(1)
        end
        
        tween(WarnFrame, { BackgroundTransparency = 1 }, 0.3)
        tween(WarnBox, { BackgroundTransparency = 1 }, 0.3)
        tween(WarnText, { TextTransparency = 1 }, 0.3)
        task.wait(0.3)
        WarnFrame:Destroy()

        buildMainMenu()
        MinimizedButton.Text = "⚡ " .. L.openBtn
        MinimizedButton.Visible = true
    end)
end

------------------------------------------------------------
-- 1) ANIMASYONLU GİRİŞ EKRANI (İLK ÇALIŞAN KISIM)
------------------------------------------------------------
local IntroFrame = create("Frame", { Name = "Intro", Size = UDim2.fromScale(1, 1), Position = UDim2.fromScale(0, 0), BackgroundColor3 = Theme.Background, ZIndex = 80 })
IntroFrame.Parent = ScreenGui

local Content = create("Frame", { AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.new(0.5, 0, 0.5, 0), Size = UDim2.new(0, 360, 0, 140), BackgroundTransparency = 1, ZIndex = 81 })
Content.Parent = IntroFrame

local LogoLabel = create("TextLabel", { Text = "UguzHub", Font = Enum.Font.GothamBlack, TextSize = 52, TextColor3 = Theme.Text, BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 60), TextTransparency = 1, ZIndex = 81 })
LogoLabel.Parent = Content

local ProTag = create("TextLabel", { Text = "V2 VIP PRO", Font = Enum.Font.GothamBold, TextSize = 18, TextColor3 = Theme.Accent, BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 22), Position = UDim2.new(0, 0, 0, 58), TextTransparency = 1, ZIndex = 81 })
ProTag.Parent = Content

local Underline = create("Frame", { Size = UDim2.new(0, 0,0, 3), Position = UDim2.new(0.5, 0, 0, 88), AnchorPoint = Vector2.new(0.5, 0), BackgroundColor3 = Theme.Accent, BorderSizePixel = 0, ZIndex = 81 })
corner(2).Parent = Underline
Underline.Parent = Content

local LoadingLabel = create("TextLabel", { Text = "Yükleniyor...", Font = Enum.Font.GothamMedium, TextSize = 16, TextColor3 = Theme.SubText, BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 24), Position = UDim2.new(0, 0, 0, 104), TextTransparency = 1, ZIndex = 81 })
LoadingLabel.Parent = Content

task.defer(function()
    tween(LogoLabel, { TextTransparency = 0 }, 0.5)
    tween(ProTag, { TextTransparency = 0 }, 0.5)
    task.wait(0.1)
    tween(Underline, { Size = UDim2.new(0, 240, 0, 3) }, 0.5, Enum.EasingStyle.Quart)
    task.wait(0.2)
    tween(LoadingLabel, { TextTransparency = 0 }, 0.3)

    task.wait(1.5)

    tween(IntroFrame, { BackgroundTransparency = 1 }, 0.4)
    tween(LogoLabel, { TextTransparency = 1 }, 0.3)
    tween(ProTag, { TextTransparency = 1 }, 0.3)
    tween(Underline, { BackgroundTransparency = 1 }, 0.3)
    tween(LoadingLabel, { TextTransparency = 1 }, 0.3)
    task.wait(0.4)
    IntroFrame:Destroy()

    showLanguageMenu()
end)

------------------------------------------------------------
-- 4) ANA MENÜ (BUILD MAIN MENU)
------------------------------------------------------------
local MainFrame
local MENU_W, MENU_H = 500, 300

function buildMainMenu()
    if MainFrame then MainFrame:Destroy() end

    MainFrame = create("Frame", { Name = "MainMenu", Size = UDim2.new(0, MENU_W, 0, MENU_H), Position = UDim2.new(0.5, 0, 0.5, 0), AnchorPoint = Vector2.new(0.5, 0.5), BackgroundColor3 = Theme.Background, ClipsDescendants = true, ZIndex = 5 })
    corner(RADIUS).Parent = MainFrame
    stroke(Theme.Accent, 1.5).Parent = MainFrame
    MainFrame.Parent = ScreenGui

    local TopBar = create("Frame", { Size = UDim2.new(1, 0, 0, 38), BackgroundColor3 = Theme.Sidebar, BackgroundTransparency = CARD_TRANSPARENCY, ZIndex = 6, Active = true })
    corner(RADIUS).Parent = TopBar
    TopBar.Parent = MainFrame

    create("TextLabel", { Text = "UguzHub  •  V2 VIP", Font = Enum.Font.GothamBlack, TextSize = 13, TextColor3 = Theme.Text, BackgroundTransparency = 1, Size = UDim2.new(1, -56, 1, 0), Position = UDim2.new(0, 14, 0, 0), TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 7 }).Parent = TopBar

    local MinimizeBtn = create("TextButton", { Text = "✕", Font = Enum.Font.GothamBold, TextSize = 14, TextColor3 = Theme.SubText, BackgroundTransparency = 1, Size = UDim2.new(0, 32, 0, 32), Position = UDim2.new(1, -36, 0, 3), ZIndex = 7 })
    MinimizeBtn.Parent = TopBar
    MinimizeBtn.MouseButton1Click:Connect(function()
        MainFrame.Visible = false
        MinimizedButton.Visible = true
    end)

    local Sidebar = create("Frame", { Size = UDim2.new(0, 125, 1, -46), Position = UDim2.new(0, 8, 0, 42), BackgroundColor3 = Theme.Sidebar, BackgroundTransparency = CARD_TRANSPARENCY, ZIndex = 6 })
    corner(10).Parent = Sidebar
    Sidebar.Parent = MainFrame

    local TabContainer = create("Frame", { Size = UDim2.new(1, -147, 1, -46), Position = UDim2.new(0, 139, 0, 42), BackgroundTransparency = 1, ZIndex = 6 })
    TabContainer.Parent = MainFrame

    create("UIListLayout", { SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 5) }).Parent = Sidebar

    local pages, tabBtns = {}, {}

    local function addTab(name, icon)
        local btn = create("TextButton", { Size = UDim2.new(1, 0, 0, 32), BackgroundColor3 = Theme.Card, BackgroundTransparency = 0.6, Font = Enum.Font.GothamMedium, Text = " " .. icon .. "  " .. name, TextColor3 = Theme.SubText, TextSize = 11, TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 7 })
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
        local frame = create("Frame", { Size = UDim2.new(1, -6, 0, 32), BackgroundColor3 = Theme.Card, BackgroundTransparency = CARD_TRANSPARENCY })
        corner(8).Parent = frame
        stroke(Theme.Stroke, 1).Parent = frame
        frame.Parent = parent

        create("TextLabel", { Text = labelText, Font = Enum.Font.GothamMedium, TextColor3 = Theme.Text, TextSize = 10, BackgroundTransparency = 1, Size = UDim2.new(0.7, 0, 1, 0), Position = UDim2.new(0, 10, 0, 0), TextXAlignment = Enum.TextXAlignment.Left }).Parent = frame

        local switch = create("Frame", { Size = UDim2.new(0, 30, 0, 15), Position = UDim2.new(1, -38, 0.5, -7), BackgroundColor3 = Color3.fromRGB(35, 35, 48) })
        corner(10).Parent = switch
        switch.Parent = frame

        local dot = create("Frame", { Size = UDim2.new(0, 11, 0, 11), Position = UDim2.new(0, 2, 0.5, -5), BackgroundColor3 = Color3.fromRGB(180, 180, 195) })
        corner(10).Parent = dot
        dot.Parent = switch

        local btn = create("TextButton", { Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1, Text = "" })
        btn.Parent = frame

        btn.MouseButton1Click:Connect(function()
            Flags[flag] = not Flags[flag]
            if Flags[flag] then
                tween(switch, { BackgroundColor3 = Theme.Accent }, 0.2)
                tween(dot, { Position = UDim2.new(1, -13, 0.5, -5), BackgroundColor3 = Color3.fromRGB(255, 255, 255) }, 0.2)
            else
                tween(switch, { BackgroundColor3 = Color3.fromRGB(35, 35, 48) }, 0.2)
                tween(dot, { Position = UDim2.new(0, 2, 0.5, -5), BackgroundColor3 = Color3.fromRGB(180, 180, 195) }, 0.2)
            end
        end)
    end

    -- SEKMELER
    local ESPTab = addTab(L.tabESP, "👁")
    local AimbotTab = addTab(L.tabAimbot, "🎯")
    local PlayersTab = addTab(L.tabPlayers, "👥")
    local TeleportTab = addTab(L.tabTP, "🚀")
    local SettingsTab = addTab(L.tabSettings, "⚙")

    -- ESP TAB
    createToggle(ESPTab, L.espAll, "ESPAll")
    createToggle(ESPTab, L.espGun, "ESPGun")
    createToggle(ESPTab, L.autoGrab, "AutoGrabGun")

    -- AIMBOT TAB
    createToggle(AimbotTab, L.aimbot, "AimbotEnabled")
    createToggle(AimbotTab, L.aimMurdClose, "AimbotMurdNearest")
    createToggle(AimbotTab, L.shootMurd, "ShootMurderer")

    -- PLAYERS TAB
    createToggle(PlayersTab, L.autoFarm, "AutoFarm")
    createToggle(PlayersTab, L.autoKillMurd, "AutoKillMurderer")
    createToggle(PlayersTab, L.autoFlingMurd, "AutoFlingMurderer")
    createToggle(PlayersTab, L.autoFlingSheriff, "AutoFlingSheriff")
    createToggle(PlayersTab, L.autoFlingAll, "AutoFlingAll")

    -- SETTINGS TAB
    create("TextLabel", { Text = L.title, Font = Enum.Font.GothamBold, TextSize = 13, TextColor3 = Theme.SubText, BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 18), TextXAlignment = Enum.TextXAlignment.Left }).Parent = SettingsTab

    local DiscordBtn = create("TextButton", { Size = UDim2.new(1, -6, 0, 32), Position = UDim2.new(0, 0, 0, 30), BackgroundColor3 = Theme.Card, Font = Enum.Font.GothamBold, Text = L.discordBtn, TextColor3 = Theme.Text, TextSize = 11 })
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

MinimizedButton.MouseButton1Click:Connect(function()
    if MainFrame then
        MainFrame.Visible = true
        MinimizedButton.Visible = false
    end
end)
