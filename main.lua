-- [[ UguzHub V2 VIP - Complete Fixed & Feature Rich Edition ]] --
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
-- TEMA VE BAYRAKLAR
------------------------------------------------------------
local Flags = {
    ESPAll = false,
    ESPGun = false,
    AutoGrabGun = false,
    AutoFarm = false,
    SelectedLang = "TR"
}

local Theme = {
    Background = Color3.fromRGB(16, 16, 22),
    Sidebar    = Color3.fromRGB(16, 23, 38),
    Card       = Color3.fromRGB(25, 35, 50),
    Accent     = Color3.fromRGB(138, 92, 255),
    Text       = Color3.fromRGB(235, 235, 245),
    SubText    = Color3.fromRGB(165, 165, 180),
    Danger     = Color3.fromRGB(220, 38, 38),
    Warning    = Color3.fromRGB(245, 158, 11)
}

------------------------------------------------------------
-- DİL PAKETLERİ
------------------------------------------------------------
local LangData = {
    TR = {
        name = "🇹🇷 Türkçe",
        title = "UguzHub V2 VIP",
        warningTitle = "⚠️ ÖNEMLİ UYARI",
        warningMsg = "Delta Ayarlarındaki Tüm Herşeyi Kapattığınızdan Emin Olun! Sizlere Daha İyi Bir Deneyim Yaşatmak İçin Çabalıyoruz!",
        discordMsg = "İsteklerinizi veya Şikayetlerinizi Discord sunucumuza yazabilirsiniz!",
        tabVisuals = "Görsel (ESP)",
        tabCombat = "Savaş & Kill",
        tabFarm = "Auto Farm",
        tabTP = "Teleport",
        tabProfile = "Profil",
        espAll = "Oyuncu ESP",
        autoGrab = "Otomatik Silah Topla",
        autoFarm = "Otomatik Coin Farm",
        killAll = "🔪 Kill All (Herkesi Öldür)",
        flingMurd = "🌀 Fling Murderer",
        flingSheriff = "🌀 Fling Sheriff",
        flingAll = "🌀 Fling All",
        shootBtn = "🎯 Shoot Murderer (Buton)",
        tpLobby = "Lobiye Işınlan",
        tpMap = "Haritaya Işınlan",
        tpMurd = "Katile Işınlan",
        tpSheriff = "Şerife Işınlan",
        userRole = "VIP Üye"
    },
    EN = {
        name = "🇬🇧 English",
        title = "UguzHub V2 VIP",
        warningTitle = "⚠️ IMPORTANT WARNING",
        warningMsg = "Make sure to turn off everything in Delta Settings! We are striving to provide you with a better experience!",
        discordMsg = "You can join our Discord server for support!",
        tabVisuals = "Visuals (ESP)",
        tabCombat = "Combat & Kill",
        tabFarm = "Auto Farm",
        tabTP = "Teleport",
        tabProfile = "Profile",
        espAll = "Player ESP",
        autoGrab = "Auto Grab Gun",
        autoFarm = "Auto Coin Farm",
        killAll = "🔪 Kill All",
        flingMurd = "🌀 Fling Murderer",
        flingSheriff = "🌀 Fling Sheriff",
        flingAll = "🌀 Fling All",
        shootBtn = "🎯 Shoot Murderer (Button)",
        tpLobby = "Teleport to Lobby",
        tpMap = "Teleport to Map",
        tpMurd = "Teleport to Murderer",
        tpSheriff = "Teleport to Sheriff",
        userRole = "VIP Member"
    }
}

------------------------------------------------------------
-- YARDIMCI FONKSİYONLAR & OYUN MANTIĞI
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

local function getPlayerByRole(roleName)
    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and getRole(plr) == roleName then
            return plr
        end
    end
    return nil
end

-- Fling Mantığı
local function flingTarget(targetPlr)
    if not targetPlr or not targetPlr.Character then return end
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    local tHrp = targetPlr.Character:FindFirstChild("HumanoidRootPart")
    
    if hrp and tHrp then
        local bV = Instance.new("BodyVelocity")
        bV.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
        bV.Velocity = Vector3.new(99999, 99999, 99999)
        bV.Parent = hrp

        local timer = 0
        while timer < 1.5 and tHrp and tHrp.Parent do
            hrp.CFrame = tHrp.CFrame * CFrame.new(0, 0, 0)
            task.wait(0.05)
            timer = timer + 0.05
        end
        bV:Destroy()
    end
end

------------------------------------------------------------
-- MAIN DÖNGÜ (ESP & AUTO FARM)
------------------------------------------------------------
RunService.RenderStepped:Connect(function()
    pcall(function()
        -- ESP
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

        -- Auto Grab Gun
        if Flags.AutoGrabGun then
            local gunDrop = Workspace:FindFirstChild("GunDrop", true)
            if gunDrop and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                LocalPlayer.Character.HumanoidRootPart.CFrame = gunDrop.CFrame
            end
        end

        -- Auto Farm (Coins)
        if Flags.AutoFarm and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            local coinContainer = Workspace:FindFirstChild("Normal", true) or Workspace:FindFirstChild("CoinContainer", true)
            if coinContainer then
                for _, coin in pairs(coinContainer:GetChildren()) do
                    if coin:IsA("BasePart") and coin.Name:lower():find("coin") then
                        LocalPlayer.Character.HumanoidRootPart.CFrame = coin.CFrame
                        task.wait(0.1)
                        break
                    end
                end
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
-- 1. INTRO
------------------------------------------------------------
local LoadingFrame = Instance.new("Frame")
LoadingFrame.Name = "Loading"
LoadingFrame.Size = UDim2.fromScale(1, 1)
LoadingFrame.BackgroundColor3 = Theme.Background
LoadingFrame.ZIndex = 200
LoadingFrame.Parent = ScreenGui

local Content = Instance.new("Frame")
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
Underline.Size = UDim2.new(0, 0, 0, 3)
Underline.Position = UDim2.new(0.5, 0, 0, 88)
Underline.AnchorPoint = Vector2.new(0.5, 0)
Underline.BackgroundColor3 = Theme.Accent
Underline.BorderSizePixel = 0
Underline.ZIndex = 201
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
-- 2. DİL MENÜSÜ & UYARI & MAIN BAĞLANTILARI
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
Scroll.Size = UDim2.new(0, 320, 0, 300)
Scroll.Position = UDim2.new(0.5, -160, 0.5, -100)
Scroll.BackgroundTransparency = 1
Scroll.ScrollBarThickness = 4
Scroll.Parent = LangMenu

local ScrollList = Instance.new("UIListLayout")
ScrollList.Padding = UDim.new(0, 10)
ScrollList.HorizontalAlignment = Enum.HorizontalAlignment.Center
ScrollList.Parent = Scroll

-- İleriye dönük fonksiyon tanımları
local showWarningScreen
local buildMainMenu

for code, data in pairs(LangData) do
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -20, 0, 45)
    btn.Text = data.name
    btn.BackgroundColor3 = Theme.Card
    btn.TextColor3 = Theme.Text
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 14
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 10)
    corner.Parent = btn

    btn.MouseButton1Click:Connect(function()
        Flags.SelectedLang = code
        LangMenu:Destroy()
        showWarningScreen()
    end)
    btn.Parent = Scroll
end

function showWarningScreen()
    local L = LangData[Flags.SelectedLang] or LangData.TR

    local WarnMenu = Instance.new("Frame")
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
    closeBtn.Parent = WarnBox

    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 8)
    btnCorner.Parent = closeBtn

    task.spawn(function()
        for i = 7, 1, -1 do
            closeBtn.Text = "TAMAM (" .. i .. "s)"
            task.wait(1)
        end
        closeBtn.Text = "TAMAM"
        closeBtn.BackgroundColor3 = Theme.Accent
        closeBtn.TextColor3 = Theme.Text
        
        task.wait(0.3)
        WarnMenu:Destroy()
        buildMainMenu()
    end)
end

------------------------------------------------------------
-- 3. ANA MENÜ
------------------------------------------------------------
function buildMainMenu()
    local L = LangData[Flags.SelectedLang] or LangData.TR

    local Main = Instance.new("Frame")
    Main.Name = "MainFrame"
    Main.Size = UDim2.new(0, 500, 0, 340)
    Main.Position = UDim2.new(0.5, -250, 0.5, -170)
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

    -- Drag
    local dragging, dragStart, startPos
    Main.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true; dragStart = input.Position; startPos = Main.Position
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            Main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + (input.Position.X - dragStart.X), startPos.Y.Scale, startPos.Y.Offset + (input.Position.Y - dragStart.Y))
        end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
    end)

    -- Header
    local Header = Instance.new("Frame")
    Header.Size = UDim2.new(1, 0, 0, 40)
    Header.BackgroundColor3 = Theme.Sidebar
    Header.Parent = Main

    local HeaderTitle = Instance.new("TextLabel")
    HeaderTitle.Text = "  ⚡ " .. L.title
    HeaderTitle.Size = UDim2.new(1, 0, 1, 0)
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
    SidebarList.Padding = UDim.new(0, 4)
    SidebarList.Parent = Sidebar

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
        btn.Size = UDim2.new(1, 0, 0, 32)
        btn.Text = name
        btn.BackgroundColor3 = Theme.Sidebar
        btn.TextColor3 = Theme.SubText
        btn.Font = Enum.Font.GothamMedium
        btn.TextSize = 11
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

    local function createButton(parent, text, color, callback)
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(1, -5, 0, 36)
        btn.Text = text
        btn.BackgroundColor3 = color or Theme.Card
        btn.TextColor3 = Theme.Text
        btn.Font = Enum.Font.GothamBold
        btn.TextSize = 11
        btn.Parent = parent

        local c = Instance.new("UICorner")
        c.CornerRadius = UDim.new(0, 8)
        c.Parent = btn

        btn.MouseButton1Click:Connect(callback)
    end

    -- Tablar
    local VisualsTab = addTab(L.tabVisuals, "Visuals")
    local CombatTab  = addTab(L.tabCombat, "Combat")
    local FarmTab    = addTab(L.tabFarm, "Farm")
    local TeleportTab= addTab(L.tabTP, "TP")
    local ProfileTab = addTab(L.tabProfile, "Profile")

    -- Visuals
    createToggle(VisualsTab, L.espAll, "ESPAll")
    createToggle(VisualsTab, L.autoGrab, "AutoGrabGun")

    -- Combat & Actions
    createButton(CombatTab, L.killAll, Theme.Danger, function()
        pcall(function()
            for _, plr in pairs(Players:GetPlayers()) do
                if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
                    LocalPlayer.Character.HumanoidRootPart.CFrame = plr.Character.HumanoidRootPart.CFrame
                    task.wait(0.2)
                end
            end
        end)
    end)
    createButton(CombatTab, L.flingMurd, Theme.Card, function() flingTarget(getPlayerByRole("Murderer")) end)
    createButton(CombatTab, L.flingSheriff, Theme.Card, function() flingTarget(getPlayerByRole("Sheriff")) end)
    createButton(CombatTab, L.flingAll, Theme.Card, function()
        for _, plr in pairs(Players:GetPlayers()) do
            if plr ~= LocalPlayer then flingTarget(plr) end
        end
    end)
    createButton(CombatTab, L.shootBtn, Theme.Accent, function() spawnShootButton() end)

    -- Auto Farm
    createToggle(FarmTab, L.autoFarm, "AutoFarm")

    -- Teleport
    createButton(TeleportTab, L.tpLobby, Theme.Card, function()
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(110, 138, -12)
        end
    end)
    createButton(TeleportTab, L.tpMurd, Theme.Card, function()
        local m = getPlayerByRole("Murderer")
        if m and m.Character and m.Character:FindFirstChild("HumanoidRootPart") then
            LocalPlayer.Character.HumanoidRootPart.CFrame = m.Character.HumanoidRootPart.CFrame
        end
    end)
    createButton(TeleportTab, L.tpSheriff, Theme.Card, function()
        local s = getPlayerByRole("Sheriff")
        if s and s.Character and s.Character:FindFirstChild("HumanoidRootPart") then
            LocalPlayer.Character.HumanoidRootPart.CFrame = s.Character.HumanoidRootPart.CFrame
        end
    end)

    -- Profile
    local UserLabel = Instance.new("TextLabel")
    UserLabel.Text = "👤 Kullanıcı: " .. LocalPlayer.Name .. "\nRank: " .. L.userRole .. "\n\n" .. L.discordMsg
    UserLabel.Size = UDim2.new(1, -10, 1, 0)
    UserLabel.TextColor3 = Theme.Text
    UserLabel.Font = Enum.Font.GothamMedium
    UserLabel.TextSize = 12
    UserLabel.TextWrapped = true
    UserLabel.BackgroundTransparency = 1
    UserLabel.Parent = ProfileTab

    -- Varsayılan Tab
    pages["Visuals"].Visible = true
    tabBtns["Visuals"].BackgroundColor3 = Theme.Card
    tabBtns["Visuals"].TextColor3 = Theme.Accent
end

------------------------------------------------------------
-- 4. ATEŞ BUTONU
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

    local dragging, dragStart, startPos
    shootBtn.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true; dragStart = input.Position; startPos = shootBtn.Position
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            shootBtn.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + (input.Position.X - dragStart.X), startPos.Y.Scale, startPos.Y.Offset + (input.Position.Y - dragStart.Y))
        end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
    end)

    shootBtn.MouseButton1Click:Connect(function()
        local murd = getPlayerByRole("Murderer")
        if murd and murd.Character and murd.Character:FindFirstChild("HumanoidRootPart") then
            Camera.CFrame = CFrame.new(Camera.CFrame.Position, murd.Character.HumanoidRootPart.Position)
        end
    end)
end

------------------------------------------------------------
-- BAŞLATMA
------------------------------------------------------------
task.defer(function()
    TweenService:Create(LogoLabel, TweenInfo.new(0.6), { TextTransparency = 0 }):Play()
    TweenService:Create(ProTag, TweenInfo.new(0.6), { TextTransparency = 0 }):Play()
    task.wait(0.15)
    TweenService:Create(Underline, TweenInfo.new(0.6, Enum.EasingStyle.Quart), { Size = UDim2.new(0, 220, 0, 3) }):Play()
    task.wait(0.2)
    TweenService:Create(LoadingLabel, TweenInfo.new(0.4), { TextTransparency = 0 }):Play()

    task.wait(3.5)

    TweenService:Create(LoadingFrame, TweenInfo.new(0.5), { BackgroundTransparency = 1 }):Play()
    TweenService:Create(LogoLabel, TweenInfo.new(0.4), { TextTransparency = 1 }):Play()
    TweenService:Create(ProTag, TweenInfo.new(0.4), { TextTransparency = 1 }):Play()
    TweenService:Create(Underline, TweenInfo.new(0.4), { BackgroundTransparency = 1 }):Play()
    TweenService:Create(LoadingLabel, TweenInfo.new(0.4), { TextTransparency = 1 }):Play()
    
    task.wait(0.5)
    LoadingFrame:Destroy()
    
    LangMenu.Visible = true
end)
