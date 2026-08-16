--[[
    ================================================================
    UguzHub V2 Pro - FULL EDITION (PARÇA 1/3)
    ----------------------------------------------------------------
    - Sistem Hizmetleri ve Değişken Tanımlamaları
    - Dil Paketleri (TR, EN, RU, DE - Eksiksiz Metinler)
    - Oyun İçi Rol Tespiti (Murderer, Sheriff, Innocent)
    - Savaş ve Saldırı Fonksiyonları (KillAll, AutoShoot)
    - Anti-AFK ve Arka Plan Döngüleri (AutoFarm Speed: 17)
    ================================================================
]]

-- Roblox Servisleri
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local Lighting = game:GetService("Lighting")
local VirtualUser = game:GetService("VirtualUser")

-- Oyuncu ve Kamera Tanımlamaları
local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera

----------------------------------------------------------------
-- 1. ESKİ ARAYÜZ TEMİZLİĞİ
----------------------------------------------------------------
if CoreGui:FindFirstChild("UguzHubV2Pro") then 
    CoreGui.UguzHubV2Pro:Destroy() 
end

----------------------------------------------------------------
-- 2. GLOBAL SİSTEM BAYRAKLARI (FLAGS)
----------------------------------------------------------------
local Flags = {
    -- Oyuncu Hareket Ayarları
    SpeedWalk = false,
    SpeedValue = 24,
    JumpPower = false,
    JumpValue = 75,
    InfiniteJump = false,
    Noclip = false,
    
    -- Görsel Ayarlar (ESP)
    ESPAll = false,
    ESPMurderer = false,
    ESPSheriff = false,
    ESPInnocent = false,
    Fullbright = false,
    
    -- Crosshair Seçenekleri
    CrosshairCircle = false,
    CrosshairHeart = false,
    CrosshairDot = false,
    
    -- Savaş ve Otomasyon Ayarları
    AimbotEnabled = false,
    AutoShoot = false,
    KillAura = false,
    AutoGrabGun = false,
    AutoGunDropped = false,
    SheriffFling = false,
    
    -- Ekran Üzeri Taşınabilir Butonlar
    ShootButtonEnabled = false,
    AimbotBtnEnabled = false,
    NoclipBtnEnabled = false,
    
    -- Otomatik Çiftlik ve Tarama
    AutoFarm = false,
    FarmMode = "Tween",
    FarmSpeed = 17, -- Sabit Farm Hızı
    KillAllActive = false,
    
    -- Genel Araçlar
    AntiAFK = true
}

----------------------------------------------------------------
-- 3. TEMA VE GÖRSEL KONFİGÜRASYON
----------------------------------------------------------------
local Theme = {
    Background = Color3.fromRGB(18, 16, 26),
    Sidebar    = Color3.fromRGB(24, 21, 35),
    Card       = Color3.fromRGB(32, 28, 48),
    Accent     = Color3.fromRGB(168, 85, 247),
    AccentSoft = Color3.fromRGB(90, 60, 180),
    Text       = Color3.fromRGB(240, 240, 245),
    SubText    = Color3.fromRGB(160, 155, 180),
    Stroke     = Color3.fromRGB(147, 51, 234),
    Success    = Color3.fromRGB(34, 197, 94),
    Danger     = Color3.fromRGB(239, 68, 68)
}

local RADIUS = 14

----------------------------------------------------------------
-- 4. ÇOKLU DİL PAKETLERİ (4 DİL - TAM METİN)
----------------------------------------------------------------
local Lang = {}

-- TÜRKÇE DİL PAKETİ
Lang.TR = {
    loading = "Yükleniyor",
    subtitle = "Dilinizi seçin",
    openBtn = "UguzHub",
    notice = "Sizlere daha iyi bir deneyim sunmak amacıyla lütfen delta ayarlarindaki tüm izinleri Kapattığınıza emin olun.",
    title = "  Murder Mystery 2 | UguzHub V2 Pro",
    tabs = { 
        Main = "Ana Menü", 
        Visual = "Görsel", 
        Combat = "Savaş", 
        Teleport = "Işınlanma" 
    },
    welcome = "Hoşgeldin",
    discordBtn = "Discord: discord.gg/uguzhub (Tıkla Kopyala)",
    discordCopied = "Discord Linki Kopyalandı!",
    autoFarm = "Auto Farm (Coin Topla)",
    farmModeTp = "  Farm Modu: Teleport",
    farmModeTween = "  Farm Modu: Tween (Hız: 17)",
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
    shootBtnToggle = "Ekran Butonu: Katili Vur",
    aimbotBtnToggle = "Ekran Butonu: Aimbot Toggle",
    noclipBtnToggle = "Ekran Butonu: Noclip Toggle",
    sheriffFling = "Sheriff Fling (Şerif Fırlat)",
    tpToDroppedGun = "Düşen Silaha Işınlan",
    fullbright = "Fullbright (Aydınlık)",
    antiAfk = "Anti-AFK Koruması",
    crossCircle = "Crosshair: Renkli Çember",
    crossHeart = "Crosshair: Kalp İkonu",
    crossDot = "Crosshair: Beyaz Nokta",
    tpLobby = "  Lobiye Git",
    tpMap = "  Harita Ortasına Git",
    shootBtnText = "🎯 Katili Vur"
}

-- İNGİLİZCE DİL PAKETİ
Lang.EN = {
    loading = "Loading",
    subtitle = "Select your language",
    openBtn = "UguzHub",
    notice = "To provide you with a better experience, please make sure to turn off all permissions in the delta settings.",
    title = "  Murder Mystery 2 | UguzHub V2 Pro",
    tabs = { 
        Main = "Main", 
        Visual = "Visual", 
        Combat = "Combat", 
        Teleport = "Teleport" 
    },
    welcome = "Welcome",
    discordBtn = "Discord: discord.gg/uguzhub (Click to Copy)",
    discordCopied = "Discord Link Copied!",
    autoFarm = "Auto Farm (Coins)",
    farmModeTp = "  Farm Mode: Teleport",
    farmModeTween = "  Farm Mode: Tween (Speed: 17)",
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
    shootBtnToggle = "Screen Button: Shoot Murderer",
    aimbotBtnToggle = "Screen Button: Aimbot Toggle",
    noclipBtnToggle = "Screen Button: Noclip Toggle",
    sheriffFling = "Sheriff Fling",
    tpToDroppedGun = "TP to Dropped Gun",
    fullbright = "Fullbright",
    antiAfk = "Anti-AFK Protection",
    crossCircle = "Crosshair: Colored Circle",
    crossHeart = "Crosshair: Heart Icon",
    crossDot = "Crosshair: White Dot",
    tpLobby = "  Teleport to Lobby",
    tpMap = "  Teleport to Map Center",
    shootBtnText = "🎯 Shoot Murderer"
}

-- RUSÇA DİL PAKETİ
Lang.RU = {
    loading = "Загрузка",
    subtitle = "Выберите язык",
    openBtn = "UguzHub",
    notice = "Чтобы обеспечить вам лучший опыт, пожалуйста, убедитесь, что отключили все разрешения в настройках delta.",
    title = "  Murder Mystery 2 | UguzHub V2 Pro",
    tabs = { 
        Main = "Главное", 
        Visual = "Визуал", 
        Combat = "Бой", 
        Teleport = "Телепорт" 
    },
    welcome = "Добро пожаловать",
    discordBtn = "Discord: discord.gg/uguzhub (Нажмите для копирования)",
    discordCopied = "Ссылка Discord скопирована!",
    autoFarm = "Авто Фарм (Монеты)",
    farmModeTp = "  Режим Фарма: Телепорт",
    farmModeTween = "  Режим Фарма: Плавный (Скорость: 17)",
    killAll = "  Убить Всех Игроков",
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
    shootBtnToggle = "Экранная Кнопка: Убить Убийцу",
    aimbotBtnToggle = "Экранная Кнопка: Аимбот",
    noclipBtnToggle = "Экранная Кнопка: Ноклип",
    sheriffFling = "Флинг Шерифа",
    tpToDroppedGun = "ТП к Выпавшей Пушке",
    fullbright = "Яркое Освещение",
    antiAfk = "Защита от AFK",
    crossCircle = "Прицел: Цвеной Круг",
    crossHeart = "Прицел: Сердечко",
    crossDot = "Прицел: Белая Точка",
    tpLobby = "  Телепорт в Лобби",
    tpMap = "  Телепорт в Центр Карты",
    shootBtnText = "🎯 Убить Убийцу"
}

-- ALMANCA DİL PAKETİ
Lang.DE = {
    loading = "Wird geladen",
    subtitle = "Wähle deine Sprache",
    openBtn = "UguzHub",
    notice = "Um Ihnen ein besseres Erlebnis zu bieten, stellen Sie bitte sicher, dass Sie alle Berechtigungen in den Delta-Einstellungen deaktivieren.",
    title = "  Murder Mystery 2 | UguzHub V2 Pro",
    tabs = { 
        Main = "Haupt", 
        Visual = "Visuell", 
        Combat = "Kampf", 
        Teleport = "Teleport" 
    },
    welcome = "Willkommen",
    discordBtn = "Discord: discord.gg/uguzhub (Klicken zum Kopieren)",
    discordCopied = "Discord Link kopiert!",
    autoFarm = "Auto-Farm (Münzen)",
    farmModeTp = "  Farm-Modus: Teleport",
    farmModeTween = "  Farm-Modus: Tween (Geschwindigkeit: 17)",
    killAll = "  Alle Spieler Töten",
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
    shootBtnToggle = "Bildschirm-Button: Mörder Schießen",
    aimbotBtnToggle = "Bildschirm-Button: Aimbot",
    noclipBtnToggle = "Bildschirm-Button: Noclip",
    sheriffFling = "Sheriff Fling",
    tpToDroppedGun = "TP zur Gelandeten Waffe",
    fullbright = "Helles Licht",
    antiAfk = "Anti-AFK Schutz",
    crossCircle = "Fadenkreuz: Farbiger Kreis",
    crossHeart = "Fadenkreuz: Herz-Icon",
    crossDot = "Fadenkreuz: Weißer Punkt",
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

local CurrentLang = "TR"
local L = Lang[CurrentLang]

----------------------------------------------------------------
-- 5. OYUN MEKANİKLERİ VE ROL TESPİTİ
----------------------------------------------------------------
local function getRole(plr)
    if not plr or not plr.Character then 
        return "Innocent" 
    end
    
    local char = plr.Character
    local backpack = plr:FindFirstChild("Backpack")
    
    if (char:FindFirstChild("Knife") or (backpack and backpack:FindFirstChild("Knife"))) then 
        return "Murderer" 
    elseif (char:FindFirstChild("Gun") or (backpack and backpack:FindFirstChild("Gun"))) then 
        return "Sheriff" 
    end
    
    return "Innocent"
end

----------------------------------------------------------------
-- 6. KATLİAM VE ATEN SİSTEMİ (KILL ALL & SHOOT)
----------------------------------------------------------------
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

----------------------------------------------------------------
-- 7. ANTI-AFK KORUMASI
----------------------------------------------------------------
LocalPlayer.Idled:Connect(function()
    if Flags.AntiAFK then
        VirtualUser:CaptureController()
        VirtualUser:ClickButton2(Vector2.new())
    end
end)

----------------------------------------------------------------
-- 8. ARKA PLAN OTOMASYON DÖNGÜLERİ (LOOPS)
----------------------------------------------------------------
-- AutoFarm Döngüsü (Hız Tam Olarak 17)
task.spawn(function()
    while task.wait(0.1) do
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
                                local speed = Flags.FarmSpeed
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
                            
                            task.wait(0.05)
                            break
                        end
                    end
                end
            end)
        end
    end
end)
--[[
    ================================================================
    UguzHub V2 Pro - FULL EDITION (PARÇA 2/3)
    ----------------------------------------------------------------
    - Yardımcı Savaş Döngüleri (AutoShoot, AutoGrab, KillAura)
    - Oyuncu Hareket ve Fizik Yönetimi (Speed, Jump, Noclip)
    - ESP (Görsel Tarama) ve Aimbot Sistemleri
    - Bildirim Sistemleri ve Arayüz Temelleri
    ================================================================
]]

----------------------------------------------------------------
-- 9. SAVAŞ VE YARDIMCI OTOMASYON DÖNGÜLERİ
----------------------------------------------------------------

-- Otomatik Şerif Ateş Etme Döngüsü
task.spawn(function()
    while task.wait(0.1) do
        if Flags.AutoShoot then
            pcall(function()
                if getRole(LocalPlayer) == "Sheriff" then
                    shootMurdererOnce()
                end
            end)
        end
    end
end)

-- Yerden Otomatik Silah Toplama Döngüsü
task.spawn(function()
    while task.wait(0.5) do
        if Flags.AutoGrabGun then
            pcall(function()
                local gunDrop = Workspace:FindFirstChild("GunDrop") or Workspace:FindFirstChild("Gun")
                local root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                if gunDrop and root then
                    root.CFrame = gunDrop.CFrame
                end
            end)
        end
    end
end)

-- Otomatik Silah Düşürme Döngüsü
task.spawn(function()
    while task.wait(0.5) do
        if Flags.AutoGunDropped then
            pcall(function()
                local char = LocalPlayer.Character
                local gun = char and char:FindFirstChild("Gun")
                if gun then
                    gun.Parent = Workspace
                end
            end)
        end
    end
end)

-- Yakın Mesafe Otomatik Bıçaklama (KillAura)
task.spawn(function()
    while task.wait(0.1) do
        if Flags.KillAura then
            pcall(function()
                local char = LocalPlayer.Character
                local knife = char and (char:FindFirstChild("Knife") or (LocalPlayer:FindFirstChild("Backpack") and LocalPlayer.Backpack:FindFirstChild("Knife")))
                
                if knife then
                    knife.Parent = char
                    local knifeHandle = knife:FindFirstChild("Handle") or knife:FindFirstChildWhichIsA("BasePart")
                    
                    for _, target in pairs(Players:GetPlayers()) do
                        if target ~= LocalPlayer and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
                            local targetHrp = target.Character.HumanoidRootPart
                            local dist = (char.HumanoidRootPart.Position - targetHrp.Position).Magnitude
                            
                            if dist < 15 then
                                if firetouchinterest and knifeHandle then
                                    firetouchinterest(knifeHandle, targetHrp, 0)
                                    firetouchinterest(knifeHandle, targetHrp, 1)
                                end
                                knife:Activate()
                            end
                        end
                    end
                end
            end)
        end
    end
end)

-- Şerif Fırlatma (Sheriff Fling) Döngüsü
task.spawn(function()
    while task.wait(0.1) do
        if Flags.SheriffFling then
            pcall(function()
                local sheriff = nil
                for _, p in pairs(Players:GetPlayers()) do
                    if p ~= LocalPlayer and getRole(p) == "Sheriff" and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                        sheriff = p.Character.HumanoidRootPart
                        break
                    end
                end
                
                if sheriff and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                    local hrp = LocalPlayer.Character.HumanoidRootPart
                    local bfv = Instance.new("BodyAngularVelocity")
                    bfv.AngularVelocity = Vector3.new(0, 99999, 0)
                    bfv.MaxTorque = Vector3.new(0, math.huge, 0)
                    bfv.Parent = hrp
                    
                    hrp.CFrame = sheriff.CFrame
                    task.wait(0.2)
                    bfv:Destroy()
                end
            end)
        end
    end
end)

----------------------------------------------------------------
-- 10. OYUN SÜRÜCÜSÜ VE HAREKET EVENTLERİ
----------------------------------------------------------------

-- Hız, Zıplama Gücü ve Noclip Güncellemeleri
RunService.Stepped:Connect(function()
    pcall(function()
        local char = LocalPlayer.Character
        if char then
            local hum = char:FindFirstChildOfClass("Humanoid")
            if hum then
                if Flags.SpeedWalk then 
                    hum.WalkSpeed = Flags.SpeedValue 
                end
                if Flags.JumpPower then 
                    hum.JumpPower = Flags.JumpValue 
                end
            end
            
            if Flags.Noclip then
                for _, part in pairs(char:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = false
                    end
                end
            end
        end
    end)
end)

-- Sınırsız Zıplama (Infinite Jump)
UserInputService.JumpRequest:Connect(function()
    if Flags.InfiniteJump then
        pcall(function()
            local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            if hum then
                hum:ChangeState(Enum.HumanoidStateType.Jumping)
            end
        end)
    end
end)

-- Aydınlatma (Fullbright) Güncellemesi
RunService.RenderStepped:Connect(function()
    if Flags.Fullbright then
        Lighting.Ambient = Color3.fromRGB(255, 255, 255)
        Lighting.Brightness = 2
        Lighting.GlobalShadows = false
    end
end)

----------------------------------------------------------------
-- 11. ESP (GÖRSEL TARAMA) SİSTEMİ
----------------------------------------------------------------
local function clearESP()
    for _, p in pairs(Players:GetPlayers()) do
        if p.Character and p.Character:FindFirstChild("UguzESP") then
            p.Character.UguzESP:Destroy()
        end
    end
end

RunService.RenderStepped:Connect(function()
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
            local role = getRole(p)
            local shouldDraw = false
            local color = Color3.fromRGB(255, 255, 255)
            
            if Flags.ESPAll then
                shouldDraw = true
                if role == "Murderer" then 
                    color = Color3.fromRGB(255, 50, 50)
                elseif role == "Sheriff" then 
                    color = Color3.fromRGB(50, 150, 255)
                else 
                    color = Color3.fromRGB(50, 255, 100) 
                end
            elseif Flags.ESPMurderer and role == "Murderer" then
                shouldDraw = true
                color = Color3.fromRGB(255, 50, 50)
            elseif Flags.ESPSheriff and role == "Sheriff" then
                shouldDraw = true
                color = Color3.fromRGB(50, 150, 255)
            elseif Flags.ESPInnocent and role == "Innocent" then
                shouldDraw = true
                color = Color3.fromRGB(50, 255, 100)
            end
            
            local hl = p.Character:FindFirstChild("UguzESP")
            if shouldDraw then
                if not hl then
                    hl = Instance.new("Highlight")
                    hl.Name = "UguzESP"
                    hl.Parent = p.Character
                end
                hl.FillColor = color
                hl.OutlineColor = Color3.fromRGB(255, 255, 255)
                hl.FillTransparency = 0.5
            else
                if hl then 
                    hl:Destroy() 
                end
            end
        end
    end
end)

----------------------------------------------------------------
-- 12. AIMBOT (OTOMATİK ODAKLANMA) SİSTEMİ
----------------------------------------------------------------
RunService.RenderStepped:Connect(function()
    if Flags.AimbotEnabled then
        local murderer = nil
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and getRole(p) == "Murderer" and p.Character and p.Character:FindFirstChild("Head") then
                murderer = p.Character.Head
                break
            end
        end
        if murderer then
            Camera.CFrame = CFrame.new(Camera.CFrame.Position, murderer.Position)
        end
    end
end)

----------------------------------------------------------------
-- 13. KULLANICI ARAYÜZÜ (UI CORE & BİLDİRİMLER)
----------------------------------------------------------------
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "UguzHubV2Pro"
ScreenGui.ResetOnSpawn = false

pcall(function() 
    ScreenGui.Parent = CoreGui 
end)

-- Bildirim Paneli Tasarımı
local NotifyFrame = Instance.new("Frame")
NotifyFrame.Size = UDim2.new(0, 250, 0, 40)
NotifyFrame.Position = UDim2.new(0.5, -125, 0.05, 0)
NotifyFrame.BackgroundColor3 = Theme.Card
NotifyFrame.BorderSizePixel = 0
NotifyFrame.Visible = false
NotifyFrame.Parent = ScreenGui

local NotifyCorner = Instance.new("UICorner")
NotifyCorner.CornerRadius = UDim.new(0, 8)
NotifyCorner.Parent = NotifyFrame

local NotifyStroke = Instance.new("UIStroke")
NotifyStroke.Color = Theme.Stroke
NotifyStroke.Thickness = 1.5
NotifyStroke.Parent = NotifyFrame

local NotifyText = Instance.new("TextLabel")
NotifyText.Size = UDim2.new(1, 0, 1, 0)
NotifyText.BackgroundTransparency = 1
NotifyText.Font = Enum.Font.GothamBold
NotifyText.TextColor3 = Theme.Text
NotifyText.TextSize = 13
NotifyText.Text = ""
NotifyText.Parent = NotifyFrame

local function sendNotification(msg)
    NotifyText.Text = msg
    NotifyFrame.Visible = true
    task.delay(2.5, function()
        NotifyFrame.Visible = false
    end)
end
--[[
    ================================================================
    UguzHub V2 Pro - FULL EDITION (PARÇA 3/3)
    ----------------------------------------------------------------
    - Ana Arayüz Penceresi ve Sekme Mimarisi
    - UI Bileşen Üreteçleri (Toggle, Button, Slider)
    - Ekran Üzeri Taşınabilir Butonlar (Overlay Buttons)
    - Dil Seçim Ekranı ve Script Başlatıcı
    ================================================================
]]

----------------------------------------------------------------
-- 14. ANA PENCERE VE TAB İÇERİK YAPISI
----------------------------------------------------------------

-- Dil Seçim Çerçevesi (Splash Screen)
local LangFrame = Instance.new("Frame")
LangFrame.Size = UDim2.new(0, 320, 0, 360)
LangFrame.Position = UDim2.new(0.5, -160, 0.5, -180)
LangFrame.BackgroundColor3 = Theme.Background
LangFrame.BorderSizePixel = 0
LangFrame.Active = true
LangFrame.Draggable = true
LangFrame.Parent = ScreenGui

local LangCorner = Instance.new("UICorner")
LangCorner.CornerRadius = UDim.new(0, RADIUS)
LangCorner.Parent = LangFrame

local LangStroke = Instance.new("UIStroke")
LangStroke.Color = Theme.Stroke
LangStroke.Thickness = 2
LangStroke.Parent = LangFrame

local LangTitle = Instance.new("TextLabel")
LangTitle.Size = UDim2.new(1, 0, 0, 45)
LangTitle.BackgroundTransparency = 1
LangTitle.Font = Enum.Font.GothamBold
LangTitle.Text = "UguzHub V2 Pro"
LangTitle.TextColor3 = Theme.Accent
LangTitle.TextSize = 20
LangTitle.Parent = LangFrame

local LangSub = Instance.new("TextLabel")
LangSub.Size = UDim2.new(1, -20, 0, 20)
LangSub.Position = UDim2.new(0, 10, 0, 40)
LangSub.BackgroundTransparency = 1
LangSub.Font = Enum.Font.Gotham
LangSub.Text = "Select Language / Dil Seçin"
LangSub.TextColor3 = Theme.SubText
LangSub.TextSize = 13
LangSub.Parent = LangFrame

local LangContainer = Instance.new("Frame")
LangContainer.Size = UDim2.new(1, -30, 0, 260)
LangContainer.Position = UDim2.new(0, 15, 0, 75)
LangContainer.BackgroundTransparency = 1
LangContainer.Parent = LangFrame

local LangLayout = Instance.new("UIListLayout")
LangLayout.SortOrder = Enum.SortOrder.LayoutOrder
LangLayout.Padding = UDim.new(0, 10)
LangLayout.Parent = LangContainer

-- Ana Menü Penceresi
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 620, 0, 420)
MainFrame.Position = UDim2.new(0.5, -310, 0.5, -210)
MainFrame.BackgroundColor3 = Theme.Background
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Visible = false
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, RADIUS)
MainCorner.Parent = MainFrame

local MainStroke = Instance.new("UIStroke")
MainStroke.Color = Theme.Stroke
MainStroke.Thickness = 2
MainStroke.Parent = MainFrame

-- Başlık Çubuğu
local TitleBar = Instance.new("Frame")
TitleBar.Size = UDim2.new(1, 0, 0, 45)
TitleBar.BackgroundColor3 = Theme.Sidebar
TitleBar.BorderSizePixel = 0
TitleBar.Parent = MainFrame

local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, RADIUS)
TitleCorner.Parent = TitleBar

local TitleText = Instance.new("TextLabel")
TitleText.Size = UDim2.new(1, -50, 1, 0)
TitleText.Position = UDim2.new(0, 15, 0, 0)
TitleText.BackgroundTransparency = 1
TitleText.Font = Enum.Font.GothamBold
TitleText.Text = "UguzHub V2 Pro"
TitleText.TextColor3 = Theme.Text
TitleText.TextSize = 15
TitleText.TextXAlignment = Enum.TextXAlignment.Left
TitleText.Parent = TitleBar

-- Kapatma Butonu
local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 30, 0, 30)
CloseBtn.Position = UDim2.new(1, -38, 0, 7)
CloseBtn.BackgroundColor3 = Theme.Card
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.Text = "X"
CloseBtn.TextColor3 = Theme.Danger
CloseBtn.TextSize = 14
CloseBtn.Parent = TitleBar

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 6)
CloseCorner.Parent = CloseBtn

CloseBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = false
end)

-- Sol Yan Panel (Sidebar)
local Sidebar = Instance.new("Frame")
Sidebar.Size = UDim2.new(0, 150, 1, -55)
Sidebar.Position = UDim2.new(0, 10, 0, 50)
Sidebar.BackgroundColor3 = Theme.Sidebar
Sidebar.BorderSizePixel = 0
Sidebar.Parent = MainFrame

local SideCorner = Instance.new("UICorner")
SideCorner.CornerRadius = UDim.new(0, 10)
SideCorner.Parent = Sidebar

local TabBtnContainer = Instance.new("Frame")
TabBtnContainer.Size = UDim2.new(1, -10, 1, -10)
TabBtnContainer.Position = UDim2.new(0, 5, 0, 5)
TabBtnContainer.BackgroundTransparency = 1
TabBtnContainer.Parent = Sidebar

local TabBtnLayout = Instance.new("UIListLayout")
TabBtnLayout.SortOrder = Enum.SortOrder.LayoutOrder
TabBtnLayout.Padding = UDim.new(0, 6)
TabBtnLayout.Parent = TabBtnContainer

-- Sekme İçerik Alanı (Content Area)
local ContentArea = Instance.new("Frame")
ContentArea.Size = UDim2.new(1, -180, 1, -55)
ContentArea.Position = UDim2.new(0, 170, 0, 50)
ContentArea.BackgroundTransparency = 1
ContentArea.Parent = MainFrame

local Tabs = {}

local function createTabContainer(name)
    local scroll = Instance.new("ScrollingFrame")
    scroll.Size = UDim2.new(1, 0, 1, 0)
    scroll.BackgroundTransparency = 1
    scroll.BorderSizePixel = 0
    scroll.ScrollBarThickness = 4
    scroll.ScrollBarImageColor3 = Theme.Accent
    scroll.Visible = false
    scroll.Parent = ContentArea

    local layout = Instance.new("UIListLayout")
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Padding = UDim.new(0, 8)
    layout.Parent = scroll

    Tabs[name] = scroll
    return scroll
end

local mainTab     = createTabContainer("Main")
local visualTab   = createTabContainer("Visual")
local combatTab   = createTabContainer("Combat")
local teleportTab = createTabContainer("Teleport")

local function switchTab(tabName)
    for name, container in pairs(Tabs) do
        container.Visible = (name == tabName)
    end
end

----------------------------------------------------------------
-- 15. ARAYÜZ BİLEŞEN ÜRETEÇLERİ (UI HELPER FUNCTIONS)
----------------------------------------------------------------

local function createButton(parent, text, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -10, 0, 38)
    btn.BackgroundColor3 = Theme.Card
    btn.Font = Enum.Font.GothamBold
    btn.Text = text
    btn.TextColor3 = Theme.Text
    btn.TextSize = 12
    btn.Parent = parent

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = btn

    local stroke = Instance.new("UIStroke")
    stroke.Color = Theme.Stroke
    stroke.Thickness = 1
    stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    stroke.Parent = btn

    btn.MouseButton1Click:Connect(function()
        if callback then callback() end
    end)

    return btn
end

local function createToggle(parent, text, flagName, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, -10, 0, 38)
    frame.BackgroundColor3 = Theme.Card
    frame.Parent = parent

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = frame

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -60, 1, 0)
    label.Position = UDim2.new(0, 10, 0, 0)
    label.BackgroundTransparency = 1
    label.Font = Enum.Font.Gotham
    label.Text = text
    label.TextColor3 = Theme.Text
    label.TextSize = 12
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = frame

    local toggleBtn = Instance.new("TextButton")
    toggleBtn.Size = UDim2.new(0, 40, 0, 22)
    toggleBtn.Position = UDim2.new(1, -50, 0.5, -11)
    toggleBtn.BackgroundColor3 = Flags[flagName] and Theme.Success or Theme.Sidebar
    toggleBtn.Text = ""
    toggleBtn.Parent = frame

    local toggleCorner = Instance.new("UICorner")
    toggleCorner.CornerRadius = UDim.new(1, 0)
    toggleCorner.Parent = toggleBtn

    toggleBtn.MouseButton1Click:Connect(function()
        Flags[flagName] = not Flags[flagName]
        toggleBtn.BackgroundColor3 = Flags[flagName] and Theme.Success or Theme.Sidebar
        if callback then callback(Flags[flagName]) end
    end)

    return frame
end

local function createSlider(parent, text, minVal, maxVal, defaultVal, flagName)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, -10, 0, 50)
    frame.BackgroundColor3 = Theme.Card
    frame.Parent = parent

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = frame

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -20, 0, 20)
    label.Position = UDim2.new(0, 10, 0, 5)
    label.BackgroundTransparency = 1
    label.Font = Enum.Font.Gotham
    label.Text = text .. ": " .. tostring(defaultVal)
    label.TextColor3 = Theme.Text
    label.TextSize = 12
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = frame

    local sliderBg = Instance.new("Frame")
    sliderBg.Size = UDim2.new(1, -20, 0, 8)
    sliderBg.Position = UDim2.new(0, 10, 0, 30)
    sliderBg.BackgroundColor3 = Theme.Sidebar
    sliderBg.Parent = frame

    local sliderBgCorner = Instance.new("UICorner")
    sliderBgCorner.CornerRadius = UDim.new(1, 0)
    sliderBgCorner.Parent = sliderBg

    local fill = Instance.new("Frame")
    fill.Size = UDim2.new((defaultVal - minVal) / (maxVal - minVal), 0, 1, 0)
    fill.BackgroundColor3 = Theme.Accent
    fill.Parent = sliderBg

    local fillCorner = Instance.new("UICorner")
    fillCorner.CornerRadius = UDim.new(1, 0)
    fillCorner.Parent = fill

    local dragging = false

    local function update(input)
        local pos = math.clamp((input.Position.X - sliderBg.AbsolutePosition.X) / sliderBg.AbsoluteSize.X, 0, 1)
        local value = math.floor(minVal + (maxVal - minVal) * pos)
        fill.Size = UDim2.new(pos, 0, 1, 0)
        Flags[flagName] = value
        label.Text = text .. ": " .. tostring(value)
    end

    sliderBg.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            update(input)
        end
    end)

    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            update(input)
        end
    end)

    return frame
end

----------------------------------------------------------------
-- 16. EKRAN ÜZERİ TAŞINABİLİR BUTONLAR (OVERLAY BUTTONS)
----------------------------------------------------------------
local function createOverlayButton(text, flagName, onClick)
    local btnFrame = Instance.new("Frame")
    btnFrame.Size = UDim2.new(0, 130, 0, 40)
    btnFrame.Position = UDim2.new(0.8, 0, 0.3, 0)
    btnFrame.BackgroundColor3 = Theme.Card
    btnFrame.BorderSizePixel = 0
    btnFrame.Active = true
    btnFrame.Draggable = true
    btnFrame.Visible = false
    btnFrame.Parent = ScreenGui

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = btnFrame

    local stroke = Instance.new("UIStroke")
    stroke.Color = Theme.Accent
    stroke.Thickness = 1.5
    stroke.Parent = btnFrame

    local actionBtn = Instance.new("TextButton")
    actionBtn.Size = UDim2.new(1, 0, 1, 0)
    actionBtn.BackgroundTransparency = 1
    actionBtn.Font = Enum.Font.GothamBold
    actionBtn.Text = text
    actionBtn.TextColor3 = Theme.Text
    actionBtn.TextSize = 12
    actionBtn.Parent = btnFrame

    actionBtn.MouseButton1Click:Connect(function()
        if onClick then onClick() end
    end)

    return btnFrame
end

local shootOverlayBtn = createOverlayButton("🎯 Katili Vur", "ShootButtonEnabled", function()
    shootMurdererOnce()
end)

local aimbotOverlayBtn = createOverlayButton("🎯 Aimbot: KAPALI", "AimbotBtnEnabled", function()
    Flags.AimbotEnabled = not Flags.AimbotEnabled
    aimbotOverlayBtn:FindFirstChildOfClass("TextButton").Text = Flags.AimbotEnabled and "🎯 Aimbot: AÇIK" or "🎯 Aimbot: KAPALI"
end)

local noclipOverlayBtn = createOverlayButton("👻 Noclip: KAPALI", "NoclipBtnEnabled", function()
    Flags.Noclip = not Flags.Noclip
    noclipOverlayBtn:FindFirstChildOfClass("TextButton").Text = Flags.Noclip and "👻 Noclip: AÇIK" or "👻 Noclip: KAPALI"
end)

----------------------------------------------------------------
-- 17. MENÜ VE SEKMELERİN İÇERİĞİNİ YÜKLEME SİSTEMİ
----------------------------------------------------------------
local function buildMainInterface()
    -- Eski sekmelerdeki içerikleri temizle
    for _, tab in pairs(Tabs) do
        for _, child in pairs(tab:GetChildren()) do
            if not child:IsA("UIListLayout") then
                child:Destroy()
            end
        end
    end
    for _, child in pairs(TabBtnContainer:GetChildren()) do
        if not child:IsA("UIListLayout") then
            child:Destroy()
        end
    end

    -- Sekme Butonlarını Yeniden Oluştur
    for tabKey, tabName in pairs(L.tabs) do
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(1, 0, 0, 36)
        btn.BackgroundColor3 = Theme.Card
        btn.Font = Enum.Font.GothamBold
        btn.Text = tabName
        btn.TextColor3 = Theme.Text
        btn.TextSize = 13
        btn.Parent = TabBtnContainer

        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(0, 8)
        corner.Parent = btn

        btn.MouseButton1Click:Connect(function()
            switchTab(tabKey)
        end)
    end

    ------------------------------------------------------------
    -- 1. MAIN TAB (ANA MENÜ)
    ------------------------------------------------------------
    createButton(mainTab, L.discordBtn, function()
        pcall(function()
            setclipboard("https://discord.gg/uguzhub")
            sendNotification(L.discordCopied)
        end)
    end)

    createToggle(mainTab, L.autoFarm, "AutoFarm")
    
    createButton(mainTab, L.farmModeTween, function()
        Flags.FarmMode = "Tween"
        sendNotification("Farm Modu: Tween (Hız: 17)")
    end)
    
    createButton(mainTab, L.farmModeTp, function()
        Flags.FarmMode = "TP"
        sendNotification("Farm Modu: Teleport")
    end)

    createButton(mainTab, L.killAll, function()
        Flags.KillAllActive = true
        executeKillAll()
    end)

    createToggle(mainTab, L.speedWalk, "SpeedWalk")
    createSlider(mainTab, "Hız Ayarı (Speed)", 16, 100, Flags.SpeedValue, "SpeedValue")

    createToggle(mainTab, L.jumpPower, "JumpPower")
    createSlider(mainTab, "Zıplama Ayarı (Jump)", 50, 200, Flags.JumpValue, "JumpValue")

    createToggle(mainTab, L.infJump, "InfiniteJump")
    createToggle(mainTab, L.noclip, "Noclip")
    createToggle(mainTab, L.antiAfk, "AntiAFK")

    ------------------------------------------------------------
    -- 2. VISUAL TAB (GÖRSEL)
    ------------------------------------------------------------
    createToggle(visualTab, L.espAll, "ESPAll")
    createToggle(visualTab, L.espMur, "ESPMurderer")
    createToggle(visualTab, L.espSher, "ESPSheriff")
    createToggle(visualTab, L.espInno, "ESPInnocent")
    createToggle(visualTab, L.fullbright, "Fullbright")

    ------------------------------------------------------------
    -- 3. COMBAT TAB (SAVAŞ & BUTONLAR)
    ------------------------------------------------------------
    createToggle(combatTab, L.aimbot, "AimbotEnabled")
    createToggle(combatTab, L.autoShoot, "AutoShoot")
    createToggle(combatTab, L.killAura, "KillAura")
    createToggle(combatTab, L.autoGrab, "AutoGrabGun")
    createToggle(combatTab, L.autoDrop, "AutoGunDropped")
    createToggle(combatTab, L.sheriffFling, "SheriffFling")

    createToggle(combatTab, L.shootBtnToggle, "ShootButtonEnabled", function(enabled)
        shootOverlayBtn.Visible = enabled
    end)

    createToggle(combatTab, L.aimbotBtnToggle, "AimbotBtnEnabled", function(enabled)
        aimbotOverlayBtn.Visible = enabled
    end)

    createToggle(combatTab, L.noclipBtnToggle, "NoclipBtnEnabled", function(enabled)
        noclipOverlayBtn.Visible = enabled
    end)

    ------------------------------------------------------------
    -- 4. TELEPORT TAB (IŞINLANMA)
    ------------------------------------------------------------
    createButton(teleportTab, L.tpLobby, function()
        pcall(function()
            local lobby = Workspace:FindFirstChild("Lobby") or Workspace:FindFirstChild("LobbyModel")
            local root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            if lobby and root then
                root.CFrame = lobby:GetModelCFrame() or CFrame.new(0, 100, 0)
            end
        end)
    end)

    createButton(teleportTab, L.tpMap, function()
        pcall(function()
            local root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            if root then
                root.CFrame = CFrame.new(0, 10, 0)
            end
        end)
    end)

    createButton(teleportTab, L.tpToDroppedGun, function()
        pcall(function()
            local gunDrop = Workspace:FindFirstChild("GunDrop") or Workspace:FindFirstChild("Gun")
            local root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            if gunDrop and root then
                root.CFrame = gunDrop.CFrame
            end
        end)
    end)

    switchTab("Main")
end

----------------------------------------------------------------
-- 18. DİL SEÇİMİNİ OLUŞTURMA VE BAŞLATMA
----------------------------------------------------------------
for _, langData in ipairs(LanguageOptions) do
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 45)
    btn.BackgroundColor3 = Theme.Card
    btn.Font = Enum.Font.GothamBold
    btn.Text = langData.flag .. "  " .. langData.name
    btn.TextColor3 = Theme.Text
    btn.TextSize = 14
    btn.Parent = LangContainer

    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 8)
    btnCorner.Parent = btn

    local btnStroke = Instance.new("UIStroke")
    btnStroke.Color = Theme.Stroke
    btnStroke.Thickness = 1
    btnStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    btnStroke.Parent = btn

    btn.MouseButton1Click:Connect(function()
        CurrentLang = langData.code
        L = Lang[CurrentLang]
        
        LangFrame.Visible = false
        MainFrame.Visible = true
        
        buildMainInterface()
        sendNotification(L.welcome .. ", " .. LocalPlayer.Name .. "!")
    end)
end

-- Arayüz Açma / Kapama Sabit Butonu (UguzHub Icon)
local OpenBtn = Instance.new("TextButton")
OpenBtn.Size = UDim2.new(0, 90, 0, 32)
OpenBtn.Position = UDim2.new(0, 15, 0.4, 0)
OpenBtn.BackgroundColor3 = Theme.Sidebar
OpenBtn.Font = Enum.Font.GothamBold
OpenBtn.Text = "UguzHub"
OpenBtn.TextColor3 = Theme.Accent
OpenBtn.TextSize = 12
OpenBtn.Active = true
OpenBtn.Draggable = true
OpenBtn.Parent = ScreenGui

local OpenCorner = Instance.new("UICorner")
OpenCorner.CornerRadius = UDim.new(0, 8)
OpenCorner.Parent = OpenBtn

local OpenStroke = Instance.new("UIStroke")
OpenStroke.Color = Theme.Stroke
OpenStroke.Thickness = 1.5
OpenStroke.Parent = OpenBtn

OpenBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
end)
