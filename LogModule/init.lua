-- // F4YKING - Github
-- // 10 September 2023

--[[]]

---- Variables ----
-- Services
local HttpService = game:GetService("HttpService")

-- GameId
local gameId = game.GameId

-- Settings
export type LogSettings = {
    SendLogsCmd: string,
    DebugMode: boolean,
    MessagesPerPage: number,
    PageSend: number,
}

local Settings: LogSettings = {

    SendLogsCmd = ".logs",
    DebugMode = false,

    MessagesPerPage = 10, -- How many messages in one page.
    PageSend = 5, -- How many pages will be sent.

}

local Admins = {}
local Webhooks = {}

local WebhookData = {
    ["content"] = "<t:" .. os.time() .. ":F>", -- This will send the exact time the webhook has been sent.

    ["embeds"] = {
        {
            ["title"] = "Game Logs - " .. gameId,
            ["url"] = "https://www.roblox.com/games/" .. gameId,
            ["description"] = "", -- Will send the logs pages here.
            ["color"] = 6989903,

            ["footer"] = {
                ["text"] = "" -- Will sent player name who requested logs.
            }
        }
    }
}

-- data
local currentPage = 1
local isSending = false

local data = { {} }

-- queue
local msgQueue = {}

---- Functions ----
-- CopyDict
local CopyDict: (t: {}) -> {} = require(script.CopyDict)

-- TableToString
local TableToString: (t: {}) -> string = require(script.TableToString)

-- Post - PostPage
function Post(str: string, webhook: string, plr: Player?)

    plr = typeof(plr) == "Instance" and plr:IsA("Player") and plr or {Name = "System", UserId = -1}

    local wbData = CopyDict(WebhookData)
    wbData.content = "<t:" .. os.time() .. ":F>"

    wbData.embeds[1].description = "```\n" .. str .. "\n```"
    wbData.embeds[1].footer.text = "Sent by: " .. plr.Name .. " | UserId: " .. tostring(plr.UserId)

    wbData = HttpService:JSONEncode(wbData)

    return pcall(function()
        HttpService:PostAsync(webhook, wbData)
    end)
end

function PostPage(pageTable, currentWebhook: number,  plr: Player?)
    -- Page - Webhook
    local page: string = TableToString(pageTable)
    local choosenWebhook = #Webhooks==1 and Webhooks[1] or Webhooks[currentWebhook % #Webhooks]

    return Post(page, choosenWebhook, plr)
end

--- Initializes ----
---- LogModule
local LogModule = {}

-- Set - Add
function LogModule.AddWebhooks(webhooks: {string}) -- Webhook String(s)
    for _, webhook: string in ipairs(webhooks) do
        table.insert(Webhooks, webhook)
    end
end

function LogModule.AddAdmins(admins: {number}) -- UserId(s)
    for _, admin: number in ipairs(admins) do
        table.insert(Admins, admin)
    end
end

function LogModule.SetSettings(set: LogSettings)
    for i, v in pairs(set) do
        Settings[i] = v
    end
end

-- function LogModule.SetWebhookData(wb: {})
--     WebhookData = wb
-- end

-- Admin
function LogModule.CheckPlayer(plr: Player?)

    if table.find(Admins, plr.UserId) == nil then return end

    plr.Chatted:Connect(function(msg: string)
        if string.lower(msg) ~= Settings.SendLogsCmd then return end
        LogModule.SendLogs(plr)
    end)

end

-- Log
function LogModule.AddLog(msg: string?, noTime: boolean?)

    if Settings.DebugMode then print(msg) end

    msg = tostring(msg)
    if type(msg) ~= "string" then warn(".AddLog first parameter is not a string.") return end

    if #data[currentPage] >= Settings.MessagesPerPage then
        currentPage+=1; data[currentPage] = {}
    end

    msg = noTime and msg or os.date(" | [%X] - " .. msg)

    local tab = isSending and msgQueue or data[currentPage]
    table.insert(tab, msg)

end

function LogModule.SendLogs(plr: Player?)

    -- Checks
    if #Webhooks == 0 then warn("No webhooks available but trying to send logs."); return end
    if isSending then warn("Currently sending."); return end

    isSending = true

    -- PostStr
    local succ = LogModule.PostStr("Sending Logs!", plr)
    if not succ then return end

    -- Start
    local currentWebhook = 0
    local err = nil

    for i = #data-(Settings.PageSend-1), #data do
        if i <= 0 then continue end

        local succ, er = PostPage(data[i], currentWebhook, plr)
        if not succ then err = er; break end

        currentWebhook += 1
        task.wait(1)
    end

    -- Errors
    if err then warn("WARNING: CANNOT SEND LOG(s), ERROR MESSAGE:\n" .. err); return end

    -- Succeed - Restart
    print("Success!, Log(s) has been sent!")

    -- Restart
    currentPage = 1
	data = { {} }

    -- Cooldown
    task.wait(5); isSending = false

    -- msgQueue
    if #msgQueue > 0 then
        print(msgQueue)

        for _, msg in ipairs(msgQueue) do
            LogModule.AddLog(msg, true)
        end

        msgQueue = {}

    end

end

function LogModule.PostStr(str: string, plr: Player?)
    local succ, err = Post(str, Webhooks[1], plr)
    if not succ then warn(err) end; return succ, err
end

return LogModule