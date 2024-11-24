local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Attributes = require(ReplicatedStorage.Utilities.Attributes)

local CurrencyController = require(ReplicatedStorage.Controllers.CurrencyController)

local Component = require(ReplicatedStorage.Packages.Component)

local CurrencyDisplay = Component.new({
	Tag = "CurrencyDisplay",
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
	CurrencyController:observeCurrency(currencyName, function(_newCurrency)
		self:Update()
	end)
end

return CurrencyDisplay
