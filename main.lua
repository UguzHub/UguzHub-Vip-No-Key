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
        TabWeapon = "⚔  Weapon Spawner",
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

        WeaponSpawnerHeader = "Weapon Spawner",
        WeaponSpawnerTitle = "Weapon Spawner",
        StatusDisabled = "Disabled",
        StatusEnabled = "Enabled",

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
        TabWeapon = "⚔  Спавнер Оружия",
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

        WeaponSpawnerHeader = "Спавнер Оружия",
        WeaponSpawnerTitle = "Спавнер Оружия",
        StatusDisabled = "Выключено",
        StatusEnabled = "Включено",

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
LoadingFrame.Size = UDim2.new(0, 520, 0, 340)
LoadingFrame.Position = UDim2.new(0.5, -260, 0.5, -170)
LoadingFrame.BackgroundColor3 = Color3.fromRGB(10, 12, 20)
LoadingFrame.BorderSizePixel = 0
LoadingFrame.Parent = ScreenGui

local LoadingCorner = Instance.new("UICorner")
LoadingCorner.CornerRadius = UDim.new(0, 14)
LoadingCorner.Parent = LoadingFrame

local LoadingStroke = Instance.new("UIStroke")
LoadingStroke.Color = Color3.fromRGB(45, 50, 75)
LoadingStroke.Thickness = 1.2
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
LoadingSub.TextColor3 = Color3.fromRGB(160, 160, 185)
LoadingSub.TextSize = 12
LoadingSub.Parent = LoadingFrame

local BarBackground = Instance.new("Frame")
BarBackground.Size = UDim2.new(0.8, 0, 0, 6)
BarBackground.Position = UDim2.new(0.1, 0, 0.75, 0)
BarBackground.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
BarBackground.BorderSizePixel = 0
BarBackground.Parent = LoadingFrame

local BarCorner = Instance.new("UICorner")
BarCorner.CornerRadius = UDim.new(1, 0)
BarCorner.Parent = BarBackground

local BarFill = Instance.new("Frame")
BarFill.Size = UDim2.new(0, 0, 1, 0)
BarFill.BackgroundColor3 = Color3.fromRGB(99, 102, 241)
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
    AutoFlingAll = false,
    WeaponSpawner = false
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
MainFrame.Size = UDim2.new(0, 520, 0, 340)
MainFrame.Position = UDim2.new(0.5, -260, 0.5, -170)
MainFrame.BackgroundColor3 = Color3.fromRGB(10, 12, 20)
MainFrame.BorderSizePixel = 0
MainFrame.ClipsDescendants = true
MainFrame.Visible = false
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 16)
MainCorner.Parent = MainFrame

local MainStroke = Instance.new("UIStroke")
MainStroke.Color = Color3.fromRGB(45, 50, 75)
MainStroke.Thickness = 1.2
MainStroke.Parent = MainFrame

-- Background Image Overlay (optional)
local BackgroundImage = Instance.new("ImageLabel")
BackgroundImage.Name = "BackgroundImage"
BackgroundImage.Size = UDim2.new(1, 0, 1, 0)
BackgroundImage.Position = UDim2.new(0, 0, 0, 0)
BackgroundImage.BackgroundTransparency = 1
BackgroundImage.ImageTransparency = 0.65
BackgroundImage.ScaleType = Enum.ScaleType.Crop
BackgroundImage.Parent = MainFrame

local bgImageFileName = "UguzHub_CharacterBg.png"
if writefile and getcustomasset then
    pcall(function()
        if isfile and isfile(bgImageFileName) then
            BackgroundImage.Image = getcustomasset(bgImageFileName)
        end
    end)
end

-- Dark Overlay tint for readability
local OverlayFrame = Instance.new("Frame")
OverlayFrame.Name = "OverlayFrame"
OverlayFrame.Size = UDim2.new(1, 0, 1, 0)
OverlayFrame.BackgroundColor3 = Color3.fromRGB(8, 10, 16)
OverlayFrame.BackgroundTransparency = 0.35
OverlayFrame.BorderSizePixel = 0
OverlayFrame.Parent = MainFrame

-- TOP HEADER BAR
local Header = Instance.new("Frame")
Header.Name = "Header"
Header.Size = UDim2.new(1, 0, 0, 42)
Header.Position = UDim2.new(0, 0, 0, 0)
Header.BackgroundTransparency = 1
Header.ZIndex = 5
Header.Parent = MainFrame

makeDraggable(Header, MainFrame)
makeDraggable(MainFrame, MainFrame)

local ThreeLinesBtn = Instance.new("TextButton")
ThreeLinesBtn.Name = "ThreeLinesBtn"
ThreeLinesBtn.Size = UDim2.new(0, 28, 0, 28)
ThreeLinesBtn.Position = UDim2.new(0, 10, 0.5, -14)
ThreeLinesBtn.BackgroundColor3 = Color3.fromRGB(20, 22, 35)
ThreeLinesBtn.Font = Enum.Font.GothamBold
ThreeLinesBtn.Text = "☰"
ThreeLinesBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ThreeLinesBtn.TextSize = 15
ThreeLinesBtn.ZIndex = 6
ThreeLinesBtn.Parent = Header

local HeaderTitle = Instance.new("TextLabel")
HeaderTitle.Size = UDim2.new(0, 150, 1, 0)
HeaderTitle.Position = UDim2.new(0, 46, 0, 0)
HeaderTitle.BackgroundTransparency = 1
HeaderTitle.Font = Enum.Font.GothamBold
HeaderTitle.Text = "⚡ UguzHub"
HeaderTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
HeaderTitle.TextSize = 14
HeaderTitle.TextXAlignment = Enum.TextXAlignment.Left
HeaderTitle.ZIndex = 6
HeaderTitle.Parent = Header

local SearchBox = Instance.new("TextBox")
SearchBox.Size = UDim2.new(0, 120, 0, 26)
SearchBox.Position = UDim2.new(1, -190, 0.5, -13)
SearchBox.BackgroundColor3 = Color3.fromRGB(20, 22, 35)
SearchBox.Font = Enum.Font.Gotham
SearchBox.PlaceholderText = "🔍 Search..."
SearchBox.Text = ""
SearchBox.TextColor3 = Color3.fromRGB(255, 255, 255)
SearchBox.TextSize = 11
SearchBox.ZIndex = 6
SearchBox.Parent = Header

local SettingsBtn = Instance.new("TextButton")
SettingsBtn.Size = UDim2.new(0, 26, 0, 26)
SettingsBtn.Position = UDim2.new(1, -62, 0.5, -13)
{