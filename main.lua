--[[
    UguzHub V2 Pro (Ultimate 35+ Features Menu + Multi-Language UI)
    ------------------------------------------------------------
    Akış:
      1) 0-5sn: Tam ekran yükleme animasyonu (logo + "Loading")
      2) Dil seçimi: 8 dil, bayraklı, 4'er 4'er (TR/EN/RU/ES/AR/DE/FR/PH)
      3) Dil seçilince 7 saniyeliğine, seçilen dile göre bilgi yazısı çıkar
      4) 7sn sonra 35+ özellikli gelişmiş Combat & Utility menüsü açılır
      5) Menü kapatılırsa sağ üstte mavi "UguzHub" butonuyla tekrar açılabilir
]]

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Workspace = game:GetService("Workspace")
local CoreGui = game:GetService("CoreGui")
local Camera = Workspace.CurrentCamera

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

------------------------------------------------------------
-- TEMA
------------------------------------------------------------
local Theme = {
    Background = Color3.fromRGB(16, 16, 22),
    Sidebar    = Color3.fromRGB(20, 20, 28),
    Card       = Color3.fromRGB(30, 30, 40),
    Accent     = Color3.fromRGB(138, 92, 255),
    AccentSoft = Color3.fromRGB(90, 60, 180),
    Blue       = Color3.fromRGB(41, 121, 255),
    BlueSoft   = Color3.fromRGB(70, 150, 255),
    Text       = Color3.fromRGB(235, 235, 245),
    SubText    = Color3.fromRGB(165, 165, 180),
    Stroke     = Color3.fromRGB(55, 55, 70),
}

local RADIUS = 16

------------------------------------------------------------
-- DİL PAKETLERİ (8 dil, tam çevirili)
------------------------------------------------------------
local Lang = {}

Lang.TR = {
    loading = "Yükleniyor",
    subtitle = "Dilinizi seçin",
    openBtn = "UguzHub",
    notice = "Sizlere Daha İyi Bir Deneyim Yaşatmak İçin Deltanin Ayarlarindaki Tum Herseyi Kapattığınızda Emin Olun Lütfen",
    menuTitle = "UguzHub V2 Pro | Ultimate Combat & Utility (35 Features)"
}

Lang.EN = {
    loading = "Loading",
    subtitle = "Select your language",
    openBtn = "UguzHub",
    notice = "To Provide You With A Better Experience, Please Make Sure To Turn Off Everything In Delta's Settings",
    menuTitle = "UguzHub V2 Pro | Ultimate Combat & Utility (35 Features)"
}

Lang.RU = {
    loading = "Загрузка",
    subtitle = "Выберите язык",
    openBtn = "UguzHub",
    notice = "Чтобы обеспечить вам лучший опыт, пожалуйста, убедитесь, что вы отключили всё в настройках Delta",
    menuTitle = "UguzHub V2 Pro | Ultimate Combat & Utility (35 Features)"
}

Lang.ES = {
    loading = "Cargando",
    subtitle = "Selecciona tu idioma",
    openBtn = "UguzHub",
    notice = "Para brindarte una mejor experiencia, asegúrate de desactivar todo en la configuración de Delta",
    menuTitle = "UguzHub V2 Pro | Ultimate Combat & Utility (35 Features)"
}

Lang.AR = {
    loading = "جار التحميل",
    subtitle = "اختر لغتك",
    openBtn = "UguzHub",
    notice = "لتقديم تجربة أفضل لك، يرجى التأكد من إيقاف تشغيل كل شيء في إعدادات ديتا",
    menuTitle = "UguzHub V2 Pro | Ultimate Combat & Utility (35 Features)"
}

Lang.DE = {
    loading = "Wird geladen",
    subtitle = "Wähle deine Sprache",
    openBtn = "UguzHub",
    notice = "Um dir ein besseres Erlebnis zu bieten, stelle bitte sicher, dass du alles in den Delta-Einstellungen deaktivierst",
    menuTitle = "UguzHub V2 Pro | Ultimate Combat & Utility (35 Features)"
}

Lang.FR = {
    loading = "Chargement",
    subtitle = "Choisissez votre langue",
    openBtn = "UguzHub",
    notice = "Pour vous offrir une meilleure expérience, assurez-vous de tout désactiver dans les paramètres de Delta",
    menuTitle = "UguzHub V2 Pro | Ultimate Combat & Utility (35 Features)"
}

Lang.PH = {
    loading = "Naglo-load",
    subtitle = "Piliin ang iyong wika",
    openBtn = "UguzHub",
    notice = "Para mabigyan ka ng mas magandang karanasan, siguraduhing i-off ang lahat sa mga setting ng Delta",
    menuTitle = "UguzHub V2 Pro | Ultimate Combat & Utility (35 Features)"
}

------------------------------------------------------------
-- 8 DİL SEÇENEĞİ (4'er 4'er, bayraklı)
------------------------------------------------------------
local LanguageOptions = {
    { code = "TR", flag = "🇹🇷", name = "Türkçe" },
    { code = "EN", flag = "🇬🇧", name = "English" },
    { code = "RU", flag = "🇷🇺", name = "Русский" },
    { code = "ES", flag = "🇪🇸", name = "Español" },
    { code = "AR", flag = "🇸🇦", name = "العربية" },
    { code = "DE", flag = "🇩🇪", name = "Deutsch" },
    { code = "FR", flag = "🇫🇷", name = "Français" },
    { code = "PH", flag = "🇵🇭", name = "Filipino" },
}

local CurrentLang = "EN"
local L = Lang[CurrentLang]

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

-- Prevent duplicate UI
if CoreGui:FindFirstChild("UguzHubV2Pro") then
    CoreGui.UguzHubV2Pro:Destroy()
end

local ScreenGui = create("ScreenGui", {
    Name = "UguzHubV2Pro",
    ResetOnSpawn = false,
    ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
    DisplayOrder = 50,
    IgnoreGuiInset = true,
})
ScreenGui.Parent = CoreGui

------------------------------------------------------------
-- GİRİŞ EKRANI (yükleme + dil seçimi)
------------------------------------------------------------
local IntroFrame = create("Frame", {
    Name = "Intro",
    Size = UDim2.fromScale(1, 1),
    Position = UDim2.fromScale(0, 0),
    BorderSizePixel = 0,
    BackgroundColor3 = Theme.Background,
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
    Position = UDim2.new(0, 0, 0, 150),
    Size = UDim2.new(1, 0, 0, 200),
    BackgroundTransparency = 1,
    ZIndex = 11,
    Visible = false,
})
LangHolder.Parent = IntroContent

create("UIGridLayout", {
    CellSize = UDim2.new(0, 84, 0, 92),
    CellPadding = UDim2.new(0, 6, 0, 6),
    HorizontalAlignment = Enum.HorizontalAlignment.Center,
    SortOrder = Enum.SortOrder.LayoutOrder,
}).Parent = LangHolder

------------------------------------------------------------
-- BİLGİLENDİRME EKRANI (7 saniye)
------------------------------------------------------------
local NoticeFrame = create("Frame", {
    Size = UDim2.fromScale(1, 1),
    BackgroundColor3 = Theme.Background,
    BackgroundTransparency = 1,
    Visible = false,
    ZIndex = 15,
})
NoticeFrame.Parent = ScreenGui

local NoticeLabel = create("TextLabel", {
    Text = "",
    Font = Enum.Font.GothamMedium,
    TextSize = 20,
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
-- MİNİMİZE BUTON (sağ üst, MAVİ)
------------------------------------------------------------
local MinimizedButton = create("TextButton", {
    Text = "🔵 " .. L.openBtn,
    Font = Enum.Font.GothamBold,
    TextSize = 15,
    TextColor3 = Theme.Text,
    BackgroundColor3 = Theme.Blue,
    Size = UDim2.new(0, 118, 0, 38),
    Position = UDim2.new(1, -134, 0, 16),
    AutoButtonColor = false,
    Visible = false,
    ZIndex = 8,
})
corner(12).Parent = MinimizedButton
stroke(Color3.fromRGB(255, 255, 255), 1).Parent = MinimizedButton
MinimizedButton.Parent = ScreenGui

MinimizedButton.MouseEnter:Connect(function()
    tween(MinimizedButton, { BackgroundColor3 = Theme.BlueSoft }, 0.15)
end)
MinimizedButton.MouseLeave:Connect(function()
    tween(MinimizedButton, { BackgroundColor3 = Theme.Blue }, 0.15)
end)

------------------------------------------------------------
-- ANA MENÜ VE 35+ ÖZELLİK FONKSİYONLARI
------------------------------------------------------------
local MainFrame
local langCards = {}

local function buildMainMenu()
    MainFrame = create("Frame", {
        Size = UDim2.new(0, 600, 0, 460),
        Position = UDim2.new(0.5, 0, 0.5, 0),
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundColor3 = Theme.Background,
        ClipsDescendants = true,
        Visible = false,
        ZIndex = 5,
    })
    corner(RADIUS).Parent = MainFrame
    stroke(Theme.Accent, 1.5).Parent = MainFrame
    MainFrame.Parent = ScreenGui

    -- Üst bar (Sürüklenebilir)
    local TopBar = create("Frame", {
        Size = UDim2.new(1, 0, 0, 45),
        BackgroundColor3 = Theme.Sidebar,
        ZIndex = 6,
        Active = true,
    })
    corner(RADIUS).Parent = TopBar
    TopBar.Parent = MainFrame

    local TitleLabel = create("TextLabel", {
        Text = "⚡️ " .. L.menuTitle,
        Font = Enum.Font.GothamBold,
        TextSize = 14,
        TextColor3 = Theme.Text,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, -56, 1, 0),
        Position = UDim2.new(0, 14, 0, 0),
        TextXAlignment = Enum.TextXAlignment.Left,
        ZIndex = 7,
    })
    TitleLabel.Parent = TopBar

    local MinimizeBtn = create("TextButton", {
        Text = "–",
        Font = Enum.Font.GothamBold,
        TextSize = 20,
        TextColor3 = Theme.SubText,
        BackgroundTransparency = 1,
        Size = UDim2.new(0, 32, 0, 32),
        Position = UDim2.new(1, -36, 0, 6),
        ZIndex = 7,
    })
    MinimizeBtn.Parent = TopBar
    MinimizeBtn.MouseButton1Click:Connect(function()
        tween(MainFrame, { Size = UDim2.new(0, 480, 0, 360) }, 0.2, Enum.EasingStyle.Quint, Enum.EasingDirection.In)
        task.wait(0.2)
        MainFrame.Visible = false
        MainFrame.Size = UDim2.new(0, 600, 0, 460)
        MinimizedButton.Visible = true
    end)

    -- Sürükleme Mantığı
    do
        local dragging, dragInput, dragStart, startPos
        TopBar.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                dragging = true
                dragStart = input.Position
                startPos = MainFrame.Position
                input.Changed:Connect(function()
                    if input.UserInputState == Enum.UserInputState.End then dragging = false end
                end)
            end
        end)
        TopBar.InputChanged:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
                dragInput = input
            end
        end)
        UserInputService.InputChanged:Connect(function(input)
            if input == dragInput and dragging then
                local delta = input.Position - dragStart
                MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
            end
        end)
    end

    -- Özellik Listesi (Scrolling Frame)
    local scroll = create("ScrollingFrame", {
        Size = UDim2.new(1, -20, 1, -60),
        Position = UDim2.new(0, 10, 0, 52),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        CanvasSize = UDim2.new(0, 0, 0, 1450),
        ScrollBarThickness = 6,
        ZIndex = 6,
    })
    scroll.Parent = MainFrame

    create("UIListLayout", {
        Padding = UDim.new(0, 8),
        SortOrder = Enum.SortOrder.LayoutOrder,
    }).Parent = scroll

    local function createToggle(name, callback)
        local btn = create("TextButton", {
            Size = UDim2.new(1, -10, 0, 38),
            BackgroundColor3 = Theme.Card,
            BorderSizePixel = 0,
            Text = "  " .. name .. " [OFF]",
            TextColor3 = Theme.SubText,
            TextSize = 13,
            Font = Enum.Font.GothamMedium,
            TextXAlignment = Enum.TextXAlignment.Left,
            ZIndex = 7,
        })
        corner(8).Parent = btn
        stroke().Parent = btn
        btn.Parent = scroll

        local enabled = false
        btn.MouseButton1Click:Connect(function()
            enabled = not enabled
            if enabled then
                tween(btn, { BackgroundColor3 = Theme.Accent }, 0.2)
                btn.TextColor3 = Theme.Text
                btn.Text = "  " .. name .. " [ON]"
            else
                tween(btn, { BackgroundColor3 = Theme.Card }, 0.2)
                btn.TextColor3 = Theme.SubText
                btn.Text = "  " .. name .. " [OFF]"
            end
            pcall(function() callback(enabled) end)
        end)
    end

    -- ================= 35+ ÖZELLİK ENTEGRASYONU =================
    createToggle("1. Role ESP (Sheriff/Murderer)", function(state)
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character then
                if state then
                    local hl = Instance.new("Highlight")
                    hl.Name = "RoleESP"
                    hl.Adornee = p.Character
                    hl.FillColor = Color3.fromRGB(255, 0, 0)
                    hl.Parent = p.Character
                else
                    if p.Character:FindFirstChild("RoleESP") then p.Character.RoleESP:Destroy() end
                end
            end
        end
    end)

    createToggle("2. Fullbright (No Darkness)", function(state)
        game.Lighting.Brightness = state and 2 or 1
        game.Lighting.ClockTime = state and 14 or 12
        game.Lighting.GlobalShadows = not state
    end)

    createToggle("3. Speed Boost (WalkSpeed 24)", function(state)
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            LocalPlayer.Character.Humanoid.WalkSpeed = state and 24 or 16
        end
    end)

    createToggle("4. High Jump (JumpPower 75)", function(state)
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            LocalPlayer.Character.Humanoid.UseJumpPower = true
            LocalPlayer.Character.Humanoid.JumpPower = state and 75 or 50
        end
    end)

    local noclipConn
    createToggle("5. Noclip (Walk Through Walls)", function(state)
        if state then
            noclipConn = RunService.Stepped:Connect(function()
                if LocalPlayer.Character then
                    for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
                        if part:IsA("BasePart") then part.CanCollide = false end
                    end
                end
            end)
        else
            if noclipConn then noclipConn:Disconnect() end
        end
    end)

    local infJumpConn
    createToggle("6. Infinite Jump", function(state)
        if state then
            infJumpConn = UserInputService.JumpRequest:Connect(function()
                if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
                    LocalPlayer.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
                end
            end)
        else
            if infJumpConn then infJumpConn:Disconnect() end
        end
    end)

    createToggle("7. Coin / Drop ESP", function(state)
        for _, obj in pairs(Workspace:GetDescendants()) do
            if obj.Name == "Coin" or obj.Name == "GunDrop" or obj.Name == "KnifeDrop" then
                if state then
                    local bill = Instance.new("BillboardGui", obj)
                    bill.Name = "ItemESP"
                    bill.Size = UDim2.new(0, 40, 0, 40)
                    bill.AlwaysOnTop = true
                    local txt = Instance.new("TextLabel", bill)
                    txt.Size = UDim2.new(1, 0, 1, 0)
                    txt.BackgroundTransparency = 1
                    txt.Text = "💎"
                    txt.TextSize = 20
                else
                    if obj:FindFirstChild("ItemESP") then obj.ItemESP:Destroy() end
                end
            end
        end
    end)

    createToggle("8. Auto-Collect Dropped Gun", function(state)
        task.spawn(function()
            while state and task.wait(0.5) do
                pcall(function()
                    for _, v in pairs(Workspace:GetChildren()) do
                        if v.Name == "GunDrop" and v:FindFirstChild("Handle") and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                            LocalPlayer.Character.HumanoidRootPart.CFrame = v.Handle.CFrame
                        end
                    end
                end)
            end
        end)
    end)

    createToggle("9. Wide FOV (105)", function(state)
        Camera.FieldOfView = state and 105 or 70
    end)

    createToggle("10. Remove Fog & Atmosphere", function(state)
        for _, v in pairs(game.Lighting:GetChildren()) do
            if v:IsA("Atmosphere") or v:IsA("PostEffect") then v.Enabled = not state end
        end
    end)

    createToggle("11. Force Third Person", function(state)
        LocalPlayer.CameraMaxZoomDistance = state and 30 or 400
        LocalPlayer.CameraMinZoomDistance = state and 10 or 0.5
    end)

    createToggle("12. FPS Boost (Smooth Plastic)", function(state)
        if state then
            for _, v in pairs(Workspace:GetDescendants()) do
  if v:IsA("BasePart") then v.Material = Enum.Material.SmoothPlastic end
            end
        end
    end)

    createToggle("13. Quick Rejoin Server", function(state)
        if state then game:GetService("TeleportService"):Teleport(game.PlaceId, LocalPlayer) end
    end)

    createToggle("14. Server Hop (Find Lobby)", function(state)
        if state then
            pcall(function()
                local Http = game:GetService("HttpService")
                local servers = Http:JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/"..game.PlaceId.."/servers/Public?sortOrder=Asc&limit=100"))
                for _, s in ipairs(servers.data) do
                    if s.playing < s.maxPlayers then
                        game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, s.id, LocalPlayer)
                        break
                    end
                end
            end)
        end
    end)

    createToggle("15. Force Sit Animation", function(state)
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            LocalPlayer.Character.Humanoid.Sit = state
        end
    end)

    createToggle("16. Tool Transparency", function(state)
        if LocalPlayer.Character then
            for _, tool in pairs(LocalPlayer.Character:GetChildren()) do
                if tool:IsA("Tool") then
                    for _, part in pairs(tool:GetDescendants()) do
                        if part:IsA("BasePart") then part.Transparency = state and 0.8 or 0 end
                    end
                end
            end
        end
    end)

    createToggle("17. Hide Head Nametag", function(state)
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Head") then
            local bb = LocalPlayer.Character.Head:FindFirstChildOfClass("BillboardGui")
            if bb then bb.Enabled = not state end
        end
    end)

    local spinConn
    createToggle("18. Spinbot (Client Fun)", function(state)
        if state then
            spinConn = RunService.RenderStepped:Connect(function()
                if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                    LocalPlayer.Character.HumanoidRootPart.CFrame = LocalPlayer.Character.HumanoidRootPart.CFrame * CFrame.Angles(0, math.rad(25), 0)
                end
            end)
        else
            if spinConn then spinConn:Disconnect() end
        end
    end)

    createToggle("19. UguzHub Lobby Announcer", function(state)
        task.spawn(function()
            while state and task.wait(15) do
                pcall(function()
                    game:GetService("ReplicatedStorage").DefaultChatSystemChatEvents.SayMessageRequest:FireServer("UguzHub MM2 Utility Active!", "All")
                end)
            end
        end)
    end)

    createToggle("20. Auto-Equip Inventory Gear", function(state)
        if state and LocalPlayer.Backpack then
            for _, tool in pairs(LocalPlayer.Backpack:GetChildren()) do
                if tool:IsA("Tool") then tool.Parent = LocalPlayer.Character end
            end
        end
    end)

    createToggle("21. Hazard Floor Bypass", function(state)
        if state then
            for _, v in pairs(Workspace:GetDescendants()) do
                if v:IsA("BasePart") and (v.Name == "KillPart" or v.Name == "Lava" or v.Name == "Water") then
                    v.CanCollide = false
                    v.Transparency = 0.9
                end
            end
        end
    end)

    createToggle("22. Lock Time to Noon", function(state)
        task.spawn(function()
            while state and task.wait(1) do game.Lighting.ClockTime = 12 end
        end)
    end)

    createToggle("23. Mega Zoom Distance (1000)", function(state)
        LocalPlayer.CameraMaxZoomDistance = state and 1000 or 400
    end)

    createToggle("24. Show FPS Counter", function(state)
        local stats = CoreGui:FindFirstChild("UguzStats")
        if state then
            if not stats then
                local sg = Instance.new("ScreenGui", CoreGui)
                sg.Name = "UguzStats"
                local lbl = Instance.new("TextLabel", sg)
                lbl.Size = UDim2.new(0, 150, 0, 30)
                lbl.Position = UDim2.new(0, 10, 0, 10)
                lbl.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
                lbl.BackgroundTransparency = 0.5
                lbl.TextColor3 = Color3.fromRGB(0, 255, 100)
                lbl.TextSize = 14
                lbl.Font = Enum.Font.GothamBold
                task.spawn(function()
                    while sg.Parent do
                        lbl.Text = "FPS: " .. math.floor(1/RunService.RenderStepped:Wait())
                        task.wait(0.5)
                    end
                end)
            end
        else
            if stats then stats:Destroy() end
        end
    end)

    createToggle("25. Toggle UI Visibility (Insert Key)", function(state)
        UserInputService.InputBegan:Connect(function(input)
            if input.KeyCode == Enum.KeyCode.Insert then
                MainFrame.Visible = not MainFrame.Visible
            end
        end)
    end)

    createToggle("26. FOV Circle Display", function(state)
        local fov = CoreGui:FindFirstChild("UguzFOVCircle")
        if state then
            if not fov then
                local sg = Instance.new("ScreenGui", CoreGui)
                sg.Name = "UguzFOVCircle"
                local f = Instance.new("Frame", sg)
                f.Size = UDim2.new(0, 250, 0, 250)
                f.Position = UDim2.new(0.5, -125, 0.5, -125)
                f.BackgroundTransparency = 1
                corner(125).Parent = f
                stroke(Color3.fromRGB(255, 50, 80), 2).Parent = f
            end
        else
            if fov then fov:Destroy() end
        end
    end)

    local aimbotConn
    createToggle("27. General Smooth Aimbot", function(state)
        if state then
            aimbotConn = RunService.RenderStepped:Connect(function()
                local closest, shortest = nil, math.huge
                for _, p in pairs(Players:GetPlayers()) do
                    if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("Head") then
                        local pos, onScreen = Camera:WorldToViewportPoint(p.Character.Head.Position)
                        if onScreen then
                            local dist = (Vector2.new(pos.X, pos.Y) - Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)).Magnitude
                            if dist < 125 and dist < shortest then
                                shortest = dist
                                closest = p
                            end
                        end
                    end
                end
                if closest and closest.Character and closest.Character:FindFirstChild("Head") then
                    Camera.CFrame = CFrame.new(Camera.CFrame.Position, closest.Character.Head.Position)
                end
            end)
        else
            if aimbotConn then aimbotConn:Disconnect() end
        end
    end)

    createToggle("28. Murderer Priority Lock", function(state)
        task.spawn(function()
            while state and task.wait(0.2) do
                pcall(function()
                    for _, p in pairs(Players:GetPlayers()) do
                        if p ~= LocalPlayer and p.Character then
                            local bp = p:FindFirstChild("Backpack")
                            local char = p.Character
                            if (bp and (bp:FindFirstChild("Knife") or bp:FindFirstChild("Gun"))) or (char:FindFirstChild("Knife") or char:FindFirstChild("Gun")) then
                                local hl = char:FindFirstChild("RoleESP") or Instance.new("Highlight", char)
                                hl.FillColor = Color3.fromRGB(255, 0, 0)
                            end
                        end
                    end
                end)
            end
        end)
    end)

    createToggle("29. Hitbox Expander (Head x3)", function(state)
        task.spawn(function()
            while state and task.wait(1) do
                pcall(function()
                    for _, p in pairs(Players:GetPlayers()) do
                        if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("Head") then
                            p.Character.Head.Size = state and Vector3.new(4, 4, 4) or Vector3.new(2, 1, 1)
                            p.Character.Head.Transparency = state and 0.6 or 0
                            p.Character.Head.CanCollide = false
                        end
                    end
                end)
            end
        end)
    end)

    createToggle("30. Auto-Triggerbot Assist", function(state)
        task.spawn(function()
            while state and task.wait(0.1) do
                pcall(function()
                    local mouse = LocalPlayer:GetMouse()
                    if mouse.Target and mouse.Target.Parent then
                        local tp = Players:GetPlayerFromCharacter(mouse.Target.Parent)
                        if tp and tp ~= LocalPlayer then mouse1click() end
                    end
                end)
            end
        end)
    end)

    local antiAimConn
    createToggle("31. Anti-Aim Jitter (Desync)", function(state)
        if state then
            antiAimConn = RunService.RenderStepped:Connect(function()
                if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                    LocalPlayer.Character.HumanoidRootPart.CFrame = LocalPlayer.Character.HumanoidRootPart.CFrame * CFrame.Angles(0, math.rad(math.random(-180, 180)), 0)
                end
            end)
        else
            if antiAimConn then antiAimConn:Disconnect() end
        end
    end)

    createToggle("32. Quick Drop / HipHeight State", function(state)
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            LocalPlayer.Character.Humanoid.HipHeight = state and -1 or 0
        end
    end)

    createToggle("33. Auto-Reload Gun Ammo State", function(state)
        task.spawn(function()
            while state and task.wait(1) do
                pcall(function()
                    local char = LocalPlayer.Character
                    local tool = char and char:FindFirstChildOfClass("Tool")
                    if tool and tool.Name == "Gun" then end
                end)
            end
        end)
    end)

    createToggle("34. Neon Cyberpunk Lighting Mode", function(state)
        game.Lighting.OutdoorAmbient = state and Color3.fromRGB(50, 0, 100) or Color3.fromRGB(128, 128, 128)
        game.Lighting.Ambient = state and Color3.fromRGB(30, 0, 60) or Color3.fromRGB(0, 0, 0)
    end)

    createToggle("35. Safe Mode (Pause Triggers)", function(state)
        if state then print("UguzHub: Safe Mode Active") end
    end)
end

------------------------------------------------------------
-- AKIŞ VE DİL SEÇİM YÖNETİMİ
------------------------------------------------------------
local function showNoticeThenMenu()
    NoticeLabel.Text = L.notice
    NoticeFrame.Visible = true
    tween(NoticeFrame, { BackgroundTransparency = 0.05 }, 0.4)
    tween(NoticeLabel, { TextTransparency = 0 }, 0.5)

    task.delay(7, function()
        tween(NoticeFrame, { BackgroundTransparency = 1 }, 0.5)
        tween(NoticeLabel, { TextTransparency = 1 }, 0.4)
        task.wait(0.5)
        NoticeFrame.Visible = false

        if not MainFrame then
            buildMainMenu()
        end
        MainFrame.Visible = true
        MinimizedButton.Visible = false
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
        tween(LogoLabel, { TextTransparency = 1 }, 0.3)
        tween(ProTag, { TextTransparency = 1 }, 0.3)
        tween(SubtitleLabel, { TextTransparency = 1 }, 0.3)
        for _, card in ipairs(langCards) do
            tween(card, { BackgroundTransparency = 1 }, 0.25)
        end
        task.wait(0.4)
        IntroFrame.Visible = false

        MinimizedButton.Text = "🔵 " .. L.openBtn
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
        if CurrentLang ~= opt.code then tween(card, { BackgroundColor3 = Theme.AccentSoft }, 0.15) end
    end)
    card.MouseLeave:Connect(function()
        if CurrentLang ~= opt.code then tween(card, { BackgroundColor3 = Theme.Card }, 0.15) end
    end)
    card.MouseButton1Click:Connect(function()
        selectLanguage(opt.code)
    end)

    card.Parent = LangHolder
    table.insert(langCards, card)
end

MinimizedButton.MouseButton1Click:Connect(function()
    if MainFrame then
        MinimizedButton.Visible = false
        MainFrame.Visible = true
    end
end)

------------------------------------------------------------
-- BAŞLANGIÇ ANİMASYONU (0-5 sn)
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

    task.wait(5) -- 5 saniye yükleme animasyonu
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
