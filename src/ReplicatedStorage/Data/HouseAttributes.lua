--!strict
export type HouseAttribute = {
	DisplayName: string,
	Values: { any }?,
	Range: {
		Min: number,
		Max: number,
	}?,
}

local HouseAttributes: { [string]: HouseAttribute } = {
	ExteriorPaintColor = {
		Values = {
			Color3.fromRGB(224, 178, 208),
			Color3.fromRGB(148, 190, 129),
		},
		DisplayName = "Paint Color",
	},
	GrassHeight = {
		Range = {
			Min = 1,
			Max = 2,
		},
		DisplayName = "Grass Height",
	},
}

return HouseAttributes
