--!strict

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local benchmark = require(ReplicatedStorage.Utilities.Functions).benchmark

local Server = require(script.Parent)

local function main()
	local elapsed: number
	elapsed = benchmark(Server.load, Server)
	print(("Server loaded in %.3fs"):format(elapsed))
	elapsed = benchmark(Server.init, Server)
	print(("Server started in %.3fs"):format(elapsed))
end

main()
