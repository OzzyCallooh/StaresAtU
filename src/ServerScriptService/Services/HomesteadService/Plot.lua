--!strict

local Types = require(script.Parent.Types)

export type PlotName = Types.PlotName
export type Plot = Types.Plot

local Plot = {}
Plot.__index = Plot

function Plot.loadAll(plotModelContainer: Instance): { [PlotName]: Plot }
	local plots: { [PlotName]: Plot } = {}
	for _, plotModel: Instance in plotModelContainer:GetChildren() do
		assert(plotModel:IsA("Model"), "Model expected")
		local plot: Plot = Plot.new(plotModel)
		local plotName: PlotName = plot:GetName()
		plots[plotName] = plot
	end
	return plots
end

function Plot.new(model: Model)
	local self = {}
	self.Model = model
	self.Homestead = nil
	return setmetatable(self, Plot)
end

function Plot:GetName(): string
	return self.Model.Name
end

function Plot:GetCFrame(): CFrame
	return self.Model:GetPivot()
end

function Plot:SetHomestead(homestead: Types.Homestead?)
	self.Homestead = homestead
end

function Plot:GetHomestead(): Types.Homestead?
	return self.Homestead
end

function Plot:IsOccupied(): boolean
	return self.Homestead ~= nil
end

return Plot
