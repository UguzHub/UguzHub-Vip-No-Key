--[[
    UguzHub V2 VIP - Özel Tasarım & Saydam Arayüz (Sadece Menü)
]]

repeat task.wait() until game:IsLoaded()

local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")

local LocalPlayer = Players.LocalPlayer

-- Önceki GUI'yi temizle
if CoreGui:FindFirstChild("UguzHubTransUI") then 
    CoreGui.UguzHubTransUI:Destroy() 
end

-- Görseldeki Mor / Şık Saydam Tema
local Theme = {
    Background = Color3.fromRGB(18, 16, 26),
    Sidebar    = Color3.fromRGB(24, 21, 35),
    Card       = Color3.fromRGB(32, 28, 48),
    Accent     = Color3.fromRGB(168, 85, 247),
    Text       = Color3.fromRGB(240, 240, 245),
    SubText    = Color3.fromRGB(160, 155, 180),
    Stroke     = Color3.fromRGB(147, 51, 234)
}

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "UguzHubTransUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.DisplayOrder = 100
ScreenGui.Parent = CoreGui

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 520, 0, 330)
MainFrame.Position = UDim2.new(0.5, -260, 0.5, -165)
MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
MainFrame.BackgroundColor3 = Theme.Background
MainFrame.BackgroundTransparency = 0.15
MainFrame.ClipsDescendants = true
MainFrame.Parent = ScreenGui

Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 14)
local mainStroke = Instance.new("UIStroke", MainFrame)
mainStroke.Color = Theme.Stroke
mainStroke.Transparency = 0.3
mainStroke.Thickness = 2

-- Sürükleme Özelliği
local dragging, dragStart, startPos
MainFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = MainFrame.Position
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + (input.Position.X - dragStart.X), startPos.Y.Scale, startPos.Y.Offset + (input.Position.Y - dragStart.Y))
    end
end)
UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then 
        dragging = false 
    end
end)

-- Başlık Çubuğu
local Header = Instance.new("Frame")
Header.Size = UDim2.new(1, 0, 0, 36)
Header.BackgroundColor3 = Theme.Sidebar
Header.BackgroundTransparency = 0.3
Header.Parent = MainFrame

local HeaderTitle = Instance.new("TextLabel")
HeaderTitle.Text = "  Murder Mystery 2 | UguzHub"
HeaderTitle.Size = UDim2.new(1, -40, 1, 0)
HeaderTitle.TextColor3 = Theme.Text
HeaderTitle.Font = Enum.Font.GothamBold
HeaderTitle.TextSize = 13
HeaderTitle.TextXAlignment = Enum.TextXAlignment.Left
HeaderTitle.BackgroundTransparency = 1
HeaderTitle.Parent = Header

local CloseBtn = Instance.new("TextButton")
CloseBtn.Text = "×"
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 18
CloseBtn.TextColor3 = Theme.SubText
CloseBtn.BackgroundTransparency = 1
CloseBtn.Size = UDim2.new(0, 36, 0, 36)
CloseBtn.Position = UDim2.new(1, -36, 0, 0)
CloseBtn.Parent = Header

-- Sağ Sekme Menüsü (Sidebar)
local Sidebar = Instance.new("Frame")
Sidebar.Size = UDim2.new(0, 130, 1, -36)
Sidebar.Position = UDim2.new(1, -130, 0, 36)
Sidebar.BackgroundColor3 = Theme.Sidebar
Sidebar.BackgroundTransparency = 0.4
Sidebar.Parent = MainFrame

local SidebarList = Instance.new("UIListLayout")
SidebarList.Padding = UDim.new(0, 4)
SidebarList.Parent = Sidebar

local ContentContainer = Instance.new("Frame")
ContentContainer.Size = UDim2.new(1, -135, 1, -42)
ContentContainer.Position = UDim2.new(0, 4, 0, 40)
ContentContainer.BackgroundTransparency = 1
ContentContainer.Parent = MainFrame

local pages, tabBtns = {}, {}

local function addTab(name, id)
    local page = Instance.new("ScrollingFrame")
    page.Size = UDim2.new(1, 0, 1, 0)
    page.BackgroundTransparency = 1
    page.ScrollBarThickness = 2
    page.Visible = false
    page.Parent = ContentContainer

    local pList = Instance.new("UIListLayout")
    pList.Padding = UDim.new(0, 6)
    pList.Parent = page

    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 48)
    btn.Text = name
    btn.BackgroundColor3 = Theme.Sidebar
    btn.BackgroundTransparency = 0.5
    btn.TextColor3 = Theme.SubText
    btn.Font = Enum.Font.GothamMedium
    btn.TextSize = 12
    btn.AutoButtonColor = false
    btn.Parent = Sidebar

    btn.MouseButton1Click:Connect(function()
        for _, p in pairs(pages) do p.Visible = false end
        for _, b in pairs(tabBtns) do 
            b.BackgroundColor3 = Theme.Sidebar
            b.TextColor3 = Theme.SubText 
        end
        page.Visible = true
        btn.BackgroundColor3 = Theme.Card
        btn.TextColor3 = Theme.Accent
    end)

    pages[id] = page
    tabBtns[id] = btn
    return page
end

-- SEKMELER
local MainTab   = addTab("Main", "Main")
local VisualTab = addTab("Visual", "Visual")
local CombatTab = addTab("Combat", "Combat")
local TeleTab   = addTab("Teleport", "Teleport")

------------------------------------------------------------
-- MAIN SEKMESİ: PROFİL KARTI & DİSCORD KOPYALAMA KUTUSU
------------------------------------------------------------
local ProfileCard = Instance.new("Frame")
ProfileCard.Size = UDim2.new(1, -4, 0, 85)
ProfileCard.BackgroundColor3 = Theme.Card
ProfileCard.BackgroundTransparency = 0.25
ProfileCard.Parent = MainTab
Instance.new("UICorner", ProfileCard).CornerRadius = UDim.new(0, 8)

-- Profil Resmi (Avatar)
local AvatarImg = Instance.new("ImageLabel")
AvatarImg.Size = UDim2.new(0, 60, 0, 60)
AvatarImg.Position = UDim2.new(0, 10, 0.5, -30)
AvatarImg.BackgroundColor3 = Color3.fromRGB(40, 35, 60)
AvatarImg.Parent = ProfileCard
Instance.new("UICorner", AvatarImg).CornerRadius = UDim.new(1, 0)

pcall(function()
    AvatarImg.Image = Players:GetUserThumbnailAsync(LocalPlayer.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size150x150)
end)

-- Hoşgeldin ve İsim
local WelcomeLbl = Instance.new("TextLabel")
WelcomeLbl.Size = UDim2.new(1, -80, 0, 20)
WelcomeLbl.Position = UDim2.new(0, 78, 0, 16)
WelcomeLbl.Text = "Hoşgeldin, " .. LocalPlayer.Name
WelcomeLbl.TextColor3 = Theme.Text
WelcomeLbl.Font = Enum.Font.GothamBold
WelcomeLbl.TextSize = 13
WelcomeLbl.TextXAlignment = Enum.TextXAlignment.Left
WelcomeLbl.BackgroundTransparency = 1
WelcomeLbl.Parent = ProfileCard

local SubInfoLbl = Instance.new("TextLabel")
SubInfoLbl.Size = UDim2.new(1, -80, 0, 20)
SubInfoLbl.Position = UDim2.new(0, 78, 0, 38)
SubInfoLbl.Text = "@" .. LocalPlayer.Name .. " | ID: " .. LocalPlayer.UserId
SubInfoLbl.TextColor3 = Theme.SubText
SubInfoLbl.Font = Enum.Font.Gotham
SubInfoLbl.TextSize = 10
SubInfoLbl.TextXAlignment = Enum.TextXAlignment.Left
SubInfoLbl.BackgroundTransparency = 1
SubInfoLbl.Parent = ProfileCard

-- DİSCORD KOPYALAMA KUTUSU
local DiscordCard = Instance.new("TextButton")
DiscordCard.Size = UDim2.new(1, -4, 0, 38)
DiscordCard.BackgroundColor3 = Theme.Card
DiscordCard.BackgroundTransparency = 0.25
DiscordCard.Text = ""
DiscordCard.AutoButtonColor = false
DiscordCard.Parent = MainTab
Instance.new("UICorner", DiscordCard).CornerRadius = UDim.new(0, 8)

local DiscordIcon = Instance.new("TextLabel")
DiscordIcon.Size = UDim2.new(0, 30, 1, 0)
DiscordIcon.Position = UDim2.new(0, 8, 0, 0)
DiscordIcon.Text = "💬"
DiscordIcon.TextSize = 14
DiscordIcon.BackgroundTransparency = 1
DiscordIcon.Parent = DiscordCard

local DiscordText = Instance.new("TextLabel")
DiscordText.Size = UDim2.new(1, -45, 1, 0)
DiscordText.Position = UDim2.new(0, 38, 0, 0)
DiscordText.Text = "Discord: discord.gg/uguzhub (Tıkla Kopyala)"
DiscordText.TextColor3 = Theme.Accent
DiscordText.Font = Enum.Font.GothamBold
DiscordText.TextSize = 11
DiscordText.TextXAlignment = Enum.TextXAlignment.Left
DiscordText.BackgroundTransparency = 1
DiscordText.Parent = DiscordCard

DiscordCard.MouseButton1Click:Connect(function()
    pcall(function()
        setclipboard("https://discord.gg/uguzhub")
        DiscordText.Text = "Discord Linki Kopyalandı!"
        task.wait(1.5)
        DiscordText.Text = "Discord: discord.gg/uguzhub (Tıkla Kopyala)"
    end)
end)

-- Varsayılan Main Sekmesini Aç
pages["Main"].Visible = true
tabBtns["Main"].BackgroundColor3 = Theme.Card
tabBtns["Main"].TextColor3 = Theme.Accent

-- Minimize Butonu
local MinimizedButton = Instance.new("TextButton")
MinimizedButton.Name = "MinimizedButton"
MinimizedButton.Text = "🟣 UguzHub"
MinimizedButton.Font = Enum.Font.GothamBold
MinimizedButton.TextSize = 14
MinimizedButton.TextColor3 = Theme.Text
MinimizedButton.BackgroundColor3 = Theme.Accent
MinimizedButton.Size = UDim2.new(0, 110, 0, 36)
MinimizedButton.Position = UDim2.new(1, -126, 0, 16)
MinimizedButton.Visible = false
Instance.new("UICorner", MinimizedButton).CornerRadius = UDim.new(0, 10)
MinimizedButton.Parent = ScreenGui

CloseBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = false
    MinimizedButton.Visible = true
end)

MinimizedButton.MouseButton1Click:Connect(function()
    MainFrame.Visible = true
    MinimizedButton.Visible = false
end)
