--[[
    UguzHub V2 Pro - Düzeltilmiş Sürüm (Auto Farm, Tween/Teleport, Kill All, Şeffaf Arayüz)
]]

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")

local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera

-- Önceki GUI'yi temizle
if CoreGui:FindFirstChild("UguzHubV2Pro") then 
    CoreGui.UguzHubV2Pro:Destroy() 
end

------------------------------------------------------------
-- ÖZELLİK BAYRAKLARI
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
    
    AutoFarm = false,
    FarmMode = "Teleport",
    KillAllActive = false,
    
    Fullbright = false
}

------------------------------------------------------------
-- TEMA
------------------------------------------------------------
local Theme = {
    Background = Color3.fromRGB(18, 16, 26),
    Sidebar    = Color3.fromRGB(24, 21, 35),
    Card       = Color3.fromRGB(32, 28, 48),
    Accent     = Color3.fromRGB(168, 85, 247),
    AccentSoft = Color3.fromRGB(90, 60, 180),
    Text       = Color3.fromRGB(240, 240, 245),
    SubText    = Color3.fromRGB(160, 155, 180),
    Stroke     = Color3.fromRGB(147, 51, 234),
}

local RADIUS = 14

------------------------------------------------------------
-- OYUN ROLLERİ VE DÖNGÜLER (MM2)
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

local function executeKillAll()
    local myChar = LocalPlayer.Character
    if not myChar then return end
    local knife = myChar:FindFirstChild("Knife") or (LocalPlayer:FindFirstChild("Backpack") and LocalPlayer.Backpack:FindFirstChild("Knife"))
    if not knife then return end
    knife.Parent = myChar
    
    local knifeHandle = knife:FindFirstChild("Handle") or knife:FindFirstChildWhichIsA("BasePart")
    local myHrp = myChar:FindFirstChild("HumanoidRootPart")
    if not myHrp then return end

    for _, player in ipairs(Players:GetPlayers()) do
        if not Flags.KillAllActive then break end
        if player ~= LocalPlayer and player.Character then
            local targetHrp = player.Character:FindFirstChild("HumanoidRootPart")
            local hum = player.Character:FindFirstChildOfClass("Humanoid")
            if targetHrp and hum and hum.Health > 0 then
                myHrp.CFrame = targetHrp.CFrame * CFrame.new(0, 0, 1)
                task.wait(0.05)
                pcall(function()
                    if firetouchinterest and knifeHandle then
                        firetouchinterest(knifeHandle, targetHrp, 0)
                        firetouchinterest(knifeHandle, targetHrp, 1)
                    end
                    knife:Activate()
                end)
                task.wait(0.1)
            end
        end
    end
    Flags.KillAllActive = false
end

task.spawn(function()
    while task.wait(0.5) do
        if Flags.AutoFarm then
            pcall(function()
                local char = LocalPlayer.Character
                local root = char and char:FindFirstChild("HumanoidRootPart")
                if root then
                    for _, obj in ipairs(Workspace:GetDescendants()) do
                        if not Flags.AutoFarm then break end
                        if (obj:IsA("BasePart") or obj:IsA("MeshPart")) and obj.Name:lower():find("coin") and obj.Transparency < 0.9 then
                            if Flags.FarmMode == "Tween" then
                                local distance = (root.Position - obj.Position).Magnitude
                                local speed = 250
                                local tweenInfo = TweenInfo.new(distance / speed, Enum.EasingStyle.Linear)
                                local tween = TweenService:Create(root, tweenInfo, {CFrame = obj.CFrame})
                                tween:Play()
                                tween.Completed:Wait()
                            else
                                root.CFrame = obj.CFrame
                            end
                            
                            pcall(function()
                                if firetouchinterest then
                                    firetouchinterest(root, obj, 0)
                                    firetouchinterest(root, obj, 1)
                                end
                            end)
                            task.wait(0.1)
                            break
                        end
                    end
                end
            end)
        end
    end
end)

RunService.RenderStepped:Connect(function()
    pcall(function()
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            local hum = LocalPlayer.Character.Humanoid
            if Flags.SpeedWalk then hum.WalkSpeed = Flags.SpeedValue end
            if Flags.JumpPower then hum.JumpPower = Flags.JumpValue end
        end

        if Flags.Noclip and LocalPlayer.Character then
            for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
                if part:IsA("BasePart") then part.CanCollide = false end
            end
        end

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

        if Flags.AutoGrabGun then
            local gunDrop = Workspace:FindFirstChild("GunDrop", true)
            if gunDrop and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                LocalPlayer.Character.HumanoidRootPart.CFrame = gunDrop.CFrame
            end
        end

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

        if Flags.KillAura and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            local hrp = LocalPlayer.Character.HumanoidRootPart
            for _, p in pairs(Players:GetPlayers()) do
                if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                    if (p.Character.HumanoidRootPart.Position - hrp.Position).Magnitude < 15 then
                        local knife = LocalPlayer.Character:FindFirstChild("Knife") or (LocalPlayer:FindFirstChild("Backpack") and LocalPlayer.Backpack:FindFirstChild("Knife"))
                        if knife then knife.Parent = LocalPlayer.Character end
                    end
                end
            end
        end

        if Flags.Fullbright then
            game:GetService("Lighting").Brightness = 2
            game:GetService("Lighting").ClockTime = 14
            game:GetService("Lighting").GlobalShadows = false
        end
    end)
end)

UserInputService.JumpRequest:Connect(function()
    if Flags.InfiniteJump and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
    end
end)

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

------------------------------------------------------------
-- ANA GUI OLUŞTURUCU
------------------------------------------------------------
local ScreenGui = create("ScreenGui", {
    Name = "UguzHubV2Pro",
    ResetOnSpawn = false,
    ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
    DisplayOrder = 100,
    IgnoreGuiInset = true,
})
ScreenGui.Parent = CoreGui

local MinimizedButton = create("TextButton", {
    Name = "MinimizedButton",
    Text = "🟣 UguzHub",
    Font = Enum.Font.GothamBold,
    TextSize = 15,
    TextColor3 = Theme.Text,
    BackgroundColor3 = Theme.Accent,
    Size = UDim2.new(0, 118, 0, 38),
    Position = UDim2.new(1, -134, 0, 16),
    AutoButtonColor = false,
    Visible = false,
    ZIndex = 8,
})
corner(12).Parent = MinimizedButton
stroke(Color3.fromRGB(255, 255, 255), 1).Parent = MinimizedButton
MinimizedButton.Parent = ScreenGui

local MENU_W, MENU_H = 520, 330
local MainFrame

local function buildMainMenu()
    MainFrame = create("Frame", {
        Name = "MainMenu",
        Size = UDim2.new(0, MENU_W, 0, MENU_H),
        Position = UDim2.new(0.5, 0, 0.5, 0),
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundColor3 = Theme.Background,
        BackgroundTransparency = 0.15,
        ClipsDescendants = true,
        Visible = true,
        ZIndex = 5,
    })
    corner(RADIUS).Parent = MainFrame
    stroke(Theme.Stroke, 2).Parent = MainFrame
    MainFrame.Parent = ScreenGui

    local Header = create("Frame", {
        Size = UDim2.new(1, 0, 0, 36),
        BackgroundColor3 = Theme.Sidebar,
        BackgroundTransparency = 0.3,
        Parent = MainFrame,
        ZIndex = 6,
    })

    create("TextLabel", {
        Size = UDim2.new(1, -40, 1, 0),
        Text = "  Murder Mystery 2 | UguzHub V2 Pro",
        TextColor3 = Theme.Text,
        Font = Enum.Font.GothamBold,
        TextSize = 13,
        TextXAlignment = Enum.TextXAlignment.Left,
        BackgroundTransparency = 1,
        Parent = Header,
        ZIndex = 7,
    })

    local CloseBtn = create("TextButton", {
        Text = "×",
        Font = Enum.Font.GothamBold,
        TextSize = 18,
        TextColor3 = Theme.SubText,
        BackgroundTransparency = 1,
        Size = UDim2.new(0, 36, 0, 36),
        Position = UDim2.new(1, -36, 0, 0),
        Parent = Header,
        ZIndex = 7,
    })

    CloseBtn.MouseButton1Click:Connect(function()
        MainFrame.Visible = false
        MinimizedButton.Visible = true
    end)

    local Sidebar = create("Frame", {
        Size = UDim2.new(0, 130, 1, -36),
        Position = UDim2.new(1, -130, 0, 36),
        BackgroundColor3 = Theme.Sidebar,
        BackgroundTransparency = 0.4,
        Parent = MainFrame,
        ZIndex = 6,
    })

    create("UIListLayout", {
        Padding = UDim.new(0, 4),
        Parent = Sidebar,
    })

    local ContentContainer = create("Frame", {
        Size = UDim2.new(1, -135, 1, -42),
        Position = UDim2.new(0, 4, 0, 40),
        BackgroundTransparency = 1,
        Parent = MainFrame,
        ZIndex = 6,
    })

    local pages, tabBtns = {}, {}

    local function addTab(name, id)
        local page = create("ScrollingFrame", {
            Size = UDim2.new(1, 0, 1, 0),
            BackgroundTransparency = 1,
            ScrollBarThickness = 2,
            Visible = false,
            Parent = ContentContainer,
            ZIndex = 6,
        })

        create("UIListLayout", {
            Padding = UDim.new(0, 6),
            Parent = page,
        })

        local btn = create("TextButton", {
            Size = UDim2.new(1, 0, 0, 48),
            Text = name,
            BackgroundColor3 = Theme.Sidebar,
            BackgroundTransparency = 0.5,
            TextColor3 = Theme.SubText,
            Font = Enum.Font.GothamMedium,
            TextSize = 12,
            AutoButtonColor = false,
            Parent = Sidebar,
            ZIndex = 7,
        })

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
        local frame = create("Frame", {
            Size = UDim2.new(1, -4, 0, 34),
            BackgroundColor3 = Theme.Card,
            BackgroundTransparency = 0.25,
            Parent = parent,
            ZIndex = 6,
        })
        corner(6).Parent = frame

        create("TextLabel", {
            Text = "  " .. text,
            Size = UDim2.new(0.65, 0, 1, 0),
            TextColor3 = Theme.Text,
            Font = Enum.Font.Gotham,
            TextSize = 11,
            TextXAlignment = Enum.TextXAlignment.Left,
            BackgroundTransparency = 1,
            Parent = frame,
            ZIndex = 7,
        })

        local toggleBtn = create("TextButton", {
            Size = UDim2.new(0, 42, 0, 20),
            Position = UDim2.new(1, -48, 0.5, -10),
            Text = "OFF",
            BackgroundColor3 = Color3.fromRGB(45, 40, 60),
            TextColor3 = Theme.SubText,
            Font = Enum.Font.GothamBold,
            TextSize = 10,
            Parent = frame,
            ZIndex = 7,
        })
        corner(4).Parent = toggleBtn

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

    local MainTab   = addTab("Main", "Main")
    local VisualTab = addTab("Visual", "Visual")
    local CombatTab = addTab("Combat", "Combat")
    local TeleTab   = addTab("Teleport", "Teleport")

    local ProfileCard = create("Frame", {
        Size = UDim2.new(1, -4, 0, 85),
        BackgroundColor3 = Theme.Card,
        BackgroundTransparency = 0.25,
        Parent = MainTab,
        ZIndex = 6,
    })
    corner(8).Parent = ProfileCard

    local AvatarImg = create("ImageLabel", {
        Size = UDim2.new(0, 60, 0, 60),
        Position = UDim2.new(0, 10, 0.5, -30),
        BackgroundColor3 = Color3.fromRGB(40, 35, 60),
        Parent = ProfileCard,
        ZIndex = 7,
    })
    corner(30).Parent = AvatarImg

    pcall(function()
        AvatarImg.Image = Players:GetUserThumbnailAsync(LocalPlayer.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size150x150)
    end)

    create("TextLabel", {
        Size = UDim2.new(1, -80, 0, 20),
        Position = UDim2.new(0, 78, 0, 16),
        Text = "Hoşgeldin, " .. LocalPlayer.Name,
        TextColor3 = Theme.Text,
        Font = Enum.Font.GothamBold,
        TextSize = 13,
        TextXAlignment = Enum.TextXAlignment.Left,
        BackgroundTransparency = 1,
        Parent = ProfileCard,
        ZIndex = 7,
    })

    create("TextLabel", {
        Size = UDim2.new(1, -80, 0, 20),
        Position = UDim2.new(0, 78, 0, 38),
        Text = "@" .. LocalPlayer.Name .. " | ID: " .. LocalPlayer.UserId,
        TextColor3 = Theme.SubText,
        Font = Enum.Font.Gotham,
        TextSize = 10,
        TextXAlignment = Enum.TextXAlignment.Left,
        BackgroundTransparency = 1,
        Parent = ProfileCard,
        ZIndex = 7,
    })

    local DiscordCard = create("TextButton", {
        Size = UDim2.new(1, -4, 0, 38),
        BackgroundColor3 = Theme.Card,
        BackgroundTransparency = 0.25,
        Text = "",
        AutoButtonColor = false,
        Parent = MainTab,
        ZIndex = 6,
    })
    corner(8).Parent = DiscordCard

    create("TextLabel", {
        Size = UDim2.new(0, 30, 1, 0),
        Position = UDim2.new(0, 8, 0, 0),
        Text = "💬",
        TextSize = 14,
        BackgroundTransparency = 1,
        Parent = DiscordCard,
        ZIndex = 7,
    })

    local DiscordText = create("TextLabel", {
        Size = UDim2.new(1, -45, 1, 0),
        Position = UDim2.new(0, 38, 0, 0),
        Text = "Discord: discord.gg/uguzhub (Tıkla Kopyala)",
        TextColor3 = Theme.Accent,
        Font = Enum.Font.GothamBold,
        TextSize = 11,
        TextXAlignment = Enum.TextXAlignment.Left,
        BackgroundTransparency = 1,
        Parent = DiscordCard,
        ZIndex = 7,
    })

    DiscordCard.MouseButton1Click:Connect(function()
        pcall(function()
            setclipboard("https://discord.gg/uguzhub")
            DiscordText.Text = "Discord Linki Kopyalandı!"
            task.wait(1.5)
            DiscordText.Text = "Discord: discord.gg/uguzhub (Tıkla Kopyala)"
        end)
    end)

    createToggle(MainTab, "Auto Farm (Coin Topla)", "AutoFarm")

    local ModeBtn = create("TextButton", {
        Size = UDim2.new(1, -4, 0, 34),
        BackgroundColor3 = Theme.Card,
        BackgroundTransparency = 0.25,
        Text = "  Farm Mode: Teleport",
        TextColor3 = Theme.Text,
        Font = Enum.Font.Gotham,
        TextSize = 11,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = MainTab,
        ZIndex = 6,
    })
    corner(6).Parent = ModeBtn
    ModeBtn.MouseButton1Click:Connect(function()
        if Flags.FarmMode == "Teleport" then
            Flags.FarmMode = "Teleport"
            ModeBtn.Text = "  Farm Mode: Teleport"
        end
    end)

    local KillAllBtn = create("TextButton", {
        Size = UDim2.new(1, -4, 0, 34),
        BackgroundColor3 = Color3.fromRGB(150, 40, 40),
        BackgroundTransparency = 0.2,
        Text = "  Kill All (Herkesi Katlet)",
        TextColor3 = Theme.Text,
        Font = Enum.Font.GothamBold,
        TextSize = 11,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = MainTab,
        ZIndex = 6,
    })
    corner(6).Parent = KillAllBtn
    KillAllBtn.MouseButton1Click:Connect(function()
        Flags.KillAllActive = true
        task.spawn(executeKillAll)
    end)

    createToggle(MainTab, "Speed Walk (Hız)", "SpeedWalk")
    createToggle(MainTab, "Jump Power (Zıplama)", "JumpPower")
    createToggle(MainTab, "Infinite Jump (Sınırsız Zıpla)", "InfiniteJump")
    createToggle(MainTab, "Noclip (Duvardan Geç)", "Noclip")

    createToggle(VisualTab, "Player ESP (Tümü)", "ESPAll")
    createToggle(VisualTab, "Murderer ESP (Katil)", "ESPMurderer")
    createToggle(VisualTab, "Sheriff ESP (Şerif)", "ESPSheriff")
    createToggle(VisualTab, "Innocent ESP (Masum)", "ESPInnocent")

    createToggle(CombatTab, "Aimbot (Katile Kilitlen)", "AimbotEnabled")
    createToggle(CombatTab, "Auto Shoot (Otomatik Ateş)", "AutoShoot")
    createToggle(CombatTab, "KillAura (Yakındakini Kes)", "KillAura")
    createToggle(CombatTab, "Auto Grab Gun (Silahı Al)", "AutoGrabGun")

    createToggle(TeleTab, "Fullbright (Aydınlık)", "Fullbright")

    local function createTPButton(name, cf)
        local btn = create("TextButton", {
            Size = UDim2.new(1, -4, 0, 32),
            Text = "  " .. name,
            Font = Enum.Font.GothamMedium,
            TextSize = 11,
            TextColor3 = Theme.Text,
            TextXAlignment = Enum.TextXAlignment.Left,
            BackgroundColor3 = Theme.Card,
            BackgroundTransparency = 0.25,
            Parent = TeleTab,
            ZIndex = 6,
        })
        corner(6).Parent = btn
        
        btn.MouseButton1Click:Connect(function()
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                LocalPlayer.Character.HumanoidRootPart.CFrame = cf
            end
        end)
    end

    createTPButton("TP to Lobby (Lobiye Git)", CFrame.new(110, 138, -12))
    createTPButton("TP to Map (Harita Ortası)", CFrame.new(0, 50, 0))

    pages["Main"].Visible = true
    tabBtns["Main"].BackgroundColor3 = Theme.Card
    tabBtns["Main"].TextColor3 = Theme.Accent

    local dragging, dragStart, startPos
    Header.InputBegan:Connect(function(input)
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
end

buildMainMenu()

MinimizedButton.MouseButton1Click:Connect(function()
    if MainFrame then
        MainFrame.Visible = true
        MinimizedButton.Visible = false
    end
end)
