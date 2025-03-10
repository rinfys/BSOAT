local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
local NotificationLibrary = loadstring(game:HttpGet("https://raw.githubusercontent.com/Kenaii11/Util/refs/heads/main/NotificationLibrary.lua"))()
local PTS = Window:CreateTab("PTS", 4483362458)
local rightleg = game:GetService("Players").LocalPlayer.Character:FindFirstChild("Right Leg")
local react = game:GetService("ReplicatedStorage"):WaitForChild("RemoteEvents"):WaitForChild("React")
local HI = false
getgenv().BallFling = false
local BFC = Window:CreateTab("BFC", 4483362458)
local BFL = Window:CreateTab("BFL", 4483362458) 
local BFL1 = BFL:CreateSection("rinfy!!!")
local BFC2 = BFC:CreateSection("rinfy!!!")
local PTS3 = PTS:CreateSection("rinfy!!!")
local BallsFolder = workspace:FindFirstChild("Balls")
if BallsFolder then print("IT EXISTS!!") else warn("it doesnt exist..") end
local BallFlingThread


local Window = Rayfield:CreateWindow({
   Name = "best script of all time",
   Icon = 0, 
   LoadingTitle = "kenaii's help tool",
   LoadingSubtitle = "by Kenaii and rinfy",
   Theme = "Default", 

   DisableRayfieldPrompts = false,
   DisableBuildWarnings = false, 

   ConfigurationSaving = {
      Enabled = false,
      FolderName = nil, 
      FileName = "test"
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
        for i,v in BallsFolder:GetChildren() do  
            if v:IsA("BasePart") then 
                kickBall(v)
            end
        end
    else
        warn("bro there isnt even a balls folder :sob: cant even kick balls")
    end
end

local sigmakeybind1 = BFL:CreateKeybind({
   Name = "Kick Ball Keybind",
   CurrentKeybind = "Q",
   HoldToInteract = false,
   Flag = "Keybind1", 
   Callback = function(Keybind)
       kickBalls()
   end,
})


function StartBallFling()
    if BallFlingThread then return end
    BallFlingThread = task.spawn(function()
        while getgenv().BallFling do
            for _, v in pairs(workspace:GetDescendants()) do
                if v:IsA("TouchTransmitter") and v.Parent == workspace:FindFirstChild("Ball") then
                    firetouchinterest(game.Players.LocalPlayer.Character.HumanoidRootPart, v.Parent, 0)
                    task.wait()
                    firetouchinterest(game.Players.LocalPlayer.Character.HumanoidRootPart, v.Parent, 1)
                end
            end
        end
        BallFlingThread = nil
    end)
end

local sigmatoggle = BFC:CreateToggle({
   Name = "Ball Fling",
   Info = "Flings the ball while the toggle is set to true", 
   CurrentValue = false,
   Flag = "Toggle1", 
   Callback = function(Value)
       getgenv().BallFling = Value
       if Value then
           StartBallFling()
       end
   end,
})

local sigmakeybind = BFC:CreateKeybind({
   Name = "Kick Ball Once",
   CurrentKeybind = "R",
   HoldToInteract = false,
   Flag = "Keybind2", 
   Callback = function()
       for _, v in pairs(workspace:GetDescendants()) do
           if v:IsA("TouchTransmitter") and v.Parent == workspace:FindFirstChild("ScrimBall1") then
               firetouchinterest(game.Players.LocalPlayer.Character.HumanoidRootPart, v.Parent, 0)
               task.wait()
               firetouchinterest(game.Players.LocalPlayer.Character.HumanoidRootPart, v.Parent, 1)
           end
       end
   end,
})

 local sigmatoggle141 = PTS:CreateToggle({
    Name = "Kicks the ball infinitely",
    Info = "Kicks the ball infinitely when enabled",  
    CurrentValue = false,
    Flag = "Toggle1", 
    Callback = function(Value)
       HI = Value
       if Value then
          while HI do
             task.wait(0.1)
             local balls = workspace:WaitForChild("Balls"):GetChildren()
             for _, ball in pairs(balls) do
                 if ball:IsA("BasePart") then
                     react:FireServer(ball, rightleg)
                 end
             end
          end
       end
    end,
 })
 
 local sigmakeybin122 = PTS:CreateKeybind({
    Name = "Kick Ball",
    CurrentKeybind = "Q",
    HoldToInteract = false,
    Flag = "Keybind2", 
    Callback = function()
       task.wait(0.1)
       local balls = workspace:WaitForChild("Balls"):GetChildren()
       for _, ball in pairs(balls) do
           if ball:IsA("BasePart") then
               react:FireServer(ball, rightleg)
           end
       end
    end
 })