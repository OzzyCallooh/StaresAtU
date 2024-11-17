--!strict
local ServerScriptService = game:GetService("ServerScriptService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local Services = require(ReplicatedStorage.Utilities.Services)

local Server: Services.Services = Services
Server.serviceModules = {
	ServerScriptService.Services.PlayerDataService,
	ServerScriptService.Services.CmdrStartupService,
	ServerScriptService.Services.HomesteadService,
}

return Server
