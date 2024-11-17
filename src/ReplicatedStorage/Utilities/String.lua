--!strict

local String = {}

--[[
	Returns whether haystack begins with needle.
]]
function String.beginsWith(haystack: string, needle: string): boolean
	return haystack:sub(1, needle:len()) == needle
end

return String
