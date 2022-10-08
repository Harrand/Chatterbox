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
	-- protect against no quotes existing
	if chatter_global_save.quotes == nil then
		chatter_global_save.quotes = {}
	end
	for i, q in pairs(chatter_global_save.quotes) do
		local quote = chatter.Quote:new(q)
		print("Quote " .. i .. ": \"" .. quote.name .. "\" (" .. quote:length() .. " lines)")
	end
end

-- / chatter quote
chatter.Commands["quote"] = chatter.Command:new()
chatter.Commands["quote"].description = "/say a quote!"
chatter.Commands["quote"].subcmd = "quote"
chatter.Commands["quote"].func = function(args)
	local quote_name = args[1]
	for i, q in pairs(chatter_global_save.quotes) do
		if q.name == quote_name then
			local quote = chatter.Quote:new(q)
			quote:say()
			return
		end
	end
	print("Error: No such quote exists with the name \"" .. quote_name .. "\"")
end

-- / chatter addquote
chatter.Commands["addquote"] = chatter.Command:new()
chatter.Commands["addquote"].description = "create a new quote"
chatter.Commands["addquote"].subcmd = "addquote"
chatter.Commands["addquote"].func = function(args)
	-- if we're adding the first quote, this will be nil
	if chatter_global_save.quotes == nil then
		chatter_global_save.quotes = {}
	end
	local quote_name = args[1]
	table.insert(chatter_global_save.quotes, {name = quote_name, elements = {}})
	print("Added new empty quote \"" .. quote_name .. "\"")
end

-- / chatter delquote
chatter.Commands["delquote"] = chatter.Command:new()
chatter.Commands["delquote"].description = "delete an existing quote"
chatter.Commands["delquote"].subcmd = "delquote"
chatter.Commands["delquote"].func = function(args)
	-- if we're adding the first quote, this will be nil
	if chatter_global_save.quotes == nil then
		chatter_global_save.quotes = {}
		return
	end
	local quote_name = args[1]
	local id = nil
	for i, q in pairs(chatter_global_save.quotes) do
		if q.name == quote_name then
			id = i
		end
	end
	if id == nil then
		print("Error: No such quote by the name of \"" .. quote_name .. "\". Nothing happened")
	else
		table.remove(chatter_global_save.quotes, id)
		print("Deleted quote \"" .. quote_name .. "\"")
	end
end

-- / chatter edit
chatter.Commands["edit"] = chatter.Command:new()
chatter.Commands["edit"].description = "begin editing an existing quote"
chatter.Commands["edit"].subcmd = "edit"
chatter.Commands["edit"].func = function(args)
	local quote_name = args[1]
	if chatter_global_save.quotes == nil then
		print("You have no quotes. Create a quote with " .. chatter.util.colour("00FFFFF") .. "/chatter addquote" .. chatter.util.colour() .. " first.")
		return
	end

	for i, q in pairs(chatter_global_save.quotes) do
		if q.name == quote_name then
			local quote = chatter.Quote:new(q)
				chatter.quotes.begin_edit(chatter.QuoteBuilder:edit(quote))
			return
		end
	end
end

-- / chatter line
chatter.Commands["line"] = chatter.Command:new()
chatter.Commands["line"].description = "set the line at the given timestamp"
chatter.Commands["line"].subcmd = "line"
chatter.Commands["line"].func = function(args)
	local timestamp = tonumber(args[1])
	local message = ""
	for i = 2, #args do
		message = message .. args[i] .. " "	
	end
	e = chatter.QuoteBuilderEntry:new()
	e.timestamp = timestamp
	e.message = message
	table.insert(chatter.quotes.edit.entries, e)
	print("Set message of \"" .. e.message .. "\" at timestamp " .. e.timestamp)
end

-- / chatter finish
chatter.Commands["finish"] = chatter.Command:new()
chatter.Commands["finish"].description = "finish edit of an existing quote, and save changes"
chatter.Commands["finish"].subcmd = "finish"
chatter.Commands["finish"].func = function(args)
	if chatter_global_save.quotes == nil then
		print("You have no quotes. Create a quote with " .. chatter.util.colour("00FFFFF") .. "/chatter addquote" .. chatter.util.colour() .. " first.")
		return
	end

	result = chatter.quotes.finish_edit()
	local quote_name = result.name
	for i, q in pairs(chatter_global_save.quotes) do
		if q.name == quote_name then
			table.remove(chatter_global_save.quotes, i)
			table.insert(chatter_global_save.quotes, {name = result.name, elements = result.elements})
			print("Finalised edit of \"" .. quote_name .. "\" (now with " .. result:length() .. " lines)")
			return
		end
	end
end

-- / chatter clearquotes
chatter.Commands["clearquotes"] = chatter.Command:new()
chatter.Commands["clearquotes"].description = "permanently delete all quotes"
chatter.Commands["clearquotes"].subcmd = "clearquotes"
chatter.Commands["clearquotes"].func = function(args)
	chatter_global_save.quotes = {}
	print("Deleted all quotes.")
end

-- / chatter channel
chatter.Commands["channel"] = chatter.Command:new()
chatter.Commands["channel"].description = "Set which chat channel quotes are sent to"
chatter.Commands["channel"].subcmd = "channel"
chatter.Commands["channel"].func = function(args)
	local chat_type = args[1]
	if chat_type == nil then
		local extras = ""
		if chatter.current_chat_type == chatter.chat_type["/w"] or chatter.current_chat_type == chatter.chat_type["/x"] then
			extras = " (" .. chatter.current_chat_extra .. ")"
		end
		print("Current channel: " .. chatter.current_chat_type .. extras)
	else
		local t = chatter.chat_type[chat_type]
		if t == nil then
			print("Error: Unrecognised chat channel \"" .. chat_type .. "\"")
		end
		chatter.current_chat_type = t
	end
	local chat_extra = args[2]
	if chat_extra ~= nil then
		chatter.current_chat_extra = chat_extra
	end
end

-- / chatter testquote
chatter.Commands["testquote"] = chatter.Command:new()
chatter.Commands["testquote"].description = "/say a test quote!"
chatter.Commands["testquote"].subcmd = "testquote"
chatter.Commands["testquote"].func = function(args)
	local q = chatter.Quote:new()
	q.name = "Test Quote"
	q.elements[0] = "harrybo was"
	q.elements[700] = "DEAD!!!"
	q.elements[2500] = "and everything was lovely once again. wonderful."
	q.elements[5500] = "and then we went home"
	q:say()
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
