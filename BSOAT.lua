local Rayfield = loadstring(game:HttpGet('https://raw.githubusercontent.com/SiriusSoftwareLtd/Rayfield/refs/heads/main/source.lua'))()
local NotificationLibrary = loadstring(game:HttpGet("https://raw.githubusercontent.com/Kenaii11/Util/refs/heads/main/NotificationLibrary.lua"))()
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local hrp = character:WaitForChild("HumanoidRootPart")
local BallsFolder = workspace:FindFirstChild("Balls")
getgenv().BallFling = false

if BallsFolder then
    print("IT EXISTS!!")
else
    warn("it doesnt exist..")
end

local function kickBall(ball)
    local TouchTransmitter = ball:FindFirstChildWhichIsA("TouchTransmitter")
    if TouchTransmitter then
        firetouchinterest(game.Players.LocalPlayer.Character.HumanoidRootPart, ball, 0)
        task.wait()
        firetouchinterest(game.Players.LocalPlayer.Character.HumanoidRootPart, ball, 1)
    else
        warn("no touch thingy on the ball :sob:")
    end
end

local function kickBalls()
    if BallsFolder then
        for _, v in ipairs(BallsFolder:GetChildren()) do
            if v:IsA("BasePart") then
                kickBall(v)
            end
        end
    else
        warn("bro there isnt even a balls folder :sob: cant even kick balls")
    end
end

local Window = Rayfield:CreateWindow({
    Name = "best in the world!!1111",
    Icon = 0,
    LoadingTitle = "bfl skill helper",
    LoadingSubtitle = "by rinfy and adamtaxi",
    Theme = "Default",
    DisableRayfieldPrompts = false,
    DisableBuildWarnings = false,
    ConfigurationSaving = {
        Enabled = false,
        FolderName = nil,
        FileName = "Big Hub"
    },
    Discord = {
        Enabled = false,
        Invite = "noinvitelink",
        RememberJoins = true
    },
    KeySystem = false,
    KeySettings = {
        Title = "Untitled",
        Subtitle = "Key System",
        Note = "No method of obtaining the key is provided",
        FileName = "Key",
        SaveKey = true,
        GrabKeyFromSite = false,
        Key = {"Hello"}
    }
})

local GeneralTab = Window:CreateTab("BFL", 4483362458)
local Section1 = GeneralTab:CreateSection("rinfy and adam are the best")

local sigmakeybind1 = GeneralTab:CreateKeybind({
    Name = "Kick Ball Keybind",
    CurrentKeybind = "Q",
    HoldToInteract = false,
    Flag = "Keybind1",
    Callback = function(Keybind)
        kickBalls()
    end,
})

local sigmakeybind2 = GeneralTab:CreateKeybind({
    Name = "Fix ball invis",
    CurrentKeybind = "F",
    HoldToInteract = false,
    Flag = "Keybind1",
    Callback = function(Keybind)
        for _, ABall in ipairs(BallsFolder:GetChildren()) do
            if ABall:IsA("BasePart") then
                ABall.Transparency = 0
            end
        end
    end,
})

local Toggle = GeneralTab:CreateToggle({
    Name = "Loop kick",
    CurrentValue = false,
    Flag = "Toggle1",
    Callback = function(Value)
        while Value do
            kickBall()
            task.wait(0.2)
        end
    end,
})

Rayfield:Notify({
    Title = "loop kick toggle",
    Content = "fyi cba to do this toggle thing its blatant anyway",
    Duration = 6.5,
    Image = 4483362458,
})

local adamkeybind = GeneralTab:CreateKeybind({
    Name = "Delete ball",
    CurrentKeybind = "F",
    HoldToInteract = false,
    Flag = "Keybind7",
    Callback = function(Keybind)
        local ball
        repeat
            for _, obj in ipairs(workspace:GetDescendants()) do
                if obj:IsA("BasePart") and obj.Name == "Ball1" then
                    ball = obj
                    break
                end
            end
            task.wait(0.1)
        until ball

        -- Apply extreme physical properties
        ball.CanCollide = false
        ball.Size = Vector3.new(1000, 1000, 1000)
        ball.CustomPhysicalProperties = PhysicalProperties.new(100, 1, 1, 100, 100)

        -- Save original position
        local originalCFrame = hrp.CFrame

        -- Set up touch detection
        local touched = false
        local conn
        conn = ball.Touched:Connect(function(hit)
            if hit:IsDescendantOf(character) then
                touched = true
                conn:Disconnect()
            end
        end)

        -- Teleport player to ball position until touched
        while not touched do
            hrp.CFrame = ball.CFrame + Vector3.new(0, 5, 0)
            RunService.RenderStepped:Wait()
        end

        -- Teleport back
        hrp.CFrame = originalCFrame
    end,
})

-- this toggle one wont work i couldnt be asked to finish
