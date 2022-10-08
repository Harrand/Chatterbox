local addon_name, chatter = ...

-- QuoteBuilder if we're in quote edit mode
chatter.edit = nil

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

function chatter.QuoteBuilder:build()
	q = chatter.Quote
	return q
end
