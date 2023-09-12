-- // F4YKING - Github
-- // 10 September 2023

---- Variables ----
-- Services
local Players = game:GetService("Players")
local ServerStorage = game:GetService("ServerStorage")

-- Modules
local LogModule = require(ServerStorage.LogModule)

---- Initializes ----
---- LogModule
local SettMod = script:FindFirstChild("TestSettings") or script.Settings

local Settings =  require(SettMod)

-- Setup
LogModule.AddWebhooks(Settings.Webhooks)

LogModule.AddAdmins(Settings.Admins)

-- PlayerAdded
Players.PlayerAdded:Connect(function(plr: Player)

    LogModule.AddLog(plr.Name .. " Has joined the game.")
    LogModule.CheckPlayer(plr)

    plr.Chatted:Connect(function(msg: string)
        LogModule.AddLog("[" .. plr.Name .. "]: " .. msg)
    end)
    
end)

-- AddLog
LogModule.AddLog("Hello world")
LogModule.AddLog("From vscode")

-- local n = 1
-- while 1 do
--     task.wait(1); print(n); LogModule.AddLog(n); n += 1
-- end
