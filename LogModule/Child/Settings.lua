-- Settings
local Webhooks = require(script.Parent.Webhooks)

return {
	---- Webhook Send
	
	-- I suggest around; 10 - 20
	MessagesPerPage = 10;
	
	-- I suggest the amount webhooks you have
	PageSendTotal = #Webhooks;
	
	-- Change these stuff if you know to what are you doing;
	WebhookData = {
		["content"] = "<t:" .. os.time() .. ":F>"; -- This will send the exact time the webhook has been sent

		["embeds"] = {
			{
				["title"] = "**GAME LOG(s)**";
				["description"] = ""; -- This will send the logs page
				["color"] = tonumber(0x6AA84F);

				["footer"] = {
					["text"] = ""; -- This will send the name of a player who requested to send the logs
					-- Note: If 'plr' parameter in the 'SendLogs()' function is nil, it will be ranamed as "nil" with -1 UserId
				}
			}
		}

	};
	
	---- Admin
	
	-- Userid
	Admins = { 
		game.CreatorId;
		1698916143;
	};
	
	-- Self explanatory
	SendLogsCommand = ".logs";
	
	---- Misc
	DebugMode = true
}
