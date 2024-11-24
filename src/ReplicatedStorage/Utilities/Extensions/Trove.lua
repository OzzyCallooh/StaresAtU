local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Trove = require(ReplicatedStorage.Packages.Trove)

local TroveExtension = {}

function TroveExtension:Constructing()
	self.Trove = Trove.new()
end

function TroveExtension:Stopped()
	self.Trove:Destroy()
end

return TroveExtension
