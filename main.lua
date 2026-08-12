-- =================================================================
-- UGUZHUB V2 PRO | GÜNCELLENMİŞ BUTON GÖRSELLERİ İLE
-- =================================================================
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local LocalPlayer = Players.LocalPlayer

-- Arka Plan Görsel ID'si
local BACKGROUND_ASSET_ID = "rbxassetid://92104233904415"

-- [Daha önceki dil tanımlamaları aynı kalıyor...]
local Translations = {
    TR = { Title = "UguzHub V2 Pro", Loading = "Yükleniyor...", Main = "Ana Sayfa", AutoFarm = "Oto Farm", Combat = "Savaş", Troll = "Troll", Extra = "Ekstralar", Settings = "Ayarlar", Greeting = "Bugün nasılsın, ", PlayerInfo = "Profil", EspToggle = "ESP", FarmToggle = "Oto Sikke", SilentAimToggle = "Silent Aim", LockSheriff = "Şerife Kilitlen", LockMurderer = "Katile Kilitlen", WalkSpeed = "Hız", FlyToggle = "Uçma", FlingToggle = "Fling", C4Item = "Bomba", Emotes = "Emoteler", LangSelected = "Dil Türkçe!" },
    EN = { Title = "UguzHub V2 Pro", Loading = "Loading...", Main = "Main", AutoFarm = "Auto Farm", Combat = "Combat", Troll = "Troll", Extra = "Extras", Settings = "Settings", Greeting = "How are you, ", PlayerInfo = "Profile", EspToggle = "ESP", FarmToggle = "Auto Coin", SilentAimToggle = "Silent Aim", LockSheriff = "Lock Sheriff", LockMurderer = "Lock Murderer", WalkSpeed = "Speed", FlyToggle = "Fly", FlingToggle = "Fling", C4Item = "Bomb", Emotes = "Emotes", LangSelected = "Language English!" },
    RU = { Title = "UguzHub V2 Pro", Loading = "Загрузка...", Main = "Главная", AutoFarm = "Авто-Фарм", Combat = "Бой", Troll = "Тролль", Extra = "Доп.", Settings = "Настройки", Greeting = "Привет, ", PlayerInfo = "Профиль", EspToggle = "ESP", FarmToggle = "Авто-Сбор", SilentAimToggle = "Silent Aim", LockSheriff = "Захват Шерифа", LockMurderer = "Захват Убийцы", WalkSpeed = "Скорость", FlyToggle = "Полет", FlingToggle = "Флинг", C4Item = "Бомба", Emotes = "Эмоции", LangSelected = "Язык Русский!" }
}

-- [Açılış ekranı kodları aynı kalıyor...]
-- (Kodu kısaltmak için giriş arayüzü kısmını geçiyorum, önceki kodun aynısıdır)

-- GÜNCELLENMİŞ BUTON FONKSİYONU
local function CreateLangButton(text, langKey)
    local Btn = Instance.new("TextButton")
    Btn.Size = UDim2.new(1, 0, 0, 40)
    Btn.BackgroundColor3 = Color3.fromRGB(30, 32, 45)
    Btn.Text = text
    Btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    Btn.TextSize = 16
    Btn.Font = Enum.Font.GothamBold
    Btn.AutoButtonColor = true
    Btn.ClipsDescendants = true -- Resmin dışarı taşmasını engeller
    Btn.Parent = ButtonHolder

    local BtnCorner = Instance.new("UICorner")
    BtnCorner.CornerRadius = UDim.new(0, 8)
    BtnCorner.Parent = Btn

    -- BUTON İÇİNDEKİ RESİM
    local ButtonImage = Instance.new("ImageLabel")
    ButtonImage.Name = "ButtonBg"
    ButtonImage.Size = UDim2.new(1, 0, 1, 0)
    ButtonImage.BackgroundTransparency = 1
    ButtonImage.Image = BACKGROUND_ASSET_ID
    ButtonImage.ImageTransparency = 0.3 -- Yazının okunması için biraz kararttık
    ButtonImage.ScaleType = Enum.ScaleType.Crop
    ButtonImage.ZIndex = 0 -- Yazının arkasında kalması için
    ButtonImage.Parent = Btn

    Btn.MouseButton1Click:Connect(function()
        InitializeHub(langKey)
    end)
end

-- [Geri kalan fonksiyonlar ve InitializeHub aynı kalıyor...]
