local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Comm = require(ReplicatedStorage.Packages.Comm)

local CommExtension = {}

type ClientRemotePropertyDefinition = {
	Observe: ((any) -> any)?,
}

local SYMBOL_CLIENT_REMOTE_PROPERTY_DEFINITIONS = {}

function CommExtension:Constructing()
	assert(self.Trove, "TroveExtension must be added before CommExtension")
	local namespace = self.Tag
	local commFolderName = "_comm_" .. namespace
	self._commFolder = self.Instance:WaitForChild(commFolderName)
	self.ClientComm = Comm.ClientComm.new(self._commFolder, true, namespace)
	self.Trove:Add(self.ClientComm)
	self.Server = self.ClientComm:BuildObject()

	local clientRemotePropertyDefinitions = self.Properties

	if clientRemotePropertyDefinitions then
		self[SYMBOL_CLIENT_REMOTE_PROPERTY_DEFINITIONS] = clientRemotePropertyDefinitions
		local clientRemoteProperties = {}
		for propertyName: string, _clientPropertyDefinition: ClientRemotePropertyDefinition in
			clientRemotePropertyDefinitions
		do
			local clientRemoteProperty =
				assert(self.ClientComm:GetProperty(propertyName), "No property " .. propertyName)
			clientRemoteProperties[propertyName] = clientRemoteProperty
		end
		-- In the component instance, this overrides the Properties definitions
		-- with the actual ClientRemoteProperty instances
		self.Properties = clientRemoteProperties
	end
end

function CommExtension:Started()
	local clientRemotePropertyDefinitions = self[SYMBOL_CLIENT_REMOTE_PROPERTY_DEFINITIONS]
	if clientRemotePropertyDefinitions then
		for propertyName: string, clientPropertyDefinition: ClientRemotePropertyDefinition in
			clientRemotePropertyDefinitions
		do
			local clientRemoteProperty = self.Properties[propertyName]
			if clientPropertyDefinition.Observe then
				clientRemoteProperty:Observe(function(value: any)
					clientPropertyDefinition.Observe(self, value)
				end)
			end
		end
	end
end

return CommExtension
