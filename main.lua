local addon_name, chatter = ...

local frame = CreateFrame("FRAME")
frame:RegisterEvent("ADDON_LOADED")
frame:RegisterEvent("VARIABLES_LOADED")

function chatterbox_init(event, arg)
	if event == "ADDON_LOADED"  then
		print("Chatterbox Loaded for " .. arg)
	end
	if event == "VARIABLES_LOADED" then
		print("Chatterbox Vars Loaded for " .. arg)	
	end
end

frame:SetScript("OnEvent", chatterbox_init)
