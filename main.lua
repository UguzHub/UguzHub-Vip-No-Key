-- [[ UGUZHUB - MURDER MYSTERY 2 ]] --

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Workspace = game:GetService("Workspace")
local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera

-- Safe GUI Parent Detection
local ParentGui
if gethui then
    ParentGui = gethui()
elseif game:GetService("CoreGui"):FindFirstChild("RobloxGui") then
    ParentGui = game:GetService("CoreGui")
else
    ParentGui = LocalPlayer:WaitForChild("PlayerGui", 5) or LocalPlayer.PlayerGui
end

if ParentGui:FindFirstChild("UguzHub_MM2") then
    ParentGui.UguzHub_MM2:Destroy()
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "UguzHub_MM2"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = ParentGui

------------------------------------------------------------------------
-- LANGUAGE SAVE / LOAD SYSTEM
------------------------------------------------------------------------

local ConfigFileName = "UguzHub_Lang.txt"

local function saveLanguage(lang)
    if writefile then
        pcall(function()
            writefile(ConfigFileName, lang)
        end)
    end
end

local function loadLanguage()
    if isfile and readfile and isfile(ConfigFileName) then
        local success, result = pcall(readfile, ConfigFileName)
        if success and (result == "EN" or result == "RU") then
            return result
        end
    end
    return "EN"
end

local CurrentLang = loadLanguage()
local RegisteredTexts = {}

local Translations = {
    EN = {
        TabESP = "👁  ESP",
        TabAimbot = "🎯  Aimbot",
        TabPlayers = "👤  Players",
        TabTeleport = "🌀  Teleport",
        TabSettings = "⚙  Settings",
        
        ESPAll = "ESP All (Red: Murder, Blue: Sheriff, Green: Innocent)",
        GunHeader = "Gun Options",
        ESPGun = "ESP Gun",
        AutoGrabGun = "Auto (Grab Gun)",
        TPGrabGun = "TP Grab Gun (Teleport & Back)",
        
        AimbotEnable = "Enable Aimbot",
        
        KillActions = "Kill Actions",
        AutoKillMurderer = "Auto Kill Murderer (Sheriff Only)",
        KillMurderer = "Kill Murderer",
        KillAll = "Kill All (Murderer Only)",
        AutoFlingHeader = "Auto Fling Options",
        AutoFlingMurderer = "Auto Fling Murderer",
        AutoFlingSheriff = "Auto Fling Sheriff",
        AutoFlingAll = "Auto Fling All",
        
        TeleportLocations = "Locations",
        TPToLobby = "TP to Lobby",
        TPToMap = "TP to Map",
        TeleportPlayers = "Players",
        TPToMurderer = "TP to Murderer",
        TPToSheriff = "TP to Sheriff",
        
        SettingsHeader = "Language Settings",
        SelectLangLabel = "Click below to select language:",
        LangENBtn = "English 🇺🇸",
        LangRUBtn = "Русский 🇷🇺",
        WaitText = "Wait 5 seconds..."
    },
    RU = {
        TabESP = "👁  ESP",
        TabAimbot = "🎯  Аимбот",
        TabPlayers = "👤  Игроки",
        TabTeleport = "🌀  Телепорт",
        TabSettings = "⚙  Настройки",
        
        ESPAll = "ESP Всех (Красный: Мардер, Синий: Шериф, Зеленый: Мирный)",
        GunHeader = "Настройки Оружия",
        ESPGun = "ESP Оружия",
        AutoGrabGun = "Авто-подбор оружия",
        TPGrabGun = "ТП подбор оружия (ТП и обратно)",
        
        AimbotEnable = "Включить Аимбот",
        
        KillActions = "Действия Убийства",
        AutoKillMurderer = "Auto Kill Murderer (Sheriff Only)",
        KillMurderer = "Убить Мардера",
        KillAll = "Убить Всех (Только Мардер)",
        AutoFlingHeader = "Настройки Авто-Флинга",
        AutoFlingMurderer = "Авто-Флинг Мардера",
        AutoFlingSheriff = "Авто-Флинг Шерифа",
        AutoFlingAll = "Авто-Флинг Всех",
        
        TeleportLocations = "Локации",
        TPToLobby = "ТП в Лобби",
        TPToMap = "ТП на Карту",
        TeleportPlayers = "Игроки",
        TPToMurderer = "ТП к Мардеру",
        TPToSheriff = "ТП к Шерифу",
        
        SettingsHeader = "Настройки Языка",
        SelectLangLabel = "Нажмите ниже чтобы выбрать язык:",
        LangENBtn = "English 🇺🇸",
        LangRUBtn = "Русский 🇷🇺",
        WaitText = "Подождите 5 секунд..."
    }
}

local function registerText(element, key)
    table.insert(RegisteredTexts, {element = element, key = key})
    element.Text = Translations[CurrentLang][key] or element.Text
end

------------------------------------------------------------------------
-- DRAGGING SYSTEM
------------------------------------------------------------------------

local function makeDraggable(dragHandle, frameToMove)
    local dragging = false
    local dragInput, dragStart, startPos

    dragHandle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = frameToMove.Position

            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    dragHandle.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            frameToMove.Position = UDim2.new(
                startPos.X.Scale,
                startPos.X.Offset + delta.X,
                startPos.Y.Scale,
                startPos.Y.Offset + delta.Y
            )
        end
    end)
end

------------------------------------------------------------------------
-- LOADING SCREEN (3 SECONDS INITIAL)
------------------------------------------------------------------------

local LoadingFrame = Instance.new("Frame")
LoadingFrame.Name = "LoadingFrame"
LoadingFrame.Size = UDim2.new(0, 300, 0, 140)
LoadingFrame.Position = UDim2.new(0.5, -150, 0.5, -70)
LoadingFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 18)
LoadingFrame.BorderSizePixel = 0
LoadingFrame.Parent = ScreenGui

local LoadingCorner = Instance.new("UICorner")
LoadingCorner.CornerRadius = UDim.new(0, 14)
LoadingCorner.Parent = LoadingFrame

local LoadingStroke = Instance.new("UIStroke")
LoadingStroke.Color = Color3.fromRGB(34, 197, 94)
LoadingStroke.Thickness = 1.5
LoadingStroke.Parent = LoadingFrame

local LoadingTitle = Instance.new("TextLabel")
LoadingTitle.Size = UDim2.new(1, 0, 0, 40)
LoadingTitle.Position = UDim2.new(0, 0, 0, 15)
LoadingTitle.BackgroundTransparency = 1
LoadingTitle.Font = Enum.Font.GothamBold
LoadingTitle.Text = "⚡ UguzHub"
LoadingTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
LoadingTitle.TextSize = 18
LoadingTitle.Parent = LoadingFrame

local LoadingSub = Instance.new("TextLabel")
LoadingSub.Size = UDim2.new(1, 0, 0, 20)
LoadingSub.Position = UDim2.new(0, 0, 0, 45)
LoadingSub.BackgroundTransparency = 1
LoadingSub.Font = Enum.Font.Gotham
LoadingSub.Text = "Loading MM2 Script..."
LoadingSub.TextColor3 = Color3.fromRGB(150, 150, 150)
LoadingSub.TextSize = 12
LoadingSub.Parent = LoadingFrame

local BarBackground = Instance.new("Frame")
BarBackground.Size = UDim2.new(0.8, 0, 0, 6)
BarBackground.Position = UDim2.new(0.1, 0, 0.75, 0)
BarBackground.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
BarBackground.BorderSizePixel = 0
BarBackground.Parent = LoadingFrame

local BarCorner = Instance.new("UICorner")
BarCorner.CornerRadius = UDim.new(1, 0)
BarCorner.Parent = BarBackground

local BarFill = Instance.new("Frame")
BarFill.Size = UDim2.new(0, 0, 1, 0)
BarFill.BackgroundColor3 = Color3.fromRGB(34, 197, 94)
BarFill.BorderSizePixel = 0
BarFill.Parent = BarBackground

local FillCorner = Instance.new("UICorner")
FillCorner.CornerRadius = UDim.new(1, 0)
FillCorner.Parent = BarFill

makeDraggable(LoadingFrame, LoadingFrame)

-- Flags
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

-- MM2 Role Detection
local function getRole(player)
    if not player or not player.Character then return "Innocent" end
    if player.Backpack:FindFirstChild("Knife") or player.Character:FindFirstChild("Knife") then
        return "Murderer"
    elseif player.Backpack:FindFirstChild("Gun") or player.Character:FindFirstChild("Gun") then
        return "Sheriff"
    end
    return "Innocent"
end

local RoleColors = {
    Murderer = Color3.fromRGB(239, 68, 68),
    Sheriff = Color3.fromRGB(59, 130, 246),
    Innocent = Color3.fromRGB(34, 197, 94),
    Gun = Color3.fromRGB(234, 179, 8)
}

------------------------------------------------------------------------
-- MAIN USER INTERFACE
------------------------------------------------------------------------

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 500, 0, 320)
MainFrame.Position = UDim2.new(0.5, -250, 0.5, -160)
MainFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 22)
MainFrame.BorderSizePixel = 0
MainFrame.ClipsDescendants = true
MainFrame.Visible = false
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 16)
MainCorner.Parent = MainFrame

-- TOP HEADER BAR (ALWAYS VISIBLE & DRAGGABLE)
local Header = Instance.new("Frame")
Header.Name = "Header"
Header.Size = UDim2.new(1, 0, 0, 40)
Header.Position = UDim2.new(0, 0, 0, 0)
Header.BackgroundTransparency = 1
Header.Parent = MainFrame

makeDraggable(Header, MainFrame)
makeDraggable(MainFrame, MainFrame)

-- 3 Lines Button (☰)
local ThreeLinesBtn = Instance.new("TextButton")
ThreeLinesBtn.Name = "ThreeLinesBtn"
ThreeLinesBtn.Size = UDim2.new(0, 28, 0, 28)
ThreeLinesBtn.Position = UDim2.new(0, 8, 0.5, -14)
ThreeLinesBtn.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
ThreeLinesBtn.Font = Enum.Font.GothamBold
ThreeLinesBtn.Text = "☰"
ThreeLinesBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ThreeLinesBtn.TextSize = 15
ThreeLinesBtn.Parent = Header

local ThreeLinesCorner = Instance.new("UICorner")
ThreeLinesCorner.CornerRadius = UDim.new(0, 6)
ThreeLinesCorner.Parent = ThreeLinesBtn

local HeaderTitle = Instance.new("TextLabel")
HeaderTitle.Size = UDim2.new(0, 150, 1, 0)
HeaderTitle.Position = UDim2.new(0, 42, 0, 0)
HeaderTitle.BackgroundTransparency = 1
HeaderTitle.Font = Enum.Font.GothamBold
HeaderTitle.Text = "⚡ UguzHub"
HeaderTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
HeaderTitle.TextSize = 14
HeaderTitle.TextXAlignment = Enum.TextXAlignment.Left
HeaderTitle.Parent = Header

local SearchBox = Instance.new("TextBox")
SearchBox.Size = UDim2.new(0, 110, 0, 24)
SearchBox.Position = UDim2.new(1, -180, 0.5, -12)
SearchBox.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
SearchBox.Font = Enum.Font.Gotham
SearchBox.PlaceholderText = "🔍 Search..."
SearchBox.Text = ""
SearchBox.TextColor3 = Color3.fromRGB(255, 255, 255)
SearchBox.TextSize = 11
SearchBox.Parent = Header

local SearchCorner = Instance.new("UICorner")
SearchCorner.CornerRadius = UDim.new(0, 6)
SearchCorner.Parent = SearchBox

local SettingsBtn = Instance.new("TextButton")
SettingsBtn.Size = UDim2.new(0, 24, 0, 24)
SettingsBtn.Position = UDim2.new(1, -62, 0.5, -12)
SettingsBtn.BackgroundColor3 = Color3.fromRGB(12, 12, 15)
SettingsBtn.Font = Enum.Font.GothamBold
SettingsBtn.Text = "⚙"
SettingsBtn.TextColor3 = Color3.fromRGB(220, 220, 220)
SettingsBtn.TextSize = 13
SettingsBtn.Parent = Header

local SettingsCorner = Instance.new("UICorner")
SettingsCorner.CornerRadius = UDim.new(0, 6)
SettingsCorner.Parent = SettingsBtn

local SettingsStroke = Instance.new("UIStroke")
SettingsStroke.Color = Color3.fromRGB(80, 80, 80)
SettingsStroke.Thickness = 1
SettingsStroke.Parent = SettingsBtn

local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 24, 0, 24)
CloseBtn.Position = UDim2.new(1, -32, 0.5, -12)
CloseBtn.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.Text = "✕"
CloseBtn.TextColor3 = Color3.fromRGB(220, 220, 220)
CloseBtn.TextSize = 12
CloseBtn.Parent = Header

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 6)
CloseCorner.Parent = CloseBtn

local GreyLine = Instance.new("Frame")
GreyLine.Name = "GreyLine"
GreyLine.Size = UDim2.new(1, 0, 0, 2)
GreyLine.Position = UDim2.new(0, 0, 0, 40)
GreyLine.BackgroundColor3 = Color3.fromRGB(70, 70, 75)
GreyLine.BorderSizePixel = 0
GreyLine.Parent = MainFrame

local BodyFrame = Instance.new("Frame")
BodyFrame.Name = "BodyFrame"
BodyFrame.Size = UDim2.new(1, 0, 1, -42)
BodyFrame.Position = UDim2.new(0, 0, 0, 42)
BodyFrame.BackgroundTransparency = 1
BodyFrame.BorderSizePixel = 0
BodyFrame.Parent = MainFrame

local isCollapsed = false
local function toggleCollapse()
    isCollapsed = not isCollapsed
    if isCollapsed then
        BodyFrame.Visible = false
        MainFrame.Size = UDim2.new(0, 500, 0, 42)
    else
        MainFrame.Size = UDim2.new(0, 500, 0, 320)
        BodyFrame.Visible = true
    end
end

ThreeLinesBtn.MouseButton1Click:Connect(toggleCollapse)
CloseBtn.MouseButton1Click:Connect(toggleCollapse)

-- Sidebar
local Sidebar = Instance.new("Frame")
Sidebar.Size = UDim2.new(0, 140, 1, 0)
Sidebar.BackgroundColor3 = Color3.fromRGB(12, 12, 15)
Sidebar.BorderSizePixel = 0
Sidebar.Parent = BodyFrame

local SidebarCorner = Instance.new("UICorner")
SidebarCorner.CornerRadius = UDim.new(0, 16)
SidebarCorner.Parent = Sidebar

local LogoLabel = Instance.new("TextLabel")
LogoLabel.Size = UDim2.new(1, -15, 0, 35)
LogoLabel.Position = UDim2.new(0, 12, 0, 5)
LogoLabel.BackgroundTransparency = 1
LogoLabel.Font = Enum.Font.GothamBold
LogoLabel.Text = "<font size='10' color='#22c55e'>MurderMystery2</font>"
LogoLabel.RichText = true
LogoLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
LogoLabel.TextSize = 13
LogoLabel.TextXAlignment = Enum.TextXAlignment.Left
LogoLabel.Parent = Sidebar

local TabList = Instance.new("Frame")
TabList.Size = UDim2.new(1, 0, 1, -40)
TabList.Position = UDim2.new(0, 0, 0, 40)
TabList.BackgroundTransparency = 1
TabList.Parent = Sidebar

local TabListLayout = Instance.new("UIListLayout")
TabListLayout.SortOrder = Enum.SortOrder.LayoutOrder
TabListLayout.Padding = UDim.new(0, 5)
TabListLayout.Parent = TabList

-- Content Area
local ContentArea = Instance.new("Frame")
ContentArea.Size = UDim2.new(1, -150, 1, -10)
ContentArea.Position = UDim2.new(0, 145, 0, 5)
ContentArea.BackgroundTransparency = 1
ContentArea.Parent = BodyFrame

-- Black Wait Screen Overlay
local WaitOverlay = Instance.new("Frame")
WaitOverlay.Name = "WaitOverlay"
WaitOverlay.Size = UDim2.new(1, 0, 1, 0)
WaitOverlay.BackgroundColor3 = Color3.fromRGB(10, 10, 12)
WaitOverlay.BorderSizePixel = 0
WaitOverlay.ZIndex = 20
WaitOverlay.Visible = false
WaitOverlay.Parent = MainFrame

local WaitCorner = Instance.new("UICorner")
WaitCorner.CornerRadius = UDim.new(0, 16)
WaitCorner.Parent = WaitOverlay

local WaitLabel = Instance.new("TextLabel")
WaitLabel.Size = UDim2.new(1, 0, 1, 0)
WaitLabel.BackgroundTransparency = 1
WaitLabel.Font = Enum.Font.GothamBold
WaitLabel.Text = "Wait 5 seconds..."
WaitLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
WaitLabel.TextSize = 18
WaitLabel.ZIndex = 21
WaitLabel.Parent = WaitOverlay

------------------------------------------------------------------------
-- TABS & HELPERS
------------------------------------------------------------------------

local pages = {}
local tabBtns = {}

local function addTab(name, langKey)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -12, 0, 32)
    btn.Position = UDim2.new(0, 6, 0, 0)
    btn.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
    btn.BorderSizePixel = 0
    btn.Font = Enum.Font.GothamMedium
    btn.TextColor3 = Color3.fromRGB(150, 150, 160)
    btn.TextSize = 11
    btn.TextXAlignment = Enum.TextXAlignment.Left
    btn.Parent = TabList

    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 8)
    btnCorner.Parent = btn

    local page = Instance.new("ScrollingFrame")
    page.Size = UDim2.new(1, 0, 1, 0)
    page.BackgroundTransparency = 1
    page.BorderSizePixel = 0
    page.ScrollBarThickness = 2
    page.Visible = false
    page.Parent = ContentArea

    local layout = Instance.new("UIListLayout")
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Padding = UDim.new(0, 6)
    layout.Parent = page

    pages[name] = page
    tabBtns[name] = btn

    registerText(btn, langKey)

    local function openThisTab()
        for _, p in pairs(pages) do p.Visible = false end
        for _, b in pairs(tabBtns) do 
            b.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
            b.TextColor3 = Color3.fromRGB(150, 150, 160)
        end
        page.Visible = true
        btn.BackgroundColor3 = Color3.fromRGB(34, 197, 94)
        btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    end

    btn.MouseButton1Click:Connect(openThisTab)

    return page, openThisTab
end

local ESPTab = addTab("ESP", "TabESP")
local AimbotTab = addTab("Aimbot", "TabAimbot")
local PlayersTab = addTab("Players", "TabPlayers")
local TeleportTab = addTab("Teleport", "TabTeleport")
local SettingsTab, openSettingsTab = addTab("Settings", "TabSettings")

SettingsBtn.MouseButton1Click:Connect(function()
    openSettingsTab()
end)

pages["ESP"].Visible = true
tabBtns["ESP"].BackgroundColor3 = Color3.fromRGB(34, 197, 94)
tabBtns["ESP"].TextColor3 = Color3.fromRGB(255, 255, 255)

local function createToggle(parent, labelKey, flag, defaultColor)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, -10, 0, 36)
    frame.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
    frame.Parent = parent

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = frame

    local txt = Instance.new("TextLabel")
    txt.Size = UDim2.new(0.75, 0, 1, 0)
    txt.Position = UDim2.new(0, 10, 0, 0)
    txt.BackgroundTransparency = 1
    txt.Font = Enum.Font.Gotham
    txt.TextColor3 = defaultColor or Color3.fromRGB(220, 220, 220)
    txt.TextSize = 11
    txt.TextXAlignment = Enum.TextXAlignment.Left
    txt.Parent = frame

    registerText(txt, labelKey)

    local switch = Instance.new("Frame")
    switch.Size = UDim2.new(0, 34, 0, 18)
    switch.Position = UDim2.new(1, -42, 0.5, -9)
    switch.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
    switch.Parent = frame

    local switchCorner = Instance.new("UICorner")
    switchCorner.CornerRadius = UDim.new(1, 0)
    switchCorner.Parent = switch

    local dot = Instance.new("Frame")
    dot.Size = UDim2.new(0, 14, 0, 14)
    dot.Position = UDim2.new(0, 2, 0.5, -7)
    dot.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
    dot.Parent = switch

    local dotCorner = Instance.new("UICorner")
    dotCorner.CornerRadius = UDim.new(1, 0)
    dotCorner.Parent = dot

    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 1, 0)
    btn.BackgroundTransparency = 1
    btn.Text = ""
    btn.Parent = frame

    btn.MouseButton1Click:Connect(function()
        Flags[flag] = not Flags[flag]
        if Flags[flag] then
            switch.BackgroundColor3 = Color3.fromRGB(34, 197, 94)
            dot.Position = UDim2.new(1, -16, 0.5, -7)
            dot.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        else
            switch.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
            dot.Position = UDim2.new(0, 2, 0.5, -7)
            dot.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
        end
    end)
end

local function createHeader(parent, labelKey, color)
    local txt = Instance.new("TextLabel")
    txt.Size = UDim2.new(1, -10, 0, 20)
    txt.BackgroundTransparency = 1
    txt.Font = Enum.Font.GothamBold
    txt.TextColor3 = color or Color3.fromRGB(255, 255, 255)
    txt.TextSize = 12
    txt.TextXAlignment = Enum.TextXAlignment.Left
    txt.Parent = parent

    registerText(txt, labelKey)
end

local function createButton(parent, labelKey, color, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -10, 0, 38)
    btn.BackgroundColor3 = color or Color3.fromRGB(34, 197, 94)
    btn.Font = Enum.Font.GothamBold
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.TextSize = 11
    btn.Parent = parent

    registerText(btn, labelKey)

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = btn

    btn.MouseButton1Click:Connect(function()
        if callback then callback() end
    end)
end

local function createTeleportButton(parent, labelKey, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -10, 0, 36)
    btn.BackgroundColor3 = Color3.fromRGB(12, 12, 15)
    btn.Font = Enum.Font.GothamBold
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.TextSize = 11
    btn.Parent = parent

    registerText(btn, labelKey)

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = btn

    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(120, 120, 120)
    stroke.Thickness = 1.2
    stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    stroke.Parent = btn

    btn.MouseButton1Click:Connect(function()
        if callback then callback() end
    end)
end

------------------------------------------------------------------------
-- LANGUAGE SWITCH FUNCTION WITH 5s BLACK OVERLAY & SAVE
------------------------------------------------------------------------

local isChangingLang = false

local function setLanguage(langCode)
    if isChangingLang then return end
    isChangingLang = true
    CurrentLang = langCode
    saveLanguage(langCode)

    WaitOverlay.Visible = true
    WaitLabel.Text = Translations[CurrentLang].WaitText or "Wait 5 seconds..."

    task.spawn(function()
        task.wait(5)
        
        for _, item in ipairs(RegisteredTexts) do
            if item.element and item.element.Parent then
                local newTxt = Translations[CurrentLang][item.key]
                if newTxt then
                    item.element.Text = newTxt
                end
            end
        end

        WaitOverlay.Visible = false
        isChangingLang = false
    end)
end

------------------------------------------------------------------------
-- 100X FLING ENGINE
------------------------------------------------------------------------

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
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
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
                if p ~= LocalPlayer and getRole(p) == "Murderer" and Flags.AutoFlingMurderer then
                    superFling(p)
                end
            end
        end

        if Flags.AutoFlingSheriff then
            for _, p in pairs(Players:GetPlayers()) do
                if p ~= LocalPlayer and getRole(p) == "Sheriff" and Flags.AutoFlingSheriff then
                    superFling(p)
                end
            end
        end

        if Flags.AutoFlingAll then
            for _, p in pairs(Players:GetPlayers()) do
                if p ~= LocalPlayer and Flags.AutoFlingAll then
                    superFling(p)
                end
            end
        end
    end
end)

------------------------------------------------------------------------
-- TAB CONTENTS
------------------------------------------------------------------------

-- 1. ESP TAB
createToggle(ESPTab, "ESPAll", "ESPAll")
createHeader(ESPTab, "GunHeader", Color3.fromRGB(255, 255, 255))
createToggle(ESPTab, "ESPGun", "ESPGun", Color3.fromRGB(234, 179, 8))
createToggle(ESPTab, "AutoGrabGun", "AutoGrabGun")

createButton(ESPTab, "TPGrabGun", Color3.fromRGB(234, 179, 8), function()
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

-- 2. AIMBOT TAB
createToggle(AimbotTab, "AimbotEnable", "AimbotEnabled")

-- 3. PLAYERS TAB
createHeader(PlayersTab, "KillActions", Color3.fromRGB(255, 255, 255))
createToggle(PlayersTab, "AutoKillMurderer", "AutoKillMurderer")

createButton(PlayersTab, "KillMurderer", Color3.fromRGB(59, 130, 246), function()
    local myChar = LocalPlayer.Character
    if myChar and myChar:FindFirstChild("HumanoidRootPart") then
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and getRole(p) == "Murderer" and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                myChar.HumanoidRootPart.CFrame = p.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, 3)
            end
        end
    end
end)

createButton(PlayersTab, "KillAll", Color3.fromRGB(239, 68, 68), function()
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

createHeader(PlayersTab, "AutoFlingHeader", Color3.fromRGB(255, 255, 255))
createToggle(PlayersTab, "AutoFlingMurderer", "AutoFlingMurderer")
createToggle(PlayersTab, "AutoFlingSheriff", "AutoFlingSheriff")
createToggle(PlayersTab, "AutoFlingAll", "AutoFlingAll")

-- 4. TELEPORT TAB
createHeader(TeleportTab, "TeleportLocations", Color3.fromRGB(255, 255, 255))

createTeleportButton(TeleportTab, "TPToLobby", function()
    local myHrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not myHrp then return end
    local lobby = Workspace:FindFirstChild("Lobby")
    if lobby then
        local spawnPart = lobby:FindFirstChild("Spawns") or lobby:FindFirstChild("Spawn") or lobby:FindFirstChildWhichIsA("BasePart", true)
        if spawnPart then
            myHrp.CFrame = spawnPart.CFrame + Vector3.new(0, 3, 0)
        else
            myHrp.CFrame = CFrame.new(-108, 140, 82)
        end
    else
        myHrp.CFrame = CFrame.new(-108, 140, 82)
    end
end)

createTeleportButton(TeleportTab, "TPToMap", function()
    local myHrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not myHrp then return end
    
    local found = false
    for _, child in pairs(Workspace:GetChildren()) do
        if child:FindFirstChild("Spawns") or child:FindFirstChild("CoinContainer") then
            local spawns = child:FindFirstChild("Spawns")
            local spawnPart = spawns and spawns:FindFirstChildWhichIsA("BasePart") or child:FindFirstChildWhichIsA("BasePart", true)
            if spawnPart then
                myHrp.CFrame = spawnPart.CFrame + Vector3.new(0, 3, 0)
                found = true
                break
            end
        end
    end
    
    if not found then
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                if getRole(p) == "Murderer" or getRole(p) == "Sheriff" then
                    myHrp.CFrame = p.Character.HumanoidRootPart.CFrame + Vector3.new(0, 2, 0)
                    break
                end
            end
        end
    end
end)

createHeader(TeleportTab, "TeleportPlayers", Color3.fromRGB(255, 255, 255))

createTeleportButton(TeleportTab, "TPToMurderer", function()
    local myHrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not myHrp then return end
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and getRole(p) == "Murderer" and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
            myHrp.CFrame = p.Character.HumanoidRootPart.CFrame + Vector3.new(0, 2, 0)
            break
        end
    end
end)

createTeleportButton(TeleportTab, "TPToSheriff", function()
    local myHrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not myHrp then return end
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and getRole(p) == "Sheriff" and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
            myHrp.CFrame = p.Character.HumanoidRootPart.CFrame + Vector3.new(0, 2, 0)
            break
        end
    end
end)

-- 5. SETTINGS TAB (Language Selection)
createHeader(SettingsTab, "SettingsHeader", Color3.fromRGB(255, 255, 255))
createHeader(SettingsTab, "SelectLangLabel", Color3.fromRGB(150, 150, 160))

createButton(SettingsTab, "LangENBtn", Color3.fromRGB(34, 197, 94), function()
    setLanguage("EN")
end)

createButton(SettingsTab, "LangRUBtn", Color3.fromRGB(59, 130, 246), function()
    setLanguage("RU")
end)

------------------------------------------------------------------------
-- MAIN RENDER LOOP
------------------------------------------------------------------------

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

------------------------------------------------------------------------
-- DIRECT EXECUTION (DIRECTLY SHOW MAIN MENU AFTER SHORT LOADING)
------------------------------------------------------------------------

TweenService:Create(BarFill, TweenInfo.new(2.8, Enum.EasingStyle.Linear, Enum.EasingDirection.Out), {Size = UDim2.new(1, 0, 1, 0)}):Play()

task.spawn(function()
    task.wait(3)
    if LoadingFrame and LoadingFrame.Parent then
        LoadingFrame:Destroy()
    end
    MainFrame.Visible = true
end)
