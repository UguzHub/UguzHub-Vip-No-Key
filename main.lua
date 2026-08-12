-- =================================================================
-- UGUZHUB V2 PRO | DEFINITIVE BACKGROUND FIX
-- =================================================================
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local LocalPlayer = Players.LocalPlayer

local INTRO_BG_ID = "rbxassetid://15732257423" 
local MENU_BG_ID = "rbxassetid://10830725683"

local Translations = {
    TR = { Title = "UguzHub V2 Pro", Loading = "Yükleniyor...", Main = "Ana Sayfa", AutoFarm = "Oto Farm", Combat = "Savaş & Aim", Troll = "Troll", Extra = "Ekstralar", Settings = "Ayarlar", Greeting = "Bugün nasılsın, ", PlayerInfo = "Profil" },
    EN = { Title = "UguzHub V2 Pro", Loading = "Loading...", Main = "Main", AutoFarm = "Auto Farm", Combat = "Combat", Troll = "Troll", Extra = "Extras", Settings = "Settings", Greeting = "How are you, ", PlayerInfo = "Profile" },
    RU = { Title = "UguzHub V2 Pro", Loading = "Загрузка...", Main = "Главная", AutoFarm = "Авто-Фарм", Combat = "Бой", Troll = "Тролль", Extra = "Доп.", Settings = "Настройки", Greeting = "Привет, ", PlayerInfo = "Профиль" }
}

if CoreGui:FindFirstChild("UguzIntroGui") then CoreGui.UguzIntroGui:Destroy() end
if CoreGui:FindFirstChild("UguzGlobalBg") then CoreGui.UguzGlobalBg:Destroy() end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "UguzIntroGui"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = CoreGui

local BackgroundImage = Instance.new("ImageLabel")
BackgroundImage.Size = UDim2.new(1, 0, 1, 0)
BackgroundImage.BackgroundColor3 = Color3.fromRGB(5, 5, 8)
BackgroundImage.Image = INTRO_BG_ID
BackgroundImage.ImageTransparency = 0.25
BackgroundImage.ScaleType = Enum.ScaleType.Crop
BackgroundImage.Parent = ScreenGui

local DarkOverlay = Instance.new("Frame")
DarkOverlay.Size = UDim2.new(1, 0, 1, 0)
DarkOverlay.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
DarkOverlay.BackgroundTransparency = 0.4
DarkOverlay.Parent = BackgroundImage

local MainContainer = Instance.new("Frame")
MainContainer.Size = UDim2.new(0, 450, 0, 320)
MainContainer.Position = UDim2.new(0.5, 0, 0.5, 0)
MainContainer.AnchorPoint = Vector2.new(0.5, 0.5)
MainContainer.BackgroundColor3 = Color3.fromRGB(12, 12, 16)
MainContainer.BorderSizePixel = 0
MainContainer.Parent = ScreenGui

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 14)
UICorner.Parent = MainContainer

local UIStroke = Instance.new("UIStroke")
UIStroke.Color = Color3.fromRGB(30, 30, 40)
UIStroke.Thickness = 1.5
UIStroke.Parent = MainContainer

local TitleLabel = Instance.new("TextLabel")
TitleLabel.Size = UDim2.new(1, 0, 0, 50)
TitleLabel.Position = UDim2.new(0, 0, 0, 20)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Text = "UGUZHUB V2 PRO"
TitleLabel.TextColor3 = Color3.fromRGB(240, 240, 245)
TitleLabel.TextSize = 28
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.Parent = MainContainer

local ButtonHolder = Instance.new("Frame")
ButtonHolder.Size = UDim2.new(1, -50, 0, 170)
ButtonHolder.Position = UDim2.new(0, 25, 0, 95)
ButtonHolder.BackgroundTransparency = 1
ButtonHolder.Parent = MainContainer

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.Padding = UDim.new(0, 10)
UIListLayout.Parent = ButtonHolder

local function InitializeHub(langKey)
    local L = Translations[langKey]
    ScreenGui:Destroy()

    -- MENÜ ARKASINDAKİ RESMİ SIFIRDAN OLUŞTUR
    local GlobalBg = Instance.new("ScreenGui")
    GlobalBg.Name = "UguzGlobalBg"
    GlobalBg.DisplayOrder = -999 -- En arkada durur
    GlobalBg.ResetOnSpawn = false
    GlobalBg.Parent = CoreGui

    local BgImage = Instance.new("ImageLabel")
    BgImage.Size = UDim2.new(1, 0, 1, 0)
    BgImage.BackgroundTransparency = 1
    BgImage.Image = MENU_BG_ID
    BgImage.ScaleType = Enum.ScaleType.Crop
    BgImage.Parent = GlobalBg

    local Overlay = Instance.new("Frame")
    Overlay.Size = UDim2.new(1, 0, 1, 0)
    Overlay.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    Overlay.BackgroundTransparency = 0.5 -- Arka plan resminin görünürlüğü
    Overlay.Parent = BgImage

    local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

    local Window = Rayfield:CreateWindow({
        Name = L.Title,
        LoadingTitle = L.Title,
        LoadingSubtitle = "by Uguz",
        ConfigurationSaving = { Enabled = false },
        Discord = { Enabled = false },
        KeySystem = false
    })

    local MainTab = Window:CreateTab(L.Main, 4483362458)
    MainTab:CreateToggle({ Name = "ESP", CurrentValue = false, Callback = function() end })

    local SettingsTab = Window:CreateTab(L.Settings, 4483362458)
    SettingsTab:CreateLabel("👤 " .. LocalPlayer.Name)
    SettingsTab:CreateLabel("✨ " .. L.Greeting .. LocalPlayer.DisplayName .. "!")

    -- RAYFIELD ŞEFFAFLIK AYARI
    task.spawn(function()
        task.wait(0.5)
        pcall(function()
            local rayGui = CoreGui:FindFirstChild("Rayfield") or CoreGui:FindFirstChild("RayfieldGui")
            if rayGui then
                for _, v in pairs(rayGui:GetDescendants()) do
                    if v:IsA("Frame") and v.Name == "Main" then
                        v.BackgroundTransparency = 0.35 -- Rayfield menüsünü transparan yaparak arkadaki resmi gösterir
                    end
                end
            end
        end)
    end)
end

local function CreateLangButton(text, langKey)
    local Btn = Instance.new("TextButton")
    Btn.Size = UDim2.new(1, 0, 0, 42)
    Btn.BackgroundColor3 = Color3.fromRGB(22, 22, 30)
    Btn.Text = text
    Btn.TextColor3 = Color3.fromRGB(220, 220, 230)
    Btn.TextSize = 15
    Btn.Font = Enum.Font.GothamMedium
    Btn.Parent = ButtonHolder

    local BtnCorner = Instance.new("UICorner")
    BtnCorner.CornerRadius = UDim.new(0, 8)
    BtnCorner.Parent = Btn

    local BtnStroke = Instance.new("UIStroke")
    BtnStroke.Color = Color3.fromRGB(40, 40, 55)
    BtnStroke.Thickness = 1
    BtnStroke.Parent = Btn

    Btn.MouseButton1Click:Connect(function()
        InitializeHub(langKey)
    end)
end

CreateLangButton("🇹🇷 Türkçe", "TR")
CreateLangButton("🇺🇸 English", "EN")
CreateLangButton("🇷🇺 Русский", "RU")
