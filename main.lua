-- [[ UguzHub V2 VIP - Full Master Edition ]] --
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
    Background = Color3.fromRGB(10, 15, 25),      -- Kapalı Mavi Arka Plan
    Sidebar    = Color3.fromRGB(16, 23, 38),      -- Yan Menü
    Card       = Color3.fromRGB(25, 35, 50),       -- Butonlar / Paneller
    Accent     = Color3.fromRGB(147, 51, 234),     -- Neon Mor
    Text       = Color3.fromRGB(255, 255, 255),    -- Beyaz
    SubText    = Color3.fromRGB(160, 175, 200),   -- Açık Gri/Mavi
    Danger     = Color3.fromRGB(220, 38, 38)       -- Kırmızı
}

------------------------------------------------------------
-- 8 DİL PAKETİ VE SİSTEM MESAJLARI
------------------------------------------------------------
local LangData = {
    TR = {
        name = "🇹🇷 Türkçe",
        title = "UguzHub V2 VIP",
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
-- ROL VE OYUN MANTIĞI FONKSİYONLARI
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
-- MAIN LOOP (RENDERSTEPPED)
------------------------------------------------------------
RunService.RenderStepped:Connect(function()
    pcall(function()
        -- 1. ESP TESPİTİ
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

        -- 2. AUTO GRAB GUN
        if Flags.AutoGrabGun then
            local gunDrop = Workspace:FindFirstChild("GunDrop", true)
            if gunDrop and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                LocalPlayer.Character.HumanoidRootPart.CFrame = gunDrop.CFrame
            end
        end
    end)
end)

------------------------------------------------------------
-- GUI OLUŞTURMA
------------------------------------------------------------
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "UguzHubVIPMain"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = CoreGui

-- 1. DİL SEÇİM MENÜSÜ (EKRANI KAPLAYAN MODERN GEÇİŞ)
local LangMenu = Instance.new("Frame")
LangMenu.Name = "LangMenu"
LangMenu.Size = UDim2.fromScale(1, 1)
LangMenu.BackgroundColor3 = Theme.Background
LangMenu.ZIndex = 100
LangMenu.Parent = ScreenGui

local Title = Instance.new("TextLabel")
Title.Text = "UguzHub  •  Language Selection"
Title.Size = UDim2.new(1, 0, 0, 80)
Title.Position = UDim2.new(0, 0, 0, 20)
Title.TextColor3 = Theme.Text
Title.Font = Enum.Font.GothamBold
Title.TextSize = 26
Title.BackgroundTransparency = 1
Title.Parent = LangMenu

local Scroll = Instance.new("ScrollingFrame")
Scroll.Size = UDim2.new(0, 320, 0, 360)
Scroll.Position = UDim2.new(0.5, -160, 0.5, -150)
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
        task.wait(0.4)
        LangMenu:Destroy()
        buildMainMenu()
    end)
    btn.Parent = Scroll
end

------------------------------------------------------------
-- 2. ANA MENÜ (SEKMELİ, MODERN VE SÜRÜKLENEBİLİR)
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

    -- Header (Üst Bar)
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

    -- Sidebar (Yan Sekmeler)
    local Sidebar = Instance.new("Frame")
    Sidebar.Size = UDim2.new(0, 130, 1, -40)
    Sidebar.Position = UDim2.new(0, 0, 0, 40)
    Sidebar.BackgroundColor3 = Theme.Sidebar
    Sidebar.Parent = Main

    local SidebarList = Instance.new("UIListLayout")
    SidebarList.Padding = UDim.new(0, 5)
    SidebarList.Parent = Sidebar

    -- İçerik Konteynırı
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

    -- SEKMELER
    local VisualsTab = addTab(L.tabVisuals, "Visuals")
    local AimbotTab  = addTab(L.tabAimbot, "Aimbot")
    local TeleportTab= addTab(L.tabTP, "TP")
    local ProfileTab = addTab(L.tabProfile, "Profile")

    -- Visuals Tab
    createToggle(VisualsTab, L.espAll, "ESPAll")
    createToggle(VisualsTab, L.autoGrab, "AutoGrabGun")

    -- Aimbot Tab
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

    -- Teleport Tab
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

    -- Profile & Support Tab
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

    -- İlk Sekmeyi Aç
    pages["Visuals"].Visible = true
    tabBtns["Visuals"].BackgroundColor3 = Theme.Card
    tabBtns["Visuals"].TextColor3 = Theme.Accent
end

------------------------------------------------------------
-- 3. SÜRÜKLENEBİLİR ATEŞ BUTONU (SHOOT MURDERER)
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

    -- Sürükleme
    local dragging, dragStart, startPos
    shootBtn.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = shootBtn.Position
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
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)

    -- Tıklama Mantığı (Katile Kilitlen)
    shootBtn.MouseButton1Click:Connect(function()
        local murd = getMurderer()
        if murd and murd.Character and murd.Character:FindFirstChild("HumanoidRootPart") then
            Camera.CFrame = CFrame.new(Camera.CFrame.Position, murd.Character.HumanoidRootPart.Position)
        end
    end)
end
