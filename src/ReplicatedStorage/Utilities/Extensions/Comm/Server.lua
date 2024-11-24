local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Comm = require(ReplicatedStorage.Packages.Comm)

local CommExtension = {}

type ServerRemotePropertyDefinition = {
	InitialValue: any?,
}

function CommExtension:Constructing()
	assert(self.Trove, "TroveExtension must be added before CommExtension")
	local namespace = self.Tag
	local commFolderName = "_comm_" .. namespace
	self._commFolder = Instance.new("Folder")
	self._commFolder.Name = commFolderName
	self._commFolder.Archivable = false
	self._commFolder.Parent = self.Instance
	self.ServerComm = Comm.ServerComm.new(self._commFolder, namespace)
	self.Trove:Add(self.ServerComm)
	if self.Client then
		for functionName: string, callback: (Player, ...any) -> () in self.Client do
			self.ServerComm:BindFunction(functionName, function(player: Player, ...: any)
				return callback(self, player, ...)
			end)
		end
	end
	local propertyDefinitions = self.Properties
	if propertyDefinitions then
		local remoteProperties = {}
		for propertyName: string, serverPropertyDefinition: ServerRemotePropertyDefinition in propertyDefinitions do
			local remoteProperty = self.ServerComm:CreateProperty(propertyName, serverPropertyDefinition.InitialValue)
			remoteProperties[propertyName] = remoteProperty
		end
		-- In the component instance, this overrides the Properties definitions
		-- with the actual RemoteProperty instances
		self.Properties = remoteProperties
	end
end

return CommExtension
