local addon_name, chatter = ...

chatter.Quote = {name = "", elements = {}}
function chatter.Quote:new(o)
	o = o or {}
	setmetatable(o, self)
	self.__index = self
	return o
end

function chatter.Quote:length()
	local len = 0
	for _, _ in pairs(self.elements) do
		len = len + 1
	end
	return len
end

-- sorted iteration impl
local function sorted_iter(t)
	local i = {}
	for k in next, t do
		table.insert(i, k)
	end
	table.sort(i)
	return function()
		local k = table.remove(i)
		if k ~= nil then
			return k, t[k]
		end
	end
end

function chatter.Quote:say()
	for timestamp, str in sorted_iter(self.elements) do
		print("NYI, info:")
		print("timestamp = " .. timestamp)
		print("str = " .. str)
	end
end
