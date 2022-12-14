local addon_name, chatter = ...

chatter_global_save = {}

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
	table.sort(i, function(a, b) return a > b end)
	return function()
		local k = table.remove(i)
		if k ~= nil then
			return k, t[k]
		end
	end
end

function chatter.Quote:say()
	local timestamps = {}
	local strings = {}
	local i = 1
	for timestamp, str in sorted_iter(self.elements) do
		timestamps[i] = timestamp
		strings[i] = str
		i = i + 1 
	end
	if i == 1 then
		print("Quote \"" .. self.name .. "\" had no lines, nothing to say!")
		return
	end
	function send_payload(x)
		if chatter.current_chat_type == chatter.chat_type["/0"] then
			print("Debug: " .. strings[x])
		else
			SendChatMessage(strings[x], chatter.current_chat_type, nil, chatter.current_chat_extra)
		end
	end
	function do_delay(x, elapsed)
		chatter.util.delay(timestamps[x] - elapsed, function() send_payload(x); if x < i-1 then do_delay(x+1, timestamps[x] + elapsed) end end)
	end
	function do_delay_start()
		do_delay(1, 0)
	end
	chatter.util.delay(0, do_delay_start)
end
