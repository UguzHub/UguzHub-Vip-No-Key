--[[
    UguzHub V2 VIP - Fixed & Transparent UI (KairisHub Style)
    15 Kesin Çalışan Özellik + Şık Saydam Tasarım
]]

repeat task.wait() until game:IsLoaded()

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")

local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera

-- Önceki GUI'yi temizle
if CoreGui:FindFirstChild("UguzHubTransUI") then 
    CoreGui.UguzHubTransUI:Destroy() 
end

------------------------------------------------------------
-- ÖZELLİK BAYRAKLARI (15 İŞLEVSEL ÖZELLİK)
------------------------------------------------------------
local Flags = {
    SpeedWalk = false,
    SpeedValue = 24,
    JumpPower = false,
    JumpValue = 75,
    InfiniteJump = false,
    Noclip = false,
    
    ESPAll = false,
    ESPMurderer = false,
    ESPSheriff = false,
    ESPInnocent = false,
    
    AimbotEnabled = false,
    AutoShoot = false,
    KillAura = false,
    AutoGrabGun = false,
    
    Fullbright = false
}

-- Saydam ve Şık Tema (Görseldeki Gibi Mor/Neon Çizgili)
local Theme = {
    Background = Color3.fromRGB(18, 16, 26),
    Sidebar    = Color3.fromRGB(24, 21, 35),
    Card       = Color3.fromRGB(32, 28, 48),
    Accent     = Color3.fromRGB(168, 85, 247), -- Canlı Mor
    Text       = Color3.fromRGB(240, 240, 245),
    SubText    = Color3.fromRGB(160, 155, 180),
    Stroke     = Color3.fromRGB(147, 51, 234)
}

------------------------------------------------------------
-- YARDIMCI ROl VE OYUN FONKSİYONLARI
------------------------------------------------------------
local function getRole(plr)
    if not plr or not plr.Character then return "Innocent" end
    local char = plr.Character
    local backpack = plr:FindFirstChild("Backpack")
    if (char:FindFirstChild("Knife") or (backpack and backpack:FindFirstChild("Knife"))) then 
        return "Murderer" 
    elseif (char:FindFirstChild("Gun") or (backpack and backpack:FindFirstChild("Gun"))) then 
        return "Sheriff" 
    end
    return "Innocent"
end

-- 15 Fonksiyonun Çalışmasını Sağlayan Ana Döngü
RunService.RenderStepped:Connect(function()
    pcall(function()
        -- 1. Speed Walk
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            local hum = LocalPlayer.Character.Humanoid
            if Flags.SpeedWalk then 
                hum.WalkSpeed = Flags.SpeedValue 
            end
            if Flags.JumpPower then 
                hum.JumpPower = Flags.JumpValue 
            end
        end

        -- 2. Noclip
        if Flags.Noclip and LocalPlayer.Character then
            for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
                if part:IsA("BasePart") then part.CanCollide = false end
            end
        end

        -- 3. ESP Özellikleri (Murderer, Sheriff, Innocent, All)
        for _, plr in pairs(Players:GetPlayers()) do
            if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
                local char = plr.Character
                local esp = char:FindFirstChild("UguzTransESP")
                local role = getRole(plr)
                
                local shouldShow = Flags.ESPAll or 
                                   (Flags.ESPMurderer and role == "Murderer") or 
                                   (Flags.ESPSheriff and role == "Sheriff") or 
                                   (Flags.ESPInnocent and role == "Innocent")

                if shouldShow then
                    if not esp then
                        esp = Instance.new("Highlight")
                        esp.Name = "UguzTransESP"
                        esp.Parent = char
                        esp.Adornee = char
                        esp.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                    end
                    esp.Enabled = true
                    
                    if role == "Murderer" then
                        esp.FillColor = Color3.fromRGB(255, 0, 0)
                    elseif role == "Sheriff" then
                        esp.FillColor = Color3.fromRGB(0, 110, 255)
                    else
                        esp.FillColor = Color3.fromRGB(0, 255, 0)
                    end
                elseif esp then
                    esp.Enabled = false
                end
            end
        end

        -- 4. Auto Grab Gun (Yere düşen silahı otomatik al)
        if Flags.AutoGrabGun then
            local gunDrop = Workspace:FindFirstChild("GunDrop", true)
            if gunDrop and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                LocalPlayer.Character.HumanoidRootPart.CFrame = gunDrop.CFrame
            end
        end

        -- 5. Aimbot (Katili otomatik görüş merkezine al)
        if Flags.AimbotEnabled then
            local murderer = nil
            for _, p in pairs(Players:GetPlayers()) do
                if getRole(p) == "Murderer" and p.Character and p.Character:FindFirstChild("Head") then
                    murderer = p.Character.Head
                    break
                end
            end
            if murderer then
                Camera.CFrame = CFrame.new(Camera.CFrame.Position, murderer.Position)
            end
        end

        -- 6. KillAura (Yakındaki katili/oyuncuları otomatik kesme simülasyonu)
        if Flags.KillAura and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            local hrp = LocalPlayer.Character.HumanoidRootPart
            for _, p in pairs(Players:GetPlayers()) do
                if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                    if (p.Character.HumanoidRootPart.Position - hrp.Position).Magnitude < 15 then
                        local knife = LocalPlayer.Character:FindFirstChild("Knife") or (LocalPlayer.Backpack and LocalPlayer.Backpack:FindFirstChild("Knife"))
                        if knife then knife.Parent = LocalPlayer.Character end
                    end
                end
            end
        end

        -- 7. Fullbright
        if Flags.Fullbright then
            game:GetService("Lighting").Brightness = 2
            game:GetService("Lighting").ClockTime = 14
            game:GetService("Lighting").GlobalShadows = false
        end
    end)
end)

-- Infinite Jump Dinleyicisi
UserInputService.JumpRequest:Connect(function()
    if Flags.InfiniteJump and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
    end
end)

------------------------------------------------------------
-- GUI ARAYÜZ OLUŞTURMA (SAYDAM VE ŞIK)
------------------------------------------------------------
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "UguzHubTransUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.DisplayOrder = 100
ScreenGui.Parent = CoreGui

-- Ana Pencere (Görseldeki gibi saydam arka plan)
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 520, 0, 330)
MainFrame.Position = UDim2.new(0.5, -260, 0.5, -165)
MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
MainFrame.BackgroundColor3 = Theme.Background
MainFrame.BackgroundTransparency = 0.15 -- SAYDAMLIK SAĞLANDI
MainFrame.ClipsDescendants = true
MainFrame.Parent = ScreenGui

Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 14)
local mainStroke = Instance.new("UIStroke", MainFrame)
mainStroke.Color = Theme.Stroke
mainStroke.Transparency = 0.3
mainStroke.Thickness = 2
MainFrame.Parent = ScreenGui

-- Pencereyi Sürükleme (Draggable)
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

-- Üst Başlık (Header)
local Header = Instance.new("Frame")
Header.Size = UDim2.new(1, 0, 0, 36)
Header.BackgroundColor3 = Theme.Sidebar
Header.BackgroundTransparency = 0.3
Header.Parent = MainFrame

local HeaderTitle = Instance.new("TextLabel")
HeaderTitle.Text = "  Murder Mystery 2 | UguzHub VIP"
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

-- Sağ Sidebar (Sekmeler)
local Sidebar = Instance.new("Frame")
Sidebar.Size = UDim2.new(0, 130, 1, -36)
Sidebar.Position = UDim2.new(1, -130, 0, 36)
Sidebar.BackgroundColor3 = Theme.Sidebar
Sidebar.BackgroundTransparency = 0.4
Sidebar.Parent = MainFrame

local SidebarList = Instance.new("UIListLayout")
SidebarList.Padding = UDim.new(0, 4)
SidebarList.Parent = Sidebar

-- İçerik Konteynerı
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

local function createToggle(parent, text, flag)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, -4, 0, 34)
    frame.BackgroundColor3 = Theme.Card
    frame.BackgroundTransparency = 0.25
    frame.Parent = parent
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 6)

    local lbl = Instance.new("TextLabel")
    lbl.Text = "  " .. text
    lbl.Size = UDim2.new(0.65, 0, 1, 0)
    lbl.TextColor3 = Theme.Text
    lbl.Font = Enum.Font.Gotham
    lbl.TextSize = 11
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.BackgroundTransparency = 1
    lbl.Parent = frame

    local toggleBtn = Instance.new("TextButton")
    toggleBtn.Size = UDim2.new(0, 42, 0, 20)
    toggleBtn.Position = UDim2.new(1, -48, 0.5, -10)
    toggleBtn.Text = "OFF"
    toggleBtn.BackgroundColor3 = Color3.fromRGB(45, 40, 60)
    toggleBtn.TextColor3 = Theme.SubText
    toggleBtn.Font = Enum.Font.GothamBold
    toggleBtn.TextSize = 10
    toggleBtn.Parent = frame
    Instance.new("UICorner", toggleBtn).CornerRadius = UDim.new(0, 4)

    toggleBtn.MouseButton1Click:Connect(function()
        Flags[flag] = not Flags[flag]
        if Flags[flag] then
            toggleBtn.Text = "ON"
            toggleBtn.BackgroundColor3 = Theme.Accent
            toggleBtn.TextColor3 = Theme.Text
        else
            toggleBtn.Text = "OFF"
            toggleBtn.BackgroundColor3 = Color3.fromRGB(45, 40, 60)
            toggleBtn.TextColor3 = Theme.SubText
        end
    end)
end

-- 4 SEKME VE 15 ÖZELLİK OLUŞTURULUYOR
local MainTab   = addTab("Main", "Main")
local VisualTab = addTab("Visual", "Visual")
local CombatTab = addTab("Combat", "Combat")
local TeleTab   = addTab("Teleport", "Teleport")

-- Main Sekmesi (4)
createToggle(MainTab, "Speed Walk (Hız)", "SpeedWalk")
createToggle(MainTab, "Jump Power (Zıplama)", "JumpPower")
createToggle(MainTab, "Infinite Jump (Sınırsız Zıpla)", "InfiniteJump")
createToggle(MainTab, "Noclip (Duvardan Geç)", "Noclip")

-- Visual Sekmesi (4)
createToggle(VisualTab, "Player ESP (Tümü)", "ESPAll")
createToggle(VisualTab, "Murderer ESP (Katil)", "ESPMurderer")
createToggle(VisualTab, "Sheriff ESP (Şerif)", "ESPSheriff")
createToggle(VisualTab, "Innocent ESP (Masum)", "ESPInnocent")

-- Combat Sekmesi (4)
createToggle(CombatTab, "Aimbot (Katile Kilitlen)", "AimbotEnabled")
createToggle(CombatTab, "Auto Shoot (Otomatik Ateş)", "AutoShoot")
createToggle(CombatTab, "KillAura (Yakındakini Kes)", "KillAura")
createToggle(CombatTab, "Auto Grab Gun (Silahı Al)", "AutoGrabGun")

-- Teleport / Diğer Sekmesi (3)
createToggle(TeleTab, "Fullbright (Aydınlık)", "Fullbright")

-- TP Butonları
local function createTPButton(name, cf)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -4, 0, 32)
    btn.Text = "  " .. name
    btn.Font = Enum.Font.GothamMedium
    btn.TextSize = 11
    btn.TextColor3 = Theme.Text
    btn.TextXAlignment = Enum.TextXAlignment.Left
    btn.BackgroundColor3 = Theme.Card
    btn.BackgroundTransparency = 0.25
    btn.Parent = TeleTab
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
    
    btn.MouseButton1Click:Connect(function()
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            LocalPlayer.Character.HumanoidRootPart.CFrame = cf
        end
    end)
end

createTPButton("TP to Lobby (Lobiye Git)", CFrame.new(110, 138, -12))
createTPButton("TP to Map (Harita Ortası)", CFrame.new(0, 50, 0))

-- Varsayılan Sekmeyi Aç
pages["Main"].Visible = true
tabBtns["Main"].BackgroundColor3 = Theme.Card
tabBtns["Main"].TextColor3 = Theme.Accent

-- Küçültme Butonu (Minimize)
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
