local addon_name, chatter = ...
SLASH_CHATTER1 = "/chatter"
SlashCmdList.CHATTER = function(msg, _)
	local args = {strsplit(" ", msg)}

	local cmd = args[1]
	if(#cmd == 0) then
		print("Chatterbox by Harrand")
	else
		if cmd == "quotes" then
			chatter.list_quotes()
		elseif cmd == "new" then
			local quote_name = args[2]
			if quote_name == nil then
				quote_name = "Untitled"
			end
			chatter.begin_quote(quote_name)
		elseif cmd == "finish" then
			chatter.finish_quote()
		elseif cmd == "clear" then
			chatter_saved.quotes = {}
			print("Cleared all quotes.")
		elseif cmd == "say" then
			local quote_name = args[2]
			if quote_name == nil then
				print("Need to specify a quote name")
				return
			end
			local quote = Quote
			quote = get_quote(quote_name)
			if quote ~= nil then
				quote:test()
			else
				print("Unknown quote \"" .. quote_name .. "\"")
			end
		elseif cmd == "line" then
			if chatter.quotes.edit_mode == false then
				print("Can't add a line because no quote is being edited")
				return
			end
			local timestamp = tonumber(args[2])
			local line = ""
			for i = 3, #args do
				line = line .. args[i] .. " "
			end
			local q = QuoteElement
			q.timestamp = timestamp
			q.str = line
			print("adding new line at timestamp " .. q.timestamp .. " with message " .. q.str)
			chatter.quotes.editor:add(q)
			print("test so far: ")
			chatter.quotes.editor:test()
		else
			print("Unknown subcmd " .. args[1])
		end
	end
end
