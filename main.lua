local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- Çeviri Sözlüğü (8 Dil - Resmi Dil Kullanımı)
local Translations = {
    TR = {
        title = "UguzHub - Yönetim Paneli",
        delta_title = "Sistem Bilgilendirmesi",
        delta_msg = "Sizlere daha kaliteli ve kesintisiz bir hizmet sunabilmemiz adına, lütfen Delta uygulamasının ayarlarında yer alan kısıtlayıcı izinleri kapattığınızdan emin olunuz.",
        confirm_close = "Uygulamayı kapatmak istediğinize emin misiniz?",
        yes = "Evet",
        no = "Hayır",
        continue = "Devam Et",
        greetings = {"Bugün nasılsınız?", "Gününüz nasıl geçiyor?", "Hoş geldiniz.", "Sisteme erişim sağlandı."},
        discord = "Görüş, şikayet ve önerilerinizi resmi Discord sunucumuza katılarak iletebilirsiniz."
    },
    EN = {
        title = "UguzHub - Control Panel",
        delta_title = "System Notification",
        delta_msg = "To provide you with better and uninterrupted service, please make sure you have disabled the restrictive permissions in Delta settings.",
        confirm_close = "Are you sure you want to close the application?",
        yes = "Yes",
        no = "No",
        continue = "Continue",
        greetings = {"How are you today?", "How is your day going?", "Welcome.", "System access granted."},
        discord = "You can submit your feedback, complaints, and suggestions by joining our official Discord server."
    },
    ES = {
        title = "UguzHub - Panel de Control",
        delta_title = "Notificación del Sistema",
        delta_msg = "Para brindarle un servicio de mejor calidad y sin interrupciones, asegúrese de haber desactivado los permisos restrictivos en la configuración de Delta.",
        confirm_close = "¿Está seguro de que desea cerrar la aplicación?",
        yes = "Sí",
        no = "No",
        continue = "Continuar",
        greetings = {"¿Cómo está hoy?", "¿Cómo va su día?", "Bienvenido.", "Acceso al sistema concedido."},
        discord = "Puede enviar sus comentarios, quejas y sugerencias uniéndose a nuestro servidor oficial de Discord."
    },
    DE = {
        title = "UguzHub - Kontrollzentrum",
        delta_title = "Systembenachrichtigung",
        delta_msg = "Um Ihnen einen besseren und unterbrechungsfreien Service zu bieten, stellen Sie bitte sicher, dass Sie die einschränkenden Berechtigungen in den Delta-Einstellungen deaktiviert haben.",
        confirm_close = "Sind Sie sicher, dass Sie die Anwendung schließen möchten?",
        yes = "Ja",
        no = "Nein",
        continue = "Fortfahren",
        greetings = {"Wie geht es Ihnen heute?", "Wie verläuft Ihr Tag?", "Willkommen.", "Systemzugriff gewährt."},
        discord = "Sie können Ihr Feedback, Ihre Beschwerden und Vorschläge einreichen, indem Sie unserem offiziellen Discord-Server beitreten."
    },
    FR = {
        title = "UguzHub - Panneau de Contrôle",
        delta_title = "Notification Système",
        delta_msg = "Afin de vous fournir un service de meilleure qualité et sans interruption, veuillez vous assurer d'avoir désactivé les autorisations restrictives dans les paramètres de Delta.",
        confirm_close = "Êtes-vous sûr de vouloir fermer l'application?",
        yes = "Oui",
        no = "Non",
        continue = "Continuer",
        greetings = {"Comment allez-vous aujourd'hui?", "Comment se passe votre journée?", "Bienvenue.", "Accès au système accordé."},
        discord = "Vous pouvez soumettre vos remarques, réclamations et suggestions en rejoignant notre serveur Discord officiel."
    },
    RU = {
        title = "UguzHub - Панель управления",
        delta_title = "Системное уведомление",
        delta_msg = "Чтобы мы могли предоставить вам более качественный и бесперебойный сервис, убедитесь, что вы отключили ограничительные разрешения в настройках Delta.",
        confirm_close = "Вы уверены, что хотите закрыть приложение?",
        yes = "Да",
        no = "Нет",
        continue = "Продолжить",
        greetings = {"Как ваши дела сегодня?", "Как проходит ваш день?", "Добро пожаловать.", "Доступ к системе разрешен."},
        discord = "Вы можете отправить свои отзывы, жалобы и предложения, присоединившись к нашему официальному серверу Discord."
    },
    PT = {
        title = "UguzHub - Painel de Controle",
        delta_title = "Notificação do Sistema",
        delta_msg = "Para que possamos oferecer um serviço de melhor qualidade e sem interrupções, certifique-se de ter desativado as permissões restritivas nas configurações do Delta.",
        confirm_close = "Tem certeza de que deseja fechar o aplicativo?",
        yes = "Sim",
        no = "Não",
        continue = "Continuar",
        greetings = {"Como você está hoje?", "Como está sendo seu dia?", "Bem-vindo.", "Acesso ao sistema concedido."},
        discord = "Você pode enviar seus comentários, reclamações e sugestões entrando em nosso servidor oficial do Discord."
    },
    AR = {
        title = "UguzHub - لوحة التحكم",
        delta_title = "إشعار النظام",
        delta_msg = "من أجل تقديم خدمة أفضل ودون انقطاع، يرجى التأكد من تعطيل الأذونات المقيدة في إعدادات تطبيق Delta.",
        confirm_close = "هل أنت تأكد من أنك تريد إغلاق التطبيق؟",
        yes = "نعم",
        no = "لا",
        continue = "متابعة",
        greetings = {"كيف حالك اليوم؟", "كيف يسير يومك؟", "أهلاً بك.", "تم منح الوصول إلى النظام."},
        discord = "يمكنك تقديم ملاحظاتك وشكواك واقتراحاتك من خلال الانضمام إلى خادم Discord الرسمي الخاص بنا."
    }
}

local CurrentLang = "TR"

-- Eski UI Temizliği
if PlayerGui:FindFirstChild("UguzHubUI") then
    PlayerGui.UguzHubUI:Destroy()
end

-- ScreenGui
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "UguzHubUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = PlayerGui

-- Sürüklenebilirlik Fonksiyonu
local function makeDraggable(frame, handle)
    handle = handle or frame
    local dragging, dragInput, dragStart, startPos
    handle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then dragging = false end
            end)
        end
    end)
    handle.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
end

---------------------------------------------------------
-- 1. ANİMASYONLU GİRİŞ EKRANI (SPLASH SCREEN)
---------------------------------------------------------
local SplashFrame = Instance.new("Frame", ScreenGui)
SplashFrame.Size = UDim2.new(1, 0, 1, 0)
SplashFrame.BackgroundColor3 = Color3.fromRGB(12, 12, 16)
SplashFrame.ZIndex = 100

local SplashLogo = Instance.new("TextLabel", SplashFrame)
SplashLogo.Size = UDim2.new(0, 300, 0, 50)
SplashLogo.Position = UDim2.new(0.5, -150, 0.4, -25)
SplashLogo.Text = "UGUZHUB"
SplashLogo.TextColor3 = Color3.fromRGB(140, 80, 255)
SplashLogo.TextSize = 38
SplashLogo.Font = Enum.Font.GothamBold
SplashLogo.BackgroundTransparency = 1

local BarBackground = Instance.new("Frame", SplashFrame)
BarBackground.Size = UDim2.new(0, 260, 0, 6)
BarBackground.Position = UDim2.new(0.5, -130, 0.5, 20)
BarBackground.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
BarBackground.BorderSizePixel = 0
Instance.new("UICorner", BarBackground).CornerRadius = UDim.new(1, 0)

local BarFill = Instance.new("Frame", BarBackground)
BarFill.Size = UDim2.new(0, 0, 1, 0)
BarFill.BackgroundColor3 = Color3.fromRGB(140, 80, 255)
BarFill.BorderSizePixel = 0
Instance.new("UICorner", BarFill).CornerRadius = UDim.new(1, 0)

---------------------------------------------------------
-- 2. ANA PENCERE VE AÇMA/KAPAMA LOGOSU
---------------------------------------------------------
local ToggleButton = Instance.new("ImageButton", ScreenGui)
ToggleButton.Name = "ToggleButton"
ToggleButton.Size = UDim2.new(0, 45, 0, 45)
ToggleButton.Position = UDim2.new(0.5, -22, 0, 15)
ToggleButton.BackgroundColor3 = Color3.fromRGB(22, 22, 28)
ToggleButton.Image = "rbxassetid://1000094166"
ToggleButton.Visible = false
Instance.new("UICorner", ToggleButton).CornerRadius = UDim.new(0, 10)
local ToggleStroke = Instance.new("UIStroke", ToggleButton)
ToggleStroke.Color = Color3.fromRGB(140, 80, 255)
ToggleStroke.Thickness = 1.5
makeDraggable(ToggleButton)

local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 480, 0, 310)
MainFrame.Position = UDim2.new(0.5, -240, 0.5, -155)
MainFrame.BackgroundColor3 = Color3.fromRGB(16, 16, 20)
MainFrame.BorderSizePixel = 0
MainFrame.Visible = false
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 10)
local MainStroke = Instance.new("UIStroke", MainFrame)
MainStroke.Color = Color3.fromRGB(90, 50, 180)
MainStroke.Thickness = 1.5
makeDraggable(MainFrame)

-- Üst Bar (Header)
local Header = Instance.new("Frame", MainFrame)
Header.Size = UDim2.new(1, 0, 0, 40)
Header.BackgroundColor3 = Color3.fromRGB(22, 22, 28)
Header.BorderSizePixel = 0
Instance.new("UICorner", Header).CornerRadius = UDim.new(0, 10)

local TitleLabel = Instance.new("TextLabel", Header)
TitleLabel.Size = UDim2.new(1, -90, 1, 0)
TitleLabel.Position = UDim2.new(0, 15, 0, 0)
TitleLabel.Text = "UguzHub"
TitleLabel.TextColor3 = Color3.fromRGB(240, 240, 240)
TitleLabel.TextSize = 15
TitleLabel.Font = Enum.Font.SourceSansBold
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
TitleLabel.BackgroundTransparency = 1

local MinimizeBtn = Instance.new("TextButton", Header)
MinimizeBtn.Size = UDim2.new(0, 28, 0, 28)
MinimizeBtn.Position = UDim2.new(1, -65, 0, 6)
MinimizeBtn.Text = "-"
MinimizeBtn.TextSize = 20
MinimizeBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
MinimizeBtn.BackgroundColor3 = Color3.fromRGB(32, 32, 42)
MinimizeBtn.Font = Enum.Font.SourceSansBold
Instance.new("UICorner", MinimizeBtn).CornerRadius = UDim.new(0, 6)

local CloseBtn = Instance.new("TextButton", Header)
CloseBtn.Size = UDim2.new(0, 28, 0, 28)
CloseBtn.Position = UDim2.new(1, -33, 0, 6)
CloseBtn.Text = "X"
CloseBtn.TextSize = 14
CloseBtn.TextColor3 = Color3.fromRGB(255, 80, 80)
CloseBtn.BackgroundColor3 = Color3.fromRGB(32, 32, 42)
CloseBtn.Font = Enum.Font.SourceSansBold
Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(0, 6)

---------------------------------------------------------
-- 3. SAYFALAR (DİL, DELTA VE AYARLAR)
---------------------------------------------------------
local LanguagePage = Instance.new("Frame", MainFrame)
LanguagePage.Size = UDim2.new(1, 0, 1, -40)
LanguagePage.Position = UDim2.new(0, 0, 0, 40)
LanguagePage.BackgroundTransparency = 1

local DeltaPage = Instance.new("Frame", MainFrame)
DeltaPage.Size = UDim2.new(1, 0, 1, -40)
DeltaPage.Position = UDim2.new(0, 0, 0, 40)
DeltaPage.BackgroundTransparency = 1
DeltaPage.Visible = false

local SettingsPage = Instance.new("Frame", MainFrame)
SettingsPage.Size = UDim2.new(1, 0, 1, -40)
SettingsPage.Position = UDim2.new(0, 0, 0, 40)
SettingsPage.BackgroundTransparency = 1
SettingsPage.Visible = false

-- Dil Listesi Hazırlığı (4 Sol - 4 Sağ)
local LeftCol = Instance.new("Frame", LanguagePage)
LeftCol.Size = UDim2.new(0.48, -10, 1, -20)
LeftCol.Position = UDim2.new(0, 15, 0, 10)
LeftCol.BackgroundTransparency = 1

local RightCol = Instance.new("Frame", LanguagePage)
RightCol.Size = UDim2.new(0.48, -10, 1, -20)
RightCol.Position = UDim2.new(0.52, 5, 0, 10)
RightCol.BackgroundTransparency = 1

Instance.new("UIListLayout", LeftCol).Padding = UDim.new(0, 6)
Instance.new("UIListLayout", RightCol).Padding = UDim.new(0, 6)

local Languages = {
    Left = {
        {Name = "Türkçe", Flag = "🇹🇷", Code = "TR"},
        {Name = "English", Flag = "🇺🇸", Code = "EN"},
        {Name = "Español", Flag = "🇪🇸", Code = "ES"},
        {Name = "Deutsch", Flag = "🇩🇪", Code = "DE"}
    },
    Right = {
        {Name = "Français", Flag = "🇫🇷", Code = "FR"},
        {Name = "Русский", Flag = "🇷🇺", Code = "RU"},
        {Name = "Português", Flag = "🇵🇹", Code = "PT"},
        {Name = "العربية", Flag = "🇸🇦", Code = "AR"}
    }
}

-- Delta Uyarısı Elemanları
local DeltaTitle = Instance.new("TextLabel", DeltaPage)
DeltaTitle.Size = UDim2.new(1, -30, 0, 30)
DeltaTitle.Position = UDim2.new(0, 15, 0, 15)
DeltaTitle.TextColor3 = Color3.fromRGB(255, 180, 60)
DeltaTitle.TextSize = 18
DeltaTitle.Font = Enum.Font.SourceSansBold
DeltaTitle.TextXAlignment = Enum.TextXAlignment.Left
DeltaTitle.BackgroundTransparency = 1

local DeltaMsg = Instance.new("TextLabel", DeltaPage)
DeltaMsg.Size = UDim2.new(1, -30, 0, 110)
DeltaMsg.Position = UDim2.new(0, 15, 0, 50)
DeltaMsg.BackgroundColor3 = Color3.fromRGB(22, 22, 30)
DeltaMsg.TextColor3 = Color3.fromRGB(220, 220, 230)
DeltaMsg.TextSize = 14
DeltaMsg.Font = Enum.Font.SourceSans
DeltaMsg.TextWrapped = true
DeltaMsg.PaddingLeft = UDim.new(0, 12)
DeltaMsg.PaddingRight = UDim.new(0, 12)
Instance.new("UICorner", DeltaMsg).CornerRadius = UDim.new(0, 8)

local DeltaContinueBtn = Instance.new("TextButton", DeltaPage)
DeltaContinueBtn.Size = UDim2.new(0, 140, 0, 35)
DeltaContinueBtn.Position = UDim2.new(0.5, -70, 0, 180)
DeltaContinueBtn.BackgroundColor3 = Color3.fromRGB(110, 60, 210)
DeltaContinueBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
DeltaContinueBtn.Font = Enum.Font.SourceSansBold
DeltaContinueBtn.TextSize = 15
Instance.new("UICorner", DeltaContinueBtn).CornerRadius = UDim.new(0, 8)

-- Ayarlar Sayfası Elemanları
local ProfileImage = Instance.new("ImageLabel", SettingsPage)
ProfileImage.Size = UDim2.new(0, 55, 0, 55)
ProfileImage.Position = UDim2.new(1, -70, 0, 15)
ProfileImage.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
Instance.new("UICorner", ProfileImage).CornerRadius = UDim.new(1, 0)

pcall(function()
    local content = Players:GetUserThumbnailAsync(LocalPlayer.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size100x100)
    ProfileImage.Image = content
end)

local UserNameLabel = Instance.new("TextLabel", SettingsPage)
UserNameLabel.Size = UDim2.new(0, 320, 0, 22)
UserNameLabel.Position = UDim2.new(0, 15, 0, 15)
UserNameLabel.Text = LocalPlayer.DisplayName .. " (@" .. LocalPlayer.Name .. ")"
UserNameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
UserNameLabel.TextSize = 17
UserNameLabel.Font = Enum.Font.SourceSansBold
UserNameLabel.TextXAlignment = Enum.TextXAlignment.Left
UserNameLabel.BackgroundTransparency = 1

local GreetingLabel = Instance.new("TextLabel", SettingsPage)
GreetingLabel.Size = UDim2.new(0, 320, 0, 20)
GreetingLabel.Position = UDim2.new(0, 15, 0, 40)
GreetingLabel.TextColor3 = Color3.fromRGB(170, 170, 190)
GreetingLabel.TextSize = 14
GreetingLabel.Font = Enum.Font.SourceSansItalic
GreetingLabel.TextXAlignment = Enum.TextXAlignment.Left
GreetingLabel.BackgroundTransparency = 1

local DiscordText = Instance.new("TextLabel", SettingsPage)
DiscordText.Size = UDim2.new(1, -30, 0, 80)
DiscordText.Position = UDim2.new(0, 15, 0, 95)
DiscordText.BackgroundColor3 = Color3.fromRGB(22, 22, 30)
DiscordText.TextColor3 = Color3.fromRGB(210, 210, 225)
DiscordText.TextSize = 14
DiscordText.Font = Enum.Font.SourceSans
DiscordText.TextWrapped = true
DiscordText.PaddingLeft = UDim.new(0, 12)
DiscordText.PaddingRight = UDim.new(0, 12)
Instance.new("UICorner", DiscordText).CornerRadius = UDim.new(0, 8)

---------------------------------------------------------
-- 4. KANAT / ONAY PENCERESİ (EMİN MİSİNİZ?)
---------------------------------------------------------
local ConfirmFrame = Instance.new("Frame", MainFrame)
ConfirmFrame.Size = UDim2.new(1, 0, 1, 0)
ConfirmFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 14)
ConfirmFrame.BackgroundTransparency = 0.05
ConfirmFrame.Visible = false
ConfirmFrame.ZIndex = 20
Instance.new("UICorner", ConfirmFrame).CornerRadius = UDim.new(0, 10)

local ConfirmText = Instance.new("TextLabel", ConfirmFrame)
ConfirmText.Size = UDim2.new(1, -40, 0, 50)
ConfirmText.Position = UDim2.new(0, 20, 0.3, -25)
ConfirmText.TextColor3 = Color3.fromRGB(255, 255, 255)
ConfirmText.TextSize = 16
ConfirmText.Font = Enum.Font.SourceSansBold
ConfirmText.TextWrapped = true
ConfirmText.BackgroundTransparency = 1

local YesBtn = Instance.new("TextButton", ConfirmFrame)
YesBtn.Size = UDim2.new(0, 110, 0, 35)
YesBtn.Position = UDim2.new(0.5, -120, 0.65, 0)
YesBtn.BackgroundColor3 = Color3.fromRGB(190, 45, 45)
YesBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
YesBtn.Font = Enum.Font.SourceSansBold
YesBtn.TextSize = 15
Instance.new("UICorner", YesBtn).CornerRadius = UDim.new(0, 6)

local NoBtn = Instance.new("TextButton", ConfirmFrame)
NoBtn.Size = UDim2.new(0, 110, 0, 35)
NoBtn.Position = UDim2.new(0.5, 10, 0.65, 0)
NoBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 65)
NoBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
NoBtn.Font = Enum.Font.SourceSansBold
NoBtn.TextSize = 15
Instance.new("UICorner", NoBtn).CornerRadius = UDim.new(0, 6)

---------------------------------------------------------
-- 5. MANTIK VE ETKİLEŞİMLER
---------------------------------------------------------
local function selectLanguage(code)
    CurrentLang = code
    local data = Translations[code] or Translations.TR
    
    -- Delta Ekranı Güncelle
    DeltaTitle.Text = data.delta_title
    DeltaMsg.Text = data.delta_msg
    DeltaContinueBtn.Text = data.continue
    
    LanguagePage.Visible = false
    DeltaPage.Visible = true
end

DeltaContinueBtn.MouseButton1Click:Connect(function()
    local data = Translations[CurrentLang] or Translations.TR
    TitleLabel.Text = data.title
    
    local randomGreeting = data.greetings[math.random(1, #data.greetings)]
    GreetingLabel.Text = randomGreeting
    DiscordText.Text = data.discord
    
    YesBtn.Text = data.yes
    NoBtn.Text = data.no
    
    DeltaPage.Visible = false
    SettingsPage.Visible = true
end)

local function buildLangButtons(list, parent)
    for _, item in ipairs(list) do
        local btn = Instance.new("TextButton", parent)
        btn.Size = UDim2.new(1, 0, 0, 45)
        btn.BackgroundColor3 = Color3.fromRGB(24, 24, 32)
        btn.Text = item.Flag .. "  " .. item.Name
        btn.TextColor3 = Color3.fromRGB(230, 230, 240)
        btn.TextSize = 15
        btn.Font = Enum.Font.SourceSansBold
        Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)
        
        local bStroke = Instance.new("UIStroke", btn)
        bStroke.Color = Color3.fromRGB(45, 45, 60)
        
        btn.MouseButton1Click:Connect(function()
            selectLanguage(item.Code)
        end)
    end
end

buildLangButtons(Languages.Left, LeftCol)
buildLangButtons(Languages.Right, RightCol)

-- Küçültme & Açma
MinimizeBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = false
    ToggleButton.Visible = true
end)

ToggleButton.MouseButton1Click:Connect(function()
    MainFrame.Visible = true
    ToggleButton.Visible = false
end)

-- Kapatma Dialog
CloseBtn.MouseButton1Click:Connect(function()
    local data = Translations[CurrentLang] or Translations.TR
    ConfirmText.Text = data.confirm_close
    ConfirmFrame.Visible = true
end)

NoBtn.MouseButton1Click:Connect(function()
    ConfirmFrame.Visible = false
end)

YesBtn.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

---------------------------------------------------------
-- ANİMASYON AÇILIŞI (SPLASH SÜRECİ)
---------------------------------------------------------
task.spawn(function()
    local fillTween = TweenService:Create(BarFill, TweenInfo.new(1.8, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.new(1, 0, 1, 0)})
    fillTween:Play()
    fillTween.Completed:Wait()
    
    task.wait(0.2)
    local fadeTween = TweenService:Create(SplashFrame, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundTransparency = 1})
    TweenService:Create(SplashLogo, TweenInfo.new(0.4), {TextTransparency = 1}):Play()
    TweenService:Create(BarBackground, TweenInfo.new(0.4), {BackgroundTransparency = 1}):Play()
    TweenService:Create(BarFill, TweenInfo.new(0.4), {BackgroundTransparency = 1}):Play()
    
    fadeTween:Play()
    fadeTween.Completed:Wait()
    
    SplashFrame:Destroy()
    MainFrame.Visible = true
    end
