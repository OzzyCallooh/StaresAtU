--!strict

type Spawn = CFrame | (player: Player) -> CFrame | nil

--[[
	
]]
local PlayerSpawnService = {}
PlayerSpawnService._spawns = {} :: { [Player]: Spawn }

function PlayerSpawnService.init(self: PlayerSpawnService) end

local function evaluateSpawn(spawn: Spawn, player: Player): CFrame?
	if typeof(spawn) == "CFrame" then
		return spawn
	elseif typeof(spawn) == "function" then
		return spawn(player)
	else
		return nil
	end
end

function PlayerSpawnService.setPlayerSpawn(self: PlayerSpawnService, player: Player, spawn: Spawn)
	assert(player.Parent, "Player is not in the game")
	if self._spawns[player] and spawn then
		warn("Player spawn overwrote", player)
	end
	print("Setting player spawn", player, spawn)
	self._spawns[player] = spawn
end

function PlayerSpawnService.onPlayerAdded(self: PlayerSpawnService, player: Player)
	player.CharacterAdded:Connect(function(character: Model)
		character:WaitForChild("HumanoidRootPart")
		local humanoid: Humanoid = character:WaitForChild("Humanoid") :: Humanoid
		local spawnCFrame: CFrame? = evaluateSpawn(self._spawns[player], player)
		if spawnCFrame then
			print("Spawning player at specific spawn", spawnCFrame)
			character:PivotTo(spawnCFrame * CFrame.new(0, humanoid.HipHeight, 0))
		end
	end)
end

function PlayerSpawnService.onPlayerRemoving(self: PlayerSpawnService, player: Player)
	self._spawns[player] = nil
end

export type PlayerSpawnService = typeof(PlayerSpawnService)

return PlayerSpawnService
