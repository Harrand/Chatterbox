local addon_name, chatter = ...
chatter.quotes = {}
-- QuoteBuilder if we're in quote edit mode
chatter.quotes.edit = nil

chatter.QuoteBuilderEntry = {timestamp = 0, message = ""}
function chatter.QuoteBuilderEntry:new(o)
	o = o or {}
	setmetatable(o, self)
	self.__index = self
	return o
end
chatter.QuoteBuilder = {name = "", entries = {}}
function chatter.QuoteBuilder:new(o, name)
	o = o or {}
	setmetatable(o, self)
	self.__index = self
	self.name = name
	return o
end

function chatter.QuoteBuilder:edit(quote)
	-- we have an existing quote. make a builder from it.
	ret = chatter.QuoteBuilder:new()
	self.name = quote.name
	for timestamp, str in pairs(quote.elements) do
		entry = chatter.QuoteBuilderEntry:new()
		entry.timestamp = timestamp
		entry.message = quote.str
		table.insert(ret.entries, entry)
	end
	return ret
end

function chatter.QuoteBuilder:build()
	ret = chatter.Quote:new()
	ret.name = self.name
	for i, entry in ipairs(self.entries) do
		ret.elements[entry.timestamp] = entry.message
	end
	return ret
end

function chatter.quotes.begin_edit(builder)
	if chatter.quotes.edit ~= nil then
		print("Error: Already editing a quote")
		return
	end
	chatter.quotes.edit = builder
	print("Now editing \"" .. builder.name .. "\"")
end

function chatter.quotes.cancel_edit()
	print("Cancelled edit of quote \"" .. chatter.quotes.edit.name .. "\". All unsubmitted edits are now lost.")
	chatter.quotes.edit = nil
end

function chatter.quotes.finish_edit()
	local result = chatter.quotes.edit:build()
	chatter.quotes.edit = nil
	return result
end
