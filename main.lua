--[[
    UguzHub V2 Pro
    Animasyonlu, çok dilli (TR / RU / EN) oyun içi menü arayüzü
    ------------------------------------------------------------
    Akış:
      1) 0-5sn: Büyük "UguzHub" logosu + "Loading" yazısı (menü YOK)
      2) 5sn sonra: Dil seçim ekranı (bayraklı: TR / RU / EN)
      3) Dil seçilince: sağ üstte küçük "UguzHub" butonu belirir
      4) Butona basınca: kompakt ana menü açılır (Rayfield tarzı)
      5) Menü içindeki "–" butonuna basınca: menü küçülür, buton geri gelir

    Bu script yalnızca ARAYÜZ + zararsız/kozmetik özellikler içerir:
      - Ana Sayfa / Itemler / Emoteler / Ayarlar / Bilgi sekmeleri
      - Ayarlar: oyuncunun gerçek Roblox avatarı + kullanıcı adı + selamlama
      - Emoteler: Roblox'un ücretsiz/varsayılan emote'larını oynatır
      - Itemler: "Şaka Bombası" -> sadece görsel + ses efekti (konfeti/duman)

    Bu script kasıtlı olarak İÇERMEZ:
      - Aimbot / Silent Aim / Auto Lock / ESP / Wallhack
      - Autofarm / Fly / Speed (Walkspeed) hilesi
      - Herhangi bir "exploit" ya da haksız avantaj sağlayan kod

    Kullanım: StarterGui içine bir LocalScript olarak koy.
]]

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local Debris = game:GetService("Debris")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

------------------------------------------------------------
-- TEMA
------------------------------------------------------------
local Theme = {
    Background   = Color3.fromRGB(16, 16, 22),
    Sidebar      = Color3.fromRGB(20, 20, 28),
    Card         = Color3.fromRGB(32, 32, 42),
    Accent       = Color3.fromRGB(138, 92, 255),
    AccentSoft   = Color3.fromRGB(90, 60, 180),
    Text         = Color3.fromRGB(235, 235, 245),
    SubText      = Color3.fromRGB(165, 165, 180),
    Stroke       = Color3.fromRGB(55, 55, 70),
}

local CARD_TRANSPARENCY = 0.28 -- arka plan görselinin kartların arkasından görünmesi için

------------------------------------------------------------
-- DİL PAKETLERİ
------------------------------------------------------------
local Lang = {
    TR = {
        loading = "Yükleniyor",
        subtitle = "Devam etmek için bir dil seçin",
        tabs = { "Ana Sayfa", "Itemler", "Emoteler", "Ayarlar", "Bilgi" },
        greeting = "Bugün nasılsın",
        welcome = "Hoş geldin, menü hazır!",
        jokebomb = "Şaka Bombası",
        jokebombDesc = "Etrafına zararsız konfeti ve duman patlatır.",
        emoteHeader = "Ücretsiz Emoteler",
        infoText = "UguzHub V2 Pro - lüks ve animasyonlu menü sistemi.",
        settingsToggle1 = "Bildirim Sesleri",
        settingsToggle2 = "Otomatik Tema",
        openBtn = "UguzHub",
    },
    RU = {
        loading = "Загрузка",
        subtitle = "Выберите язык, чтобы продолжить",
        tabs = { "Главная", "Предметы", "Эмоции", "Настройки", "Инфо" },
        greeting = "Как дела сегодня",
        welcome = "Добро пожаловать, меню готово!",
        jokebomb = "Шуточная Бомба",
        jokebombDesc = "Безобидные конфетти и дым вокруг вас.",
        emoteHeader = "Бесплатные эмоции",
        infoText = "UguzHub V2 Pro - роскошное анимированное меню.",
        settingsToggle1 = "Звуки уведомлений",
        settingsToggle2 = "Авто-тема",
        openBtn = "UguzHub",
    },
    EN = {
        loading = "Loading",
        subtitle = "Select a language to continue",
        tabs = { "Main", "Items", "Emotes", "Settings", "Info" },
        greeting = "How are you today",
        welcome = "Welcome, your menu is ready!",
        jokebomb = "Joke Bomb",
        jokebombDesc = "Bursts harmless confetti and smoke around you.",
        emoteHeader = "Free Emotes",
        infoText = "UguzHub V2 Pro - a luxurious, animated menu system.",
        settingsToggle1 = "Notification Sounds",
        settingsToggle2 = "Auto Theme",
        openBtn = "UguzHub",
    },
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
    return create("UICorner", { CornerRadius = UDim.new(0, radius or 12) })
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
})
ScreenGui.Parent = PlayerGui

------------------------------------------------------------
-- GİRİŞ EKRANI (LOADING + DİL SEÇİMİ AYNI FRAME İÇİNDE, AŞAMALI)
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

-- Logonun altına "çizilen" animasyonlu çizgi
local Underline = create("Frame", {
    Name = "Underline",
    Size = UDim2.new(0, 0, 0, 3),
    Position = UDim2.new(0.5, 0, 0.38, 46),
    AnchorPoint = Vector2.new(0.5, 0),
    BackgroundColor3 = Theme.Accent,
    BorderSizePixel = 0,
    ZIndex = 11,
})
Underline.Parent = IntroFrame
corner(2).Parent = Underline

-- Yükleniyor yazısı (0-5sn arası görünür)
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

-- Dil seçim alt başlığı (5sn sonra görünür)
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

-- Dil seçim butonları (bayraklı, 5sn sonra görünür)
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

local LanguageOptions = {
    { code = "TR", flag = "🇹🇷", name = "Türkçe" },
    { code = "RU", flag = "🇷🇺", name = "Русский" },
    { code = "EN", flag = "🇬🇧", name = "English" },
}

local langButtons = {}

------------------------------------------------------------
-- KÜÇÜLTÜLMÜŞ (MINIMIZED) BUTON - sağ üst köşe, "UguzHub" yazısı
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
-- ANA MENÜ (sonradan doldurulacak)
------------------------------------------------------------
local MainFrame -- forward declare
local buildMainMenu -- forward declare
local openMenu -- forward declare
local closeMenu -- forward declare

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

------------------------------------------------------------
-- AŞAMA 1: 0-5sn YÜKLEME EKRANI, AŞAMA 2: DİL SEÇİMİ
------------------------------------------------------------
task.defer(function()
    -- Logo + "Loading" belirir
    tween(LogoLabel, { TextTransparency = 0 }, 0.6)
    tween(ProTag, { TextTransparency = 0 }, 0.6)
    task.wait(0.15)
    tween(Underline, { Size = UDim2.new(0, 240, 0, 3) }, 0.6, Enum.EasingStyle.Quart)
    task.wait(0.2)
    tween(LoadingLabel, { TextTransparency = 0 }, 0.4)

    -- Loading yazısı nokta animasyonu (bu sırada HİÇBİR menü yüklenmez)
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

    task.wait(5) -- toplam 5 saniye bekleme
    dotsRunning = false

    -- Loading'den dil seçimine geçiş
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
-- ANA MENÜ OLUŞTURMA (kompakt, Rayfield tarzı)
------------------------------------------------------------
local MENU_W, MENU_H = 460, 320
local SIDEBAR_W = 130

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

    -- Arka plan görseli (Rayfield tarzı) - net görünür, hafif karartılmış
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

    -- Okunabilirlik için hafif karartma (görsel hâlâ net görünür kalır)
    local BackgroundDim = create("Frame", {
        Name = "BackgroundDim",
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundColor3 = Theme.Background,
        BackgroundTransparency = 0.55,
        ZIndex = 2,
    })
    corner(16).Parent = BackgroundDim
    BackgroundDim.Parent = MainFrame

    -- Üst bar
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

    -- Küçültme butonu ("–") -> menüyü kapatır, sağ üstteki UguzHub butonunu geri getirir
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

    -- Sidebar
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

    -- İçerik alanı
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

    ------------------------------------------------------------
    -- 1) MAIN SAYFASI
    ------------------------------------------------------------
    local MainPage = newPage()
    create("TextLabel", {
        Text = L.welcome,
        Font = Enum.Font.GothamBold,
        TextSize = 18,
        TextColor3 = Theme.Text,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 28),
        TextXAlignment = Enum.TextXAlignment.Left,
    }).Parent = MainPage

    local function makeToggleRow(labelText, yPos)
        local row = create("Frame", {
            Size = UDim2.new(1, 0, 0, 38),
            Position = UDim2.new(0, 0, 0, yPos),
            BackgroundColor3 = Theme.Card,
            BackgroundTransparency = CARD_TRANSPARENCY,
        })
        corner(10).Parent = row

        create("TextLabel", {
            Text = labelText,
            Font = Enum.Font.Gotham,
            TextSize = 13,
            TextColor3 = Theme.Text,
            BackgroundTransparency = 1,
            Size = UDim2.new(1, -66, 1, 0),
            Position = UDim2.new(0, 12, 0, 0),
            TextXAlignment = Enum.TextXAlignment.Left,
        }).Parent = row

        local toggle = create("TextButton", {
            Size = UDim2.new(0, 40, 0, 22),
            Position = UDim2.new(1, -52, 0.5, -11),
            BackgroundColor3 = Theme.AccentSoft,
            Text = "",
        })
        corner(11).Parent = toggle
        local knob = create("Frame", {
            Size = UDim2.new(0, 16, 0, 16),
            Position = UDim2.new(0, 3, 0.5, -8),
            BackgroundColor3 = Theme.Text,
        })
        corner(8).Parent = knob
        knob.Parent = toggle

        local state = false
        toggle.MouseButton1Click:Connect(function()
            state = not state
            tween(knob, { Position = state and UDim2.new(1, -19, 0.5, -8) or UDim2.new(0, 3, 0.5, -8) }, 0.2)
            tween(toggle, { BackgroundColor3 = state and Theme.Accent or Theme.AccentSoft }, 0.2)
        end)

        row.Parent = MainPage
        return row
    end

    makeToggleRow(L.settingsToggle1, 40)
    makeToggleRow(L.settingsToggle2, 84)

    ------------------------------------------------------------
    -- 2) ITEMS SAYFASI ("Şaka Bombası")
    ------------------------------------------------------------
    local ItemsPage = newPage()

    local BombCard = create("Frame", {
        Size = UDim2.new(1, 0, 0, 100),
        BackgroundColor3 = Theme.Card,
        BackgroundTransparency = CARD_TRANSPARENCY,
    })
    corner(12).Parent = BombCard
    BombCard.Parent = ItemsPage

    create("TextLabel", {
        Text = "🎉 " .. L.jokebomb,
        Font = Enum.Font.GothamBold,
        TextSize = 16,
        TextColor3 = Theme.Text,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, -20, 0, 24),
        Position = UDim2.new(0, 12, 0, 10),
        TextXAlignment = Enum.TextXAlignment.Left,
    }).Parent = BombCard

    create("TextLabel", {
        Text = L.jokebombDesc,
        Font = Enum.Font.Gotham,
        TextSize = 12,
        TextColor3 = Theme.SubText,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, -20, 0, 30),
        Position = UDim2.new(0, 12, 0, 34),
        TextXAlignment = Enum.TextXAlignment.Left,
        TextWrapped = true,
    }).Parent = BombCard

    local BombBtn = create("TextButton", {
        Text = "USE",
        Font = Enum.Font.GothamBold,
        TextSize = 13,
        TextColor3 = Theme.Text,
        BackgroundColor3 = Theme.Accent,
        Size = UDim2.new(0, 80, 0, 26),
        Position = UDim2.new(1, -92, 1, -36),
    })
    corner(8).Parent = BombBtn
    BombBtn.Parent = BombCard

    local function triggerJokeBomb()
        local character = LocalPlayer.Character
        if not character then return end
        local hrp = character:FindFirstChild("HumanoidRootPart")
        if not hrp then return end

        local attachment = Instance.new("Attachment")
        attachment.Parent = hrp

        local confetti = Instance.new("ParticleEmitter")
        confetti.Texture = "rbxasset://textures/particles/sparkles_main.dds"
        confetti.Lifetime = NumberRange.new(1, 1.5)
        confetti.Rate = 0
        confetti.Speed = NumberRange.new(8, 16)
        confetti.SpreadAngle = Vector2.new(180, 180)
        confetti.Color = ColorSequence.new(Theme.Accent)
        confetti.Parent = attachment
        confetti:Emit(40)

        local sound = Instance.new("Sound")
        sound.SoundId = "rbxasset://sounds/impact_water.mp3"
        sound.Volume = 0.6
        sound.Parent = hrp
        sound:Play()

        Debris:AddItem(attachment, 2)
        Debris:AddItem(sound, 3)
    end

    BombBtn.MouseButton1Click:Connect(triggerJokeBomb)

    ------------------------------------------------------------
    -- 3) EMOTES SAYFASI
    ------------------------------------------------------------
    local EmotesPage = newPage()

    create("TextLabel", {
        Text = L.emoteHeader,
        Font = Enum.Font.GothamBold,
        TextSize = 16,
        TextColor3 = Theme.Text,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 22),
        TextXAlignment = Enum.TextXAlignment.Left,
    }).Parent = EmotesPage

    local EmoteGrid = create("Frame", {
        Size = UDim2.new(1, 0, 1, -30),
        Position = UDim2.new(0, 0, 0, 30),
        BackgroundTransparency = 1,
    })
    EmoteGrid.Parent = EmotesPage

    create("UIGridLayout", {
        CellSize = UDim2.new(0, 92, 0, 50),
        CellPadding = UDim2.new(0, 8, 0, 8),
    }).Parent = EmoteGrid

    local DefaultEmotes = { "wave", "point", "laugh", "dance", "cheer" }

    for _, emoteName in ipairs(DefaultEmotes) do
        local eBtn = create("TextButton", {
            Text = emoteName:sub(1, 1):upper() .. emoteName:sub(2),
            Font = Enum.Font.GothamMedium,
            TextSize = 12,
            TextColor3 = Theme.Text,
            BackgroundColor3 = Theme.Card,
            BackgroundTransparency = CARD_TRANSPARENCY,
        })
        corner(10).Parent = eBtn
        eBtn.Parent = EmoteGrid

        eBtn.MouseButton1Click:Connect(function()
            local character = LocalPlayer.Character
            local humanoid = character and character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                pcall(function()
                    humanoid:PlayEmote(emoteName)
                end)
            end
        end)
    end

    ------------------------------------------------------------
    -- 4) AYARLAR SAYFASI (Avatar + isim + selamlama)
    ------------------------------------------------------------
    local SettingsPage = newPage()

    local AvatarFrame = create("Frame", {
        Size = UDim2.new(0, 76, 0, 76),
        BackgroundColor3 = Theme.Card,
        BackgroundTransparency = CARD_TRANSPARENCY,
    })
    corner(38).Parent = AvatarFrame
    stroke(Theme.Accent, 2).Parent = AvatarFrame
    AvatarFrame.Parent = SettingsPage

    local AvatarImage = create("ImageLabel", {
        Size = UDim2.new(1, -6, 1, -6),
        Position = UDim2.new(0, 3, 0, 3),
        BackgroundTransparency = 1,
        Image = "rbxthumb://type=AvatarHeadShot&id=" .. LocalPlayer.UserId .. "&w=150&h=150",
    })
    corner(38).Parent = AvatarImage
    AvatarImage.Parent = AvatarFrame

    create("TextLabel", {
        Text = LocalPlayer.DisplayName .. "  (@" .. LocalPlayer.Name .. ")",
        Font = Enum.Font.GothamBold,
        TextSize = 14,
        TextColor3 = Theme.Text,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, -92, 0, 20),
        Position = UDim2.new(0, 88, 0, 10),
        TextXAlignment = Enum.TextXAlignment.Left,
    }).Parent = SettingsPage

    create("TextLabel", {
        Text = L.greeting .. ", " .. LocalPlayer.DisplayName .. "?",
        Font = Enum.Font.Gotham,
        TextSize = 13,
        TextColor3 = Theme.SubText,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, -92, 0, 18),
        Position = UDim2.new(0, 88, 0, 34),
        TextXAlignment = Enum.TextXAlignment.Left,
    }).Parent = SettingsPage

    ------------------------------------------------------------
    -- 5) BİLGİ SAYFASI
    ------------------------------------------------------------
    local InfoPage = newPage()
    create("TextLabel", {
        Text = L.infoText,
        Font = Enum.Font.Gotham,
        TextSize = 13,
        TextColor3 = Theme.SubText,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 60),
        TextWrapped = true,
        TextXAlignment = Enum.TextXAlignment.Left,
    }).Parent = InfoPage

    ------------------------------------------------------------
    -- SIDEBAR TAB BUTONLARI
    ------------------------------------------------------------
    for i, tabName in ipairs(L.tabs) do
        local tabBtn = create("TextButton", {
            Text = tabName,
            Font = Enum.Font.GothamMedium,
            TextSize = 13,
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
-- AÇ / KAPA (Rayfield tarzı, sağ üstteki "UguzHub" butonu ile)
------------------------------------------------------------
function openMenu()
    MinimizedButton.Visible = false
    MainFrame.Visible = true
    MainFrame.Size = UDim2.new(0, MENU_W * 0.85, 0, MENU_H * 0.85)

    -- Sadece hafif bir "pop" animasyonu (X ve Y aynı oranda büyür, katlanma/uzama olmaz)
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
