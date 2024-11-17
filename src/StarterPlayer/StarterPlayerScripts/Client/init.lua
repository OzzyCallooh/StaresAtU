--!strict
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local Services = require(ReplicatedStorage.Utilities.Services)

local Client: Services.Services = Services
Client.serviceModules = {
	ReplicatedStorage.ClientServices.CmdrClientStartupService,
	ReplicatedStorage.ClientServices.IconDisplayService,
}

return Client
