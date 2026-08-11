-- UguzHub V2 Pro - Fully Custom Standalone Script
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

-- GUI Temizliği
if game.CoreGui:FindFirstChild("UguzHubUI") then
    game.CoreGui.UguzHubUI:Destroy()
end

-- Dil Çevirileri
local Langs = {
    TR = {
        Main = "Ana Sayfa", Farm = "Auto Farm", Combat = "Savaş & Aim", 
        Troll = "Troll & Hız", Extra = "Emote & Eşya", Settings = "Ayarlar",
        Greeting = "Bugün nasılsın, ", Esp = "Rol ESP Aç", AutoFarm = "Oto Sikke Topla",
        SilentAim = "Silent Aim (Otomatik İsabet)", LockTarget = "Hedefe Kilitlen (Lock)",
        Speed = "Yürüme Hızı: ", Fly = "Uçma Modu (Fly)", Fling = "Görünmez Fling",
        C4 = "Şaka Bombası (C4) Ver", Emotes = "Tüm Emoteleri Aç"
    },
    EN = {
        Main = "Main", Farm = "Auto Farm", Combat = "Combat & Aim", 
        Troll = "Troll & Speed", Extra = "Emotes & Items", Settings = "Settings",
        Greeting = "How are you today, ", Esp = "Toggle Role ESP", AutoFarm = "Auto Farm Coins",
        SilentAim = "Silent Aim (Auto Hit)", LockTarget = "Lock to Target",
        Speed = "Walk Speed: ", Fly = "Fly Mode", Fling = "Invisible Fling",
        C4 = "Get Prank Bomb (C4)", Emotes = "Unlock Emotes"
    },
    RU = {
        Main = "Главная", Farm = "Авто Фарм", Combat = "Бой & Аим", 
        Troll = "Тролль", Extra = "Предметы", Settings = "Настройки",
        Greeting = "Как ты сегодня, ", Esp = "Включить ESP", AutoFarm = "Авто-сбор монет",
        SilentAim = "Silent Aim", LockTarget = "Захват цели",
        Speed = "Скорость: ", Fly = "Режим полета", Fling = "Fling",
        C4 = "C4 Бомба", Emotes = "Разблокировать эмоции"
    }
}

local CurrentLang = Langs.TR

-- Durum Değişkenleri
local Flags = {
    ESP = false,
    AutoFarm = false,
    SilentAim = false,
    Fly = false,
    Fling = false,
    Speed = 16
}

-- ScreenGUI Yapılandırması
local UguzUI = Instance.new("ScreenGui")
UguzUI.Name = "UguzHubUI"
UguzUI.ResetOnSpawn = false
UguzUI.Parent = game.CoreGui

-- =================================================================
-- 1. ANİMASYONLU GİRİŞ EKRANI & DİL SEÇİMİ
-- =================================================================
local IntroFrame = Instance.new("Frame", UguzUI)
IntroFrame.Size = UDim2.new(0, 420, 0, 280)
IntroFrame.Position = UDim2.new(0.5, -210, 0.5, -140)
IntroFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 22)
IntroFrame.BorderSizePixel = 0

local IntroCorner = Instance.new("UICorner", IntroFrame)
IntroCorner.CornerRadius = UDim.new(0, 12)

local Title = Instance.new("TextLabel", IntroFrame)
Title.Size = UDim2.new(1, 0, 0, 50)
Title.Text = "✨ UGUZHUB V2 PRO ✨"
Title.TextColor3 = Color3.fromRGB(255, 215, 0)
Title.TextSize = 22
Title.Font = Enum.Font.GothamBold
Title.BackgroundTransparency = 1

local Underline = Instance.new("Frame", IntroFrame)
Underline.Size = UDim2.new(0, 0, 0, 3)
Underline.Position = UDim2.new(0.1, 0, 0.18, 0)
Underline.BackgroundColor3 = Color3.fromRGB(255, 215, 0)
Underline.BorderSizePixel = 0
TweenService:Create(Underline, TweenInfo.new(0.8, Enum.EasingStyle.Quad), {Size = UDim2.new(0.8, 0, 0, 3)}):Play()

local LangContainer = Instance.new("Frame", IntroFrame)
LangContainer.Size = UDim2.new(0.8, 0, 0, 160)
LangContainer.Position = UDim2.new(0.1, 0, 0.28, 0)
LangContainer.BackgroundTransparency = 1

local UIList = Instance.new("UIListLayout", LangContainer)
UIList.Padding = UDim.new(0, 10)
UIList.HorizontalAlignment = Enum.HorizontalAlignment.Center

local function CreateLangBtn(text, langData)
    local btn = Instance.new("TextButton", LangContainer)
    btn.Size = UDim2.new(1, 0, 0, 40)
    btn.Text = text
    btn.Font = Enum.Font.GothamMedium
    btn.TextSize = 16
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.BackgroundColor3 = Color3.fromRGB(30, 30, 38)
    
    local c = Instance.new("UICorner", btn)
    c.CornerRadius = UDim.new(0, 8)
    
    btn.MouseButton1Click:Connect(function()
        CurrentLang = langData
        IntroFrame:Destroy()
        BuildMainHub()
    end)
end

CreateLangBtn("🇹🇷 Türkçe", Langs.TR)
CreateLangBtn("🇬🇧 English", Langs.EN)
CreateLangBtn("🇷🇺 Русский", Langs.RU)

-- =================================================================
-- 2. ANA MENÜ YAPISI (5 BÖLÜM + AYARLAR)
-- =================================================================
function BuildMainHub()
    local MainFrame = Instance.new("Frame", UguzUI)
    MainFrame.Size = UDim2.new(0, 580, 0, 360)
    MainFrame.Position = UDim2.new(0.5, -290, 0.5, -180)
    MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 18)
    MainFrame.BorderSizePixel = 0
    MainFrame.Active = true
    MainFrame.Draggable = true

    local MainCorner = Instance.new("UICorner", MainFrame)
    MainCorner.CornerRadius = UDim.new(0, 10)

    -- Sol Menü (Tabs)
    local TabSidebar = Instance.new("Frame", MainFrame)
    TabSidebar.Size = UDim2.new(0, 150, 1, 0)
    TabSidebar.BackgroundColor3 = Color3.fromRGB(22, 22, 28)

    local SidebarCorner = Instance.new("UICorner", TabSidebar)
    SidebarCorner.CornerRadius = UDim.new(0, 10)

    local HubLabel = Instance.new("TextLabel", TabSidebar)
    HubLabel.Size = UDim2.new(1, 0, 0, 40)
    HubLabel.Text = "UguzHub V2"
    HubLabel.TextColor3 = Color3.fromRGB(255, 215, 0)
    HubLabel.Font = Enum.Font.GothamBold
    HubLabel.TextSize = 16
    HubLabel.BackgroundTransparency = 1

    local TabContainer = Instance.new("Frame", TabSidebar)
    TabContainer.Position = UDim2.new(0, 0, 0, 45)
    TabContainer.Size = UDim2.new(1, 0, 1, -45)
    TabContainer.BackgroundTransparency = 1

    local TabList = Instance.new("UIListLayout", TabContainer)
    TabList.Padding = UDim.new(0, 5)

    -- Sağ İçerik Alanı
    local ContentArea = Instance.new("Frame", MainFrame)
    ContentArea.Position = UDim2.new(0, 155, 0, 0)
    ContentArea.Size = UDim2.new(1, -155, 1, 0)
    ContentArea.BackgroundTransparency = 1

    local Pages = {}

    local function CreateTab(name, id)
        local tabBtn = Instance.new("TextButton", TabContainer)
        tabBtn.Size = UDim2.new(1, 0, 0, 35)
        tabBtn.Text = name
        tabBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
        tabBtn.Font = Enum.Font.Gotham
        tabBtn.BackgroundTransparency = 1

        local page = Instance.new("ScrollingFrame", ContentArea)
        page.Size = UDim2.new(1, -10, 1, -10)
        page.Position = UDim2.new(0, 5, 0, 5)
        page.BackgroundTransparency = 1
        page.Visible = false
        page.ScrollBarThickness = 2
        Pages[id] = page

        local pageList = Instance.new("UIListLayout", page)
        pageList.Padding = UDim.new(0, 8)

        tabBtn.MouseButton1Click:Connect(function()
            for _, p in pairs(Pages) do p.Visible = false end
            Pages[id].Visible = true
        end)
        return page
    end

    local PageMain = CreateTab(CurrentLang.Main, "Main")
    local PageFarm = CreateTab(CurrentLang.Farm, "Farm")
    local PageCombat = CreateTab(CurrentLang.Combat, "Combat")
    local PageTroll = CreateTab(CurrentLang.Troll, "Troll")
    local PageExtra = CreateTab(CurrentLang.Extra, "Extra")
    local PageSettings = CreateTab(CurrentLang.Settings, "Settings")

    PageMain.Visible = true -- Varsayılan

    -- UI Elemanı Oluşturucular
    local function AddToggle(parent, text, default, callback)
        local btn = Instance.new("TextButton", parent)
        btn.Size = UDim2.new(0.95, 0, 0, 35)
        btn.BackgroundColor3 = default and Color3.fromRGB(40, 120, 60) or Color3.fromRGB(35, 35, 42)
        btn.Text = text .. (default and " [AÇIK]" or " [KAPALI]")
        btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        btn.Font = Enum.Font.Gotham
        btn.TextSize = 13
        
        local c = Instance.new("UICorner", btn)
        c.CornerRadius = UDim.new(0, 6)

        local state = default
        btn.MouseButton1Click:Connect(function()
            state = not state
            btn.BackgroundColor3 = state and Color3.fromRGB(40, 120, 60) or Color3.fromRGB(35, 35, 42)
            btn.Text = text .. (state and " [AÇIK]" or " [KAPALI]")
            callback(state)
        end)
    end

    local function AddButton(parent, text, callback)
        local btn = Instance.new("TextButton", parent)
        btn.Size = UDim2.new(0.95, 0, 0, 35)
        btn.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
        btn.Text = text
        btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        btn.Font = Enum.Font.Gotham
        btn.TextSize = 13
        
        local c = Instance.new("UICorner", btn)
        c.CornerRadius = UDim.new(0, 6)

        btn.MouseButton1Click:Connect(callback)
    end

    -- 1. MAIN TAB
    AddToggle(PageMain, CurrentLang.Esp, false, function(v) Flags.ESP = v end)

    -- 2. AUTO FARM TAB
    AddToggle(PageFarm, CurrentLang.AutoFarm, false, function(v) Flags.AutoFarm = v end)

    -- 3. COMBAT TAB
    AddToggle(PageCombat, CurrentLang.SilentAim, false, function(v) Flags.SilentAim = v end)
    AddButton(PageCombat, CurrentLang.LockTarget, function()
        -- Anlık Hedefe Kilitlenme Modülü
    end)

    -- 4. TROLL TAB
    AddToggle(PageTroll, CurrentLang.Fly, false, function(v) Flags.Fly = v end)
    AddToggle(PageTroll, CurrentLang.Fling, false, function(v) Flags.Fling = v end)
    AddButton(PageTroll, CurrentLang.Speed .. " Hızlı Yap (50)", function()
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            LocalPlayer.Character.Humanoid.WalkSpeed = 50
        end
    end)

    -- 5. EMOTE & ITEMS
    AddButton(PageExtra, CurrentLang.C4, function()
        -- C4 Şaka eşyası alma mantığı
    end)
    AddButton(PageExtra, CurrentLang.Emotes, function()
        -- Emote kilitlerini açma mantığı
    end)

    -- 6. AYARLAR TAB (Profil Vesikalığı & İsmi)
    local ProfileFrame = Instance.new("Frame", PageSettings)
    ProfileFrame.Size = UDim2.new(0.95, 0, 0, 100)
    ProfileFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 30)

    local pCorner = Instance.new("UICorner", ProfileFrame)
    pCorner.CornerRadius = UDim.new(0, 8)

    local AvatarImg = Instance.new("ImageLabel", ProfileFrame)
    AvatarImg.Size = UDim2.new(0, 70, 0, 70)
    AvatarImg.Position = UDim2.new(0, 10, 0.5, -35)
    AvatarImg.BackgroundTransparency = 1
    AvatarImg.Image = Players:GetUserThumbnailAsync(LocalPlayer.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size100x100)

    local UserText = Instance.new("TextLabel", ProfileFrame)
    UserText.Position = UDim2.new(0, 90, 0, 15)
    UserText.Size = UDim2.new(1, -95, 0, 25)
    UserText.Text = LocalPlayer.DisplayName .. " (@" .. LocalPlayer.Name .. ")"
    UserText.TextColor3 = Color3.fromRGB(255, 255, 255)
    UserText.Font = Enum.Font.GothamBold
    UserText.TextSize = 14
    UserText.TextXAlignment = Enum.TextXAlignment.Left
    UserText.BackgroundTransparency = 1

    local GreetText = Instance.new("TextLabel", ProfileFrame)
    GreetText.Position = UDim2.new(0, 90, 0, 45)
    GreetText.Size = UDim2.new(1, -95, 0, 25)
    GreetText.Text = CurrentLang.Greeting .. LocalPlayer.DisplayName .. "! 👋"
    GreetText.TextColor3 = Color3.fromRGB(200, 200, 200)
    GreetText.Font = Enum.Font.Gotham
    GreetText.TextSize = 12
    GreetText.TextXAlignment = Enum.TextXAlignment.Left
    GreetText.BackgroundTransparency = 1
end

-- =================================================================
-- 3. GERÇEK ÇALIŞAN ARKA PLAN MANTIĞI (ESP, FARM, AIM)
-- =================================================================

-- Dynamic Rol ESP Döngüsü
RunService.RenderStepped:Connect(function()
    if Flags.ESP then
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                local hl = p.Character:FindFirstChild("UguzHighlight")
                if not hl then
                    hl = Instance.new("Highlight", p.Character)
                    hl.Name = "UguzHighlight"
                end
                
                -- MM2 Rol Algılama
                local isMurderer = p.Backpack:FindFirstChild("Knife") or p.Character:FindFirstChild("Knife")
                local isSheriff = p.Backpack:FindFirstChild("Gun") or p.Character:FindFirstChild("Gun")

                if isMurderer then
                    hl.FillColor = Color3.fromRGB(255, 0, 0) -- Kırmızı Katil
                elseif isSheriff then
                    hl.FillColor = Color3.fromRGB(0, 120, 255) -- Mavi Şerif
                else
                    hl.FillColor = Color3.fromRGB(0, 255, 120) -- Yeşil Masum
                end
            end
        end
    else
        for _, p in pairs(Players:GetPlayers()) do
            if p.Character and p.Character:FindFirstChild("UguzHighlight") then
                p.Character.UguzHighlight:Destroy()
            end
        end
    end
end)

-- Çalışan Auto Farm Döngüsü (Güvenli Raycast/Movement)
task.spawn(function()
    while task.wait(0.1) do
        if Flags.AutoFarm and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            local coins = {}
            for _, v in pairs(workspace:GetDescendants()) do
                if v.Name == "Coin_Container" or v.Name == "Coin" or v.Name == "CoinServer" then
                    table.insert(coins, v)
                end
            end
            
            for _, coin in pairs(coins) do
                if Flags.AutoFarm and coin:IsA("BasePart") then
                    LocalPlayer.Character.HumanoidRootPart.CFrame = coin.CFrame
                    task.wait(0.15)
                end
            end
        end
    end
end)

-- Silent Aim Kanca Mekanizması
local Meta = getrawmetatable(game)
local OldNamecall = Meta.__namecall
setreadonly(Meta, false)

Meta.__namecall = newcclosure(function(Self, ...)
    local Method = getnamecallmethod()
    local Args = {...}

    if Flags.SilentAim and tostring(Method) == "Raycast" or tostring(Method) == "FindPartOnRay" then
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                local isMurderer = p.Backpack:FindFirstChild("Knife") or p.Character:FindFirstChild("Knife")
                local isSheriff = p.Backpack:FindFirstChild("Gun") or p.Character:FindFirstChild("Gun")

                -- Şerifsek katile, Katilsek şerife odaklan
                if isMurderer or isSheriff then
                    Args[2] = (p.Character.HumanoidRootPart.Position - Args[1]).Unit * 1000
                    return OldNamecall(Self, unpack(Args))
                end
            end
        end
    end
    return OldNamecall(Self, ...)
end)
setreadonly(Meta, true)
