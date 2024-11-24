local ReplicatedStorage = game:GetService("ReplicatedStorage")

local CurrencyController = require(ReplicatedStorage.Controllers.CurrencyController)

local Component = require(ReplicatedStorage.Packages.Component)

local CurrencyDisplay = Component.new({
	Tag = "CurrencyDisplay",
})
CurrencyDisplay.ATTR_CURRENCY_NAME = "CurrencyName"

function CurrencyDisplay:GetCurrencyName()
	return self.Instance:GetAttribute(CurrencyDisplay.ATTR_CURRENCY_NAME) :: string
end

function CurrencyDisplay:Start()
	print("CurrencyDisplay started", self.Instance:GetFullName())
	local currencyName = self:GetCurrencyName()
	CurrencyController:observeCurrency(currencyName, function(newCurrency)
		print("CurrencyDisplay", currencyName, newCurrency)
		self.Instance.Text = tostring(newCurrency)
	end)
end

return CurrencyDisplay
