--[[
    UguzHub V2 Pro
    ------------------------------------------------------------
    Akış (4 Adım):
      1) 0-5sn: Tam ekran yükleme animasyonu (logo + "Loading")
      2) Dil seçimi: 8 dil, bayraklı, 4'er 4'er (TR/EN/RU/ES/AR/DE/FR/PH)
      3) Dil seçilince 7'den geriye sayan Delta uyarı mesajı ekranda görünür
      4) Sayaç bittiğinde uyarı kapanır ve ana menü açılır (Sağ üstten tekrar açılabilir)
]]

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

------------------------------------------------------------
-- TEMA
------------------------------------------------------------
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
}

local RADIUS = 16
local CARD_TRANSPARENCY = 0.25

------------------------------------------------------------
-- DİL PAKETLERİ (8 dil, tam çevirili)
------------------------------------------------------------
local Lang = {}

Lang.TR = {
    loading = "Yükleniyor",
    subtitle = "Dilinizi seçin",
    openBtn = "UguzHub",
    notice = "Deneyimini Daha İyi Hale Getirmek İçin Deltanin Ayarlarindaki Tum Herseyi Kapattığınızda Emin Olun",
}

Lang.EN = {
    loading = "Loading",
    subtitle = "Select your language",
    openBtn = "UguzHub",
    notice = "To Make Your Experience Better, Make Sure To Turn Off Everything In Delta's Settings.",
}

Lang.RU = {
    loading = "Загрузка",
    subtitle = "Выберите язык",
    openBtn = "UguzHub",
    notice = "Чтобы улучшить ваш опыт, убедитесь, что вы отключили всё в настройках Delta.",
}

Lang.ES = {
    loading = "Cargando",
    subtitle = "Selecciona tu idioma",
    openBtn = "UguzHub",
    notice = "Para mejorar tu experiencia, asegúrate de apagar todo en la configuración de Delta.",
}

Lang.AR = {
    loading = "جار التحميل",
    subtitle = "اختر لغتك",
    openBtn = "UguzHub",
    notice = "لجعل تجربتك أفضل، تأكد من إيقاف تشغيل كل شيء في إعدادات Delta.",
}

Lang.DE = {
    loading = "Wird geladen",
    subtitle = "Wähle deine Sprache",
    openBtn = "UguzHub",
    notice = "Um dein Erlebnis zu verbessern, stelle sicher, dass du alles in den Delta-Einstellungen ausschaltest.",
}

Lang.FR = {
    loading = "Chargement",
    subtitle = "Choisissez votre langue",
    openBtn = "UguzHub",
    notice = "Pour améliorer votre expérience, assurez-vous de tout désactiver dans les paramètres de Delta.",
}

Lang.PH = {
    loading = "Naglo-load",
    subtitle = "Piliin ang iyong wika",
    openBtn = "UguzHub",
    notice = "Para mas maging maganda ang iyong karanasan, siguraduhing i-off ang lahat sa mga setting ng Delta.",
}

------------------------------------------------------------
-- 8 DİL SEÇENEĞİ (4'er 4'er, bayraklı)
------------------------------------------------------------
local LanguageOptions = {
    { code = "TR", flag = "🇹🇷", name = "Türkçe" },
    { code = "EN", flag = "🇬🇧", name = "English" },
    { code = "RU", flag = "🇷🇺", name = "Русский" },
    { code = "ES", flag = "🇪🇸", name = "Español" },
    { code = "AR", flag = "🇸🇦", name = "العربية" },
    { code = "DE", flag = "🇩🇪", name = "Deutsch" },
    { code = "FR", flag = "🇫🇷", name = "Français" },
    { code = "PH", flag = "🇵🇭", name = "Filipino" },
}

local CurrentLang = "EN"
local L = Lang[CurrentLang]

------------------------------------------------------------
-- YARDIMCI FONKSİYONLAR
------------------------------------------------------------
local function create(class, props, children)
    local inst = Instance.new(class)
    for prop, value in pairs(props or {}) do
        inst[prop] = value
    end
    for _, child in ipairs(children or {}) do
        child.Parent = inst
    end
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
    local info = TweenInfo.new(
        duration or 0.3,
        style or Enum.EasingStyle.Quint,
        direction or Enum.EasingDirection.Out
    )
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
-- 1. & 2. ADIM: GİRİŞ EKRANI (Yükleme + Dil Seçimi)
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
-- 3. ADIM: 7 SANİYELİK GERİ SAYIMLI DELTA UYARI EKRANI
------------------------------------------------------------
local NoticeFrame = create("Frame", {
    Name = "Notice",
    Size = UDim2.fromScale(1, 1),
    Position = UDim2.fromScale(0, 0),
    BackgroundColor3 = Theme.Background,
    BackgroundTransparency = 1,
    Visible = false,
    ZIndex = 15,
})
NoticeFrame.Parent = ScreenGui

local NoticeContainer = create("Frame", {
    Name = "NoticeContainer",
    Size = UDim2.new(0, 440, 0, 180),
    AnchorPoint = Vector2.new(0.5, 0.5),
    Position = UDim2.new(0.5, 0, 0.5, 0),
    BackgroundTransparency = 1,
    ZIndex = 16,
})
NoticeContainer.Parent = NoticeFrame

local NoticeLabel = create("TextLabel", {
    Text = "",
    Font = Enum.Font.GothamMedium,
    TextSize = 18,
    TextColor3 = Theme.Text,
    BackgroundTransparency = 1,
    Size = UDim2.new(1, 0, 0, 110),
    Position = UDim2.new(0, 0, 0, 0),
    TextWrapped = true,
    TextXAlignment = Enum.TextXAlignment.Center,
    TextTransparency = 1,
    ZIndex = 16,
})
NoticeLabel.Parent = NoticeContainer

local CountdownLabel = create("TextLabel", {
    Text = "7",
    Font = Enum.Font.GothamBold,
    TextSize = 24,
    TextColor3 = Theme.Accent,
    BackgroundTransparency = 1,
    Size = UDim2.new(1, 0, 0, 40),
    Position = UDim2.new(0, 0, 0, 120),
    TextXAlignment = Enum.TextXAlignment.Center,
    TextTransparency = 1,
    ZIndex = 16,
})
CountdownLabel.Parent = NoticeContainer

------------------------------------------------------------
-- MİNİMİZE (KAPALI) BUTON
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

MinimizedButton.MouseEnter:Connect(function()
    tween(MinimizedButton, { BackgroundColor3 = Theme.BlueSoft }, 0.15)
end)
MinimizedButton.MouseLeave:Connect(function()
    tween(MinimizedButton, { BackgroundColor3 = Theme.Blue }, 0.15)
end)

------------------------------------------------------------
-- ANA MENÜ DEĞİŞKENLERİ VE AKIŞ FONKSİYONLARI
------------------------------------------------------------
local MainFrame
local buildMainMenu
local openMenu
local closeMenu
local langCards = {}

local function showNoticeThenMenu()
    NoticeLabel.Text = L.notice
    NoticeFrame.Visible = true
    tween(NoticeFrame, { BackgroundTransparency = 0.05 }, 0.4)
    tween(NoticeLabel, { TextTransparency = 0 }, 0.5)
    tween(CountdownLabel, { TextTransparency = 0 }, 0.5)

    -- 7'den geriye sayım döngüsü
    task.spawn(function()
        for i = 7, 1, -1 do
            CountdownLabel.Text = tostring(i)
            task.wait(1)
        end
        CountdownLabel.Text = "0"
    end)

    -- 7 saniye sonra uyarıyı kapat ve 4. Adım (Ana Menü) geç
    task.delay(7, function()
        tween(NoticeFrame, { BackgroundTransparency = 1 }, 0.5)
        tween(NoticeLabel, { TextTransparency = 1 }, 0.4)
        tween(CountdownLabel, { TextTransparency = 1 }, 0.4)
        task.wait(0.5)
        NoticeFrame.Visible = false

        if not MainFrame then
            buildMainMenu()
        end
        openMenu() -- 4. Adım: Ana Menü Açılıyor
    end)
end

local function selectLanguage(code)
    CurrentLang = code
    L = Lang[CurrentLang]

    for _, card in ipairs(langCards) do
        local isSelected = card:GetAttribute("Code") == code
        tween(card, { BackgroundColor3 = isSelected and Theme.Accent or Theme.Card }, 0.2)
    end

    task.delay(0.25, function()
        tween(IntroFrame, { BackgroundTransparency = 1 }, 0.4)
        for _, obj in ipairs({ LogoLabel, ProTag, SubtitleLabel }) do
            tween(obj, { TextTransparency = 1 }, 0.3)
        end
        for _, card in ipairs(langCards) do
            tween(card, { BackgroundTransparency = 1 }, 0.25)
        end
        task.wait(0.4)
        IntroFrame.Visible = false

        MinimizedButton.Text = "🔵 " .. L.openBtn
        showNoticeThenMenu()
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

    create("TextLabel", {
        Text = opt.flag,
        Font = Enum.Font.GothamBold,
        TextSize = 26,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 34),
        Position = UDim2.new(0, 0, 0, 10),
        ZIndex = 12,
    }).Parent = card

    create("TextLabel", {
        Text = opt.name,
        Font = Enum.Font.GothamMedium,
        TextSize = 12,
        TextColor3 = Theme.Text,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, -6, 0, 18),
        Position = UDim2.new(0, 3, 0, 48),
        TextXAlignment = Enum.TextXAlignment.Center,
        ZIndex = 12,
    }).Parent = card

    card.MouseEnter:Connect(function()
        if CurrentLang ~= opt.code then
            tween(card, { BackgroundColor3 = Theme.AccentSoft }, 0.15)
        end
    end)
    card.MouseLeave:Connect(function()
        if CurrentLang ~= opt.code then
            tween(card, { BackgroundColor3 = Theme.Card }, 0.15)
        end
    end)
    card.MouseButton1Click:Connect(function()
        selectLanguage(opt.code)
    end)

    card.Parent = LangHolder
    table.insert(langCards, card)
end

------------------------------------------------------------
-- 1. ADIM BAŞLANGICI (0-5 sn Yükleme)
------------------------------------------------------------
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

    -- 2. Adım: Dil Seçimi Ekranını Göster
    SubtitleLabel.Visible = true
    LangHolder.Visible = true
    tween(SubtitleLabel, { TextTransparency = 0 }, 0.4)
    for i, card in ipairs(langCards) do
        card.BackgroundTransparency = 1
        task.delay(0.03 * i, function()
            tween(card, { BackgroundTransparency = 0 }, 0.3)
        end)
    end
end)

------------------------------------------------------------
-- 4. ADIM: ANA MENÜ İNŞASI
------------------------------------------------------------
local MENU_W, MENU_H = 320, 200

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
        ImageTransparency = 0.2,
        ScaleType = Enum.ScaleType.Crop,
        ZIndex = 1,
    })
    corner(RADIUS).Parent = BackgroundArt
    BackgroundArt.Parent = MainFrame

    local BackgroundDim = create("Frame", {
        Name = "BackgroundDim",
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundColor3 = Theme.Background,
        BackgroundTransparency = 0.55,
        ZIndex = 2,
    })
    corner(RADIUS).Parent = BackgroundDim
    BackgroundDim.Parent = MainFrame

    local TopBar = create("Frame", {
        Size = UDim2.new(1, 0, 0, 40),
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
        TextSize = 14,
        TextColor3 = Theme.Text,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, -56, 1, 0),
        Position = UDim2.new(0, 14, 0, 0),
        TextXAlignment = Enum.TextXAlignment.Left,
        TextTruncate = Enum.TextTruncate.AtEnd,
        ZIndex = 7,
    }).Parent = TopBar

    local MinimizeBtn = create("TextButton", {
        Text = "–",
        Font = Enum.Font.GothamBold,
        TextSize = 20,
        TextColor3 = Theme.SubText,
        BackgroundTransparency = 1,
        Size = UDim2.new(0, 32, 0, 32),
        Position = UDim2.new(1, -36, 0, 4),
        ZIndex = 7,
    })
    MinimizeBtn.Parent = TopBar
    MinimizeBtn.MouseButton1Click:Connect(function()
        closeMenu()
    end)

    -- Sürükleme Mantığı
    do
        local dragging = false
        local dragInput, dragStart, startPos

        TopBar.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1
                or input.UserInputType == Enum.UserInputType.Touch then
                dragging = true
                dragStart = input.Position
                startPos = MainFrame.Position

                input.Changed:Connect(function()
                    if input.UserInputState == Enum.UserInputState.End then
                        dragging = false
                    end
                end)
            end
        end)

        TopBar.InputChanged:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseMovement
                or input.UserInputType == Enum.UserInputType.Touch then
                dragInput = input
            end
        end)

        UserInputService.InputChanged:Connect(function(input)
            if input == dragInput and dragging then
                local delta = input.Position - dragStart
                MainFrame.Position = UDim2.new(
                    startPos.X.Scale, startPos.X.Offset + delta.X,
                    startPos.Y.Scale, startPos.Y.Offset + delta.Y
                )
            end
        end)
    end

    create("Frame", {
        Name = "Content",
        Size = UDim2.new(1, -24, 1, -52),
        Position = UDim2.new(0, 12, 0, 46),
        BackgroundTransparency = 1,
        ZIndex = 6,
    }).Parent = MainFrame
end

------------------------------------------------------------
-- AÇ / KAPA FONKSİYONLARI
------------------------------------------------------------
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

MinimizedButton.MouseButton1Click:Connect(function()
    if not MainFrame then return end
    openMenu()
end)
