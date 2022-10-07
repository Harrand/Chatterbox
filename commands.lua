local addon_name, chatter = ...
SLASH_CHATTER1 = "/chatter"
SlashCmdList.CHATTER = function(msg, _)
	local args = {strsplit(" ", msg)}

	local cmd = args[1]
	if(#cmd == 0) then
		print("Chatterbox by Harrand")
	else
		if cmd == "quotes" then

		elseif cmd == "new" then

		elseif cmd == "finish" then

		elseif cmd == "clear" then

		elseif cmd == "quote" then

		elseif cmd == "line" then

		elseif cmd == "test" then
			print("Marco!")
			chatter.util.delay(1000.0, function() print("...") chatter.util.delay(4000.0, function() print("Polo!") end) end)
		else
			print("Unknown subcmd " .. args[1])
		end
	end
end
