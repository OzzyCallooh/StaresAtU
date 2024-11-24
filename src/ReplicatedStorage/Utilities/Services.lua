--!strict
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local Signal = require(ReplicatedStorage.Packages.Signal)
type Signal = typeof(Signal.new())

local Functions = require(ReplicatedStorage.Utilities.Functions)

export type Service = {
	init: (Service) -> (),
}

export type Services = {
	-- Properties
	serviceModules: { ModuleScript },
	services: { [string]: Service },
	_loaded: boolean,
	_aliases: { [string]: Signal },

	-- Methods
	load: (self: Services) -> (),
	getService: (self: Services, string) -> Service,
	getController: (self: Services, string) -> Service,
	init: (self: Services) -> (),
	callEachService: <T...>(self: Services, fnName: string, T...) -> (),
	addAliasForSignal: (self: Services, string, Signal) -> (),
}

local Services = {}
Services.serviceModules = {} :: { ModuleScript }
Services.services = {} :: { [string]: Service }
Services._loaded = false

--[[
	Requires each of the service modules.
]]
function Services.load(self: Services)
	for _, serviceModule: ModuleScript in self.serviceModules do
		assert(
			not self.services[serviceModule.Name],
			("Duplicate service module: %s "):format(serviceModule:GetFullName())
		)
		local service = require(serviceModule) :: Service
		self.services[serviceModule.Name] = service
	end
	self._loaded = true
end
Services.load = Functions.callOnce(Functions.strictMutex(Services.load))

--[[
	Returns a service of a particular name
]]
function Services.getService(self: Services, name: string): Service
	return assert(self.services[name], ("No such service: %s"):format(name))
end
-- Alias
Services.getController = Services.getService

--[[
	Initializes each of the services, and begins the player life cycle.
]]
function Services.init(self: Services)
	assert(self._loaded, "Must load services before calling init")
	self:callEachService("init", self)

	-- Connect each signal aliases to call the respective functions in each service
	for alias: string, signal: Signal in self._aliases do
		signal:Connect(function(...)
			self:callEachService(alias, ...)
		end)
	end

	-- Call player added for existing players
	for _, player: Player in Players:GetPlayers() do
		self:callEachService("onPlayerAdded", player)
	end
end

--[[
	For each service, calls the method of the given name using task.spawn, if it exists.
	Return values are discarded.
]]
function Services.callEachService<T...>(self: Services, fnName: string, ...: T...)
	for _serviceName: string, service: Service in self.services do
		local fn = service[fnName] :: (Service, T...) -> ()?
		if fn then
			fn(service, ...)
		end
	end
end

Services._aliases = {} :: { [string]: Signal }
function Services.addAliasForSignal(self: Services, alias: string, signal)
	assert(not self._loaded, "Cannot add signal aliases after services are loaded")
	assert(not self._aliases[alias], ("Duplicate signal alias: %s"):format(alias))
	assert(typeof(signal.Connect) == "function", "Signal must have Connect method")
	assert(typeof(alias) == "string", "Alias must be a string")
	self._aliases[alias] = signal
end
Services:addAliasForSignal("onPlayerAdded", Players.PlayerAdded)
Services:addAliasForSignal("onPlayerRemoving", Players.PlayerRemoving)

return Services :: Services
