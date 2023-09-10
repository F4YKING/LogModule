-- // avarjbeqf
-- // 10 September 2023

--[[ // Notes
    [10 September 2023]
    - https://create.roblox.com/docs/luau/tables#cloning-tables
]]

---- Functions ----
-- DeepCopy
local function DeepCopy(original)
	local copy = {}

	for k, v in pairs(original) do
		if type(v) == "table" then v = DeepCopy(v) end

		copy[k] = v
	end; return copy
end

return DeepCopy