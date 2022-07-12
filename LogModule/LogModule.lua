--[[
	Made by fayking#8312

	Thank You for using my module
]]

---- Variables ----
-- Service
local httpSer = game:GetService("HttpService")

-- Modules
local TableToString = require(script.TableToString)
local Settings = require(script.Settings)
local Webhooks = require(script.Webhooks)

-- Local Vars
local currentPage = 1
local isSending = false

---- Module ----
local LogModule = {}
LogModule.Data = { {} }

---- functions ----
-- Local Functions
local function CheckMessage(msg) -- Checks if message is the same as 'sendLogsCommand'
	return string.match(string.lower(msg), Settings.SendLogsCommand) ~= nil
end

local function CheckUser(plr) -- Checks if user an admin
	return table.find(Settings.Admins, plr.UserId) ~= nil
end

-- Module Functions
function LogModule.AddLog(msg: string?)
	if Settings.DebugMode then
		print(msg)
	end
	
	msg = tostring(msg) or nil
	
	if msg == nil then warn("Paramater1 nil.") return end
	
	if #LogModule.Data[currentPage] >= Settings.MessagesPerPage then
		currentPage += 1

		LogModule.Data[currentPage] = {}
	end

	table.insert(LogModule.Data[currentPage], msg)
end

function LogModule.PrintLogs()
	print(LogModule.Data)
end

function LogModule.SendLogs(plr: Player)
	if Settings.DebugMode then
		LogModule.PrintLogs()
	end
	
	if #Webhooks == 0 then
		warn("No webhooks has been inserted, please check.")
		return
	end
	
	if isSending then warn("CURRENTLY SENDING LOG(s)."); return end
	local plr = plr or {Name = "nil", UserId = -1}
	
	isSending = true
	
	-- Sending Logs
	local CurrentWebhook = 0
	local success = true
	
	for i = #LogModule.Data-(Settings.PageSendTotal-1), #LogModule.Data do
		if i <= 0 then
			continue
		end
		
		local page = TableToString(LogModule.Data[i])
		
		local data = Settings.WebhookData
		data.embeds[1].description = "```\n" .. page .. "\n```"
		data.embeds[1].footer.text = "These log(s) has been sent by: " .. plr.Name .. " | UserId: " .. tostring(plr.UserId)
		
		data = httpSer:JSONEncode(data)
		
		local choosenWebhook = Webhooks[(CurrentWebhook % #Webhooks)+1] -- Epic calculate yes
		local succ, err = pcall(function()
			httpSer:PostAsync(choosenWebhook, data)
		end)
		
		if Settings.DebugMode then
			print(succ, err)
		end
		
		if succ == false then
			success = false
			warn("WARNING: CANNOT SEND LOG(s), ERROR MESSAGE:\n" .. err)
			break
		end

		CurrentWebhook += 1
		task.wait(5)
	end
	
	if success then
		print("Success!, Log(s) has been sent!")
		
		LogModule.Data = { {} } -- Resetting
		currentPage = 1
	end
	
	-- Cooldown
	task.wait(10)
	
	isSending = false
end

function LogModule.CheckAdmin(plr: Player)	
	-- Check if user an admin or not
	if CheckUser(plr) == false then return end
	
	if Settings.DebugMode then
		print(plr.Name .. " is an admin.")
	end
	
	plr.Chatted:Connect(function(msg)
		-- Delay
		task.wait()
		
		-- If message has the SendLogsCommand then it will send logs
		if CheckMessage(msg) == true then 
			LogModule.SendLogs(plr)
		end
	end)
end

return LogModule
