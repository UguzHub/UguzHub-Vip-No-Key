--[[
    UguzHub V2 Pro - Sheriff Fling & TP to Gun Button Update
]]

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")

local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera

-- Önceki GUI'yi temizle
if CoreGui:FindFirstChild("UguzHubV2Pro") then 
    CoreGui.UguzHubV2Pro:Destroy() 
end

------------------------------------------------------------
-- ÖZELLİK BAYRAKLARI
------------------------------------------------------------
local Flags = {
    SpeedWalk = false,
    SpeedValue = 24,
    JumpPower = false,
    JumpValue = 75,
    InfiniteJump = false,
    Noclip = false,
    
    ESPAll = false,
    ESPMurderer = false,
    ESPSheriff = false,
    ESPInnocent = false,
    
    AimbotEnabled = false,
    AutoShoot = false,
    KillAura = false,
    AutoGrabGun = false,
    AutoGunDropped = false,
    ShootButtonEnabled = false,
    SheriffFling = false,
    
    AutoFarm = false,
    FarmMode = "Teleport",
    KillAllActive = false,
    
    Fullbright = false
}

------------------------------------------------------------
-- TEMA
------------------------------------------------------------
local Theme = {
    Background = Color3.fromRGB(18, 16, 26),
    Sidebar    = Color3.fromRGB(24, 21, 35),
    Card       = Color3.fromRGB(32, 28, 48),
    Accent     = Color3.fromRGB(168, 85, 247),
    AccentSoft = Color3.fromRGB(90, 60, 180),
    Text       = Color3.fromRGB(240, 240, 245),
    SubText    = Color3.fromRGB(160, 155, 180),
    Stroke     = Color3.fromRGB(147, 51, 234),
}

local RADIUS = 14

------------------------------------------------------------
-- DİL PAKETLERİ (4 DİL TAM ÇEVİRİ)
------------------------------------------------------------
local Lang = {}

Lang.TR = {
    loading = "Yükleniyor",
    subtitle = "Dilinizi seçin",
    openBtn = "UguzHub",
    notice = "Sizlere daha iyi bir deneyim sunmak amacıyla lütfen delta ayarlarindaki tüm izinleri Kapattığınıza emin olun.",
    title = "  Murder Mystery 2 | UguzHub V2 Pro",
    tabs = { Main = "Ana Menü", Visual = "Görsel", Combat = "Savaş", Teleport = "Işınlanma" },
    welcome = "Hoşgeldin",
    discordBtn = "Discord: discord.gg/uguzhub (Tıkla Kopyala)",
    discordCopied = "Discord Linki Kopyalandı!",
    autoFarm = "Auto Farm (Coin Topla)",
    farmModeTp = "  Farm Modu: Teleport",
    farmModeTween = "  Farm Modu: Tween",
    killAll = "  Kill All (Herkesi Katlet)",
    speedWalk = "Speed Walk (Hız)",
    jumpPower = "Jump Power (Zıplama)",
    infJump = "Infinite Jump (Sınırsız Zıpla)",
    noclip = "Noclip (Duvardan Geç)",
    espAll = "Player ESP (Tümü)",
    espMur = "Murderer ESP (Katil)",
    espSher = "Sheriff ESP (Şerif)",
    espInno = "Innocent ESP (Masum)",
    aimbot = "Aimbot (Katile Kilitlen)",
    autoShoot = "Auto Shoot (Otomatik Ateş)",
    killAura = "KillAura (Yakındakini Kes)",
    autoGrab = "Auto Grab Gun (Silahı Al)",
    autoDrop = "Auto Gun Dropped (Silah Düşür)",
    shootBtnToggle = "Shoot Murderer Butonu",
    sheriffFling = "Sheriff Fling (Şerif Fırlat)",
    tpToDroppedGun = "Düşen Silaha Işınlan",
    fullbright = "Fullbright (Aydınlık)",
    tpLobby = "  Lobiye Git",
    tpMap = "  Harita Ortasına Git",
    shootBtnText = "🎯 Katili Vur"
}

Lang.EN = {
    loading = "Loading",
    subtitle = "Select your language",
    openBtn = "UguzHub",
    notice = "To provide you with a better experience, please make sure to turn off all permissions in the delta settings.",
    title = "  Murder Mystery 2 | UguzHub V2 Pro",
    tabs = { Main = "Main", Visual = "Visual", Combat = "Combat", Teleport = "Teleport" },
    welcome = "Welcome",
    discordBtn = "Discord: discord.gg/uguzhub (Click to Copy)",
    discordCopied = "Discord Link Copied!",
    autoFarm = "Auto Farm (Coins)",
    farmModeTp = "  Farm Mode: Teleport",
    farmModeTween = "  Farm Mode: Tween",
    killAll = "  Kill All Players",
    speedWalk = "Speed Walk",
    jumpPower = "Jump Power",
    infJump = "Infinite Jump",
    noclip = "Noclip",
    espAll = "Player ESP (All)",
    espMur = "Murderer ESP",
    espSher = "Sheriff ESP",
    espInno = "Innocent ESP",
    aimbot = "Aimbot (Lock Murderer)",
    autoShoot = "Auto Shoot",
    killAura = "KillAura",
    autoGrab = "Auto Grab Gun",
    autoDrop = "Auto Gun Dropped",
    shootBtnToggle = "Shoot Murderer Button",
    sheriffFling = "Sheriff Fling",
    tpToDroppedGun = "TP to Dropped Gun",
    fullbright = "Fullbright",
    tpLobby = "  Teleport to Lobby",
    tpMap = "  Teleport to Map Center",
    shootBtnText = "🎯 Shoot Murderer"
}

Lang.RU = {
    loading = "Загрузка",
    subtitle = "Выберите язык",
    openBtn = "UguzHub",
    notice = "Чтобы обеспечить вам лучший опыт, пожалуйста, убедитесь, что отключили все разрешения в настройках delta.",
    title = "  Murder Mystery 2 | UguzHub V2 Pro",
    tabs = { Main = "Главное", Visual = "Визуал", Combat = "Бой", Teleport = "Телепорт" },
    welcome = "Добро пожаловать",
    discordBtn = "Discord: discord.gg/uguzhub (Нажмите для копирования)",
    discordCopied = "Ссылка Discord скопирована!",
    autoFarm = "Авто Фарм (Монеты)",
    farmModeTp = "  Режим Фарма: Телепорт",
    farmModeTween = "  Режим Фарма: Плавный",
    killAll = "  Убить Всех",
    speedWalk = "Скорость бега",
    jumpPower = "Сила прыжка",
    infJump = "Бесконечный прыжок",
    noclip = "Проход сквозь стены",
    espAll = "ESP Игроков (Все)",
    espMur = "ESP Убийцы",
    espSher = "ESP Шерифа",
    espInno = "ESP Мирных",
    aimbot = "Аимбот (На Убийцу)",
    autoShoot = "Авто Выстрел",
    killAura = "Киллаура",
    autoGrab = "Авто Подбор Пушки",
    autoDrop = "Авто Сброс Пушки",
    shootBtnToggle = "Кнопка Выстрела в Убийцу",
    sheriffFling = "Флинг Шерифа",
    tpToDroppedGun = "ТП к Выпавшей Пушке",
    fullbright = "Яркое Освещение",
    tpLobby = "  Телепорт в Лобби",
    tpMap = "  Телепорт в Центр Карты",
    shootBtnText = "🎯 Убить Убийцу"
}

Lang.DE = {
    loading = "Wird geladen",
    subtitle = "Wähle deine Sprache",
    openBtn = "UguzHub",
    notice = "Um Ihnen ein besseres Erlebnis zu bieten, stellen Sie bitte sicher, dass Sie alle Berechtigungen in den Delta-Einstellungen deaktivieren.",
    title = "  Murder Mystery 2 | UguzHub V2 Pro",
    tabs = { Main = "Haupt", Visual = "Visuell", Combat = "Kampf", Teleport = "Teleport" },
    welcome = "Willkommen",
    discordBtn = "Discord: discord.gg/uguzhub (Klicken zum Kopieren)",
    discordCopied = "Discord Link kopiert!",
    autoFarm = "Auto-Farm (Münzen)",
    farmModeTp = "  Farm-Modus: Teleport",
    farmModeTween = "  Farm-Modus: Tween",
    killAll = "  Alle Töten",
    speedWalk = "Laufgeschwindigkeit",
    jumpPower = "Sprungkraft",
    infJump = "Unendlicher Sprung",
    noclip = "Durch Wände gehen",
    espAll = "Spieler ESP (Alle)",
    espMur = "Mörder ESP",
    espSher = "Sheriff ESP",
    espInno = "Unschuldige ESP",
    aimbot = "Aimbot (Mörder Fokus)",
    autoShoot = "Auto Schießen",
    killAura = "KillAura",
    autoGrab = "Waffe Auto-Aufheben",
    autoDrop = "Waffe Auto-Fallenlassen",
    shootBtnToggle = "Mörder-Schießen Button",
    sheriffFling = "Sheriff Fling",
    tpToDroppedGun = "TP zur Gelandeten Waffe",
    fullbright = "Helles Licht",
    tpLobby = "  Zum Lobby Teleportieren",
    tpMap = "  Zur Kartenmitte Teleportieren",
    shootBtnText = "🎯 Mörder Erschießen"
}

local LanguageOptions = {
    { code = "TR", flag = "🇹🇷", name = "Türkçe" },
    { code = "EN", flag = "🇬🇧", name = "English" },
    { code = "RU", flag = "🇷🇺", name = "Русский" },
    { code = "DE", flag = "🇩🇪", name = "Deutsch" },
}

local CurrentLang = "EN"
local L = Lang[CurrentLang]

------------------------------------------------------------
-- ROLLER VE OYUN İŞLEVLERİ
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

local function executeKillAll()
    local myChar = LocalPlayer.Character
    if not myChar then return end
    local knife = myChar:FindFirstChild("Knife") or (LocalPlayer:FindFirstChild("Backpack") and LocalPlayer.Backpack:FindFirstChild("Knife"))
    if not knife then return end
    knife.Parent = myChar
    
    local knifeHandle = knife:FindFirstChild("Handle") or knife:FindFirstChildWhichIsA("BasePart")
    local myHrp = myChar:FindFirstChild("HumanoidRootPart")
    if not myHrp then return end

    for _, player in ipairs(Players:GetPlayers()) do
        if not Flags.KillAllActive then break end
        if player ~= LocalPlayer and player.Character then
            local targetHrp = player.Character:FindFirstChild("HumanoidRootPart")
            local hum = player.Character:FindFirstChildOfClass("Humanoid")
            if targetHrp and hum and hum.Health > 0 then
                myHrp.CFrame = targetHrp.CFrame * CFrame.new(0, 0, 1)
                task.wait(0.05)
                pcall(function()
                    if firetouchinterest and knifeHandle then
                        firetouchinterest(knifeHandle, targetHrp, 0)
                        firetouchinterest(knifeHandle, targetHrp, 1)
                    end
                    knife:Activate()
                end)
                task.wait(0.1)
            end
        end
    end
    
    Flags.KillAllActive = false
end

local function shootMurdererOnce()
    local char = LocalPlayer.Character
    if not char then return end
    
    local gun = char:FindFirstChild("Gun") or (LocalPlayer:FindFirstChild("Backpack") and LocalPlayer.Backpack:FindFirstChild("Gun"))
    if not gun then return end
    gun.Parent = char
    
    local murdererHead = nil
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and getRole(p) == "Murderer" and p.Character and p.Character:FindFirstChild("Head") then
            murdererHead = p.Character.Head
            break
        end
    end
    
    if murdererHead then
        local startTime = tick()
        while tick() - startTime < 0.8 do
            Camera.CFrame = CFrame.new(Camera.CFrame.Position, murdererHead.Position)
            pcall(function()
                gun:Activate()
            end)
            task.wait(0.03)
        end
    end
end

------------------------------------------------------------
-- DÖNGÜLER
------------------------------------------------------------
task.spawn(function()
    while task.wait(0.5) do
        if Flags.AutoFarm then
            pcall(function()
                local char = LocalPlayer.Character
                local root = char and char:FindFirstChild("HumanoidRootPart")
                if root then
                    for _, obj in ipairs(Workspace:GetDescendants()) do
                        if not Flags.AutoFarm then break end
                        if (obj:IsA("BasePart") or obj:IsA("MeshPart")) and obj.Name:lower():find("coin") and obj.Transparency < 0.9 then
                            if Flags.FarmMode == "Tween" then
                                local distance = (root.Position - obj.Position).Magnitude
                                local speed = 250
                                local tweenInfo = TweenInfo.new(distance / speed, Enum.EasingStyle.Linear)
                                local tween = TweenService:Create(root, tweenInfo, {CFrame = obj.CFrame})
                                tween:Play()
                                tween.Completed:Wait()
                            else
                                root.CFrame = obj.CFrame
                            end
                            
                            pcall(function()
                                if firetouchinterest then
                                    firetouchinterest(root, obj, 0)
                                    firetouchinterest(root, obj, 1)
                                end
                            end)
                            task.wait(0.1)
                            break
                        end
                    end
                end
            end)
        end
    end
end)

RunService.RenderStepped:Connect(function()
    pcall(function()
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            local hum = LocalPlayer.Character.Humanoid
            if Flags.SpeedWalk then hum.WalkSpeed = Flags.SpeedValue end
            if Flags.JumpPower then hum.JumpPower = Flags.JumpValue end
        end

        if Flags.Noclip and LocalPlayer.Character then
            for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
                if part:IsA("BasePart") then part.CanCollide = false end
            end
        end

        for _, plr in pairs(Players:GetPlayers()) do
            if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
                local char = plr.Character
                local esp = char:FindFirstChild("UguzTransESP")
                local role = getRole(plr)
                
                local shouldShow = Flags.ESPAll or 
                                   (Flags.ESPMurderer and role == "Murderer") or 
                                   (Flags.ESPSheriff and role == "Sheriff") or 
                                   (Flags.ESPInnocent and role == "Innocent")

                if shouldShow then
                    if not esp then
                        esp = Instance.new("Highlight")
                        esp.Name = "UguzTransESP"
                        esp.Parent = char
                        esp.Adornee = char
                        esp.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                    end
                    esp.Enabled = true
                    
                    if role == "Murderer" then
                        esp.FillColor = Color3.fromRGB(255, 0, 0)
                    elseif role == "Sheriff" then
                        esp.FillColor = Color3.fromRGB(0, 110, 255)
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

        if Flags.AutoGunDropped and LocalPlayer.Character then
            for _, tool in pairs(LocalPlayer.Character:GetChildren()) do
                if tool:IsA("Tool") and (string.find(tool.Name:lower(), "gun") or tool:FindFirstChild("Handle")) then
                    tool.Parent = Workspace
                end
            end
        end

        if Flags.SheriffFling and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            local myHrp = LocalPlayer.Character.HumanoidRootPart
            for _, p in pairs(Players:GetPlayers()) do
                if p ~= LocalPlayer and getRole(p) == "Sheriff" and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                    local targetHrp = p.Character.HumanoidRootPart
                    myHrp.CFrame = targetHrp.CFrame * CFrame.new(0, 0, 0)
                    myHrp.Velocity = Vector3.new(10000, 10000, 10000)
                    break
                end
            end
        end

        if Flags.AimbotEnabled then
            local murderer = nil
            for _, p in pairs(Players:GetPlayers()) do
                if getRole(p) == "Murderer" and p.Character and p.Character:FindFirstChild("Head") then
                    murderer = p.Character.Head
                    break
                end
            end
            if murderer then
                Camera.CFrame = CFrame.new(Camera.CFrame.Position, murderer.Position)
            end
        end

        if Flags.KillAura and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            local hrp = LocalPlayer.Character.HumanoidRootPart
            for _, p in pairs(Players:GetPlayers()) do
                if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                    if (p.Character.HumanoidRootPart.Position - hrp.Position).Magnitude < 15 then
                        local knife = LocalPlayer.Character:FindFirstChild("Knife") or (LocalPlayer:FindFirstChild("Backpack") and LocalPlayer.Backpack:FindFirstChild("Knife"))
                        if knife then knife.Parent = LocalPlayer.Character end
                    end
                end
            end
        end

        if Flags.Fullbright then
            game:GetService("Lighting").Brightness = 2
            game:GetService("Lighting").ClockTime = 14
            game:GetService("Lighting").GlobalShadows = false
        end
    end)
end)

UserInputService.JumpRequest:Connect(function()
    if Flags.InfiniteJump and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
    end
end)

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
    DisplayOrder = 100,
    IgnoreGuiInset = true,
})
ScreenGui.Parent = CoreGui

------------------------------------------------------------
-- HAREKET ETTİRİLEBİLİR SHOOT MURDERER BUTONU
------------------------------------------------------------
local ShootActionButton = create("TextButton", {
    Name = "ShootActionButton",
    Text = "🎯 Shoot Murderer",
    Font = Enum.Font.GothamBold,
    TextSize = 14,
    TextColor3 = Theme.Text,
    BackgroundColor3 = Theme.Accent,
    Size = UDim2.new(0, 150, 0, 44),
    Position = UDim2.new(0.5, -75, 0.75, 0),
    AutoButtonColor = false,
    Visible = false,
    ZIndex = 50,
})
corner(12).Parent = ShootActionButton
stroke(Color3.fromRGB(255, 255, 255), 1.5).Parent = ShootActionButton
ShootActionButton.Parent = ScreenGui

-- Buton Sürükleme Mantığı
local btnDragging, btnDragStart, btnStartPos
ShootActionButton.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        btnDragging = true
        btnDragStart = input.Position
        btnStartPos = ShootActionButton.Position
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if btnDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - btnDragStart
        ShootActionButton.Position = UDim2.new(
            btnStartPos.X.Scale,
            btnStartPos.X.Offset + delta.X,
            btnStartPos.Y.Scale,
            btnStartPos.Y.Offset + delta.Y
        )
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then 
        btnDragging = false 
    end
end)

ShootActionButton.MouseButton1Click:Connect(function()
    shootMurdererOnce()
end)

------------------------------------------------------------
-- GİRİŞ EKRANI (Yükleme + 4'lü Dil Seçimi)
------------------------------------------------------------
local IntroFrame = create("Frame", {
    Name = "Intro",
    Size = UDim2.new(1, 0, 1, 0),
    Position = UDim2.new(0, 0, 0, 0),
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
    Size = UDim2.new(1, 0, 0, 100),
    BackgroundTransparency = 1,
    ZIndex = 11,
    Visible = false,
})
LangHolder.Parent = IntroContent

create("UIGridLayout", {
    CellSize = UDim2.new(0, 80, 0, 92),
    CellPadding = UDim2.new(0, 8, 0, 0),
    HorizontalAlignment = Enum.HorizontalAlignment.Center,
    SortOrder = Enum.SortOrder.LayoutOrder,
}).Parent = LangHolder

------------------------------------------------------------
-- UYARI EKRANI (Delta Ayarları Geri Sayımı)
------------------------------------------------------------
local NoticeFrame = create("Frame", {
    Name = "Notice",
    Size = UDim2.new(1, 0, 1, 0),
    Position = UDim2.new(0, 0, 0, 0),
    BackgroundColor3 = Theme.Background,
    BackgroundTransparency = 1,
    Visible = false,
    ZIndex = 15,
})
NoticeFrame.Parent = ScreenGui

local NoticeLabel = create("TextLabel", {
    Text = "",
    Font = Enum.Font.GothamMedium,
    TextSize = 18,
    TextColor3 = Theme.Text,
    BackgroundTransparency = 1,
    Size = UDim2.new(0, 480, 0, 160),
    AnchorPoint = Vector2.new(0.5, 0.5),
    Position = UDim2.new(0.5, 0, 0.5, 0),
    TextWrapped = true,
    TextTransparency = 1,
    ZIndex = 16,
})
NoticeLabel.Parent = NoticeFrame

------------------------------------------------------------
-- MİNİMİZE BUTONU
------------------------------------------------------------
local MinimizedButton = create("TextButton", {
    Name = "MinimizedButton",
    Text = "🟣 " .. L.openBtn,
    Font = Enum.Font.GothamBold,
    TextSize = 15,
    TextColor3 = Theme.Text,
    BackgroundColor3 = Theme.Accent,
    Size = UDim2.new(0, 118, 0, 38),
    Position = UDim2.new(1, -134, 0, 16),
    AutoButtonColor = false,
    Visible = false,
    ZIndex = 8,
})
corner(12).Parent = MinimizedButton
stroke(Color3.fromRGB(255, 255, 255), 1).Parent = MinimizedButton
MinimizedButton.Parent = ScreenGui

------------------------------------------------------------
-- MENÜ KONTROLÜ
------------------------------------------------------------
local MainFrame
local buildMainMenu
local openMenu
local closeMenu
local langCards = {}

local function showNoticeThenMenu()
    local countdown = 7
    NoticeLabel.Text = L.notice .. "\n\n(" .. countdown .. ")"
    NoticeFrame.Visible = true
    tween(NoticeFrame, { BackgroundTransparency = 0.05 }, 0.4)
    tween(NoticeLabel, { TextTransparency = 0 }, 0.5)

    task.spawn(function()
        while countdown > 0 do
            task.wait(1)
            countdown = countdown - 1
            NoticeLabel.Text = L.notice .. "\n\n(" .. countdown .. ")"
        end
    end)

    task.delay(7, function()
        tween(NoticeFrame, { BackgroundTransparency = 1 }, 0.5)
        tween(NoticeLabel, { TextTransparency = 1 }, 0.4)
        task.wait(0.5)
        NoticeFrame.Visible = false

        if not MainFrame then
            buildMainMenu()
        end
        openMenu()
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

        MinimizedButton.Text = "🟣 " .. L.openBtn
        ShootActionButton.Text = L.shootBtnText
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
-- GİRİŞ AKIŞI
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
-- ANA MENÜ
------------------------------------------------------------
local MENU_W, MENU_H = 520, 330

function buildMainMenu()
    MainFrame = create("Frame", {
        Name = "MainMenu",
        Size = UDim2.new(0, MENU_W, 0, MENU_H),
        Position = UDim2.new(0.5, 0, 0.5, 0),
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundColor3 = Theme.Background,
        BackgroundTransparency = 0.15,
        ClipsDescendants = true,
        Visible = false,
        ZIndex = 5,
    })
    corner(RADIUS).Parent = MainFrame
    stroke(Theme.Stroke, 2).Parent = MainFrame
    MainFrame.Parent = ScreenGui

    local Header = create("Frame", {
        Size = UDim2.new(1, 0, 0, 36),
        BackgroundColor3 = Theme.Sidebar,
        BackgroundTransparency = 0.3,
        Parent = MainFrame,
        ZIndex = 6,
    })

    create("TextLabel", {
        Text = L.title,
        Size = UDim2.new(1, -40, 1, 0),
        TextColor3 = Theme.Text,
        Font = Enum.Font.GothamBold,
        TextSize = 13,
        TextXAlignment = Enum.TextXAlignment.Left,
        BackgroundTransparency = 1,
        Parent = Header,
        ZIndex = 7,
    })

    local CloseBtn = create("TextButton", {
        Text = "×",
        Font = Enum.Font.GothamBold,
        TextSize = 18,
        TextColor3 = Theme.SubText,
        BackgroundTransparency = 1,
        Size = UDim2.new(0, 36, 0, 36),
        Position = UDim2.new(1, -36, 0, 0),
        Parent = Header,
        ZIndex = 7,
    })

    CloseBtn.MouseButton1Click:Connect(function()
        closeMenu()
    end)

    local Sidebar = create("Frame", {
        Size = UDim2.new(0, 130, 1, -36),
        Position = UDim2.new(1, -130, 0, 36),
        BackgroundColor3 = Theme.Sidebar,
        BackgroundTransparency = 0.4,
        Parent = MainFrame,
        ZIndex = 6,
    })

    create("UIListLayout", {
        Padding = UDim.new(0, 4),
        Parent = Sidebar,
    })

    local ContentContainer = create("Frame", {
        Size = UDim2.new(1, -135, 1, -42),
        Position = UDim2.new(0, 4, 0, 40),
        BackgroundTransparency = 1,
        Parent = MainFrame,
        ZIndex = 6,
    })

    local pages, tabBtns = {}, {}

    local function addTab(name, id)
        local page = create("ScrollingFrame", {
            Size = UDim2.new(1, 0, 1, 0),
            BackgroundTransparency = 1,
            ScrollBarThickness = 2,
            Visible = false,
            Parent = ContentContainer,
            ZIndex = 6,
        })

        create("UIListLayout", {
            Padding = UDim.new(0, 6),
            Parent = page,
        })

        local btn = create("TextButton", {
            Size = UDim2.new(1, 0, 0, 48),
            Text = name,
            BackgroundColor3 = Theme.Sidebar,
            BackgroundTransparency = 0.5,
            TextColor3 = Theme.SubText,
            Font = Enum.Font.GothamMedium,
            TextSize = 12,
            AutoButtonColor = false,
            Parent = Sidebar,
            ZIndex = 7,
        })

        btn.MouseButton1Click:Connect(function()
            for _, p in pairs(pages) do p.Visible = false end
            for _, b in pairs(tabBtns) do 
                b.BackgroundColor3 = Theme.Sidebar
                b.TextColor3 = Theme.SubText 
            end
            page.Visible = true
            btn.BackgroundColor3 = Theme.Card
            btn.TextColor3 = Theme.Accent
        end)

        pages[id] = page
        tabBtns[id] = btn
        return page
    end

    local function createToggle(parent, text, flag, callback)
        local frame = create("Frame", {
            Size = UDim2.new(1, -4, 0, 34),
            BackgroundColor3 = Theme.Card,
            BackgroundTransparency = 0.25,
            Parent = parent,
            ZIndex = 6,
        })
        corner(6).Parent = frame

        create("TextLabel", {
            Text = "  " .. text,
            Size = UDim2.new(0.65, 0, 1, 0),
            TextColor3 = Theme.Text,
            Font = Enum.Font.Gotham,
            TextSize = 11,
            TextXAlignment = Enum.TextXAlignment.Left,
            BackgroundTransparency = 1,
            Parent = frame,
            ZIndex = 7,
        })

        local toggleBtn = create("TextButton", {
            Size = UDim2.new(0, 42, 0, 20),
            Position = UDim2.new(1, -48, 0.5, -10),
            Text = "OFF",
            BackgroundColor3 = Color3.fromRGB(45, 40, 60),
            TextColor3 = Theme.SubText,
            Font = Enum.Font.GothamBold,
            TextSize = 10,
            Parent = frame,
            ZIndex = 7,
        })
        corner(4).Parent = toggleBtn

        toggleBtn.MouseButton1Click:Connect(function()
            Flags[flag] = not Flags[flag]
            if Flags[flag] then
                toggleBtn.Text = "ON"
                toggleBtn.BackgroundColor3 = Theme.Accent
                toggleBtn.TextColor3 = Theme.Text
            else
                toggleBtn.Text = "OFF"
                toggleBtn.BackgroundColor3 = Color3.fromRGB(45, 40, 60)
                toggleBtn.TextColor3 = Theme.SubText
            end
            if callback then callback(Flags[flag]) end
        end)
    end

    local function createSingleClickToggle(parent, text, onAction)
        local frame = create("Frame", {
            Size = UDim2.new(1, -4, 0, 34),
            BackgroundColor3 = Theme.Card,
            BackgroundTransparency = 0.25,
            Parent = parent,
            ZIndex = 6,
        })
        corner(6).Parent = frame

        create("TextLabel", {
            Text = "  " .. text,
            Size = UDim2.new(0.65, 0, 1, 0),
            TextColor3 = Theme.Text,
            Font = Enum.Font.Gotham,
            TextSize = 11,
            TextXAlignment = Enum.TextXAlignment.Left,
            BackgroundTransparency = 1,
            Parent = frame,
            ZIndex = 7,
        })

        local actionBtn = create("TextButton", {
            Size = UDim2.new(0, 42, 0, 20),
            Position = UDim2.new(1, -48, 0.5, -10),
            Text = "OFF",
            BackgroundColor3 = Color3.fromRGB(45, 40, 60),
            TextColor3 = Theme.SubText,
            Font = Enum.Font.GothamBold,
            TextSize = 10,
            Parent = frame,
            ZIndex = 7,
        })
        corner(4).Parent = actionBtn

        local isOn = false
        actionBtn.MouseButton1Click:Connect(function()
            if not isOn then
                isOn = true
                actionBtn.Text = "ON"
                actionBtn.BackgroundColor3 = Theme.Accent
                actionBtn.TextColor3 = Theme.Text
                if onAction then onAction() end
            else
                isOn = false
                actionBtn.Text = ""
                actionBtn.BackgroundColor3 = Color3.fromRGB(45, 40, 60)
                actionBtn.TextColor3 = Theme.SubText
            end
        end)
    end

    local MainTab   = addTab(L.tabs.Main, "Main")
    local VisualTab = addTab(L.tabs.Visual, "Visual")
    local CombatTab = addTab(L.tabs.Combat, "Combat")
    local TeleTab   = addTab(L.tabs.Teleport, "Teleport")

    local ProfileCard = create("Frame", {
        Size = UDim2.new(1, -4, 0, 85),
        BackgroundColor3 = Theme.Card,
        BackgroundTransparency = 0.25,
        Parent = MainTab,
        ZIndex = 6,
    })
    corner(8).Parent = ProfileCard

    local AvatarImg = create("ImageLabel", {
        Size = UDim2.new(0, 60, 0, 60),
        Position = UDim2.new(0, 10, 0.5, -30),
        BackgroundColor3 = Color3.fromRGB(40, 35, 60),
        Parent = ProfileCard,
        ZIndex = 7,
    })
    corner(30).Parent = AvatarImg

    pcall(function()
        AvatarImg.Image = Players:GetUserThumbnailAsync(LocalPlayer.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size150x150)
    end)

    create("TextLabel", {
        Size = UDim2.new(1, -80, 0, 20),
        Position = UDim2.new(0, 78, 0, 16),
        Text = L.welcome .. ", " .. LocalPlayer.Name,
        TextColor3 = Theme.Text,
        Font = Enum.Font.GothamBold,
        TextSize = 13,
        TextXAlignment = Enum.TextXAlignment.Left,
        BackgroundTransparency = 1,
        Parent = ProfileCard,
        ZIndex = 7,
    })

    create("TextLabel", {
        Size = UDim2.new(1, -80, 0, 20),
        Position = UDim2.new(0, 78, 0, 38),
        Text = "@" .. LocalPlayer.Name .. " | ID: " .. LocalPlayer.UserId,
        TextColor3 = Theme.SubText,
        Font = Enum.Font.Gotham,
        TextSize = 10,
        TextXAlignment = Enum.TextXAlignment.Left,
        BackgroundTransparency = 1,
        Parent = ProfileCard,
        ZIndex = 7,
    })

    local DiscordCard = create("TextButton", {
        Size = UDim2.new(1, -4, 0, 38),
        BackgroundColor3 = Theme.Card,
        BackgroundTransparency = 0.25,
        Text = "",
        AutoButtonColor = false,
        Parent = MainTab,
        ZIndex = 6,
    })
    corner(8).Parent = DiscordCard

    create("TextLabel", {
        Size = UDim2.new(0, 30, 1, 0),
        Position = UDim2.new(0, 8, 0, 0),
        Text = "💬",
        TextSize = 14,
        BackgroundTransparency = 1,
        Parent = DiscordCard,
        ZIndex = 7,
    })

    local DiscordText = create("TextLabel", {
        Size = UDim2.new(1, -45, 1, 0),
        Position = UDim2.new(0, 38, 0, 0),
        Text = L.discordBtn,
        TextColor3 = Theme.Accent,
        Font = Enum.Font.GothamBold,
        TextSize = 11,
        TextXAlignment = Enum.TextXAlignment.Left,
        BackgroundTransparency = 1,
        Parent = DiscordCard,
        ZIndex = 7,
    })

    DiscordCard.MouseButton1Click:Connect(function()
        pcall(function()
            setclipboard("https://discord.gg/uguzhub")
            DiscordText.Text = L.discordCopied
            task.wait(1.5)
            DiscordText.Text = L.discordBtn
        end)
    end)

    createToggle(MainTab, L.autoFarm, "AutoFarm")

    local ModeBtn = create("TextButton", {
        Size = UDim2.new(1, -4, 0, 34),
        BackgroundColor3 = Theme.Card,
        BackgroundTransparency = 0.25,
        Text = L.farmModeTp,
        TextColor3 = Theme.Text,
        Font = Enum.Font.Gotham,
        TextSize = 11,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = MainTab,
        ZIndex = 6,
    })
    corner(6).Parent = ModeBtn
    ModeBtn.MouseButton1Click:Connect(function()
        if Flags.FarmMode == "Teleport" then
            Flags.FarmMode = "Tween"
            ModeBtn.Text = L.farmModeTween
        else
            Flags.FarmMode = "Teleport"
            ModeBtn.Text = L.farmModeTp
        end
    end)

    local KillAllBtn = create("TextButton", {
        Size = UDim2.new(1, -4, 0, 34),
        BackgroundColor3 = Color3.fromRGB(150, 40, 40),
        BackgroundTransparency = 0.2,
        Text = L.killAll,
        TextColor3 = Theme.Text,
        Font = Enum.Font.GothamBold,
        TextSize = 11,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = MainTab,
        ZIndex = 6,
    })
    corner(6).Parent = KillAllBtn
    KillAllBtn.MouseButton1Click:Connect(function()
        Flags.KillAllActive = true
        task.spawn(executeKillAll)
    end)

    createToggle(MainTab, L.speedWalk, "SpeedWalk")
    createToggle(MainTab, L.jumpPower, "JumpPower")
    createToggle(MainTab, L.infJump, "InfiniteJump")
    createToggle(MainTab, L.noclip, "Noclip")

    createToggle(VisualTab, L.espAll, "ESPAll")
    createToggle(VisualTab, L.espMur, "ESPMurderer")
    createToggle(VisualTab, L.espSher, "ESPSheriff")
    createToggle(VisualTab, L.espInno, "ESPInnocent")

    createToggle(CombatTab, L.aimbot, "AimbotEnabled")
    createToggle(CombatTab, L.autoShoot, "AutoShoot")
    createToggle(CombatTab, L.killAura, "KillAura")
    createToggle(CombatTab, L.autoGrab, "AutoGrabGun")
    createToggle(CombatTab, L.autoDrop, "AutoGunDropped")
    createToggle(CombatTab, L.sheriffFling, "SheriffFling")

    createSingleClickToggle(CombatTab, L.tpToDroppedGun, function()
        local gunDrop = Workspace:FindFirstChild("GunDrop", true)
        if gunDrop and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            LocalPlayer.Character.HumanoidRootPart.CFrame = gunDrop.CFrame
        end
    end)

    createToggle(CombatTab, L.shootBtnToggle, "ShootButtonEnabled", function(state)
        ShootActionButton.Visible = state
    end)

    createToggle(TeleTab, L.fullbright, "Fullbright")

    local function createTPButton(name, cf)
        local btn = create("TextButton", {
            Size = UDim2.new(1, -4, 0, 32),
            Text = name,
            Font = Enum.Font.GothamMedium,
            TextSize = 11,
            TextColor3 = Theme.Text,
            TextXAlignment = Enum.TextXAlignment.Left,
            BackgroundColor3 = Theme.Card,
            BackgroundTransparency = 0.25,
            Parent = TeleTab,
            ZIndex = 6,
        })
        corner(6).Parent = btn
        
        btn.MouseButton1Click:Connect(function()
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                LocalPlayer.Character.HumanoidRootPart.CFrame = cf
            end
        end)
    end

    createTPButton(L.tpLobby, CFrame.new(110, 138, -12))
    createTPButton(L.tpMap, CFrame.new(0, 50, 0))

    pages["Main"].Visible = true
    tabBtns["Main"].BackgroundColor3 = Theme.Card
    tabBtns["Main"].TextColor3 = Theme.Accent

    local dragging, dragStart, startPos
    Header.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = MainFrame.Position
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + (input.Position.X - dragStart.X), startPos.Y.Scale, startPos.Y.Offset + (input.Position.Y - dragStart.Y))
        end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then 
            dragging = false 
        end
    end)
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

MinimizedButton.MouseButton1Click:Connect(function()
    if not MainFrame then return end
    openMenu()
end)
