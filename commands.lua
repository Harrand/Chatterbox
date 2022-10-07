local addon_name, chatter = ...

chatter.Command = {description = "", subcmd = "", aliases = {}, func = nil}
function chatter.Command:help()
	print(chatter.util.colour("00FFFF") .. "/chatter " .. self.subcmd .. chatter.util.colour() .. " - " .. self.description)
end

-- Write all supported commands
chatter.Commands = {}

-- Firstly is the 'help' meta-command
chatter.print_help = function()
	print("==== " .. chatter.util.colour("FFFF00") .. "Chatterbox" .. chatter.util.colour() .. " Help" .. " ====")
	for name, command in pairs(chatter.Commands) do
		command:help()
	end
	print("======================")
end

chatter.Commands["help"] = chatter.Command

-- /chatter help
chatter.Commands["help"].description = "Displays help about all commands, or pass in a command name to view information about a specific command"
chatter.Commands["help"].subcmd = "help"
chatter.Commands["help"].func = function(args)
	if args == nil or #args == 0 then
		chatter.print_help()
	else
		local subcmd = args[1]
		chatter.Commands[subcmd]:help()
	end
end

-- Implementation specific, WoW command hookup.

SLASH_CHATTER1 = "/chatter"
SlashCmdList.CHATTER = function(msg, _)
	local args = {strsplit(" ", msg)}

	local cmd = args[1]
	if(#cmd == 0) then
		chatter.print_help()
	else
		for name, command in pairs(chatter.Commands) do
			if cmd == command.subcmd then
				command.func({select(2, unpack(args))})
				return
			end
		end
		print("Unknown subcmd " .. cmd .. ". Type " .. chatter.util.colour("00FFFF") .. "/chatter help" .. chatter.util.colour() .. " for help")
	end
end
