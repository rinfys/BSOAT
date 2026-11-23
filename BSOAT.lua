--// BSOAT — Best Script Of All Time
--// Unified exploit for BFL Football ecosystem
--// Auto-detects place and loads appropriate features
--// Mercury UI | Adonis bypass | Auto-goal | Auto-matchmaking

if getgenv().__BSOAT_LOADED then return end
getgenv().__BSOAT_LOADED = true

--// ═══════════════════════════════════════════
--//  ADONIS ANTICHEAT BYPASS
--// ═══════════════════════════════════════════
local _adonisD = false
local _adonisHooks = {}
local _adonisX, _adonisY

pcall(function()
    setthreadidentity(2)
    for _, v in getgc(true) do
        if typeof(v) == "table" then
            local a = rawget(v, "Detected")
            local b = rawget(v, "Kill")
            if typeof(a) == "function" and not _adonisX then
                _adonisX = a
                local o; o = hookfunction(_adonisX, function(c, f, n)
                    if c ~= "_" then
                        if _adonisD then warn("[BSOAT] Adonis flagged: " .. tostring(c)) end
                    end
                    return true
                end)
                table.insert(_adonisHooks, _adonisX)
            end
            if rawget(v, "Variables") and rawget(v, "Process") and typeof(b) == "function" and not _adonisY then
                _adonisY = b
                local o; o = hookfunction(_adonisY, function(f)
                    if _adonisD then warn("[BSOAT] Adonis kill blocked: " .. tostring(f)) end
                end)
                table.insert(_adonisHooks, _adonisY)
            end
        end
    end
    if _adonisX then
        local o; o = hookfunction(getrenv().debug.info, newcclosure(function(...)
            local a, f = ...
            if _adonisX and a == _adonisX then
                return coroutine.yield(coroutine.running())
            end
            return o(...)
        end))
    end
    setthreadidentity(7)
end)

task.wait(2)

--// ═══════════════════════════════════════════
--//  SERVICES & PLACE DETECTION
--// ═══════════════════════════════════════════
local Players = game:GetService("Players")
local RS = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local LP = Players.LocalPlayer

local PLACE = game.PlaceId
local PLACES = {
    FOOTBALL = 77716260620829,
    DUEL = 102215733027823,
    HUB = 110463824652211,
    MATCH = 130744705579030,
}

local MODE = "UNKNOWN"
if PLACE == PLACES.FOOTBALL then MODE = "FOOTBALL"
elseif PLACE == PLACES.DUEL then MODE = "DUEL"
elseif PLACE == PLACES.HUB then MODE = "HUB"
elseif PLACE == PLACES.MATCH then MODE = "MATCH"
else
    -- Try to detect by remotes present
    if RS:FindFirstChild("replication") then MODE = "MATCH"
    elseif RS:FindFirstChild("DuelShared") then
        if RS:FindFirstChild("endpointGateway") then MODE = "DUEL"
        else MODE = "HUB" end
    elseif RS:FindFirstChild("ExploitThis") or RS:FindFirstChild("YoureTrashAtTheGame") then
        MODE = "FOOTBALL"
    end
end

warn("[BSOAT] Place: " .. tostring(PLACE) .. " | Mode: " .. MODE)

--// ═══════════════════════════════════════════
--//  MERCURY UI
--// ═══════════════════════════════════════════
local Mercury = loadstring(game:HttpGet("https://raw.githubusercontent.com/deeeity/mercury/master/Mercury.lua"))()
local Window = Mercury:Create({
    Name = "BSOAT — " .. MODE,
    Size = UDim2.fromOffset(550, 400),
    Theme = Mercury.Themes.Dark,
    Link = "https://github.com/rinfys/BSOAT",
})

--// ═══════════════════════════════════════════
--//  SHARED HELPERS
--// ═══════════════════════════════════════════
local cfg = {}
local connections = {}
local function conn(c) table.insert(connections, c); return c end

local function getHRP()
    local ch = LP.Character
    return ch and ch:FindFirstChild("HumanoidRootPart")
end

local function getHum()
    local ch = LP.Character
    return ch and ch:FindFirstChildOfClass("Humanoid")
end

local function w(parent, name, t)
    if not parent then return nil end
    local ok, r = pcall(function() return parent:WaitForChild(name, t or 5) end)
    return ok and r or nil
end

--// ═══════════════════════════════════════════
--//  SHARED: BALL FINDER (robust, all places)
--// ═══════════════════════════════════════════
local BALL_NAMES = {"ball","aball","football","soccer","matchball","theball","soccerball","gameball","duelball","bflball"}

local function isInsideCharacter(obj)
    for _, p in ipairs(Players:GetPlayers()) do
        if p.Character and obj:IsDescendantOf(p.Character) then return true end
    end
    return false
end

local ballCache
local function getBall()
    if ballCache and ballCache.Parent then return ballCache end
    -- Check workspace.Balls folder (match stadiums)
    local balls = workspace:FindFirstChild("Balls")
    if balls then
        for _, c in pairs(balls:GetChildren()) do
            if c:IsA("BasePart") then ballCache = c return c end
        end
    end
    -- Direct name search
    for _, n in ipairs({"ABall","Ball","Football","Soccer","MatchBall"}) do
        local b = workspace:FindFirstChild(n, true)
        if b then
            if b:IsA("BasePart") and not isInsideCharacter(b) then ballCache = b return b end
            if b:IsA("Model") then
                local bp = b.PrimaryPart or b:FindFirstChildWhichIsA("BasePart")
                if bp then ballCache = bp return bp end
            end
        end
    end
    -- Shape-based fallback
    for _, c in pairs(workspace:GetChildren()) do
        if c:IsA("Part") and c.Shape == Enum.PartType.Ball then ballCache = c return c end
    end
    -- Descendant keyword search
    for _, d in ipairs(workspace:GetDescendants()) do
        if d:IsA("BasePart") and not d.Anchored and not isInsideCharacter(d) then
            local s = d.Size
            local lo, hi = math.min(s.X, s.Y, s.Z), math.max(s.X, s.Y, s.Z)
            if lo > 0.5 and hi < 8 and hi / lo < 2 then
                if d:IsA("MeshPart") or (d:IsA("Part") and d.Shape == Enum.PartType.Ball) then
                    ballCache = d return d
                end
            end
        end
    end
    return nil
end

--// ═══════════════════════════════════════════
--//  SHARED: KILL ANTICHEAT SCRIPTS
--// ═══════════════════════════════════════════
local function killACScripts(names)
    for _, container in pairs({LP:FindFirstChild("PlayerScripts"), LP:FindFirstChild("PlayerGui"), LP.Character}) do
        if container then
            for _, desc in pairs(container:GetDescendants()) do
                if desc:IsA("LocalScript") then
                    for _, n in ipairs(names) do
                        if desc.Name == n then
                            desc.Disabled = true
                            pcall(function() desc:Destroy() end)
                        end
                    end
                end
            end
        end
    end
end

--// ═══════════════════════════════════════════
--//  SHARED: MOVEMENT (Fly / Speed / Noclip)
--// ═══════════════════════════════════════════
cfg.fly = false; cfg.flySpeed = 100
cfg.speed = false; cfg.speedMult = 3
cfg.noclip = false
cfg.walkSpeed = 16; cfg.jumpPower = 50

local flyBV, flyBG

local function startFly()
    local hrp = getHRP(); if not hrp then return end
    if flyBV then flyBV:Destroy() end
    if flyBG then flyBG:Destroy() end
    flyBV = Instance.new("BodyVelocity", hrp)
    flyBV.MaxForce = Vector3.one * math.huge
    flyBV.Velocity = Vector3.zero
    flyBG = Instance.new("BodyGyro", hrp)
    flyBG.MaxTorque = Vector3.one * math.huge
    flyBG.P = 9e4
    flyBG.CFrame = hrp.CFrame
end

local function stopFly()
    if flyBV then flyBV:Destroy() flyBV = nil end
    if flyBG then flyBG:Destroy() flyBG = nil end
end

conn(RunService.Heartbeat:Connect(function()
    if not cfg.fly then if flyBV then stopFly() end return end
    if not flyBV then startFly() end
    local hrp = getHRP(); if not hrp then return end
    local cam = workspace.CurrentCamera.CFrame
    local d = Vector3.zero
    if UIS:IsKeyDown(Enum.KeyCode.W) then d = d + cam.LookVector end
    if UIS:IsKeyDown(Enum.KeyCode.S) then d = d - cam.LookVector end
    if UIS:IsKeyDown(Enum.KeyCode.A) then d = d - cam.RightVector end
    if UIS:IsKeyDown(Enum.KeyCode.D) then d = d + cam.RightVector end
    if UIS:IsKeyDown(Enum.KeyCode.Space) then d = d + Vector3.yAxis end
    if UIS:IsKeyDown(Enum.KeyCode.LeftControl) then d = d - Vector3.yAxis end
    if d.Magnitude > 0 then d = d.Unit end
    flyBV.Velocity = d * cfg.flySpeed
    flyBG.CFrame = cam
end))

conn(RunService.Heartbeat:Connect(function(dt)
    if not cfg.speed or cfg.fly then return end
    local hrp, hum = getHRP(), getHum()
    if not hrp or not hum then return end
    if hum.MoveDirection.Magnitude == 0 then return end
    hrp.CFrame = hrp.CFrame + hum.MoveDirection * (cfg.speedMult - 1) * hum.WalkSpeed * dt
end))

conn(RunService.Stepped:Connect(function()
    if not cfg.noclip then return end
    local ch = LP.Character; if not ch then return end
    for _, p in pairs(ch:GetDescendants()) do
        if p:IsA("BasePart") then p.CanCollide = false end
    end
end))

conn(RunService.Heartbeat:Connect(function()
    local hum = getHum(); if not hum then return end
    if cfg.walkSpeed ~= 16 then hum.WalkSpeed = cfg.walkSpeed end
    if cfg.jumpPower ~= 50 then hum.UseJumpPower = true; hum.JumpPower = cfg.jumpPower end
end))

--// ═══════════════════════════════════════════
--//  SHARED: BALL MAGNET + HITBOX
--// ═══════════════════════════════════════════
cfg.magnet = false; cfg.magnetDist = 200
cfg.hitbox = false; cfg.hitboxSize = 14

conn(RunService.Heartbeat:Connect(function()
    if not cfg.magnet then return end
    local hrp = getHRP(); if not hrp then return end
    local ball = getBall(); if not ball then return end
    if (ball.Position - hrp.Position).Magnitude > cfg.magnetDist then return end
    if firetouchinterest then
        firetouchinterest(hrp, ball, 0)
        task.defer(function() firetouchinterest(hrp, ball, 1) end)
    end
end))

conn(RunService.Heartbeat:Connect(function()
    if not cfg.hitbox then return end
    if not firetouchinterest then return end
    local hrp = getHRP(); if not hrp then return end
    local ball = getBall(); if not ball then return end
    if (hrp.Position - ball.Position).Magnitude <= cfg.hitboxSize then
        firetouchinterest(hrp, ball, false)
        task.defer(function() firetouchinterest(hrp, ball, true) end)
    end
end))

--// ═══════════════════════════════════════════
--//  MOVEMENT TAB (all modes)
--// ═══════════════════════════════════════════
local MovTab = Window:Tab({Name = "Movement", Icon = "rbxassetid://8569322835"})

MovTab:Toggle({Name = "Fly (WASD + Space/Ctrl)", Default = false, Callback = function(v) cfg.fly = v end})
MovTab:Slider({Name = "Fly Speed", Min = 20, Max = 500, Default = 100, Callback = function(v) cfg.flySpeed = v end})
MovTab:Toggle({Name = "Speed Boost", Default = false, Callback = function(v) cfg.speed = v end})
MovTab:Slider({Name = "Speed Multiplier", Min = 1, Max = 10, Default = 3, Callback = function(v) cfg.speedMult = v end})
MovTab:Toggle({Name = "Noclip", Default = false, Callback = function(v) cfg.noclip = v end})
MovTab:Slider({Name = "WalkSpeed", Min = 16, Max = 300, Default = 16, Callback = function(v) cfg.walkSpeed = v end})
MovTab:Slider({Name = "JumpPower", Min = 50, Max = 300, Default = 50, Callback = function(v) cfg.jumpPower = v end})

--// ═══════════════════════════════════════════
--//  BALL TAB (all modes)
--// ═══════════════════════════════════════════
local BallTab = Window:Tab({Name = "Ball", Icon = "rbxassetid://8569322835"})

BallTab:Toggle({Name = "Ball Magnet", Default = false, Callback = function(v) cfg.magnet = v end})
BallTab:Slider({Name = "Magnet Range", Min = 5, Max = 200, Default = 200, Callback = function(v) cfg.magnetDist = v end})
BallTab:Toggle({Name = "Hitbox Expander", Default = false, Callback = function(v) cfg.hitbox = v end})
BallTab:Slider({Name = "Hitbox Size", Min = 4, Max = 30, Default = 14, Callback = function(v) cfg.hitboxSize = v end})

BallTab:Button({Name = "Teleport Ball to Me", Callback = function()
    local ball = getBall(); local hrp = getHRP()
    if ball and hrp then ball.CFrame = hrp.CFrame + hrp.CFrame.LookVector * 5 end
end})

BallTab:Button({Name = "Kick Ball (Velocity)", Callback = function()
    local ball = getBall(); local hrp = getHRP()
    if ball and hrp then ball.Velocity = hrp.CFrame.LookVector * 200 + Vector3.new(0, 50, 0) end
end})

BallTab:Button({Name = "Freeze Ball", Callback = function()
    local ball = getBall(); if ball then ball.Anchored = true end
end})

BallTab:Button({Name = "Unfreeze Ball", Callback = function()
    local ball = getBall(); if ball then ball.Anchored = false end
end})

--// ═══════════════════════════════════════════
--//           FOOTBALL MODE (BFC)
--// ═══════════════════════════════════════════
if MODE == "FOOTBALL" then

local ExploitThisRemote = RS:FindFirstChild("ExploitThis")
local YoureTrashRemote = RS:FindFirstChild("YoureTrashAtTheGame")
local offenceRemote = RS:FindFirstChild("OffenceEvent")
local sbRemote = RS:FindFirstChild("SbEvent")
local refAnnsRemote = RS:FindFirstChild("refAnns")
local refereeStateRemote = RS:FindFirstChild("RefereeState")
local BlinkClient

local EXPECTED = {
    Head = Vector3.new(2,1,1), Torso = Vector3.new(2,2,1), HumanoidRootPart = Vector3.new(2,2,1),
    ["Left Arm"] = Vector3.new(1,2,1), ["Right Arm"] = Vector3.new(1,2,1),
    ["Left Leg"] = Vector3.new(1,2,1), ["Right Leg"] = Vector3.new(1,2,1),
}

-- Kill anticheat
killACScripts({"Anticheat", "ClientNoobBuster"})
conn(LP.CharacterAdded:Connect(function() task.wait(0.5) killACScripts({"Anticheat", "ClientNoobBuster"}) end))

-- Hook namecall to block AC reporting
pcall(function()
    local oldNC; oldNC = hookmetamethod(game, "__namecall", newcclosure(function(self, ...)
        if getnamecallmethod() == "FireServer" then
            if self == ExploitThisRemote or self == YoureTrashRemote then return nil end
        end
        return oldNC(self, ...)
    end))
end)

-- Own heartbeat using DOT syntax
task.spawn(function()
    while true do
        task.wait(1)
        local char = LP.Character
        if char and YoureTrashRemote then
            local snap = {}
            for name, size in pairs(EXPECTED) do
                if char:FindFirstChild(name) then snap[name] = size end
            end
            pcall(function() YoureTrashRemote.FireServer(YoureTrashRemote, snap) end)
        end
    end
end)

-- Blink client
task.spawn(function()
    local ok, blink = pcall(function() return RS:WaitForChild("Blink", 10) end)
    if ok and blink then
        local ok2, client = pcall(function() return require(blink:WaitForChild("Client", 10)) end)
        if ok2 and client then BlinkClient = client end
    end
end)

-- Kohl's Admin
local kohlsFly, kohlsNoclip = false, false

local FBTab = Window:Tab({Name = "Football", Icon = "rbxassetid://8569322835"})

FBTab:Toggle({Name = "Kohl's Fly", Default = false, Callback = function(v)
    kohlsFly = v
    pcall(function() LP:SetAttribute("_KFly", v and 256 or false) end)
end})

FBTab:Toggle({Name = "Kohl's Noclip", Default = false, Callback = function(v)
    kohlsNoclip = v
    pcall(function() LP:SetAttribute("_KNoclip", v and 256 or false) end)
end})

FBTab:Toggle({Name = "Power Lock", Default = false, Callback = function(v)
    cfg.powerLock = v
end})

task.spawn(function()
    while true do
        task.wait(0.3)
        if cfg.powerLock then
            pcall(function()
                local ihp = LP:FindFirstChild("IsHighPower")
                if ihp then ihp.Value = true end
            end)
            if BlinkClient then pcall(function() BlinkClient.BallPowerClient.Fire({BallPower = true}) end) end
        end
    end
end)

FBTab:Button({Name = "Become Referee", Callback = function()
    if refereeStateRemote then pcall(function() refereeStateRemote:FireServer(true) end) end
end})

local refMsg = ""
FBTab:Textbox({Name = "Ref Announcement", Default = "", Callback = function(v) refMsg = v end})
FBTab:Button({Name = "Send Ref Announcement", Callback = function()
    if refAnnsRemote and refMsg ~= "" then pcall(function() refAnnsRemote:FireServer(refMsg) end) end
end})

local cardTarget, cardTypeVal = "", ""
FBTab:Textbox({Name = "Card Target", Default = "", Callback = function(v) cardTarget = v end})
FBTab:Textbox({Name = "Card Type (yellow/red)", Default = "", Callback = function(v) cardTypeVal = v end})
FBTab:Button({Name = "Give Card", Callback = function()
    if offenceRemote then pcall(function() offenceRemote:FireServer(cardTypeVal, cardTarget) end) end
end})

FBTab:Button({Name = "Score Goal (SbEvent)", Callback = function()
    if sbRemote then pcall(function() sbRemote:FireServer(LP, "Goal") end) end
end})

FBTab:Button({Name = "Teleport Ball", Callback = function()
    local ball = getBall(); local hrp = getHRP()
    if ball and hrp then ball.CFrame = hrp.CFrame * CFrame.new(0, 3, 0) end
end})

end -- FOOTBALL

--// ═══════════════════════════════════════════
--//           DUEL MODE
--// ═══════════════════════════════════════════
if MODE == "DUEL" then

local endpointGateway = RS:FindFirstChild("endpointGateway")
local SwitchPlrVal = RS:FindFirstChild("SwitchPlrVal")
local EndAction = (RS:FindFirstChild("DuelShared") and RS.DuelShared:FindFirstChild("EndAction")) or RS:FindFirstChild("EndAction")
local Onboarding = RS:FindFirstChild("Onboarding")
local DuelShared = RS:FindFirstChild("DuelShared")
local Matchmaking = DuelShared and DuelShared:FindFirstChild("Matchmaking")

-- Kill anticheat
killACScripts({"endpointHandler", "MomentumGuard", "AntiAccessory", "Anticheat", "ClientNoobBuster"})
conn(LP.CharacterAdded:Connect(function()
    task.wait(0.3)
    killACScripts({"endpointHandler", "MomentumGuard", "AntiAccessory", "Anticheat", "ClientNoobBuster"})
end))

-- Hook endpointGateway
if endpointGateway and hookfunction then
    pcall(function()
        local real; real = hookfunction(endpointGateway.FireServer, function(self, opcode, payload)
            if self == endpointGateway and opcode == 0 then return end
            return real(self, opcode, payload)
        end)
    end)
end

-- Auto-goal system
cfg.autoGoal = false
cfg.autoMatchmaking = false
cfg.orbitBall = false; cfg.orbitRadius = 2

local function findOpponentGoal()
    -- Find the goal the opponent defends
    local char = LP.Character
    if not char then return nil end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return nil end

    -- Look for goal parts in workspace
    for _, d in ipairs(workspace:GetDescendants()) do
        if d:IsA("BasePart") then
            local n = d.Name:lower()
            if n:find("goal") and not n:find("post") then
                -- Pick the goal farthest from us (opponent's goal)
                if (d.Position - hrp.Position).Magnitude > 30 then
                    return d.Position
                end
            end
        end
    end

    -- Fallback: look for the goal line by checking workspace children
    local goals = {}
    for _, d in ipairs(workspace:GetDescendants()) do
        if d:IsA("Model") and d.Name:lower():find("goal") then
            local primary = d.PrimaryPart or d:FindFirstChildWhichIsA("BasePart")
            if primary then table.insert(goals, primary.Position) end
        end
    end

    if #goals >= 2 then
        -- Return farthest goal
        table.sort(goals, function(a, b)
            return (a - hrp.Position).Magnitude > (b - hrp.Position).Magnitude
        end)
        return goals[1]
    end

    return nil
end

-- Auto-goal loop: magnet ball, face opponent goal, kick
conn(RunService.Heartbeat:Connect(function()
    if not cfg.autoGoal then return end
    local hrp = getHRP(); if not hrp then return end
    local ball = getBall(); if not ball then return end
    local hum = getHum(); if not hum or hum.Health <= 0 then return end

    local dist = (hrp.Position - ball.Position).Magnitude

    -- Step 1: Get close to ball via magnet
    if dist > 3 then
        if firetouchinterest then
            firetouchinterest(hrp, ball, 0)
            task.defer(function() firetouchinterest(hrp, ball, 1) end)
        end
        -- Move towards ball
        local dir = (ball.Position - hrp.Position).Unit
        hrp.CFrame = CFrame.new(hrp.Position + dir * 2, ball.Position)
        return
    end

    -- Step 2: Ball is close, kick towards opponent goal
    local goalPos = findOpponentGoal()
    if goalPos then
        local kickDir = (goalPos - ball.Position).Unit
        pcall(function()
            ball.AssemblyLinearVelocity = kickDir * 250 + Vector3.new(0, 30, 0)
        end)
    else
        -- Fallback: kick forward
        pcall(function()
            ball.AssemblyLinearVelocity = hrp.CFrame.LookVector * 250 + Vector3.new(0, 30, 0)
        end)
    end
end))

-- Orbit ball (always touching)
conn(RunService.Heartbeat:Connect(function()
    if not cfg.orbitBall or cfg.magnet then return end
    local hrp = getHRP(); if not hrp then return end
    local ball = getBall(); if not ball then return end
    local hum = getHum(); if not hum or hum.Health <= 0 then return end
    local d = (hrp.Position - ball.Position).Magnitude
    if d > cfg.orbitRadius then
        local dir = (hrp.Position - ball.Position).Unit
        hrp.CFrame = CFrame.new(ball.Position + dir * cfg.orbitRadius) * CFrame.new(0, 1, 0)
    end
    if firetouchinterest then
        firetouchinterest(hrp, ball, 0)
        task.defer(function() firetouchinterest(hrp, ball, 1) end)
    end
end))

-- Auto-matchmaking loop
local mmState = "unknown"
if Matchmaking then
    Matchmaking.OnClientEvent:Connect(function(data)
        if type(data) ~= "table" then return end
        if data.type == "state" then mmState = data.kind or "unknown" end
        if data.type == "warnings" and data.notices then
            for _, notice in ipairs(data.notices) do
                pcall(function() Matchmaking:FireServer("warningSeen", {tostring(notice.id)}) end)
            end
        end
    end)
end

task.spawn(function()
    while true do
        task.wait(2)
        if cfg.autoMatchmaking and Matchmaking then
            if mmState == "idle" or mmState == "unknown" then
                pcall(function() Matchmaking:FireServer("sync") end)
                task.wait(0.5)
                pcall(function() Matchmaking:FireServer("queue") end)
            end
        end
    end
end)

-- Auto-requeue on match end
if EndAction then
    conn(LP.CharacterAdded:Connect(function()
        if cfg.autoMatchmaking then
            task.wait(2)
            pcall(function() EndAction:FireServer("requeue", true) end)
        end
    end))
end

-- Duel tab
local DuelTab = Window:Tab({Name = "Duel", Icon = "rbxassetid://8569322835"})

DuelTab:Toggle({Name = "Auto-Goal (shoot to opponent)", Default = false, Callback = function(v) cfg.autoGoal = v end})
DuelTab:Toggle({Name = "Auto Matchmaking (queue + requeue)", Default = false, Callback = function(v)
    cfg.autoMatchmaking = v
    if v and Matchmaking then
        -- Dismiss all warnings first
        for i = 1, 50 do pcall(function() Matchmaking:FireServer("warningSeen", {tostring(i)}) end) end
        pcall(function() Matchmaking:FireServer("sync") end)
    end
end})
DuelTab:Toggle({Name = "Ball Orbit (always touching)", Default = false, Callback = function(v) cfg.orbitBall = v end})
DuelTab:Slider({Name = "Orbit Radius", Min = 1, Max = 10, Default = 2, Callback = function(v) cfg.orbitRadius = v end})

DuelTab:Button({Name = "Mode: High", Callback = function()
    if SwitchPlrVal then SwitchPlrVal:FireServer("High", true) end
end})
DuelTab:Button({Name = "Mode: Low", Callback = function()
    if SwitchPlrVal then SwitchPlrVal:FireServer("Low", true) end
end})
DuelTab:Button({Name = "Mode: Dribble", Callback = function()
    if SwitchPlrVal then SwitchPlrVal:FireServer("Dribble", true) end
end})

local customMode = ""
DuelTab:Textbox({Name = "Custom Mode (raw inject)", Default = "", Callback = function(v) customMode = v end})
DuelTab:Button({Name = "Send Custom Mode", Callback = function()
    if SwitchPlrVal and customMode ~= "" then SwitchPlrVal:FireServer(customMode, true) end
end})

DuelTab:Button({Name = "Force Requeue", Callback = function()
    if EndAction then pcall(function() EndAction:FireServer("requeue", true) end) end
end})
DuelTab:Button({Name = "Force Lobby", Callback = function()
    if EndAction then pcall(function() EndAction:FireServer("lobby") end) end
end})

local fovVal = 120
DuelTab:Slider({Name = "Server FOV", Min = 50, Max = 500, Default = 120, Callback = function(v) fovVal = v end})
DuelTab:Button({Name = "Set Server FOV", Callback = function()
    if Onboarding then pcall(function() Onboarding:FireServer("fov", fovVal) end) end
end})

end -- DUEL

--// ═══════════════════════════════════════════
--//           HUB MODE
--// ═══════════════════════════════════════════
if MODE == "HUB" then

local SaveHubSetting = w(RS, "SaveHubSetting")
local GetHubSettings = w(RS, "GetHubSettings")
local StadiumTeleportRequest = w(RS, "StadiumTeleportRequest")
local Cosmetics = w(RS, "Cosmetics")
local Shop = Cosmetics and w(Cosmetics, "Shop")
local Remotes = w(RS, "Remotes")
local GetManagerData = Remotes and w(Remotes, "GetManagerData", 3)
local GetTeamSheetData = Remotes and w(Remotes, "GetTeamSheetData", 3)
local GetGoalAssistStats = Remotes and w(Remotes, "GetGoalAssistStats", 3)
local SendTransferOffer = Remotes and w(Remotes, "SendTransferOffer", 3)
local GetTransferMarketData = Remotes and w(Remotes, "GetTransferMarketData", 3)
local GetPlayerContracts = Remotes and w(Remotes, "GetPlayerContracts", 3)
local DuelShared = w(RS, "DuelShared")
local Matchmaking = DuelShared and w(DuelShared, "Matchmaking")
local SupporterGift = w(RS, "SupporterGift", 3)
local Choose = SupporterGift and w(SupporterGift, "Choose", 3)
local Others = SupporterGift and w(SupporterGift, "Others", 3)

-- Catalogue
local Catalogue, cachedItems = nil, {}
pcall(function()
    local CatModule = Cosmetics and Cosmetics:FindFirstChild("Catalogue")
    if CatModule then Catalogue = require(CatModule) end
end)

local function scanCatalogue()
    if not Catalogue then return end
    cachedItems = {}
    local function scan(tbl, depth)
        if depth > 4 then return end
        for _, v in pairs(tbl) do
            if type(v) == "table" then
                if v.Id and v.Name then
                    table.insert(cachedItems, {id = v.Id, name = v.Name, price = v.Price or 0, kind = v.Kind or "?"})
                else scan(v, depth + 1) end
            end
        end
    end
    scan(Catalogue, 0)
    table.sort(cachedItems, function(a, b) return (a.price or 0) < (b.price or 0) end)
    warn("[BSOAT] Found " .. #cachedItems .. " catalogue items")
end
scanCatalogue()

local HubTab = Window:Tab({Name = "Hub", Icon = "rbxassetid://8569322835"})

HubTab:Button({Name = "Get Shop State", Callback = function()
    if Shop then
        local ok, r = pcall(function() return Shop:InvokeServer("state") end)
        if ok then print("[BSOAT] Shop state:", r) end
    end
end})

HubTab:Button({Name = "Buy Cheapest Item", Callback = function()
    if #cachedItems == 0 then scanCatalogue() end
    if Shop and #cachedItems > 0 then
        local item = cachedItems[1]
        local ok, r = pcall(function() return Shop:InvokeServer("buy", item.id) end)
        print("[BSOAT] Buy " .. tostring(item.name) .. ": ", r)
    end
end})

HubTab:Button({Name = "Buy All Free Items", Callback = function()
    if #cachedItems == 0 then scanCatalogue() end
    for _, item in ipairs(cachedItems) do
        if (item.price or 0) == 0 then
            pcall(function() Shop:InvokeServer("buy", item.id) end)
            task.wait(0.1)
        end
    end
end})

HubTab:Button({Name = "Gift All to Self", Callback = function()
    if #cachedItems == 0 then scanCatalogue() end
    for i, item in ipairs(cachedItems) do
        if i > 10 then break end
        pcall(function() Shop:InvokeServer("gift", item.id, LP.UserId) end)
        task.wait(0.1)
    end
end})

HubTab:Button({Name = "Unequip Hat", Callback = function()
    if Shop then pcall(function() Shop:InvokeServer("unequip", "hat") end) end
end})

HubTab:Button({Name = "Unequip Ball", Callback = function()
    if Shop then pcall(function() Shop:InvokeServer("unequip", "ball") end) end
end})

HubTab:Button({Name = "List Catalogue (console)", Callback = function()
    if #cachedItems == 0 then scanCatalogue() end
    for _, item in ipairs(cachedItems) do
        print(string.format("[%s] %s $%d (%s)", tostring(item.id), tostring(item.name), item.price, item.kind))
    end
end})

local settingKey, settingVal = "", ""
HubTab:Textbox({Name = "Setting Key", Default = "", Callback = function(v) settingKey = v end})
HubTab:Textbox({Name = "Setting Value", Default = "", Callback = function(v) settingVal = v end})
HubTab:Button({Name = "Save Hub Setting", Callback = function()
    if SaveHubSetting and settingKey ~= "" then
        local val = tonumber(settingVal)
        if settingVal == "true" then val = true elseif settingVal == "false" then val = false end
        pcall(function() SaveHubSetting:InvokeServer(settingKey, val or settingVal) end)
    end
end})

HubTab:Button({Name = "Fake BFLCoins (UI only)", Callback = function()
    pcall(function() LP:SetAttribute("BFLCoins", 999999) end)
end})

HubTab:Button({Name = "Fake DuelElo (UI only)", Callback = function()
    pcall(function()
        local tcs = game:GetService("TextChatService")
        local channels = tcs:FindFirstChild("TextChannels")
        if channels then
            for _, ch in pairs(channels:GetChildren()) do
                for _, src in pairs(ch:GetChildren()) do
                    if src:IsA("TextSource") and src.UserId == LP.UserId then
                        src:SetAttribute("DuelElo", 9999)
                    end
                end
            end
        end
    end)
end})

HubTab:Button({Name = "Dump Manager Data", Callback = function()
    if GetManagerData then
        local ok, r = pcall(function() return GetManagerData:InvokeServer() end)
        if ok then print("[BSOAT] Manager:", r) end
    end
end})

HubTab:Button({Name = "Dump Team Sheet", Callback = function()
    if GetTeamSheetData then
        local ok, r = pcall(function() return GetTeamSheetData:InvokeServer() end)
        if ok then print("[BSOAT] TeamSheet:", r) end
    end
end})

HubTab:Button({Name = "Dump Stats", Callback = function()
    if GetGoalAssistStats then
        local ok, r = pcall(function() return GetGoalAssistStats:InvokeServer() end)
        if ok then print("[BSOAT] Stats:", r) end
    end
end})

HubTab:Button({Name = "Dump Contracts", Callback = function()
    if GetPlayerContracts then
        local ok, r = pcall(function() return GetPlayerContracts:InvokeServer() end)
        if ok then print("[BSOAT] Contracts:", r) end
    end
end})

HubTab:Button({Name = "Matchmaking Sync", Callback = function()
    if Matchmaking then pcall(function() Matchmaking:FireServer("sync") end) end
end})

HubTab:Button({Name = "Dismiss All Warnings", Callback = function()
    if Matchmaking then
        for i = 1, 50 do pcall(function() Matchmaking:FireServer("warningSeen", {tostring(i)}) end) end
    end
end})

HubTab:Button({Name = "Teleport to Football", Callback = function()
    if StadiumTeleportRequest then pcall(function() StadiumTeleportRequest:FireServer(PLACES.FOOTBALL) end) end
end})

HubTab:Button({Name = "Teleport to Match", Callback = function()
    if StadiumTeleportRequest then pcall(function() StadiumTeleportRequest:FireServer(PLACES.MATCH) end) end
end})

HubTab:Button({Name = "Teleport to Duel", Callback = function()
    if StadiumTeleportRequest then pcall(function() StadiumTeleportRequest:FireServer(PLACES.DUEL) end) end
end})

end -- HUB

--// ═══════════════════════════════════════════
--//           MATCH MODE (BFL Stadiums)
--// ═══════════════════════════════════════════
if MODE == "MATCH" then

local mainEvent, mainGateway, fansGateway, fanSyncGateway
local endpointGateway, SwitchPlrVal, BallSwitchSync
local managerAction, SubstitutionUpdate
local BFLCoins, Spray, EquipReward, PlayerCard
local afkEvent, BallSystem_match = {}, {}

pcall(function()
    local rep = RS:WaitForChild("replication", 5)
    if rep then
        mainEvent = rep:FindFirstChild("mainEvent")
        mainGateway = rep:FindFirstChild("mainGateway")
        fansGateway = rep:FindFirstChild("fansGateway")
        fanSyncGateway = rep:FindFirstChild("fanSyncGateway")
    end
end)

pcall(function()
    local rem = RS:FindFirstChild("Remotes")
    if rem then
        Spray = rem:FindFirstChild("Spray")
        EquipReward = rem:FindFirstChild("EquipReward")
        PlayerCard = rem:FindFirstChild("PlayerCard")
        managerAction = rem:FindFirstChild("managerAction")
        SubstitutionUpdate = rem:FindFirstChild("SubstitutionUpdate")
    end
end)

pcall(function()
    endpointGateway = RS:FindFirstChild("endpointGateway")
    SwitchPlrVal = RS:FindFirstChild("SwitchPlrVal")
    BallSwitchSync = RS:FindFirstChild("BallSwitchSync")
    BFLCoins = RS:FindFirstChild("BFLCoins")
    afkEvent = RS:FindFirstChild("afkEvent")
end)

-- Kill anticheat
killACScripts({"endpointHandler", "ballHandler", "MomentumGuard", "Anticheat"})
conn(LP.CharacterAdded:Connect(function() task.wait(0.3) killACScripts({"endpointHandler", "ballHandler", "MomentumGuard"}) end))

-- Anti-AFK
cfg.antiAFK = true
if afkEvent then
    task.spawn(function()
        while task.wait(60) do
            if cfg.antiAFK then pcall(function() afkEvent:FireServer(false) end) end
        end
    end)
end

-- Ball mode tab
local ModeTab = Window:Tab({Name = "Ball Mode", Icon = "rbxassetid://8569322835"})

ModeTab:Button({Name = "Mode: High", Callback = function()
    if SwitchPlrVal then SwitchPlrVal:FireServer("High", true) end
end})
ModeTab:Button({Name = "Mode: Low", Callback = function()
    if SwitchPlrVal then SwitchPlrVal:FireServer("Low", true) end
end})
ModeTab:Button({Name = "Mode: Dribble", Callback = function()
    if SwitchPlrVal then SwitchPlrVal:FireServer("Dribble", true) end
end})

local customModeM = ""
ModeTab:Textbox({Name = "Custom Mode (raw inject)", Default = "", Callback = function(v) customModeM = v end})
ModeTab:Button({Name = "Send Custom Mode", Callback = function()
    if SwitchPlrVal and customModeM ~= "" then SwitchPlrVal:FireServer(customModeM, true) end
end})

ModeTab:Button({Name = "Mode Spam (10x)", Callback = function()
    if not SwitchPlrVal then return end
    task.spawn(function()
        local modes = {"High", "Low", "Dribble", "INVALID", ""}
        for i = 1, 10 do
            SwitchPlrVal:FireServer(modes[(i % #modes) + 1], true)
            task.wait(0.1)
        end
    end)
end})

-- Referee tab
local RefTab = Window:Tab({Name = "Referee", Icon = "rbxassetid://8569322835"})

local refToggles = {"togglePitchDoor","flipGoals","toggleGLT","toggleOffsideTracking","toggleRain","toggleNight","toggleTrainingWall","toggleDisallowBallSpawn"}
for _, action in ipairs(refToggles) do
    RefTab:Button({Name = action, Callback = function()
        if mainEvent then mainEvent:FireServer(action) end
    end})
end

RefTab:Button({Name = "Resume Game", Callback = function() if mainEvent then mainEvent:FireServer("resumeGame") end end})
RefTab:Button({Name = "Pause Game", Callback = function() if mainEvent then mainEvent:FireServer("pauseGame") end end})
RefTab:Button({Name = "Half Time", Callback = function() if mainEvent then mainEvent:FireServer("halfTime") end end})
RefTab:Button({Name = "Full Time", Callback = function() if mainEvent then mainEvent:FireServer("fullTime") end end})
RefTab:Button({Name = "Extra Time 1", Callback = function() if mainEvent then mainEvent:FireServer("ExtraTime") end end})
RefTab:Button({Name = "Extra Time 2", Callback = function() if mainEvent then mainEvent:FireServer("ExtraTime2") end end})
RefTab:Button({Name = "Toggle Official Game", Callback = function() if mainEvent then mainEvent:FireServer("toggleOfficialGame") end end})
RefTab:Button({Name = "End Official Game", Callback = function() if mainEvent then mainEvent:FireServer("endOfficialGame") end end})
RefTab:Button({Name = "Toggle Substitutions", Callback = function() if mainEvent then mainEvent:FireServer("toggleSubstitutions") end end})

RefTab:Button({Name = "Spawn Ball (Center)", Callback = function() if mainEvent then mainEvent:FireServer("ballManagerSpawn", {"center"}) end end})
RefTab:Button({Name = "Spawn Ball (Left)", Callback = function() if mainEvent then mainEvent:FireServer("ballManagerSpawn", {"left"}) end end})
RefTab:Button({Name = "Spawn Ball (Right)", Callback = function() if mainEvent then mainEvent:FireServer("ballManagerSpawn", {"right"}) end end})
RefTab:Button({Name = "Thaw Ball", Callback = function() if mainEvent then mainEvent:FireServer("ballManagerAction", {"thaw"}) end end})
RefTab:Button({Name = "Freeze Ball (Server)", Callback = function() if mainEvent then mainEvent:FireServer("ballManagerAction", {"freeze"}) end end})
RefTab:Button({Name = "Clear All Balls", Callback = function() if mainEvent then mainEvent:FireServer("ballManagerAction", {"clear"}) end end})

local goalScorer, goalTeam = "", ""
RefTab:Textbox({Name = "Goal Scorer", Default = "", Callback = function(v) goalScorer = v end})
RefTab:Textbox({Name = "Goal Team", Default = "", Callback = function(v) goalTeam = v end})
RefTab:Button({Name = "Award Goal", Callback = function()
    if mainEvent then mainEvent:FireServer("awardGoal", {LP.UserId, goalScorer, goalTeam}) end
end})
RefTab:Button({Name = "Disallow Goal", Callback = function()
    if mainEvent then mainEvent:FireServer("disallowGoal", {LP.UserId}) end
end})

local cardP, cardT, cardR = "", "", ""
RefTab:Textbox({Name = "Card Player", Default = "", Callback = function(v) cardP = v end})
RefTab:Textbox({Name = "Card Type", Default = "", Callback = function(v) cardT = v end})
RefTab:Textbox({Name = "Card Reason", Default = "", Callback = function(v) cardR = v end})
RefTab:Button({Name = "Give Card", Callback = function()
    if mainEvent then mainEvent:FireServer("giveCard", {cardP, cardT, cardR}) end
end})

local tMin, tSec = 0, 0
RefTab:Textbox({Name = "Time Minutes", Default = "0", Callback = function(v) tMin = tonumber(v) or 0 end})
RefTab:Textbox({Name = "Time Seconds", Default = "0", Callback = function(v) tSec = tonumber(v) or 0 end})
RefTab:Button({Name = "Set Custom Time", Callback = function()
    if mainEvent then mainEvent:FireServer("setCustomTime", {tMin, tSec}) end
end})

local fName, fPri, fSec2 = "", "255,255,255", "255,255,255"
RefTab:Textbox({Name = "Fixture Name", Default = "", Callback = function(v) fName = v end})
RefTab:Textbox({Name = "Primary Color (R,G,B)", Default = "255,255,255", Callback = function(v) fPri = v end})
RefTab:Textbox({Name = "Secondary Color (R,G,B)", Default = "255,255,255", Callback = function(v) fSec2 = v end})

local function parseColor(str)
    local r, g, b = str:match("(%d+)%s*,%s*(%d+)%s*,%s*(%d+)")
    if r then return Color3.fromRGB(tonumber(r), tonumber(g), tonumber(b)) end
    return Color3.fromRGB(255, 255, 255)
end

RefTab:Button({Name = "Set Home Fixture", Callback = function()
    if mainEvent then mainEvent:FireServer("setHomeFixture", {fName, parseColor(fPri), parseColor(fSec2)}) end
end})
RefTab:Button({Name = "Set Away Fixture", Callback = function()
    if mainEvent then mainEvent:FireServer("setAwayFixture", {fName, parseColor(fPri), parseColor(fSec2)}) end
end})

local compName = ""
RefTab:Textbox({Name = "Competition Name", Default = "", Callback = function(v) compName = v end})
RefTab:Button({Name = "Set Competition", Callback = function()
    if mainEvent then mainEvent:FireServer("setCompetition", {compName}) end
end})

-- Manager tab
local MgrTab = Window:Tab({Name = "Manager", Icon = "rbxassetid://8569322835"})

local mgrMsg = ""
MgrTab:Textbox({Name = "Manager Message", Default = "", Callback = function(v) mgrMsg = v end})
MgrTab:Button({Name = "Send Message", Callback = function()
    if managerAction then managerAction:FireServer("message", mgrMsg) end
end})

local sOut, sIn = "", ""
MgrTab:Textbox({Name = "Sub OUT", Default = "", Callback = function(v) sOut = v end})
MgrTab:Textbox({Name = "Sub IN", Default = "", Callback = function(v) sIn = v end})
MgrTab:Button({Name = "Submit Substitution", Callback = function()
    if managerAction then managerAction:FireServer("sub", {out = sOut, inn = sIn}) end
end})

local spA, spB = "", ""
MgrTab:Textbox({Name = "Swap Player A", Default = "", Callback = function(v) spA = v end})
MgrTab:Textbox({Name = "Swap Player B", Default = "", Callback = function(v) spB = v end})
MgrTab:Button({Name = "Swap Positions", Callback = function()
    if managerAction then managerAction:FireServer("swapPos", {a = spA, b = spB}) end
end})

-- Data + Misc tab
local DataTab = Window:Tab({Name = "Data & Misc", Icon = "rbxassetid://8569322835"})

DataTab:Button({Name = "Get Referee Log", Callback = function()
    if mainGateway then
        local ok, d = pcall(function() return mainGateway:InvokeServer("getRefereeLog") end)
        if ok then print("[BSOAT] Ref Log:", d) end
    end
end})

DataTab:Button({Name = "Get Goal Log", Callback = function()
    if mainGateway then
        local ok, d = pcall(function() return mainGateway:InvokeServer("getGoalLog") end)
        if ok then print("[BSOAT] Goal Log:", d) end
    end
end})

DataTab:Button({Name = "Get Fans Data", Callback = function()
    if fanSyncGateway then
        local ok, d = pcall(function() return fanSyncGateway:InvokeServer() end)
        if ok then print("[BSOAT] Fans:", d) end
    end
end})

DataTab:Button({Name = "Spray", Callback = function()
    if Spray then Spray:FireServer() end
end})

DataTab:Button({Name = "Collect BFLCoins", Callback = function()
    if BFLCoins then BFLCoins:FireServer(true) end
end})

DataTab:Toggle({Name = "Anti-AFK", Default = true, Callback = function(v) cfg.antiAFK = v end})

DataTab:Button({Name = "Toggle Rain (Client)", Callback = function()
    local r = RS:FindFirstChild("isRaining")
    if r then r.Value = not r.Value end
end})

DataTab:Button({Name = "Toggle Night (Client)", Callback = function()
    local n = RS:FindFirstChild("night")
    if n then n.Value = not n.Value end
end})

DataTab:Button({Name = "Dump All Remotes (console)", Callback = function()
    for _, d in pairs(RS:GetDescendants()) do
        if d:IsA("RemoteEvent") or d:IsA("RemoteFunction") or d:IsA("UnreliableRemoteEvent") then
            print("[REMOTE]", d:GetFullName(), d.ClassName)
        end
    end
end})

end -- MATCH

--// ═══════════════════════════════════════════
--//  INFO TAB (all modes)
--// ═══════════════════════════════════════════
local InfoTab = Window:Tab({Name = "Info", Icon = "rbxassetid://8569322835"})

InfoTab:Button({Name = "Copy Place ID", Callback = function()
    pcall(function() setclipboard(tostring(PLACE)) end)
end})

InfoTab:Button({Name = "Copy User ID", Callback = function()
    pcall(function() setclipboard(tostring(LP.UserId)) end)
end})

InfoTab:Button({Name = "Rejoin Server", Callback = function()
    pcall(function()
        game:GetService("TeleportService"):Teleport(PLACE, LP)
    end)
end})

InfoTab:Button({Name = "Dump All Remotes", Callback = function()
    for _, d in pairs(RS:GetDescendants()) do
        if d:IsA("RemoteEvent") or d:IsA("RemoteFunction") or d:IsA("UnreliableRemoteEvent") then
            print("[REMOTE]", d:GetFullName(), d.ClassName)
        end
    end
end})

warn("[BSOAT] Loaded! Mode: " .. MODE .. " | Place: " .. tostring(PLACE))
warn("[BSOAT] Press RightShift to toggle UI")
