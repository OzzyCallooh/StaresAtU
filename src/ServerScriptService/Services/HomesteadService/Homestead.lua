--!strict

local Types = require(script.Parent.Types)
local Plot = require(script.Parent.Plot)

export type Homestead = Types.Homestead

local Homestead = {}
Homestead.__index = Homestead
Homestead.ATTR_PLOT_NAME = "PlotName"

Homestead._container = workspace.Homesteads

function Homestead.new(plot: Plot.Plot, prefab: Model, owner: Player)
	assert(not plot:IsOccupied(), "Plot already occupied")
	local self = {}
	self.Plot = plot
	self.Instance = prefab:Clone()
	self.Instance:SetAttribute(Homestead.ATTR_PLOT_NAME, plot:GetName())
	self.Instance.Parent = Homestead._container
	self.Instance:PivotTo(self.Plot:GetCFrame())
	self.Plot:SetHomestead(self)
	self.Owner = owner
	return setmetatable(self, Homestead)
end

function Homestead:Destroy()
	self.Instance:Destroy()
	if self.Plot:GetHomestead() == self then
		self.Plot:SetHomestead(nil)
	end
end

return Homestead
