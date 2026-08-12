-- =================================================================
-- UGUZHUB V2 PRO | FULL CUSTOM UI (OWNER: LYNXEZ10)
-- =================================================================
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local LocalPlayer = Players.LocalPlayer

-- Resim ID'leri
local INTRO_BG_ID = "rbxassetid://15732257423" 
local MENU_BG_ID = "rbxassetid://10830725683"

-- Eski GUI varsa temizle
if CoreGui:FindFirstChild("UguzHubMainGui") then CoreGui.UguzHubMainGui:Destroy() end
if CoreGui:FindFirstChild("UguzIntroGui") then CoreGui.UguzIntroGui:Destroy() end

local Translations = {
    TR = { Title = "UGUZHUB V2 PRO", Subtitle = "Owner: Lynxez10", Main = "Ana Sayfa", Combat = "Savaş", Extra = "Ekstralar", Settings = "Ayarlar", Welcome = "Hoşgeldin, " },
    EN = { Title = "UGUZHUB V2 PRO", Subtitle = "Owner: Lynxez10", Main = "Main", Combat = "Combat", Extra = "Extras", Settings = "Settings", Welcome = "Welcome, " },
    RU = { Title = "UGUZHUB V2 PRO", Subtitle = "Owner: Lynxez10", Main = "Главная", Combat = "Бой", Extra = "Доп.", Settings = "Настройки", Welcome = "Добро пожаловать, " }
}

-- =================================================================
-- 1. GELİŞMİŞ GİRİŞ EKRANI (INTRO & LANGUAGE)
-- =================================================================
local IntroGui = Instance.new("ScreenGui")
IntroGui.Name = "UguzIntroGui"
IntroGui.ResetOnSpawn = false
IntroGui.Parent = CoreGui

local IntroBG = Instance.new("ImageLabel")
IntroBG.Size = UDim2.new(1, 0, 1, 0)
IntroBG.BackgroundColor3 = Color3.fromRGB(5, 5, 8)
IntroBG.Image = INTRO_BG_ID
IntroBG.ImageTransparency = 0.2
IntroBG.ScaleType = Enum.ScaleType.Crop
IntroBG.Parent = IntroGui

local DarkOverlay = Instance.new("Frame")
DarkOverlay.Size = UDim2.new(1, 0, 1, 0)
DarkOverlay.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
DarkOverlay.BackgroundTransparency = 0.45
DarkOverlay.Parent = IntroBG

local IntroCard = Instance.new("Frame")
IntroCard.Size = UDim2.new(0, 480, 0, 350)
IntroCard.Position = UDim2.new(0.5, 0, 0.5, 0)
IntroCard.AnchorPoint = Vector2.new(0.5, 0.5)
IntroCard.BackgroundColor3 = Color3.fromRGB(14, 14, 20)
IntroCard.BackgroundTransparency = 0.15
IntroCard.Parent = IntroGui

local CardCorner = Instance.new("UICorner")
CardCorner.CornerRadius = UDim.new(0, 18)
CardCorner.Parent = IntroCard

local CardStroke = Instance.new("UIStroke")
CardStroke.Color = Color3.fromRGB(60, 60, 90)
CardStroke.Thickness = 1.8
CardStroke.Parent = IntroCard

-- Üst Ayırıcı Çizgi (-------- .......... --------)
local IntroDivider = Instance.new("TextLabel")
IntroDivider.Size = UDim2.new(1, 0, 0, 20)
IntroDivider.Position = UDim2.new(0, 0, 0, 12)
IntroDivider.BackgroundTransparency = 1
IntroDivider.Text = "-------- ............................................. -----------"
IntroDivider.TextColor3 = Color3.fromRGB(100, 110, 160)
IntroDivider.TextSize = 12
IntroDivider.Font = Enum.Font.Code
IntroDivider.Parent = IntroCard

local MainTitle = Instance.new("TextLabel")
MainTitle.Size = UDim2.new(1, 0, 0, 35)
MainTitle.Position = UDim2.new(0, 0, 0, 32)
MainTitle.BackgroundTransparency = 1
MainTitle.Text = "UGUZHUB V2 PRO"
MainTitle.TextColor3 = Color3.fromRGB(240, 240, 255)
MainTitle.TextSize = 26
MainTitle.Font = Enum.Font.GothamBold
MainTitle.Parent = IntroCard

local OwnerLabel = Instance.new("TextLabel")
OwnerLabel.Size = UDim2.new(1, 0, 0, 20)
OwnerLabel.Position = UDim2.new(0, 0, 0, 67)
OwnerLabel.BackgroundTransparency = 1
OwnerLabel.Text = "Owner: Lynxez10"
OwnerLabel.TextColor3 = Color3.fromRGB(0, 210, 255)
OwnerLabel.TextSize = 14
OwnerLabel.Font = Enum.Font.GothamMedium
OwnerLabel.Parent = IntroCard

local LangHolder = Instance.new("Frame")
LangHolder.Size = UDim2.new(1, -60, 0, 210)
LangHolder.Position = UDim2.new(0, 30, 0, 105)
LangHolder.BackgroundTransparency = 1
LangHolder.Parent = IntroCard

local LangLayout = Instance.new("UIListLayout")
LangLayout.Padding = UDim.new(0, 12)
LangLayout.Parent = LangHolder

-- =================================================================
-- 2. ANA MENÜ (MAIN HUB)
-- =================================================================
local function OpenMainHub(langKey)
    local L = Translations[langKey]
    IntroGui:Destroy()

    local MainGui = Instance.new("ScreenGui")
    MainGui.Name = "UguzHubMainGui"
    MainGui.ResetOnSpawn = false
    MainGui.Parent = CoreGui

    -- Resimli Arka Plan Çerçevesi
    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Size = UDim2.new(0, 620, 0, 380)
    MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
    MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
    MainFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 14)
    MainFrame.ClipsDescendants = true
    MainFrame.Active = true
    MainFrame.Draggable = true
    MainFrame.Parent = MainGui

    local MainCorner = Instance.new("UICorner")
    MainCorner.CornerRadius = UDim.new(0, 14)
    MainCorner.Parent = MainFrame

    local MainStroke = Instance.new("UIStroke")
    MainStroke.Color = Color3.fromRGB(45, 45, 65)
    MainStroke.Thickness = 1.5
    MainStroke.Parent = MainFrame

    -- İstenen Arka Plan Resmi (10830725683)
    local MenuBG = Instance.new("ImageLabel")
    MenuBG.Size = UDim2.new(1, 0, 1, 0)
    MenuBG.BackgroundTransparency = 1
    MenuBG.Image = MENU_BG_ID
    MenuBG.ImageTransparency = 0.35
    MenuBG.ScaleType = Enum.ScaleType.Crop
    MenuBG.ZIndex = 1
    MenuBG.Parent = MainFrame

    -- Üst Başlık & Açma Kapama Şeridi
    local TopBar = Instance.new("Frame")
    TopBar.Size = UDim2.new(1, 0, 0, 50)
    TopBar.BackgroundTransparency = 1
    TopBar.ZIndex = 2
    TopBar.Parent = MainFrame

    local TopDivider = Instance.new("TextLabel")
    TopDivider.Size = UDim2.new(1, 0, 0, 15)
    TopDivider.Position = UDim2.new(0, 0, 0, 2)
    TopDivider.BackgroundTransparency = 1
    TopDivider.Text = "-------- ............................................. -----------"
    TopDivider.TextColor3 = Color3.fromRGB(0, 190, 255)
    TopDivider.TextSize = 11
    TopDivider.Font = Enum.Font.Code
    TopDivider.ZIndex = 2
    TopDivider.Parent = TopBar

    local HubTitle = Instance.new("TextLabel")
    HubTitle.Size = UDim2.new(0, 200, 0, 25)
    HubTitle.Position = UDim2.new(0, 20, 0, 18)
    HubTitle.BackgroundTransparency = 1
    HubTitle.Text = L.Title
    HubTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
    HubTitle.TextSize = 18
    HubTitle.Font = Enum.Font.GothamBold
    HubTitle.TextXAlignment = Enum.TextXAlignment.Left
    HubTitle.ZIndex = 2
    HubTitle.Parent = TopBar

    local HubOwner = Instance.new("TextLabel")
    HubOwner.Size = UDim2.new(0, 150, 0, 25)
    HubOwner.Position = UDim2.new(0, 180, 0, 18)
    HubOwner.BackgroundTransparency = 1
    HubOwner.Text = "|  " .. L.Subtitle
    HubOwner.TextColor3 = Color3.fromRGB(150, 150, 180)
    HubOwner.TextSize = 13
    HubOwner.Font = Enum.Font.GothamMedium
    HubOwner.TextXAlignment = Enum.TextXAlignment.Left
    HubOwner.ZIndex = 2
    HubOwner.Parent = TopBar

    -- Kapatma / Küçültme Tuşu
    local CloseBtn = Instance.new("TextButton")
    CloseBtn.Size = UDim2.new(0, 30, 0, 30)
    CloseBtn.Position = UDim2.new(1, -40, 0, 10)
    CloseBtn.BackgroundColor3 = Color3.fromRGB(220, 50, 50)
    CloseBtn.Text = "X"
    CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    CloseBtn.Font = Enum.Font.GothamBold
    CloseBtn.TextSize = 14
    CloseBtn.ZIndex = 3
    CloseBtn.Parent = TopBar

    local CloseCorner = Instance.new("UICorner")
    CloseCorner.CornerRadius = UDim.new(0, 8)
    CloseCorner.Parent = CloseBtn

    -- Menü İçerik Alanı
    local ContentFrame = Instance.new("Frame")
    ContentFrame.Size = UDim2.new(1, -40, 1, -70)
    ContentFrame.Position = UDim2.new(0, 20, 0, 55)
    ContentFrame.BackgroundTransparency = 1
    ContentFrame.ZIndex = 2
    ContentFrame.Parent = MainFrame

    local WelcomeLabel = Instance.new("TextLabel")
    WelcomeLabel.Size = UDim2.new(1, 0, 0, 40)
    WelcomeLabel.BackgroundTransparency = 1
    WelcomeLabel.Text = L.Welcome .. LocalPlayer.DisplayName .. " (@" .. LocalPlayer.Name .. ")!"
    WelcomeLabel.TextColor3 = Color3.fromRGB(220, 220, 240)
    WelcomeLabel.TextSize = 16
    WelcomeLabel.Font = Enum.Font.GothamMedium
    WelcomeLabel.ZIndex = 2
    WelcomeLabel.Parent = ContentFrame

    -- Kısayol Tuşu ile Menü Açma/Kapama (Toggle)
    local isOpen = true
    local function ToggleMenu()
        isOpen = not isOpen
        MainFrame.Visible = isOpen
    end

    CloseBtn.MouseButton1Click:Connect(ToggleMenu)

    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if not gameProcessed and input.KeyCode == Enum.KeyCode.K then
            ToggleMenu()
        end
    end)
end

-- =================================================================
-- 3. GELİŞMİŞ EĞİMLİ & ANİMASYONLU DİL BUTONLARI
-- =================================================================
local function CreateAdvancedLangButton(text, langKey)
    local Btn = Instance.new("TextButton")
    Btn.Size = UDim2.new(1, 0, 0, 48)
    Btn.BackgroundColor3 = Color3.fromRGB(24, 25, 36)
    Btn.Text = text
    Btn.TextColor3 = Color3.fromRGB(230, 230, 240)
    Btn.TextSize = 16
    Btn.Font = Enum.Font.GothamBold
    Btn.ClipsDescendants = true
    Btn.Parent = LangHolder

    -- Eğimli / Yuvarlatılmış Kenarlar
    local BtnCorner = Instance.new("UICorner")
    BtnCorner.CornerRadius = UDim.new(0, 12)
    BtnCorner.Parent = Btn

    local BtnStroke = Instance.new("UIStroke")
    BtnStroke.Color = Color3.fromRGB(50, 52, 75)
    BtnStroke.Thickness = 1.2
    BtnStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    BtnStroke.Parent = Btn

    -- Hover (Üzerine Gelince Parlama) Animasyonları
    Btn.MouseEnter:Connect(function()
        TweenService:Create(Btn, TweenInfo.new(0.25), {BackgroundColor3 = Color3.fromRGB(38, 40, 60)}):Play()
        TweenService:Create(BtnStroke, TweenInfo.new(0.25), {Color = Color3.fromRGB(0, 180, 255)}):Play()
    end)

    Btn.MouseLeave:Connect(function()
        TweenService:Create(Btn, TweenInfo.new(0.25), {BackgroundColor3 = Color3.fromRGB(24, 25, 36)}):Play()
        TweenService:Create(BtnStroke, TweenInfo.new(0.25), {Color = Color3.fromRGB(50, 52, 75)}):Play()
    end)

    Btn.MouseButton1Click:Connect(function()
        OpenMainHub(langKey)
    end)
end

CreateAdvancedLangButton("🇹🇷  Türkçe", "TR")
CreateAdvancedLangButton("🇺🇸  English", "EN")
CreateAdvancedLangButton("🇷🇺  Русский", "RU")
