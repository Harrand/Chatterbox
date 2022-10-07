local addon_name, chatter = ...

chatter.Command = {description = "", subcmd = "", aliases = {}, func = nil}
function chatter.Command:new(o)
	o = o or {}
	setmetatable(o, self)
	self.__index = self
	return o
end
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

--------------------------------------------------------------------------------
-- /chatter help
chatter.Commands["help"] = chatter.Command:new()

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

-- /chatter quotes
chatter.Commands["quotes"] = chatter.Command:new()
chatter.Commands["quotes"].description = "Display all available quotes"
chatter.Commands["quotes"].subcmd = "quotes"
chatter.Commands["quotes"].func = function(args)
	print("TODO: Implement quotes ;)")
end

-- / chatter quote
chatter.Commands["quote"] = chatter.Command:new()
chatter.Commands["quote"].description = "/say a quote!"
chatter.Commands["quote"].subcmd = "quote"
chatter.Commands["quote"].func = function(args)
	local quote_name = args[1]
	print("<PLACEHOLDER QUOTE \"" .. quote_name .. "\">")
end
--------------------------------------------------------------------------------

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
