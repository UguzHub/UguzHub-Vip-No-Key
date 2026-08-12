--[[
    UguzHub V2 Pro
    Animasyonlu, çok dilli (TR / RU / EN) oyun içi menü arayüzü
    ------------------------------------------------------------
    Bu script yalnızca ARAYÜZ + zararsız/kozmetik özellikler içerir:
      - Animasyonlu giriş ekranı + dil seçimi (bayraklı)
      - Rayfield tarzı sidebar menü (5 bölüm)
      - Ayarlar sekmesinde oyuncunun Roblox avatarı + kullanıcı adı + selamlama
      - Emotes sekmesi: Roblox'un ücretsiz/varsayılan emote'larını oynatır
      - Items sekmesi: "Şaka Bombası" -> sadece görsel + ses efekti (konfeti/duman),
        hiçbir oyuncuya zarar vermez, herhangi bir oyun kuralını ihlal etmez.

    Bu script kasıtlı olarak İÇERMEZ:
      - Aimbot / Silent Aim / Auto Lock
      - ESP / Wallhack
      - Autofarm
      - Fly / Speed (Walkspeed) hilesi
      - Herhangi bir "exploit" ya da haksız avantaj sağlayan kod

    Kullanım: StarterGui içine bir LocalScript olarak koy, ya da
    Players.LocalPlayer.PlayerGui altına çalıştır.
]]

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local SoundService = game:GetService("SoundService")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

------------------------------------------------------------
-- TEMA
------------------------------------------------------------
local Theme = {
    Background   = Color3.fromRGB(18, 18, 24),
    Sidebar      = Color3.fromRGB(24, 24, 32),
    Card         = Color3.fromRGB(30, 30, 40),
    Accent       = Color3.fromRGB(138, 92, 255),   -- mor/lüks vurgu
    AccentSoft   = Color3.fromRGB(90, 60, 180),
    Text         = Color3.fromRGB(235, 235, 245),
    SubText      = Color3.fromRGB(160, 160, 175),
    Stroke       = Color3.fromRGB(50, 50, 65),
}

------------------------------------------------------------
-- DİL PAKETLERİ
------------------------------------------------------------
local Lang = {
    TR = {
        title = "UguzHub V2 Pro",
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
    },
    RU = {
        title = "UguzHub V2 Pro",
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
    },
    EN = {
        title = "UguzHub V2 Pro",
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
        duration or 0.35,
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
-- GİRİŞ EKRANI (INTRO)
------------------------------------------------------------
local IntroFrame = create("Frame", {
    Name = "Intro",
    Size = UDim2.fromScale(1, 1),
    BackgroundColor3 = Theme.Background,
    BackgroundTransparency = 0,
    ZIndex = 10,
}, {})
IntroFrame.Parent = ScreenGui

local LogoLabel = create("TextLabel", {
    Text = "UguzHub",
    Font = Enum.Font.GothamBlack,
    TextSize = 54,
    TextColor3 = Theme.Text,
    BackgroundTransparency = 1,
    Size = UDim2.new(0, 500, 0, 70),
    Position = UDim2.new(0.5, -250, 0.35, -60),
    TextTransparency = 1,
})
LogoLabel.Parent = IntroFrame

local ProTag = create("TextLabel", {
    Text = "V2 PRO",
    Font = Enum.Font.GothamBold,
    TextSize = 20,
    TextColor3 = Theme.Accent,
    BackgroundTransparency = 1,
    Size = UDim2.new(0, 200, 0, 24),
    Position = UDim2.new(0.5, -50, 0.35, 12),
    TextTransparency = 1,
})
ProTag.Parent = IntroFrame

-- Logonun altına "çizilen" animasyonlu çizgi
local Underline = create("Frame", {
    Name = "Underline",
    Size = UDim2.new(0, 0, 0, 3),
    Position = UDim2.new(0.5, 0, 0.35, 46),
    AnchorPoint = Vector2.new(0.5, 0),
    BackgroundColor3 = Theme.Accent,
    BorderSizePixel = 0,
})
Underline.Parent = IntroFrame
corner(2).Parent = Underline

local SubtitleLabel = create("TextLabel", {
    Text = L.subtitle,
    Font = Enum.Font.Gotham,
    TextSize = 16,
    TextColor3 = Theme.SubText,
    BackgroundTransparency = 1,
    Size = UDim2.new(0, 500, 0, 24),
    Position = UDim2.new(0.5, -250, 0.5, 0),
    TextTransparency = 1,
})
SubtitleLabel.Parent = IntroFrame

-- Dil seçim butonları (bayraklı)
local LangHolder = create("Frame", {
    Size = UDim2.new(0, 420, 0, 90),
    Position = UDim2.new(0.5, -210, 0.58, 0),
    BackgroundTransparency = 1,
})
LangHolder.Parent = IntroFrame

local LangList = create("UIListLayout", {
    FillDirection = Enum.FillDirection.Horizontal,
    HorizontalAlignment = Enum.HorizontalAlignment.Center,
    VerticalAlignment = Enum.VerticalAlignment.Center,
    Padding = UDim.new(0, 20),
})
LangList.Parent = LangHolder

local LanguageOptions = {
    { code = "TR", flag = "🇹🇷", name = "Türkçe" },
    { code = "RU", flag = "🇷🇺", name = "Русский" },
    { code = "EN", flag = "🇬🇧", name = "English" },
}

local langButtons = {}

------------------------------------------------------------
-- ANA MENÜ (sonradan doldurulacak)
------------------------------------------------------------
local MainFrame -- forward declare
local buildMainMenu -- forward declare

local function selectLanguage(code)
    CurrentLang = code
    L = Lang[CurrentLang]

    for _, btn in ipairs(langButtons) do
        local isSelected = btn:GetAttribute("Code") == code
        tween(btn, {
            BackgroundColor3 = isSelected and Theme.Accent or Theme.Card,
        }, 0.2)
    end

    SubtitleLabel.Text = L.subtitle

    -- kısa bekleme sonrası intro'dan menüye geç
    task.delay(0.35, function()
        tween(IntroFrame, { BackgroundTransparency = 1 }, 0.5)
        tween(LogoLabel, { TextTransparency = 1 }, 0.3)
        tween(ProTag, { TextTransparency = 1 }, 0.3)
        tween(SubtitleLabel, { TextTransparency = 1 }, 0.3)
        for _, btn in ipairs(langButtons) do
            tween(btn, { BackgroundTransparency = 1 }, 0.3)
        end
        task.wait(0.5)
        IntroFrame.Visible = false

        if not MainFrame then
            buildMainMenu()
        else
            MainFrame.Visible = true
            MainFrame.Position = UDim2.new(0.5, 0, 0.55, 0)
            tween(MainFrame, { Position = UDim2.new(0.5, 0, 0.5, 0) }, 0.4)
        end
    end)
end

for _, opt in ipairs(LanguageOptions) do
    local btn = create("TextButton", {
        Size = UDim2.new(0, 120, 0, 90),
        BackgroundColor3 = Theme.Card,
        AutoButtonColor = false,
        Text = "",
        BackgroundTransparency = 1,
    })
    corner(14).Parent = btn
    stroke().Parent = btn
    btn:SetAttribute("Code", opt.code)

    local flagLabel = create("TextLabel", {
        Text = opt.flag,
        Font = Enum.Font.GothamBold,
        TextSize = 32,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 40),
        Position = UDim2.new(0, 0, 0, 8),
    })
    flagLabel.Parent = btn

    local nameLabel = create("TextLabel", {
        Text = opt.name,
        Font = Enum.Font.GothamMedium,
        TextSize = 14,
        TextColor3 = Theme.Text,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 20),
        Position = UDim2.new(0, 0, 0, 52),
    })
    nameLabel.Parent = btn

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

-- Giriş animasyonu: logo fade-in + underline "çizilme"
task.defer(function()
    tween(LogoLabel, { TextTransparency = 0 }, 0.6)
    tween(ProTag, { TextTransparency = 0 }, 0.6)
    task.wait(0.15)
    tween(Underline, { Size = UDim2.new(0, 240, 0, 3) }, 0.6, Enum.EasingStyle.Quart)
    task.wait(0.25)
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
function buildMainMenu()
    MainFrame = create("Frame", {
        Name = "MainMenu",
        Size = UDim2.new(0, 620, 0, 420),
        Position = UDim2.new(0.5, 0, 0.55, 0),
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundColor3 = Theme.Background,
        ClipsDescendants = true,
        ZIndex = 5,
    })
    corner(18).Parent = MainFrame
    stroke(Theme.Accent, 1.5).Parent = MainFrame
    MainFrame.Parent = ScreenGui

    -- Arka plan görseli (Rayfield tarzı, yarı saydam, menünün en altında)
    local BackgroundArt = create("ImageLabel", {
        Name = "BackgroundArt",
        Image = "rbxassetid://15732257423",
        Size = UDim2.new(1, 0, 1, 0),
        Position = UDim2.new(0, 0, 0, 0),
        BackgroundTransparency = 1,
        ImageTransparency = 0.55,
        ScaleType = Enum.ScaleType.Crop,
        ZIndex = 1,
    })
    corner(18).Parent = BackgroundArt
    BackgroundArt.Parent = MainFrame

    -- Görselin üstüne hafif karartma, metinlerin okunabilir kalması için
    local BackgroundDim = create("Frame", {
        Name = "BackgroundDim",
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundColor3 = Theme.Background,
        BackgroundTransparency = 0.35,
        ZIndex = 2,
    })
    corner(18).Parent = BackgroundDim
    BackgroundDim.Parent = MainFrame

    -- Üst bar
    local TopBar = create("Frame", {
        Size = UDim2.new(1, 0, 0, 48),
        BackgroundColor3 = Theme.Sidebar,
        ZIndex = 6,
    })
    corner(18).Parent = TopBar
    TopBar.Parent = MainFrame

    create("TextLabel", {
        Text = "UguzHub  •  V2 Pro",
        Font = Enum.Font.GothamBold,
        TextSize = 16,
        TextColor3 = Theme.Text,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, -20, 1, 0),
        Position = UDim2.new(0, 16, 0, 0),
        TextXAlignment = Enum.TextXAlignment.Left,
        ZIndex = 7,
    }).Parent = TopBar

    local CloseBtn = create("TextButton", {
        Text = "✕",
        Font = Enum.Font.GothamBold,
        TextSize = 16,
        TextColor3 = Theme.SubText,
        BackgroundTransparency = 1,
        Size = UDim2.new(0, 36, 0, 36),
        Position = UDim2.new(1, -42, 0, 6),
        ZIndex = 7,
    })
    CloseBtn.Parent = TopBar
    CloseBtn.MouseButton1Click:Connect(function()
        tween(MainFrame, { Size = UDim2.new(0, 0, 0, 0) }, 0.3)
        task.wait(0.3)
        MainFrame.Visible = false
    end)

    -- Sidebar
    local Sidebar = create("Frame", {
        Size = UDim2.new(0, 160, 1, -48),
        Position = UDim2.new(0, 0, 0, 48),
        BackgroundColor3 = Theme.Sidebar,
        ZIndex = 6,
    })
    Sidebar.Parent = MainFrame

    local SidebarLayout = create("UIListLayout", {
        Padding = UDim.new(0, 6),
        SortOrder = Enum.SortOrder.LayoutOrder,
    })
    SidebarLayout.Parent = Sidebar

    create("UIPadding", {
        PaddingTop = UDim.new(0, 12),
        PaddingLeft = UDim.new(0, 10),
        PaddingRight = UDim.new(0, 10),
    }).Parent = Sidebar

    -- İçerik alanı
    local Content = create("Frame", {
        Size = UDim2.new(1, -160, 1, -48),
        Position = UDim2.new(0, 160, 0, 48),
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
                page.Position = UDim2.new(0, 12, 0, 8)
                tween(page, { Position = UDim2.new(0, 0, 0, 0) }, 0.3)
            end
        end
        for i, btn in ipairs(tabButtons) do
            tween(btn, {
                BackgroundColor3 = (i == index) and Theme.Accent or Theme.Sidebar,
            }, 0.2)
        end
    end

    ------------------------------------------------------------
    -- SAYFA OLUŞTURUCU YARDIMCI
    ------------------------------------------------------------
    local function newPage()
        local page = create("Frame", {
            Size = UDim2.new(1, -24, 1, -16),
            Position = UDim2.new(0, 12, 0, 8),
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
    local WelcomeLabel = create("TextLabel", {
        Text = L.welcome,
        Font = Enum.Font.GothamBold,
        TextSize = 22,
        TextColor3 = Theme.Text,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 34),
        TextXAlignment = Enum.TextXAlignment.Left,
    })
    WelcomeLabel.Parent = MainPage

    local function makeToggleRow(labelText, yPos)
        local row = create("Frame", {
            Size = UDim2.new(1, 0, 0, 44),
            Position = UDim2.new(0, 0, 0, yPos),
            BackgroundColor3 = Theme.Card,
        })
        corner(10).Parent = row
        local lbl = create("TextLabel", {
            Text = labelText,
            Font = Enum.Font.Gotham,
            TextSize = 14,
            TextColor3 = Theme.Text,
            BackgroundTransparency = 1,
            Size = UDim2.new(1, -70, 1, 0),
            Position = UDim2.new(0, 14, 0, 0),
            TextXAlignment = Enum.TextXAlignment.Left,
        })
        lbl.Parent = row

        local toggle = create("TextButton", {
            Size = UDim2.new(0, 44, 0, 24),
            Position = UDim2.new(1, -58, 0.5, -12),
            BackgroundColor3 = Theme.AccentSoft,
            Text = "",
        })
        corner(12).Parent = toggle
        local knob = create("Frame", {
            Size = UDim2.new(0, 18, 0, 18),
            Position = UDim2.new(0, 3, 0.5, -9),
            BackgroundColor3 = Theme.Text,
        })
        corner(9).Parent = knob
        knob.Parent = toggle

        local state = false
        toggle.MouseButton1Click:Connect(function()
            state = not state
            tween(knob, { Position = state and UDim2.new(1, -21, 0.5, -9) or UDim2.new(0, 3, 0.5, -9) }, 0.2)
            tween(toggle, { BackgroundColor3 = state and Theme.Accent or Theme.AccentSoft }, 0.2)
        end)

        row.Parent = MainPage
        return row
    end

    makeToggleRow(L.settingsToggle1, 50)
    makeToggleRow(L.settingsToggle2, 102)

    ------------------------------------------------------------
    -- 2) ITEMS SAYFASI ("Şaka Bombası")
    ------------------------------------------------------------
    local ItemsPage = newPage()

    local BombCard = create("Frame", {
        Size = UDim2.new(1, 0, 0, 110),
        BackgroundColor3 = Theme.Card,
    })
    corner(12).Parent = BombCard
    BombCard.Parent = ItemsPage

    create("TextLabel", {
        Text = "🎉 " .. L.jokebomb,
        Font = Enum.Font.GothamBold,
        TextSize = 18,
        TextColor3 = Theme.Text,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, -24, 0, 26),
        Position = UDim2.new(0, 14, 0, 12),
        TextXAlignment = Enum.TextXAlignment.Left,
    }).Parent = BombCard

    create("TextLabel", {
        Text = L.jokebombDesc,
        Font = Enum.Font.Gotham,
        TextSize = 13,
        TextColor3 = Theme.SubText,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, -24, 0, 20),
        Position = UDim2.new(0, 14, 0, 40),
        TextXAlignment = Enum.TextXAlignment.Left,
        TextWrapped = true,
    }).Parent = BombCard

    local BombBtn = create("TextButton", {
        Text = "USE",
        Font = Enum.Font.GothamBold,
        TextSize = 14,
        TextColor3 = Theme.Text,
        BackgroundColor3 = Theme.Accent,
        Size = UDim2.new(0, 90, 0, 30),
        Position = UDim2.new(1, -104, 1, -42),
    })
    corner(8).Parent = BombBtn
    BombBtn.Parent = BombCard

    -- Şaka bombası: yalnızca görsel/ses efekti, hasar YOK, exploit DEĞİL
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

        game:GetService("Debris"):AddItem(attachment, 2)
        game:GetService("Debris"):AddItem(sound, 3)
    end

    BombBtn.MouseButton1Click:Connect(triggerJokeBomb)

    ------------------------------------------------------------
    -- 3) EMOTES SAYFASI (Roblox'un ücretsiz/varsayılan emoteları)
    ------------------------------------------------------------
    local EmotesPage = newPage()

    create("TextLabel", {
        Text = L.emoteHeader,
        Font = Enum.Font.GothamBold,
        TextSize = 18,
        TextColor3 = Theme.Text,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 26),
        TextXAlignment = Enum.TextXAlignment.Left,
    }).Parent = EmotesPage

    local EmoteGrid = create("Frame", {
        Size = UDim2.new(1, 0, 1, -36),
        Position = UDim2.new(0, 0, 0, 36),
        BackgroundTransparency = 1,
    })
    EmoteGrid.Parent = EmotesPage

    local GridLayout = create("UIGridLayout", {
        CellSize = UDim2.new(0, 100, 0, 60),
        CellPadding = UDim2.new(0, 10, 0, 10),
    })
    GridLayout.Parent = EmoteGrid

    -- Bunlar Roblox'un standart, herkese ücretsiz gelen emote'larıdır
    local DefaultEmotes = { "wave", "point", "laugh", "dance", "cheer" }

    for _, emoteName in ipairs(DefaultEmotes) do
        local eBtn = create("TextButton", {
            Text = emoteName:sub(1, 1):upper() .. emoteName:sub(2),
            Font = Enum.Font.GothamMedium,
            TextSize = 13,
            TextColor3 = Theme.Text,
            BackgroundColor3 = Theme.Card,
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
        Size = UDim2.new(0, 90, 0, 90),
        Position = UDim2.new(0, 0, 0, 0),
        BackgroundColor3 = Theme.Card,
    })
    corner(45).Parent = AvatarFrame
    stroke(Theme.Accent, 2).Parent = AvatarFrame
    AvatarFrame.Parent = SettingsPage

    local AvatarImage = create("ImageLabel", {
        Size = UDim2.new(1, -6, 1, -6),
        Position = UDim2.new(0, 3, 0, 3),
        BackgroundTransparency = 1,
        Image = "rbxthumb://type=AvatarHeadShot&id=" .. LocalPlayer.UserId .. "&w=150&h=150",
    })
    corner(45).Parent = AvatarImage
    AvatarImage.Parent = AvatarFrame

    local NameLabel = create("TextLabel", {
        Text = LocalPlayer.DisplayName .. "  (@" .. LocalPlayer.Name .. ")",
        Font = Enum.Font.GothamBold,
        TextSize = 16,
        TextColor3 = Theme.Text,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, -110, 0, 22),
        Position = UDim2.new(0, 104, 0, 14),
        TextXAlignment = Enum.TextXAlignment.Left,
    })
    NameLabel.Parent = SettingsPage

    local GreetLabel = create("TextLabel", {
        Text = L.greeting .. ", " .. LocalPlayer.DisplayName .. "?",
        Font = Enum.Font.Gotham,
        TextSize = 14,
        TextColor3 = Theme.SubText,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, -110, 0, 20),
        Position = UDim2.new(0, 104, 0, 40),
        TextXAlignment = Enum.TextXAlignment.Left,
    })
    GreetLabel.Parent = SettingsPage

    ------------------------------------------------------------
    -- 5) BİLGİ SAYFASI
    ------------------------------------------------------------
    local InfoPage = newPage()
    create("TextLabel", {
        Text = L.infoText,
        Font = Enum.Font.Gotham,
        TextSize = 15,
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
            TextSize = 14,
            TextColor3 = Theme.Text,
            BackgroundColor3 = Theme.Sidebar,
            Size = UDim2.new(1, 0, 0, 36),
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

    -- Açılış animasyonu
    MainFrame.Size = UDim2.new(0, 0, 0, 0)
    tween(MainFrame, { Size = UDim2.new(0, 620, 0, 420) }, 0.45, Enum.EasingStyle.Back)
end

------------------------------------------------------------
-- ScreenGui'yi ekranın ortasına yerleştirmek için ek düzen
------------------------------------------------------------
IntroFrame.Position = UDim2.fromScale(0, 0)
