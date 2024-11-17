--!strict
local CollectionService = game:GetService("CollectionService")

local Tags = {}

function Tags.await(self: Tags, tag: string, parent: Instance?): Instance
	local result
	local start = tick()
	local warned = false
	repeat
		local tagged = CollectionService:GetTagged(tag)
		for _index, object in tagged do
			local checkRequired = not not parent
			if (not checkRequired) or (object:IsDescendantOf(parent)) then
				result = object
				break
			end
		end
		if not result then
			task.wait()
			if not warned and tick() - start > 5 then
				warned = true
				warn(`still waiting for {tag} in {parent or "anything"}`)
			end
		end
	until result
	return result
end

function Tags.onTaggedWithin(self: Tags, tag: string, ancestor: Instance, callback: (Instance) -> ())
	local tagged = CollectionService:GetTagged(tag)
	for _index, instance in tagged do
		if instance:IsDescendantOf(ancestor) then
			callback(instance)
		end
	end
end

type Tags = typeof(Tags)

return Tags