local addon_name, chatter = ...

chatter.loaded = false
chatter.vars_loaded = false

function first_time_load()
	print("Doing first-time tasks for Chatterbox...")
	chatter_saved = {}
	chatter_saved.quotes = {}
	print("Done")
end


local frame = CreateFrame("FRAME")
frame:RegisterEvent("ADDON_LOADED")

function frame:on_event(event, arg)
	if event == "ADDON_LOADED" and arg == "Chatterbox" then
		chatter.loaded = true
		if(chatter_saved == nil) then
			first_time_load()
		end
	end
end

frame:SetScript("OnEvent", frame.on_event)

chatter.list_quotes = function()
	if chatter.loaded then
		print(#chatter_saved.quotes .. " quotes")
		for k, v in pairs(chatter_saved.quotes) do
			print(k .. ": ")
		end
	else
		print("Chatterbox not loaded yet...")
	end
end

chatter.begin_quote = function(name)
	if chatter.quotes.edit_mode then
		print("Warning: You were already editing a quote. Discarding...")
	end
	print("Entering edit mode for a new quote \"" .. name .. "\"")
	chatter.quotes.edit_mode = true
	chatter.quotes.editor = Quote
	chatter.quotes.editor.name = name
end

chatter.finish_quote = function()
	if chatter.quotes.edit_mode == false then
		print("Error: Cannot finish quote because you weren't editing one")
	end
	chatter.quotes.edit_mode = false
	print("Editing on quote \"" .. chatter.quotes.editor.name .. "\" complete!")
	table.insert(chatter_saved.quotes, chatter.quotes.editor)

	print("Test of new quote:")
	chatter.quotes.editor:test()

	chatter.quotes.editor = nil
end
