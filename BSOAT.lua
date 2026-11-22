--// ═══════════════════════════════════════════
--//  ADONIS ANTICHEAT BYPASS (runs first)
--//  Uses getgc + hookfunction to neutralize Adonis
--// ═══════════════════════════════════════════

local g = getinfo or debug.getinfo
local d = false
local h = {}

local x, y

setthreadidentity(2)

for i, v in getgc(true) do
    if typeof(v) == "table" then
        local a = rawget(v, "Detected")
        local b = rawget(v, "Kill")

            if typeof(a) == "function" and not x then
                x = a

                  local o; o = hookfunction(x, function(c, f, n)
                      if c ~= "_" then
                          if d then
                              warn(`Adonis AntiCheat flagged\nMethod: {c}\nInfo: {f}`)
                          end
                      end

                      return true
                  end)

                  table.insert(h, x)
            end

        if rawget(v, "Variables") and rawget(v, "Process") and typeof(b) ==
"function" and not y then
            y = b
            local o; o = hookfunction(y, function(f)
                 if d then
                     warn(`Adonis AntiCheat tried to kill (fallback): {f}`)
                 end
            end)

                  table.insert(h, y)
            end
      end
end

local o; o = hookfunction(getrenv().debug.info, newcclosure(function(...)
    local a, f = ...

      if x and a == x then
          if d then
              warn(`zins | adonis bypassed`)
          end

            return coroutine.yield(coroutine.running())
      end

    return o(...)
end))

setthreadidentity(7)

--// ═══════════════════════════════════════════
--//  ADONIS BYPASS MODULE (Luraph-obfuscated)
--// ═══════════════════════════════════════════

getgenv().debugInfo = true -- Set to true for more info in console, keep to false if u dont want any logs
loadstring(game:HttpGet("https://raw.githubusercontent.com/Pixeluted/adoniscries/main/Source.lua",true))()
--// ═══════════════════════════════════════════
--//  Wait for bypass to settle before main script
--// ═══════════════════════════════════════════
task.wait(10)

--// Match Exploit — Place_130744705579030
--// Football match stadium with referee panel, manager controls, ball system
--// SERVER VALIDATES REFEREE PERMISSIONS — mainEvent calls = BAN
--// Safe: ball mode, ball magnet, spray, coins, data queries, anti-AFK

local Players = game:GetService("Players")
local RS = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local LP = Players.LocalPlayer

--// ═══════════════════════════════════════════
--//  REMOTE DISCOVERY
--// ═══════════════════════════════════════════
local mainEvent, mainGateway, fansEvent, fansGateway, fanSyncGateway
local endpointGateway, popperGateway
local SwitchPlrVal, BallSwitchSync
local managerAction, managerNotify, SubstitutionUpdate
local BFLCoins, Spray, Equip, EquipReward, PlayerCard
local ColorChangeEvent, TeleportToHub, SetNameplatePriority
local rain, afkEvent, deviceEvent, pingEvent, BFLNetProbe, pingChallenge

local BallSystem = {}

pcall(function()
    local rep = RS:WaitForChild("replication", 5)
    if rep then
        mainEvent = rep:FindFirstChild("mainEvent")
        mainGateway = rep:FindFirstChild("mainGateway")
        fansGateway = rep:FindFirstChild("fansGateway")
        fansEvent = rep:FindFirstChild("fansEvent")
        fanSyncGateway = rep:FindFirstChild("fanSyncGateway")
    end
end)

pcall(function()
    local bs = RS:FindFirstChild("BallSystem")
    if bs then
        for _, c in pairs(bs:GetChildren()) do
            BallSystem[c.Name] = c
        end
    end
end)

pcall(function()
    local rem = RS:FindFirstChild("Remotes")
    if rem then
        Spray = rem:FindFirstChild("Spray")
        Equip = rem:FindFirstChild("Equip")
        EquipReward = rem:FindFirstChild("EquipReward")
        PlayerCard = rem:FindFirstChild("PlayerCard")
        managerAction = rem:FindFirstChild("managerAction")
        managerNotify = rem:FindFirstChild("managerNotify")
        SubstitutionUpdate = rem:FindFirstChild("SubstitutionUpdate")
        SetNameplatePriority = rem:FindFirstChild("SetNameplatePriority")
        TeleportToHub = rem:FindFirstChild("TeleportToHub")
    end
end)

pcall(function()
    endpointGateway = RS:FindFirstChild("endpointGateway")
    popperGateway = RS:FindFirstChild("__popperGateway")
    SwitchPlrVal = RS:FindFirstChild("SwitchPlrVal")
    BallSwitchSync = RS:FindFirstChild("BallSwitchSync")
    BFLCoins = RS:FindFirstChild("BFLCoins")
    ColorChangeEvent = RS:FindFirstChild("ColorChangeEvent")
    rain = RS:FindFirstChild("rain")
    afkEvent = RS:FindFirstChild("afkEvent")
    deviceEvent = RS:FindFirstChild("deviceEvent")
    pingEvent = RS:FindFirstChild("pingEvent")
    BFLNetProbe = RS:FindFirstChild("BFLNetProbe")
    pingChallenge = RS:FindFirstChild("pingChallenge")
end)

--// ═══════════════════════════════════════════
--//  CONFIG STATE
--// ═══════════════════════════════════════════
local cfg = {
    ballMagnet = false,
    antiAFK = true
}
local logLines = {}

--// ═══════════════════════════════════════════
--//  GUI SETUP
--// ═══════════════════════════════════════════
local gui = Instance.new("ScreenGui")
gui.Name = "MatchExploit"
gui.ResetOnSpawn = false
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

gui.Parent = LP:WaitForChild("PlayerGui")

local main = Instance.new("Frame")
main.Name = "Main"
main.Size = UDim2.new(0, 310, 0, 500)
main.Position = UDim2.new(0, 20, 0.5, -250)
main.BackgroundColor3 = Color3.fromRGB(18, 18, 24)
main.BorderSizePixel = 0
main.Parent = gui
Instance.new("UICorner", main).CornerRadius = UDim.new(0, 8)

local titleBar = Instance.new("Frame")
titleBar.Name = "Title"
titleBar.Size = UDim2.new(1, 0, 0, 32)
titleBar.BackgroundColor3 = Color3.fromRGB(120, 25, 25)
titleBar.BorderSizePixel = 0
titleBar.Parent = main
Instance.new("UICorner", titleBar).CornerRadius = UDim.new(0, 8)

local titleLbl = Instance.new("TextLabel")
titleLbl.Size = UDim2.new(1, -60, 1, 0)
titleLbl.Position = UDim2.new(0, 10, 0, 0)
titleLbl.BackgroundTransparency = 1
titleLbl.Text = "MATCH EXPLOIT"
titleLbl.TextColor3 = Color3.new(1, 1, 1)
titleLbl.Font = Enum.Font.GothamBold
titleLbl.TextSize = 14
titleLbl.TextXAlignment = Enum.TextXAlignment.Left
titleLbl.Parent = titleBar

local statusLbl = Instance.new("TextLabel")
statusLbl.Size = UDim2.new(1, -10, 0, 16)
statusLbl.Position = UDim2.new(0, 5, 0, 32)
statusLbl.BackgroundTransparency = 1
statusLbl.TextColor3 = Color3.fromRGB(180, 180, 180)
statusLbl.Font = Enum.Font.Gotham
statusLbl.TextSize = 10
statusLbl.TextXAlignment = Enum.TextXAlignment.Left
statusLbl.Parent = main

local function updateStatus()
    statusLbl.Text = "Main:" .. (mainEvent and "OK" or "X")
        .. " Gate:" .. (mainGateway and "OK" or "X")
        .. " Ball:" .. (next(BallSystem) and "OK" or "X")
        .. " EP:" .. (endpointGateway and "OK" or "X")
        .. " Mgr:" .. (managerAction and "OK" or "X")
end
updateStatus()

-- Minimize button
local minBtn = Instance.new("TextButton")
minBtn.Size = UDim2.new(0, 24, 0, 24)
minBtn.Position = UDim2.new(1, -28, 0, 4)
minBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
minBtn.TextColor3 = Color3.new(1, 1, 1)
minBtn.Font = Enum.Font.GothamBold
minBtn.TextSize = 14
minBtn.Text = "−"
minBtn.Parent = titleBar
Instance.new("UICorner", minBtn).CornerRadius = UDim.new(0, 4)

local container = Instance.new("ScrollingFrame")
container.Name = "Container"
container.Size = UDim2.new(1, -10, 1, -78)
container.Position = UDim2.new(0, 5, 0, 50)
container.BackgroundTransparency = 1
container.ScrollBarThickness = 4
container.ScrollBarImageColor3 = Color3.fromRGB(120, 25, 25)
container.CanvasSize = UDim2.new(0, 0, 0, 3200)
container.Parent = main

local layout = Instance.new("UIListLayout")
layout.SortOrder = Enum.SortOrder.LayoutOrder
layout.Padding = UDim.new(0, 3)
layout.Parent = container

-- Log panel
local logFrame = Instance.new("Frame")
logFrame.Size = UDim2.new(1, -10, 0, 44)
logFrame.Position = UDim2.new(0, 5, 1, -48)
logFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 14)
logFrame.BorderSizePixel = 0
logFrame.Parent = main
Instance.new("UICorner", logFrame).CornerRadius = UDim.new(0, 4)

local logLbl = Instance.new("TextLabel")
logLbl.Size = UDim2.new(1, -6, 1, -4)
logLbl.Position = UDim2.new(0, 3, 0, 2)
logLbl.BackgroundTransparency = 1
logLbl.TextColor3 = Color3.fromRGB(0, 255, 100)
logLbl.Font = Enum.Font.Code
logLbl.TextSize = 10
logLbl.TextXAlignment = Enum.TextXAlignment.Left
logLbl.TextYAlignment = Enum.TextYAlignment.Top
logLbl.TextWrapped = true
logLbl.Text = ""
logLbl.Parent = logFrame

local function addLog(msg)
    table.insert(logLines, os.date("%H:%M:%S") .. " " .. msg)
    if #logLines > 3 then table.remove(logLines, 1) end
    logLbl.Text = table.concat(logLines, "\n")
end

-- Dragging
local dragging, dragStart, startPos
titleBar.InputBegan:Connect(function(inp)
    if inp.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = inp.Position
        startPos = main.Position
    end
end)
UIS.InputChanged:Connect(function(inp)
    if dragging and inp.UserInputType == Enum.UserInputType.MouseMovement then
        local d = inp.Position - dragStart
        main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + d.X, startPos.Y.Scale, startPos.Y.Offset + d.Y)
    end
end)
UIS.InputEnded:Connect(function(inp)
    if inp.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
end)

-- Minimize
local minimized = false
minBtn.MouseButton1Click:Connect(function()
    minimized = not minimized
    container.Visible = not minimized
    logFrame.Visible = not minimized
    statusLbl.Visible = not minimized
    main.Size = minimized and UDim2.new(0, 310, 0, 32) or UDim2.new(0, 310, 0, 500)
    minBtn.Text = minimized and "+" or "−"
end)

-- Toggle GUI with RightControl
UIS.InputBegan:Connect(function(inp, gpe)
    if gpe then return end
    if inp.KeyCode == Enum.KeyCode.RightControl then
        gui.Enabled = not gui.Enabled
    end
end)

--// ═══════════════════════════════════════════
--//  GUI HELPERS
--// ═══════════════════════════════════════════
local orderCounter = 0

local function nextOrder()
    orderCounter = orderCounter + 1
    return orderCounter
end

local function makeHeader(text)
    local h = Instance.new("TextLabel")
    h.Size = UDim2.new(1, 0, 0, 22)
    h.BackgroundColor3 = Color3.fromRGB(120, 25, 25)
    h.TextColor3 = Color3.new(1, 1, 1)
    h.Font = Enum.Font.GothamBold
    h.TextSize = 11
    h.Text = "  " .. text
    h.TextXAlignment = Enum.TextXAlignment.Left
    h.LayoutOrder = nextOrder()
    h.Parent = container
    Instance.new("UICorner", h).CornerRadius = UDim.new(0, 4)
    return h
end

local function makeAction(name, callback)
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(1, 0, 0, 26)
    b.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
    b.TextColor3 = Color3.fromRGB(220, 220, 220)
    b.Font = Enum.Font.Gotham
    b.TextSize = 11
    b.Text = "  " .. name
    b.TextXAlignment = Enum.TextXAlignment.Left
    b.LayoutOrder = nextOrder()
    b.Parent = container
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 4)
    b.MouseButton1Click:Connect(function()
        local ok, err = pcall(callback)
        if not ok then addLog("ERR: " .. tostring(err)) end
    end)
    return b
end

local function makeDangerAction(name, callback)
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(1, 0, 0, 26)
    b.BackgroundColor3 = Color3.fromRGB(80, 20, 20)
    b.TextColor3 = Color3.fromRGB(255, 150, 150)
    b.Font = Enum.Font.Gotham
    b.TextSize = 11
    b.Text = "  " .. name
    b.TextXAlignment = Enum.TextXAlignment.Left
    b.LayoutOrder = nextOrder()
    b.Parent = container
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 4)
    local armed = false
    b.MouseButton1Click:Connect(function()
        if not armed then
            armed = true
            b.Text = "  CLICK AGAIN — WILL BAN YOU"
            b.BackgroundColor3 = Color3.fromRGB(150, 30, 30)
            task.delay(3, function()
                armed = false
                b.Text = "  " .. name
                b.BackgroundColor3 = Color3.fromRGB(80, 20, 20)
            end)
            return
        end
        armed = false
        b.Text = "  " .. name
        b.BackgroundColor3 = Color3.fromRGB(80, 20, 20)
        local ok, err = pcall(callback)
        if not ok then addLog("ERR: " .. tostring(err)) end
    end)
    return b
end

local function makeToggle(name, cfgKey)
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(1, 0, 0, 26)
    b.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
    b.TextColor3 = Color3.fromRGB(220, 220, 220)
    b.Font = Enum.Font.Gotham
    b.TextSize = 11
    b.LayoutOrder = nextOrder()
    b.Parent = container
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 4)

    local function upd()
        b.Text = "  " .. name .. ": " .. (cfg[cfgKey] and "ON" or "OFF")
        b.BackgroundColor3 = cfg[cfgKey] and Color3.fromRGB(25, 80, 25) or Color3.fromRGB(35, 35, 45)
    end
    upd()

    b.MouseButton1Click:Connect(function()
        cfg[cfgKey] = not cfg[cfgKey]
        upd()
        addLog(name .. " " .. (cfg[cfgKey] and "ON" or "OFF"))
    end)
    return b
end

local function makeTextInput(placeholder)
    local t = Instance.new("TextBox")
    t.Size = UDim2.new(1, 0, 0, 26)
    t.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
    t.TextColor3 = Color3.new(1, 1, 1)
    t.PlaceholderText = placeholder
    t.PlaceholderColor3 = Color3.fromRGB(100, 100, 100)
    t.Font = Enum.Font.Code
    t.TextSize = 11
    t.Text = ""
    t.ClearTextOnFocus = false
    t.LayoutOrder = nextOrder()
    t.Parent = container
    Instance.new("UICorner", t).CornerRadius = UDim.new(0, 4)
    return t
end

--// ═══════════════════════════════════════════
--//  SAFE SECTION: MOVEMENT
--// ═══════════════════════════════════════════
makeHeader("MOVEMENT (safe)")

local walkInput = makeTextInput("WalkSpeed (default 16)")
walkInput.FocusLost:Connect(function()
    local n = tonumber(walkInput.Text)
    if n then
        local char = LP.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        if hum then hum.WalkSpeed = n addLog("WalkSpeed: " .. n) end
    end
end)

local jumpInput = makeTextInput("JumpPower (default 50)")
jumpInput.FocusLost:Connect(function()
    local n = tonumber(jumpInput.Text)
    if n then
        local char = LP.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        if hum then hum.JumpPower = n addLog("JumpPower: " .. n) end
    end
end)

--// ═══════════════════════════════════════════
--//  SAFE SECTION: BALL CONTROL
--// ═══════════════════════════════════════════
makeHeader("BALL")

local function getBall()
    local balls = workspace:FindFirstChild("Balls")
    if balls then
        for _, c in pairs(balls:GetChildren()) do
            if c:IsA("BasePart") then return c end
        end
    end
    for _, c in pairs(workspace:GetChildren()) do
        if c:IsA("Part") and c.Shape == Enum.PartType.Ball then return c end
    end
    local b = workspace:FindFirstChild("Ball")
    if b and (b:IsA("Part") or b:IsA("MeshPart")) then return b end
end

makeToggle("Ball Magnet", "ballMagnet")

makeAction("Teleport Ball to Me", function()
    local ball = getBall()
    local char = LP.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if ball and hrp then
        ball.CFrame = hrp.CFrame + hrp.CFrame.LookVector * 5
        addLog("Ball teleported")
    else
        addLog("Ball or HRP not found")
    end
end)

makeAction("Kick Ball (Velocity)", function()
    local ball = getBall()
    local char = LP.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if ball and hrp then
        ball.Velocity = hrp.CFrame.LookVector * 200 + Vector3.new(0, 50, 0)
        addLog("Ball kicked")
    else
        addLog("Ball or HRP not found")
    end
end)

makeAction("Freeze Ball", function()
    local ball = getBall()
    if ball then ball.Anchored = true addLog("Ball frozen") else addLog("No ball") end
end)

makeAction("Unfreeze Ball", function()
    local ball = getBall()
    if ball then ball.Anchored = false addLog("Ball unfrozen") else addLog("No ball") end
end)

makeAction("[SERVER] PassReq Spoof", function()
    local pr = BallSystem.PassReq
    if not pr then addLog("PassReq not found") return end
    local char = LP.Character
    local head = char and char:FindFirstChild("Head")
    if head then
        pr:FireServer(head.CFrame)
        addLog("PassReq fired with Head CFrame")
    end
end)

--// ═══════════════════════════════════════════
--//  SAFE SECTION: BALL MODE (SwitchPlrVal)
--//  No permission check — all players use this
--// ═══════════════════════════════════════════
makeHeader("BALL MODE (safe)")

makeAction("Mode: High", function()
    if SwitchPlrVal then SwitchPlrVal:FireServer("High", true) addLog("Mode -> High") end
end)
makeAction("Mode: Low", function()
    if SwitchPlrVal then SwitchPlrVal:FireServer("Low", true) addLog("Mode -> Low") end
end)
makeAction("Mode: Dribble", function()
    if SwitchPlrVal then SwitchPlrVal:FireServer("Dribble", true) addLog("Mode -> Dribble") end
end)

local customModeInput = makeTextInput("Custom mode text (raw inject)")
makeAction("[SERVER] Send Custom Mode", function()
    if SwitchPlrVal and customModeInput.Text ~= "" then
        SwitchPlrVal:FireServer(customModeInput.Text, true)
        addLog("Custom mode: " .. customModeInput.Text)
    end
end)

makeAction("[SERVER] BallSwitchSync Request", function()
    if BallSwitchSync then BallSwitchSync:FireServer("request") addLog("BallSwitchSync request") end
end)

makeAction("Mode Spam (10 rapid cycles)", function()
    if not SwitchPlrVal then addLog("SwitchPlrVal not found") return end
    task.spawn(function()
        local modes = {"High", "Low", "Dribble", "INVALID_MODE", ""}
        for i = 1, 10 do
            SwitchPlrVal:FireServer(modes[(i % #modes) + 1], true)
            task.wait(0.1)
        end
        addLog("Mode spam complete (10x)")
    end)
end)

--// ═══════════════════════════════════════════
--//  SAFE SECTION: DATA QUERIES
--//  mainGateway:InvokeServer is READ-ONLY
--//  Should NOT trigger ban (reading, not acting)
--// ═══════════════════════════════════════════
makeHeader("DATA QUERIES (safe)")

makeAction("[SERVER] Get Referee Log", function()
    if mainGateway then
        local ok, data = pcall(function() return mainGateway:InvokeServer("getRefereeLog") end)
        if ok then
            print("[DATA] Referee Log:", data)
            addLog("Ref log fetched (see console)")
        else
            addLog("ERR: " .. tostring(data))
        end
    else
        addLog("mainGateway not found")
    end
end)

makeAction("[SERVER] Get Goal Log", function()
    if mainGateway then
        local ok, data = pcall(function() return mainGateway:InvokeServer("getGoalLog") end)
        if ok then
            print("[DATA] Goal Log:", data)
            addLog("Goal log fetched (see console)")
        else
            addLog("ERR: " .. tostring(data))
        end
    else
        addLog("mainGateway not found")
    end
end)

local pcAttr = makeTextInput("PlayerCard attribute")
makeAction("[SERVER] Get PlayerCard", function()
    if PlayerCard then
        local ok, data = pcall(function() return PlayerCard:InvokeServer(pcAttr.Text) end)
        if ok then
            print("[DATA] PlayerCard:", data)
            addLog("PlayerCard fetched (see console)")
        else
            addLog("ERR: " .. tostring(data))
        end
    end
end)

makeAction("[SERVER] Get Fans Data", function()
    if fanSyncGateway then
        local ok, data = pcall(function() return fanSyncGateway:InvokeServer() end)
        if ok then
            print("[DATA] Fans:", data)
            addLog("Fans data fetched (see console)")
        else
            addLog("ERR: " .. tostring(data))
        end
    end
end)

--// ═══════════════════════════════════════════
--//  SAFE SECTION: MISC
--// ═══════════════════════════════════════════
makeHeader("MISC (safe)")

makeAction("[SERVER] Spray", function()
    if Spray then Spray:FireServer() addLog("Spray fired") end
end)

local rewardId = makeTextInput("Reward ID")
makeAction("[SERVER] Equip Reward", function()
    if EquipReward then
        EquipReward:FireServer(rewardId.Text)
        addLog("EquipReward: " .. rewardId.Text)
    end
end)

makeAction("[SERVER] Collect BFLCoins", function()
    if BFLCoins then BFLCoins:FireServer(true) addLog("BFLCoins toggled") end
end)

makeAction("Teleport to Hub", function()
    if TeleportToHub then TeleportToHub:FireServer() addLog("Teleport to hub fired") end
end)

makeToggle("Anti-AFK", "antiAFK")

makeAction("Toggle Rain (Client)", function()
    local r = RS:FindFirstChild("isRaining")
    if r then r.Value = not r.Value addLog("Rain: " .. tostring(r.Value)) end
end)

makeAction("Toggle Night (Client)", function()
    local n = RS:FindFirstChild("night")
    if n then n.Value = not n.Value addLog("Night: " .. tostring(n.Value)) end
end)

makeAction("Dump All Remote Names", function()
    local count = 0
    for _, d in pairs(RS:GetDescendants()) do
        if d:IsA("RemoteEvent") or d:IsA("RemoteFunction") or d:IsA("UnreliableRemoteEvent") then
            print("[REMOTE]", d:GetFullName(), d.ClassName)
            count = count + 1
        end
    end
    addLog("Dumped " .. count .. " remotes (console)")
end)

--// ═══════════════════════════════════════════
--//  DANGEROUS: REFEREE PANEL (mainEvent)
--//  SERVER VALIDATES GROUP RANK / TEAM
--//  Non-referees get BANNED ~10s after firing
--//  Red buttons = double-click safety
--// ═══════════════════════════════════════════
makeHeader("!! REFEREE (BAN RISK) !!")

local refToggles = {
    "togglePitchDoor", "flipGoals", "toggleGLT", "toggleOffsideTracking",
    "toggleRain", "toggleNight", "toggleTrainingWall", "toggleDisallowBallSpawn"
}

for _, action in ipairs(refToggles) do
    makeDangerAction("[REF] " .. action, function()
        if mainEvent then
            mainEvent:FireServer(action)
            addLog("REF (!!): " .. action)
        else
            addLog("mainEvent not found")
        end
    end)
end

makeHeader("!! REF BALL MGR (BAN RISK) !!")

makeDangerAction("[REF] Spawn Ball (Center)", function()
    if mainEvent then mainEvent:FireServer("ballManagerSpawn", {"center"}) addLog("REF: Ball spawn center") end
end)
makeDangerAction("[REF] Spawn Ball (Left)", function()
    if mainEvent then mainEvent:FireServer("ballManagerSpawn", {"left"}) addLog("REF: Ball spawn left") end
end)
makeDangerAction("[REF] Spawn Ball (Right)", function()
    if mainEvent then mainEvent:FireServer("ballManagerSpawn", {"right"}) addLog("REF: Ball spawn right") end
end)
makeDangerAction("[REF] Thaw Ball", function()
    if mainEvent then mainEvent:FireServer("ballManagerAction", {"thaw"}) addLog("REF: Ball thaw") end
end)
makeDangerAction("[REF] Freeze Ball (Server)", function()
    if mainEvent then mainEvent:FireServer("ballManagerAction", {"freeze"}) addLog("REF: Ball freeze") end
end)
makeDangerAction("[REF] Clear All Balls", function()
    if mainEvent then mainEvent:FireServer("ballManagerAction", {"clear"}) addLog("REF: Balls cleared") end
end)

makeHeader("!! REF GAME CTRL (BAN RISK) !!")

makeDangerAction("[REF] Resume Game", function()
    if mainEvent then mainEvent:FireServer("resumeGame") addLog("REF: Game resumed") end
end)
makeDangerAction("[REF] Pause Game", function()
    if mainEvent then mainEvent:FireServer("pauseGame") addLog("REF: Game paused") end
end)
makeDangerAction("[REF] Half Time", function()
    if mainEvent then mainEvent:FireServer("halfTime") addLog("REF: Half time") end
end)
makeDangerAction("[REF] Full Time", function()
    if mainEvent then mainEvent:FireServer("fullTime") addLog("REF: Full time") end
end)
makeDangerAction("[REF] Extra Time 1", function()
    if mainEvent then mainEvent:FireServer("ExtraTime") addLog("REF: Extra time 1") end
end)
makeDangerAction("[REF] Extra Time 2", function()
    if mainEvent then mainEvent:FireServer("ExtraTime2") addLog("REF: Extra time 2") end
end)
makeDangerAction("[REF] Toggle Official Game", function()
    if mainEvent then mainEvent:FireServer("toggleOfficialGame") addLog("REF: Official toggled") end
end)
makeDangerAction("[REF] End Official Game", function()
    if mainEvent then mainEvent:FireServer("endOfficialGame") addLog("REF: Official ended") end
end)
makeDangerAction("[REF] Toggle Substitutions", function()
    if mainEvent then mainEvent:FireServer("toggleSubstitutions") addLog("REF: Subs toggled") end
end)

makeHeader("!! REF GOALS/CARDS (BAN RISK) !!")

local goalScorer = makeTextInput("Goal scorer name")
local goalTeam = makeTextInput("Team name (Home/Away)")

makeDangerAction("[REF] Award Goal", function()
    if mainEvent then
        mainEvent:FireServer("awardGoal", {LP.UserId, goalScorer.Text, goalTeam.Text})
        addLog("REF: Goal awarded: " .. goalScorer.Text)
    end
end)
makeDangerAction("[REF] Disallow Goal", function()
    if mainEvent then
        mainEvent:FireServer("disallowGoal", {LP.UserId})
        addLog("REF: Goal disallowed")
    end
end)

local cardPlayer = makeTextInput("Card target player name")
local cardType = makeTextInput("Card type (yellow/red)")
local cardReason = makeTextInput("Card reason")

makeDangerAction("[REF] Give Card", function()
    if mainEvent then
        mainEvent:FireServer("giveCard", {cardPlayer.Text, cardType.Text, cardReason.Text})
        addLog("REF: Card " .. cardType.Text .. " -> " .. cardPlayer.Text)
    end
end)

makeHeader("!! REF TIME/FIXTURE (BAN RISK) !!")

local timeMin = makeTextInput("Minutes")
local timeSec = makeTextInput("Seconds")

makeDangerAction("[REF] Set Custom Time", function()
    if mainEvent then
        mainEvent:FireServer("setCustomTime", {tonumber(timeMin.Text) or 0, tonumber(timeSec.Text) or 0})
        addLog("REF: Time set " .. timeMin.Text .. ":" .. timeSec.Text)
    end
end)

local fixtureName = makeTextInput("Team name")
local fixturePrimary = makeTextInput("Primary color (R,G,B)")
local fixtureSecondary = makeTextInput("Secondary color (R,G,B)")

local function parseColor(str)
    local r, g, b = str:match("(%d+)%s*,%s*(%d+)%s*,%s*(%d+)")
    if r then return Color3.fromRGB(tonumber(r), tonumber(g), tonumber(b)) end
    return Color3.fromRGB(255, 255, 255)
end

makeDangerAction("[REF] Set Home Fixture", function()
    if mainEvent then
        mainEvent:FireServer("setHomeFixture", {fixtureName.Text, parseColor(fixturePrimary.Text), parseColor(fixtureSecondary.Text)})
        addLog("REF: Home fixture: " .. fixtureName.Text)
    end
end)
makeDangerAction("[REF] Set Away Fixture", function()
    if mainEvent then
        mainEvent:FireServer("setAwayFixture", {fixtureName.Text, parseColor(fixturePrimary.Text), parseColor(fixtureSecondary.Text)})
        addLog("REF: Away fixture: " .. fixtureName.Text)
    end
end)

local compInput = makeTextInput("Competition name")

makeDangerAction("[REF] Set Competition", function()
    if mainEvent then
        mainEvent:FireServer("setCompetition", {compInput.Text})
        addLog("REF: Competition: " .. compInput.Text)
    end
end)

--// ═══════════════════════════════════════════
--//  DANGEROUS: MANAGER CONTROLS
--//  Server checks Team == "Team Ownership" OR
--//  managerAbbrev attribute — may also ban
--// ═══════════════════════════════════════════
makeHeader("!! MANAGER (BAN RISK) !!")

local msgInput = makeTextInput("Manager message text")

makeDangerAction("[MGR] Send Manager Message", function()
    if managerAction then
        managerAction:FireServer("message", msgInput.Text)
        addLog("MGR: msg " .. msgInput.Text)
    else
        addLog("managerAction not found")
    end
end)

local subOut = makeTextInput("Sub OUT player name")
local subIn = makeTextInput("Sub IN player name")

makeDangerAction("[MGR] Submit Substitution", function()
    if managerAction then
        managerAction:FireServer("sub", {out = subOut.Text, inn = subIn.Text})
        addLog("MGR: Sub " .. subOut.Text .. " -> " .. subIn.Text)
    end
end)

local swapA = makeTextInput("Swap pos player A")
local swapB = makeTextInput("Swap pos player B")

makeDangerAction("[MGR] Swap Positions", function()
    if managerAction then
        managerAction:FireServer("swapPos", {a = swapA.Text, b = swapB.Text})
        addLog("MGR: Swap " .. swapA.Text .. " <-> " .. swapB.Text)
    end
end)

--// ═══════════════════════════════════════════
--//  SUBSTITUTION SYSTEM (unknown risk)
--// ═══════════════════════════════════════════
makeHeader("SUBSTITUTION (unknown risk)")

local subUpdateIn = makeTextInput("Sub IN player")
local subUpdateOut = makeTextInput("Sub OUT player")

makeDangerAction("[SERVER] SubstitutionUpdate IN", function()
    if SubstitutionUpdate then
        SubstitutionUpdate:FireServer("IN", subUpdateIn.Text)
        addLog("SubUpdate IN: " .. subUpdateIn.Text)
    end
end)
makeDangerAction("[SERVER] SubstitutionUpdate OUT", function()
    if SubstitutionUpdate then
        SubstitutionUpdate:FireServer("OUT", subUpdateOut.Text)
        addLog("SubUpdate OUT: " .. subUpdateOut.Text)
    end
end)

--// ═══════════════════════════════════════════
--//  RUNTIME LOOPS
--// ═══════════════════════════════════════════

-- Ball magnet loop
RunService.Heartbeat:Connect(function()
    if not cfg.ballMagnet then return end
    local char = LP.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    local ball = getBall()
    if ball then
        local torso = char:FindFirstChild("Torso") or char:FindFirstChild("UpperTorso")
        if torso and ball.Parent then
            pcall(function()
                if firetouchinterest then
                    firetouchinterest(torso, ball, true)
                    task.defer(function() firetouchinterest(torso, ball, false) end)
                end
            end)
            ball.CFrame = hrp.CFrame + hrp.CFrame.LookVector * 4
        end
    end
end)

-- Anti-AFK
if afkEvent then
    task.spawn(function()
        while task.wait(60) do
            if cfg.antiAFK then
                pcall(function() afkEvent:FireServer(false) end)
            end
        end
    end)
end

-- Auto-resize canvas
task.spawn(function()
    while task.wait(1) do
        local contentSize = layout.AbsoluteContentSize
        container.CanvasSize = UDim2.new(0, 0, 0, contentSize.Y + 20)
    end
end)

addLog("Match Exploit loaded!")
print("============================================")
print("[MATCH] Match Exploit loaded")
print("[MATCH] RightCtrl to toggle GUI")
print("[MATCH] SAFE: ball mode, ball magnet, data, spray, coins")
print("[MATCH] DANGER: ALL mainEvent referee cmds = BAN")
print("[MATCH] DANGER: managerAction cmds = likely BAN")
print("[MATCH] Red buttons require double-click")
print("  mainEvent: " .. tostring(mainEvent ~= nil))
print("  mainGateway: " .. tostring(mainGateway ~= nil))
print("  managerAction: " .. tostring(managerAction ~= nil))
print("  BallSystem: " .. tostring(next(BallSystem) ~= nil))
print("  SwitchPlrVal: " .. tostring(SwitchPlrVal ~= nil))
print("============================================")
