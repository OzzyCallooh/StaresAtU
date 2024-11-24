local ReplicatedStorage = game:GetService("ReplicatedStorage")

local CurrencyController = require(ReplicatedStorage.Controllers.CurrencyController)

local Component = require(ReplicatedStorage.Packages.Component)

local CurrencyDisplay = Component.new({
	Tag = "CurrencyDisplay",
})
CurrencyDisplay.ATTR_CURRENCY_NAME = "CurrencyName"
CurrencyDisplay.ATTR_FORMAT = "Format"

function CurrencyDisplay:GetCurrencyName()
	return self.Instance:GetAttribute(CurrencyDisplay.ATTR_CURRENCY_NAME) :: string
end

function CurrencyDisplay:GetFormat()
	return self.Instance:GetAttribute(CurrencyDisplay.ATTR_FORMAT) :: string
end

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
