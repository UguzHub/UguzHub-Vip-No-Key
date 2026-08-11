-- main.lua
-- UguzHub V2 Pro - Animated GUI + feature scaffolding for MM2 (client-side)
-- WARNING: This script is a client-side GUI & helper scaffold. Game-specific actions (weapon hooking, remote events)
-- must be adapted to the target game. Use at your own risk.

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local ContextActionService = game:GetService("ContextActionService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- Translations
local LANG = "tr" -- default
local TRANSLATIONS = {
    tr = {
        title = "UguzHub V2 Pro",
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
    },
    en = {
        title = "UguzHub V2 Pro",
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
    },
    ru = {
        title = "UguzHub V2 Pro",
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
    }
}

local function t(k)
    return (TRANSLATIONS[LANG] and TRANSLATIONS[LANG][k]) or TRANSLATIONS.tr[k] or k
end

-- Helper: create UI elements
local function new(class, props)
    local obj = Instance.new(class)
    for k, v in pairs(props or {}) do
        if k == "parent" then obj.Parent = v
        else pcall(function() obj[k] = v end)
        end
    end
    return obj
end

-- Root ScreenGui
local screen = new("ScreenGui", {Parent = PlayerGui, ResetOnSpawn = false, Name = "UguzHubGui"})

-- Main container
local mainFrame = new("Frame", {
    Parent = screen,
    Size = UDim2.new(0, 720, 0, 420),
    Position = UDim2.new(0.5, -360, 0.5, -210),
    BackgroundTransparency = 1,
    Name = "MainFrame",
})

-- Background blur + panel
local bg = new("Frame", {Parent = mainFrame, Size = UDim2.new(1,0,1,0), BackgroundColor3 = Color3.fromRGB(18,18,18), BackgroundTransparency = 0.12, Name = "BG"})
local panel = new("Frame", {Parent = bg, Size = UDim2.new(1,0,1,0), BackgroundColor3 = Color3.fromRGB(25,25,25), BackgroundTransparency = 0, BorderSizePixel = 0})
panel.BackgroundTransparency = 0
panel.BorderSizePixel = 0

-- Title / logo area
local titleBar = new("Frame", {Parent = panel, Size = UDim2.new(1,0,0,70), BackgroundTransparency = 0.15, Position = UDim2.new(0,0,0,0)})
local titleLabel = new("TextLabel", {Parent = titleBar, Text = t("title"), Font = Enum.Font.GothamBold, TextSize = 28, TextColor3 = Color3.fromRGB(255,255,255), BackgroundTransparency = 1, Position = UDim2.new(0,20,0,15)})

-- Language buttons
local flags = new("Frame", {Parent = titleBar, Size = UDim2.new(0,200,0,50), Position = UDim2.new(1,-210,0,10), BackgroundTransparency = 1})
local function makeFlag(nameCode, labelText, xOffset)
    local b = new("TextButton", {Parent = flags, Size = UDim2.new(0,60,0,30), Position = UDim2.new(0,xOffset,0,10), Text = labelText, Font = Enum.Font.Gotham, TextSize = 14, BackgroundColor3 = Color3.fromRGB(40,40,40), TextColor3 = Color3.fromRGB(255,255,255), Name = nameCode})
    b.MouseButton1Click:Connect(function()
        LANG = nameCode
        updateTexts()
        animatePanel("ripple")
    end)
    return b
end
makeFlag("tr", "TR", 0)
makeFlag("ru", "RU", 70)
makeFlag("en", "EN", 140)

-- Left menu buttons
local leftMenu = new("Frame", {Parent = panel, Size = UDim2.new(0,160,1,-70), Position = UDim2.new(0,0,0,70), BackgroundTransparency = 0.06})
local buttonsFolder = {}
local sections = {
    {key="main", text = t("main")},
    {key="autofarm", text = t("autofarm")},
    {key="esp", text = t("esp")},
    {key="silent", text = t("silent")},
    {key="trolls", text = t("trolls")},
    {key="emotes", text = t("emotes")},
    {key="items", text = t("items")},
    {key="settings", text = t("settings")},
}

local contentArea = new("Frame", {Parent = panel, Size = UDim2.new(1,-160,1,-70), Position = UDim2.new(0,160,0,70), BackgroundTransparency = 1})

local activeSection = nil

local function clearContent()
    for _, c in ipairs(contentArea:GetChildren()) do
        c:Destroy()
    end
end

local function updateTexts()
    titleLabel.Text = t("title")
    for i, s in ipairs(sections) do
        local b = buttonsFolder[s.key]
        if b then b.Text = t(s.key) end
    end
    if contentArea:FindFirstChild("Greeting") then
        contentArea.Greeting.Text = t("greeting")
    end
end

-- small helper: create labeled toggle
local function labeledToggle(parent, y, text, init)
    local lbl = new("TextLabel", {Parent = parent, Size = UDim2.new(1, -120, 0, 30), Position = UDim2.new(0, 20, 0, y), Text = text, TextXAlignment = Enum.TextXAlignment.Left, Font = Enum.Font.Gotham, TextSize = 18, BackgroundTransparency = 1, TextColor3 = Color3.new(1,1,1)})
    local btn = new("TextButton", {Parent = parent, Size = UDim2.new(0,80,0,30), Position = UDim2.new(1,-100,0,y), Text = init and t("disable") or t("enable"), Font = Enum.Font.Gotham, TextSize = 14, BackgroundColor3 = Color3.fromRGB(60,60,60), TextColor3 = Color3.fromRGB(255,255,255)})
    return btn, lbl
end

-- Build left menu buttons
for i, s in ipairs(sections) do
    local btn = new("TextButton", {Parent = leftMenu, Size = UDim2.new(1, -20, 0, 40), Position = UDim2.new(0, 10, 0, 10 + (i-1)*45), Text = t(s.key), Font = Enum.Font.Gotham, TextSize = 18, BackgroundColor3 = Color3.fromRGB(38,38,38), TextColor3 = Color3.fromRGB(255,255,255), Name = s.key})
    buttonsFolder[s.key] = btn
    btn.MouseButton1Click:Connect(function()
        openSection(s.key)
    end)
end

-- Animated ripple to emphasize language change
local function animatePanel(mode)
    local info = TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    TweenService:Create(panel, info, {BackgroundTransparency = 0.05}):Play()
    delay(0.28, function() TweenService:Create(panel, info, {BackgroundTransparency = 0}):Play() end)
end

-- Content for sections
local toggles = { Autofarm = false, ESP = false, SilentAim = false, Fly = false }

local espGuis = {}

local function createESP()
    -- add BillboardGui to every other player
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
            if espGuis[p] then continue end
            local bb = Instance.new("BillboardGui")
            bb.Name = "UguzESP"
            bb.Size = UDim2.new(0,120,0,40)
            bb.AlwaysOnTop = true
            bb.Parent = p.Character:FindFirstChild("HumanoidRootPart")
            local label = Instance.new("TextLabel", bb)
            label.Size = UDim2.new(1,0,1,0)
            label.BackgroundTransparency = 1
            label.TextColor3 = Color3.new(1,0,0)
            label.TextStrokeTransparency = 0.5
            label.Font = Enum.Font.GothamBold
            label.TextSize = 14
            label.Text = p.Name
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

-- Silent aim helper: choose target based on role value names (game-specific)
local function getPlayerRole(p)
    -- Heuristics: check for Role values in player or character
    if p:FindFirstChild("Role") and p.Role.Value then return tostring(p.Role.Value) end
    if p:FindFirstChild("leaderstats") and p.leaderstats:FindFirstChild("Role") then return tostring(p.leaderstats.Role.Value) end
    if p.Character and p.Character:FindFirstChild("IsSheriff") then return p.Character.IsSheriff.Value and "Sheriff" or "" end
    -- fallback: return team name
    if p.Team and p.Team.Name then return p.Team.Name end
    return ""
end

local function findTargetForSilentAim()
    -- If local player's role indicates Sheriff -> lock Killer
    local myRole = getPlayerRole(LocalPlayer)
    local targetRole = nil
    if string.find(string.lower(myRole), "sheriff") or string.find(string.lower(myRole), "sherif") then
        targetRole = "killer"
    elseif string.find(string.lower(myRole), "killer") or string.find(string.lower(myRole), "murderer") then
        -- if you're killer, don't lock to sheriff (user requested)
        targetRole = nil
    else
        -- fallback: choose nearest player who looks like an enemy
        targetRole = "any"
    end

    local best
    local bestDist = 1/0
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
            local role = string.lower(getPlayerRole(p) or "")
            local ok = false
            if targetRole == "any" then ok = true end
            if targetRole and targetRole ~= "any" then
                if string.find(role, string.lower(targetRole)) then ok = true end
            end
            if ok then
                local dist = (p.Character.HumanoidRootPart.Position - (LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") and LocalPlayer.Character.HumanoidRootPart.Position or workspace.CurrentCamera.CFrame.p)).Magnitude
                if dist < bestDist then best = p; bestDist = dist end
            end
        end
    end
    return best
end

-- Hook a simple silent aim: on mouse click, snap camera briefly to aim at target
local cam = workspace.CurrentCamera
local originalCFrame = nil
local aimConnection
local function enableSilentAim()
    toggles.SilentAim = true
    aimConnection = LocalPlayer:GetMouse().Button1Down:Connect(function()
        local target = findTargetForSilentAim()
        if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
            local trgCframe = CFrame.new(cam.CFrame.Position, target.Character.HumanoidRootPart.Position + Vector3.new(0,1.2,0))
            -- tween camera look
            local info = TweenInfo.new(0.06, Enum.EasingStyle.Linear)
            local goal = {CFrame = trgCframe}
            local tw = TweenService:Create(cam, info, goal)
            tw:Play()
            delay(0.08, function()
                -- return camera to player
                if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                    cam.CFrame = CFrame.new(cam.CFrame.Position, cam.CFrame.Position + cam.CFrame.LookVector)
                end
            end)
        end
    end)
end
local function disableSilentAim()
    toggles.SilentAim = false
    if aimConnection then aimConnection:Disconnect(); aimConnection = nil end
end

-- Fly implementation (simple local flight)
local flyForce
local flyLoop
local function enableFly()
    if toggles.Fly then return end
    toggles.Fly = true
    local char = LocalPlayer.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    flyForce = Instance.new("BodyVelocity")
    flyForce.MaxForce = Vector3.new(1e5, 1e5, 1e5)
    flyForce.Velocity = Vector3.new(0,0,0)
    flyForce.Parent = hrp
    flyLoop = RunService.Heartbeat:Connect(function()
        local speed = 40
        local move = Vector3.new(0,0,0)
        if UserInputService and UserInputService:IsKeyDown(Enum.KeyCode.W) then move = move + workspace.CurrentCamera.CFrame.LookVector end
        if UserInputService and UserInputService:IsKeyDown(Enum.KeyCode.S) then move = move - workspace.CurrentCamera.CFrame.LookVector end
        flyForce.Velocity = Vector3.new(move.X, move.Y, move.Z) * speed
    end)
end
local function disableFly()
    toggles.Fly = false
    if flyForce then flyForce:Destroy(); flyForce = nil end
    if flyLoop then flyLoop:Disconnect(); flyLoop = nil end
end

-- Fling (troll): brief strong velocity on target
local function flingTarget(targetPlayer)
    if not targetPlayer or not targetPlayer.Character or not targetPlayer.Character:FindFirstChild("HumanoidRootPart") then return end
    local hrp = targetPlayer.Character.HumanoidRootPart
    local bv = Instance.new("BodyVelocity")
    bv.MaxForce = Vector3.new(1e6, 1e6, 1e6)
    bv.Velocity = Vector3.new(0,80,0) + (hrp.CFrame.LookVector * 40)
    bv.P = 1e5
    bv.Parent = hrp
    delay(0.6, function() pcall(function() bv:Destroy() end) end)
end

-- Items: spawn a simple prank bomb (visual only)
local function spawnPrankBomb()
    local char = LocalPlayer.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end
    local part = Instance.new("Part")
    part.Size = Vector3.new(1,1,1)
    part.Shape = Enum.PartType.Block
    part.BrickColor = BrickColor.new("Really red")
    part.Position = char.HumanoidRootPart.Position + (workspace.CurrentCamera.CFrame.LookVector * 4) + Vector3.new(0,2,0)
    part.Anchored = false
    part.CanCollide = true
    part.Parent = workspace
    local mesh = Instance.new("SpecialMesh", part)
    mesh.MeshType = Enum.MeshType.Sphere
    delay(6, function()
        -- prank effect: small push outwards
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

-- Emotes: play animation if found in a mapping or in ReplicatedStorage
local EMOTE_ANIMS = {
    wave = "rbxassetid://507770239",
}
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

-- UI Section openers
function openSection(key)
    clearContent()
    activeSection = key
    if key == "main" then
        local l = new("TextLabel", {Parent = contentArea, Name = "Greeting", Text = t("greeting"), Size = UDim2.new(1,0,0,40), Position = UDim2.new(0,20,0,20), BackgroundTransparency = 1, Font = Enum.Font.GothamBold, TextSize = 20, TextColor3 = Color3.new(1,1,1)})
        local info = new("TextLabel", {Parent = contentArea, Text = "UguzHub V2 Pro\nLüks, animasyonlu menü. Geri kalan özellikleri kendin genişletebilirsin.", Size = UDim2.new(1,-40,0,140), Position = UDim2.new(0,20,0,80), BackgroundTransparency = 1, Font = Enum.Font.Gotham, TextSize = 16, TextColor3 = Color3.fromRGB(200,200,200)})
    elseif key == "autofarm" then
        local btn, lbl = labeledToggle(contentArea, 20, t("autofarm"), toggles.Autofarm)
        btn.MouseButton1Click:Connect(function()
            toggles.Autofarm = not toggles.Autofarm
            btn.Text = toggles.Autofarm and t("disable") or t("enable")
            -- Placeholder: wire to game-specific autofarm routine
        end)
    elseif key == "esp" then
        local btn, lbl = labeledToggle(contentArea, 20, t("esp"), toggles.ESP)
        btn.MouseButton1Click:Connect(function()
            toggles.ESP = not toggles.ESP
            btn.Text = toggles.ESP and t("disable") or t("enable")
            if toggles.ESP then createESP() else removeESP() end
        end)
    elseif key == "silent" then
        local btn, lbl = labeledToggle(contentArea, 20, t("silent"), toggles.SilentAim)
        btn.MouseButton1Click:Connect(function()
            if toggles.SilentAim then disableSilentAim() else enableSilentAim() end
            btn.Text = toggles.SilentAim and t("disable") or t("enable")
        end)
        local info = new("TextLabel", {Parent = contentArea, Text = "Not: Silent Aim game'e göre değişir. Bu bir genel yaklaşımdır.", Size = UDim2.new(1,-40,0,50), Position = UDim2.new(0,20,0,70), BackgroundTransparency = 1, Font = Enum.Font.Gotham, TextSize = 14, TextColor3 = Color3.fromRGB(180,180,180)})
    elseif key == "trolls" then
        local flyBtn = new("TextButton", {Parent = contentArea, Position = UDim2.new(0,20,0,20), Size = UDim2.new(0,140,0,34), Text = "Fly", Font = Enum.Font.Gotham, TextSize = 16})
        local flingBtn = new("TextButton", {Parent = contentArea, Position = UDim2.new(0,170,0,20), Size = UDim2.new(0,140,0,34), Text = "Fling nearest", Font = Enum.Font.Gotham, TextSize = 16})
        local invisBtn = new("TextButton", {Parent = contentArea, Position = UDim2.new(0,320,0,20), Size = UDim2.new(0,140,0,34), Text = "Invisible (local)", Font = Enum.Font.Gotham, TextSize = 16})
        flyBtn.MouseButton1Click:Connect(function()
            if toggles.Fly then disableFly() else enableFly() end
            flyBtn.Text = toggles.Fly and "Fly: ON" or "Fly"
        end)
        flingBtn.MouseButton1Click:Connect(function()
            local target = findTargetForSilentAim() or (function()
                for _, p in pairs(Players:GetPlayers()) do if p ~= LocalPlayer then return p end end
            end)()
            if target then flingTarget(target) end
        end)
        invisBtn.MouseButton1Click:Connect(function()
            local char = LocalPlayer.Character
            if not char then return end
            for _, part in pairs(char:GetDescendants()) do
                if part:IsA("BasePart") then part.LocalTransparencyModifier = 1 end
            end
            delay(6, function() if char then for _, part in pairs(char:GetDescendants()) do if part:IsA("BasePart") then part.LocalTransparencyModifier = 0 end end end)
        end)
    elseif key == "emotes" then
        local info = new("TextLabel", {Parent = contentArea, Text = "Emoteleri kullanmak için game'in ReplicatedStorage veya animation id'lerine göre bağlantı yapmanız gerekebilir.", Size = UDim2.new(1,-40,0,50), Position = UDim2.new(0,20,0,20), BackgroundTransparency = 1, Font = Enum.Font.Gotham, TextSize = 14, TextColor3 = Color3.fromRGB(200,200,200)})
        local button = new("TextButton", {Parent = contentArea, Size = UDim2.new(0,160,0,38), Position = UDim2.new(0,20,0,80), Text = "Wave (Örnek)", Font = Enum.Font.Gotham, TextSize = 16})
        button.MouseButton1Click:Connect(function()
            -- Example: play emote animation if you set a proper animation id
            playEmote(EMOTE_ANIMS.wave)
        end)
    elseif key == "items" then
        local spawnBtn = new("TextButton", {Parent = contentArea, Size = UDim2.new(0,160,0,38), Position = UDim2.new(0,20,0,20), Text = "Spawn PrankBomb", Font = Enum.Font.Gotham, TextSize = 16})
        spawnBtn.MouseButton1Click:Connect(spawnPrankBomb)
    elseif key == "settings" then
        local avatarFrame = new("Frame", {Parent = contentArea, Size = UDim2.new(0,220,0,120), Position = UDim2.new(0,20,0,20), BackgroundTransparency = 0.12})
        local nameLabel = new("TextLabel", {Parent = avatarFrame, Text = LocalPlayer.Name, Size = UDim2.new(1, -10, 0, 30), Position = UDim2.new(0,10,0,10), BackgroundTransparency = 1, Font = Enum.Font.GothamBold, TextSize = 18})
        local greet = new("TextLabel", {Parent = avatarFrame, Text = t("greeting"), Size = UDim2.new(1,-10,0,30), Position = UDim2.new(0,10,0,50), BackgroundTransparency = 1, Font = Enum.Font.Gotham, TextSize = 16})
    end
end

-- initialize
openSection("main")
updateTexts()

-- Simple show animation
panel.Position = UDim2.new(0,0,0,0)
panel.Size = UDim2.new(1,1,1,1)
local intro = TweenService:Create(mainFrame, TweenInfo.new(0.6, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {Position = UDim2.new(0.5, -360, 0.5, -210)})
intro:Play()

-- Cleanup when player leaves gui
Players.PlayerRemoving:Connect(function(p)
    if espGuis[p] then espGuis[p]:Destroy(); espGuis[p] = nil end
end)

-- End of script
