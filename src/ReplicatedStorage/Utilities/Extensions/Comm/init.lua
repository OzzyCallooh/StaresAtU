local RunService = game:GetService("RunService")

local CommExtensionServer = require(script.Server)
local CommExtensionClient = require(script.Client)

if RunService:IsServer() then
	return CommExtensionServer
elseif RunService:IsClient() then
	return CommExtensionClient
else
	error("Unknown RunService")
end
