-- Made by fayking#8312

---- Variables ----
-- Services
local plrs = game:GetService("Players")

-- Modules
local LogModule = require(script.Parent.LogModule)

-- Local Variables
local landmine = script.Landmine.Value

---- Functions ----

---- Events ----
plrs.PlayerAdded:Connect(function(plr)
	-- Adds a log when player joins
	LogModule.AddLog(plr.Name .. " has joined the game")
	
	plr.Chatted:Connect(function(msg)
		-- Adds a log when player chatted
		LogModule.AddLog("["..  plr.Name .."]: " .. msg)
		
	end)
	
	-- Checks if player an admin or not, if player an admin then the player can send logs
	LogModule.CheckAdmin(plr)
	
end)

plrs.PlayerRemoving:Connect(function(plr)
	-- adds a log when player left
	LogModule.AddLog(plr.Name .. " has left the game")
end)

landmine.Touched:Connect(function(hit)
	local char = hit.Parent
	
	if char and char:FindFirstChild("Humanoid") then
		-- adds a log when Landmine triggered
		LogModule.AddLog(char.Name .. " Triggered the landmine")

		local ex = Instance.new("Explosion")
		ex.Position = landmine.Position

		ex.Parent = workspace
		landmine:Destroy()
	end
end)

---- Run ----

