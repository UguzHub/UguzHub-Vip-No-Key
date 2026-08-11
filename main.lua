-- main.lua
-- UguzHub V2 Pro - Animated GUI + enhanced visuals & expanded translations
-- WARNING: Client-side GUI scaffold. Game-specific logic must be adapted to the target game.

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local ContextActionService = game:GetService("ContextActionService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- Default language
local LANG = "tr"
-- Expanded translations (added more UI text keys)
local TRANSLATIONS = {
    tr = {
        title = "UguzHub V2 Pro",
        subtitle = "Lüks, animasyonlu menü",
        main = "Ana Menü",
        autofarm = "Autofarm",
        esp = "ESP",
        silent = "Silent Aim",
        trolls = "Trolllar",
        emotes = "Emoteler",
        items = "Eşyalar",
        settings = "Ayarlar",
        greeting = "Bugün nasılsın?",
        enable = "Aç",
        disable = "Kapat",
        language = "Dil",
        fly = "Uçuş",
        fling = "Fırlatma",
        invisible = "Görünmezlik (yerel)",
        spawn_prank = "Şaka Bombası Oluştur",
        emote_example = "El sallama (örnek)",
        profile = "Profil",
        welcome_line = "Hoşgeldin, iyi oyunlar!",
    },
    en = {
        title = "UguzHub V2 Pro",
        subtitle = "Luxury animated menu",
        main = "Main",
        autofarm = "Autofarm",
        esp = "ESP",
        silent = "Silent Aim",
        trolls = "Trolls",
        emotes = "Emotes",
        items = "Items",
        settings = "Settings",
        greeting = "How are you today?",
        enable = "Enable",
        disable = "Disable",
        language = "Language",
        fly = "Fly",
        fling = "Fling",
        invisible = "Invisible (local)",
        spawn_prank = "Spawn Prank Bomb",
        emote_example = "Wave (example)",
        profile = "Profile",
        welcome_line = "Welcome, have fun!",
    },
    ru = {
        title = "UguzHub V2 Pro",
        subtitle = "Роскошное анимированное меню",
        main = "Главная",
        autofarm = "Автофарм",
        esp = "ESP",
        silent = "Silent Aim",
        trolls = "Тролли",
        emotes = "Эмодзи",
        items = "Предметы",
        settings = "Настройки",
        greeting = "Как дела сегодня?",
        enable = "Включить",
        disable = "Отключить",
        language = "Язык",
        fly = "Полет",
        fling = "Отправить",
        invisible = "Невидимость (локально)",
        spawn_prank = "Создать шутливую бомбу",
        emote_example = "Махнуть (пример)",
        profile = "Профиль",
        welcome_line = "Добро пожаловать, приятной игры!",
    }
}

local function t(k)
    return (TRANSLATIONS[LANG] and TRANSLATIONS[LANG][k]) or TRANSLATIONS.tr[k] or k
end

-- Helper to create instances with properties
local function new(class, props)
    local obj = Instance.new(class)
    for k,v in pairs(props or {}) do
        if k == "parent" then obj.Parent = v
        else pcall(function() obj[k] = v end)
        end
    end
    return obj
end

-- Clear any previous GUI
local existing = PlayerGui:FindFirstChild("UguzHubGui")
if existing then existing:Destroy() end

-- Root ScreenGui
local screen = new("ScreenGui", {Parent = PlayerGui, ResetOnSpawn = false, Name = "UguzHubGui", ZIndexBehavior = Enum.ZIndexBehavior.Sibling})

-- Main container
local mainFrame = new("Frame", {
    Parent = screen,
    Size = UDim2.new(0, 780, 0, 460),
    Position = UDim2.new(0.5, -390, 0.5, -230),
    BackgroundTransparency = 1,
    Name = "MainFrame",
})

-- Background with blurred overlay feel (simple translucent panel)
local panel = new("Frame", {Parent = mainFrame, Size = UDim2.new(1,0,1,0), BackgroundColor3 = Color3.fromRGB(20,20,28), BackgroundTransparency = 0, BorderSizePixel = 0})
new("UICorner", {Parent = panel, CornerRadius = UDim.new(0,12)})

-- Add subtle gradient and stroke
local grad = new("UIGradient", {Parent = panel, Color = ColorSequence.new{ColorSequenceKeypoint.new(0, Color3.fromRGB(28,28,36)), ColorSequenceKeypoint.new(1, Color3.fromRGB(18,18,26))}})
new("UIStroke", {Parent = panel, Color = Color3.fromRGB(60,60,70), Transparency = 0.85, Thickness = 1})

-- Title area with subtitle
local titleBar = new("Frame", {Parent = panel, Size = UDim2.new(1,0,0,84), BackgroundTransparency = 1})
local titleLabel = new("TextLabel", {Parent = titleBar, Text = t("title"), Font = Enum.Font.GothamBold, TextSize = 30, TextColor3 = Color3.fromRGB(240,240,255), BackgroundTransparency = 1, Position = UDim2.new(0,20,0,12)})
local subtitleLabel = new("TextLabel", {Parent = titleBar, Text = t("subtitle"), Font = Enum.Font.Gotham, TextSize = 14, TextColor3 = Color3.fromRGB(170,170,190), BackgroundTransparency = 1, Position = UDim2.new(0,20,0,44)})

-- Language flags container (use ImageButtons with placeholder asset ids)
local flags = new("Frame", {Parent = titleBar, Size = UDim2.new(0,160,0,50), Position = UDim2.new(1,-180,0,16), BackgroundTransparency = 1})
local function makeFlag(nameCode, imageId, xOffset)
    local b = new("ImageButton", {Parent = flags, Size = UDim2.new(0,44,0,32), Position = UDim2.new(0,xOffset,0,0), BackgroundTransparency = 0, BackgroundColor3 = Color3.fromRGB(40,40,40), Image = imageId, ScaleType = Enum.ScaleType.Fit, Name = nameCode})
    new("UICorner", {Parent = b, CornerRadius = UDim.new(0,6)})
    new("UIStroke", {Parent = b, Color = Color3.fromRGB(65,65,75), Thickness = 1})
    b.MouseButton1Click:Connect(function()
        LANG = nameCode
        updateTexts()
        -- pulse animation
        TweenService:Create(b, TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.new(0,50,0,36)}):Play()
        delay(0.16, function() TweenService:Create(b, TweenInfo.new(0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.new(0,44,0,32)}):Play() end)
    end)
    b.MouseEnter:Connect(function() TweenService:Create(b, TweenInfo.new(0.12), {BackgroundColor3 = Color3.fromRGB(56,56,66)}):Play() end)
    b.MouseLeave:Connect(function() TweenService:Create(b, TweenInfo.new(0.12), {BackgroundColor3 = Color3.fromRGB(40,40,40)}):Play() end)
    return b
end
-- Placeholder asset ids (replace with real flag assets if desired)
makeFlag("tr", "rbxassetid://11920996332", 0) -- Turkey flag placeholder
makeFlag("ru", "rbxassetid://11920996334", 56) -- Russia flag placeholder
makeFlag("en", "rbxassetid://11920996336", 112) -- UK/EN flag placeholder

-- Left menu with icons
local leftMenu = new("Frame", {Parent = panel, Size = UDim2.new(0,190,1,-96), Position = UDim2.new(0,0,0,96), BackgroundTransparency = 1})
new("UICorner", {Parent = leftMenu, CornerRadius = UDim.new(0,8)})
local buttonsFolder = {}
local sections = {
    {key="main", icon="rbxassetid://6023426915"},
    {key="autofarm", icon="rbxassetid://6031090991"},
    {key="esp", icon="rbxassetid://6023426915"},
    {key="silent", icon="rbxassetid://6031090991"},
    {key="trolls", icon="rbxassetid://6023426915"},
    {key="emotes", icon="rbxassetid://6031090991"},
    {key="items", icon="rbxassetid://6023426915"},
    {key="settings", icon="rbxassetid://6031090991"},
}

-- Helper to create styled left button
local function makeLeftButton(parent, y, key, iconId)
    local btn = new("TextButton", {Parent = parent, Size = UDim2.new(1, -10, 0, 44), Position = UDim2.new(0,5,0,y), BackgroundColor3 = Color3.fromRGB(32,32,40), Text = t(key), Font = Enum.Font.Gotham, TextSize = 16, TextColor3 = Color3.fromRGB(230,230,240), Name = key, AutoButtonColor = false})
    new("UICorner", {Parent = btn, CornerRadius = UDim.new(0,8)})
    new("UIStroke", {Parent = btn, Color = Color3.fromRGB(50,50,60), Thickness = 1})
    local icon = new("ImageLabel", {Parent = btn, Size = UDim2.new(0,28,0,28), Position = UDim2.new(0,8,0,8), BackgroundTransparency = 1, Image = iconId, ScaleType = Enum.ScaleType.Fit})
    btn.TextXAlignment = Enum.TextXAlignment.Left
    btn.TextScaled = false
    btn.TextStrokeTransparency = 0.8
    btn.MouseEnter:Connect(function() TweenService:Create(btn, TweenInfo.new(0.12), {BackgroundColor3 = Color3.fromRGB(46,46,56)}):Play() end)
    btn.MouseLeave:Connect(function() TweenService:Create(btn, TweenInfo.new(0.12), {BackgroundColor3 = Color3.fromRGB(32,32,40)}):Play() end)
    btn.MouseButton1Click:Connect(function() openSection(key) end)
    return btn
end

for i,s in ipairs(sections) do
    local btn = makeLeftButton(leftMenu, 8 + (i-1)*52, s.key, s.icon)
    buttonsFolder[s.key] = btn
end

-- Content area
local contentArea = new("Frame", {Parent = panel, Size = UDim2.new(1,-200,1,-96), Position = UDim2.new(0,200,0,96), BackgroundTransparency = 1})

-- state
local toggles = { Autofarm = false, ESP = false, SilentAim = false, Fly = false }
local espGuis = {}

-- Utility: button toggle factory for content area with nicer visuals
local function contentToggle(parent, y, key, startState)
    local lbl = new("TextLabel", {Parent = parent, Size = UDim2.new(1, -160, 0, 30), Position = UDim2.new(0,20,0,y), Text = t(key), TextXAlignment = Enum.TextXAlignment.Left, Font = Enum.Font.Gotham, TextSize = 18, BackgroundTransparency = 1, TextColor3 = Color3.fromRGB(230,230,240)})
    local btn = new("TextButton", {Parent = parent, Size = UDim2.new(0,120,0,32), Position = UDim2.new(1,-140,0,y), Text = startState and t("disable") or t("enable"), Font = Enum.Font.Gotham, TextSize = 14, BackgroundColor3 = Color3.fromRGB(70,70,80), TextColor3 = Color3.fromRGB(240,240,240)})
    new("UICorner", {Parent = btn, CornerRadius = UDim.new(0,6)})
    btn.MouseEnter:Connect(function() TweenService:Create(btn, TweenInfo.new(0.12), {BackgroundColor3 = Color3.fromRGB(86,86,96)}):Play() end)
    btn.MouseLeave:Connect(function() TweenService:Create(btn, TweenInfo.new(0.12), {BackgroundColor3 = Color3.fromRGB(70,70,80)}):Play() end)
    return btn, lbl
end

-- ESP functions (same as before)
local function createESP()
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
            if espGuis[p] then continue end
            local bb = Instance.new("BillboardGui")
            bb.Name = "UguzESP"
            bb.Size = UDim2.new(0,140,0,48)
            bb.AlwaysOnTop = true
            bb.Parent = p.Character:FindFirstChild("HumanoidRootPart")
            local label = Instance.new("TextLabel", bb)
            label.Size = UDim2.new(1,0,1,0)
            label.BackgroundTransparency = 0.3
            label.BackgroundColor3 = Color3.fromRGB(10,10,10)
            label.TextColor3 = Color3.fromRGB(255,120,120)
            label.TextStrokeTransparency = 0.6
            label.Font = Enum.Font.GothamBold
            label.TextSize = 14
            label.Text = p.Name
            local corner = Instance.new("UICorner", label)
            espGuis[p] = bb
        end
    end
end
local function removeESP()
    for p, g in pairs(espGuis) do
        if g and g.Parent then g:Destroy() end
    end
    espGuis = {}
end

-- Target heuristics and silent aim remain as non-invasive helpers
local function getPlayerRole(p)
    if p:FindFirstChild("Role") and p.Role.Value then return tostring(p.Role.Value) end
    if p:FindFirstChild("leaderstats") and p.leaderstats:FindFirstChild("Role") then return tostring(p.leaderstats.Role.Value) end
    if p.Character and p.Character:FindFirstChild("IsSheriff") then return p.Character.IsSheriff.Value and "Sheriff" or "" end
    if p.Team and p.Team.Name then return p.Team.Name end
    return ""
end

local function findTargetForSilentAim()
    local myRole = getPlayerRole(LocalPlayer)
    local targetRole = nil
    if string.find(string.lower(myRole), "sheriff") or string.find(string.lower(myRole), "sherif") then
        targetRole = "killer"
    elseif string.find(string.lower(myRole), "killer") or string.find(string.lower(myRole), "murderer") then
        targetRole = nil
    else
        targetRole = "any"
    end
    local best, bestDist = nil, math.huge
    local myPos = (LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") and LocalPlayer.Character.HumanoidRootPart.Position) or workspace.CurrentCamera.CFrame.p
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
            local role = string.lower(getPlayerRole(p) or "")
            local ok = false
            if targetRole == "any" then ok = true end
            if targetRole and targetRole ~= "any" then if string.find(role, string.lower(targetRole)) then ok = true end end
            if ok then
                local dist = (p.Character.HumanoidRootPart.Position - myPos).Magnitude
                if dist < bestDist then best = p; bestDist = dist end
            end
        end
    end
    return best
end

-- Simple silent aim camera assist (non-exploitative)
local cam = workspace.CurrentCamera
local aimConnection
local function enableSilentAim()
    toggles.SilentAim = true
    aimConnection = LocalPlayer:GetMouse().Button1Down:Connect(function()
        local target = findTargetForSilentAim()
        if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
            local trgCframe = CFrame.new(cam.CFrame.Position, target.Character.HumanoidRootPart.Position + Vector3.new(0,1.2,0))
            local info = TweenInfo.new(0.06, Enum.EasingStyle.Linear)
            local tw = TweenService:Create(cam, info, {CFrame = trgCframe})
            tw:Play()
            delay(0.08, function()
                -- return camera to previous orientation smoothly
                if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                    TweenService:Create(cam, TweenInfo.new(0.12), {CFrame = CFrame.new(cam.CFrame.Position, cam.CFrame.Position + cam.CFrame.LookVector)}):Play()
                end
            end)
        end
    end)
end
local function disableSilentAim()
    toggles.SilentAim = false
    if aimConnection then aimConnection:Disconnect(); aimConnection = nil end
end

-- Fly (simple local BodyVelocity)
local flyForce, flyLoop
local function enableFly()
    if toggles.Fly then return end
    toggles.Fly = true
    local char = LocalPlayer.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    flyForce = Instance.new("BodyVelocity")
    flyForce.MaxForce = Vector3.new(1e5,1e5,1e5)
    flyForce.Velocity = Vector3.new(0,0,0)
    flyForce.Parent = hrp
    flyLoop = RunService.Heartbeat:Connect(function()
        local speed = 48
        local dir = Vector3.new(0,0,0)
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then dir = dir + workspace.CurrentCamera.CFrame.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then dir = dir - workspace.CurrentCamera.CFrame.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then dir = dir - workspace.CurrentCamera.CFrame.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then dir = dir + workspace.CurrentCamera.CFrame.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then dir = dir + Vector3.new(0,1,0) end
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then dir = dir - Vector3.new(0,1,0) end
        flyForce.Velocity = dir.unit ~= dir.unit and Vector3.new(0,0,0) or dir * speed
    end)
end
local function disableFly()
    toggles.Fly = false
    if flyForce then flyForce:Destroy(); flyForce = nil end
    if flyLoop then flyLoop:Disconnect(); flyLoop = nil end
end

-- Fling (troll)
local function flingTarget(targetPlayer)
    if not targetPlayer or not targetPlayer.Character then return end
    local hrp = targetPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    local bv = Instance.new("BodyVelocity")
    bv.MaxForce = Vector3.new(1e6,1e6,1e6)
    bv.Velocity = Vector3.new(0,100,0) + (hrp.CFrame.LookVector * 60)
    bv.P = 1e5
    bv.Parent = hrp
    delay(0.6, function() pcall(function() bv:Destroy() end) end)
end

-- Prank bomb (visual)
local function spawnPrankBomb()
    local char = LocalPlayer.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end
    local part = Instance.new("Part")
    part.Size = Vector3.new(1.2,1.2,1.2)
    part.Shape = Enum.PartType.Ball
    part.BrickColor = BrickColor.new("Really red")
    part.Material = Enum.Material.Metal
    part.Position = char.HumanoidRootPart.Position + (workspace.CurrentCamera.CFrame.LookVector * 5) + Vector3.new(0,2,0)
    part.Anchored = false
    part.CanCollide = true
    part.Parent = workspace
    local b = Instance.new("PointLight", part)
    b.Color = Color3.fromRGB(255,120,120)
    b.Range = 8
    b.Brightness = 2
    delay(5, function()
        local pos = part.Position
        for i=1,6 do
            local aoe = Instance.new("Explosion")
            aoe.Position = pos
            aoe.BlastPressure = 0
            aoe.BlastRadius = 6
            aoe.Parent = workspace
        end
        pcall(function() part:Destroy() end)
    end)
end

-- Emote play helper
local EMOTE_ANIMS = { wave = "rbxassetid://507770239" }
local function playEmote(animId)
    local char = LocalPlayer.Character
    if not char then return end
    local humanoid = char:FindFirstChildWhichIsA("Humanoid")
    if not humanoid then return end
    local animator = humanoid:FindFirstChildOfClass("Animator") or Instance.new("Animator", humanoid)
    local anim = Instance.new("Animation")
    anim.AnimationId = animId
    local track = animator:LoadAnimation(anim)
    track:Play()
    delay(6, function() pcall(function() track:Stop(); anim:Destroy() end) end)
end

-- Content management
local function clearContent()
    for _, c in ipairs(contentArea:GetChildren()) do c:Destroy() end
end

local function updateTexts()
    titleLabel.Text = t("title")
    subtitleLabel.Text = t("subtitle")
    for k,btn in pairs(buttonsFolder) do
        if btn and btn:IsA("TextButton") then btn.Text = t(k) end
    end
    -- Update content greeting if present
    local greeting = contentArea:FindFirstChild("Greeting")
    if greeting and greeting:IsA("TextLabel") then greeting.Text = t("greeting") end
end

-- Section opener (improved visuals)
function openSection(key)
    clearContent()
    if key == "main" then
        local g = new("TextLabel", {Parent = contentArea, Name = "Greeting", Text = t("greeting"), Size = UDim2.new(1, -40, 0, 40), Position = UDim2.new(0,20,0,12), BackgroundTransparency = 1, Font = Enum.Font.GothamBold, TextSize = 20, TextColor3 = Color3.fromRGB(240,240,255), TextXAlignment = Enum.TextXAlignment.Left})
        local info = new("TextLabel", {Parent = contentArea, Text = t("welcome_line"), Size = UDim2.new(1,-40,0,100), Position = UDim2.new(0,20,0,64), BackgroundTransparency = 1, Font = Enum.Font.Gotham, TextSize = 16, TextColor3 = Color3.fromRGB(190,190,210)})
    elseif key == "autofarm" then
        local btn, lbl = contentToggle(contentArea, 16, "autofarm", toggles.Autofarm)
        btn.MouseButton1Click:Connect(function()
            toggles.Autofarm = not toggles.Autofarm
            btn.Text = toggles.Autofarm and t("disable") or t("enable")
        end)
    elseif key == "esp" then
        local btn, lbl = contentToggle(contentArea, 16, "esp", toggles.ESP)
        btn.MouseButton1Click:Connect(function()
            toggles.ESP = not toggles.ESP
            btn.Text = toggles.ESP and t("disable") or t("enable")
            if toggles.ESP then createESP() else removeESP() end
        end)
    elseif key == "silent" then
        local btn, lbl = contentToggle(contentArea, 16, "silent", toggles.SilentAim)
        btn.MouseButton1Click:Connect(function()
            if toggles.SilentAim then disableSilentAim() else enableSilentAim() end
            btn.Text = toggles.SilentAim and t("disable") or t("enable")
        end)
        local note = new("TextLabel", {Parent = contentArea, Text = "Note: Silent Aim is a camera assist example and must be adapted to game mechanics.", Size = UDim2.new(1,-40,0,60), Position = UDim2.new(0,20,0,64), BackgroundTransparency = 1, Font = Enum.Font.Gotham, TextSize = 14, TextColor3 = Color3.fromRGB(170,170,180)})
    elseif key == "trolls" then
        local flyBtn = new("TextButton", {Parent = contentArea, Position = UDim2.new(0,20,0,16), Size = UDim2.new(0,160,0,38), Text = t("fly"), Font = Enum.Font.Gotham, TextSize = 16})
        local flingBtn = new("TextButton", {Parent = contentArea, Position = UDim2.new(0,200,0,16), Size = UDim2.new(0,180,0,38), Text = t("fling"), Font = Enum.Font.Gotham, TextSize = 16})
        local invisBtn = new("TextButton", {Parent = contentArea, Position = UDim2.new(0,400,0,16), Size = UDim2.new(0,220,0,38), Text = t("invisible"), Font = Enum.Font.Gotham, TextSize = 16})
        for _,b in ipairs({flyBtn, flingBtn, invisBtn}) do new("UICorner", {Parent = b, CornerRadius = UDim.new(0,6)}) end
        flyBtn.MouseButton1Click:Connect(function() if toggles.Fly then disableFly() else enableFly() end; flyBtn.Text = toggles.Fly and (t("fly")..": ON") or t("fly") end)
        flingBtn.MouseButton1Click:Connect(function() local target = findTargetForSilentAim() or (function() for _,p in pairs(Players:GetPlayers()) do if p~=LocalPlayer then return p end end end)(); if target then flingTarget(target) end end)
        invisBtn.MouseButton1Click:Connect(function() local char = LocalPlayer.Character; if not char then return end; for _,part in pairs(char:GetDescendants()) do if part:IsA("BasePart") then part.LocalTransparencyModifier = 1 end end; delay(6, function() if char then for _,part in pairs(char:GetDescendants()) do if part:IsA("BasePart") then part.LocalTransparencyModifier = 0 end end end) end)
    elseif key == "emotes" then
        local info = new("TextLabel", {Parent = contentArea, Text = t("emote_example"), Size = UDim2.new(1,-40,0,40), Position = UDim2.new(0,20,0,16), BackgroundTransparency = 1, Font = Enum.Font.Gotham, TextSize = 16, TextColor3 = Color3.fromRGB(200,200,220)})
        local play = new("TextButton", {Parent = contentArea, Size = UDim2.new(0,160,0,38), Position = UDim2.new(0,20,0,64), Text = t("emote_example"), Font = Enum.Font.Gotham, TextSize = 16})
        new("UICorner", {Parent = play, CornerRadius = UDim.new(0,6)})
        play.MouseButton1Click:Connect(function() playEmote(EMOTE_ANIMS.wave) end)
    elseif key == "items" then
        local spawnBtn = new("TextButton", {Parent = contentArea, Size = UDim2.new(0,220,0,38), Position = UDim2.new(0,20,0,16), Text = t("spawn_prank"), Font = Enum.Font.Gotham, TextSize = 16})
        new("UICorner", {Parent = spawnBtn, CornerRadius = UDim.new(0,6)})
        spawnBtn.MouseButton1Click:Connect(spawnPrankBomb)
    elseif key == "settings" then
        local avatarFrame = new("Frame", {Parent = contentArea, Size = UDim2.new(0,260,0,140), Position = UDim2.new(0,20,0,16), BackgroundTransparency = 0.08})
        new("UICorner", {Parent = avatarFrame, CornerRadius = UDim.new(0,8)})
        local nameLabel = new("TextLabel", {Parent = avatarFrame, Text = t("profile")..": "..LocalPlayer.Name, Size = UDim2.new(1, -20, 0, 28), Position = UDim2.new(0,10,0,10), BackgroundTransparency = 1, Font = Enum.Font.GothamBold, TextSize = 16, TextColor3 = Color3.fromRGB(240,240,255)})
        local greet = new("TextLabel", {Parent = avatarFrame, Text = t("greeting"), Size = UDim2.new(1,-20,0,28), Position = UDim2.new(0,10,0,44), BackgroundTransparency = 1, Font = Enum.Font.Gotham, TextSize = 14, TextColor3 = Color3.fromRGB(200,200,220)})
    end
end

-- initialize
openSection("main")
updateTexts()

-- intro animation
panel.Position = UDim2.new(0,0,0,0)
local intro = TweenService:Create(mainFrame, TweenInfo.new(0.65, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {Position = UDim2.new(0.5, -390, 0.5, -230)})
intro:Play()

-- cleanup ESP on player leave
Players.PlayerRemoving:Connect(function(p)
    if espGuis[p] then espGuis[p]:Destroy(); espGuis[p] = nil end
end)

-- End of script
