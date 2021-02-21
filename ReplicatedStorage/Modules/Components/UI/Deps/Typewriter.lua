local SOURCE_LOCALE = "en"

local LocalizationService = game:GetService("LocalizationService")
local Players = game:GetService("Players")

local player = Players.LocalPlayer

local translator = nil
pcall(function()
	translator = LocalizationService:GetTranslatorForPlayerAsync(player)
end)
if not translator then
	pcall(function()
		translator = LocalizationService:GetTranslatorForLocaleAsync(SOURCE_LOCALE)
	end)
end

local TypeWriter = {}

local defaultConfigurations = {
	delayTime = 0.01,
	extraDelayOnSpace = true
}

function TypeWriter.configure(configurations)
	for key, value in pairs(defaultConfigurations) do
		local newValue = configurations[key]
		if newValue ~= nil then
			defaultConfigurations[key] = newValue
		else
			warn(key .. " is not a valid configuration for TypeWriter module")
		end
	end
end

function TypeWriter.typeWrite(guiObject, text)
	guiObject.AutoLocalize = false
	guiObject.Text = ""
	local displayText = text
	if translator then
		displayText = translator:Translate(guiObject, text)
	end
	for first, last in utf8.graphemes(displayText) do
		local grapheme = string.sub(displayText, first, last)
		guiObject.Text = guiObject.Text .. grapheme
		if defaultConfigurations.extraDelayOnSpace and grapheme == " " then
			wait(defaultConfigurations.delayTime)
		end
		wait(defaultConfigurations.delayTime)
	end
end

return TypeWriter
