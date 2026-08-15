--[[
    UguzHub V2 Pro - MM2 Full Feature Integration
    Animasyonlu, çok dilli (TR / RU / EN / DE / FR / ES / AR / ZH) oyun içi menü arayüzü
    30 Günlük Hesap Yaş Kontrolü + Eksiksiz Hile Özellikleri
    ============================================================
]]

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local Debris = game:GetService("Debris")

local LocalPlayer = Players.LocalPlayer

------------------------------------------------------------
-- 0) 30 GÜNLÜK HESAP YAŞ KONTROLÜ (KICK)
------------------------------------------------------------
if LocalPlayer.AccountAge < 30 then
    LocalPlayer:Kick("Your account is less than 30 days old.")
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
    Card         = Color3.fromRGB(32, 32, 42),
    Accent       = Color3.fromRGB(138, 92, 255),
    AccentSoft   = Color3.fromRGB(90, 60, 180),
    Blue         = Color3.fromRGB(41, 121, 255),
    BlueSoft     = Color3.fromRGB(70, 150, 255),
    Text         = Color3.fromRGB(235, 235, 245),
    SubText      = Color3.fromRGB(165, 165, 180),
    Stroke       = Color3.fromRGB(55, 55, 70),
}

local CARD_TRANSPARENCY = 0.28
local RADIUS = 16

------------------------------------------------------------
-- DİL PAKETLERİ
------------------------------------------------------------
local Lang = {}

Lang.EN = { 
    loading = "Loading", 
    subtitle = "Select your language", 
    greeting = "How are you today", 
    sectionTitle = "Settings", 
    openBtn = "UguzHub" 
}
Lang.TR = { 
    loading = "Yükleniyor", 
    subtitle = "Dilinizi seçin", 
    greeting = "Bugün nasılsın", 
    sectionTitle = "Ayarlar", 
    openBtn = "UguzHub" 
}
Lang.RU = { 
    loading = "Загрузка", 
    subtitle = "Выберите язык", 
    greeting = "Как дела сегодня", 
    sectionTitle = "Настройки", 
    openBtn = "UguzHub" 
}
Lang.DE = { 
    loading = "Wird geladen", 
    subtitle = "Wähle deine Sprache", 
    greeting = "Wie geht es dir heute", 
    sectionTitle = "Einstellungen", 
    openBtn = "UguzHub" 
}
Lang.FR = { 
    loading = "Chargement", 
    subtitle = "Choisissez votre langue", 
    greeting = "Comment vas-tu aujourd'hui", 
    sectionTitle = "Paramètres", 
    openBtn = "UguzHub" 
}
Lang.ES = { 
    loading = "Cargando", 
    subtitle = "Selecciona tu idioma", 
    greeting = "¿Cómo estás hoy", 
    sectionTitle = "Ajustes", 
    openBtn = "UguzHub" 
}
Lang.AR = { 
    loading = "جار التحميل", 
    subtitle = "اختر لغتك", 
    greeting = "كيف حالك اليوم", 
    sectionTitle = "الإعدادات", 
    openBtn = "UguzHub" 
}
Lang.ZH = { 
    loading = "加载中", 
    subtitle = "选择你的语言", 
    greeting = "你今天好吗", 
    sectionTitle = "设置", 
    openBtn = "UguzHub" 
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
    ESPAll = false,
    ESPGun = false,
    AutoGrabGun = false,
    AimbotEnabled = false,
    AutoKillMurderer = false,
    AutoFlingMurderer = false,
    AutoFlingSheriff = false,
    AutoFlingAll = false
}

local RoleColors = {
    Murderer = Color3.fromRGB(239, 68, 68),
    Sheriff = Color3.fromRGB(59, 130, 246),
    Innocent = Color3.fromRGB(34, 197, 94),
    Gun = Color3.fromRGB(234, 179, 8)
}

local function getRole(player)
    if not player or not player.Character then return "Innocent" end
    if player.Backpack:FindFirstChild("Knife") or player.Character:FindFirstChild("Knife") then
        return "Murderer"
    elseif player.Backpack:FindFirstChild("Gun") or player.Character:FindFirstChild("Gun") then
        return "Sheriff"
    end
    return "Innocent"
end

local function superFling(targetPlayer)
    if not targetPlayer or targetPlayer == LocalPlayer or not targetPlayer.Character then return end
    local myChar = LocalPlayer.Character
    local targetChar = targetPlayer.Character
    local myHrp = myChar and myChar:FindFirstChild("HumanoidRootPart")
    local targetHrp = targetChar and targetChar:FindFirstChild("HumanoidRootPart")
    
    if not myHrp or not targetHrp then return end

    local oldCFrame = myHrp.CFrame
    local bav = Instance.new("BodyAngularVelocity")
    bav.Name = "UltraFlingForce"
    bav.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
    bav.AngularVelocity = Vector3.new(0, 9999999, 0)
    bav.Parent = myHrp

    for i = 1, 20 do
        if not targetHrp or not targetHrp.Parent or not myHrp or not myHrp.Parent then break end
        for _, part in pairs(myChar:GetChildren()) do
            if part:IsA("BasePart") then part.CanCollide = false end
        end
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
    while task.wait(0.1) do
        if Flags.AutoFlingMurderer then
            for _, p in pairs(Players:GetPlayers()) do
                if p ~= LocalPlayer and getRole(p) == "Murderer" and Flags.AutoFlingMurderer then superFling(p) end
            end
        end
        if Flags.AutoFlingSheriff then
            for _, p in pairs(Players:GetPlayers()) do
                if p ~= LocalPlayer and getRole(p) == "Sheriff" and Flags.AutoFlingSheriff then superFling(p) end
            end
        end
        if Flags.AutoFlingAll then
            for _, p in pairs(Players:GetPlayers()) do
                if p ~= LocalPlayer and Flags.AutoFlingAll then superFling(p) end
            end
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

local function corner(radius)
    return create("UICorner", { CornerRadius = UDim.new(0, radius or RADIUS) })
end

local function stroke(color, thickness)
    return create("UIStroke", {
        Color = color or Theme.Stroke,
        Thickness = thickness or 1,
        Transparency = 0.4,
    })
end

local function tween(obj, props, duration, style, direction)
    local info = TweenInfo.new(duration or 0.3, style or Enum.EasingStyle.Quint, direction or Enum.EasingDirection.Out)
    local t = TweenService:Create(obj, info, props)
    t:Play()
    return t
end

------------------------------------------------------------
-- ANA GUI
------------------------------------------------------------
local ScreenGui = create("ScreenGui", {
    Name = "UguzHubV2Pro",
    ResetOnSpawn = false,
    ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
    DisplayOrder = 50,
})
ScreenGui.Parent = PlayerGui

------------------------------------------------------------
-- GİRİŞ EKRANI
------------------------------------------------------------
local IntroFrame = create("Frame", {
    Name = "Intro",
    Size = UDim2.fromScale(1, 1),
    BackgroundColor3 = Theme.Background,
    BackgroundTransparency = 0,
    ZIndex = 10,
})
IntroFrame.Parent = ScreenGui

local LogoLabel = create("TextLabel", {
    Text = "UguzHub",
    Font = Enum.Font.GothamBlack,
    TextSize = 56,
    TextColor3 = Theme.Text,
    BackgroundTransparency = 1,
    Size = UDim2.new(0, 500, 0, 70),
    Position = UDim2.new(0.5, -250, 0.38, -60),
    TextTransparency = 1,
    ZIndex = 11,
})
LogoLabel.Parent = IntroFrame

local ProTag = create("TextLabel", {
    Text = "V2 PRO",
    Font = Enum.Font.GothamBold,
    TextSize = 20,
    TextColor3 = Theme.Accent,
    BackgroundTransparency = 1,
    Size = UDim2.new(0, 200, 0, 24),
    Position = UDim2.new(0.5, -50, 0.38, 12),
    TextTransparency = 1,
    ZIndex = 11,
})
ProTag.Parent = IntroFrame

local Underline = create("Frame", {
    Name = "Underline",
    Size = UDim2.new(0, 0, 0, 3),
    Position = UDim2.new(0.5, 0, 0.38, 46),
    AnchorPoint = Vector2.new(0.5, 0),
    BackgroundColor3 = Theme.Accent,
    BorderSizePixel = 0,
    ZIndex = 11,
})
corner(2).Parent = Underline
Underline.Parent = IntroFrame

local LoadingLabel = create("TextLabel", {
    Text = L.loading,
    Font = Enum.Font.GothamMedium,
    TextSize = 18,
    TextColor3 = Theme.SubText,
    BackgroundTransparency = 1,
    Size = UDim2.new(0, 400, 0, 24),
    Position = UDim2.new(0.5, -200, 0.5, 0),
    TextTransparency = 1,
    ZIndex = 11,
})
LoadingLabel.Parent = IntroFrame

local SubtitleLabel = create("TextLabel", {
    Text = L.subtitle,
    Font = Enum.Font.Gotham,
    TextSize = 16,
    TextColor3 = Theme.SubText,
    BackgroundTransparency = 1,
    Size = UDim2.new(0, 500, 0, 24),
    Position = UDim2.new(0.5, -250, 0.5, 0),
    TextTransparency = 1,
    ZIndex = 11,
    Visible = false,
})
SubtitleLabel.Parent = IntroFrame

local LangHolder = create("Frame", {
    Size = UDim2.new(0, 420, 0, 90),
    Position = UDim2.new(0.5, -210, 0.58, 0),
    BackgroundTransparency = 1,
    ZIndex = 11,
    Visible = false,
})
LangHolder.Parent = IntroFrame

create("UIListLayout", {
    FillDirection = Enum.FillDirection.Horizontal,
    HorizontalAlignment = Enum.HorizontalAlignment.Center,
    VerticalAlignment = Enum.VerticalAlignment.Center,
    Padding = UDim.new(0, 20),
}).Parent = LangHolder

local langButtons = {}

------------------------------------------------------------
-- MİNİMİZE BUTON
------------------------------------------------------------
local MinimizedButton = create("TextButton", {
    Name = "MinimizedButton",
    Text = "🟣 " .. L.openBtn,
    Font = Enum.Font.GothamBold,
    TextSize = 15,
    TextColor3 = Theme.Text,
    BackgroundColor3 = Theme.Sidebar,
    Size = UDim2.new(0, 118, 0, 38),
    Position = UDim2.new(1, -134, 0, 16),
    AutoButtonColor = false,
    Visible = false,
    ZIndex = 8,
})
corner(10).Parent = MinimizedButton
stroke(Theme.Accent, 1.2).Parent = MinimizedButton
MinimizedButton.Parent = ScreenGui

MinimizedButton.MouseEnter:Connect(function()
    tween(MinimizedButton, { BackgroundColor3 = Theme.AccentSoft }, 0.15)
end)
MinimizedButton.MouseLeave:Connect(function()
    tween(MinimizedButton, { BackgroundColor3 = Theme.Sidebar }, 0.15)
end)

------------------------------------------------------------
-- ANA MENÜ (forward declare)
------------------------------------------------------------
local MainFrame
local buildMainMenu
local openMenu
local closeMenu

local function selectLanguage(code)
    CurrentLang = code
    L = Lang[CurrentLang]

    for _, btn in ipairs(langButtons) do
        local isSelected = btn:GetAttribute("Code") == code
        tween(btn, { BackgroundColor3 = isSelected and Theme.Accent or Theme.Card }, 0.2)
    end

    SubtitleLabel.Text = L.subtitle

    task.delay(0.3, function()
        tween(IntroFrame, { BackgroundTransparency = 1 }, 0.45)
        tween(LogoLabel, { TextTransparency = 1 }, 0.3)
        tween(ProTag, { TextTransparency = 1 }, 0.3)
        tween(SubtitleLabel, { TextTransparency = 1 }, 0.3)
        for _, btn in ipairs(langButtons) do
            tween(btn, { BackgroundTransparency = 1 }, 0.3)
        end
        task.wait(0.45)
        IntroFrame.Visible = false

        if not MainFrame then
            buildMainMenu()
        end

        MinimizedButton.Visible = true
        MinimizedButton.BackgroundTransparency = 1
        MinimizedButton.Text = "🟣 " .. L.openBtn
        tween(MinimizedButton, { BackgroundTransparency = 0 }, 0.3)
    end)
end

for _, opt in ipairs(LanguageOptions) do
    local btn = create("TextButton", {
        Size = UDim2.new(0, 120, 0, 90),
        BackgroundColor3 = Theme.Card,
        AutoButtonColor = false,
        Text = "",
        BackgroundTransparency = 1,
        ZIndex = 11,
    })
    corner(14).Parent = btn
    stroke().Parent = btn
    btn:SetAttribute("Code", opt.code)

    create("TextLabel", {
        Text = opt.flag,
        Font = Enum.Font.GothamBold,
        TextSize = 32,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 40),
        Position = UDim2.new(0, 0, 0, 8),
        ZIndex = 12,
    }).Parent = btn

    create("TextLabel", {
        Text = opt.name,
        Font = Enum.Font.GothamMedium,
        TextSize = 14,
        TextColor3 = Theme.Text,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 20),
        Position = UDim2.new(0, 0, 0, 52),
        ZIndex = 12,
    }).Parent = btn

    btn.MouseEnter:Connect(function()
        if CurrentLang ~= opt.code then
            tween(btn, { BackgroundColor3 = Theme.AccentSoft }, 0.15)
        end
    end)
    btn.MouseLeave:Connect(function()
        if CurrentLang ~= opt.code then
            tween(btn, { BackgroundColor3 = Theme.Card }, 0.15)
        end
    end)
    btn.MouseButton1Click:Connect(function()
        selectLanguage(opt.code)
    end)

    btn.Parent = LangHolder
    table.insert(langButtons, btn)
end

task.defer(function()
    tween(LogoLabel, { TextTransparency = 0 }, 0.6)
    tween(ProTag, { TextTransparency = 0 }, 0.6)
    task.wait(0.15)
    tween(Underline, { Size = UDim2.new(0, 240, 0, 3) }, 0.6, Enum.EasingStyle.Quart)
    task.wait(0.2)
    tween(LoadingLabel, { TextTransparency = 0 }, 0.4)

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

    task.wait(5)
    dotsRunning = false

    tween(LoadingLabel, { TextTransparency = 1 }, 0.3)
    task.wait(0.3)
    LoadingLabel.Visible = false

    SubtitleLabel.Visible = true
    LangHolder.Visible = true
    tween(SubtitleLabel, { TextTransparency = 0 }, 0.5)
    for i, btn in ipairs(langButtons) do
        btn.BackgroundTransparency = 1
        task.delay(0.05 * i, function()
            tween(btn, { BackgroundTransparency = 0 }, 0.35)
        end)
    end
end)

------------------------------------------------------------
-- ANA MENÜ OLUŞTURMA
------------------------------------------------------------
local MENU_W, MENU_H = 480, 300
local SIDEBAR_W = 110

function buildMainMenu()
    MainFrame = create("Frame", {
        Name = "MainMenu",
        Size = UDim2.new(0, MENU_W, 0, MENU_H),
        Position = UDim2.new(0.5, 0, 0.5, 0),
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundColor3 = Theme.Background,
        ClipsDescendants = true,
        Visible = false,
        ZIndex = 5,
    })
    corner(16).Parent = MainFrame
    stroke(Theme.Accent, 1.5).Parent = MainFrame
    MainFrame.Parent = ScreenGui

    local BackgroundArt = create("ImageLabel", {
        Name = "BackgroundArt",
        Image = "rbxassetid://15732257423",
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        ImageTransparency = 0.15,
        ScaleType = Enum.ScaleType.Crop,
        ZIndex = 1,
    })
    corner(16).Parent = BackgroundArt
    BackgroundArt.Parent = MainFrame

    local BackgroundDim = create("Frame", {
        Name = "BackgroundDim",
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundColor3 = Theme.Background,
        BackgroundTransparency = 0.55,
        ZIndex = 2,
    })
    corner(16).Parent = BackgroundDim
    BackgroundDim.Parent = MainFrame

    local TopBar = create("Frame", {
        Size = UDim2.new(1, 0, 0, 42),
        BackgroundColor3 = Theme.Sidebar,
        BackgroundTransparency = CARD_TRANSPARENCY,
        ZIndex = 6,
    })
    corner(16).Parent = TopBar
    TopBar.Parent = MainFrame

    create("TextLabel", {
        Text = "UguzHub  •  V2 Pro",
        Font = Enum.Font.GothamBold,
        TextSize = 15,
        TextColor3 = Theme.Text,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, -20, 1, 0),
        Position = UDim2.new(0, 14, 0, 0),
        TextXAlignment = Enum.TextXAlignment.Left,
        ZIndex = 7,
    }).Parent = TopBar

    local MinimizeBtn = create("TextButton", {
        Text = "–",
        Font = Enum.Font.GothamBold,
        TextSize = 20,
        TextColor3 = Theme.SubText,
        BackgroundTransparency = 1,
        Size = UDim2.new(0, 32, 0, 32),
        Position = UDim2.new(1, -38, 0, 5),
        ZIndex = 7,
    })
    MinimizeBtn.Parent = TopBar
    MinimizeBtn.MouseButton1Click:Connect(function()
        closeMenu()
    end)

    local Sidebar = create("Frame", {
        Size = UDim2.new(0, SIDEBAR_W, 1, -42),
        Position = UDim2.new(0, 0, 0, 42),
        BackgroundColor3 = Theme.Sidebar,
        BackgroundTransparency = CARD_TRANSPARENCY,
        ZIndex = 6,
    })
    Sidebar.Parent = MainFrame

    create("UIListLayout", {
        Padding = UDim.new(0, 5),
        SortOrder = Enum.SortOrder.LayoutOrder,
    }).Parent = Sidebar

    create("UIPadding", {
        PaddingTop = UDim.new(0, 10),
        PaddingLeft = UDim.new(0, 8),
        PaddingRight = UDim.new(0, 8),
    }).Parent = Sidebar

    local Content = create("Frame", {
        Size = UDim2.new(1, -SIDEBAR_W, 1, -42),
        Position = UDim2.new(0, SIDEBAR_W, 0, 42),
        BackgroundTransparency = 1,
        ClipsDescendants = true,
        ZIndex = 6,
    })
    Content.Parent = MainFrame

    local pages = {}
    local tabButtons = {}

    local function switchTab(index)
        for i, page in ipairs(pages) do
            local active = (i == index)
            page.Visible = active
            if active then
                page.Position = UDim2.new(0, 10, 0, 6)
                tween(page, { Position = UDim2.new(0, 0, 0, 0) }, 0.25)
            end
        end
        for i, btn in ipairs(tabButtons) do
            tween(btn, {
                BackgroundColor3 = (i == index) and Theme.Accent or Theme.Sidebar,
                BackgroundTransparency = (i == index) and 0.05 or CARD_TRANSPARENCY,
            }, 0.2)
        end
    end

    local function newPage()
        local page = create("Frame", {
            Size = UDim2.new(1, -20, 1, -14),
            Position = UDim2.new(0, 10, 0, 6),
            BackgroundTransparency = 1,
            Visible = false,
        })
        page.Parent = Content
        table.insert(pages, page)
        return page
    end

    local function createToggle(parent, labelText, flag)
        local frame = create("Frame", { 
            Size = UDim2.new(1, -6, 0, 30), 
            BackgroundColor3 = Theme.Card, 
            BackgroundTransparency = CARD_TRANSPARENCY 
        })
        corner(8).Parent = frame
        frame.Parent = parent

        create("TextLabel", { 
            Text = labelText, 
            Font = Enum.Font.Gotham, 
            TextColor3 = Theme.Text, 
            TextSize = 10, 
            BackgroundTransparency = 1, 
            Size = UDim2.new(0.7, 0, 1, 0), 
            Position = UDim2.new(0, 8, 0, 0), 
            TextXAlignment = Enum.TextXAlignment.Left 
        }).Parent = frame

        local switch = create("Frame", { 
            Size = UDim2.new(0, 28, 0, 14), 
            Position = UDim2.new(1, -34, 0.5, -7), 
            BackgroundColor3 = Color3.fromRGB(40, 40, 45) 
        })
        corner(10).Parent = switch
        switch.Parent = frame

        local dot = create("Frame", { 
            Size = UDim2.new(0, 10, 0, 10), 
            Position = UDim2.new(0, 2, 0.5, -5), 
            BackgroundColor3 = Color3.fromRGB(200, 200, 200) 
        })
        corner(10).Parent = dot
        dot.Parent = switch

        local btn = create("TextButton", { 
            Size = UDim2.new(1, 0, 1, 0), 
            BackgroundTransparency = 1, 
            Text = "" 
        })
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
        local btn = create("TextButton", { 
            Size = UDim2.new(1, -6, 0, 30), 
            BackgroundColor3 = Theme.Card, 
            Font = Enum.Font.GothamBold, 
            Text = labelText, 
            TextColor3 = Theme.Text, 
            TextSize = 10 
        })
        corner(8).Parent = btn
        stroke(Theme.Accent, 1).Parent = btn
        btn.Parent = parent
        btn.MouseButton1Click:Connect(function() 
            if callback then callback() end 
        end)
    end

    -------- ESP TAB --------
    local ESPPage = newPage()
    create("TextLabel", {
        Text = "👁️ ESP Seçenekleri",
        Font = Enum.Font.GothamBold,
        TextSize = 14,
        TextColor3 = Theme.Text,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 20),
        TextXAlignment = Enum.TextXAlignment.Left,
    }).Parent = ESPPage
    
    createToggle(ESPPage, "ESP All (Herkesi Göster)", "ESPAll")
    createToggle(ESPPage, "ESP Gun (Yerdeki Silah)", "ESPGun")
    createToggle(ESPPage, "Auto Grab Gun", "AutoGrabGun")
    createButton(ESPPage, "TP Grab Gun (Işınlan Al)", function()
        local gunDrop = Workspace:FindFirstChild("GunDrop") or Workspace:FindFirstChild("Gun")
        local myHrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if gunDrop and myHrp then
            local oldCFrame = myHrp.CFrame
            myHrp.CFrame = gunDrop.CFrame
            task.wait(0.15)
            if firetouchinterest then
                firetouchinterest(myHrp, gunDrop, 0)
                firetouchinterest(myHrp, gunDrop, 1)
            end
            task.wait(0.1)
            myHrp.CFrame = oldCFrame
        end
    end)

    -------- AIMBOT TAB --------
    local AimbotPage = newPage()
    create("TextLabel", {
        Text = "🎯 Aimbot Seçenekleri",
        Font = Enum.Font.GothamBold,
        TextSize = 14,
        TextColor3 = Theme.Text,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 20),
        TextXAlignment = Enum.TextXAlignment.Left,
    }).Parent = AimbotPage
    
    createToggle(AimbotPage, "Aimbot Enable (Kilitle)", "AimbotEnabled")

    -------- PLAYERS TAB --------
    local PlayersPage = newPage()
    create("TextLabel", {
        Text = "👤 Oyuncu Seçenekleri",
        Font = Enum.Font.GothamBold,
        TextSize = 14,
        TextColor3 = Theme.Text,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 20),
        TextXAlignment = Enum.TextXAlignment.Left,
    }).Parent = PlayersPage
    
    createToggle(PlayersPage, "Auto Kill Murderer (Sheriff)", "AutoKillMurderer")
    createButton(PlayersPage, "Kill Murderer", function()
        local myChar = LocalPlayer.Character
        if myChar and myChar:FindFirstChild("HumanoidRootPart") then
            for _, p in pairs(Players:GetPlayers()) do
                if p ~= LocalPlayer and getRole(p) == "Murderer" and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                    myChar.HumanoidRootPart.CFrame = p.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, 3)
                end
            end
        end
    end)
    createButton(PlayersPage, "Kill All (Murderer Only)", function()
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
    createToggle(PlayersPage, "Auto Fling Murderer", "AutoFlingMurderer")
    createToggle(PlayersPage, "Auto Fling Sheriff", "AutoFlingSheriff")
    createToggle(PlayersPage, "Auto Fling All", "AutoFlingAll")

    -------- TELEPORT TAB --------
    local TeleportPage = newPage()
    create("TextLabel", {
        Text = "🌀 Teleport Seçenekleri",
        Font = Enum.Font.GothamBold,
        TextSize = 14,
        TextColor3 = Theme.Text,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 20),
        TextXAlignment = Enum.TextXAlignment.Left,
    }).Parent = TeleportPage
    
    createButton(TeleportPage, "TP to Lobby", function()
        local myHrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if not myHrp then return end
        local lobby = Workspace:FindFirstChild("Lobby")
        if lobby then
            local spawnPart = lobby:FindFirstChild("Spawns") or lobby:FindFirstChild("Spawn") or lobby:FindFirstChildWhichIsA("BasePart", true)
            if spawnPart then myHrp.CFrame = spawnPart.CFrame + Vector3.new(0, 3, 0) else myHrp.CFrame = CFrame.new(-108, 140, 82) end
        else myHrp.CFrame = CFrame.new(-108, 140, 82) end
    end)
    createButton(TeleportPage, "TP to Map", function()
        local myHrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if not myHrp then return end
        local found = false
        for _, child in pairs(Workspace:GetChildren()) do
            if child:FindFirstChild("Spawns") or child:FindFirstChild("CoinContainer") then
                local spawns = child:FindFirstChild("Spawns")
                local spawnPart = spawns and spawns:FindFirstChildWhichIsA("BasePart") or child:FindFirstChildWhichIsA("BasePart", true)
                if spawnPart then myHrp.CFrame = spawnPart.CFrame + Vector3.new(0, 3, 0); found = true; break end
            end
        end
        if not found then
            for _, p in pairs(Players:GetPlayers()) do
                if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                    if getRole(p) == "Murderer" or getRole(p) == "Sheriff" then myHrp.CFrame = p.Character.HumanoidRootPart.CFrame + Vector3.new(0, 2, 0); break end
                end
            end
        end
    end)
    createButton(TeleportPage, "TP to Murderer", function()
        local myHrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if not myHrp then return end
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and getRole(p) == "Murderer" and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then myHrp.CFrame = p.Character.HumanoidRootPart.CFrame + Vector3.new(0, 2, 0); break end
        end
    end)
    createButton(TeleportPage, "TP to Sheriff", function()
        local myHrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if not myHrp then return end
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and getRole(p) == "Sheriff" and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then myHrp.CFrame = p.Character.HumanoidRootPart.CFrame + Vector3.new(0, 2, 0); break end
        end
    end)

    -------- SETTINGS TAB --------
    local SettingsPage = newPage()
    create("TextLabel", {
        Text = L.sectionTitle,
        Font = Enum.Font.GothamBold,
        TextSize = 13,
        TextColor3 = Theme.SubText,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 18),
        TextXAlignment = Enum.TextXAlignment.Left,
    }).Parent = SettingsPage

    local AvatarFrame = create("Frame", {
        Size = UDim2.new(0, 50, 0, 50),
        Position = UDim2.new(0, 0, 0, 26),
        BackgroundColor3 = Theme.Card,
        BackgroundTransparency = CARD_TRANSPARENCY,
    })
    corner(25).Parent = AvatarFrame
    stroke(Theme.Accent, 2).Parent = AvatarFrame
    AvatarFrame.Parent = SettingsPage

    local AvatarImage = create("ImageLabel", {
        Size = UDim2.new(1, -4, 1, -4),
        Position = UDim2.new(0, 2, 0, 2),
        BackgroundTransparency = 1,
        Image = "rbxthumb://type=AvatarHeadShot&id=" .. LocalPlayer.UserId .. "&w=150&h=150",
    })
    corner(25).Parent = AvatarImage
    AvatarImage.Parent = AvatarFrame

    create("TextLabel", {
        Text = LocalPlayer.DisplayName .. " (@" .. LocalPlayer.Name .. ")",
        Font = Enum.Font.GothamBold,
        TextSize = 12,
        TextColor3 = Theme.Text,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, -60, 0, 18),
        Position = UDim2.new(0, 60, 0, 28),
        TextXAlignment = Enum.TextXAlignment.Left,
    }).Parent = SettingsPage

    create("TextLabel", {
        Text = L.greeting .. ", " .. LocalPlayer.DisplayName .. "?",
        Font = Enum.Font.Gotham,
        TextSize = 11,
        TextColor3 = Theme.SubText,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, -60, 0, 16),
        Position = UDim2.new(0, 60, 0, 46),
        TextXAlignment = Enum.TextXAlignment.Left,
    }).Parent = SettingsPage

    -------- TAB BUTTONS --------
    local TabNames = { "👁️ ESP", "🎯 Aimbot", "👤 Players", "🌀 Teleport", "⚙️ Ayarlar" }
    for i, tabName in ipairs(TabNames) do
        local tabBtn = create("TextButton", {
            Text = tabName,
            Font = Enum.Font.GothamMedium,
            TextSize = 11,
            TextColor3 = Theme.Text,
            BackgroundColor3 = Theme.Sidebar,
            BackgroundTransparency = CARD_TRANSPARENCY,
            Size = UDim2.new(1, 0, 0, 32),
            LayoutOrder = i,
            AutoButtonColor = false,
        })
        corner(8).Parent = tabBtn
        tabBtn.Parent = Sidebar
        table.insert(tabButtons, tabBtn)

        tabBtn.MouseButton1Click:Connect(function()
            switchTab(i)
        end)
    end

    switchTab(1)
end

------------------------------------------------------------
-- MENÜ AÇ / KAPA
------------------------------------------------------------
function openMenu()
    MinimizedButton.Visible = false
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

MinimizedButton.MouseButton1Click:Connect(function()
    if not MainFrame then return end
    openMenu()
end)

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
            if p.Character and p.Character:FindFirstChild("UguzHighlight") then
                p.Character.UguzHighlight:Destroy()
            end
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

    if Flags.AimbotEnabled or (Flags.AutoKillMurderer and getRole(LocalPlayer) == "Sheriff") then
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and getRole(p) == "Murderer" and p.Character and p.Character:FindFirstChild("Head") then
                Camera.CFrame = CFrame.new(Camera.CFrame.Position, p.Character.Head.Position)
            end
        end
    end
end)
