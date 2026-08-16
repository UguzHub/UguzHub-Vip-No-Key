-- [[ UguzHub V2 VIP - Full Master Edition + Warning Screen ]] --
repeat task.wait() until game:IsLoaded()

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")

local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera

-- Temizlik (Varsa eski GUI'yi sil)
if CoreGui:FindFirstChild("UguzHubVIPMain") then 
    CoreGui.UguzHubVIPMain:Destroy() 
end

------------------------------------------------------------
-- TEMA VE BAYRAKLAR
------------------------------------------------------------
local Flags = {
    ESPAll = false,
    ESPGun = false,
    AutoGrabGun = false,
    AimbotEnabled = false,
    AutoFarm = false,
    SelectedLang = "TR"
}

local Theme = {
    Background = Color3.fromRGB(16, 16, 22),      -- Arka Plan
    Sidebar    = Color3.fromRGB(16, 23, 38),      -- Yan Menü
    Card       = Color3.fromRGB(25, 35, 50),       -- Butonlar / Paneller
    Accent     = Color3.fromRGB(138, 92, 255),    -- Neon Mor
    Text       = Color3.fromRGB(235, 235, 245),   -- Beyaz
    SubText    = Color3.fromRGB(165, 165, 180),   -- Açık Gri
    Danger     = Color3.fromRGB(220, 38, 38),      -- Kırmızı
    Warning    = Color3.fromRGB(245, 158, 11)     -- Turuncu/Sarı
}

------------------------------------------------------------
-- DİL PAKETLERİ VE UYARI METİNLERİ
------------------------------------------------------------
local LangData = {
    TR = {
        name = "🇹🇷 Türkçe",
        title = "UguzHub V2 VIP",
        warningTitle = "⚠️ ÖNEMLİ UYARI",
        warningMsg = "Delta Ayarlarındaki Tüm Herşeyi Kapattığınızdan Emin Olun! Sizlere Daha İyi Bir Deneyim Yaşatmak İçin Çabalıyoruz!",
        discordMsg = "İsteklerinizi veya Şikayetlerinizi bu sunucuya girip yazabilirsiniz!",
        tabVisuals = "Görsel (ESP)",
        tabAimbot = "Aimbot & Savaş",
        tabTP = "Teleport",
        tabProfile = "Profil & Destek",
        espAll = "Oyuncu ESP",
        espGun = "Düşen Silah ESP",
        autoGrab = "Otomatik Silah Topla",
        shootBtn = "Shoot Murderer (Sürüklenebilir Buton)",
        tpLobby = "Lobiye Işınlan",
        tpMap = "Haritaya Işınlan",
        tpMurd = "Katile Işınlan",
        userRole = "VIP Üye"
    },
    TL = {
        name = "🇵🇭 Tagalog",
        title = "UguzHub V2 VIP",
        warningTitle = "⚠️ MAHALAGANG BABALA",
        warningMsg = "Tiyaking nakapatay ang lahat ng setting sa Delta Settings! Nagsisikap kami upang bigyan ka ng mas magandang karanasan!",
        discordMsg = "Maaari kang sumali sa server na ito upang isulat ang iyong mga kahilingan o reklamo!",
        tabVisuals = "Visuals (ESP)",
        tabAimbot = "Aimbot",
        tabTP = "Teleport",
        tabProfile = "Profile & Suporta",
        espAll = "Player ESP",
        espGun = "Gun ESP",
        autoGrab = "Auto Grab Gun",
        shootBtn = "Shoot Murderer (Spawn Button)",
        tpLobby = "Teleport sa Lobby",
        tpMap = "Teleport sa Map",
        tpMurd = "Teleport sa Murderer",
        userRole = "VIP Member"
    },
    EN = {
        name = "🇬🇧 English",
        title = "UguzHub V2 VIP",
        warningTitle = "⚠️ IMPORTANT WARNING",
        warningMsg = "Make sure to turn off everything in Delta Settings! We are striving to provide you with a better experience!",
        discordMsg = "You can join this server to write your requests or complaints!",
        tabVisuals = "Visuals (ESP)",
        tabAimbot = "Aimbot",
        tabTP = "Teleport",
        tabProfile = "Profile & Support",
        espAll = "Player ESP",
        espGun = "Dropped Gun ESP",
        autoGrab = "Auto Grab Gun",
        shootBtn = "Shoot Murderer (Spawn Button)",
        tpLobby = "Teleport to Lobby",
        tpMap = "Teleport to Map",
        tpMurd = "Teleport to Murderer",
        userRole = "VIP Member"
    },
    ES = {
        name = "🇪🇸 Español",
        title = "UguzHub V2 VIP",
        warningTitle = "⚠️ ADVERTENCIA IMPORTANTE",
        warningMsg = "¡Asegúrate de desactivar todo en la configuración de Delta! ¡Nos esforzamos por ofrecerte una mejor experiencia!",
        discordMsg = "¡Puedes unirte a este servidor para escribir tus solicitudes o quejas!",
        tabVisuals = "Visuales (ESP)",
        tabAimbot = "Aimbot",
        tabTP = "Teletransportar",
        tabProfile = "Perfil y Soporte",
        espAll = "ESP Jugadores",
        espGun = "ESP Arma",
        autoGrab = "Auto Tomar Arma",
        shootBtn = "Disparar Asesino (Boton)",
        tpLobby = "TP al Lobby",
        tpMap = "TP al Mapa",
        tpMurd = "TP al Asesino",
        userRole = "Miembro VIP"
    },
    DE = {
        name = "🇩🇪 Deutsch",
        title = "UguzHub V2 VIP",
        warningTitle = "⚠️ WICHTIGER HINWEIS",
        warningMsg = "Stelle sicher, dass du alles in den Delta-Einstellungen ausschaltest! Wir bemühen uns, dir ein besseres Erlebnis zu bieten!",
        discordMsg = "Tritt diesem Server bei, um deine Wünsche oder Beschwerden zu schreiben!",
        tabVisuals = "Visuell (ESP)",
        tabAimbot = "Aimbot",
        tabTP = "Teleport",
        tabProfile = "Profil & Support",
        espAll = "Spieler ESP",
        espGun = "Waffen ESP",
        autoGrab = "Auto Waffe Greifen",
        shootBtn = "Mörder Erschießen (Button)",
        tpLobby = "TP zur Lobby",
        tpMap = "TP zur Karte",
        tpMurd = "TP zum Mörder",
        userRole = "VIP Mitglied"
    },
    FR = {
        name = "🇫🇷 Français",
        title = "UguzHub V2 VIP",
        warningTitle = "⚠️ AVERTISSEMENT IMPORTANT",
        warningMsg = "Assurez-vous de tout désactiver dans les paramètres Delta! Nous nous efforçons de vous offrir une meilleure expérience!",
        discordMsg = "Vous pouvez rejoindre ce serveur pour écrire vos demandes ou réclamations!",
        tabVisuals = "Visuels (ESP)",
        tabAimbot = "Aimbot",
        tabTP = "Téléportation",
        tabProfile = "Profil & Support",
        espAll = "ESP Joueurs",
        espGun = "ESP Arme",
        autoGrab = "Auto Ramasser Arme",
        shootBtn = "Tirer Meurtrier (Bouton)",
        tpLobby = "TP au Lobby",
        tpMap = "TP à la Carte",
        tpMurd = "TP au Meurtrier",
        userRole = "Membre VIP"
    },
    RU = {
        name = "🇷🇺 Русский",
        title = "UguzHub V2 VIP",
        warningTitle = "⚠️ ВАЖНОЕ ПРЕДУПРЕЖДЕНИЕ",
        warningMsg = "Убедитесь, что вы отключили всё в настройках Delta! Мы стараемся предоставить вам лучший сервис!",
        discordMsg = "Вы можете зайти на этот сервер, чтобы написать свои пожелания или жалобы!",
        tabVisuals = "Визуалы (ESP)",
        tabAimbot = "Аимбот",
        tabTP = "Телепорт",
        tabProfile = "Профиль и Поддержка",
        espAll = "ESP Игроков",
        espGun = "ESP Оружия",
        autoGrab = "Авто Подбор Оружия",
        shootBtn = "Убить Убийцу (Кнопка)",
        tpLobby = "ТП в Лобби",
        tpMap = "ТП на Карту",
        tpMurd = "ТП к Убийце",
        userRole = "VIP Участник"
    },
    AR = {
        name = "🇸🇦 العربية",
        title = "UguzHub V2 VIP",
        warningTitle = "⚠️ تحذير هام",
        warningMsg = "تأكد من إيقاف تشغيل كل شيء في إعدادات Delta! نحن نسعى جاهدين لتقديم تجربة أفضل لك!",
        discordMsg = "يمكنك الانضمام إلى هذا السيرفر لكتابة طلباتك أو شكاواك!",
        tabVisuals = "كشف (ESP)",
        tabAimbot = "التصويب",
        tabTP = "الانتقال",
        tabProfile = "الملف الشخصي والدعم",
        espAll = "كشف اللاعبين",
        espGun = "كشف السلاح",
        autoGrab = "التقاط السلاح تلقائياً",
        shootBtn = "إطلاق النار على القاتل (زر)",
        tpLobby = "انتقال للوبي",
        tpMap = "انتقال للخريطة",
        tpMurd = "انتقال للقاتل",
        userRole = "عضو VIP"
    }
}

------------------------------------------------------------
-- ROL VE OYUN MANTIĞI
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
        if getRole(plr) == "Murderer" then
            return plr
        end
    end
    return nil
end

------------------------------------------------------------
-- RENDERSTEPPED LOOP
------------------------------------------------------------
RunService.RenderStepped:Connect(function()
    pcall(function()
        for _, plr in pairs(Players:GetPlayers()) do
            if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
                local esp = plr.Character:FindFirstChild("UguzESP")
                if Flags.ESPAll then
                    if not esp then
                        esp = Instance.new("Highlight")
                        esp.Name = "UguzESP"
                        esp.Parent = plr.Character
                    end
                    esp.Enabled = true
                    local role = getRole(plr)
                    if role == "Murderer" then
                        esp.FillColor = Color3.fromRGB(255, 0, 0)
                    elseif role == "Sheriff" then
                        esp.FillColor = Color3.fromRGB(0, 120, 255)
                    else
                        esp.FillColor = Color3.fromRGB(0, 255, 0)
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
    end)
end)

------------------------------------------------------------
-- BASE GUI OLUŞTURMA
------------------------------------------------------------
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "UguzHubVIPMain"
ScreenGui.ResetOnSpawn = false
ScreenGui.IgnoreGuiInset = true
ScreenGui.Parent = CoreGui

------------------------------------------------------------
-- 1. YÜKLEME ANİMASYONU (INTRO)
------------------------------------------------------------
local LoadingFrame = Instance.new("Frame")
LoadingFrame.Name = "Loading"
LoadingFrame.Size = UDim2.fromScale(1, 1)
LoadingFrame.Position = UDim2.fromScale(0, 0)
LoadingFrame.BorderSizePixel = 0
LoadingFrame.BackgroundColor3 = Theme.Background
LoadingFrame.BackgroundTransparency = 0
LoadingFrame.ZIndex = 200
LoadingFrame.Parent = ScreenGui

local Content = Instance.new("Frame")
Content.Name = "Content"
Content.AnchorPoint = Vector2.new(0.5, 0.5)
Content.Position = UDim2.new(0.5, 0, 0.45, 0)
Content.Size = UDim2.new(0, 360, 0, 140)
Content.BackgroundTransparency = 1
Content.ZIndex = 201
Content.Parent = LoadingFrame

local LogoLabel = Instance.new("TextLabel")
LogoLabel.Text = "UguzHub"
LogoLabel.Font = Enum.Font.GothamBlack
LogoLabel.TextSize = 50
LogoLabel.TextColor3 = Theme.Text
LogoLabel.BackgroundTransparency = 1
LogoLabel.Size = UDim2.new(1, 0, 0, 60)
LogoLabel.Position = UDim2.new(0, 0, 0, 0)
LogoLabel.TextTransparency = 1
LogoLabel.ZIndex = 201
LogoLabel.Parent = Content

local ProTag = Instance.new("TextLabel")
ProTag.Text = "V2 PRO"
ProTag.Font = Enum.Font.GothamBold
ProTag.TextSize = 18
ProTag.TextColor3 = Theme.Accent
ProTag.BackgroundTransparency = 1
ProTag.Size = UDim2.new(1, 0, 0, 22)
ProTag.Position = UDim2.new(0, 0, 0, 58)
ProTag.TextTransparency = 1
ProTag.ZIndex = 201
ProTag.Parent = Content

local Underline = Instance.new("Frame")
Underline.Name = "Underline"
Underline.Size = UDim2.new(0, 0, 0, 3)
Underline.Position = UDim2.new(0.5, 0, 0, 88)
Underline.AnchorPoint = Vector2.new(0.5, 0)
Underline.BackgroundColor3 = Theme.Accent
Underline.BorderSizePixel = 0
Underline.ZIndex = 201
local uCorner = Instance.new("UICorner")
uCorner.CornerRadius = UDim.new(0, 2)
uCorner.Parent = Underline
Underline.Parent = Content

local LoadingLabel = Instance.new("TextLabel")
LoadingLabel.Text = "Loading"
LoadingLabel.Font = Enum.Font.GothamMedium
LoadingLabel.TextSize = 17
LoadingLabel.TextColor3 = Theme.SubText
LoadingLabel.BackgroundTransparency = 1
LoadingLabel.Size = UDim2.new(1, 0, 0, 24)
LoadingLabel.Position = UDim2.new(0, 0, 0, 108)
LoadingLabel.TextTransparency = 1
LoadingLabel.ZIndex = 201
LoadingLabel.Parent = Content

------------------------------------------------------------
-- 2. DİL SEÇİM MENÜSÜ
------------------------------------------------------------
local LangMenu = Instance.new("Frame")
LangMenu.Name = "LangMenu"
LangMenu.Size = UDim2.fromScale(1, 1)
LangMenu.BackgroundColor3 = Theme.Background
LangMenu.ZIndex = 100
LangMenu.Visible = false
LangMenu.Parent = ScreenGui

local Title = Instance.new("TextLabel")
Title.Text = "UguzHub  •  Language Selection"
Title.Size = UDim2.new(1, 0, 0, 80)
Title.Position = UDim2.new(0, 0, 0, 40)
Title.TextColor3 = Theme.Text
Title.Font = Enum.Font.GothamBold
Title.TextSize = 26
Title.BackgroundTransparency = 1
Title.Parent = LangMenu

local Scroll = Instance.new("ScrollingFrame")
Scroll.Size = UDim2.new(0, 320, 0, 360)
Scroll.Position = UDim2.new(0.5, -160, 0.5, -120)
Scroll.BackgroundTransparency = 1
Scroll.ScrollBarThickness = 4
Scroll.ScrollBarImageColor3 = Theme.Accent
Scroll.Parent = LangMenu

local ScrollList = Instance.new("UIListLayout")
ScrollList.Padding = UDim.new(0, 10)
ScrollList.HorizontalAlignment = Enum.HorizontalAlignment.Center
ScrollList.Parent = Scroll

ScrollList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    Scroll.CanvasSize = UDim2.new(0, 0, 0, ScrollList.AbsoluteContentSize.Y + 10)
end)

for code, data in pairs(LangData) do
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -20, 0, 45)
    btn.Text = data.name
    btn.BackgroundColor3 = Theme.Card
    btn.TextColor3 = Theme.Text
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 14
    btn.AutoButtonColor = false
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 10)
    corner.Parent = btn
    
    local stroke = Instance.new("UIStroke")
    stroke.Color = Theme.Accent
    stroke.Thickness = 1
    stroke.Transparency = 0.5
    stroke.Parent = btn

    btn.MouseButton1Click:Connect(function()
        Flags.SelectedLang = code
        TweenService:Create(LangMenu, TweenInfo.new(0.4), {BackgroundTransparency = 1}):Play()
        for _, v in pairs(LangMenu:GetDescendants()) do
            if v:IsA("TextLabel") or v:IsA("TextButton") then
                TweenService:Create(v, TweenInfo.new(0.3), {TextTransparency = 1}):Play()
            end
        end
        task.wait(0.4)
        LangMenu:Destroy()
        showWarningScreen() -- Dil Seçilince UYARI EKRANINA GEÇ
    end)
    btn.Parent = Scroll
end

------------------------------------------------------------
-- 3. UYARI EKRANI (DELTA AYARLARI & 7 SANİYE SAYAÇ)
------------------------------------------------------------
function showWarningScreen()
    local L = LangData[Flags.SelectedLang] or LangData.TR

    local WarnMenu = Instance.new("Frame")
    WarnMenu.Name = "WarnMenu"
    WarnMenu.Size = UDim2.fromScale(1, 1)
    WarnMenu.BackgroundColor3 = Theme.Background
    WarnMenu.ZIndex = 150
    WarnMenu.Parent = ScreenGui

    local WarnBox = Instance.new("Frame")
    WarnBox.Size = UDim2.new(0, 380, 0, 220)
    WarnBox.Position = UDim2.new(0.5, -190, 0.5, -110)
    WarnBox.BackgroundColor3 = Theme.Card
    WarnBox.Parent = WarnMenu

    local wCorner = Instance.new("UICorner")
    wCorner.CornerRadius = UDim.new(0, 12)
    wCorner.Parent = WarnBox

    local wStroke = Instance.new("UIStroke")
    wStroke.Color = Theme.Warning
    wStroke.Thickness = 1.5
    wStroke.Parent = WarnBox

    local wTitle = Instance.new("TextLabel")
    wTitle.Text = L.warningTitle
    wTitle.Size = UDim2.new(1, 0, 0, 45)
    wTitle.TextColor3 = Theme.Warning
    wTitle.Font = Enum.Font.GothamBold
    wTitle.TextSize = 16
    wTitle.BackgroundTransparency = 1
    wTitle.Parent = WarnBox

    local wMsg = Instance.new("TextLabel")
    wMsg.Text = L.warningMsg
    wMsg.Size = UDim2.new(1, -30, 0, 90)
    wMsg.Position = UDim2.new(0, 15, 0, 45)
    wMsg.TextColor3 = Theme.Text
    wMsg.Font = Enum.Font.GothamMedium
    wMsg.TextSize = 13
    wMsg.TextWrapped = true
    wMsg.BackgroundTransparency = 1
    wMsg.Parent = WarnBox

    local closeBtn = Instance.new("TextButton")
    closeBtn.Size = UDim2.new(1, -40, 0, 40)
    closeBtn.Position = UDim2.new(0, 20, 1, -50)
    closeBtn.BackgroundColor3 = Color3.fromRGB(40, 50, 65)
    closeBtn.TextColor3 = Theme.SubText
    closeBtn.Font = Enum.Font.GothamBold
    closeBtn.TextSize = 13
    closeBtn.AutoButtonColor = false
    closeBtn.Parent = WarnBox

    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 8)
    btnCorner.Parent = closeBtn

    local canClose = false

    local function proceedToMain()
        TweenService:Create(WarnMenu, TweenInfo.new(0.4), {BackgroundTransparency = 1}):Play()
        for _, v in pairs(WarnMenu:GetDescendants()) do
            if v:IsA("TextLabel") or v:IsA("TextButton") or v:IsA("Frame") then
                TweenService:Create(v, TweenInfo.new(0.3), {BackgroundTransparency = 1}):Play()
                if v:IsA("TextLabel") or v:IsA("TextButton") then
                    TweenService:Create(v, TweenInfo.new(0.3), {TextTransparency = 1}):Play()
                end
            end
        end
        task.wait(0.4)
        WarnMenu:Destroy()
        buildMainMenu()
    end

    closeBtn.MouseButton1Click:Connect(function()
        if canClose then
            proceedToMain()
        end
    end)

    -- 7 Saniye Sayacı
    task.spawn(function()
        for i = 7, 1, -1 do
            closeBtn.Text = "OK (" .. i .. "s)"
            task.wait(1)
        end
        canClose = true
        closeBtn.Text = "OK / TAMAM"
        closeBtn.BackgroundColor3 = Theme.Accent
        closeBtn.TextColor3 = Theme.Text
        
        -- Otomatik kapanıp ana menüye geçiş
        task.wait(0.5)
        if WarnMenu and WarnMenu.Parent then
            proceedToMain()
        end
    end)
end

------------------------------------------------------------
-- 4. ANA MENÜ OLUŞTURUCU
------------------------------------------------------------
function buildMainMenu()
    local L = LangData[Flags.SelectedLang] or LangData.TR

    local Main = Instance.new("Frame")
    Main.Name = "MainFrame"
    Main.Size = UDim2.new(0, 480, 0, 320)
    Main.Position = UDim2.new(0.5, -240, 0.5, -160)
    Main.BackgroundColor3 = Theme.Background
    Main.ClipsDescendants = true
    Main.Parent = ScreenGui

    local MainCorner = Instance.new("UICorner")
    MainCorner.CornerRadius = UDim.new(0, 12)
    MainCorner.Parent = Main

    local MainStroke = Instance.new("UIStroke")
    MainStroke.Color = Theme.Accent
    MainStroke.Thickness = 1.5
    MainStroke.Parent = Main

    -- Sürükleme Mantığı
    local dragging, dragStart, startPos
    Main.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = Main.Position
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            Main.Position = UDim2.new(
                startPos.X.Scale, 
                startPos.X.Offset + (input.Position.X - dragStart.X), 
                startPos.Y.Scale, 
                startPos.Y.Offset + (input.Position.Y - dragStart.Y)
            )
        end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)

    -- Header
    local Header = Instance.new("Frame")
    Header.Size = UDim2.new(1, 0, 0, 40)
    Header.BackgroundColor3 = Theme.Sidebar
    Header.Parent = Main

    local HeaderTitle = Instance.new("TextLabel")
    HeaderTitle.Text = "  ⚡ " .. L.title
    HeaderTitle.Size = UDim2.new(1, -40, 1, 0)
    HeaderTitle.TextColor3 = Theme.Text
    HeaderTitle.Font = Enum.Font.GothamBold
    HeaderTitle.TextSize = 14
    HeaderTitle.TextXAlignment = Enum.TextXAlignment.Left
    HeaderTitle.BackgroundTransparency = 1
    HeaderTitle.Parent = Header

    -- Sidebar
    local Sidebar = Instance.new("Frame")
    Sidebar.Size = UDim2.new(0, 130, 1, -40)
    Sidebar.Position = UDim2.new(0, 0, 0, 40)
    Sidebar.BackgroundColor3 = Theme.Sidebar
    Sidebar.Parent = Main

    local SidebarList = Instance.new("UIListLayout")
    SidebarList.Padding = UDim.new(0, 5)
    SidebarList.Parent = Sidebar

    -- İçerik
    local ContentContainer = Instance.new("Frame")
    ContentContainer.Size = UDim2.new(1, -140, 1, -50)
    ContentContainer.Position = UDim2.new(0, 135, 0, 45)
    ContentContainer.BackgroundTransparency = 1
    ContentContainer.Parent = Main

    local pages, tabBtns = {}, {}

    local function addTab(name, id)
        local page = Instance.new("ScrollingFrame")
        page.Size = UDim2.new(1, 0, 1, 0)
        page.BackgroundTransparency = 1
        page.ScrollBarThickness = 3
        page.Visible = false
        page.Parent = ContentContainer

        local pList = Instance.new("UIListLayout")
        pList.Padding = UDim.new(0, 8)
        pList.Parent = page

        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(1, 0, 0, 35)
        btn.Text = name
        btn.BackgroundColor3 = Theme.Sidebar
        btn.TextColor3 = Theme.SubText
        btn.Font = Enum.Font.GothamMedium
        btn.TextSize = 11
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
        frame.Size = UDim2.new(1, -5, 0, 36)
        frame.BackgroundColor3 = Theme.Card
        frame.Parent = parent

        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(0, 8)
        corner.Parent = frame

        local lbl = Instance.new("TextLabel")
        lbl.Text = "  " .. text
        lbl.Size = UDim2.new(0.7, 0, 1, 0)
        lbl.TextColor3 = Theme.Text
        lbl.Font = Enum.Font.Gotham
        lbl.TextSize = 11
        lbl.TextXAlignment = Enum.TextXAlignment.Left
        lbl.BackgroundTransparency = 1
        lbl.Parent = frame

        local toggleBtn = Instance.new("TextButton")
        toggleBtn.Size = UDim2.new(0, 50, 0, 22)
        toggleBtn.Position = UDim2.new(1, -55, 0.5, -11)
        toggleBtn.Text = "OFF"
        toggleBtn.BackgroundColor3 = Color3.fromRGB(40, 50, 65)
        toggleBtn.TextColor3 = Theme.SubText
        toggleBtn.Font = Enum.Font.GothamBold
        toggleBtn.TextSize = 10
        toggleBtn.Parent = frame

        local tCorner = Instance.new("UICorner")
        tCorner.CornerRadius = UDim.new(0, 6)
        tCorner.Parent = toggleBtn

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

    -- Sekmeleri Doldur
    local VisualsTab = addTab(L.tabVisuals, "Visuals")
    local AimbotTab  = addTab(L.tabAimbot, "Aimbot")
    local TeleportTab= addTab(L.tabTP, "TP")
    local ProfileTab = addTab(L.tabProfile, "Profile")

    createToggle(VisualsTab, L.espAll, "ESPAll")
    createToggle(VisualsTab, L.autoGrab, "AutoGrabGun")

    local ShootSpawnBtn = Instance.new("TextButton")
    ShootSpawnBtn.Size = UDim2.new(1, -5, 0, 38)
    ShootSpawnBtn.Text = L.shootBtn
    ShootSpawnBtn.BackgroundColor3 = Theme.Danger
    ShootSpawnBtn.TextColor3 = Theme.Text
    ShootSpawnBtn.Font = Enum.Font.GothamBold
    ShootSpawnBtn.TextSize = 11
    ShootSpawnBtn.Parent = AimbotTab

    local sCorner = Instance.new("UICorner")
    sCorner.CornerRadius = UDim.new(0, 8)
    sCorner.Parent = ShootSpawnBtn

    ShootSpawnBtn.MouseButton1Click:Connect(function()
        spawnShootButton()
    end)

    local function createTPButton(text, targetCFrame)
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(1, -5, 0, 36)
        btn.Text = text
        btn.BackgroundColor3 = Theme.Card
        btn.TextColor3 = Theme.Text
        btn.Font = Enum.Font.GothamMedium
        btn.TextSize = 11
        btn.Parent = TeleportTab

        local c = Instance.new("UICorner")
        c.CornerRadius = UDim.new(0, 8)
        c.Parent = btn

        btn.MouseButton1Click:Connect(function()
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                if type(targetCFrame) == "function" then
                    local target = targetCFrame()
                    if target then
                        LocalPlayer.Character.HumanoidRootPart.CFrame = target
                    end
                else
                    LocalPlayer.Character.HumanoidRootPart.CFrame = targetCFrame
                end
            end
        end)
    end

    createTPButton(L.tpLobby, CFrame.new(110, 138, -12))
    createTPButton(L.tpMurd, function()
        local m = getMurderer()
        if m and m.Character and m.Character:FindFirstChild("HumanoidRootPart") then
            return m.Character.HumanoidRootPart.CFrame
        end
        return nil
    end)

    local ProfBox = Instance.new("Frame")
    ProfBox.Size = UDim2.new(1, -5, 0, 150)
    ProfBox.BackgroundColor3 = Theme.Card
    ProfBox.Parent = ProfileTab

    local pCorner = Instance.new("UICorner")
    pCorner.CornerRadius = UDim.new(0, 8)
    pCorner.Parent = ProfBox

    local UserLabel = Instance.new("TextLabel")
    UserLabel.Text = "👤 " .. LocalPlayer.Name
    UserLabel.Size = UDim2.new(1, -10, 0, 30)
    UserLabel.Position = UDim2.new(0, 10, 0, 5)
    UserLabel.TextColor3 = Theme.Accent
    UserLabel.Font = Enum.Font.GothamBold
    UserLabel.TextSize = 13
    UserLabel.TextXAlignment = Enum.TextXAlignment.Left
    UserLabel.BackgroundTransparency = 1
    UserLabel.Parent = ProfBox

    local RoleLabel = Instance.new("TextLabel")
    RoleLabel.Text = "Rank: " .. L.userRole
    RoleLabel.Size = UDim2.new(1, -10, 0, 20)
    RoleLabel.Position = UDim2.new(0, 10, 0, 30)
    RoleLabel.TextColor3 = Theme.SubText
    RoleLabel.Font = Enum.Font.Gotham
    RoleLabel.TextSize = 11
    RoleLabel.TextXAlignment = Enum.TextXAlignment.Left
    RoleLabel.BackgroundTransparency = 1
    RoleLabel.Parent = ProfBox

    local MsgLabel = Instance.new("TextLabel")
    MsgLabel.Text = L.discordMsg
    MsgLabel.Size = UDim2.new(1, -20, 0, 80)
    MsgLabel.Position = UDim2.new(0, 10, 0, 60)
    MsgLabel.TextColor3 = Theme.Text
    MsgLabel.Font = Enum.Font.GothamMedium
    MsgLabel.TextSize = 11
    MsgLabel.TextWrapped = true
    MsgLabel.TextYAlignment = Enum.TextYAlignment.Top
    MsgLabel.TextXAlignment = Enum.TextXAlignment.Left
    MsgLabel.BackgroundTransparency = 1
    MsgLabel.Parent = ProfBox

    pages["Visuals"].Visible = true
    tabBtns["Visuals"].BackgroundColor3 = Theme.Card
    tabBtns["Visuals"].TextColor3 = Theme.Accent
end

------------------------------------------------------------
-- 5. ATEŞ BUTONU MANTIĞI
------------------------------------------------------------
function spawnShootButton()
    if ScreenGui:FindFirstChild("ShootActionButton") then return end

    local shootBtn = Instance.new("TextButton")
    shootBtn.Name = "ShootActionButton"
    shootBtn.Size = UDim2.new(0, 110, 0, 45)
    shootBtn.Position = UDim2.new(0.1, 0, 0.3, 0)
    shootBtn.Text = "🎯 SHOOT"
    shootBtn.BackgroundColor3 = Theme.Danger
    shootBtn.TextColor3 = Theme.Text
    shootBtn.Font = Enum.Font.GothamBlack
    shootBtn.TextSize = 13
    shootBtn.Parent = ScreenGui

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 10)
    corner.Parent = shootBtn

    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(255, 255, 255)
    stroke.Thickness = 1.5
    stroke.Parent = shootBtn

    local dragging, dragStart, startPos
    shootBtn.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true; dragStart = input.Position; startPos = shootBtn.Position
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            shootBtn.Position = UDim2.new(
                startPos.X.Scale, 
                startPos.X.Offset + (input.Position.X - dragStart.X), 
                startPos.Y.Scale, 
                startPos.Y.Offset + (input.Position.Y - dragStart.Y)
            )
        end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
    end)

    shootBtn.MouseButton1Click:Connect(function()
        local murd = getMurderer()
        if murd and murd.Character and murd.Character:FindFirstChild("HumanoidRootPart") then
            Camera.CFrame = CFrame.new(Camera.CFrame.Position, murd.Character.HumanoidRootPart.Position)
        end
    end)
end

------------------------------------------------------------
-- ANİMASYON SÜRECİ
------------------------------------------------------------
task.defer(function()
    TweenService:Create(LogoLabel, TweenInfo.new(0.6), { TextTransparency = 0 }):Play()
    TweenService:Create(ProTag, TweenInfo.new(0.6), { TextTransparency = 0 }):Play()
    task.wait(0.15)
    TweenService:Create(Underline, TweenInfo.new(0.6, Enum.EasingStyle.Quart), { Size = UDim2.new(0, 220, 0, 3) }):Play()
    task.wait(0.2)
    TweenService:Create(LoadingLabel, TweenInfo.new(0.4), { TextTransparency = 0 }):Play()

    local dotsRunning = true
    task.spawn(function()
        local states = { "Loading", "Loading.", "Loading..", "Loading..." }
        local i = 1
        while dotsRunning do
            LoadingLabel.Text = states[i]
            i = (i % #states) + 1
            task.wait(0.4)
        end
    end)

    task.wait(4)
    dotsRunning = false

    TweenService:Create(LoadingFrame, TweenInfo.new(0.5), { BackgroundTransparency = 1 }):Play()
    TweenService:Create(LogoLabel, TweenInfo.new(0.4), { TextTransparency = 1 }):Play()
    TweenService:Create(ProTag, TweenInfo.new(0.4), { TextTransparency = 1 }):Play()
    TweenService:Create(Underline, TweenInfo.new(0.4), { BackgroundTransparency = 1 }):Play()
    TweenService:Create(LoadingLabel, TweenInfo.new(0.4), { TextTransparency = 1 }):Play()
    
    task.wait(0.5)
    LoadingFrame:Destroy()
    
    LangMenu.Visible = true
end)
