--!strict
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local data = ReplicatedStorage.Data
local Icons = require(data.Icons)

local remotes = ReplicatedStorage.Remotes
local showIconRemote = remotes.showIcon

return function (context, chips)
	for _, chip in chips do
		showIconRemote:FireAllClients(Icons[chip])
		task.wait(0.15)
	end
end
