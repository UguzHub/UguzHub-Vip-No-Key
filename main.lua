-- [[ UguzHub V2 VIP - Modern UI, Smooth Auto Farm (Tween) & Mobile UI ]] --

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local CoreGui = game:GetService("CoreGui")
local Clipboard = setclipboard or toclipboard or syn and syn.clipboard

local LocalPlayer = Players.LocalPlayer

------------------------------------------------------------
-- 0) HESAP YAŞ KONTROLÜ
------------------------------------------------------------
if LocalPlayer.AccountAge < 14 then
    LocalPlayer:Kick("Your account is less than 14 days old.")
    return
end

local Camera = Workspace.CurrentCamera

------------------------------------------------------------
-- TEMA & MODERN ARAYÜZ RENKLERİ
------------------------------------------------------------
local Theme = {
    Background   = Color3.fromRGB(13, 13, 18),
    Sidebar      = Color3.fromRGB(18, 18, 26),
    Card         = Color3.fromRGB(24, 24, 35),
    Accent       = Color3.fromRGB(147, 51, 234), -- VIP Mor
    AccentSoft   = Color3.fromRGB(126, 34, 206),
    Blue         = Color3.fromRGB(59, 130, 246),
    Text         = Color3.fromRGB(243, 244, 246),
    SubText      = Color3.fromRGB(156, 163, 175),
    Stroke       = Color3.fromRGB(45, 45, 65),
}

local CARD_TRANSPARENCY = 0.15
local RADIUS = 14

------------------------------------------------------------
-- DİL PAKETLERİ (TÜRK BAYRAĞI EN ÜSTTE, FLİPİNCE EKLENDİ)
------------------------------------------------------------
local Lang = {
    TR = {
        loading = "Yükleniyor", subtitle = "Lütfen Dilinizi Seçin", greeting = "Hoş Geldin", sectionTitle = "Sistem Ayarları", openBtn = "UguzHub", 
        warningText = "Lütfen Delta Ayarlarındaki Tüm Her Şeyi Kapattığınızdan Emin Olun. Oyun Deneyiminizi En Üst Seviyeye Çıkarmak İstiyoruz",
        discordBtn = "Discord Sunucusuna Katıl", discordCopied = "Bağlantı Kopyalandı!",
        espAll = "Oyuncu ESP", espGun = "Yerdeki Silah ESP", autoGrab = "Otomatik Silah Topla", tpGrab = "Smooth Silaha Git",
        aimbot = "Aimbot Kilitlenme", autoKillMurd = "Oto Katili Avla", killMurd = "Katili Öldür", killAll = "Herkesi Katlet (Katil)",
        autoFarm = "Smooth Auto Farm (Anti-Kick)",
        autoFlingMurd = "Katili Savur (Fling)", autoFlingSheriff = "Şerifi Savur (Fling)", autoFlingAll = "Herkesi Savur (Fling)",
        tpLobby = "Lobiye Dön", tpMap = "Haritaya Geç", tpMurd = "Katile Işınlan", tpSheriff = "Şerife Işınlan",
        tabESP = "Görüş (ESP)", tabAimbot = "Hedef (Aimbot)", tabPlayers = "Oto Farm & Oyuncu", tabTP = "Işınlanma", tabSettings = "Ayarlar"
    },
    TL = { -- Tagalog / Filpince
        loading = "Naglo-load", subtitle = "Pumili ng Wika", greeting = "Maligayang Pagdating", sectionTitle = "Mga Setting ng Sistema", openBtn = "UguzHub", 
        warningText = "Mangyaring Siguraduhing Naka-off Ang Lahat Sa Delta Settings. Nais Naming Pagbutihin Ang Inyong Karanasan Sa Paglalaro",
        discordBtn = "Sumali sa Discord Server", discordCopied = "Na-copy na ang Link!",
        espAll = "ESP ng Manlalaro", espGun = "ESP ng Baril sa Lupa", autoGrab = "Kusa Kumuha ng Baril", tpGrab = "Smooth Punta sa Baril",
        aimbot = "Aimbot Lock", autoKillMurd = "Auto Patayin ang Murderer", killMurd = "Patayin ang Murderer", killAll = "Patayin Lahat (Bilang Murderer)",
        autoFarm = "Smooth Auto Farm (Anti-Kick)",
        autoFlingMurd = "Auto Fling Murderer", autoFlingSheriff = "Auto Fling Sheriff", autoFlingAll = "Auto Fling Lahat",
        tpLobby = "TP sa Lobby", tpMap = "TP sa Map", tpMurd = "TP sa Murderer", tpSheriff = "TP sa Sheriff",
        tabESP = "ESP Visuals", tabAimbot = "Aimbot", tabPlayers = "Farm & Manlalaro", tabTP = "Teleport", tabSettings = "Mga Setting"
    },
    EN = {
        loading = "Loading", subtitle = "Select your language", greeting = "Welcome back", sectionTitle = "System Settings", openBtn = "UguzHub", 
        warningText = "Please Make Sure To Turn Off Everything In Delta Settings. We Want To Maximize Your Gaming Experience",
        discordBtn = "Join Discord Server", discordCopied = "Link Copied!",
        espAll = "Player ESP", espGun = "Dropped Gun ESP", autoGrab = "Auto Grab Gun", tpGrab = "Smooth Go To Gun",
        aimbot = "Aimbot Lock", autoKillMurd = "Auto Kill Murderer", killMurd = "Kill Murderer", killAll = "Kill All (As Murderer)",
        autoFarm = "Smooth Auto Farm (Anti-Kick)",
        autoFlingMurd = "Auto Fling Murderer", autoFlingSheriff = "Auto Fling Sheriff", autoFlingAll = "Auto Fling All",
        tpLobby = "TP to Lobby", tpMap = "TP to Map", tpMurd = "TP to Murderer", tpSheriff = "TP to Sheriff",
        tabESP = "ESP Visuals", tabAimbot = "Aimbot", tabPlayers = "Farm & Players", tabTP = "Teleport", tabSettings = "Settings"
    }
}

local LanguageOptions = {
    { code = "TR", flag = "🇹🇷", name = "Türkçe" },
    { code = "TL", flag = "🇵🇭", name = "Tagalog" },
    { code = "EN", flag = "🇬🇧", name = "English" }
}

local CurrentLang = "TR"
local L = Lang[CurrentLang]

------------------------------------------------------------
-- HİLE BAYRAKLARI & MOTORLARI
------------------------------------------------------------
local Flags = {
    ESPAll = false, ESPGun = false, AutoGrabGun = false,
    AimbotEnabled = false, AutoKillMurderer = false, AutoFarm = false,
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
    local backpack = player:FindFirstChild("Backpack")
    local character = player.Character
    
    if (backpack and backpack:FindFirstChild("Knife")) or character:FindFirstChild("Knife") then
        return "Murderer"
    elseif (backpack and backpack:FindFirstChild("Gun")) or character:FindFirstChild("Gun") then
        return "Sheriff"
    end
    return "Innocent"
end

------------------------------------------------------------
-- SMOOTH TWEEN GOTO SİSTEMİ (ANTİ-KICK AUTO FARM)
------------------------------------------------------------
local isFarming = false

local function tweenGoto(targetCFrame, speed)
    local char = LocalPlayer.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    if not root then return end

    speed = speed or 28
    local distance = (root.Position - targetCFrame.Position).Magnitude
    local duration = distance / speed

    local tweenInfo = TweenInfo.new(duration, Enum.EasingStyle.Linear)
    local tween = TweenService:Create(root, tweenInfo, { CFrame = targetCFrame })
    
    tween:Play()
    return tween
end

-- SMART AUTO FARM LOOP
task.spawn(function()
    while task.wait(0.2) do
        if Flags.AutoFarm and not isFarming then
            local char = LocalPlayer.Character
            local root = char and char:FindFirstChild("HumanoidRootPart")
            if root then
                local closestCoin = nil
                local shortestDistance = math.huge

                for _, obj in ipairs(Workspace:GetDescendants()) do
                    if (obj:IsA("BasePart") or obj:IsA("MeshPart")) and obj.Name:lower():find("coin") and obj.Transparency < 0.9 then
                        local dist = (root.Position - obj.Position).Magnitude
                        if dist < shortestDistance then
                            shortestDistance = dist
                            closestCoin = obj
                        end
                    end
                end

                if closestCoin then
                    isFarming = true
                    local tw = tweenGoto(closestCoin.CFrame, 32)
                    if tw then
                        tw.Completed:Wait()
                        pcall(function()
                            if firetouchinterest then
                                firetouchinterest(root, closestCoin, 0)
                                firetouchinterest(root, closestCoin, 1)
                            end
                        end)
                    end
                    isFarming = false
                end
            end
        end
    end
end)

-- KILL ALL FUNCTION
local function killAll()
    local myChar = LocalPlayer.Character
    if not myChar then return end
    local knife = myChar:FindFirstChild("Knife") or (LocalPlayer.Backpack and LocalPlayer.Backpack:FindFirstChild("Knife"))
    if not knife then return end
    knife.Parent = myChar
    
    local knifeHandle = knife:FindFirstChild("Handle") or knife:FindFirstChildWithClass("BasePart")
    local myHrp = myChar:FindFirstChild("HumanoidRootPart")

    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            local targetHrp = player.Character:FindFirstChild("HumanoidRootPart")
            if targetHrp and player.Character:FindFirstChildOfClass("Humanoid").Health > 0 then
                myHrp.CFrame = targetHrp.CFrame * CFrame.new(0, 0, 1)
                task.wait(0.05)
                pcall(function()
                    if firetouchinterest then
                        firetouchinterest(knifeHandle, targetHrp, 0)
                        firetouchinterest(knifeHandle, targetHrp, 1)
                    end
                    knife:Activate()
                end)
                task.wait(0.1)
            end
        end
    end
end

------------------------------------------------------------
-- FLING MOTORU
------------------------------------------------------------
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
-- YARDIMCI BİLEŞENLER
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
-- ANA GUI CONTAINER
------------------------------------------------------------
local ScreenGui = create("ScreenGui", { Name = "UguzHubVIPMain", ResetOnSpawn = false, ZIndexBehavior = Enum.ZIndexBehavior.Sibling, DisplayOrder = 999, IgnoreGuiInset = true })
ScreenGui.Parent = CoreGui

------------------------------------------------------------
-- YÜKLEME EKRANI & DİL SEÇİMİ
------------------------------------------------------------
local LoadingFrame = create("Frame", { Name = "Loading", Size = UDim2.fromScale(1, 1), Position = UDim2.fromScale(0, 0), BorderSizePixel = 0, BackgroundColor3 = Theme.Background, ZIndex = 50 })
LoadingFrame.Parent = ScreenGui

local Content = create("Frame", { Name = "Content", AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.new(0.5, 0, 0.42, 0), Size = UDim2.new(0, 360, 0, 140), BackgroundTransparency = 1, ZIndex = 51 })
Content.Parent = LoadingFrame

local LogoLabel = create("TextLabel", { Text = "UguzHub", Font = Enum.Font.GothamBlack, TextSize = 50, TextColor3 = Theme.Text, BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 60), TextTransparency = 1, ZIndex = 51 })
LogoLabel.Parent = Content

local ProTag = create("TextLabel", { Text = "V2 VIP PRO", Font = Enum.Font.GothamBold, TextSize = 18, TextColor3 = Theme.Accent, BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 22), Position = UDim2.new(0, 0, 0, 58), TextTransparency = 1, ZIndex = 51 })
ProTag.Parent = Content

local Underline = create("Frame", { Name = "Underline", Size = UDim2.new(0, 0, 0, 3), Position = UDim2.new(0.5, 0, 0, 88), AnchorPoint = Vector2.new(0.5, 0), BackgroundColor3 = Theme.Accent, BorderSizePixel = 0, ZIndex = 51 })
corner(2).Parent = Underline
Underline.Parent = Content

local LoadingLabel = create("TextLabel", { Text = "Loading", Font = Enum.Font.GothamMedium, TextSize = 17, TextColor3 = Theme.SubText, BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 24), Position = UDim2.new(0, 0, 0, 108), TextTransparency = 1, ZIndex = 51 })
LoadingLabel.Parent = Content

local SubtitleLabel = create("TextLabel", { Text = "", Font = Enum.Font.GothamMedium, TextSize = 15, TextColor3 = Theme.SubText, BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 22), Position = UDim2.new(0.5, -180, 0, 110), TextTransparency = 1, ZIndex = 51, Visible = false })
SubtitleLabel.Parent = Content

local LangHolder = create("Frame", { Name = "LangHolder", AnchorPoint = Vector2.new(0.5, 0), Position = UDim2.new(0.5, 0, 0, 145), Size = UDim2.new(0, 320, 0, 170), BackgroundTransparency = 1, ZIndex = 51, Visible = false })
LangHolder.Parent = Content

create("UIGridLayout", { CellSize = UDim2.new(0, 96, 0, 72), CellPadding = UDim2.new(0, 8, 0, 8), HorizontalAlignment = Enum.HorizontalAlignment.Center, VerticalAlignment = Enum.VerticalAlignment.Center }).Parent = LangHolder

------------------------------------------------------------
-- MİNİMİZE BUTONU
------------------------------------------------------------
local MinimizedButton = create("TextButton", { Name = "MinimizedButton", Text = "⚡ UguzHub", Font = Enum.Font.GothamBold, TextSize = 13, TextColor3 = Theme.Text, BackgroundColor3 = Theme.Accent, Size = UDim2.new(0, 110, 0, 36), Position = UDim2.new(1, -126, 0, 18), AutoButtonColor = false, Visible = false, ZIndex = 40 })
corner(10).Parent = MinimizedButton
stroke(Color3.fromRGB(255, 255, 255), 1).Parent = MinimizedButton
MinimizedButton.Parent = ScreenGui

------------------------------------------------------------
-- UYARI & ANA MENÜ YÖNETİMİ
------------------------------------------------------------
local MainFrame, buildMainMenu, closeMenu, openMenu

local function showWarningScreen()
    local WarnFrame = create("Frame", { Name = "WarnFrame", Size = UDim2.fromScale(1, 1), Position = UDim2.fromScale(0, 0), BackgroundColor3 = Theme.Background, BackgroundTransparency = 1, ZIndex = 60 })
    WarnFrame.Parent = ScreenGui

    local WarnBox = create("Frame", { Size = UDim2.new(0, 420, 0, 180), Position = UDim2.fromScale(0.5, 0.5), AnchorPoint = Vector2.new(0.5, 0.5), BackgroundColor3 = Theme.Card, BackgroundTransparency = 1, ZIndex = 61 })
    corner(16).Parent = WarnBox
    stroke(Theme.Accent, 1.5).Parent = WarnBox
    WarnBox.Parent = WarnFrame

    local WarnText = create("TextLabel", { Text = "", Font = Enum.Font.GothamBold, TextSize = 13, TextColor3 = Theme.Text, TextWrapped = true, TextXAlignment = Enum.TextXAlignment.Center, Size = UDim2.new(1, -40, 1, -40), Position = UDim2.fromScale(0.5, 0.5), AnchorPoint = Vector2.new(0.5, 0.5), BackgroundTransparency = 1, TextTransparency = 1, ZIndex = 62 })
    WarnText.Parent = WarnBox

    tween(WarnFrame, { BackgroundTransparency = 0.2 }, 0.4)
    tween(WarnBox, { BackgroundTransparency = CARD_TRANSPARENCY }, 0.4)
    tween(WarnText, { TextTransparency = 0 }, 0.4)

    task.spawn(function()
        for i = 3, 1, -1 do
            WarnText.Text = L.warningText .. " (" .. i .. ")"
            task.wait(1)
        end
        
        tween(WarnFrame, { BackgroundTransparency = 1 }, 0.4)
        tween(WarnBox, { BackgroundTransparency = 1 }, 0.4)
        tween(WarnText, { TextTransparency = 1 }, 0.4)
        task.wait(0.4)
        WarnFrame:Destroy()

        buildMainMenu()
        MinimizedButton.Text = "⚡ " .. L.openBtn
        MinimizedButton.Visible = true
        MinimizedButton.BackgroundTransparency = 1
        tween(MinimizedButton, { BackgroundTransparency = 0 }, 0.3)
    end)
end

------------------------------------------------------------
-- DİL SEÇİM SİSTEMİ
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
        tween(LoadingFrame, { BackgroundTransparency = 1 }, 0.5)
        tween(LogoLabel, { TextTransparency = 1 }, 0.4)
        tween(ProTag, { TextTransparency = 1 }, 0.4)
        tween(SubtitleLabel,{ TextTransparency = 1 }, 0.4)
        tween(Underline, { BackgroundTransparency = 1 }, 0.4)
        for _, card in ipairs(langCards) do tween(card, { BackgroundTransparency = 1 }, 0.25) end
        task.wait(0.5)
        LoadingFrame.Visible = false

        showWarningScreen()
    end)
end

for i, opt in ipairs(LanguageOptions) do
    local card = create("TextButton", { Name = opt.code, Text = "", AutoButtonColor = false, BackgroundColor3 = Theme.Card, BackgroundTransparency = 1, LayoutOrder = i, ZIndex = 52 })
    corner(10).Parent = card
    stroke().Parent = card
    card:SetAttribute("Code", opt.code)

    create("TextLabel", { Text = opt.flag, Font = Enum.Font.GothamBold, TextSize = 20, BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 26), Position = UDim2.new(0, 0, 0, 8), TextXAlignment = Enum.TextXAlignment.Center, ZIndex = 53 }).Parent = card
    create("TextLabel", { Text = opt.name, Font = Enum.Font.GothamMedium, TextSize = 11, TextColor3 = Theme.Text, BackgroundTransparency = 1, Size = UDim2.new(1, -4, 0, 18), Position = UDim2.new(0, 2, 0, 40), TextXAlignment = Enum.TextXAlignment.Center, ZIndex = 53 }).Parent = card

    card.MouseButton1Click:Connect(function() selectLanguage(opt.code) end)
    card.Parent = LangHolder
    table.insert(langCards, card)
end

------------------------------------------------------------
-- YÜKLEME ANİMASYONU
------------------------------------------------------------
task.defer(function()
    tween(LogoLabel, { TextTransparency = 0 }, 0.6)
    tween(ProTag, { TextTransparency = 0 }, 0.6)
    task.wait(0.15)
    tween(Underline, { Size = UDim2.new(0, 240, 0, 3) }, 0.6, Enum.EasingStyle.Quart)
    task.wait(0.2)
    tween(LoadingLabel, { TextTransparency = 0 }, 0.4)

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

    task.wait(2.5)
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
-- KARE SHOT MURDERER BUTONU (ZIPLAMA TUŞUNUN ÜSTÜNDE)
------------------------------------------------------------
local ShotSquareButton = Instance.new("TextButton")
local SquareCorner = Instance.new("UICorner")
local SquareStroke = Instance.new("UIStroke")
local FillBar = Instance.new("Frame")
local FillCorner = Instance.new("UICorner")
local ButtonIcon = Instance.new("TextLabel")

ShotSquareButton.Name = "ShotSquareButton"
ShotSquareButton.Parent = ScreenGui
ShotSquareButton.Position = UDim2.new(0.82, -110, 0.65, -60)
ShotSquareButton.Size = UDim2.new(0, 55, 0, 55)
ShotSquareButton.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
ShotSquareButton.Text = ""
ShotSquareButton.AutoButtonColor = false
ShotSquareButton.ClipsDescendants = true
ShotSquareButton.ZIndex = 100

SquareCorner.CornerRadius = UDim.new(0, 12)
SquareCorner.Parent = ShotSquareButton

SquareStroke.Parent = ShotSquareButton
SquareStroke.Thickness = 2
SquareStroke.Color = Color3.fromRGB(255, 60, 60)

FillBar.Name = "FillBar"
FillBar.Parent = ShotSquareButton
FillBar.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
FillBar.Position = UDim2.new(0, 0, 1, 0)
FillBar.Size = UDim2.new(1, 0, 0, 0)
FillBar.BorderSizePixel = 0

FillCorner.CornerRadius = UDim.new(0, 12)
FillCorner.Parent = FillBar

ButtonIcon.Name = "ButtonIcon"
ButtonIcon.Parent = ShotSquareButton
ButtonIcon.Size = UDim2.new(1, 0, 1, 0)
ButtonIcon.BackgroundTransparency = 1
ButtonIcon.Font = Enum.Font.GothamBold
ButtonIcon.Text = "🎯"
ButtonIcon.TextSize = 24
ButtonIcon.ZIndex = 101

local isHoldingLock = false

ShotSquareButton.MouseButton1Click:Connect(function()
    local myChar = LocalPlayer.Character
    if myChar and myChar:FindFirstChild("HumanoidRootPart") then
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and getRole(p) == "Murderer" and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                tweenGoto(p.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, 3), 100)
            end
        end
    end
end)

ShotSquareButton.MouseButton1Down:Connect(function()
    isHoldingLock = true
    TweenService:Create(FillBar, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        Size = UDim2.new(1, 0, 1, 0),
        Position = UDim2.new(0, 0, 0, 0)
    }):Play()
end)

ShotSquareButton.MouseButton1Up:Connect(function()
    isHoldingLock = false
    TweenService:Create(FillBar, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        Size = UDim2.new(1, 0, 0, 0),
        Position = UDim2.new(0, 0, 1, 0)
    }):Play()
end)

------------------------------------------------------------
-- ANA MENÜ DİZAYNI
------------------------------------------------------------
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
    MinimizeBtn.MouseButton1Click:Connect(function() closeMenu() end)

    local Sidebar = create("Frame", { Size = UDim2.new(0, 125, 1, -46), Position = UDim2.new(0, 8, 0, 42), BackgroundColor3 = Theme.Sidebar, BackgroundTransparency = CARD_TRANSPARENCY, ZIndex = 6 })
    corner(10).Parent = Sidebar
    Sidebar.Parent = MainFrame

    local TabContainer = create("Frame", { Size = UDim2.new(1, -147, 1, -46), Position = UDim2.new(0, 139, 0, 42), BackgroundTransparency = 1, ZIndex = 6 })
    TabContainer.Parent = MainFrame

    create("UIListLayout", { SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 5) }).Parent = Sidebar

    local pages = {}
    local tabBtns = {}

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

        create("TextLabel", { Text = labelText, Font = Enum.Font.GothamMedium, TextColor3 = Theme.Text, TextSize = 11, BackgroundTransparency = 1, Size = UDim2.new(0.7, 0, 1, 0), Position = UDim2.new(0, 10, 0, 0), TextXAlignment = Enum.TextXAlignment.Left }).Parent = frame

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

    local function createButton(parent, labelText, callback)
        local btn = create("TextButton", { Size = UDim2.new(1, -6, 0, 32), BackgroundColor3 = Theme.Card, Font = Enum.Font.GothamBold, Text = labelText, TextColor3 = Theme.Text, TextSize = 11 })
        corner(8).Parent = btn
        stroke(Theme.Accent, 1).Parent = btn
        btn.Parent = parent
        btn.MouseButton1Click:Connect(function() if callback then callback() end end)
    end

    -- TABLAR
    local ESPTab = addTab(L.tabESP, "👁")
    local AimbotTab = addTab(L.tabAimbot, "🎯")
    local PlayersTab = addTab(L.tabPlayers, "👥")
    local TeleportTab = addTab(L.tabTP, "🚀")
    local SettingsTab = addTab(L.tabSettings, "⚙")

    -- ESP TAB
    createToggle(ESPTab, L.espAll, "ESPAll")
    createToggle(ESPTab, L.espGun, "ESPGun")
    createToggle(ESPTab, L.autoGrab, "AutoGrabGun")
    createButton(ESPTab, L.tpGrab, function()
        local gunDrop = Workspace:FindFirstChild("GunDrop") or Workspace:FindFirstChild("Gun")
        if gunDrop then tweenGoto(gunDrop.CFrame, 35) end
    end)

    -- AIMBOT TAB
    createToggle(AimbotTab, L.aimbot, "AimbotEnabled")

    -- PLAYERS TAB
    createToggle(PlayersTab, L.autoFarm, "AutoFarm")
    createToggle(PlayersTab, L.autoKillMurd, "AutoKillMurderer")
    createButton(PlayersTab, L.killMurd, function()
        local myChar = LocalPlayer.Character
        if myChar and myChar:FindFirstChild("HumanoidRootPart") then
            for _, p in pairs(Players:GetPlayers()) do
                if p ~= LocalPlayer and getRole(p) == "Murderer" and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                    tweenGoto(p.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, 3), 40)
                end
            end
        end
    end)
    createButton(PlayersTab, L.killAll, function()
        killAll()
    end)
    createToggle(PlayersTab, L.autoFlingMurd, "AutoFlingMurderer")
    createToggle(PlayersTab, L.autoFlingSheriff, "AutoFlingSheriff")
    createToggle(PlayersTab, L.autoFlingAll, "AutoFlingAll")

    -- TELEPORT TAB
    createButton(TeleportTab, L.tpLobby, function()
        tweenGoto(CFrame.new(-108, 140, 82), 40)
    end)
    createButton(TeleportTab, L.tpMap, function()
        for _, child in pairs(Workspace:GetChildren()) do
            if child:FindFirstChild("Spawns") or child:FindFirstChild("CoinContainer") then
                local spawnPart = child:FindFirstChild("Spawns") and child.Spawns:FindFirstChildWhichIsA("BasePart") or child:FindFirstChildWhichIsA("BasePart", true)
                if spawnPart then tweenGoto(spawnPart.CFrame + Vector3.new(0, 3, 0), 40); break end
            end
        end
    end)
    createButton(TeleportTab, L.tpMurd, function()
        for _, p in pairs(Players:GetPlayers()) do if p ~= LocalPlayer and getRole(p) == "Murderer" and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then tweenGoto(p.Character.HumanoidRootPart.CFrame + Vector3.new(0, 2, 0), 40); break end end
    end)
    createButton(TeleportTab, L.tpSheriff, function()
        for _, p in pairs(Players:GetPlayers()) do if p ~= LocalPlayer and getRole(p) == "Sheriff" and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then tweenGoto(p.Character.HumanoidRootPart.CFrame + Vector3.new(0, 2, 0), 40); break end end
    end)

    -- SETTINGS TAB
    create("TextLabel", { Text = L.sectionTitle, Font = Enum.Font.GothamBold, TextSize = 13, TextColor3 = Theme.SubText, BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 18), TextXAlignment = Enum.TextXAlignment.Left }).Parent = SettingsTab

    local AvatarFrame = create("Frame", { Size = UDim2.new(0, 42, 0, 42), Position = UDim2.new(0, 4, 0, 24), BackgroundColor3 = Theme.Card, BackgroundTransparency = CARD_TRANSPARENCY })
    corner(21).Parent = AvatarFrame
    stroke(Theme.Accent, 2).Parent = AvatarFrame
    AvatarFrame.Parent = SettingsTab

    local AvatarImage = create("ImageLabel", { Size = UDim2.new(1, -4, 1, -4), Position = UDim2.new(0, 2, 0, 2), BackgroundTransparency = 1, Image = "rbxthumb://type=AvatarHeadShot&id=" .. LocalPlayer.UserId .. "&w=150&h=150" })
    corner(21).Parent = AvatarImage
    AvatarImage.Parent = AvatarFrame

    create("TextLabel", { Text = LocalPlayer.DisplayName .. " (@" .. LocalPlayer.Name .. ")", Font = Enum.Font.GothamBold, TextSize = 11, TextColor3 = Theme.Text, BackgroundTransparency = 1, Size = UDim2.new(1, -56, 0, 18), Position = UDim2.new(0, 54, 0, 25), TextXAlignment = Enum.TextXAlignment.Left }).Parent = SettingsTab
    create("TextLabel", { Text = L.greeting .. ", " .. LocalPlayer.DisplayName .. "!", Font = Enum.Font.Gotham, TextSize = 10, TextColor3 = Theme.SubText, BackgroundTransparency = 1, Size = UDim2.new(1, -56, 0, 16), Position = UDim2.new(0, 54, 0, 43), TextXAlignment = Enum.TextXAlignment.Left }).Parent = SettingsTab

    local DiscordBtn = create("TextButton", { Size = UDim2.new(1, -6, 0, 32), Position = UDim2.new(0, 0, 0, 78), BackgroundColor3 = Theme.Card, Font = Enum.Font.GothamBold, Text = L.discordBtn, TextColor3 = Theme.Text, TextSize = 11 })
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
-- ESP VE AIMBOT ENGINE
------------------------------------------------------------
RunService.RenderStepped:Connect(function()
    -- ESP
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

        if Flags.AutoGrabGun then
            tweenGoto(gunDrop.CFrame, 35)
        end
    end

    -- AIMBOT & KİLİTLENME
    if isHoldingLock then
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and getRole(p) == "Murderer" and p.Character and p.Character:FindFirstChild("Head") then
                Camera.CFrame = CFrame.new(Camera.CFrame.Position, p.Character.Head.Position)
                break
            end
        end
    elseif Flags.AimbotEnabled then
        local targetRole = (getRole(LocalPlayer) == "Murderer") and "Sheriff" or "Murderer"
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and getRole(p) == targetRole and p.Character and p.Character:FindFirstChild("Head") then
                Camera.CFrame = CFrame.new(Camera.CFrame.Position, p.Character.Head.Position)
                break
            end
        end
    end
end)
