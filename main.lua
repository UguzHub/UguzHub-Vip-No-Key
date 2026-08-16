-- [[ UguzHub V2 Pro - MM2 Full Feature Integration ]] --

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")

local LocalPlayer = Players.LocalPlayer

------------------------------------------------------------
-- 0) 14 GÜNLÜK HESAP YAŞ KONTROLÜ (KICK)
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
-- DİL PAKETLERİ
------------------------------------------------------------
local Lang = {}

Lang.EN = { loading = "Loading", subtitle = "Select your language", greeting = "How are you today", sectionTitle = "Settings", openBtn = "UguzHub" }
Lang.TR = { loading = "Yükleniyor", subtitle = "Dilinizi seçin", greeting = "Bugün nasılsın", sectionTitle = "Ayarlar", openBtn = "UguzHub" }
Lang.RU = { loading = "Загрузка", subtitle = "Выберите язык", greeting = "Как дела сегодня", sectionTitle = "Настройки", openBtn = "UguzHub" }
Lang.DE = { loading = "Wird geladen", subtitle = "Wähle deine Sprache", greeting = "Wie geht es dir heute", sectionTitle = "Einstellungen", openBtn = "UguzHub" }
Lang.FR = { loading = "Chargement", subtitle = "Choisissez votre langue", greeting = "Comment vas-tu aujourd'hui", sectionTitle = "Paramètres", openBtn = "UguzHub" }
Lang.ES = { loading = "Cargando", subtitle = "Selecciona tu idioma", greeting = "¿Cómo estás hoy", sectionTitle = "Ajustes", openBtn = "UguzHub" }
Lang.AR = { loading = "جار التحميل", subtitle = "اختر لغتك", greeting = "كيف حالك اليوم", sectionTitle = "الإعدادات", openBtn = "UguzHub" }
Lang.ZH = { loading = "加载中", subtitle = "选择你的语言", greeting = "你今天好吗", sectionTitle = "设置", openBtn = "UguzHub" }

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
    IgnoreGuiInset = true,
})
ScreenGui.Parent = PlayerGui

------------------------------------------------------------
-- GİRİŞ EKRANI
------------------------------------------------------------
local IntroFrame = create("Frame", {
    Name = "Intro",
    Size = UDim2.fromScale(1, 1),
    Position = UDim2.fromScale(0, 0),
    BorderSizePixel = 0,
    BackgroundColor3 = Theme.Background,
    BackgroundTransparency = 0,
    ZIndex = 10,
})
IntroFrame.Parent = ScreenGui

local IntroContent = create("Frame", {
    Name = "IntroContent",
    AnchorPoint = Vector2.new(0.5, 0),
    Position = UDim2.new(0.5, 0, 0.24, 0),
    Size = UDim2.new(0, 360, 0, 370),
    BackgroundTransparency = 1,
    ZIndex = 11,
})
IntroContent.Parent = IntroFrame

local LogoLabel = create("TextLabel", {
    Text = "UguzHub",
    Font = Enum.Font.GothamBlack,
    TextSize = 50,
    TextColor3 = Theme.Text,
    BackgroundTransparency = 1,
    Size = UDim2.new(1, 0, 0, 60),
    Position = UDim2.new(0, 0, 0, 0),
    TextTransparency = 1,
    ZIndex = 11,
})
LogoLabel.Parent = IntroContent

local ProTag = create("TextLabel", {
    Text = "V2 PRO",
    Font = Enum.Font.GothamBold,
    TextSize = 18,
    TextColor3 = Theme.Accent,
    BackgroundTransparency = 1,
    Size = UDim2.new(1, 0, 0, 22),
    Position = UDim2.new(0, 0, 0, 58),
    TextTransparency = 1,
    ZIndex = 11,
})
ProTag.Parent = IntroContent

local Underline = create("Frame", {
    Name = "Underline",
    Size = UDim2.new(0, 0, 0, 3),
    Position = UDim2.new(0.5, 0, 0, 88),
    AnchorPoint = Vector2.new(0.5, 0),
    BackgroundColor3 = Theme.Accent,
    BorderSizePixel = 0,
    ZIndex = 11,
})
corner(2).Parent = Underline
Underline.Parent = IntroContent

local LoadingLabel = create("TextLabel", {
    Text = L.loading,
    Font = Enum.Font.GothamMedium,
    TextSize = 17,
    TextColor3 = Theme.SubText,
    BackgroundTransparency = 1,
    Size = UDim2.new(1, 0, 0, 24),
    Position = UDim2.new(0, 0, 0, 108),
    TextTransparency = 1,
    ZIndex = 11,
})
LoadingLabel.Parent = IntroContent

local SubtitleLabel = create("TextLabel", {
    Text = L.subtitle,
    Font = Enum.Font.Gotham,
    TextSize = 15,
    TextColor3 = Theme.SubText,
    BackgroundTransparency = 1,
    Size = UDim2.new(1, 0, 0, 22),
    Position = UDim2.new(0, 0, 0, 108),
    TextTransparency = 1,
    ZIndex = 11,
    Visible = false,
})
SubtitleLabel.Parent = IntroContent

local LangHolder = create("Frame", {
    Name = "LangHolder",
    Position = UDim2.new(0, 0, 0, 150),
    Size = UDim2.new(1, 0, 0, 200),
    BackgroundTransparency = 1,
    ZIndex = 11,
    Visible = false,
})
LangHolder.Parent = IntroContent

create("UIGridLayout", {
    CellSize = UDim2.new(0, 84, 0, 92),
    CellPadding = UDim2.new(0, 6, 0, 6),
    HorizontalAlignment = Enum.HorizontalAlignment.Center,
    SortOrder = Enum.SortOrder.LayoutOrder,
}).Parent = LangHolder

------------------------------------------------------------
-- MİNİMİZE BUTON
------------------------------------------------------------
local MinimizedButton = create("TextButton", {
    Name = "MinimizedButton",
    Text = "🔵 " .. L.openBtn,
    Font = Enum.Font.GothamBold,
    TextSize = 15,
    TextColor3 = Theme.Text,
    BackgroundColor3 = Theme.Blue,
    Size = UDim2.new(0, 118, 0, 38),
    Position = UDim2.new(1, -134, 0, 16),
    AutoButtonColor = false,
    Visible = false,
    ZIndex = 8,
})
corner(12).Parent = MinimizedButton
stroke(Color3.fromRGB(255, 255, 255), 1).Parent = MinimizedButton
MinimizedButton.Parent = ScreenGui

MinimizedButton.MouseEnter:Connect(function() tween(MinimizedButton, { BackgroundColor3 = Theme.BlueSoft }, 0.15) end)
MinimizedButton.MouseLeave:Connect(function() tween(MinimizedButton, { BackgroundColor3 = Theme.Blue }, 0.15) end)

------------------------------------------------------------
-- DİL KARTLARI DÖNGÜSÜ
------------------------------------------------------------
local MainFrame, buildMainMenu, openMenu, closeMenu
local langCards = {}

local function selectLanguage(code)
    CurrentLang = code
    L = Lang[CurrentLang]

    for _, card in ipairs(langCards) do
        local isSelected = card:GetAttribute("Code") == code
        tween(card, { BackgroundColor3 = isSelected and Theme.Accent or Theme.Card }, 0.2)
    end

    task.delay(0.25, function()
        tween(IntroFrame, { BackgroundTransparency = 1 }, 0.4)
        for _, obj in ipairs({ LogoLabel, ProTag, SubtitleLabel }) do tween(obj, { TextTransparency = 1 }, 0.3) end
        for _, card in ipairs(langCards) do tween(card, { BackgroundTransparency = 1 }, 0.25) end
        task.wait(0.4)
        IntroFrame.Visible = false

        if not MainFrame then buildMainMenu() end

        MinimizedButton.Text = "🔵 " .. L.openBtn
        MinimizedButton.Visible = true
        MinimizedButton.BackgroundTransparency = 1
        tween(MinimizedButton, { BackgroundTransparency = 0 }, 0.3)
    end)
end

for i, opt in ipairs(LanguageOptions) do
    local card = create("TextButton", {
        Name = opt.code,
        Text = "",
        AutoButtonColor = false,
        BackgroundColor3 = Theme.Card,
        BackgroundTransparency = 1,
        LayoutOrder = i,
        ZIndex = 11,
    })
    corner(14).Parent = card
    stroke().Parent = card
    card:SetAttribute("Code", opt.code)

    create("TextLabel", { Text = opt.flag, Font = Enum.Font.GothamBold, TextSize = 26, BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 34), Position = UDim2.new(0, 0, 0, 10), ZIndex = 12 }).Parent = card
    create("TextLabel", { Text = opt.name, Font = Enum.Font.GothamMedium, TextSize = 12, TextColor3 = Theme.Text, BackgroundTransparency = 1, Size = UDim2.new(1, -6, 0, 18), Position = UDim2.new(0, 3, 0, 48), TextXAlignment = Enum.TextXAlignment.Center, ZIndex = 12 }).Parent = card

    card.MouseEnter:Connect(function() if CurrentLang ~= opt.code then tween(card, { BackgroundColor3 = Theme.AccentSoft }, 0.15) end end)
    card.MouseLeave:Connect(function() if CurrentLang ~= opt.code then tween(card, { BackgroundColor3 = Theme.Card }, 0.15) end end)
    card.MouseButton1Click:Connect(function() selectLanguage(opt.code) end)

    card.Parent = LangHolder
    table.insert(langCards, card)
end

task.defer(function()
    tween(LogoLabel, { TextTransparency = 0 }, 0.6)
    tween(ProTag, { TextTransparency = 0 }, 0.6)
    task.wait(0.15)
    tween(Underline, { Size = UDim2.new(0, 220, 0, 3) }, 0.6, Enum.EasingStyle.Quart)
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
    tween(SubtitleLabel, { TextTransparency = 0 }, 0.4)
    for i, card in ipairs(langCards) do
        card.BackgroundTransparency = 1
        task.delay(0.03 * i, function() tween(card, { BackgroundTransparency = 0 }, 0.3) end)
    end
end)

------------------------------------------------------------
-- ANA MENÜ (Özelliklerle Genişletilmiş ve Sekmeli)
------------------------------------------------------------
local MENU_W, MENU_H = 480, 280

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
    corner(RADIUS).Parent = MainFrame
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
    corner(RADIUS).Parent = BackgroundArt
    BackgroundArt.Parent = MainFrame

    local BackgroundDim = create("Frame", {
        Name = "BackgroundDim",
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundColor3 = Theme.Background,
        BackgroundTransparency = 0.5,
        ZIndex = 2,
    })
    corner(RADIUS).Parent = BackgroundDim
    BackgroundDim.Parent = MainFrame

    local TopBar = create("Frame", {
        Size = UDim2.new(1, 0, 0, 36),
        BackgroundColor3 = Theme.Sidebar,
        BackgroundTransparency = CARD_TRANSPARENCY,
        ZIndex = 6,
        Active = true,
    })
    corner(RADIUS).Parent = TopBar
    TopBar.Parent = MainFrame

    create("TextLabel", {
        Text = "UguzHub  •  V2 Pro",
        Font = Enum.Font.GothamBold,
        TextSize = 13,
        TextColor3 = Theme.Text,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, -56, 1, 0),
        Position = UDim2.new(0, 12, 0, 0),
        TextXAlignment = Enum.TextXAlignment.Left,
        ZIndex = 7,
    }).Parent = TopBar

    local MinimizeBtn = create("TextButton", {
        Text = "–",
        Font = Enum.Font.GothamBold,
        TextSize = 18,
        TextColor3 = Theme.SubText,
        BackgroundTransparency = 1,
        Size = UDim2.new(0, 32, 0, 32),
        Position = UDim2.new(1, -34, 0, 2),
        ZIndex = 7,
    })
    MinimizeBtn.Parent = TopBar
    MinimizeBtn.MouseButton1Click:Connect(function() closeMenu() end)

    -- Sürükleme Mantığı
    do
        local dragging, dragInput, dragStart, startPos
        TopBar.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                dragging = true
                dragStart = input.Position
                startPos = MainFrame.Position
                input.Changed:Connect(function()
                    if input.UserInputState == Enum.UserInputState.End then dragging = false end
                end)
            end
        end)
        TopBar.InputChanged:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then dragInput = input end
        end)
        UserInputService.InputChanged:Connect(function(input)
            if input == dragInput and dragging then
                local delta = input.Position - dragStart
                MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
            end
        end)
    end

    ------------------------------------------------------------
    -- SIDEBAR (SOL SEKME MENÜSÜ)
    ------------------------------------------------------------
    local Sidebar = create("Frame", {
        Size = UDim2.new(0, 110, 1, -42),
        Position = UDim2.new(0, 6, 0, 40),
        BackgroundColor3 = Theme.Sidebar,
        BackgroundTransparency = CARD_TRANSPARENCY,
        ZIndex = 6,
    })
    corner(10).Parent = Sidebar
    Sidebar.Parent = MainFrame

    local TabContainer = create("Frame", {
        Size = UDim2.new(1, -128, 1, -42),
        Position = UDim2.new(0, 122, 0, 40),
        BackgroundTransparency = 1,
        ZIndex = 6,
    })
    TabContainer.Parent = MainFrame

    local TabList = create("UIListLayout", { SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 4) })
    TabList.Parent = Sidebar

    local pages = {}
    local tabBtns = {}

    local function addTab(name, icon)
        local btn = create("TextButton", {
            Size = UDim2.new(1, 0, 0, 30),
            BackgroundColor3 = Theme.Card,
            BackgroundTransparency = 0.5,
            Font = Enum.Font.GothamMedium,
            Text = icon .. " " .. name,
            TextColor3 = Theme.SubText,
            TextSize = 11,
            TextXAlignment = Enum.TextXAlignment.Left,
            ZIndex = 7,
        })
        corner(8).Parent = btn
        btn.Parent = Sidebar

        local page = create("ScrollingFrame", {
            Size = UDim2.new(1, 0, 1, 0),
            BackgroundTran
