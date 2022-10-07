local addon_name, chatter = ...

chatter.loaded = false
chatter.vars_loaded = false

local frame = CreateFrame("FRAME")
frame:RegisterEvent("ADDON_LOADED")
frame:RegisterEvent("VARIABLES_LOADED")

function first_time_load()
	print("Doing first-time tasks for Chatterbox...")
	chatter.saved = {}
	chatter.saved.quotes = {}
	print("Done")
end

function frame:on_event(event, arg)
	if event == "ADDON_LOADED" and arg == "Chatterbox" then
		chatter.loaded = true
		if(chatter.saved == nil) then
			first_time_load()
		end
	end
end

frame:SetScript("OnEvent", frame.on_event)

chatter.list_quotes = function()
	if chatter.loaded then
		print(#chatter.saved.quotes .. " quotes")
		for k, v in pairs(chatter.saved.quotes) do
			print(k .. ": ")
		end
	else
		print("Chatterbox not loaded yet...")
	end
end
