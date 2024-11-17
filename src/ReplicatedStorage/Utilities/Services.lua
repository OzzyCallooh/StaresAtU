--!strict
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local Functions = require(ReplicatedStorage.Utilities.Functions)

export type Service = {
	init: (Service) -> (),
	onPlayerAdded: (Service, Player) -> ()?,
	onPlayerRemoving: (Service, Player) -> ()?,
}

export type Services = {
	-- Properties
	serviceModules: { ModuleScript },
	services: { Service },
	_loaded: boolean,

	-- Methods
	load: (self: Services) -> (),
	init: (self: Services) -> (),
	callEachService: <T...>(self: Services, fnName: string, T...) -> (),
	_onPlayerAdded: (self: Services, Player) -> (),
	_onPlayerRemoving: (self: Services, Player) -> (),
}

local Services = {}
Services.serviceModules = {} :: { ModuleScript }
Services.services = {} :: { Service }
Services._loaded = false

--[[
	Requires each of the service modules.
]]
function Services.load(self: Services)
	for _, serviceModule: ModuleScript in self.serviceModules do
		local service = require(serviceModule) :: Service
		table.insert(self.services, service)
	end
	self._loaded = true
end
Services.load = Functions.callOnce(Functions.strictMutex(Services.load))

--[[
	Initializes each of the services, and begins the player life cycle.
]]
function Services.init(self: Services)
	assert(self._loaded, "Must load services before calling init")
	self:callEachService("init", self)

	-- Player lifecycle
	Players.PlayerAdded:Connect(function(player: Player)
		self:_onPlayerAdded(player)
	end)
	Players.PlayerRemoving:Connect(function(player: Player)
		self:_onPlayerRemoving(player)
	end)
	for _, player: Player in Players:GetPlayers() do
		task.spawn(self._onPlayerAdded, self, player)
	end
end

--[[
	For each service, calls the method of the given name using task.spawn, if it exists.
	Return values are discarded.
]]
function Services.callEachService<T...>(self: Services, fnName: string, ...: T...)
	for _, service: Service in self.services do
		local fn = service[fnName] :: (Service, T...) -> ()?
		if fn then
			task.spawn(fn, service, ...)
		end
	end
end

function Services._onPlayerAdded(self: Services, player: Player)
	self:callEachService("onPlayerAdded", player)
end

function Services._onPlayerRemoving(self: Services, player: Player)
	self:callEachService("onPlayerRemoving", player)
end

return Services :: Services
