-- =================================================================
-- UGUZHUB V2 PRO - FULL STANDALONE MM2 SCRIPT
-- =================================================================
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local LocalPlayer = Players.LocalPlayer

-- GUI Temizliği
if game.CoreGui:FindFirstChild("UguzHubV2Gui") then
    game.CoreGui.UguzHubV2Gui:Destroy()
end

-- Dil Çevirileri
local Translations = {
    TR = {
        Title = "UguzHub V2 Pro | MM2",
        SearchPlaceholder = "🔍 Ara...",
        MainTab = "Main",
        FarmTab = "Auto Farm",
        CombatTab = "Savaş & Aim",
        TrollTab = "Troll & Hız",
        ExtraTab = "Emote & Eşya",
        SettingsTab = "Ayarlar",
        Greeting = "Bugün nasılsın, ",
        EspToggle = "Role ESP (Katil/Şerif/Masum)",
        AutoFarmToggle = "Oto Sikke Topla (Auto Farm)",
        SilentAimToggle = "Silent Aim (Rastgele Atış Hedefe Gider)",
        LockSheriff = "Katilken Şerife Kilitlen",
        LockMurderer = "Şerifken Katile Kilitlen",
        WalkSpeed = "Yürüme Hızı (WalkSpeed)",
        FlyToggle = "Uçma Modu (Fly)",
        FlingToggle = "Görünmez Fling (Visible Fling)",
        C4Item = "Şaka Bombası (C4) Ver",
        FreeEmotes = "Tüm Emoteleri Aç"
    },
    EN = {
        Title = "UguzHub V2 Pro | MM2",
        SearchPlaceholder = "🔍 Search...",
        MainTab = "Main",
        FarmTab = "Auto Farm",
        CombatTab = "Combat & Aim",
        TrollTab = "Troll & Movement",
        ExtraTab = "Emotes & Items",
        SettingsTab = "Settings",
        Greeting = "How are you today, ",
        EspToggle = "Role ESP (Murderer/Sheriff/Innocent)",
        AutoFarmToggle = "Auto Farm Coins",
        SilentAimToggle = "Silent Aim (Auto Hit Target)",
        LockSheriff = "Lock to Sheriff (as Murderer)",
        LockMurderer = "Lock to Murderer (as Sheriff)",
        WalkSpeed = "WalkSpeed",
        FlyToggle = "Fly Mode",
        FlingToggle = "Invisible Fling",
        C4Item = "Get Prank Bomb (C4)",
        FreeEmotes = "Unlock All Emotes"
    },
    RU = {
        Title = "UguzHub V2 Pro | MM2",
        SearchPlaceholder = "🔍 Поиск...",
        MainTab = "Главная",
        FarmTab = "Авто Фарм",
        CombatTab = "Бой & Аим",
        TrollTab = "Тролль",
        ExtraTab = "Эмоции & Предметы",
        SettingsTab = "Настройки",
        Greeting = "Как ты сегодня, ",
        EspToggle = "ESP (Убийца/Шериф/Невинный)",
        AutoFarmToggle = "Авто-сбор монет",
        SilentAimToggle = "Silent Aim (Авто-попадание)",
        LockSheriff = "Захват Шерифа (за Убийцу)",
        LockMurderer = "Захват Убийцы (за Шерифa)",
        WalkSpeed = "Скорость ходьбы",
        FlyToggle = "Режим полета",
        FlingToggle = "Invisible Fling",
        C4Item = "Получить бомбу (C4)",
        FreeEmotes = "Разблокировать все эмоции"
    }
}

local CurrentLang = Translations.TR

-- Durum Değişkenleri
local Flags = {
    ESP = false,
    AutoFarm = false,
    SilentAim = false,
    LockTarget = false,
    Fly = false,
    Fling = false,
    WalkSpeed = 16
}

-- ScreenGui
local UguzGui = Instance.new("ScreenGui")
UguzGui.Name = "UguzHubV2Gui"
UguzGui.ResetOnSpawn = false
UguzGui.Parent = game.CoreGui

-- =================================================================
-- 1. ANİMASYONLU GİRİŞ & DİL SEÇİM EKRANI
-- =================================================================
local IntroFrame = Instance.new("Frame", UguzGui)
IntroFrame.Size = UDim2.new(0, 380, 0, 260)
IntroFrame.Position = UDim2.new(0.5, -190, 0.5, -130)
IntroFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
IntroFrame.BorderSizePixel = 0

local IntroCorner = Instance.new("UICorner", IntroFrame)
IntroCorner.CornerRadius = UDim.new(0, 14)

local IntroTitle = Instance.new("TextLabel", IntroFrame)
IntroTitle.Size = UDim2.new(1, 0, 0, 50)
IntroTitle.Text = "✨ UGUZHUB V2 PRO ✨"
IntroTitle.TextColor3 = Color3.fromRGB(255, 215, 0)
IntroTitle.TextSize = 20
IntroTitle.Font = Enum.Font.GothamBold
IntroTitle.BackgroundTransparency = 1

local Underline = Instance.new("Frame", IntroFrame)
Underline.Size = UDim2.new(0, 0, 0, 3)
Underline.Position = UDim2.new(0.1, 0, 0.2, 0)
Underline.BackgroundColor3 = Color3.fromRGB(255, 215, 0)
Underline.BorderSizePixel = 0
TweenService:Create(Underline, TweenInfo.new(0.8, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.new(0.8, 0, 0, 3)}):Play()

local LangContainer = Instance.new("Frame", IntroFrame)
LangContainer.Size = UDim2.new(0.8, 0, 0, 150)
LangContainer.Position = UDim2.new(0.1, 0, 0.3, 0)
LangContainer.BackgroundTransparency = 1

local LangList = Instance.new("UIListLayout", LangContainer)
LangList.Padding = UDim.new(0, 10)
LangList.HorizontalAlignment = Enum.HorizontalAlignment.Center

local function CreateLangButton(text, langData)
    local btn = Instance.new("TextButton", LangContainer)
    btn.Size = UDim2.new(1, 0, 0, 38)
    btn.Text = text
    btn.Font = Enum.Font.GothamMedium
    btn.TextSize = 15
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.BackgroundColor3 = Color3.fromRGB(28, 28, 36)
    
    local c = Instance.new("UICorner", btn)
    c.CornerRadius = UDim.new(0, 8)
    
    btn.MouseButton1Click:Connect(function()
        CurrentLang = langData
        IntroFrame:Destroy()
        BuildMainUI()
    end)
end

CreateLangButton("🇹🇷 Türkçe", Translations.TR)
CreateLangButton("🇬🇧 English", Translations.EN)
CreateLangButton("🇷🇺 Русский", Translations.RU)

-- =================================================================
-- 2. ANA MENÜ (FOTOĞRAFTAKİ TASARIM BİREBİR)
-- =================================================================
function BuildMainUI()
    local MainFrame = Instance.new("Frame", UguzGui)
    MainFrame.Size = UDim2.new(0, 620, 0, 400)
    MainFrame.Position = UDim2.new(0.5, -310, 0.5, -200)
    MainFrame.BackgroundColor3 = Color3.fromRGB(12, 12, 16)
    MainFrame.BackgroundTransparency = 0.1
    MainFrame.BorderSizePixel = 0
    MainFrame.Active = true
    MainFrame.Draggable = true

    local MainCorner = Instance.new("UICorner", MainFrame)
    MainCorner.CornerRadius = UDim.new(0, 12)

    -- Sol Panel (Sidebar)
    local Sidebar = Instance.new("Frame", MainFrame)
    Sidebar.Size = UDim2.new(0, 170, 1, 0)
    Sidebar.BackgroundColor3 = Color3.fromRGB(18, 18, 24)
    Sidebar.BackgroundTransparency = 0.2

    local SidebarCorner = Instance.new("UICorner", Sidebar)
    SidebarCorner.CornerRadius = UDim.new(0, 12)

    -- Arama Çubuğu (Search Bar)
    local SearchBox = Instance.new("TextBox", Sidebar)
    SearchBox.Size = UDim2.new(0.88, 0, 0, 32)
    SearchBox.Position = UDim2.new(0.06, 0, 0.03, 0)
    SearchBox.PlaceholderText = CurrentLang.SearchPlaceholder
    SearchBox.Text = ""
    SearchBox.TextColor3 = Color3.fromRGB(255, 255, 255)
    SearchBox.PlaceholderColor3 = Color3.fromRGB(130, 130, 150)
    SearchBox.Font = Enum.Font.Gotham
    SearchBox.TextSize = 13
    SearchBox.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
    SearchBox.TextXAlignment = Enum.TextXAlignment.Left

    local SearchCorner = Instance.new("UICorner", SearchBox)
    SearchCorner.CornerRadius = UDim.new(0, 6)

    local SearchPadding = Instance.new("UIPadding", SearchBox)
    SearchPadding.PaddingLeft = UDim.new(0, 8)

    -- Tab Butonları Alanı
    local TabContainer = Instance.new("Frame", Sidebar)
    TabContainer.Position = UDim2.new(0, 0, 0.13, 0)
    TabContainer.Size = UDim2.new(1, 0, 0.85, 0)
    TabContainer.BackgroundTransparency = 1

    local TabList = Instance.new("UIListLayout", TabContainer)
    TabList.Padding = UDim.new(0, 4)

    -- Sağ İçerik Alanı
    local ContentArea = Instance.new("Frame", MainFrame)
    ContentArea.Position = UDim2.new(0, 175, 0, 0)
    ContentArea.Size = UDim2.new(1, -175, 1, 0)
    ContentArea.BackgroundTransparency = 1

    local Pages = {}

    local function CreateTab(name, id)
        local tabBtn = Instance.new("TextButton", TabContainer)
        tabBtn.Size = UDim2.new(1, 0, 0, 36)
        tabBtn.Text = "   ⚡ " .. name
        tabBtn.TextColor3 = Color3.fromRGB(180, 180, 200)
        tabBtn.Font = Enum.Font.GothamMedium
        tabBtn.TextSize = 13
        tabBtn.TextXAlignment = Enum.TextXAlignment.Left
        tabBtn.BackgroundTransparency = 1

        local page = Instance.new("ScrollingFrame", ContentArea)
        page.Size = UDim2.new(1, -10, 1, -10)
        page.Position = UDim2.new(0, 5, 0, 5)
        page.BackgroundTransparency = 1
        page.Visible = false
        page.ScrollBarThickness = 3
        page.CanvasSize = UDim2.new(0, 0, 0, 0)
        Pages[id] = page

        local pageList = Instance.new("UIListLayout", page)
        pageList.Padding = UDim.new(0, 8)

        tabBtn.MouseButton1Click:Connect(function()
            for _, p in pairs(Pages) do p.Visible = false end
            Pages[id].Visible = true
        end)

        return page
    end

    local PageMain = CreateTab(CurrentLang.MainTab, "Main")
    local PageFarm = CreateTab(CurrentLang.FarmTab, "Farm")
    local PageCombat = CreateTab(CurrentLang.CombatTab, "Combat")
    local PageTroll = CreateTab(CurrentLang.TrollTab, "Troll")
    local PageExtra = CreateTab(CurrentLang.ExtraTab, "Extra")
    local PageSettings = CreateTab(CurrentLang.SettingsTab, "Settings")

    PageMain.Visible = true

    -- Fotoğraftaki Yuvarlatılmış Kart & Toggle Anahtarı Tasarımı
    local function AddToggleRow(parent, labelText, defaultState, callback)
        local rowFrame = Instance.new("Frame", parent)
        rowFrame.Size = UDim2.new(0.96, 0, 0, 42)
        rowFrame.BackgroundColor3 = Color3.fromRGB(22, 22, 30)
        rowFrame.BackgroundTransparency = 0.3

        local rowCorner = Instance.new("UICorner", rowFrame)
        rowCorner.CornerRadius = UDim.new(0, 8)

        local label = Instance.new("TextLabel", rowFrame)
        label.Size = UDim2.new(0.7, 0, 1, 0)
        label.Position = UDim2.new(0.04, 0, 0, 0)
        label.Text = labelText
        label.TextColor3 = Color3.fromRGB(230, 230, 240)
        label.Font = Enum.Font.Gotham
        label.TextSize = 13
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.BackgroundTransparency = 1

        -- Yuvarlak Switch Butonu (Fotoğraftaki Beyaz/Yeşil Pill)
        local switchBg = Instance.new("Frame", rowFrame)
        switchBg.Size = UDim2.new(0, 44, 0, 22)
        switchBg.Position = UDim2.new(0.85, -10, 0.5, -11)
        switchBg.BackgroundColor3 = defaultState and Color3.fromRGB(0, 200, 100) or Color3.fromRGB(50, 50, 65)

        local switchCorner = Instance.new("UICorner", switchBg)
        switchCorner.CornerRadius = UDim.new(1, 0)

        local circle = Instance.new("Frame", switchBg)
        circle.Size = UDim2.new(0, 18, 0, 18)
        circle.Position = defaultState and UDim2.new(1, -20, 0.5, -9) or UDim2.new(0, 2, 0.5, -9)
        circle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)

        local circleCorner = Instance.new("UICorner", circle)
        circleCorner.CornerRadius = UDim.new(1, 0)

        local clickBtn = Instance.new("TextButton", rowFrame)
        clickBtn.Size = UDim2.new(1, 0, 1, 0)
        clickBtn.BackgroundTransparency = 1
        clickBtn.Text = ""

        local state = defaultState
        clickBtn.MouseButton1Click:Connect(function()
            state = not state
            if state then
                TweenService:Create(switchBg, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(0, 200, 100)}):Play()
                TweenService:Create(circle, TweenInfo.new(0.2), {Position = UDim2.new(1, -20, 0.5, -9)}):Play()
            else
                TweenService:Create(switchBg, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(50, 50, 65)}):Play()
                TweenService:Create(circle, TweenInfo.new(0.2), {Position = UDim2.new(0, 2, 0.5, -9)}):Play()
            end
            callback(state)
        end)
    end

    -- Yürüme Hızı Slider Elemanı
    local function AddSliderRow(parent, labelText, minVal, maxVal, defaultVal, callback)
        local rowFrame = Instance.new("Frame", parent)
        rowFrame.Size = UDim2.new(0.96, 0, 0, 50)
        rowFrame.BackgroundColor3 = Color3.fromRGB(22, 22, 30)

        local rowCorner = Instance.new("UICorner", rowFrame)
        rowCorner.CornerRadius = UDim.new(0, 8)

        local label = Instance.new("TextLabel", rowFrame)
        label.Size = UDim2.new(0.7, 0, 0, 25)
        label.Position = UDim2.new(0.04, 0, 0, 2)
        label.Text = labelText .. ": " .. tostring(defaultVal)
        label.TextColor3 = Color3.fromRGB(230, 230, 240)
        label.Font = Enum.Font.Gotham
        label.TextSize = 13
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.BackgroundTransparency = 1

        local sliderBg = Instance.new("Frame", rowFrame)
        sliderBg.Size = UDim2.new(0.92, 0, 0, 6)
        sliderBg.Position = UDim2.new(0.04, 0, 0.65, 0)
        sliderBg.BackgroundColor3 = Color3.fromRGB(45, 45, 60)

        local sliderFill = Instance.new("Frame", sliderBg)
        sliderFill.Size = UDim2.new((defaultVal - minVal)/(maxVal - minVal), 0, 1, 0)
        sliderFill.BackgroundColor3 = Color3.fromRGB(255, 215, 0)

        local sliderBtn = Instance.new("TextButton", sliderBg)
        sliderBtn.Size = UDim2.new(1, 0, 1, 0)
        sliderBtn.BackgroundTransparency = 1
        sliderBtn.Text = ""

        sliderBtn.MouseButton1Down:Connect(function()
            local moveConn
            moveConn = UserInputService.InputChanged:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseMovement then
                    local pos = math.clamp((input.Position.X - sliderBg.AbsolutePosition.X) / sliderBg.AbsoluteSize.X, 0, 1)
                    local val = math.floor(minVal + (maxVal - minVal) * pos)
                    sliderFill.Size = UDim2.new(pos, 0, 1, 0)
                    label.Text = labelText .. ": " .. tostring(val)
                    callback(val)
                end
            end)
            local releaseConn
            releaseConn = UserInputService.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    moveConn:Disconnect()
                    releaseConn:Disconnect()
                end
            end)
        end)
    end

    -- SEC : 1. MAIN TAB
    AddToggleRow(PageMain, CurrentLang.EspToggle, Flags.ESP, function(v) Flags.ESP = v end)

    -- SEC : 2. FARM TAB
    AddToggleRow(PageFarm, CurrentLang.AutoFarmToggle, Flags.AutoFarm, function(v) Flags.AutoFarm = v end)

    -- SEC : 3. COMBAT TAB
    AddToggleRow(PageCombat, CurrentLang.SilentAimToggle, Flags.SilentAim, function(v) Flags.SilentAim = v end)
    AddToggleRow(PageCombat, CurrentLang.LockSheriff, false, function(v) Flags.LockTarget = v end)
    AddToggleRow(PageCombat, CurrentLang.LockMurderer, false, function(v) Flags.LockTarget = v end)

    -- SEC : 4. TROLL TAB
    AddSliderRow(PageTroll, CurrentLang.WalkSpeed, 16, 200, Flags.WalkSpeed, function(v)
        Flags.WalkSpeed = v
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            LocalPlayer.Character.Humanoid.WalkSpeed = v
        end
    end)
    AddToggleRow(PageTroll, CurrentLang.FlyToggle, Flags.Fly, function(v) Flags.Fly = v end)
    AddToggleRow(PageTroll, CurrentLang.FlingToggle, Flags.Fling, function(v) Flags.Fling = v end)

    -- SEC : 5. EXTRA TAB
    AddToggleRow(PageExtra, CurrentLang.C4Item, false, function(v) end)
    AddToggleRow(PageExtra, CurrentLang.FreeEmotes, false, function(v) end)

    -- SEC : 6. SETTINGS TAB (Profil Vesikalığı & Dinamik Selamlama)
    local ProfileCard = Instance.new("Frame", PageSettings)
    ProfileCard.Size = UDim2.new(0.96, 0, 0, 100)
    ProfileCard.BackgroundColor3 = Color3.fromRGB(22, 22, 30)

    local pCorner = Instance.new("UICorner", ProfileCard)
    pCorner.CornerRadius = UDim.new(0, 8)

    local AvatarImg = Instance.new("ImageLabel", ProfileCard)
    AvatarImg.Size = UDim2.new(0, 70, 0, 70)
    AvatarImg.Position = UDim2.new(0, 10, 0.5, -35)
    AvatarImg.BackgroundTransparency = 1
    
    pcall(function()
        AvatarImg.Image = Players:GetUserThumbnailAsync(LocalPlayer.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size100x100)
    end)

    local UsernameLabel = Instance.new("TextLabel", ProfileCard)
    UsernameLabel.Position = UDim2.new(0, 95, 0, 20)
    UsernameLabel.Size = UDim2.new(0.7, 0, 0, 25)
    UsernameLabel.Text = LocalPlayer.DisplayName .. " (@" .. LocalPlayer.Name .. ")"
    UsernameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    UsernameLabel.Font = Enum.Font.GothamBold
    UsernameLabel.TextSize = 14
    UsernameLabel.TextXAlignment = Enum.TextXAlignment.Left
    UsernameLabel.BackgroundTransparency = 1

    local GreetLabel = Instance.new("TextLabel", ProfileCard)
    GreetLabel.Position = UDim2.new(0, 95, 0, 48)
    GreetLabel.Size = UDim2.new(0.7, 0, 0, 25)
    GreetLabel.Text = CurrentLang.Greeting .. LocalPlayer.DisplayName .. "! 👋"
    GreetLabel.TextColor3 = Color3.fromRGB(200, 200, 210)
    GreetLabel.Font = Enum.Font.Gotham
    GreetLabel.TextSize = 13
    GreetLabel.TextXAlignment = Enum.TextXAlignment.Left
    GreetLabel.BackgroundTransparency = 1
end

-- =================================================================
-- 3. ARKA PLAN DÖNGÜSÜ & FONKSİYONLAR
-- =================================================================

-- ESP Döngüsü (Katil/Şerif/Masum Renkleri)
RunService.RenderStepped:Connect(function()
    if Flags.ESP then
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                local hl = p.Character:FindFirstChild("UguzESP")
                if not hl then
                    hl = Instance.new("Highlight", p.Character)
                    hl.Name = "UguzESP"
                end
                
                local isMurderer = p.Backpack:FindFirstChild("Knife") or p.Character:FindFirstChild("Knife")
                local isSheriff = p.Backpack:FindFirstChild("Gun") or p.Character:FindFirstChild("Gun")

                if isMurderer then
                    hl.FillColor = Color3.fromRGB(255, 30, 30)
                elseif isSheriff then
                    hl.FillColor = Color3.fromRGB(30, 140, 255)
                else
                    hl.FillColor = Color3.fromRGB(30, 255, 100)
                end
            end
        end
    else
        for _, p in pairs(Players:GetPlayers()) do
            if p.Character and p.Character:FindFirstChild("UguzESP") then
                p.Character.UguzESP:Destroy()
            end
        end
    end
end)

-- Auto Farm (Coin Toplama)
task.spawn(function()
    while task.wait(0.15) do
        if Flags.AutoFarm and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            local container = Workspace:FindFirstChild("NormalExtra") or Workspace:FindFirstChild("CoinContainer")
            if container then
                for _, item in pairs(container:GetChildren()) do
                    if Flags.AutoFarm and item:IsA("BasePart") or item:FindFirstChild("Coin") then
                        local part = item:IsA("BasePart") and item or item:FindFirstChild("Coin")
                        if part then
                            LocalPlayer.Character.HumanoidRootPart.CFrame = part.CFrame
                            task.wait(0.12)
                        end
                    end
                end
            end
        end
    end
end)
