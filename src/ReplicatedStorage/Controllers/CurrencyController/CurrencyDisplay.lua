local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Component = require(ReplicatedStorage.Packages.Component)

local TroveExtension = require(ReplicatedStorage.Utilities.Extensions.Trove)

local Attributes = require(ReplicatedStorage.Utilities.Attributes)

local CurrencyController = require(ReplicatedStorage.Controllers.CurrencyController)

local CurrencyDisplay = Component.new({
	Tag = "CurrencyDisplay",
	Extensions = {
		TroveExtension,
	},
})

CurrencyDisplay.Attributes = Attributes.wrapComponentClass(CurrencyDisplay)
CurrencyDisplay.Attributes[{ get = "GetCurrencyName", set = "SetCurrencyName" }] = "CurrencyName"
CurrencyDisplay.Attributes[{ get = "GetFormat", set = "SetFormat" }] = "Format"

function CurrencyDisplay:GetCurrency()
	local currencyValue = CurrencyController:getCurrency(self:GetCurrencyName())
	return currencyValue
end

function CurrencyDisplay:Update()
	local format = self:GetFormat() or "%d"
	local currencyValue = self:GetCurrency()
	self.Instance.Text = format:format(currencyValue)
end

function CurrencyDisplay:Start()
	print("CurrencyDisplay started", self.Instance:GetFullName())
	local currencyName = self:GetCurrencyName()
	self.Trove:Add(CurrencyController:observeCurrency(currencyName, function(_newCurrency)
		self:Update()
	end))
end

return CurrencyDisplay
