-- // F4YKING - Github
-- // 12 September 2023

--[[ ]]

---- Functions ----
-- TableToString
function TableToString(table: {})
    local result = ""

    for _, str: string in ipairs(table) do
        result ..= str .. "\n"
    end

    return result
end

---- Initialize ----
-- Return
return TableToString