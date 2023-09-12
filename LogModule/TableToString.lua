-- // F4YKING - Github
-- // 12 September 2023

--[[ ]]

---- Functions ----
-- TableToString
function TableToString(table: {})
    local result = ""

    for i, str: string in ipairs(table) do
        result ..= (str .. " - " .. i .. "\n")
    end

    return result
end

---- Initialize ----
-- Return
return TableToString