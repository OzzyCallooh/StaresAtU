local ReplicatedStorage = game:GetService("ReplicatedStorage")
local benchmark = require(ReplicatedStorage.Utilities.Functions).benchmark

local remotes = ReplicatedStorage.Remotes
local getPlayerData = remotes.getPlayerData
local playerDataLoaded = remotes.playerDataLoaded

local Client = require(script.Parent)

local function waitForPlayerData()
	-- Wait for player data to load
	local hasLoaded = false
	playerDataLoaded.OnClientEvent:Once(function()
		hasLoaded = true
	end)
	local playerData = getPlayerData:InvokeServer()
	if playerData then
		hasLoaded = true
	end

	while not hasLoaded do
		task.wait()
	end
end

local function main()
	waitForPlayerData()
	
	-- Do loading spiel
	local elapsed: number
	elapsed = benchmark(Client.load, Client)
	print(("Client loaded in %.3fs"):format(elapsed))
	elapsed = benchmark(Client.init, Client)
	print(("Client started in %.3fs"):format(elapsed))
end

main()


