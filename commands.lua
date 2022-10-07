local addon_name, chatter = ...
SLASH_CHATTER1 = "/chatter"
SlashCmdList.CHATTER = function(msg, _)
	local args = {strsplit(" ", msg)}

	local cmd = args[1]
	if(#cmd == 0) then
		print("Chatterbox by Harrand")
	else
		if(cmd == "quotes") then
			chatter.list_quotes()
		else
			print("Unknown subcmd " .. args[1])
		end
	end
end
